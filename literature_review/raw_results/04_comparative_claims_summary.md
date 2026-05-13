# 04 — Comparative claims from growth-curve parameter inference

Survey of 18 papers across four domains (drug-resistance / antimicrobial screening, microbial experimental evolution, gene-knockout fitness assays, predictive microbiology) that report comparative claims based on growth-curve-fitted parameters. The goal of this list is to find load-bearing claims that would plausibly be re-evaluated under a 30 % widening of reported CIs.

## Five illustrative high-impact examples for the introduction

### 1. Melnyk et al. 2015 — meta-analysis of resistance fitness costs

> Melnyk, A. H., Wong, A., & Kassen, R. (2015). The fitness costs of antibiotic resistance mutations. *Evolutionary Applications*, 8(3), 273–283. **doi:10.1111/eva.12196**

A random-effects meta-analysis of 128 studies estimates mean relative fitness of antibiotic-resistant mutants at 0.880 (95 % CI excluding 1.0; z = 129.3, p < 0.0001), with significantly lower fitness in Gram-positives (0.822) than Gram-negatives (0.973) (t = −5.19, p < 0.0001). The whole paradigm of "fitness costs limit the spread of resistance" rests on these aggregated point estimates, each of which is itself a fitted growth-rate or competition statistic with under-reported within-curve uncertainty. The CI on the field-wide mean is dominated by between-study heterogeneity, but if individual studies' fit uncertainty is systematically underestimated by ≈30 %, the funnel-plot test and the heterogeneity statistics shift substantially.

### 2. Sprouffske & Wagner 2016 — Growthcurver

> Sprouffske, K., & Wagner, A. (2016). Growthcurver: an R package for obtaining interpretable metrics from microbial growth curves. *BMC Bioinformatics*, 17, 172. **doi:10.1186/s12859-016-1016-7**

Among the most widely cited tools (≥ 1 500 citations) in growth-curve analysis. Returns r (intrinsic growth rate) and K (carrying capacity) by Levenberg–Marquardt least-squares fit. **The package does not report parameter confidence intervals in its core output**, and the bulk of downstream papers compare strains by running an ad-hoc t-test on replicate-level point estimates. This is the most concrete illustration of how miscalibrated CIs in growth-curve inference can quietly inflate false-positive rates in comparative biology — at the scale of an entire methodological pipeline.

### 3. La Rosa et al. 2021 — *P. aeruginosa* compensatory evolution

> La Rosa, R., Rossi, E., Feist, A. M., Johansen, H. K., & Molin, S. (2021). Compensatory evolution of *Pseudomonas aeruginosa*'s slow growth phenotype suggests mechanisms of adaptation in cystic fibrosis. *Nature Communications*, 12, 3186. **doi:10.1038/s41467-021-23451-y**

A rare example of bootstrap (500 reps) 95 % CIs on the fitted μ_max parameters. Reports per-strain trajectories from μ_max = 0.37 ± 0.03 /h (starting) to 1.28 ± 0.02 /h, 1.08 ± 0.02 /h, and 0.87 ± 0.02 /h. The endpoint differences are large enough to survive a 30 % CI widening, but the *per-generation comparisons within trajectories* are within ≈1.5× and would be directly sensitive. This is a useful "well-behaved" exemplar to contrast with weaker uncertainty reporting elsewhere.

### 4. Pennone et al. 2021 — omnibus Baranyi modelling for *L. monocytogenes*

> Pennone, V., Dygico, L. K., Bourke, P., Brodkorb, A., & Fanning, S. (2021). Omnibus modelling of *Listeria monocytogenes* growth rates at low temperatures. *Foods*, 10(5), 1099. **doi:10.3390/foods10051099**

Reports μ_max with proper 95 % CI under mixed-effects framework: 0.0410 (CI 0.0364–0.0459) /h at 4.5 °C up to 0.1126 (CI 0.1049–0.1480) /h at 12 °C. The authors **explicitly argue that the omnibus framework produces wider CIs than the more common sequential primary-then-secondary approach**, and that those wider CIs are the correct ones for shelf-life predictions. This is the closest paper in our list to the methodological point we want to make, and a strong supporting citation for our paper.

### 5. Chowdhury et al. 2023 — fitness cost of omadacycline resistance

> Chowdhury, F. R., et al. (2023). Fitness costs of antibiotic resistance impede the evolution of resistance to other antibiotics. *ACS Infectious Diseases*, 9(10), 1834–1846. **doi:10.1021/acsinfecdis.3c00156**

