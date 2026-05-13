# Per-strain reanalysis of Alonso-del Valle 2021 — 50 enterobacterial strains
# carrying or lacking the carbapenemase plasmid pOXA-48.
#
# Strategy:
#   - For each strain S, load WT and TC (transconjugant) OD trajectories.
#   - Fit BayesBiont NL_logistic on each (independent, default curated priors).
#   - Compute the posterior of the log-ratio of growth rates: log(r_TC / r_WT).
#     log-ratio > 0 ⇒ plasmid carriage makes the strain fitter.
#   - Save per-strain summary and aggregate fitness distribution.
#
# Paper's central claim: a tail of strains with log-ratio > 0 ("beneficial plasmid
# carriers") explains why pOXA-48 persists in clinical bacterial populations.
# Under our reanalysis, do we see the same tail?

using Pkg; Pkg.activate(joinpath(@__DIR__, "..", ".."))
using BayesBiont, Kinbiont, Statistics, Random, Printf, CSV, DataFrames

const S02_DIR  = joinpath(@__DIR__, "..", "..", "pilot", "S02_alonso_del_valle_2021")
const S02_RAW  = joinpath(S02_DIR, "raw", "ODdata_strains")

"""Load one (strain, condition) CSV and return (times, OD)."""
function load_curve(strain::String, condition::String)
    path = joinpath(S02_RAW, "ODdata_$(strain)_$(condition).csv")
    df = CSV.read(path, DataFrame)
    return Float64.(df.t), Float64.(df.OD600)
end

"""List all distinct strain IDs present as WT/TC pairs."""
function list_strains()
    files = readdir(S02_RAW)
    strains = unique(map(f -> split(f, '_')[2], filter(f -> endswith(f, ".csv"), files)))
    # Keep only strains that have both WT and TC files
    keep = String[]
    for s in strains
        if isfile(joinpath(S02_RAW, "ODdata_$(s)_WT.csv")) &&
           isfile(joinpath(S02_RAW, "ODdata_$(s)_TC.csv"))
            push!(keep, s)
        end
    end
    return sort(keep)
end

"""Fit one curve with BayesBiont logistic; return the growth-rate posterior samples."""
function fit_one_curve(times, y; seed::Int=42, n_warmup=300, n_samples=300)
    # Drop any non-positive readings (rare; happens near t=0 with blank subtraction)
    valid = y .> 0
    if count(valid) < 6
        return nothing
    end
    data = GrowthData(reshape(y[valid], 1, :), times[valid], ["c"])
    spec = BayesianModelSpec([MODEL_REGISTRY["NL_logistic"]])
    opts = BayesFitOptions(n_chains=1, n_warmup=n_warmup, n_samples=n_samples,
                           target_accept=0.95, rng_seed=seed)
    r    = bayesfit(data, spec, opts)[1]
    return (r_samples=r.lag, K_samples=r.N_max, N0_samples=r.growth_rate, σ_mean=mean(r.σ))
end

function fit_strain(strain::String; seed_offset::Int=0, kwargs...)
    t_wt, y_wt = load_curve(strain, "WT")
    t_tc, y_tc = load_curve(strain, "TC")
    f_wt = fit_one_curve(t_wt, y_wt; seed=42 + seed_offset, kwargs...)
    f_tc = fit_one_curve(t_tc, y_tc; seed=43 + seed_offset, kwargs...)
    (f_wt === nothing || f_tc === nothing) && return nothing
    # Match posterior draw indices (samples are independent draws, paired arbitrarily — OK for log-ratio)
    n = min(length(f_wt.r_samples), length(f_tc.r_samples))
    log_ratio = log.(f_tc.r_samples[1:n]) .- log.(f_wt.r_samples[1:n])
    return (
        strain    = strain,
        r_wt_mean = mean(f_wt.r_samples),
        r_wt_lo   = quantile(f_wt.r_samples, 0.025),
        r_wt_hi   = quantile(f_wt.r_samples, 0.975),
        r_tc_mean = mean(f_tc.r_samples),
        r_tc_lo   = quantile(f_tc.r_samples, 0.025),
        r_tc_hi   = quantile(f_tc.r_samples, 0.975),
        log_ratio_mean = mean(log_ratio),
        log_ratio_lo   = quantile(log_ratio, 0.025),
        log_ratio_hi   = quantile(log_ratio, 0.975),
        p_beneficial   = mean(log_ratio .> 0),
    )
end

function run_all(; verbose::Bool=true)
    strains = list_strains()
    println("Fitting $(length(strains)) strains (WT + TC each → 2 fits per strain)…")
    results = NamedTuple[]
    failed  = String[]
    t0 = time()
    for (k, s) in enumerate(strains)
        r = try
            fit_strain(s; seed_offset=k)
        catch e
            println("  $s: ERROR — $e")
            nothing
        end
        if r === nothing
            push!(failed, s)
            continue
        end
        push!(results, r)
        if verbose && (k <= 5 || k == length(strains) || k % 10 == 0)
            @printf("  [%3d/%d] %-6s  log_ratio=%+.3f [%+.3f, %+.3f]  P(beneficial)=%.2f  elapsed=%.0fs\n",
                    k, length(strains), s, r.log_ratio_mean, r.log_ratio_lo, r.log_ratio_hi,
                    r.p_beneficial, time() - t0)
        end
    end
    println("\nDone. Fit $(length(results))/$(length(strains)) strains in $(round(time() - t0; digits=1))s")
    if !isempty(failed)
        println("Failed: $(join(failed, ", "))")
    end
    return results
end

if abspath(PROGRAM_FILE) == @__FILE__
    rows = run_all()
    # Aggregate stats
    log_ratios = [r.log_ratio_mean for r in rows]
    p_benef    = [r.p_beneficial for r in rows]
    n_clear_pos = count(>(0.95), p_benef)
    n_clear_neg = count(<(0.05), p_benef)
    n_neutral   = length(rows) - n_clear_pos - n_clear_neg

    println("\n=== Aggregate fitness distribution ===")
    @printf("  N strains fit                  : %d\n", length(rows))
    @printf("  Mean log-ratio (log(r_TC/r_WT)): %+.3f\n", mean(log_ratios))
    @printf("  Median log-ratio               : %+.3f\n", quantile(log_ratios, 0.5))
    @printf("  Strains with P(beneficial)>0.95: %d  (=> robust beneficial-carrier tail)\n", n_clear_pos)
    @printf("  Strains with P(beneficial)<0.05: %d  (=> clear fitness cost)\n", n_clear_neg)
    @printf("  Strains neutral (in between)   : %d\n", n_neutral)

    # Save to CSV
    out = joinpath(S02_DIR, "per_strain_summary.csv")
    open(out, "w") do f
        keys = (:strain, :r_wt_mean, :r_wt_lo, :r_wt_hi,
                :r_tc_mean, :r_tc_lo, :r_tc_hi,
                :log_ratio_mean, :log_ratio_lo, :log_ratio_hi, :p_beneficial)
        println(f, join(string.(keys), ","))
        for r in rows
            println(f, join([string(getfield(r, k)) for k in keys], ","))
        end
    end
    println("Wrote $out")
end
