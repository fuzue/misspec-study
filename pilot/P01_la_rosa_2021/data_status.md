# P01 La Rosa 2021 — data status: UNAVAILABLE (raw growth curves)

**Status:** UNAVAILABLE. Source Data and Zenodo deposit publish **fitted** μ_max per generation, not the raw per-replicate per-timepoint OD vs. time series needed for reanalysis.

## What is publicly available

| Artifact | URL | Content | Useful? |
|----------|-----|---------|---------|
| Source Data XLSX (`MOESM11_ESM.xlsx`) | https://static-content.springer.com/esm/art%3A10.1038%2Fs41467-021-23451-y/MediaObjects/41467_2021_23451_MOESM11_ESM.xlsx | 18 sheets keyed to figure panels. Figure 1a / S2 give fitted μ_max per generation per clone; Figure S6 gives μ_max per replicate per evolved isolate. No OD vs time. | No — only fitted summary statistics, not raw curves. |
| Supplementary Data 1–6 (MOESM4–9 .xlsx) | …MOESM{4..9}_ESM.xlsx | Mutations, RNA-seq DE genes. | No — not phenotype data. |
| Supplementary Information PDF (`MOESM1_ESM.pdf`) | …MOESM1_ESM.pdf | Figures + tables, narrative supplement. | No — narrative, not raw OD. |
| Zenodo `LaRosa2021_ALE_analysis` | https://doi.org/10.5281/zenodo.3612820 | R/Rmd + Python pipeline for RNA-seq + mutation analysis, plus mutation tables (`data/raw/mtables/PA_*.mutations.tsv`) and isolate metadata (`data/raw/isolates_collection.tsv`). | No — has zero growth-curve files. The Rmd is solely for RNA-seq and mutation analysis. |
| ENA `PRJEB38310` | https://www.ebi.ac.uk/ena/browser/view/PRJEB38310 | Raw Illumina reads. | No — genomes/transcriptomes only. |

## Verbatim Data Availability statement

> "Sequencing data that support the findings of this study have been deposited in the EMBL-EBI European Nucleotide Archive (ENA) with the primary accession code PRJEB38310. Source data are provided with this paper."

## What is missing

Per-replicate per-timepoint OD600 (or biomass) vs. time for the ALE plate-reader runs that produced the μ_max values in Figure 1a, Figure S2 and Figure S6. The Methods describe an in-house MATLAB package fitting μ between OD 0.05 and 0.95, but the input series are not deposited.

## Author-request path (NOT executed)

Corresponding author (paper): **Ruggero La Rosa**, DTU Biosustain (now at Universidade degli Studi di Milano, Department of Biosciences).
Group leader: **Søren Molin**, DTU Biosustain.
A request would go to `ruggero.la-rosa@unimi.it` (current affiliation listed in 2021 author note) and cc `smolin@bio.dtu.dk`, asking for the raw plate-reader CSV/MATLAB output underlying Figure 1a / Figure S2 / Figure S6.

## Decision

Replace with substitute **S01 Pedreira 2022** and/or **S02 Alonso-del Valle 2021** (see `S01_*/` and `S02_*/`).
