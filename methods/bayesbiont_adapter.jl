"""
BayesBiont method adapter — returns posterior samples per parameter.

Usage:
    samples = fit_bayesbiont(times, observed, kinbiont_model_name; opts...)
"""

using BayesBiont, Kinbiont

"""
    fit_bayesbiont(times, observed, model_name; rng_seed, n_warmup, n_samples) -> Dict{Symbol,Vector{Float64}}

Returns per-parameter posterior samples flattened across chains.
"""
function fit_bayesbiont(times::Vector{Float64}, observed::Vector{Float64},
                       model_name::String;
                       rng_seed::Int=42, n_chains::Int=1,
                       n_warmup::Int=400, n_samples::Int=400)
    data = GrowthData(reshape(observed, 1, :), times, ["c"])
    spec = BayesianModelSpec([MODEL_REGISTRY[model_name]])
    opts = BayesFitOptions(n_chains=n_chains, n_warmup=n_warmup,
                           n_samples=n_samples, rng_seed=rng_seed)
    r = bayesfit(data, spec, opts)[1]
    out = Dict{Symbol, Vector{Float64}}()
    for n in r.model.param_names
        out[Symbol(n)] = getproperty(r, Symbol(n))
    end
    return out
end
