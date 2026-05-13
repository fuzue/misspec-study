# Prior art: calibration & coverage of CIs in growth-curve / nonlinear regression

## Headline finding

**There is no published study that empirically measures frequentist coverage of confidence or credible intervals for the parameters of microbial growth-curve fits under structural model misspecification.**

The two closest existing studies — Simpson et al. (2021, *J. Theor. Biol.*) on profile-likelihood identifiability across sigmoid growth models, and Rockaya & Baranyi (2025, *Food Microbiology*) on SE realism after reparametrization — both assume the deterministic model is correctly specified. **No Monte Carlo coverage study under cross-model misspecification appears in the published literature.** Adjacent literature exists, but the specific question — "if the true generator is, say, Baranyi-Roberts and we fit Gompertz (or vice-versa), what fraction of the time does a nominal 95% Wald/profile/credible interval cover the true growth rate?" — appears genuinely unanswered.

The closest existing work is **Rockaya & Baranyi (2025, *Food Microbiology*, doi:10.1016/j.fm.2025.104726)**, which studies how rescaling/reparametrization of the Baranyi-Roberts model affects the *standard error* of growth-parameter estimates and argues that "the error structure of the BRM-fit is closer to that of linear regression," hence conventional t-distribution CIs are dependable. This is closest in spirit to our work but (i) assumes the model is correctly specified, (ii) does not measure coverage by Monte Carlo simulation, and (iii) does not consider Bayesian credible intervals or PSIS-LOO diagnostics. Our contribution — measuring coverage degradation as a function of structural misspecification severity — is therefore methodologically novel.

The cleanest framing for the paper: *"Despite a 30-year history of nonlinear primary growth-model fits in predictive microbiology (Baranyi & Roberts 1994; Dalgaard 1995; Pin 2004, 2011; Mejlholm & Dalgaard 2009–2015) and a parallel body of Bayesian fits (Pouillot 2003; Albert 2005; Powell 2006; Quinto 2018; Rickett 2015), no published study has measured the coverage of the resulting confidence or credible intervals under structural misspecification of the deterministic growth model. The closest related work is Rockaya & Baranyi (2025), who study the effect of reparametrization on standard-error realism in the well-specified case."*

This is a clean "unstudied territory" claim, but the surrounding literature is rich and gives us strong methodological tools (profile likelihood: Bates & Watts 1988, Seber & Wild 1989, Bellio 2000, Raue 2009; higher-order asymptotics: Brazzale-Davison-Reid 2007; PSIS-LOO and SBC: Vehtari/Gelman/Gabry 2017, Talts 2018).

## Foundational references the paper MUST cite

1. **Bates DM & Watts DG (1988). *Nonlinear Regression Analysis and Its Applications.* Wiley, New York.** — Canonical treatment of intrinsic/parameter-effects curvature, profile traces, and the unreliability of Wald CIs in nonlinear regression. This is the intellectual ancestor of any growth-curve CI critique.

2. **Seber GAF & Wild CJ (1989). *Nonlinear Regression.* Wiley, New York.** — Standard reference: linearisation Wald, likelihood-based, and bootstrap CIs in nonlinear regression; the encyclopedic companion to Bates & Watts.

3. **Brazzale AR, Davison AC, Reid N (2007). *Applied Asymptotics: Case Studies in Small-Sample Statistics.* Cambridge University Press.** — Definitive treatment of higher-order asymptotic CIs (modified profile likelihood, Skovgaard adjustment) in nonlinear and non-Gaussian small-sample problems; ships with the `nlreg` R package.

4. **Bellio R (2000). "Applications of likelihood asymptotics for nonlinear regression in herbicide bioassays." *Biometrics* 56:1204–1212.** doi:10.1111/j.0006-341x.2000.01204.x — The cleanest applied paper on higher-order likelihood CIs in dose-response (structurally similar to growth) curves; methodological backbone for any small-sample nonlinear CI work.

5. **Vehtari A, Gelman A, Gabry J (2017). "Practical Bayesian model evaluation using leave-one-out cross-validation and WAIC." *Statistics and Computing* 27:1413–1432.** doi:10.1007/s11222-016-9696-4 — 4,858 citations. PSIS-LOO with k-hat diagnostic; if we use Bayesian fits or model comparison at all this is required.

