# Data-availability search strategy

## Sources ranked by expected yield

1. **Dryad** — `datadryad.org` search for "growth curve" / "OD600" / specific organisms. High data quality, well-curated metadata.
2. **Zenodo** — `zenodo.org`. Heterogeneous quality but high volume; many bioRxiv-linked datasets.
3. **Figshare** — `figshare.com`. Often holds raw plate-reader files attached to papers.
4. **Supplementary materials** — *Nature Communications*, *Nature Microbiology*, *Cell Reports*, *mBio*, *PLOS Biology*, *eLife*, *ACS Infect. Dis.* typically attach `data_S1.xlsx` style spreadsheets.
5. **GitHub** — paper-associated repos containing `data/`, `csv/`, `od/` folders. Highest yield from synthetic-biology and computational-microbiology papers.
6. **ComBase** — predictive-microbiology repository with raw curves for *L. monocytogenes*, *Salmonella*, *E. coli*, *Campylobacter*, *Y. enterocolitica* etc.
7. **OSF** — `osf.io`. Smaller but high-quality; experimental-evolution groups use it.
8. **Mendeley Data** — Elsevier's repository, increasingly populated.

## Search queries (Dryad / Zenodo / Figshare)

- `("growth curve" OR "OD600" OR "optical density") AND ("E. coli" OR "Saccharomyces" OR "Pseudomonas" OR "Listeria" OR "Salmonella")`
- `"plate reader" microbial growth`
- `"experimental evolution" OD bacterial`
- `"antimicrobial susceptibility" growth curve raw`
- `"Baranyi" predictive microbiology raw data`

## Targeted lab repositories

Labs known for active data sharing — manually check 2018+ output:

- **Lenski lab / LTEE** (Michigan State) — LTEE generation samples have public OD data
- **Lang lab** (Lehigh) — yeast experimental evolution
- **Cooper lab** (Pittsburgh) — Pseudomonas experimental evolution
- **Wielgoss / Schloter / Andersson labs** — various microbial evolution
- **Toprak lab** (UT Southwestern) — morbidostat, antibiotic resistance
- **Tans lab** (AMOLF) — single-cell + bulk yeast/E. coli growth
- **Marx lab** (Idaho) — Methylobacterium evolution
- **Wagner lab** (Zurich) — evolution + Growthcurver pioneers
- **Tavazoie / Khalil labs** (Boston) — synthetic biology fitness

## Journal-targeted scraping

Recent (2020–2026) papers in:

- *Nature Communications* — supplementary spreadsheet often `41467-202X-XXXXX-MOESM-SDX.xlsx`
- *Cell Reports* — `mmcS1.xlsx` standard
- *mBio* — heterogeneous; check supplementary item lists
- *Microbial Biotechnology* — sometimes with raw data
- *ISME Journal* — community microbiology, occasional raw data

## How a candidate is added

For each promising hit:
1. Verify the data link resolves and the file contains per-replicate per-timepoint OD/CFU values (not just summary tables).
2. Extract: DOI, organism, comparative claim, fit method, number of replicates per condition.
3. Append to `candidates.csv` with `data_source` set, `data_url` set if verified, original claim captured in 1–2 sentences.

## Anti-patterns (don't bother)

- Papers whose only "raw data" is a screenshot or graph image — unusable.
- Papers reporting fitted parameters only (no time-series).
- Reviews / meta-analyses (no primary data of their own).
- Papers in non-microbial domains (livestock, fish, tumour, plant).

## Time budget

Stage 1a is allotted ~3 weeks of part-time. Target: 50 candidates verified, then move on to selection for the 20–30 to reanalyse.
