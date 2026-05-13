# P03 — Chowdhury et al. 2023, *ACS Infect. Dis.* 9(10):1834–1845

**DOI:** 10.1021/acsinfecdis.3c00156
**Title:** Fitness Costs of Antibiotic Resistance Impede the Evolution of Resistance to Other Antibiotics.
**Corresponding author:** Brandon L. Findlay (Concordia University, Montréal, Canada).

## Correction to brief

The brief describes this as an **omadacycline**-resistance study from the Lipsitch lab. The actual paper is on **chloramphenicol (CHL)** resistance from the Findlay lab. The "omadacycline-resistant mutant / evolved-recovery line" pattern still maps cleanly onto the experiment: the comparisons are wild-type *E. coli* MG1655 vs. CHL-resistant "old mutant" (OM, 5× MIC parent) vs. compensated/evolved-recovery lines (1X, 2X, 3X, 4X, 5X — five revived sub-lineages from the CHL-evolved population).

## Quantitative claim to reanalyse

From plate-reader growth curves (Bioscreen-style, fit with Growthcurver R package):

- **AUC of growth curve** ~8× lower for the OM strain vs. WT.
- **Stationary-phase OD** ~5× lower for OM vs. WT.
- **Evolved-recovery line (5X) AUC** ~5× above OM (i.e. closer to WT).
- Uncertainty reported as **SEM only**, with N = 16 (or as the legend specifies; figures use SEM error bars throughout — Figs. 1B, S1, S4).

## Parameter and groups

- **Parameters:** AUC, μ_max and asymptote ("k") from Growthcurver logistic fit.
- **Groups compared:**
  - WT (MG1655) vs. OM (CHL-resistant parental).
  - OM vs. 1X..5X (five compensated/evolved recovery sub-lines).
  - WT-B (BW25113) vs. CFZR (cefazolin-resistant) for the second-antibiotic class.
- **Reported uncertainty:** SEM only (the modal case in `04_comparative_claims.tsv`).

## Why this matters for MisspecStudy

SEM-only is the most common practice in the literature review. Headline 5–8× differences (WT vs. OM) will survive any reasonable reanalysis. The interesting cases are the intermediate p ≈ 0.01 comparisons among the 1X–5X evolved-recovery lines — these are where Bayesian propagation of fit uncertainty (rather than treating Growthcurver point estimates as exact and taking SEM across N curves) is most likely to flip the conclusion.
