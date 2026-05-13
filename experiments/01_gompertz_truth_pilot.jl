"""
Experiment 01 — pilot: Gompertz truth, compare two fits:

    (a) BayesBiont fitting NL_Gompertz   — correct model, calibrated method
    (b) BayesBiont fitting NL_logistic    — misspecified shape, same method
    (c) Kinbiont MLE + parametric bootstrap fitting NL_Gompertz — correct
                                                                  model, practitioner method

We expect:
- (a) 95% coverage ≈ 95% on every parameter (calibrated)
- (b) 95% coverage substantially below 95% on shape-driven params (misspecified)
- (c) Coverage depends on whether bootstrap captures the parametric noise correctly

Run from repo root:  julia --project=. experiments/01_gompertz_truth_pilot.jl
"""

using Random, Statistics, Printf

include(joinpath(@__DIR__, "..", "src", "models.jl"))
include(joinpath(@__DIR__, "..", "src", "coverage.jl"))
include(joinpath(@__DIR__, "..", "methods", "bayesbiont_adapter.jl"))
include(joinpath(@__DIR__, "..", "methods", "kinbiont_bootstrap_adapter.jl"))

const N_REPS    = 20
const BASE_SEED = 1000

exp_recipe = gompertz_truth()    # truth params: N_max=1.0, growth_rate=0.4, lag=5.0

# Truth parameter names — both Gompertz and Logistic models in Kinbiont label their
# params ["N_max", "growth_rate", "lag"], so we can compute coverage on the same
# named axes. (Note: Logistic's positional semantics is [K, N_0, r] — the labels
# are Kinbiont's convention; coverage is still well-defined as "does the 95% CI
# on the parameter that the model calls `N_max` contain the truth's N_max?")
truth_param_names = ["N_max", "growth_rate", "lag"]

function run_method(method_label::String, fit_fn::Function)
    println("\n=== $method_label ===")
    per_rep = NamedTuple[]
    for k in 1:N_REPS
        seed = BASE_SEED + k
        times, observed, truth = generate(exp_recipe, seed)
        t0 = time()
        samples = try
            fit_fn(times, observed; rng_seed=seed)
        catch e
            println("  rep $k: error — $e")
            continue
        end
        elapsed = time() - t0
        push!(per_rep, (samples=samples, truth=truth))
        if k <= 3 || k == N_REPS
            @printf("  rep %2d: done in %5.1fs\n", k, elapsed)
        end
    end
    return summarise(per_rep, truth_param_names)
end

rows_a = run_method(
    "(a) BayesBiont NUTS, NL_Gompertz (correct model)",
    (t, y; rng_seed) -> fit_bayesbiont(t, y, "NL_Gompertz"; rng_seed=rng_seed),
)

rows_b = run_method(
    "(b) BayesBiont NUTS, NL_logistic (misspecified)",
    (t, y; rng_seed) -> fit_bayesbiont(t, y, "NL_logistic"; rng_seed=rng_seed),
)

rows_c = run_method(
    "(c) Kinbiont MLE + parametric bootstrap, NL_Gompertz (correct model)",
    (t, y; rng_seed) -> fit_kinbiont_bootstrap(t, y, "NL_Gompertz"; rng_seed=rng_seed),
)

function print_table(label, rows)
    println("\n--- $label ---")
    @printf("%-12s | %5s | %11s | %11s\n", "param", "reps", "coverage_95", "mean_width")
    for r in rows
        @printf("%-12s | %5d | %11.2f | %11.4f\n",
                r.param, r.n_reps, r.coverage_95, r.mean_width)
    end
end

print_table("(a) BayesBiont Gompertz (correct)",    rows_a)
print_table("(b) BayesBiont Logistic (misspec)",     rows_b)
print_table("(c) Kinbiont bootstrap Gompertz",       rows_c)
