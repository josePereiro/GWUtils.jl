function _exportall(filter::Function, mod::Module)
    for sym in names(mod; all = true)
        if filter(sym)
            @eval mod export $(sym)
        end
    end
end

macro _exportall_underscore()
    _exportall(__module__) do sym
        startswith(string(sym), "_")
    end
end

macro _exportall_uppercase()
    _exportall(__module__) do sym
        isuppercase(first(string(sym)))
    end
end

