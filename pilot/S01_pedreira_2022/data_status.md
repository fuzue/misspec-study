# S01 Pedreira 2022 — data status: PARTIAL

**Status:** PARTIAL. Raw mean-OD and mean-CFU time series are deposited on Zenodo together with per-timepoint empirical standard deviations across replicates. **Per-replicate (individual-curve) traces are not separately deposited** — only the across-replicate mean and SD.

## Verbatim Data Availability statement (Frontiers article)

> "The datasets and mathematical models presented in this study can be found online in the following public repository https://doi.org/10.5281/zenodo.5167910"

## Deposit

| Item | Value |
|------|-------|
| Concept DOI | 10.5281/zenodo.5167910 |
| Latest version DOI (resolved by Zenodo API) | 10.5281/zenodo.7732915 (version 3.0.0) |
| Title | "Mathematic models (Matlab and R code) to describe and analyse the effect of sub-MIC concentrations of antimicrobials in bacterial growth" |
| Licence | CC-BY 4.0 |
| Total size | 1.3 MB |
| API endpoint | https://zenodo.org/api/records/7732915 |

### Files

| File | Size | Role |
|------|------|------|
| `A0_RUN_all.m`            | 6.3 kB | MATLAB master script. |
| `A1_Model_Logistic.m`     | 4.8 kB | Logistic primary model. |
| `A1_Model_Mechanistic.m`  | 4.3 kB | Mechanistic competing model. |
| `A1_postprocess.m`        | 5.3 kB | Section 2.1 post-processing (figures and tables). |
| `A2_Model_ODandCFUs.m`    | 5.1 kB | Joint OD + CFU model. |
| `A2_postprocess.m`        | 7.2 kB | Section 2.2 post-processing. |
| `A3_SupMat.m`             | 2.9 kB | Supplementary post-processing. |
| `data_Bc.mat`             | 2.2 kB | **B. cereus dataset** — see structure below. |
| `data_Ec.mat`             | 2.2 kB | **E. coli dataset** — same structure. |
| `Generated_results(pre).zip` | 1.2 MB | Pre-computed fit outputs. |
| `Main_DDAC.R`             | 1.9 kB | R port of fit. |
| `readme.md`               | 1.0 kB | Instructions. |

### Structure of `data_Bc.mat` / `data_Ec.mat`

Verified by loading with `scipy.io.loadmat`:

- `bacteria` — string (`'Bc'` or `'Ec'`).
- `uu` — `(1, 7)` cell of DDAC concentrations [mg/L]: 0, 0.05, 0.07, 0.25, 0.8, 1.0, 1.5.
- `tt` — `(1, 7)` cell, each `(12, 1)` — timepoints in hours, 0..48.
- `X_OD`, `X_cfus` — `(1, 7)` cell of `(12, 1)` mean OD or mean CFU per timepoint per concentration.
- `E_OD`, `E_cfus` — `(1, 7)` cell of `(12, 1)` constant per-condition error (≈ 0.04 OD units for *Bc* exp 0).
- `Ei_OD`, `Ei_cfus` — `(1, 7)` cell of `(12, 1)` per-timepoint empirical SD across replicates.

So per (organism × concentration) we have 12 timepoints, with mean + per-timepoint SD on both OD and CFU axes — two replicate-derived noise estimates suitable to use as the observational-noise prior in a hierarchical Bayesian fit. The original number of biological replicates is documented in Methods (n=3 per condition, three independent days) but the individual replicate curves are not in the deposit.

## Counts (across both organisms)

- 2 organisms × 7 DDAC concentrations = 14 curves.
- 12 timepoints per curve.
- 2 readouts per timepoint (OD, CFU) with associated SDs.

## Author-request path (only if per-replicate curves needed)

Corresponding author: **Míriam R. García**, Bioprocess Engineering Group, IIM-CSIC, Eduardo Cabello 6, 36208 Vigo, Spain — `miriamr@iim.csic.es` (public lab page).
First author: **Adrián Pedreira** (same group).
The deposit already gives us the cross-replicate SD; a request would only be needed if the reanalysis required individual replicate traces (e.g. to evaluate replicate-level random effects independently of the across-replicate SD).
