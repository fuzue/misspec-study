# MisspecStudy — Project Plan

**Title (working):** *A systematic Bayesian reanalysis of published microbial growth-curve comparisons.*

**Status:** Stage 1 (inventory + pilot), kicked off 2026-05-13.

---

## Thesis (one sentence)

> We collected N published microbial growth-curve papers with raw data available, reanalysed each one with hierarchical Bayesian methods (BayesBiont), and report how often the original comparative conclusion survives, weakens, flips, or strengthens (for null results) when uncertainty is properly propagated.

This replaces the original framing ("CI coverage under Gompertz-vs-Logistic misspecification"). That earlier framing was statistical theatre on phenomenological models and would not survive review. The reanalysis framing is empirically grounded: real published works on trial, against a calibrated baseline.

## Why this matters

- Every comparative growth-curve paper in the last decade is implicitly on trial: do the reported significant effects survive calibrated uncertainty?
- The literature review (`literature_review/2026-05_growth_curve_practice_survey.md`) established that **~92 % of microbial growth-curve papers report no formal CI**, that **the dominant tooling produces Wald CIs without coverage validation**, and that **modal effect sizes (10–30 %) sit in the regime where miscalibration flips significance calls**.
- A field-wide reanalysis answers what reviewers actually want to know: *not* "does the math work in simulation?" *but* "would published papers' conclusions change?"

---

## Stages and milestones

### Stage 1 — Inventory + pilot (weeks 1–4)

**Parallel tracks**, both running now.

**1a. Data inventory** (`inventory/`).
- M1.1 — 50+ candidate papers with verified raw-data availability across Dryad / Zenodo / Figshare / supplementary spreadsheets / GitHub repos.
- M1.2 — Candidate metadata captured in `inventory/candidates.csv` (DOI, organism, data link, original claim, fit method).
- M1.3 — Domain coverage: experimental evolution, antimicrobial screening, synthetic biology fitness, food microbiology.

**1b. Pilot** (`pilot/`).
- M1.4 — Three papers reanalysed end-to-end (La Rosa 2021, Pennone 2021, Chowdhury 2023 or substitutes if data unavailable).
- M1.5 — Standardised reanalysis pipeline: arbitrary raw-data format → `GrowthData` → BayesBiont hierarchical fit → posterior contrast matching original claim → diagnostic report.
- M1.6 — Decision: if 0/3 papers reproduce, study is infeasible and we revisit scope.

### Stage 2 — Pre-registration freeze (week 4)

- M2.1 — `PRE_REGISTRATION.md` finalised and committed before any Stage 3 reanalyses begin.
- M2.2 — Locked selection criteria, locked verdict thresholds, locked statistical comparison protocol.

### Stage 3 — Full reanalysis (weeks 5–10)

- M3.1 — 20–30 papers reanalysed.
- M3.2 — Per-paper output: `reanalysis/NN_<first_author>_<year>/` directory containing input data, fit script, posterior dump, verdict.
- M3.3 — Aggregate table: `reanalysis/RESULTS.csv` (paper, claim, original CI, posterior, verdict, diagnostics).
- M3.4 — Domain stratification: how does verdict rate differ across experimental evolution vs antimicrobial vs food micro vs synthetic biology?

### Stage 4 — Write-up (weeks 11–14)

- M4.1 — Five case studies (one survives, one flips, one weakens, one null-strengthens, one boundary).
- M4.2 — Aggregate analysis + figures.
- M4.3 — Methods section pointing to BayesBiont + reproducible repo.
- M4.4 — Submit to target venue (Bioinformatics / PLOS Comp Bio / Patterns / Royal Society Open Science).

---

## Concrete repo layout

```
misspec-study/
├── PROJECT_PLAN.md          ← this file
├── PRE_REGISTRATION.md      ← locked-in criteria before Stage 3
├── literature_review/        ← already exists; foundational evidence for the paper
├── inventory/
│   ├── README.md
│   ├── search_strategy.md   ← reproducible search protocol
│   ├── candidates.csv       ← growing list of candidate papers with data
│   └── data_sources.md      ← cataloguing Dryad/Zenodo/GitHub yield per source
├── pilot/
│   ├── README.md
│   ├── pilot_targets.md     ← La Rosa / Pennone / Chowdhury or substitutes
│   ├── PNN_<paper>/         ← per-paper pilot directory
│   │   ├── original_claim.md
│   │   ├── fetch_data.sh    ← reproducible data acquisition
│   │   ├── refit.jl
│   │   └── verdict.md
│   └── PILOT_REPORT.md      ← summary across 3 pilots
├── reanalysis/
│   ├── pipeline/            ← shared reanalysis pipeline
│   │   ├── README.md
│   │   ├── load_raw.jl      ← format adapters (Excel / CSV / etc)
│   │   ├── fit.jl           ← BayesBiont hierarchical fit harness
│   │   └── verdict.jl       ← apply pre-registered verdict criteria
│   ├── NNN_<paper>/         ← per-paper reanalysis
│   └── RESULTS.csv          ← aggregate table
├── data/                    ← gitignored; raw + intermediate artifacts
├── analysis/                ← aggregate-stage scripts, figures
└── paper/                   ← LaTeX manuscript (Stage 4)
```

---

## Decision log (current)

- **2026-05-13** — Original framing abandoned after Edgar's pushback that Gompertz/Logistic misspecification is statistical theatre on toy curves. Pivot to reanalysis study.
- **2026-05-13** — Two-track Stage 1 (inventory parallel with pilot) over single-track. Justification: pilot validates pipeline feasibility while inventory accumulates corpus.
- **2026-05-13** — Pre-registration delayed to end of Stage 1 so we can lock criteria informed by what data is actually available. Stage 1 explicitly may *not* shape what counts as "flipped" once Stage 3 begins.

---

## Risks and mitigations

| Risk | Mitigation |
|---|---|
| Data availability too low (<20 reanalysable papers) | Stage 1 inventory has explicit M1.1 = 50+ candidates; if we hit this, the pool selection will work out. If we don't, scope down to in-depth 5–10 case studies. |
| Pilot fails to reproduce original results within ±10 % | Treat as a finding ("the literature is itself irreproducible") and pivot the paper toward reproducibility rather than calibration. |
| Selection bias (cherry-picking papers where conclusions change) | Pre-registration freeze before Stage 3. Selection criteria are about data + claim availability, not about effect direction. |
| Reanalysis upset original authors | Frame as "what we now know about the field," not "your paper was wrong." Reach out to authors for problematic cases before publication. |
| Effort overrun | Per-stage milestones; Stage 1 budget = 4 weeks. If we exceed, re-scope. |

---

## Tooling and conventions

- **Code**: Julia (BayesBiont, Kinbiont); Python only where unavoidable (PDF scraping, Dryad API).
- **Reproducibility**: every per-paper directory has a `fetch_data.sh` (or equivalent) script that pulls raw data from its public source. Data is gitignored; scripts are committed.
- **Posteriors**: saved as JLD2 or HDF5 per reanalysis; chains downsampled to 1000 draws for the public artifact.
- **Tests**: pre-registered verdicts are computed by `pipeline/verdict.jl`; no hand-coded "this one flipped".

---

## How to resume work in a new session

1. Read this file.
2. Read `PRE_REGISTRATION.md` (locks the rules).
3. Check `inventory/candidates.csv` for current candidate count and source diversity.
4. Check `pilot/PILOT_REPORT.md` for pilot status.
5. Check the most recent commit on `main` for what was last touched.
