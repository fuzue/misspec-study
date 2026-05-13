# MisspecStudy — Claude collaboration notes

## Mission

Paper-only project. Measure the calibration gap of growth-curve ODE inference under structural misspecification across the ecosystem (scipy, lmfit, emcee, Stan, Turing, Kinbiont, BayesBiont, NumPyro). Paired with BayesBiont as the "calibrated method" baseline.

## Status

Pilot — Julia-only scaffold; Gompertz-truth × Logistic-misspec recipe with BayesBiont and Kinbiont-bootstrap methods. Coverage measurement loop functional but small N.

## Scope per `~/fuzue-master-plan/projects/misspec-study.md`

**In scope:**
- 3–5 well-studied biological ODE models (logistic, Gompertz, Baranyi, two-compartment PK, SIR)
- For each: 1 "true" generating model + 2–3 misspecified inference models
- Calibration metrics: nominal-vs-actual coverage, sharpness, PIT histograms, log-score
- Both synthetic data (controlled misspecification) and 1–2 real-data anchors

**Out of scope:**
- Multi-domain benchmark suite (killed "kinbench" scope)
- Public leaderboard / CI infrastructure
- New inference methods (BayesBiont is the methodological contribution alongside)
- Theoretical analysis of misspecification (follow-up paper)

## Conventions

- **Synthetic data is deterministic**: every experiment seeds an `rng` per repetition; coverage runs reproduce exactly.
- **Data is not committed**: `data/synthetic/` and `data/results/` are gitignored. Regenerate from the experiment scripts.
- **One file per experiment**: `experiments/NN_truth-name_misspec-name_method.jl` is the entry point. Reading the file end-to-end should tell the whole story.
- **Methods return per-replicate posterior samples**, not just point estimates. The coverage layer always operates on samples.
- **Calibration is the headline metric.** Sharpness is a secondary axis to flag "fast but lying" methods.

## Paired project

BayesBiont.jl provides the Bayesian fitting infrastructure. The two repos evolve together: BayesBiont supplies inference, MisspecStudy supplies the evaluation framework.

## Reference docs

- Spec: `~/fuzue-master-plan/projects/misspec-study.md`
- Paired: `~/BayesBiont.jl/`
- Kinbiont dev: `~/pinheiroTech/KinBiont.jl/`
