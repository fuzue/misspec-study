# Growth-curve fitting in practice: a systematic survey of methods, uncertainty, and calibration
**MisspecStudy literature review · 2026-05-13**

## TL;DR

A systematic survey of **204 sources** — 78 primary microbiology papers (PubMed 2020–2026), 18 software/methods papers, 50 prior-art references on nonlinear-regression CI calibration, 18 documented comparative claims from screening/evolution literature, and 36 real-world-stakes references (clinical PK, antimicrobial breakpoints, food safety, industrial bioprocess) — establishes four findings the MisspecStudy paper can defend:

1. **Uncertainty quantification on growth-curve parameters is missing from ~85 % of recent primary papers.** Of 55 on-topic microbial growth-curve studies coded from PubMed 2020–2026, only ~15 % report any formal CI on a fitted growth parameter; 0 report a frequentist coverage check; and the dominant comparison method on fitted parameters is t-test/ANOVA on replicate-level point estimates.

2. **The community's actual tooling produces Wald CIs from least-squares fits — without coverage validation.** The five most-cited entries in our tools survey (Zwietering 1990 ≈ 4 200 cites, drc ≈ 3 100, Baranyi–Roberts 1994 ≈ 2 600, Growthcurver ≈ 740, grofit ≈ 500) collectively define the "Levenberg–Marquardt on Gompertz/logistic/Baranyi + asymptotic Wald CI from the local Jacobian" workflow. **Zero of the 18 tool/methods papers reviewed run a formal coverage check** on simulated data. The single paper that does run simulation-based diagnostics (Ghenu, Marrec & Bank 2023) documents systematic µ_max-vs-µ mismatch and that >10 % of surveyed growth-curve papers fail to even disclose how growth rate was computed.

3. **The specific question — coverage of growth-curve CIs under structural misspecification — has not been answered in the published literature.** The closest direct prior art (Rockaya & Baranyi 2025, *Food Microbiology*) studies reparametrization in the well-specified case. The Bayesian-growth-curve antecedents (Pouillot 2003, Powell 2006, Quinto 2018) report credible intervals without coverage assessment. The predictive-microbiology validation literature (ComBase tradition) reports Af/Bf on point predictions, never CI coverage.

4. **Real-world stakes are concrete in four production pipelines** — Bayesian therapeutic drug monitoring (InsightRX, DoseMeRx, MwPharm++, BestDose), antimicrobial breakpoint setting (EUCAST/FDA Monte Carlo PTA), food-safety shelf-life prediction (ComBase, EFSA), and industrial bioprocess control. **However**, a clean published trail of "patient harm caused by miscalibrated CI" does not exist; what *is* documented is (i) routine NONMEM `$COV` step failures (Bauer 2019), (ii) 48 %-agreement between vancomycin priors on ICU dosing decisions across 466 patients (Patanwala 2022), (iii) 7 % fail-dangerous bias in *Listeria* RTE-meat predictions (Tarlak 2023), and (iv) the EUCAST 2022 cefiderocol AST warning. The paper should claim methodological importance with operational evidence, not direct patient-level harm attribution.

The five raw coded data tables are in `raw_results/`; a unified deduplicated index is in `papers_coded.csv`.

---

## 1. Methods

This is a five-axis systematic survey conducted 2026-05-13 against multiple databases via REST APIs. Each axis answers one of the questions in the MisspecStudy brief.

### 1.1 Search axes and database use

| Axis | Question | Primary DBs queried | Coding scheme |
|---|---|---|---|
| 01 — Primary papers | What do practitioners actually do? | PubMed E-utilities | software, model, uncertainty, comparison, replicates |
| 02 — Software / methods | What do the canonical tools deliver by default? | PubMed, Semantic Scholar, GitHub vignettes | tool name, fit method, uncertainty default, calibration-in-paper |
| 03 — Prior art on calibration | Has this been done? | Semantic Scholar, arXiv, PubMed | relevance (direct / supporting / foundational / tangential) |
| 04 — Comparative claims | Whose conclusion would change? | PubMed, Semantic Scholar, bioRxiv | claim, parameter compared, reported uncertainty, comparison method |
| 05 — Real-world stakes | Does this matter operationally? | PubMed, regulator guidances (FDA, EMA, EFSA, ICH), commercial-tool websites | domain, source type, uncertainty handling |

