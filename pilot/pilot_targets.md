# Pilot targets

Three papers from the literature review's `04_comparative_claims.tsv`, chosen for **(i)** likely data availability, **(ii)** clarity of the comparative claim, **(iii)** coverage of three different reporting practices (bootstrap CI / mixed-effects CI / SEM only).

## 1. La Rosa et al. 2021 — *Nat. Commun.* 12:3186

**DOI:** 10.1038/s41467-021-23451-y
**Title:** Compensatory evolution of *Pseudomonas aeruginosa*'s slow growth phenotype suggests mechanisms of adaptation in cystic fibrosis.
**Domain:** evolution.
**Original claim:** μ_max trajectory from 0.37 ± 0.03 → 1.28 ± 0.02 → 1.08 ± 0.02 → 0.87 ± 0.02 /h across compensatory-evolution generations, with bootstrap (500 reps) 95 % CIs.
**Why this paper:** the *only* paper in our literature review with bootstrap CIs on the fitted parameter. Best chance of reproducing the original analysis cleanly. The endpoint differences are large (3×) and should survive any reasonable reanalysis; the per-generation transitions are within ~1.5× and are the sensitive comparisons.

**Data status:** TBD — *Nat. Commun.* policy is data on reasonable request; supplementary materials may include curves.

## 2. Pennone et al. 2021 — *Foods* 10:1099

**DOI:** 10.3390/foods10051099
**Title:** Omnibus modelling of *Listeria monocytogenes* growth rates at low temperatures.
**Domain:** food microbiology.
**Original claim:** μ_max with 95 % CIs across temperatures from 4.5 °C to 12 °C; explicit argument that the omnibus framework's wider CIs are the correct ones for shelf-life prediction.
**Why this paper:** closest in spirit to MisspecStudy's argument — the authors themselves make the case that proper uncertainty matters. A successful reanalysis here is a direct validation of our approach. *Foods* (MDPI) typically has raw data in supplementary materials.

**Data status:** TBD — MDPI's open-access policy usually includes a data availability statement.

## 3. Chowdhury et al. 2023 — *ACS Infect. Dis.* 9:1834

**DOI:** 10.1021/acsinfecdis.3c00156
**Title:** Fitness costs of antibiotic resistance impede the evolution of resistance to other antibiotics.
**Domain:** antimicrobial / evolution.
**Original claim:** AUC of fitted growth curves 8× lower for omadacycline-resistant mutant vs WT; 5× lower stationary OD; evolved-recovery line AUC 5× above resistant parent. Uncertainty reported as SEM only (N=16).
**Why this paper:** SEM-only is the most common practice in our review; this represents the *modal* case. Headline 5–8× differences should survive any reanalysis, but intermediate comparisons at p ≈ 0.01 are the interesting cases.

**Data status:** TBD — ACS journals increasingly require supplementary data.

## Substitution plan

If a target's data is genuinely unavailable, substitutes from `04_comparative_claims.tsv` (priority order):

1. **Pedreira et al. 2022** — Hessian-based CI; explicit identifiability discussion. Direct relevance.
2. **Alonso-del Valle et al. 2021** — plasmid carriage fitness costs. SEM only.
3. **Hitomi et al. 2024** — 8-of-9 significance at the edge.

## Next action

Run `pilot/find_data.sh` (to be written) that probes each DOI's supplementary materials and the lab/group websites for raw data links; record outcomes in this file.
