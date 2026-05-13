# Pre-registration — MisspecStudy reanalysis

**Status:** **FROZEN 2026-05-13** at commit `68653a0` after two pilot reanalyses (S01 Pedreira 2022, S02 Alonso-del Valle 2021) informed the operational details below. Stage 3 reanalyses begin against this locked document. Any change after freeze must be a new commit with message starting `pre-reg deviation:` and explicit justification.

The point of this document is to fix the rules *before* we see Stage 3 data. The two pilots were used to validate that the pipeline runs end-to-end on real public deposits; their results are documented in `pilot/S01_*/verdict.md` and `pilot/S02_*/verdict.md` but did **not** shape the verdict thresholds in §2 below (those are the same as the pre-pilot draft).

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

## 5. Operational lessons from the two pilots (informational; not a rule change)

Documenting what the pilots taught us so future-me (and reviewers) know what was learned vs. pre-registered:

- **Most papers don't deposit per-replicate traces** — they deposit across-replicate mean + per-timepoint SD or SE. The S01 Pedreira and S02 Alonso-del Valle deposits are both like this. Stage 3 should treat "mean curve + per-timepoint dispersion" as the standard input format and use the dispersion in the observation-noise prior (or accept BayesBiont's default `:lognormal` noise model and let `σ` absorb the per-timepoint variance — pragmatic compromise).
- **Reproducing the original point estimate within ±10 %** (§1 criterion 4) needs care because many papers use a secondary dose-response or fitness-statistic fit on top of the primary growth-curve fit. We may need to allow the criterion to be applied at the *primary* parameter level (per-curve μ_max / K) rather than the secondary (k_a, fitness, MIC) level. Recording this as an interpretive nuance, not a rule change.
- **Ragged timepoint counts are common** (S01 Ec had 11 vs 12 points across concentrations). The loader supports ragged input. No rule change.
- **No-growth conditions** (saturating drug, complete kill) trigger a posterior collapse on `K → 0` and a wide-on-purpose `r` posterior. This is the right behaviour, not a bug; the verdict for such conditions should drop them from secondary fits (per §3 step 6: pareto-k > 0.7 ⇒ diagnostic-fail; we extend the convention to "if `K_mean` < 0.1 × max OD seen elsewhere for the same organism, mark the curve as no-growth and exclude from secondary fits"). This is an *implementation detail*, not a rule change.

## 6. Deviation log

Any change to this document after it is frozen must:
1. Be a separate commit with message starting `pre-reg deviation:`.
2. Explain *why* the change is necessary.
3. Note which papers (if any) would have been affected by the unchanged version.

| Date | Commit | Change | Justification | Papers affected |
|---|---|---|---|---|
| (none yet — frozen `68653a0`) | | | | |