The central finding — "fitness costs impede further resistance evolution" — rests on AUC of fitted growth curves: the resistant mutant has AUC ≈ 8× lower than WT and stationary OD ≈ 5× lower; an evolved-recovery line has AUC ≈ 5× above the resistant parent. Uncertainty reported as SEM (N = 16) only — no formal CI on AUC or μ_max. The 8× / 5× contrasts are large enough that the qualitative claim is robust, but **intermediate comparisons in the data** (e.g. between independently evolved recovery lines) hover near p < 0.01 thresholds where CI inflation is directly load-bearing.

## Patterns observed across the 18 papers

**Reporting of parameter uncertainty.** Of 18 papers reviewed:

- **3 papers report formal 95 % CIs on fitted μ_max / K / lag** as the primary measure of uncertainty (Pennone 2021, La Rosa 2021, Pedreira 2022). Pennone and La Rosa use mixed-effects + bootstrap respectively; Pedreira uses Hessian-based CI from MLE — and shows some CIs *wider than the point estimate*, already evidence of identifiability problems.
- **5 papers report only standard deviation or standard error across replicates** of the fitted point estimate (Chowdhury 2023, Cheng 2019, Hitomi 2024, Choi 2020, Alonso-del Valle 2021). This is the modal practice in the experimental-evolution and knockout literatures.
- **7 papers report only point estimates with significance flags from t-tests / ANOVA** on replicate-level data (Lindqvist 2006, von Groll 2010, Lambert 2000, Luo 2015, Theophel 2014, the rifampicin-resistant strain literature, plus several smaller studies). No CI on the underlying fitted parameter at all.
- **3 papers are aggregate / methods / meta-analyses** that inherit the uncertainty practices of upstream studies (Melnyk 2015, Sprouffske 2016, Hernando-Amado 2023).

**Comparison methods.** Student's t-test or one-way ANOVA on replicate-level point estimates dominates (12/18). Two papers use nonlinear mixed-effects modelling. One uses Mann–Whitney U. Bootstrap-based CIs are rare (1/18 explicitly).

**Magnitude of claimed effects.** Across the four domains, claimed effect sizes for growth-rate comparisons cluster in the 10–30 % range, exactly the regime where CI miscalibration matters most. La Rosa-type 3× differences are robust to widened CIs; the modal 10–20 % growth-rate-reduction claims (e.g. rifampicin-resistance, plasmid carriage, knockout sensitivity profiling) are not.

## Claims plausibly affected by 30 %-wider CIs

I'd group the 18 examples as follows (with appropriate epistemic humility — these are predictions, not guarantees):

**Likely affected (claim becomes weaker or reverses)**:
- Melnyk 2015 — between-Gram-stain difference would tighten; per-study significance calls in the underlying meta-analysis dataset would shuffle.
- North 2014 (yeast deletion sensitivity) — many borderline "hit" calls in genome-wide screens are within 10–20 % of WT growth rate; 30 % CI inflation would substantially reduce the hit list.
- Theophel 2014 — qualitative "considerably higher" claims with no formal uncertainty are most vulnerable.
- von Groll 2010 — quantitative ranking of 21 M. tuberculosis isolates would reshuffle even if the "MDR is slowest" headline survives.
- Cheng 2019 — apparent decoupling of yield and growth rate (the two-dimensional tradeoff claim) is most sensitive to underestimated parameter correlation.
- Hitomi 2024 — 8-of-9 significance claim is at the edge.

**Likely unaffected (effect size large)**:
- La Rosa 2021 endpoint comparisons (3× differences).
- Chowdhury 2023 main AUC comparisons (5–8× differences).
- Pennone 2021 cross-temperature comparisons (3× differences).

**Negative-result claims that go the *other* way** — papers concluding "no significant difference" (Choi 2020 colistin growth rate) become *more* confident (Type II error rate rises), which is its own miscalibration story but in the opposite direction.

## Notes on uncertainty in this review

- A handful of citation counts were not visible on the rendered pages I could access; I left those approximate. The TSV reflects what I could verify.
- The "rifampicin-resistant strains grow 10–20 % slower" entry in the TSV is a *class* of claims surfaced in the search results rather than a single paper — I included it as a placeholder for that family of comparisons because they are exactly the regime our paper targets.
- The full TSV is at `/home/aivuk/misspec-study/literature_review/raw_results/04_comparative_claims.tsv`.
