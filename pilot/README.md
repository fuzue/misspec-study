# Stage 1b — Pilot reanalyses

**Goal:** validate the end-to-end reanalysis pipeline on 3 papers from the literature review's `04_comparative_claims.tsv`. Either the pipeline works on real published data or the project is infeasible.

## Status

| Paper | Data found? | Reproduced original fit? | BayesBiont fit done? | Verdict |
|---|---|---|---|---|
| La Rosa et al. 2021 (*Nat. Commun.* 12:3186) | TBD | — | — | — |
| Pennone et al. 2021 (*Foods* 10:1099) | TBD | — | — | — |
| Chowdhury et al. 2023 (*ACS Infect. Dis.* 9:1834) | TBD | — | — | — |

## How a pilot proceeds

For each target:

1. Locate the paper's data (supplementary, repository, or contact author). Stop and document if data is not available.
2. In `pilot/PNN_<author>_<year>/`:
   - `original_claim.md` — what the paper reports, with the specific quantitative claim we'll evaluate.
   - `fetch_data.sh` (or `.py` / `.jl`) — reproducible script that pulls the raw data from its public source.
   - `load.jl` — converts the raw format to `Kinbiont.GrowthData`.
   - `refit.jl` — runs BayesBiont hierarchical fit matching the paper's design.
   - `verdict.md` — applies the (draft) verdict criteria from PRE_REGISTRATION.md.
3. Decision criterion: the pilot succeeds if we can reproduce the original point estimate within ±10 % and compute a coherent posterior contrast.

## What "validates the pipeline" means

- The pipeline can handle 3 different raw-data formats (likely Excel from supp materials, CSV from Dryad, GitHub-linked TSV).
- The hierarchical BayesBiont fit converges without warnings on real plate-reader data.
- The contrast posterior is interpretable and the verdict thresholds in `PRE_REGISTRATION.md` can be applied without ambiguity.

If 2+ of the 3 pilots succeed, we proceed to Stage 2 (pre-registration freeze) and Stage 3 (full reanalysis). If 0–1 succeed, we revisit scope.
