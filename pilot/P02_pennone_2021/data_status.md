# P02 Pennone 2021 — data status: UNAVAILABLE (raw growth data)

**Status:** UNAVAILABLE. Authors' Data Availability statement explicitly defers to on-request access.

## Verbatim Data Availability statement

> "The data presented in this study are available on request from the corresponding author."
> (Foods 10(5):1099, §Data Availability)

## What is publicly available

| Artifact | URL | Content | Useful? |
|----------|-----|---------|---------|
| MDPI article page | https://www.mdpi.com/2304-8158/10/5/1099 | Full text + figures + Tables 1–9. MDPI rate-limits/Akamai-blocks scripted access. | Indirect — Tables 2–8 give fitted (sequential and omnibus) parameter estimates per strain/temperature, **no raw CFU series**. |
| PubMed Central mirror | https://pmc.ncbi.nlm.nih.gov/articles/PMC8156314/ | Same article. | Same as MDPI. |
| IPB institutional repository | https://bibliotecadigital.ipb.pt/entities/publication/e601f9bf-b72f-4cc4-aece-0668f7a1190f | Bragança institutional record for co-author Gonzales-Barron — only metadata + PDF link, no data attachment. | No. |
| Supplementary materials | none listed | The Foods landing page has no Supplementary Files section. | No. |
| Repository deposits | none | No GitHub, Zenodo, Dryad, Figshare, OSF or Mendeley Data deposit was identified via Google / search engines / direct probing. | No. |

## What is missing

Per-replicate per-timepoint plate-count series (log CFU·mL⁻¹ vs t) at 4.5 °C, 7.8 °C, 12.0 °C for each of the five *L. monocytogenes* strains. These are the inputs to both the first-order (Huang) and the omnibus mixed-effects fits whose CIs are being compared.

## Author-request path (NOT executed)

Corresponding author: **Francis Butler**, UCD School of Biosystems and Food Engineering, Belfield, Dublin 4, Ireland — `f.butler@ucd.ie` (institutional address, verified from UCD profile page).
A request would explicitly ask for the raw log-CFU vs. time tables underlying Tables 2–8 (the per-(strain × temperature × replicate) plate-count series).
Co-corresponding contacts at the data-modelling end: **Ursula Gonzales-Barron** (Centro de Investigação de Montanha, IPB Bragança) — `ubarron@ipb.pt`.

## Decision

Replace with substitute **S01 Pedreira 2022** (also a low-temperature / dose-response growth-curve study with explicit identifiability/CI discussion, raw OD + CFU deposited on Zenodo) and/or **S02 Alonso-del Valle 2021** (~250 OD time-series CSVs on GitHub).