6. **Raue A, Kreutz C, Maiwald T et al. (2009). "Structural and practical identifiability analysis of partially observed dynamical models by exploiting the profile likelihood." *Bioinformatics* 25:1923–1929.** doi:10.1093/bioinformatics/btp358 — 1,323 citations. Standard reference for profile-likelihood identifiability and CI construction in ODE models. Growth curves *are* ODE fits.

7. **Talts S, Betancourt M, Simpson D, Vehtari A, Gelman A (2018). "Validating Bayesian Inference Algorithms with Simulation-Based Calibration." arXiv:1804.06788.** — Canonical SBC paper; the standard way to verify Bayesian CI coverage.

## Closest direct prior art on sigmoid-population coverage

- **Simpson MJ et al. (2021).** *Parameter identifiability and model selection for sigmoid population growth models.* J. Theor. Biol. (bioRxiv 2021.06.22.449499); doi:10.1098/rsif.2021.0143. **73 citations.** Profile-likelihood identifiability across logistic / Gompertz / Richards on the exact model class MisspecStudy targets — but in the **well-specified** case and without cross-model misspecification. Must be engaged directly in the methods section.
- **Simpson MJ et al. (2024).** *Making Predictions Using Poorly Identified Mathematical Models.* Bull. Math. Biol.; doi:10.1007/s11538-024-01294-0. **15 citations.** Prediction-set construction for weakly identifiable ODE models; same intellectual lineage but focuses on prediction intervals rather than parameter CIs.
- **Pironet A et al. (2017).** *Practical identifiability analysis of a minimal cardiovascular system model.* Comput. Methods Programs Biomed.; doi:10.1016/j.cmpb.2017.01.005. **33 citations.** ODE-identifiability + parameter-CI methodology, adjacent biological domain.

## Strong supporting references in adjacent areas

- **Rockaya M & Baranyi J (2025). "Variability of growth parameter estimates — The role of rescaling and reparametrization." *Food Microbiology* 130:104726.** Closest existing prior art in spirit; the paper to engage with directly.
- **Akkermans S, Nimmegeers P, Van Impe JF (2018). "A tutorial on uncertainty propagation techniques for predictive microbiology models." *Int J Food Microbiol* 282:1–8.** doi:10.1016/j.ijfoodmicro.2018.05.027. — Benchmarks Monte Carlo, linearisation, sigma-point, and bootstrap propagation through growth models. The natural state-of-the-art uncertainty paper from the predictive-microbiology community.
- **Tönsing C, Timmer J, Kreutz C (2023). "Likelihood-ratio test statistic for the finite-sample case in nonlinear ordinary differential equation models." *PLoS Comput Biol* 19:e1011417.** Directly studies when asymptotic chi-square LRT approximations break for ODE fits — supports our claim that nominal coverage fails at typical N.
- **Simpson MJ et al. (2020). "Practical parameter identifiability for spatio-temporal models of cell invasion." *J R Soc Interface* 17:20200055.** — Profile-likelihood coverage studies for biological-growth ODEs.
- **Ionides EL et al. (2017). "Monte Carlo profile confidence intervals for dynamic systems." *J R Soc Interface* 14:20170126.** — Profile CI methodology with nominal-coverage proof for noisy partially-observed dynamic systems.
- **Pouillot R, Albert I, Cornu M, Denis JB (2003). "Estimation of uncertainty and variability in bacterial growth using Bayesian inference." *Int J Food Microbiol* 81:87–104.** — Foundational Bayesian-growth-curve paper. Reports credible intervals but does not check coverage.
- **Powell MR, Schlosser W, Ebel E (2006). "Bayesian synthesis of a pathogen growth model: Listeria monocytogenes under competition." *Int J Food Microbiol* 109:34–46.** — Bayesian growth-curve antecedent under competition; no coverage analysis.
- **Garre A et al. (2023). "The importance of what we cannot observe: Experimental limitations as a source of bias for meta-regression models in predictive microbiology." *Int J Food Microbiol* 387:110045.** — Best example of bias-from-misspecification thinking in the predictive-microbiology literature, though it is data-process misspecification rather than deterministic-model misspecification.
- **Hoff P & Wakefield J (2012). "Bayesian sandwich posteriors for pseudo-true parameters." arXiv:1211.0087.** — Bayesian posteriors that target the pseudo-true parameter under misspecification with asymptotic frequentist coverage; directly relevant theoretical backdrop.
- **Buja A et al. (2019). "Models as Approximations II: A Model-Free Theory of Parametric Regression." *Statistical Science* 34:545–565.** arXiv:1612.03257 — Model-free theory of parametric regression under misspecification; frequentist counterpart to Hoff-Wakefield.

