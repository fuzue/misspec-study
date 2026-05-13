# Load Pedreira 2022 deposit into per-organism GrowthData.
#
# Input:  raw/data_Bc.mat, raw/data_Ec.mat from the Zenodo deposit.
# Output: NamedTuple (organism, ddac, times, mean_OD, sd_OD) per curve;
#         convenience constructor `growthdata_for(organism)` returns a single
#         GrowthData with 7 rows (one per DDAC concentration).
#
# Note: deposit contains across-replicate mean + SD per timepoint, not the
# individual replicate traces.

using Kinbiont: GrowthData
using MAT

const PEDREIRA_RAW = joinpath(@__DIR__, "..", "..", "pilot", "S01_pedreira_2022", "raw")

"""
    load_pedreira(organism::Symbol) -> NamedTuple

`organism` is `:Bc` or `:Ec`. Returns a NamedTuple with
- `ddac::Vector{Float64}`: DDAC concentrations [mg/L], length 7
- `times::Vector{Vector{Float64}}`: timepoints [h] per concentration (Ec has 11 or 12 points)
- `mean_OD::Vector{Vector{Float64}}`: across-replicate mean OD per concentration
- `sd_OD::Vector{Vector{Float64}}`: across-replicate SD per concentration
- `labels::Vector{String}`: one label per concentration, e.g. "Bc_0.05mgL"

Ragged structure (variable timepoint count per condition) is preserved because
the Ec deposit has 11 timepoints for the first three DDAC concentrations.
"""
function load_pedreira(organism::Symbol)
    file = organism === :Bc ? "data_Bc.mat" : "data_Ec.mat"
    d = matread(joinpath(PEDREIRA_RAW, file))
    ddac    = vec(Float64.(d["uu"]))
    times   = [vec(Float64.(d["tt"][j])) for j in eachindex(ddac)]
    mean_OD = [vec(Float64.(d["X_OD"][j])) for j in eachindex(ddac)]
    sd_OD   = [vec(Float64.(d["Ei_OD"][j])) for j in eachindex(ddac)]
    labels  = ["$(organism)_$(round(c; sigdigits=2))mgL" for c in ddac]
    return (; ddac, times, mean_OD, sd_OD, labels)
end

"""
    growthdata_for(organism::Symbol) -> Kinbiont.GrowthData

Wrap the mean OD trajectories as a 7-curve GrowthData (one curve per DDAC concentration).
Errors if the organism has ragged timepoints across concentrations (Ec has 11 vs 12).
"""
function growthdata_for(organism::Symbol)
    P = load_pedreira(organism)
    if any(length(t) != length(P.times[1]) for t in P.times)
        throw(ArgumentError("$(organism) has ragged timepoints — use load_pedreira and fit per-curve"))
    end
    mat = permutedims(reduce(hcat, P.mean_OD))
    return GrowthData(mat, P.times[1], P.labels)
end
