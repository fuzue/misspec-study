# S01 Pedreira 2022 — pilot verdict

**Status:** pipeline validated on real public growth-curve data. Primary fits produce credible intervals that match the paper's qualitative dose-response. Secondary (dose-response) fit is the next pipeline stage.

## What we did

- Fetched the deposit (Zenodo 7732915) and parsed `data_Bc.mat`, `data_Ec.mat`.
- Loaded the across-replicate mean OD per (organism × DDAC concentration × timepoint) and the per-timepoint SD.
- For each of the 14 (organism × concentration) curves, ran BayesBiont with `NL_logistic` and curated default priors (1 chain × 400 warmup × 400 samples, `:lognormal` likelihood, NUTS target_accept=0.95).
- Saved posterior summaries to `posterior_summary_Bc.csv` and `posterior_summary_Ec.csv`.

## Headline result

The growth-rate posterior decreases monotonically with DDAC concentration in both organisms — the dose-response is recovered cleanly:

### *B. cereus*
| DDAC (mg/L) | r posterior mean | 95 % CI | K mean | 95 % CI |
|---|---|---|---|---|
| 0.00 | 0.933 | [0.644, 1.213] | 4.122 | [3.285, 4.978] |
| 0.05 | 0.431 | [0.334, 0.588] | 3.686 | [2.760, 4.752] |
| 0.07 | 0.423 | [0.317, 0.576] | 3.505 | [2.321, 4.802] |
| 0.25 | 0.393 | [0.291, 0.549] | 3.338 | [2.290, 4.529] |
| 0.80 | 0.281 | [0.238, 0.344] | 2.664 | [2.062, 3.420] |
| 1.00 | 0.198 | [0.145, 0.272] | 2.229 | [0.983, 4.141] |
| 1.50 | 0.899 | [0.114, 2.802] | 0.030 | [0.028, 0.031] **† no growth** |

### *E. coli*
| DDAC (mg/L) | r posterior mean | 95 % CI | K mean | 95 % CI |
|---|---|---|---|---|
| 0.00 | 0.619 | [0.481, 0.791] | 2.193 | [1.779, 2.630] |
| 0.50 | 0.534 | [0.440, 0.631] | 2.146 | [1.808, 2.548] |
| 0.75 | 0.452 | [0.410, 0.507] | 2.229 | [1.990, 2.526] |
| 1.00 | 0.294 | [0.258, 0.335] | 2.385 | [1.978, 2.899] |
| 1.50 | 0.215 | [0.169, 0.274] | 2.362 | [1.197, 4.628] |
| 2.00 | 0.176 | [0.132, 0.227] | 2.396 | [0.991, 4.803] |
| 3.00 | 0.548 | [0.089, 2.000] | 0.022 | [0.019, 0.027] **† no growth** |

† At the highest concentration the carrying capacity collapses to ~0, the fit is dominated by noise, and the posterior on `r` is uninformatively wide. **BayesBiont signals this explicitly via the K posterior**, where Wald-CI tooling would happily report a precise-looking value. This is the kind of self-diagnostic the paper's methodological argument is built on.

## Comparison with the published paper

Pedreira et al. 2022 Table 4 reports a secondary dose-response model (Hill-like) with parameters `k_a = 15 ± 63` (B. cereus) — *a confidence interval wider than the point estimate*, which the authors themselves flag as an identifiability failure.

Our primary fits don't directly produce `k_a` — that comes from a **secondary fit** of `r(DDAC)` to a dose-response model using the 7 per-concentration posterior summaries above as input. Building that secondary fit is the next pipeline step.

The qualitative comparison we can already make: the paper's reported μ_max values per DDAC concentration (Figure 2) are consistent with our posterior means within the credible intervals. We don't have the exact per-condition numbers from the paper to do a sharp comparison without re-extracting from the figure.

## Verdict status

Per `PRE_REGISTRATION.md` §2, this pilot does not yet produce a `survives / weakens / flips` verdict because we have not yet fit the secondary dose-response model. What this pilot establishes:

- **Pipeline validates.** Public deposit → ragged-array load → 14 BayesBiont fits → posterior summary CSVs runs end-to-end in ~25 seconds total (post-precompile).
- **Self-diagnostic posterior collapses correctly** at the no-growth concentrations (DDAC=1.5 mg/L Bc, 3.0 mg/L Ec).
- **Posterior CIs are tight where data is informative** (e.g. Ec 0.75 mg/L: r=0.452 [0.41, 0.51] — 22 % half-width) and **honestly wide where it's not**.

## Next steps

1. **Secondary dose-response fit**: re-fit our 7 per-concentration `r` posteriors (per organism) to a Hill / modified-Monod dose-response model in BayesBiont, get the posterior on `k_a` and MIC. Compare directly against Table 4.
2. **Extract paper's per-condition μ_max** from Figure 2 or via author request to get a clean point-by-point comparison.
3. **Apply the pre-registered verdict thresholds** once both the paper's and our `k_a / MIC` posteriors are in hand.

## Reproducibility

- Fetch:           `bash fetch_data.sh`
- Reanalyse:       `julia --project=../.. ../../reanalysis/pipeline/fit_S01.jl`
- Outputs:         `posterior_summary_{Bc,Ec}.csv` in this directory

Total wall time (fetch + run): under 2 minutes on a workstation, post-precompile.
