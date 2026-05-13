# S01 — Pedreira, Vázquez & García 2022, *Front. Microbiol.* 13:758237

**DOI:** 10.3389/fmicb.2022.758237
**Title:** Kinetics of Bacterial Adaptation, Growth, and Death at Didecyldimethylammonium Chloride sub-MIC Concentrations.
**Senior author:** Míriam R. García (IIM-CSIC, Vigo, Spain).

## Substitution rationale

Substitution for P01/P02/P03 (none of which deposited raw growth-curve data). Pedreira 2022 is the priority-1 substitute from `pilot/pilot_targets.md`:

- Reports growth-rate-as-a-function-of-DDAC-concentration with **identifiability discussion** (notes wide CIs where CI > point estimate, exposing the misspecification problem directly).
- **Raw OD and CFU time series are deposited on Zenodo** (mean + per-timepoint empirical SD across replicates; constant per-condition error level as a second uncertainty estimate).
- Two organisms (B. cereus, E. coli) × seven DDAC concentrations × 12 timepoints over 48 h.

## Quantitative claim to reanalyse

DDAC dose–response: *B. cereus* μ_max falls from ~0.6 /h at 0 mg/L DDAC to ~0.4 /h at 0.5 mg/L (Figure 2 / Table 4); fitted MIC = 1.39 mg/L for *B. cereus* and 2.86 mg/L for *E. coli*. The MIC value drives regulatory recommendations on DDAC biocide use, so the width of the CI on MIC is directly policy-relevant.

Table 4 of the paper reports e.g. k_a = 15 ± 63 — a CI wider than the point estimate, evidence of identifiability failure under the published frequentist fit. This is exactly the regime where a hierarchical Bayesian fit with weakly-informative priors will produce a different (and more honest) credible interval.

## Parameter and groups

- **Parameters:** μ_max (h⁻¹), MIC (mg/L), DDAC-affinity k_a, mechanistic-model rate constants.
- **Groups compared:** 7 DDAC concentrations (0, 0.05, 0.07, 0.25, 0.8, 1.0, 1.5 mg/L) for *B. cereus*; analogous concentration ladder for *E. coli*.
- **Reported uncertainty:** parameter ± frequentist asymptotic CI (Table 4), AIC/BIC for model selection.

## Why this matters for MisspecStudy

The authors' own Table 4 already exhibits the failure mode MisspecStudy is targeting (CI > point estimate, ~50 % of fitted parameters). A Bayesian reanalysis should (i) replace those misleading asymptotic CIs with credible intervals that respect the prior on positive rate constants, and (ii) widen the MIC interval enough to meaningfully change the regulatory call.