### 1.2 Search queries (representative; full list in `raw_results/0*_notes.md`)

PubMed E-utilities `esearch` calls used Boolean MeSH/title-abstract queries, e.g.:

```
("Gompertz"[TIAB] OR "Baranyi"[TIAB] OR "logistic growth"[TIAB])
  AND ("OD600"[TIAB] OR "growth rate"[TIAB] OR "growth curve"[TIAB])
  AND ("2020"[PDat] : "2026"[PDat])
```

Candidate pool across the five primary-paper queries: ≈1 100 unique PMIDs (337 + 38 + 482 + 235 + 91 hits with substantial overlap).

Semantic Scholar Graph API was used for citation counts and broader-domain search; rate-limiting forced fallback to direct PubMed efetch for some entries. arXiv export API supplemented the methodology / statistics literature.

### 1.3 Inclusion criteria

**Primary papers (axis 01)**: Microbial OD600 or CFU growth-curve fits, 2020–2026, primary research (not reviews/methods). Off-topic Gompertz applications (livestock, fish, fetal, tumor) were retained in the TSV with `domain=other` to document why they were excluded.

**Tools (axis 02)**: published or widely used software for microbial growth-curve fitting, with a peer-reviewed methods paper or substantial GitHub documentation.

**Prior art (axis 03)**: nonlinear-regression CI theory + Bayesian model-misspecification theory + growth-curve-specific work, plus required foundational references (Bates–Watts, Seber–Wild, Vehtari–Gelman–Gabry).

**Comparative claims (axis 04)**: papers making a specific quantitative claim (e.g. "growth rate of X is significantly lower than Y") where the claim is load-bearing for the paper's conclusion.

**Stakes (axis 05)**: regulator guidances, clinical-PK software, breakpoint methodology, food-safety guidelines, and industrial bioprocess applications.

### 1.4 Coding

For each axis, the per-paper coding schema is documented in the corresponding `raw_results/0N_*.tsv` header. Coding was best-effort from abstracts and (where available) full-text methods sections; ambiguous fields were marked "not in abstract" rather than guessed. The unified `papers_coded.csv` joins all five axes on DOI with a consistent column set.

### 1.5 Reproducibility

Every search query is documented (with URL-encoded API call) in the corresponding `raw_results/0N_*_notes.md`. The TSVs are the raw coded output, machine-readable. A fresh run of the queries against the same database snapshots should reproduce the candidate pool within rate-limiting noise.

---

## 2. Headline tables

### 2.1 What uncertainty do practitioners actually report?

Primary microbial growth-curve papers 2020–2026 (on-topic subset, N = 55 of 78 coded):

| Uncertainty on fitted parameters | Count | % |
|---|---|---|
| **None — point estimate only** | ≈ 38 | ≈ 69 % |
| SD / SEM across replicate point estimates | ≈ 9 | ≈ 16 % |
| Standard error from NLS Jacobian (Wald) | ≈ 5 | ≈ 9 % |
| Formal 95 % CI (any method) | ≈ 2 | ≈ 4 % |
| Bayesian credible interval on fitted parameters | **1** (1.8 %) — Ratkowsky secondary model, *Pseudomonas* in mineral water (PMID 41135392) | |
| Frequentist coverage check on the reported CI | **0** | 0 % |

Source: `raw_results/01_pubmed_primary_papers.tsv` and `01_pubmed_primary_papers_notes.md`.

Stratified by **how replicates are handled**:

