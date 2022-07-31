function _tryparse(T::Type, str::AbstractString, dfl = nothing)
    v = tryparse(T, str)
    return isnothing(v) ? dfl : v
end