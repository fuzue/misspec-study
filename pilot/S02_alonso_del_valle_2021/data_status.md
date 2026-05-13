# S02 Alonso-del Valle 2021 — data status: FOUND

**Status:** FOUND. All per-strain plasmid+/plasmid– OD time series are publicly deposited on GitHub (`ccg-esb/pOXA48`, mirrored on Zenodo 10.5281/zenodo.4605352 as a 1.2 GB versioned snapshot).

## Verbatim Data Availability statement (Nature Communications, §"Data availability")

> "The sequences generated and analysed during the current study and the annotated genomes of the isolates under study are available in the Sequence Read Archive (SRA), BioProject ID: PRJNA641166. Source data are provided with this paper."

(Source data XLSX accompanies the article; raw growth-curve series live in the code-availability GitHub/Zenodo deposit cited under §"Code availability".)

## Verbatim Code Availability statement

> "The code generated during the current study is available in GitHub [ref. 86: Alonso-del Valle, A. et al. pOXA48: variability of plasmid fitness effects contributes to plasmid persistence in bacterial communities. Zenodo https://doi.org/10.5281/zenodo.4605352 (2021)]."

## Primary data deposit

| Item | Value |
|------|-------|
| GitHub | https://github.com/ccg-esb/pOXA48 |
| Zenodo snapshot DOI | 10.5281/zenodo.4605352 |
| Zenodo file | `ccg-esb/pOXA48-v1.zip` (1.24 GB) |
| GitHub data subdirectory | `data/ODdata_strains/` |
| Licence | per repository (Apache 2.0 by default; verified at fetch) |

## Counts

- **100 CSVs** in `data/ODdata_strains/`, named `ODdata_<strain>_TC.csv` and `ODdata_<strain>_WT.csv` — 50 strains × {WT, transconjugant carrying pOXA-48} pairs.
- **144 timepoints per curve**, 10-minute intervals over 24 h.
- **Three columns per CSV**: `t`, `OD600`, `ste`. The `OD600` column is the mean across replicates and `ste` is the across-replicate standard error per timepoint — three replicate cultures per strain were measured (per §Methods).

So the deposit gives us the across-replicate mean and SE — already plenty for hierarchical Bayesian reanalysis with an observational-noise prior derived directly from `ste`. Per-replicate (individual) traces are not deposited separately; if needed they would have to be requested from the authors.

## Verified sample CSV (first 8 rows of `ODdata_C001_TC.csv`)

```
t,OD600,ste
0,0.092167,0.001169
0.16667,0.0925,0.0015166
0.33333,0.093167,0.001169
0.5,0.0945,0.0015166
0.66667,0.095667,0.0018619
0.83333,0.098333,0.0020656
1,0.10133,0.0024221
```

## Other useful artifacts in the deposit

- `data/MCMC_chains/` and `data/MCMC_chains_gr/` — the per-strain posterior MCMC chains from the authors' original Metropolis-Hastings fit. These let us cross-check our reanalysis against the authors' own posterior.
- `code/m-files/`, `code/MCMC/R/` — MATLAB + R source for the figures and the fit pipeline (`runMe.R` in `code/MCMC/R/`).
- Source Data XLSX (MOESM5–7 of the article) — per-strain fitted fitness summary statistics that we can use as the "as-reported" baseline.

## Author-request path (not needed)

Corresponding author: **Álvaro San Millán**, Centro Nacional de Biotecnología-CSIC, Madrid — `asanmillan@cnb.csic.es`.
Computational co-corresponding: **Rafael Peña-Miller**, Centro de Ciencias Genómicas, UNAM, Cuernavaca — `rpm@ccg.unam.mx` (PI of the `ccg-esb` GitHub organisation that hosts the deposit).
We would only contact the authors if we needed (i) individual replicate traces or (ii) confirmation of replicate-day/plate metadata not encoded in the deposited CSVs.
