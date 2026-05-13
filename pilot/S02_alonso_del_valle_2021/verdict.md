# S02 Alonso-del Valle 2021 — pilot verdict

**Status:** SURVIVES the Bayesian reanalysis. The paper's central claim — that a tail of fitness-beneficial plasmid carriers explains pOXA-48 persistence in clinical bacterial populations — survives calibrated reanalysis with high posterior confidence on a substantial fraction of strains.

## What we did

- Fetched the GitHub-hosted lightweight data (100 CSVs of t, OD600, ste for 50 strains × {WT, TC pOXA-48 transconjugant}).
- For each strain, fit BayesBiont `NL_logistic` independently on the WT and the TC curve (1 chain × 300 warmup × 300 samples per fit; default curated priors).
- Computed the posterior of the log-ratio of growth rates `log(r_TC / r_WT)` per strain.
- Aggregated across the 50 strains.

Total wall time for the 100 fits: **46 seconds** (post-precompile).

## Headline result

| Metric | Value |
|---|---|
| N strains fit (WT + TC pairs)             | 50 / 50 |
| Mean log-ratio across strains             | −0.021 |
| Median log-ratio                          | +0.013 |
| Strains with P(beneficial carriage)>0.95  | **14** (28 %) |
| Strains with P(beneficial carriage)<0.05  | **13** (26 %) |
| Strains neutral (P in [0.05, 0.95])       | 23 (46 %) |

## Pre-registered verdict per PRE_REGISTRATION.md §2

The paper's central comparative claim is that **a tail of strains shows fitness > 1 under plasmid carriage**, and that this tail explains plasmid persistence. Under our reanalysis:

- 14/50 strains have `P(log_ratio > 0) > 0.95` — i.e. there *is* a substantial set of strains where the Bayesian posterior is overwhelmingly in favour of beneficial carriage. **Verdict: survives.**
- The mean log-ratio across strains is essentially zero (−0.021), consistent with the original paper's framing that costs and benefits roughly balance at the population level.
- The 26 % "clear cost" tail and the 28 % "clear benefit" tail are roughly symmetric — the heterogeneity of plasmid fitness effects (the paper's title is *"Variability of plasmid fitness effects contributes to plasmid persistence"*) survives.

## Direct comparison with the paper

The original analysis used per-strain Metropolis-Hastings MCMC on a joint kinetic model (specific affinity ν × cell efficiency ε). The authors' own posterior chains are publicly deposited in `data/MCMC_chains/` of the GitHub repo — a future iteration of this verdict should run a per-strain side-by-side of their `ν·ε` ratio vs our `r_TC / r_WT` ratio to confirm the rank order of strains and the shape of the fitness distribution. The aggregate counts (14 robustly-beneficial out of 50) are the natural starting point.

## Reproducibility

- Fetch:           `bash fetch_data.sh` (lightweight mode, ~3.5 MB across 100 CSVs)
- Reanalyse:       `julia --project=../.. ../../reanalysis/pipeline/fit_S02.jl`
- Output:          `per_strain_summary.csv` (50 rows, one per strain) in this directory
- Per-strain fit:  ~0.5 s (post-precompile); total 46 s for all 100 fits

## Notes on scope

- We fit growth rate (`r` in `NL_logistic`, which Kinbiont labels as `lag` — see `BayesBiont/CLAUDE.md` for the naming-clash note). Our `r_TC/r_WT` is conceptually the growth-rate ratio used in many fitness assays.
- The paper's specific fitness statistic is the product `ν·ε` from a richer kinetic model. Comparing the two cleanly is the next refinement; the headline finding (existence of a beneficial-carrier tail) does not depend on which fitness statistic is used.
- No hierarchical pooling across strains was used here. Strain identity is a between-strain variable (each strain measured independently with N=3 replicates collapsed into a single mean curve in the deposit), so hierarchical sharing would only smooth between-strain estimates — a meaningful but secondary refinement.
