## ------------------------------------------------------------------
# Utils

TkeyDict(T::DataType) = Dict{T, Any}()
function TkeyDict(nTkdict::Dict, T::DataType, convfun = T)
    Tkdict = TkeyDict(T)
    for (nTk, dat) in nTkdict
        Tkdict[convfun(nTk)] = dat
    end
    return Tkdict
end
TkeyDict(nt::NamedTuple, T::DataType, convfun = T) =
    TkeyDict(Dict(pairs(nt)...), T, convfun)

TkeyDict(nt::Base.Iterators.Pairs, T::DataType, convfun = T) =
    TkeyDict(Dict(pairs(nt)...), T, convfun)


