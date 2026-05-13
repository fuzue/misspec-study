# PubMed Primary Papers Survey - Notes

## Search Reproducibility

Search conducted 2026-05-11 via NCBI E-utilities (esearch + efetch).

### Queries Run (and total hits)

1. `("Gompertz"[Title/Abstract] OR "Baranyi"[Title/Abstract] OR "logistic growth"[Title/Abstract]) AND ("OD600"[Title/Abstract] OR "growth rate"[Title/Abstract] OR "growth curve"[Title/Abstract]) AND ("2020"[Date - Publication] : "2026"[Date - Publication])`
   - **Hits returned: 337** (top 200 PMIDs retrieved)

2. `("antimicrobial susceptibility"[Title/Abstract] OR "drug screening"[Title/Abstract]) AND "growth curve"[Title/Abstract] AND ("2020"[Date - Publication] : "2026"[Date - Publication])`
   - **Hits returned: 38**

3. `("experimental evolution"[Title/Abstract]) AND ("fitness"[Title/Abstract] OR "growth rate"[Title/Abstract]) AND ("2020"[Date - Publication] : "2026"[Date - Publication])`
   - **Hits returned: 482** (top 200 PMIDs retrieved)

4. `("predictive microbiology"[Title/Abstract] OR "Baranyi model"[Title/Abstract]) AND ("2020"[Date - Publication] : "2026"[Date - Publication])`
   - **Hits returned: 235** (top 200 PMIDs retrieved)

5. `("plate reader"[Title/Abstract] OR "high-throughput growth"[Title/Abstract]) AND "growth"[Title/Abstract] AND ("2020"[Date - Publication] : "2026"[Date - Publication])`
   - **Hits returned: 91**

**Aggregate unique PMIDs in the candidate pool: ~1100+** (with substantial overlap between queries).

## Coding Summary

- **Abstracts read & coded: 90 papers** (in TSV)
- **Truly on-topic primary microbial OD/CFU growth-curve papers: ~55** (the rest are off-topic — animal/tumor/plant growth — but were retained in the TSV with a `domain` of `other` to document why they were excluded).
- The "off-topic" papers are surprisingly common because terms like "Gompertz" and "logistic growth" dominate poultry, fish, livestock, fetal, and tumor literature. This is a methodologically important observation in its own right: most Gompertz papers in PubMed 2020-2026 are NOT microbial.

## Patterns Observed (key for the misspec-study paper)

### 1. Uncertainty is almost universally underreported in microbial growth-curve fitting

Of the ~55 on-topic primary papers coded:
- **~85% report point estimates only.** When uncertainty is reported, it is usually mean ± SD of triplicates (which conflates biological with parameter uncertainty), or just R² / RMSE for the *fit* (not for the parameters).
- **0 papers in the 2020-2026 sample reported Bayesian credible intervals** other than a handful using `brms`-style Bayesian frequentist comparisons (e.g. Black Utrerana chickens, PMID 41101196, but that's not microbial).
- **PMID 39952767 (Penttilä et al., Food Microbiol 2025)** is the standout exception and is highly relevant to the misspec story: it explicitly compares error structure of Baranyi-Roberts vs Gompertz fits and argues BRM is more reliable for CIs. Should be cited prominently.
- **PMID 41135392** (Pseudomonas aeruginosa in mineral water) explicitly uses Bayesian inference on the Ratkowsky secondary model "allowing incorporation of variability" — rare.

### 2. Comparison method is essentially never described in abstracts

- Many papers claim "significantly higher growth rate" or "significant difference" without disclosing the test in the abstract. Most fall back on ANOVA or t-tests at the replicate-mean level. Almost none use bootstrap-CI overlap or Bayesian contrasts on the *model parameters*.
- Antimicrobial papers rarely fit any kinetic model — they just report MIC or "growth curves were measured" qualitatively.

### 3. Software is rarely disclosed in the abstract

- The most frequently named tools were: `Growthcurver` (PMID 38501820, 37873238), `BactEXTRACT` (PMID 38361656), `Welly` (PMID 40092528).
- Custom MATLAB implementations were named in two methods papers: PMID 41080428 (4Z model MATLAB code) and a few methanotroph papers.
- No paper in the sample names Kinbiont, but a small subset uses brms (Bayesian, R), and a few explicitly use bootstrap.

### 4. Replicates handled

- The dominant pattern is to **average across replicates before fitting** (this destroys variance information). A minority (e.g. PMID 39363210 with 1002 curves per condition, PMID 39059941 single-cell time-lapse) fit independently.
- No clearly **hierarchical** fits in the abstract sample.

### 5. Model family distribution (on-topic microbial subset)

- **Baranyi**: most common in food-microbiology / predictive-microbiology applications (~50%).
- **Modified Gompertz / Gompertz**: most common in fungal, biogas, and general microbial work (~30%).
- **Logistic**: most common in microalgae and yeast applications.
- **Richards / ODE / two-compartment**: essentially absent in this random sample.

### 6. The "R² is high, therefore the model is correct" fallacy

- Many papers cite R² > 0.99 as evidence of a good fit, even when residuals across the whole curve trajectory would clearly show systematic misspecification (e.g. PMID 40683734 reports Baranyi R² 0.474-0.997, a huge spread that suggests the model is misspecified for some samples but is not acknowledged as such).

### 7. Calibration is rare

- Only PMID 36228033 ("Estimating microbial population data from optical density") explicitly addresses OD-to-cell calibration.
- Plate-reader calibration / cross-laboratory standardization is recognized as a problem by the synthetic-biology community (PMID 35949424, 37981737) but rarely propagated as parameter uncertainty.

## Inaccessible DOIs / Issues

- A few bioRxiv preprints have unusual DOI format (`10.64898/2026.xx.xx.xxxxxx`) — accessible but unusual.
- Two retrieved entries were corrections / errata (PMID 39992137 is a correction of an earlier paper, PMID 37873238 is the bioRxiv preprint version of PMID 38501820).
- A few PMIDs that appeared in the initial query had only abstract-free entries (mostly older protocol updates) — these were excluded from the TSV.

## How to reproduce

```bash
# Query 1
curl 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&retmax=200&term=%28%22Gompertz%22%5BTitle%2FAbstract%5D+OR+%22Baranyi%22%5BTitle%2FAbstract%5D+OR+%22logistic+growth%22%5BTitle%2FAbstract%5D%29+AND+%28%22OD600%22%5BTitle%2FAbstract%5D+OR+%22growth+rate%22%5BTitle%2FAbstract%5D+OR+%22growth+curve%22%5BTitle%2FAbstract%5D%29+AND+%282020%5BDate+-+Publication%5D+%3A+2026%5BDate+-+Publication%5D%29&retmode=json'

# Then for each batch of ~10 PMIDs:
curl 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=<csv_ids>&rettype=abstract&retmode=text'
```

## Recommendations for the methodological paper

The empirical pattern strongly supports the paper's likely argument: practitioners
- routinely fit Gompertz/Baranyi/logistic without checking model fit beyond R²,
- average replicates before fitting (destroying biological-uncertainty signal),
- report point estimates with no propagation to downstream comparisons (t-test on means),
- claim "significant differences" in μ between strains/conditions without checking if the difference is within the parameter CI.

The Penttilä 2025 paper (PMID 39952767) should be the lead methodological citation since it independently raises the reparametrization / error-structure issue.
