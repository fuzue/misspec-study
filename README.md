# MisspecStudy

Empirically measuring the calibration gap of ODE-parameter inference under structural model misspecification.

> **Status:** early — pilot pipeline only. Paper draft pending.

## The question

All biological ODE models are wrong. Most are phenomenological curves, not mechanistic predictions — fit one strain in one condition, parameters don't transfer. Yet methods papers report point estimates and uncertainty bounds as if the model were correct. **When the model is wrong (always), do current inference methods admit they don't know things?**

This study takes 3–5 well-known biological ODE models, deliberately introduces structural misspecification (missing degradation term, wrong functional form, ignored compartment, lag-phase drop, etc.), and asks: are the methods' uncertainty estimates calibrated, or systematically over-confident?

## Methods compared

| Method | Type | Status |
|---|---|---|
| [Kinbiont.jl](https://github.com/pinheiroGroup/KinBiont.jl) | MLE + parametric bootstrap | pilot |
| [BayesBiont.jl](https://github.com/fuzue/BayesBiont.jl) | NUTS posterior | pilot |
| scipy.optimize.curve_fit + delta-method CI | MLE | planned |
| lmfit | MLE + propagation | planned |
| emcee | MCMC | planned |
| Stan / cmdstan | NUTS | planned |
| NumPyro | NUTS / SVI | planned |

## Metrics

- **Coverage**: fraction of 95% intervals that contain the true parameter under repeated synthetic experiments
- **Sharpness**: mean interval width (narrower is "better" only when calibrated)
- **PIT histogram**: probability-integral transforms of the truth under each posterior; uniform = perfectly calibrated
- **Log-score**: out-of-sample log-likelihood of held-out timepoints

## Expected finding

Most methods' nominal-95% intervals will cover the true parameter at substantially lower rates (e.g. 55–70%) under realistic misspecification. BayesBiont's properly-priored Bayesian approach should hold up better but not perfectly.

## Repo layout

```
src/         Julia core: truth and misspecified model definitions, coverage utilities
methods/     One adapter per inference method
experiments/ One file per (truth, misspec, method) combination
data/        Generated synthetic data and per-method results (gitignored)
analysis/    Scoring and figure generation
paper/       LaTeX manuscript (future)
```

## License

MIT
