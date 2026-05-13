# S02 — Alonso-del Valle et al. 2021, *Nat. Commun.* 12:2653

**DOI:** 10.1038/s41467-021-22849-y
**Title:** Variability of plasmid fitness effects contributes to plasmid persistence in bacterial communities.
**Senior author:** Álvaro San Millán (Centro Nacional de Biotecnología, CSIC, Madrid).

## Substitution rationale

Priority-2 substitute from `pilot/pilot_targets.md`, used in addition to S01 Pedreira because:

- Provides ~250 plasmid carriage / fitness comparisons — close to the large-N scale we were targeting in the original P03 Chowdhury claim.
- Authors deposited **all raw plate-reader growth curves** in a public GitHub repository (`ccg-esb/pOXA48`, mirrored to Zenodo 10.5281/zenodo.4605352).
- The conclusion ("tail of nearly-neutral / beneficial plasmid carriers explains plasmid persistence") rests on per-strain comparisons just above and just below relative fitness = 1.0 — exactly the regime where the choice of fit method and uncertainty model matters.

## Quantitative claim to reanalyse

Distribution of relative fitness (plasmid+ vs. plasmid–) measured across ~50 enterobacterial host strains carrying the carbapenemase-encoding plasmid pOXA-48. Authors argue that the **tail of strains scoring fitness >1** (i.e. carrying pOXA-48 makes them slightly fitter) is biologically real, not a measurement artefact, and that this tail explains why pOXA-48 persists in clinical bacterial populations even in the absence of antibiotic selection.

Per-strain fitness is computed from joint Metropolis–Hastings MCMC fits of growth-curve parameters (specific affinity ν, cell efficiency ε) on each strain's plasmid+/plasmid– (TC/WT) pair (Methods, Fig. 4).

## Parameter and groups

- **Parameters per strain:** ν, ε, derived μ_max; relative fitness = (ν·ε)_TC / (ν·ε)_WT or analogous logistic-parameter ratios.
- **Groups compared:** ~50 enterobacterial strains × {WT, TC} = 100 OD time series. Plus in silico competition experiments (Supp Fig 7, 8).
- **Reported uncertainty:** standard error across triplicate growth-curve replicates per strain (per-timepoint SE in the deposited CSVs), MCMC posterior intervals on fitted parameters; t-test against fitness = 1.0 for each strain.

## Why this matters for MisspecStudy

The "tail of beneficial plasmid carriers" claim rests on a *small subset* of strains scoring fitness slightly above 1.0. With 30 % wider CIs (the rough effect size we expect from misspecification correction) more of those strains would be reclassified as nominally neutral, undermining the distributional argument. Conversely, if the Bayesian reanalysis preserves the tail, that is direct validation of the original authors' biological conclusion under more conservative inference.

This is also one of the **only growth-curve papers in our literature review where the authors themselves used MCMC** to fit the growth model (rare in this domain) — so the reanalysis is comparing apples-to-apples (Bayesian vs. Bayesian-with-stronger-priors / hierarchical pooling) rather than translating a frequentist fit.
