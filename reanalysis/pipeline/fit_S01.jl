# Pilot reanalysis of Pedreira 2022 — logistic fit per (organism, DDAC concentration).
#
# Strategy (minimum-viable pilot):
#   - one curve per (organism × DDAC) — across-replicate mean + per-timepoint SD as data
#   - logistic curve (matches paper's Model_Logistic.m)
#   - BayesBiont :lognormal likelihood, default curated priors
#   - 1 chain × 400 warmup × 400 samples per curve
#   - Output: posterior summary per concentration, comparison vs paper Table 4
#
# We do NOT hierarchically pool across concentrations in this v0.1 pilot — each curve
# is fit independently. Hierarchical pooling across concentrations is a meaningful
# next step (μ_max vs [DDAC] is a structured response).

using Pkg
Pkg.activate(joinpath(@__DIR__, "..", "..", "."))
using BayesBiont, Kinbiont, Statistics, Random, Printf

include(joinpath(@__DIR__, "load_S01.jl"))

# Pedreira's NL_logistic naming bug-fix note: Kinbiont labels are [N_max, growth_rate, lag]
# but the underlying function parameterises as [K, N_0, r]. Numerically the third position
# is the growth rate. We extract the "lag" field's samples as the growth-rate posterior.
# (See literature_review/raw_results/ for the original observation of this naming clash.)

function fit_organism(organism::Symbol; n_chains=1, n_warmup=400, n_samples=400, seed=42)
    Random.seed!(seed)
    P    = load_pedreira(organism)
    rows = NamedTuple[]
    println("Fitting $(organism) — $(length(P.ddac)) concentrations…")
    for j in 1:length(P.ddac)
        y = P.mean_OD[j]
        times_j = P.times[j]
        # The deposit's mean curve drops slightly at the last timepoint for some
        # concentrations (post-stationary decline); the logistic monotone fit will
        # average over that. Filter to ensure y > 0 for :lognormal.
        valid = y .> 0
        if count(valid) < 6
            push!(rows, (ddac=P.ddac[j], status=:insufficient_data, n_pts=count(valid)))
            continue
        end
        t_v, y_v = times_j[valid], y[valid]
        data = GrowthData(reshape(y_v, 1, :), t_v, [P.labels[j]])
        spec = BayesianModelSpec([MODEL_REGISTRY["NL_logistic"]])
        opts = BayesFitOptions(n_chains=n_chains, n_warmup=n_warmup,
                               n_samples=n_samples, target_accept=0.95,
                               rng_seed=seed + j)
        t0 = time()
        r  = bayesfit(data, spec, opts)[1]
        # NL_logistic positional: p[1]=K (label "N_max"), p[2]=N_0 (label "growth_rate"), p[3]=r (label "lag")
        K_post    = r.N_max
        N0_post   = r.growth_rate
        rate_post = r.lag
        push!(rows, (
            ddac     = P.ddac[j],
            status   = :ok,
            n_pts    = length(y_v),
            elapsed  = time() - t0,
            K_mean   = mean(K_post),
            K_lo     = quantile(K_post, 0.025),
            K_hi     = quantile(K_post, 0.975),
            r_mean   = mean(rate_post),
            r_lo     = quantile(rate_post, 0.025),
            r_hi     = quantile(rate_post, 0.975),
            N0_mean  = mean(N0_post),
            σ_mean   = mean(r.σ),
        ))
        @printf("  [%d/%d] DDAC=%.2f  r=%.3f [%.3f, %.3f]  K=%.3f [%.3f, %.3f]  %.1fs\n",
                j, length(P.ddac), P.ddac[j],
                mean(rate_post), quantile(rate_post, 0.025), quantile(rate_post, 0.975),
                mean(K_post), quantile(K_post, 0.025), quantile(K_post, 0.975),
                time() - t0)
    end
    return rows
end

function print_table(organism, rows)
    println("\n=== $organism — BayesBiont logistic per-concentration ===")
    @printf("%-8s | %5s | %20s | %20s | %7s\n",
            "DDAC", "n", "rate (r) [95% CI]", "K (N_max) [95% CI]", "σ")
    for r in rows
        if r.status === :ok
            @printf("%-8.2f | %5d | %.3f [%.3f, %.3f]      | %.3f [%.3f, %.3f]      | %.3f\n",
                    r.ddac, r.n_pts, r.r_mean, r.r_lo, r.r_hi,
                    r.K_mean, r.K_lo, r.K_hi, r.σ_mean)
        else
            @printf("%-8.2f | %5d | %s\n", r.ddac, r.n_pts, r.status)
        end
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    rows_Bc = fit_organism(:Bc)
    print_table(:Bc, rows_Bc)

    rows_Ec = fit_organism(:Ec)
    print_table(:Ec, rows_Ec)

    # Save the posterior summaries for downstream verdict scripting.
    using DelimitedFiles
    function dump(rows, organism)
        out = joinpath(@__DIR__, "..", "..", "pilot", "S01_pedreira_2022",
                       "posterior_summary_$(organism).csv")
        keys = (:ddac, :status, :n_pts, :K_mean, :K_lo, :K_hi,
                :r_mean, :r_lo, :r_hi, :N0_mean, :σ_mean)
        open(out, "w") do f
            println(f, join(string.(keys), ","))
            for r in rows
                vals = [string(get(r, k, "")) for k in keys]
                println(f, join(vals, ","))
            end
        end
        println("Wrote $out")
    end
    dump(rows_Bc, "Bc")
    dump(rows_Ec, "Ec")
end
