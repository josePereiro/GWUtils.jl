function _tryparse(T::Type, str::String, dfl = nothing)
    v = tryparse(T, str)
    return isnothing(v) ? dfl : v
end