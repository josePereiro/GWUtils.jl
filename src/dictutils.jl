function _haskeys(d, k, ks...)
    for ki in ks
        !haskey(d, ki) && return false
    end
    return haskey(d, k)
end

function _haspairs(d, p, ps...)
    for (k, v) in ps
        !haskey(d, k) && return false
        v != d[k] && return false
    end
    k, v = p
    !haskey(d, k) && return false
    v != d[k] && return false
    return true
end

function _hasvalues(d, v, vs...)
    dvals = Set(values(d))
    !(v in dvals) && return false
    for v in vs
        !(v in dvals) && return false
    end
    return true
end