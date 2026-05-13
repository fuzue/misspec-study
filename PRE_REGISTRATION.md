# Pre-registration — MisspecStudy reanalysis

**Status:** Draft, to be **frozen and committed before any Stage 3 reanalysis begins.**

The point of this document is to fix the rules *before* we see Stage 3 data. If we change a rule after this is frozen, the change must be a new commit with an explicit deviation note.

---

## 1. Selection criteria — when does a paper enter the reanalysis pool?

A candidate paper enters the Stage 3 reanalysis pool iff **all** of the following hold:

1. **Domain**: the paper presents microbial growth-curve data (OD or CFU vs time) on bacteria, yeast, or other microbes. Animal growth curves, tumour growth curves, plant growth, human cell-line proliferation are out of scope.
2. **Comparative claim**: the paper makes at least one quantitative comparative claim on a *fitted* growth-curve parameter (e.g. μ_max, K, λ, AUC) across strains, conditions, treatments, or genotypes. Qualitative differences without parameter inference do not count.
3. **Raw data available**: per-replicate, per-timepoint OD or CFU values can be obtained from the paper's supplementary materials, an associated repository (Dryad, Zenodo, Figshare, GitHub, OSF), or the authors via documented request. Synthesised or smoothed data only does not count.
4. **Reproducibility floor**: re-fitting the same parametric model used by the paper to the same data reproduces the originally reported point estimates within **±10 %** on at least the primary parameter under comparison. If we cannot reproduce, the paper is excluded; if it is borderline (10–20 %), we record this and re-examine post-hoc rather than reanalysing.
5. **Sample size**: at least 2 biological replicates per condition for the conditions being compared (otherwise no replicate-level variance to integrate).
6. **Year**: 2015–2026 publication date (older papers often have idiosyncratic file formats and dated methods sections).

Papers that pass (1)–(3) but fail (4)–(6) are recorded in `inventory/excluded.csv` with the failure reason, for transparency.

## 2. Verdict definition — what counts as the conclusion changing?

For each comparative claim in a reanalysed paper, we compute the posterior probability of the same-direction effect under BayesBiont. Let `θ` be the parameter being compared (e.g. `μ_strain_A − μ_strain_B`), and let the paper's claim be `θ > 0` (or `θ < 0`).

Define:

- `P_same` = posterior probability of the same-direction effect under the reanalysis.

**Pre-registered verdict thresholds:**

| `P_same` | Verdict |
|---|---|
| > 0.975 | **survives** |
| 0.90 – 0.975 | **survives-weakened** |
| 0.5 – 0.90 | **inconclusive** (was significant; now uncertain) |
| < 0.5 | **flips** (more posterior mass in the opposite direction) |

For null-result claims (paper reported "no significant difference"):

| `P_diff > δ_min` | Verdict |
|---|---|
| > 0.95 | **null strengthens** (still no clear effect after reanalysis) |
| < 0.95 | **null challenged** (we find positive evidence of an effect the paper missed) |

`δ_min` is the smallest practically meaningful effect size in the relevant domain — set per domain in `pre_registration_addendum_<domain>.md` (food micro: 0.05 log10 CFU/h; antimicrobial: 10 % μ_max change; evolution: 5 % fitness; synthetic biology: 20 % growth-rate change).

## 3. Statistical comparison protocol

For each reanalysed paper:

1. Build a `GrowthData` matching the paper's experimental design (one curve per replicate × condition × timepoint).
2. Fit BayesBiont hierarchically with `group=` set to whatever groups the paper compares.
3. Choose the model family the paper used (Gompertz / Logistic / Baranyi / Richards / aHPM); if multiple, fit each and report the one preferred by LOO.
4. Compute the contrast posterior `contrast(post, group_A, group_B; param=...)` matching the paper's comparative claim.
5. Apply the verdict thresholds in §2.
6. Diagnostics: pareto-k for LOO, posterior predictive check on each curve. Flag any case where pareto-k > 0.7 — the BayesBiont posterior is not trustworthy and we report the verdict as **diagnostic-fail** rather than survives/flips/etc.

## 4. Reporting

- Every reanalysis reports the original CI / SE / p-value AND the BayesBiont posterior contrast, side by side.
- We do not editorialise per paper. The verdict is computed by `pipeline/verdict.jl` from the posterior; the per-paper writeup describes the experimental context and reports the verdict without prose interpretation.
- Aggregate-level interpretation only appears in the final paper, not in per-paper writeups.

## 5. Deviation log

Any change to this document after it is frozen must:
1. Be a separate commit with message starting `pre-reg deviation:`.
2. Explain *why* the change is necessary.
3. Note which papers (if any) would have been affected by the unchanged version.
