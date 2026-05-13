"""
Coverage / sharpness scoring on per-replicate posterior samples.

A method's output for one replicate is a `Dict{Symbol, Vector{Float64}}` of
posterior samples per parameter. Coverage aggregates over many replicates.
"""

using Statistics: mean, quantile

"""
    coverage_95(samples::AbstractVector, truth::Real) -> Bool

Whether the 95% equal-tail interval of `samples` contains `truth`.
"""
function coverage_95(samples::AbstractVector, truth::Real)
    lo, hi = quantile(samples, [0.025, 0.975])
    return lo <= truth <= hi
end

"""
    interval_width_95(samples::AbstractVector) -> Float64
"""
function interval_width_95(samples::AbstractVector)
    lo, hi = quantile(samples, [0.025, 0.975])
    return hi - lo
end

"""
    summarise(per_rep_results, param_names) -> NamedTuple

Aggregate over replicates: per parameter, fraction of 95% intervals that cover
the truth and mean interval width. `per_rep_results` is a vector of named tuples
`(samples = Dict{Symbol,Vector}, truth = NamedTuple)`.
"""
function summarise(per_rep_results, param_names)
    rows = NamedTuple[]
    for name in param_names
        sym = Symbol(name)
        covered = 0
        widths = Float64[]
        for r in per_rep_results
            haskey(r.samples, sym) || continue
            haskey(r.truth, sym)   || continue
            s = r.samples[sym]
            covered += coverage_95(s, r.truth[sym]) ? 1 : 0
            push!(widths, interval_width_95(s))
        end
        push!(rows, (
            param        = String(sym),
            n_reps       = length(per_rep_results),
            coverage_95  = covered / length(per_rep_results),
            mean_width   = mean(widths),
        ))
    end
    return rows
end
