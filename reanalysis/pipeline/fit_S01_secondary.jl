# Secondary dose-response fit: take the 7 per-concentration r posteriors from the
# primary BayesBiont fit (Step 1 of the pilot) and fit a 3-parameter sigmoid
# dose-response in DDAC concentration. Produces a credible interval on IC50 and
# the no-DDAC growth rate, which we can compare to Pedreira 2022 Table 4.

using Pkg; Pkg.activate(joinpath(@__DIR__, "..", ".."))
using Turing, Distributions, Random, Statistics, Printf, DelimitedFiles

const PILOT_DIR = joinpath(@__DIR__, "..", "..", "pilot", "S01_pedreira_2022")

"""Parse the per-concentration posterior summary CSV emitted by `fit_S01.jl`."""
function load_summary(organism::String)
    path = joinpath(PILOT_DIR, "posterior_summary_$(organism).csv")
    raw, _ = readdlm(path, ',', header=true)
    n = size(raw, 1)
    ddac = Float64.(raw[:, 1])
    r_mean = Float64.(raw[:, 7])
    r_lo   = Float64.(raw[:, 8])
    r_hi   = Float64.(raw[:, 9])
    K_mean = Float64.(raw[:, 4])
    # Treat 95% CI half-width / 1.96 as an approximate Gaussian SD on the posterior mean.
    r_se = (r_hi .- r_lo) ./ (2 * 1.96)
    return (; ddac, r_mean, r_lo, r_hi, r_se, K_mean)
end

# 3-parameter sigmoid dose-response model.
# μ([DDAC]) = μ_0 / (1 + ([DDAC]/IC50)^h)
@model function dose_response(ddac, r_mean, r_se)
    μ_0   ~ LogNormal(log(0.5), 0.7)
    IC50  ~ LogNormal(log(1.0), 1.0)
    h     ~ LogNormal(log(2.0), 0.6)
    for i in eachindex(ddac)
        μ_i = μ_0 / (1 + (ddac[i] / IC50)^h)
        r_mean[i] ~ Normal(μ_i, max(r_se[i], 0.01))
    end
end

function fit_secondary(organism::String; n_chains=2, n_warmup=600, n_samples=600,
                       drop_no_growth::Bool=true, no_growth_K::Float64=0.1)
    S = load_summary(organism)
    keep = drop_no_growth ? (S.K_mean .> no_growth_K) : trues(length(S.ddac))
    ddac, r_mean, r_se = S.ddac[keep], S.r_mean[keep], S.r_se[keep]
    println("Secondary fit $organism — using $(count(keep))/$(length(S.ddac)) " *
            "concentrations (dropped no-growth K<$no_growth_K)")
    model = dose_response(ddac, r_mean, r_se)
    chain = sample(MersenneTwister(42), model,
                   NUTS(n_warmup, 0.95), MCMCThreads(),
                   n_samples, n_chains; progress=false)
    return chain, ddac
end

function summarize(chain, organism)
    μ_0  = vec(chain[:μ_0].data)
    IC50 = vec(chain[:IC50].data)
    h    = vec(chain[:h].data)
    @printf("\n=== %s — secondary dose-response posterior ===\n", organism)
    @printf("  μ_0   = %.3f [%.3f, %.3f]  /h    (rate at zero DDAC)\n",
            mean(μ_0), quantile(μ_0, 0.025), quantile(μ_0, 0.975))
    @printf("  IC50  = %.3f [%.3f, %.3f]  mg/L  (half-max DDAC)\n",
            mean(IC50), quantile(IC50, 0.025), quantile(IC50, 0.975))
    @printf("  h     = %.3f [%.3f, %.3f]        (Hill steepness)\n",
            mean(h), quantile(h, 0.025), quantile(h, 0.975))
    return (
        μ_0_mean=mean(μ_0), μ_0_lo=quantile(μ_0, 0.025), μ_0_hi=quantile(μ_0, 0.975),
        IC50_mean=mean(IC50), IC50_lo=quantile(IC50, 0.025), IC50_hi=quantile(IC50, 0.975),
        h_mean=mean(h), h_lo=quantile(h, 0.025), h_hi=quantile(h, 0.975),
    )
end

if abspath(PROGRAM_FILE) == @__FILE__
    chain_Bc, _ = fit_secondary("Bc")
    s_Bc = summarize(chain_Bc, "Bc")
    chain_Ec, _ = fit_secondary("Ec")
    s_Ec = summarize(chain_Ec, "Ec")

    # Save the secondary-fit summary for the verdict writeup.
    out = joinpath(PILOT_DIR, "secondary_dose_response_summary.csv")
    open(out, "w") do f
        println(f, "organism,param,mean,lo95,hi95")
        for (org, s) in [("Bc", s_Bc), ("Ec", s_Ec)]
            println(f, "$org,μ_0,$(s.μ_0_mean),$(s.μ_0_lo),$(s.μ_0_hi)")
            println(f, "$org,IC50,$(s.IC50_mean),$(s.IC50_lo),$(s.IC50_hi)")
            println(f, "$org,h,$(s.h_mean),$(s.h_lo),$(s.h_hi)")
        end
    end
    println("\nWrote $out")
end