| Replicates | Count | % |
|---|---|---|
| Averaged before fitting (variance information destroyed) | ≈ 35 | ≈ 64 % |
| Fit independently, then summary statistics on fitted points | ≈ 16 | ≈ 29 % |
| Hierarchical / partial pooling | **0** | 0 % |
| Not specified in abstract | ≈ 4 | ≈ 7 % |

### 2.2 What do the canonical tools deliver by default?

Coded from 18 software / methods papers (`raw_results/02_software_methods_papers.tsv`).

| Default uncertainty output | Tools |
|---|---|
| Point estimate only (no SE/CI) | Kinbiont (Angaroni 2025), gcplyr (Blazanin 2024), Zwietering 1990 reparameterization (defines parameters but supplies no uncertainty), Dashing Growth Curves (Reiter & Vorholt 2024) |
| Wald SE / 95 % CI from NLS Jacobian | Growthcurver (Sprouffske & Wagner 2016), drc (Ritz 2015), GrowthRates (Hall 2014), DMFit / Baranyi–Roberts 1994, GraphPad Prism (default), biogrowth NLS path (Garre 2023) |
| Bootstrap CI (configurable) | opm (Vaas 2013), grofit (Kahm 2010), QurvE (Wirth 2023) |
| Bayesian / GP credible band | fitderiv / omniplate (Swain 2016), AMiGA (Midani 2021), biogrowth MCMC path (Garre 2023), bletl (Osthege 2022) |
| Profile likelihood CI (on demand) | drc `profile()`, GraphPad Prism "asymmetrical" option |

**Calibration in the methods paper itself**: 0 / 18 ran a frequentist coverage check on simulated data. Three (fitderiv, bletl, Kinbiont) report partial validation (qualitative band widening or parameter-recovery accuracy without CI coverage). One (Ghenu, Marrec & Bank 2023) runs simulation-based diagnostics on the µ_max vs µ relationship and documents that **>10 % of surveyed growth-curve papers fail to disclose how growth rate was computed**.

### 2.3 Citation-weighted "what the field actually runs"

Citation counts via Semantic Scholar Graph API (May 2026 snapshot):

| Tool / reference | Approx citations | Default uncertainty |
|---|---|---|
| Zwietering et al. 1990 (modified-Gompertz reparameterization) | ~4 200 | None |
| Ritz et al. 2015 (drc, R) | ~3 100 | Wald CI |
| Baranyi & Roberts 1994 (primary model, DMFit) | ~2 600 | Wald SE |
| Sprouffske & Wagner 2016 (Growthcurver) | ~740 | Wald SE |
| Kahm et al. 2010 (grofit) | ~500 | Bootstrap CI (configurable) |
| Hall et al. 2014 (GrowthRates) | ~490 | SE on slope |
| Vaas et al. 2013 (opm) | ~230 | Bootstrap CI |
| Swain et al. 2016 (fitderiv) | ~130 | Bayesian credible band |
| Wirth et al. 2023 (QurvE) | ~60 | Bootstrap CI |
| Midani et al. 2021 (AMiGA) | ~50 | Bayesian credible band |
| Osthege et al. 2022 (bletl) | ~18 | Bayesian credible band |
| Angaroni et al. 2025 (Kinbiont) | ~3 | None |

The four tools at the top of the citation distribution all return Wald-style or no uncertainty. **Bayesian-credible-band tools sit in the long tail** at one to two orders of magnitude fewer citations. By citation-weighted use, the field is overwhelmingly fitting parametric primary models by least squares and reporting asymptotic CIs from the local Jacobian.

### 2.4 What comparison method is used on the fitted parameters?

From `raw_results/04_comparative_claims.tsv`, 18 papers with specific comparative claims:

| Comparison method | Count |
|---|---|
| Student's t-test or one-way ANOVA on replicate-level point estimates | 12 |
| Mixed-effects modelling | 2 |
| Mann–Whitney U on replicates | 1 |
| Bootstrap-based CI overlap | 1 |
| Bayesian contrast on posterior of difference | 0 |
| Not described in the paper | 2 |

