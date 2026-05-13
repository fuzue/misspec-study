"""
Kinbiont MLE + parametric bootstrap adapter.

The "typical practitioner" baseline: fit by optimization, generate bootstrap
replicates by adding noise of the same kind/scale used by the model fit, refit
each replicate, build an empirical sampling distribution of the parameters.
"""

using Kinbiont
using Random: MersenneTwister
using Distributions: LogNormal

"""
    fit_kinbiont_bootstrap(times, observed, model_name; n_boot=200, rng_seed=42) -> Dict{Symbol,Vector{Float64}}

Returns per-parameter bootstrap samples. The bootstrap injects log-normal
multiplicative noise around the *MLE-predicted* curve at residual scale, matching
the multiplicative noise assumption used to generate the synthetic data.
"""
function fit_kinbiont_bootstrap(times::Vector{Float64}, observed::Vector{Float64},
                                model_name::String;
                                n_boot::Int=200, rng_seed::Int=42)
    data = GrowthData(reshape(observed, 1, :), times, ["c"])
    model = MODEL_REGISTRY[model_name]
    # Initial guess: prior median equivalent (matches BayesBiont init convention)
    p0 = model.guess === nothing ?
        ones(length(model.param_names)) :
        model.guess(Matrix(transpose(hcat(times, observed))))
    spec = ModelSpec([model], [p0])
    opts = FitOptions(loss="RE")
    res = kinbiont_fit(data, spec, opts)
    p_hat = Float64.(res[1].best_params)

    pred = model.func(p_hat, times)
    log_resid = log.(observed) .- log.(max.(pred, eps()))
    σ_hat = max(std(log_resid), 1e-3)

    rng = MersenneTwister(rng_seed)
    boot_samples = [Float64[] for _ in 1:length(p_hat)]
    for _ in 1:n_boot
        y_boot = pred .* exp.(σ_hat .* randn(rng, length(times)))
        boot_data = GrowthData(reshape(y_boot, 1, :), times, ["b"])
        boot_spec = ModelSpec([model], [p_hat])
        boot_res = try
            kinbiont_fit(boot_data, boot_spec, opts)
        catch
            continue
        end
        p_b = Float64.(boot_res[1].best_params)
        length(p_b) == length(p_hat) || continue
        for (i, v) in enumerate(p_b)
            push!(boot_samples[i], v)
        end
    end

    out = Dict{Symbol, Vector{Float64}}()
    for (i, name) in enumerate(model.param_names)
        out[Symbol(name)] = boot_samples[i]
    end
    return out
end
