# P02 — Pennone et al. 2021, *Foods* 10(5):1099

**DOI:** 10.3390/foods10051099
**Title:** Omnibus Modelling of *Listeria monocytogenes* Growth Rates at Low Temperatures.
**Corresponding author:** Francis Butler (UCD School of Biosystems and Food Engineering, Dublin).
**Co-authors:** V. Pennone, U. Gonzales-Barron, K. Hunt, V. Cadavez, O. McAuliffe.

## Correction to brief

The brief lists conditions of **4.5, 6, 8, 10, 12 °C**. The paper as published uses **three temperatures**: 4.5 °C, 7.8 °C, and 12.0 °C. Five *L. monocytogenes* strains: NCTC10527, 12MOB045LM, 12MOB080LM, 12MOB079LM, 12MOB099LM. Plate-count (CFU·mL⁻¹) over time, not OD.

## Quantitative claim to reanalyse

Compare growth-rate (√μ_max) estimates obtained by:
1. **First-order modelling** — Huang primary fit per (strain × temperature) combination (Table 2–6 for the five strains).
2. **Omnibus modelling** — single mixed-effects nonlinear fit covering all conditions in one step (Tables 4–8).

Authors' argument: the omnibus framework's wider 95 % CIs on μ_max are the *correct* uncertainty for shelf-life prediction. Reported μ_max estimates with sequential vs. omnibus 95 % CI per strain × temperature.

## Parameter and groups

- **Parameter:** √μ_max (h⁻¹·⁰·⁵) (Ratkowsky-square-root parameterisation).
- **Groups:** five strains × three temperatures = 15 (strain × temperature) cells, ~3 replicate plate-count series per cell.
- **Reported uncertainty:** 95 % CIs (mixed-effects approximate), plus between-condition random-effect variance components s_u (Y₀), s_v (√μ_max), s_w (Y_max).

## Why this matters for MisspecStudy

This is the **only paper in our literature review** whose authors explicitly argue that the wider CI obtained from a hierarchical/mixed-effects fit is the correct uncertainty for downstream regulatory decisions — i.e. exactly the argument MisspecStudy is trying to validate quantitatively. A successful Bayesian reanalysis that recovers the omnibus CIs (or widens them further when prior misspecification is propagated) would be a direct, on-thesis validation.