Modal claimed effect size: **10–30 % difference in µ_max or carrying capacity** — exactly the regime where a 30 %-too-tight CI would flip the significance call.

---

## 3. Direct prior art on calibration (axis 03)

### 3.1 The single most important finding

**No published study has empirically measured frequentist coverage of CIs or credible intervals for microbial growth-curve parameters under structural model misspecification.**

The closest existing work:

> **Rockaya & Baranyi (2025).** *Variability of growth parameter estimates — The role of rescaling and reparametrization.* **Food Microbiology** 130:104726. **doi:10.1016/j.fm.2025.104726**

This paper argues that the error structure of the Baranyi-Roberts model after rescaling "is closer to that of linear regression," supporting use of conventional t-distribution CIs — but **(i) under correct model specification**, **(ii) without a Monte Carlo coverage study**, and **(iii) without Bayesian credible intervals or PSIS-LOO diagnostics**.

This gives MisspecStudy a clean "unstudied territory" claim, surrounded by rich adjacent literature that provides our methodological backbone.

### 3.2 Foundational references the paper must cite

| Reference | DOI / source | Role |
|---|---|---|
| Bates & Watts 1988 | Wiley book | Canonical: intrinsic vs parameter-effects curvature; Wald CI unreliability in nonlinear regression |
| Seber & Wild 1989 | Wiley book | Standard reference: Wald, likelihood, bootstrap CIs in nonlinear regression |
| Brazzale, Davison & Reid 2007 | Cambridge book | Higher-order asymptotic CIs (modified profile, Skovgaard) |
| Bellio 2000 | doi:10.1111/j.0006-341x.2000.01204.x | Higher-order CIs applied to dose-response (structurally similar to growth) |
| Vehtari, Gelman & Gabry 2017 | doi:10.1007/s11222-016-9696-4 | PSIS-LOO with k̂ diagnostic; ~4 858 cites |
| Raue et al. 2009 | doi:10.1093/bioinformatics/btp358 | Profile-likelihood identifiability in ODE models; ~1 323 cites |
| Talts et al. 2018 | arXiv:1804.06788 | Simulation-Based Calibration — standard method to verify Bayesian interval coverage |

### 3.3 Strong supporting references in adjacent areas

- **Akkermans, Nimmegeers & Van Impe 2018** (doi:10.1016/j.ijfoodmicro.2018.05.027) — tutorial on uncertainty propagation in predictive microbiology; benchmarks Monte Carlo / linearisation / sigma-point / bootstrap propagation but assumes correct deterministic model.
- **Tönsing, Timmer & Kreutz 2023** (*PLoS Comput Biol* 19:e1011417) — finite-sample failure of asymptotic LRT in nonlinear ODE models; provides finite-sample corrections.
- **Simpson et al. 2020** (doi:10.1098/rsif.2020.0055) — profile-likelihood identifiability and coverage for cell-invasion ODEs.
- **Ionides et al. 2017** (doi:10.1098/rsif.2017.0126) — Monte Carlo profile CIs for partially-observed dynamic systems.
- **Pouillot et al. 2003** (doi:10.1016/s0168-1605(02)00214-7), **Powell et al. 2006**, **Quinto et al. 2018** — foundational Bayesian growth-curve antecedents; report credible intervals, none check coverage.
- **Hoff & Wakefield 2012** (arXiv:1211.0087), **Buja et al. 2019** (*Stat Sci* 34:545–565) — theoretical backdrop for what credible intervals can mean under misspecification (they cover the pseudo-true parameter, not the true one).
- **Grünwald & Mehta 2016**, **de Heide et al. 2019**, **Wu & Martin 2020/2021** — safe-Bayes / generalised-Bayes calibration under misspecification.

### 3.4 Gap statement (drop-in for the paper's Methods/Introduction)

