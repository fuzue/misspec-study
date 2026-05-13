"""
Truth-and-misspecification recipes.

Each `Truth` describes how to generate clean data from biology-flavoured ground truth.
Each `MisspecFit` declares which inference model to fit. By convention the *truth*
generator has structure the *fit* model does not, so coverage degrades systematically.
"""

using Random: AbstractRNG, MersenneTwister

# ---------------- Truth: Gompertz ----------------

"""
    gompertz_curve(t, p) -> Vector

3-parameter Gompertz: p = [N_max, growth_rate, lag].
"""
gompertz_curve(t, p) = p[1] .* exp.(-exp.(-p[2] .* (t .- p[3])))

# ---------------- Truth: Logistic (the misspec target) ----------------

"""
    logistic_curve(t, p) -> Vector

3-parameter logistic in Kinbiont's positional convention: p = [K, N_0, r].
Symmetric around the inflection — the wrong shape when Gompertz generated the data.
"""
logistic_curve(t, p) = p[1] ./ (1 .+ (p[1] ./ p[2] .- 1) .* exp.(-p[3] .* t))

# ---------------- Synthetic experiment generator ----------------

"""
    Experiment(truth_func, truth_params, param_names, σ, t_end, dt)

A single synthetic-experiment recipe. `σ` is multiplicative log-normal noise.
"""
struct Experiment
    truth_func::Function
    truth_params::Vector{Float64}
    param_names::Vector{String}
    σ::Float64
    t_end::Float64
    dt::Float64
end

"""
    generate(exp::Experiment, seed::Int) -> (times, observed, truth)

Generate one replicate at the given seed. Multiplicative log-normal noise.
"""
function generate(exp::Experiment, seed::Int)
    rng = MersenneTwister(seed)
    times = collect(0.0:exp.dt:exp.t_end)
    clean = exp.truth_func(times, exp.truth_params)
    observed = clean .* exp.(exp.σ .* randn(rng, length(times)))
    truth_nt = NamedTuple(Symbol(n) => v for (n, v) in zip(exp.param_names, exp.truth_params))
    return times, observed, truth_nt
end

# ---------------- Canonical recipes ----------------

"""
    gompertz_truth(; N_max=1.0, growth_rate=0.4, lag=5.0, σ=0.05, t_end=24.0, dt=0.25) -> Experiment
"""
gompertz_truth(; N_max=1.0, growth_rate=0.4, lag=5.0, σ=0.05, t_end=24.0, dt=0.25) =
    Experiment(gompertz_curve, [N_max, growth_rate, lag],
               ["N_max", "growth_rate", "lag"], σ, t_end, dt)
