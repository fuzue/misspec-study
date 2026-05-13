# Stage 1a — Data inventory

**Goal:** assemble 50+ candidate papers with verified raw growth-curve data available, across at least four domains (experimental evolution, antimicrobial screening, synthetic biology, food microbiology).

## Status

| Metric | Target | Current |
|---|---|---|
| Candidates found | 50+ | 0 (kickoff) |
| Raw data verified accessible | 50+ | 0 |
| Domain coverage | 4 domains | 0 |

## How to add a candidate

Append a row to `candidates.csv` with columns:

```
doi, year, first_author, title, journal, domain, data_source, data_url, original_claim, fit_method, n_replicates, organism, notes
```

`data_source` is one of: `dryad`, `zenodo`, `figshare`, `supplementary_xlsx`, `github`, `osf`, `combase`, `mendeley_data`, `direct_request_pending`.

`domain` is one of: `evolution`, `antimicrobial`, `synthetic_biology`, `food_microbiology`, `other`.

A candidate is *verified* once its `data_url` resolves to a downloadable file with per-replicate per-timepoint values. Unverified candidates may sit in the table marked `data_url=PENDING` while we follow up.

## Search strategy

See `search_strategy.md`.

## Excluded candidates

Papers that turn out to fail the inclusion floor (synthesised data only, animal models, no comparative claim) are moved to `excluded.csv` with a reason. Documenting exclusions is part of the reproducibility story.
