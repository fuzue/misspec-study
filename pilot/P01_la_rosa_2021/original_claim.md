# P01 — La Rosa et al. 2021, *Nat. Commun.* 12:3186

**DOI:** 10.1038/s41467-021-23451-y
**Title:** Compensatory evolution of *Pseudomonas aeruginosa*'s slow growth phenotype suggests mechanisms of adaptation in cystic fibrosis.
**Senior author:** Søren Molin (DTU Biosustain, Lyngby).

## Quantitative claim to reanalyse

Adaptive laboratory evolution (ALE) trajectory of maximum specific growth rate μ_max across selected clinical *P. aeruginosa* lineages in MOPS + glucose, fitted from optical density 0.05 → 0.95 with an in-house MATLAB pipeline (Eq. (1) in Methods: μ = (1/ΔX) ln(X_t / X_0)).

Headline trajectory (mean ± bootstrap-SD across replicate cultures, 500 bootstrap reps):

| Stage | μ_max (h⁻¹) |
|-------|-------------|
| Starting clinical isolate (S) | 0.37 ± 0.03 |
| Intermediate evolved (I) | 1.28 ± 0.02 |
| Later evolved (L) | 1.08 ± 0.02 |
| Late post-recovery / endpoint | 0.87 ± 0.02 |

(Numbers as reported in `pilot_targets.md`; the paper presents the same per-clone trajectories per generation in Figure 1a / Figure S2 with bootstrap 95 % CIs.)

## Parameter and groups

- **Parameter:** maximum specific growth rate μ_max (h⁻¹), single per-curve scalar from log-linear fit.
- **Groups compared:** generation-bucket of ALE (S, I, L) within each lineage (PAO1, clone 141, clone 10, clone 427.1); selected I-vs-L and S-vs-I contrasts.
- **Reported uncertainty:** 500-replication non-parametric bootstrap 95 % CI on the fitted μ_max — the **only** paper in `04_comparative_claims.tsv` that bootstraps the kinetic parameter directly.

## Why this matters for MisspecStudy

Endpoint differences (0.37 → 1.28, ≈3.4×) will survive any reasonable reanalysis. The sensitive contrasts are the per-generation transitions (≤1.5×) and the I-vs-L drop, where bootstrap-based CIs may be optimistic versus a hierarchical Bayesian fit that propagates uncertainty in the inflection point and the OD baseline.
