# P03 Chowdhury 2023 — data status: UNAVAILABLE (raw OD curves)

**Status:** UNAVAILABLE. Supporting Information contains growth-curve **figures** (with SEM bands) but no tabular raw OD vs time data. No Data Availability statement covers the phenotypic measurements; only the sequencing data are deposited.

## Verbatim statements

The paper does not include a standalone "Data Availability" section. The only deposit statement is:

> "Sequencing data have been deposited in the NCBI BioProject database with accession number PRJNA986536."

The Supporting Information section is titled "Supporting Information Available" and lists three SI files (see below).

## What is publicly available

| Artifact | URL | Content | Useful? |
|----------|-----|---------|---------|
| SI 1 (PDF) | https://pubs.acs.org/doi/suppl/10.1021/acsinfecdis.3c00156/suppl_file/id3c00156_si_001.pdf | "Additional growth curves, kinetics of nitrofurantoin evolution, and inoculum effect". Figures only — no tabular data. | Partial: visible curves with SEM bands; would need WebPlotDigitizer extraction to recover means but not replicate dispersion or per-timepoint variance. |
| SI 2 (XLSX) | https://pubs.acs.org/doi/suppl/10.1021/acsinfecdis.3c00156/suppl_file/id3c00156_si_002.xlsx | breseq variant calls, depths, AF, sequencing QC. | No — genomics. |
| SI 3 (MP4) | https://pubs.acs.org/doi/suppl/10.1021/acsinfecdis.3c00156/suppl_file/id3c00156_si_003.mp4 | Soft-agar motility movie (132 MB). | No. |
| BioProject `PRJNA986536` | https://www.ncbi.nlm.nih.gov/bioproject/PRJNA986536 | Whole-genome sequencing reads for the resistant + revived strains. | No — genomics only. |
| Findlay Lab website | http://findlaylab.ca/research/ | Publication list with DOIs; no data attachments, no GitHub link. | No. |
| GitHub | n/a | `github.com/findlaylab` returns 404. No public Findlay-lab GitHub organisation containing growth-curve data was identified. | No. |
| Zenodo / Dryad / Figshare / Mendeley / OSF | none | None found via search. | No. |

## Obstacle note

Direct downloads from `pubs.acs.org/doi/suppl/...` return HTTP 403 to scripted clients without an active ACS session; PMC mirror URLs (`pmc.ncbi.nlm.nih.gov/articles/instance/10581211/bin/...`) now interpose a JavaScript proof-of-work interstitial. SI 1 PDF is therefore inspected manually by a human collaborator in a browser; the description above is from the PMC HTML's caption text and the article's own description of SI 1.

## What is missing

Per-replicate per-timepoint OD600 vs t for the Growthcurver fits behind Figures 1B, S1, S4 (WT, OM, 1X..5X, WTB, CFZR comparisons). The paper uses the Growthcurver R package which natively reads wide-format plate-reader CSVs; those input CSVs are not deposited.

## Author-request path (NOT executed)

Corresponding author: **Brandon L. Findlay**, Department of Biology / Department of Chemistry and Biochemistry, Concordia University, Montréal — `brandon.findlay@concordia.ca`.
First author: **Farhan R. Chowdhury** (PhD student, Findlay Lab).
A request would ask for the wide-format plate-reader CSVs underlying the Growthcurver fits behind Figs. 1B, S1 and S4, with strain × replicate annotations.

## Decision

Same as P01/P02 — fall back to substitutes **S01 Pedreira 2022** and **S02 Alonso-del Valle 2021**, both of which have raw growth-curve files deposited publicly.