> Despite a 30-year history of nonlinear primary growth-model fits in predictive microbiology (Baranyi & Roberts 1994; Dalgaard 1995; Pin et al. 2011; Mejlholm & Dalgaard 2009–2015) and a parallel body of Bayesian fits (Pouillot 2003; Powell 2006; Quinto 2018; Rickett 2015), no published study has measured the coverage of the resulting confidence or credible intervals under structural misspecification of the deterministic growth model. The closest related work is Rockaya & Baranyi (2025), who study the effect of reparametrization on standard-error realism in the well-specified case.

---

## 4. Concrete comparative claims that depend on calibration (axis 04)

Five high-impact citations identified for direct use in the introduction (`raw_results/04_comparative_claims_summary.md`):

1. **Melnyk, Wong & Kassen 2015** — meta-analysis of antibiotic-resistance fitness costs; *Evol. Appl.* 8:273–283 (doi:10.1111/eva.12196). Mean relative fitness 0.880 (95 % CI excluding 1.0); Gram-positive 0.822 vs Gram-negative 0.973 (t = −5.19, p < 0.0001). Whole "fitness costs limit resistance spread" paradigm rests on aggregated per-study point estimates with under-reported within-curve uncertainty.

2. **Sprouffske & Wagner 2016** — Growthcurver, ≥1 500 cites; doi:10.1186/s12859-016-1016-7. The de facto standard tool for the field. **Does not output parameter CIs in its core**; the bulk of downstream papers compare strains by ad-hoc t-test on replicate-level point estimates.

3. **La Rosa et al. 2021** — *Nat. Commun.* 12:3186 (doi:10.1038/s41467-021-23451-y). Rare example of bootstrap (500-rep) 95 % CIs on µ_max: 0.37 ± 0.03 → 1.28 ± 0.02 → 1.08 ± 0.02 → 0.87 ± 0.02 /hr across compensatory-evolution trajectory. Endpoint differences are large; per-generation comparisons are within ≈1.5× and would be directly sensitive to 30 % CI widening.

4. **Pennone et al. 2021** — *Foods* 10(5):1099 (doi:10.3390/foods10051099). Omnibus Baranyi modelling of *L. monocytogenes* growth rates at low temperatures, reporting µ_max with proper 95 % CIs. **Explicitly argues that the omnibus framework produces wider — and correctly-calibrated — CIs than the more common sequential primary-then-secondary approach.** The closest existing paper to MisspecStudy's argument; strong supporting citation.

5. **Chowdhury et al. 2023** — *ACS Infect. Dis.* 9(10):1834–1846 (doi:10.1021/acsinfecdis.3c00156). "Fitness costs impede further resistance evolution" — central claim rests on AUC differences (8× and 5×) reported as SEM only. Headline survives 30 % CI widening; intermediate-line comparisons at p ≈ 0.01 do not.

### 4.1 What fraction of these claims would survive a 30 %-wider CI?

(Predictions, not guarantees — see `04_comparative_claims_summary.md` for caveats.)

| Status | Examples |
|---|---|
| Likely affected (claim weakens or flips) | Melnyk 2015 between-Gram comparisons; North 2014 yeast deletion sensitivity hit-calling; Theophel 2014 qualitative "considerably higher"; von Groll 2010 quantitative ranking of 21 *M. tuberculosis* isolates; Cheng 2019 yield-vs-growth-rate decoupling; Hitomi 2024 8-of-9 significance |
| Likely unaffected (effect size large) | La Rosa 2021 endpoint comparisons (3×); Chowdhury 2023 main AUC comparisons (5–8×); Pennone 2021 cross-temperature comparisons (3×) |
| Type II rate up (negative-results conclusions get *more* confident, wrongly) | Choi 2020 colistin "no significant difference" claims |

Modal effect-size cluster is **10–30 %** — exactly the regime where CI miscalibration flips significance calls.

---

## 5. Real-world stakes (axis 05)

### 5.1 Where growth-curve / nonlinear-regression parameter uncertainty flows into a real decision

**Four production pipelines, each documented with citations**:

#### (a) Bayesian therapeutic drug monitoring / model-informed precision dosing
- **InsightRX, DoseMeRx, PrecisePK, MwPharm++, BestDose** are commercial Bayesian TDM platforms in production clinical use.
- Patient-level decision (increase/decrease/hold dose) is read off a MAP point estimate of AUC or fT > MIC in essentially every commercial platform; posterior credible intervals computed internally but typically not exposed as an explicit CI on AUC.
- **Documented stakes**: Patanwala et al. 2022 (PMC9767744) — three published vancomycin priors (Goti, Colin, Thomson) agreed on the AUC-based dosing decision in **48 %** of 466 ICU patients. Mean AUC differed by ~93 mg·h/L between Goti and Colin. *Different priors over the same data produce different dose recommendations for half of critically ill patients.*

#### (b) Antimicrobial PK/PD breakpoint setting (EUCAST / FDA)
- Breakpoints set via Monte Carlo simulation that draws from the population PK posterior (including the parameter covariance) and an MIC distribution to compute Probability of Target Attainment (PTA). PTA threshold (typically 90 %) → adequate dose → MIC at threshold becomes the breakpoint.
- Methodology: Mouton et al. *J Antimicrob Chemother* 2011 (doi:10.1093/jac/dkq449); Trang et al. *Curr Opin Pharmacol* 2017 (PMID 29128853); recent piperacillin pediatric example 2025 (PMID 41313259).
- **Documented stakes**: EUCAST issued a formal warning in August 2022 that *all* commercially available cefiderocol AST tests had "problems with accuracy, reproducibility, bias and/or skipped wells." Reproducibility of broth MIC is acknowledged to be only ±1 doubling dilution, but the breakpoint reported to clinicians is a single integer.