## What's been studied in adjacent areas (one-line summary)

| Area | Typical claim | Gap relative to our work |
|---|---|---|
| Profile-likelihood CIs in ODE models (Raue, Hass, Simpson, Tönsing) | Profile CIs are more reliable than Wald in finite samples for well-specified models | None measure coverage under deterministic-model misspecification |
| Higher-order asymptotics for nonlinear regression (Bates-Watts, Bellio, Brazzale-Davison-Reid) | Skovgaard/modified profile is more accurate than naïve Wald in small samples | Same — assume the model is right |
| Uncertainty propagation in predictive microbiology (Akkermans, Pin, Mejlholm, Dalgaard) | Compare sigma-point, MC, bootstrap propagation against each other on growth fits | Calibration of propagated intervals is not measured |
| Bayesian growth-curve fits (Pouillot, Albert, Powell, Quinto, Rickett) | Reports posterior intervals; sometimes prior sensitivity | None check frequentist coverage of credible intervals or do SBC |
| Safe/generalised Bayes for misspecification (Grünwald, de Heide, Wu & Martin) | Tempered posteriors achieve coverage under misspecification | Not applied to growth curves; theoretical/synthetic data |
| PSIS-LOO / SBC (Vehtari-Gelman-Gabry, Talts) | Validate model fit and posterior calibration | Standard tools we should use; not previously applied to growth-misspecification |
| Predictive microbiology validation (ComBase: Pin, Mejlholm, Schaffner) | Compare predictions to challenge data using RMSE / bias factor | Never reports coverage probability of CIs |

## Useful quotes / paraphrases

- *Rockaya & Baranyi 2025*: "the error structure of the BRM-fit is closer to that of linear regression," supporting the use of t-distribution-based confidence intervals — but only under correct specification of the deterministic model. We extend this analysis to misspecified deterministic models.
- *Akkermans et al. 2018* find that "the one-step method yields more accurate and precise calculations of the model prediction uncertainty than the two-step method" and recommend the sigma-point method for propagation, but all four propagation methods compared assume the deterministic model is correctly specified.
- *Tönsing et al. 2023* explicitly study when the asymptotic chi-square approximation to the LRT fails in nonlinear ODE models — providing finite-sample corrections analogous to those of Bartlett and Skovgaard for nonlinear regression. They do not consider model misspecification.
- *Hoff & Wakefield 2012*: "Under model misspecification, MLEs converge to pseudo-true parameters corresponding to the closest in-model distribution." This sets the stage for what credible intervals *can* mean under misspecification — they cover the pseudo-true parameter, not the true one.
- *Grünwald & Mehta 2016* and *de Heide et al. 2019* (Safe-Bayes for GLMs): show that with appropriately-chosen learning rates, generalised Bayes "concentrate[s] around the best approximation of truth" — an option for our Bayesian-CI calibration fix.

## How our work differs (the gap-statement)

We measure, by Monte Carlo simulation across a grid of (model pair, sample size, noise level, design density) configurations, the empirical frequentist coverage of (i) Wald, (ii) profile-likelihood, (iii) bootstrap-percentile, and (iv) Bayesian credible intervals for the growth-rate and lag parameters of standard primary models (Gompertz, Logistic, Richards, Baranyi-Roberts) when the data-generating model is one of the others. To our knowledge this is the first study to quantify the coverage cost of structural misspecification in this widely-used class of models, and to benchmark candidate fixes (profile, bootstrap, safe-Bayes, PSIS-LOO-informed model averaging) against it.
