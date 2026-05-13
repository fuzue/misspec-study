# Pilot targets

Three papers from the literature review's `04_comparative_claims.tsv`, chosen for **(i)** likely data availability, **(ii)** clarity of the comparative claim, **(iii)** coverage of three different reporting practices (bootstrap CI / mixed-effects CI / SEM only).

## 1. La Rosa et al. 2021 — *Nat. Commun.* 12:3186

**DOI:** 10.1038/s41467-021-23451-y
**Title:** Compensatory evolution of *Pseudomonas aeruginosa*'s slow growth phenotype suggests mechanisms of adaptation in cystic fibrosis.
**Domain:** evolution.
**Original claim:** μ_max trajectory from 0.37 ± 0.03 → 1.28 ± 0.02 → 1.08 ± 0.02 → 0.87 ± 0.02 /h across compensatory-evolution generations, with bootstrap (500 reps) 95 % CIs.
**Why this paper:** the *only* paper in our literature review with bootstrap CIs on the fitted parameter. Best chance of reproducing the original analysis cleanly. The endpoint differences are large (3×) and should survive any reasonable reanalysis; the per-generation transitions are within ~1.5× and are the sensitive comparisons.

**Data status:** UNAVAILABLE (raw curves). See `P01_la_rosa_2021/data_status.md`. The Source Data XLSX and the Zenodo deposit (10.5281/zenodo.3612820) only contain fitted μ_max values per generation / per clone; no per-replicate OD vs time. Substituted with S01 Pedreira 2022 and S02 Alonso-del Valle 2021.

## 2. Pennone et al. 2021 — *Foods* 10:1099

**DOI:** 10.3390/foods10051099
**Title:** Omnibus modelling of *Listeria monocytogenes* growth rates at low temperatures.
**Domain:** food microbiology.
**Original claim:** μ_max with 95 % CIs across temperatures from 4.5 °C to 12 °C; explicit argument that the omnibus framework's wider CIs are the correct ones for shelf-life prediction.
**Why this paper:** closest in spirit to MisspecStudy's argument — the authors themselves make the case that proper uncertainty matters. A successful reanalysis here is a direct validation of our approach. *Foods* (MDPI) typically has raw data in supplementary materials.

**Data status:** UNAVAILABLE. See `P02_pennone_2021/data_status.md`. Authors' verbatim statement is "data available on request from the corresponding author"; no supplementary CFU/OD tables, no repository deposit. Also note correction: temperatures used were 4.5, 7.8, 12.0 °C (three, not five). Substituted with S01 Pedreira 2022 and S02 Alonso-del Valle 2021.

## 3. Chowdhury et al. 2023 — *ACS Infect. Dis.* 9:1834

**DOI:** 10.1021/acsinfecdis.3c00156
**Title:** Fitness costs of antibiotic resistance impede the evolution of resistance to other antibiotics.
**Domain:** antimicrobial / evolution.
**Original claim:** AUC of fitted growth curves 8× lower for omadacycline-resistant mutant vs WT; 5× lower stationary OD; evolved-recovery line AUC 5× above resistant parent. Uncertainty reported as SEM only (N=16).
**Why this paper:** SEM-only is the most common practice in our review; this represents the *modal* case. Headline 5–8× differences should survive any reanalysis, but intermediate comparisons at p ≈ 0.01 are the interesting cases.

**Data status:** UNAVAILABLE (raw growth-curve table). See `P03_chowdhury_2023/data_status.md`. The SI PDF (id3c00156_si_001.pdf) gives growth-curve **figures** with SEM bands but no tabular OD/time data; SI XLSX is variant-calling; SI MP4 is a motility movie. Only sequencing data are deposited (PRJNA986536). Also note correction: the paper is on **chloramphenicol** resistance from the Findlay lab at Concordia (not omadacycline from the Lipsitch lab). Substituted with S01 Pedreira 2022 and S02 Alonso-del Valle 2021.

## Substitution plan

If a target's data is genuinely unavailable, substitutes from `04_comparative_claims.tsv` (priority order):

1. **Pedreira et al. 2022** — Hessian-based CI; explicit identifiability discussion. Direct relevance.
2. **Alonso-del Valle et al. 2021** — plasmid carriage fitness costs. SEM only.
3. **Hitomi et al. 2024** — 8-of-9 significance at the edge.

## Outcome of the find-data pass

| ID  | Paper                          | Status        | Where the data is (if any) |
|-----|--------------------------------|---------------|----------------------------|
| P01 | La Rosa 2021                   | UNAVAILABLE   | Only fitted μ_max values are public; raw OD vs time series not deposited. |
| P02 | Pennone 2021                   | UNAVAILABLE   | "Data available on request"; nothing deposited. |
| P03 | Chowdhury 2023                 | UNAVAILABLE   | Growth-curve **figures** in SI 1 PDF only; no tabular data. |
| S01 | Pedreira 2022 (substitute #1)  | PARTIAL/FOUND | Zenodo 10.5281/zenodo.5167910 → 7732915. Mean + per-timepoint SD for OD and CFU, 2 organisms × 7 DDAC concentrations × 12 timepoints. |
| S02 | Alonso-del Valle 2021 (sub #2) | FOUND         | GitHub `ccg-esb/pOXA48` + Zenodo 10.5281/zenodo.4605352. 100 OD CSVs (50 strains × WT/TC), 144 timepoints each, mean ± SE per timepoint. |

The two substitutes together give us **2 organisms × 7 DDAC conditions (Pedreira) + 50 strains × 2 plasmid states (Alonso-del Valle)** of public growth-curve data — more than enough to demonstrate the MisspecStudy reanalysis pipeline across two distinct experimental designs (dose-response vs. strain-collection fitness comparison).

See `P0?_*/data_status.md` and `S0?_*/data_status.md` for per-paper details, and `S0?_*/fetch_data.sh` for the reproducible download commands.