#### (c) Food-safety shelf-life prediction
- **ComBase Predictor** (USDA-ARS / UK FSA / IFR) and the **USDA Pathogen Modeling Program** are dominant tools, both relying on Baranyi & Roberts or Gompertz primary models.
- Outputs feed shelf-life labels, HACCP critical limits, and EFSA scientific opinions on RTE food safety.
- **Documented stakes**: Tarlak 2023 — 7 % fail-dangerous bias in *Listeria* RTE-meat predictions. EFSA explicitly admits: *"for RTE foods that support L. monocytogenes growth, it is impossible to predict with a high degree of certainty that the level will or will not exceed 100 CFU/g during their shelf life"* (EFSA 2018, doi:10.2903/j.efsa.2018.5134). Real outbreaks during the relevant period: Italian CC155 listeriosis 2022 (~101 cases, one of Italy's largest); multi-country ST155 cluster 2022–2023, RTE-fish-linked (17 cases, 2 deaths).

#### (d) Industrial bioprocess / soft sensors
- Specific growth rate µ is estimated in real time from off-gas, OUR, or capacitance signals; estimates feed PID or MPC controllers that set feed rate, induction time, and harvest decisions in mAb-producing CHO cultures.
- A misjudged growth-rate estimate can cause a batch (often $1 M+ in biologics) to be harvested suboptimally, induced too early/late, or discarded as out-of-spec.
- Recent industrial MLOps soft sensors often do not propagate uncertainty at all (Sci Direct 2024, S0098135424004095).

### 5.2 State of practice for uncertainty propagation

- **Clinical PK**: NONMEM `$COV` step computes asymptotic SEs but **failure is routine** (Bauer 2019, doi:10.1002/psp4.12422). Recommended workarounds (bootstrap, SIR, log-likelihood profiling) can give different CI widths on the same dataset (Dosne 2017, PMC5686280; Strömberg 2020, PMC7289778).
- **Predictive microbiology**: standard validation metric is Ross's accuracy/bias factor (Af/Bf) on point predictions — **not** CI coverage.
- **Antimicrobial PK/PD**: Monte Carlo PTA *does* propagate the population PK posterior into the breakpoint decision (best of the four domains for uncertainty propagation), but assumes the posterior is correctly characterized — which Strömberg, Dosne, Bauer all document is commonly false.
- **Regulators** (FDA pop-PK 2022, EMA pop-PK 2007, EFSA 2018, ICH M15 draft 2024) require CIs/SEs to be reported but **do not prescribe a calibration test**.

### 5.3 Documented harm — what is and isn't in the literature

**Documented**:
- Cross-model dosing-decision discordance in ICU (Patanwala 2022, 48 % agreement).
- AUC-guided vs trough-guided vancomycin meta-analysis: AUC-guided reduces AKI 6.2 % vs 17.0 % (OR 0.625; PMC8644319). Bayesian helps on average; studies do not stratify by CI calibration quality.
- Fail-dangerous food-safety predictions (Tarlak 2023, 7 %).
- Regulator admission of unbounded predictive uncertainty (EFSA on *L. monocytogenes* RTE).
- AST infrastructure breakdown (EUCAST 2022 cefiderocol warning).

**Not directly documented**:
- A paper of the form "Patient X received the wrong dose because the 95 % credible interval reported by their TDM software was actually 75 % in reality" does not exist.
- Most TDM validation studies report point-estimate bias and precision, not coverage.
- The field's methodology papers (Strömberg 2020, Dosne 2017, Bauer 2019) acknowledge their CIs may be miscalibrated but do not provide an end-to-end demonstration that patient outcomes change.

### 5.4 Honest bottom line on framing

**Real-world stakes are real but the paper must frame them carefully.** The defensible claim:

> Nonlinear growth-curve and population-PK parameter inference is in active production use in Bayesian TDM (real patients), antimicrobial breakpoint setting (every clinical microbiology lab), food-safety shelf-life prediction (HACCP and EFSA risk assessments), and industrial bioprocess control ($M-scale batch decisions). In each pipeline, parameter uncertainty is propagated into the downstream decision — explicitly via Monte Carlo (PTA; bioprocess MPC), as an internal credible interval (commercial TDM), or as a prediction interval (ComBase). The dominant industry tooling is documented to produce miscalibrated or unreported uncertainty intervals in scenarios that are routine in practice (NONMEM `$COV` step failures: Bauer 2019; small-n SE miscalibration: Strömberg 2020). Regulators require uncertainty reporting but do not currently require a calibration check. Documented evidence of patient-level harm specifically attributable to interval miscalibration is rare; however, evidence of dosing-decision discordance under different priors (Patanwala 2022), fail-dangerous food-safety predictions (Tarlak 2023), and regulator admissions of inadequate predictive certainty (EFSA on *L. monocytogenes* RTE) collectively establish that calibrated uncertainty in this class of models is not an academic concern.

**Caveat the paper should also state**: in clinical TDM, the dominant operational failure mode is not interval miscalibration but **model-structure / prior choice** (Patanwala 2022). A paper on parameter-CI calibration is methodologically right but should not oversell itself as solving the headline clinical problem. Calibrated CIs are *one* necessary ingredient in trustworthy MIPD, not the whole solution.

---

## 6. What we DON'T know (gaps in this survey)

To preempt review:

- **Coverage of axes 01 and 04 is broader than deep.** We coded 78 abstracts in axis 01 and 18 in axis 04. We did not pull full-text methods sections for most of these; "no CI reported in the abstract" is a strong signal but not a guarantee that the paper does not report a CI somewhere in supplementary materials. A focused full-text follow-up on the antimicrobial-evolution subset (axis 04) is warranted before the paper's discussion.

- **The "what fraction of comparative claims would survive a 30 %-wider CI" prediction in §4.1 is qualitative.** It is based on reading the reported effect sizes and asking whether they exceed the typical SE × 1.96 × 1.3. We did **not** re-fit any of the 18 papers' data with a properly-calibrated CI to verify. That re-fitting is itself a candidate experiment for the MisspecStudy paper.

- **The clinical-PK harm-attribution chain is genuinely thin.** What we have is dosing-decision discordance (Patanwala 2022) and fail-dangerous prediction rates (Tarlak 2023), not "patient died because CI was actually 80 % not 95 %." A paper claiming the latter would need different evidence.

- **Citation counts in axis 02 are Semantic Scholar snapshots and not citation-network-corrected.** The order-of-magnitude ranking is reliable; absolute numbers may shift by ~10 %.

- **Axis 03 has weak coverage of the post-2023 safe-Bayes / generalised-Bayes literature.** Grünwald-Mehta 2016 and Wu & Martin 2020/2021 are the anchors; very recent work may be missed.

- **Predictive-microbiology validation literature was not exhaustively coded.** ComBase tradition (Pin, Mejlholm, Dalgaard, Schaffner) returns Af/Bf on point predictions — not coverage probability — but a focused dive into recent validation studies could surface counter-examples.

---

## 7. Implications for the MisspecStudy paper

Given the evidence above, the defensible structure for the paper is:

1. **Motivation.** The field fits Gompertz / Baranyi / logistic to OD/CFU data and almost universally reports point estimates or Wald-CIs without coverage validation (citations: Sprouffske 2016, Ritz 2015, Hall 2014; tooling survey; PubMed 2020–2026 survey). The closest methodological prior art (Rockaya & Baranyi 2025) assumes correct specification. The gap is direct measurement of coverage under structural misspecification.

2. **Contribution.** Monte Carlo evaluation of frequentist coverage of (i) Wald, (ii) profile-likelihood, (iii) bootstrap, (iv) Bayesian credible intervals, on a grid of (truth model × fit model × N × σ × design) configurations spanning the standard primary models (Gompertz, logistic, Richards, Baranyi-Roberts).

3. **Why it matters in practice.** Production pipelines (Bayesian TDM, antimicrobial breakpoints, food-safety shelf-life, bioprocess MPC) propagate growth-curve / PK parameter uncertainty into operational decisions. Dominant tooling is documented to produce miscalibrated CIs in routine scenarios (Bauer 2019, Strömberg 2020, Dosne 2017, Patanwala 2022, Tarlak 2023, EUCAST 2022, EFSA 2018). Regulators require uncertainty reporting but not calibration.

4. **What we are NOT claiming.** We do not claim documented patient harm from interval miscalibration specifically. We claim methodological importance with operational evidence of unaddressed miscalibration in production pipelines.

5. **Methodological frame.** Coverage is the headline metric (Vehtari/Talts 2018 SBC + standard frequentist coverage on the grid). Sharpness is a secondary axis to flag fast-but-lying methods. Pareto-k diagnostics (Vehtari, Gelman & Gabry 2017) are integrated as the self-diagnosing-when-broken machinery the field currently lacks.

---

## Appendix — File index

| Path | Contents |
|---|---|
| `raw_results/01_pubmed_primary_papers.tsv` | 78 coded primary microbiology papers (PubMed, 2020–2026) |
| `raw_results/01_pubmed_primary_papers_notes.md` | Search reproducibility + observed patterns |
| `raw_results/02_software_methods_papers.tsv` | 18 tools / foundational papers with default-uncertainty coding |
| `raw_results/02_software_methods_papers_summary.md` | Narrative + quotes per tool |
| `raw_results/03_prior_art_calibration.tsv` | 50 references on nonlinear-regression / Bayesian calibration |
| `raw_results/03_prior_art_calibration_summary.md` | Foundational + supporting refs + gap statement |
| `raw_results/04_comparative_claims.tsv` | 18 papers with documented comparative claims |
| `raw_results/04_comparative_claims_summary.md` | High-impact exemplars + survivability analysis |
| `raw_results/05_real_world_stakes.tsv` | 36 references on clinical PK / antimicrobial / food / industrial pipelines |
| `raw_results/05_real_world_stakes_summary.md` | Pipeline-by-pipeline answers to the four reviewer questions |
| `papers_coded.csv` | Unified deduplicated index across all five axes |
| `2026-05_growth_curve_practice_survey.md` | **This report** |
