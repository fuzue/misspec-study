# Real-World Stakes of Miscalibrated Growth-Model / PK Parameter Uncertainty

This summary answers the four reviewer-grade questions directly, with citations attached to every claim. Source TSV: `05_real_world_stakes.tsv` (37 entries across four domains).

---

## 1. In which real-world decision pipelines does growth-curve / nonlinear-regression parameter uncertainty flow into a downstream choice?

There are at least four concrete pipelines where nonlinear parameter inference is not a back-of-the-paper exercise but feeds an operational, billable, or regulatorily-binding decision.

### 1a. Bayesian therapeutic drug monitoring (TDM) / model-informed precision dosing (MIPD)

- **InsightRX, DoseMeRx, PrecisePK, MwPharm++, BestDose** are the commercial Bayesian TDM platforms in production clinical use. They fit a population PK model (which is a nonlinear regression with random effects) and a patient-specific posterior, then recommend a dose.
  - InsightRX: <https://www.insight-rx.com/>; DoseMeRx: <https://doseme-rx.com/>
- The patient-level decision is "increase the dose / decrease the dose / hold." That decision is read off a Maximum A Posteriori (MAP) point estimate of AUC or fT>MIC in essentially every commercial platform. Posterior credible intervals are computed internally but typically only surfaced as a graphical band on the concentration-time curve, not as an explicit credible interval on AUC. See discussion of MAP-vs-full-posterior tradeoffs in Goutelle et al. 2022 (<https://accp1.org/pdfs/documents/STEP/3_Goutelle-et-al-2022-Parametric-vs-non-parametric-Pop-PK.pdf>).
- **Concrete documented stakes**: Patanwala et al. (2022, Crit Care Res Pract; PMC9767744) compared three published vancomycin pop-PK priors (Goti, Colin, Thomson) on 466 ICU patients. All three models agreed on the AUC-based dosing decision in only **48%** of cases. Mean AUC differed by ~93 mg·h/L between Goti and Colin. *Different priors over the same data produce different dose recommendations for roughly half of critically ill patients.* <https://pmc.ncbi.nlm.nih.gov/articles/PMC9767744/>
- **Patient-level harm pathway**: Drennan et al. demonstrated that misspecified time-stamps and PK models "falsely overestimated time above MIC when true T>MIC was less than 0.4, putting patients at risk of undertreatment." <https://pmc.ncbi.nlm.nih.gov/articles/PMC7063976/>

### 1b. Antimicrobial PK/PD breakpoint setting and dose recommendation (EUCAST / FDA / Monte Carlo simulation)

- **EUCAST and FDA antibiotic breakpoints** are set via Monte Carlo simulation that draws from a population PK posterior (including the parameter covariance) and an MIC distribution to compute **Probability of Target Attainment (PTA)** for a candidate dose. The PTA crosses a threshold (typically 90%) → the dose is considered adequate → the MIC at which PTA falls below threshold becomes the breakpoint.
  - Methodology review: Mouton et al., *J Antimicrob Chemother* 2011 (<https://academic.oup.com/jac/article/66/2/227/720360>); Trang et al. *Curr Opin Pharmacol* 2017 (<https://pubmed.ncbi.nlm.nih.gov/29128853/>); recent piperacillin pediatric example 2025 (<https://pubmed.ncbi.nlm.nih.gov/41313259/>).
- **Stakes**: this directly determines (i) the dose label on the antibiotic package, (ii) which isolates are reported S/I/R to the clinician, and (iii) whether the drug is approved. Miscalibrated parameter intervals propagate directly into miscalibrated PTA, hence miscalibrated breakpoints.
- **Documented real-world breakage**: EUCAST issued a formal warning in August 2022 that *all* commercially available cefiderocol AST tests had "problems with accuracy, reproducibility, bias and/or skipped wells" (<https://www.eucast.org/warning-detail/cefiderocol-eucast-has-evaluated-august-2022-commercially-available-tests-and-all-have-problems-with-accuracy-reproducibility-bias-and-or-for-some-with-skipped-wells/>). Reproducibility of broth MIC is acknowledged to be only ±1 doubling dilution (<https://www.sciencedirect.com/science/article/pii/S1198743X14616402>) — propagating this into PTA would widen the breakpoint uncertainty band substantially, but the breakpoint reported to clinicians is a single integer.

### 1c. Food-safety shelf-life prediction (ComBase / Pathogen Modeling Program / EFSA / FDA HACCP)

- **ComBase Predictor** (USDA-ARS / UK FSA / IFR) and the **USDA Pathogen Modeling Program (PMP)** are the dominant tools for predicting microbial growth on foods. Both rely on the **Baranyi & Roberts** primary growth model (or Gompertz). <https://combase.errc.ars.usda.gov/>; <https://pmp.errc.ars.usda.gov/>
- Outputs feed into shelf-life labels, HACCP critical limits, and EFSA scientific opinions on RTE food safety. FDA HACCP guidelines specifically state that predictive-model outputs should be validated against 95% confidence intervals (<https://www.fda.gov/food/hazard-analysis-critical-control-point-haccp/haccp-principles-application-guidelines>).
- **Concrete documented stakes**: A 2023 review of *Listeria* growth predictions in RTE meat reported a **7% fail-dangerous bias** — the predictive model said growth was lower than it actually was, in 7% of validation cases (<https://www.mdpi.com/2304-8158/12/24/4461>).
- **Regulator's own admission**: EFSA writes that "for RTE foods that support L. monocytogenes growth, it is impossible to predict with a high degree of certainty that the level will or will not exceed 100 CFU/g during their shelf life" (<https://efsa.onlinelibrary.wiley.com/doi/10.2903/j.efsa.2018.5134>). Real outbreaks happened during the relevant period: Italian CC155 listeriosis outbreak 2022 (~101 cases, one of Italy's largest), multi-country ST155 cluster 2022-2023 linked to RTE fish (17 cases, 2 deaths) — <https://www.ecdc.europa.eu/en/publications-data/prolonged-multi-country-cluster-listeria-monocytogenes-st155-infections>; <https://www.sciencedirect.com/science/article/pii/S0362028X2600102X>.

### 1d. Industrial bioprocess control (soft sensors / fed-batch / MPC)

- Specific growth rate µ is estimated in real time from off-gas, oxygen-uptake-rate (OUR), or capacitance signals. Estimates feed PID or MPC controllers that set feed rate, induction time, and harvest decisions in mAb-producing CHO cultures. <https://pmc.ncbi.nlm.nih.gov/articles/PMC3755222/>; <https://pmc.ncbi.nlm.nih.gov/articles/PMC7146123/>
- Modern Kalman-filter and particle-filter formulations propagate parameter uncertainty into the state estimate; some MPC formulations use Monte Carlo on parameter uncertainty for robustness.
- **Stakes**: a misjudged growth-rate estimate can cause a batch (often $1M+ in biologics) to be harvested at suboptimal time, induced too early/late, or discarded as out-of-spec. Anomaly detection in "golden batch" frameworks (<https://www.frontiersin.org/journals/manufacturing-technology/articles/10.3389/fmtec.2024.1392038/full>) uses parameter-deviation thresholds, not calibrated CIs.
- However, recent industrial MLOps soft sensors often *do not* propagate uncertainty at all (<https://www.sciencedirect.com/science/article/abs/pii/S0098135424004095>).

---

## 2. State of practice for uncertainty propagation

### Clinical PK / pop-PK

- **NONMEM** (the dominant industry tool) computes asymptotic standard errors via the covariance step (`$COV`). **Failure of the covariance step is routine**, especially with sparse data; failure means no standard errors and no CIs are produced (<https://www.wright-dose.com/tip1.php>). Bauer (2019) is the authoritative review (<https://ascpt.onlinelibrary.wiley.com/doi/10.1002/psp4.12422>).
- Workarounds: nonparametric bootstrap (popular, computationally heavy), Sampling Importance Resampling (SIR; Dosne et al. 2016/2017 — PMC5110709, PMC5686280), log-likelihood profiling. Each can give different CI widths on the same dataset, and SIR diagnostics show that miscalibration can occur even when some diagnostic checks pass (Dosne 2017).
- For small-n pharmacometric analyses, the standard `$COV` SEs are explicitly miscalibrated and LLP-SIR is recommended (Strömberg et al. 2020 — <https://pmc.ncbi.nlm.nih.gov/articles/PMC7289778/>). **This is directly the misspec-study story.**
- Regulators (FDA pop-PK 2022 guidance — <https://www.fda.gov/media/155925/download>; EMA 2007 — <https://www.ema.europa.eu/en/reporting-results-population-pharmacokinetic-analyses-scientific-guideline>) **require** that CIs/SEs be reported but **do not** prescribe a calibration test or insist on any particular method.
- ICH M15 (draft Oct 2024, adopted Jan 2026) on Model-Informed Drug Development now explicitly endorses risk-based credibility assessment using the ASME V&V 40 framework. Uncertainty must be "accounted for" but calibration of intervals is not separately tested. <https://database.ich.org/sites/default/files/ICH_M15_EWG_Step2_DraftGuideline_2024_1031.pdf>

### Predictive microbiology / food safety

- Standard validation metrics are Ross's **accuracy factor (Af) and bias factor (Bf)** (<https://www.sciencedirect.com/science/article/pii/S0740002012001098>). These validate the **point prediction**, not the prediction interval's coverage.
- Recent ComBase work adds bootstrap-based 95% prediction intervals (2.5/97.5 percentile from aggregated bootstrap predictions). This is progress but **calibration of these intervals is rarely empirically validated**.
- EFSA's 2018 Guidance on Uncertainty Analysis (<https://www.efsa.europa.eu/sites/default/files/consultation/150618.pdf>) and Codex CXG 30 require quantitative uncertainty expression in risk assessments, but leave method choice to the assessor and do not prescribe a calibration check.

### Industrial bioprocess

- Heterogeneous: state-of-the-art academic groups use particle filters with parameter uncertainty; many production deployments use ML soft sensors that don't surface uncertainty at all.
- FDA PAT framework (2004 — <https://www.fda.gov/regulatory-information/search-fda-guidance-documents/pat-framework-innovative-pharmaceutical-development-manufacturing-and-quality-assurance>) encourages CPP variability characterization but doesn't prescribe specific uncertainty propagation methods.

### Antimicrobial PK/PD

- **Best of the four domains** for uncertainty propagation: Monte Carlo simulation drawing from the population PK posterior is *standard practice* for PTA, breakpoint setting, and dose recommendation. 10,000 iterations is typical (Mouton & Vinks 2011).
- But: the propagation assumes the underlying parameter posterior is correctly characterized. If the population PK covariance is miscalibrated (which Strömberg, Dosne, and Bauer all document is common), PTA is biased.

---

## 3. Is there documented evidence of harm from miscalibrated CIs, or is the concern speculative?

The evidence is **mixed**. There is documented harm from PK *modeling errors*, but very few studies pin the harm specifically on a *miscalibrated CI* — most cite point-estimate bias or model-structure choice. Honest reading:

### What is documented

- **Cross-model discordance with clinical consequences**: Patanwala 2022 (PMC9767744) — three published vancomycin priors disagree on the dosing decision in ~half of ICU cases. This is direct evidence that *which* model and *which* prior matters at the bedside.
- **AUC-guided vs trough-guided vancomycin**: meta-analyses show AUC-guided (Bayesian) TDM reduces AKI (6.2% vs 17.0%; OR 0.625 — <https://pmc.ncbi.nlm.nih.gov/articles/PMC8644319/>). Bayesian methods help on average, but the studies do not stratify by CI calibration quality of the underlying tools.
- **Model "fail-dangerous" in food safety**: 7% of *Listeria* predictions in RTE meat were on the unsafe side of reality (<https://www.mdpi.com/2304-8158/12/24/4461>). Real outbreaks occurred during the relevant period.
- **Regulator admits unbounded predictive uncertainty**: EFSA's own statement that confident shelf-life prediction is infeasible for *L. monocytogenes* in RTE foods (2018 opinion, doi:10.2903/j.efsa.2018.5134) is essentially an admission that current prediction intervals are not narrow or well-calibrated enough to support the decision they are being asked to support.
- **AST infrastructure breakdown**: EUCAST's 2022 cefiderocol warning is a direct example of clinical microbiology infrastructure becoming unreliable because of unaddressed uncertainty in MIC measurements.

### What is *not* directly documented

- We did not find a paper of the form "Patient X received the wrong dose because the 95% credible interval reported by their TDM software was actually 75% in reality." That granularity of attribution does not appear in the literature.
- Most TDM/MIPD validation studies report point-estimate bias and precision, or binary target-attainment outcomes — not coverage of credible intervals.
- The strongest direct claim is that **the field's own methodology papers acknowledge their CIs may be miscalibrated** (Strömberg 2020 for small-n NONMEM; Dosne 2017 for SIR; Bauer 2019 for covariance step failures) — but they then propose alternatives without an end-to-end demonstration that downstream patient outcomes change.

---

## 4. Honest bottom line — does this work have real-world stakes?

**Yes, but the framing must be careful.** Here is the fair assessment:

**The strong claim that is well-supported**: Nonlinear-regression / growth-curve parameter inference is in active production use in (a) Bayesian TDM software that prescribes doses to real patients, (b) Monte Carlo simulation that sets antibiotic breakpoints reported to every clinical microbiology lab, (c) shelf-life prediction software that informs HACCP and EFSA risk assessments, and (d) bioprocess soft sensors that decide $M-scale batch fates. None of these are toy applications. The decisions are billable, regulatorily binding, or patient-affecting.

**The strong claim that is also well-supported**: The field's own dominant tooling (NONMEM `$COV` step) is known to produce unreliable CIs in common scenarios (sparse data, small n, complex covariance structures). The recommended alternatives (bootstrap, SIR, LLP) themselves have known limitations. Citations: Bauer 2019 (PSP), Dosne 2016/2017, Strömberg 2020.

**The weaker claim that needs care**: There is *not* a clean published trail of "patient harm caused by miscalibrated CI." Harm pathways are documented, model-discordance is documented, regulator admission of inadequate predictive certainty is documented — but the chain from "the 95% CI was actually 80%" to "patient X was harmed" has not been quantified in the literature. The paper should not claim that link more strongly than the evidence supports.

**Best framing for the methodology paper**:

> "Nonlinear growth-curve and population-PK parameter inference is in active production use in Bayesian TDM, antimicrobial breakpoint setting, food-safety shelf-life prediction, and industrial bioprocess control. In each of these pipelines, parameter uncertainty is propagated into the downstream decision — explicitly via Monte Carlo simulation (antimicrobial PTA; bioprocess MPC), as a credible interval (TDM software internal representation), or as a prediction interval (ComBase, recent food-safety guidelines). The dominant industry tooling (NONMEM covariance step; ComBase point predictions; MAP-based commercial TDM displays) is known to produce miscalibrated or unreported uncertainty intervals in scenarios that are routine in practice. Regulators (FDA pop-PK guidance, EMA pop-PK guidance, EFSA uncertainty guidance, ICH M15, FDA HACCP) require uncertainty reporting but do not currently require a calibration check on the reported intervals. Documented evidence of patient-level harm specifically attributable to interval miscalibration is rare in the literature; however, evidence of dosing-decision discordance under different priors (Patanwala 2022), fail-dangerous food-safety predictions (Tarlak 2023), and regulator admissions of inadequate predictive certainty (EFSA on L. monocytogenes RTE foods) collectively establish that calibrated uncertainty in this class of models is not an academic concern."

**One more thing to be honest about**: in clinical TDM the dominant *operational* failure mode is not interval miscalibration but **model-structure choice** (which prior do you use? — Patanwala 2022). A paper on parameter-CI calibration is methodologically right but should not oversell itself as solving the headline clinical problem, which has more to do with prior selection and covariate misspecification. The honest pitch is: calibrated CIs are *one* necessary ingredient in trustworthy MIPD, not the whole solution.

---

## Citations table (most load-bearing)

| Claim | Citation |
|-------|----------|
| 48% Bayesian model agreement on ICU vancomycin dosing | Patanwala 2022, PMC9767744 |
| NONMEM `$COV` step routinely fails | Bauer 2019, doi:10.1002/psp4.12422 |
| Small-n NONMEM SEs are miscalibrated | Strömberg 2020, PMC7289778 |
| SIR is a recommended alternative | Dosne 2017, PMC5686280 |
| Cefiderocol AST tests unreliable (regulator warning) | EUCAST Aug 2022 |
| EFSA: can't confidently predict L. monocytogenes shelf life | EFSA Opinion 2018, doi:10.2903/j.efsa.2018.5134 |
| Italian ST155 listeriosis outbreaks 2022-2023 | ECDC RFA + Sci Direct cite |
| 7% fail-dangerous bias in Listeria RTE predictions | Tarlak 2023, mdpi 2304-8158/12/24/4461 |
| Monte Carlo PTA is standard for antibiotic dose selection | Mouton 2011 JAC; Trang 2017 |
| ICH M15 / ASME V&V 40 credibility framework | ICH M15 draft 2024 |
| FDA pop-PK guidance requires CI reporting (no calibration mandate) | FDA Feb 2022, fda.gov/media/155925 |
| AUC-guided vancomycin reduces AKI vs trough-guided | Aljefri 2019 meta-analysis, PMC8644319 |

All other supporting entries are in `05_real_world_stakes.tsv`.
