const _GW_NUSV_SEP = "_"


function _nusv_file_name(v, vs...)
    join(string.((v, vs...)), _GW_NUSV_SEP)
end

function _parse_nusv(fn::String)
    n = basename(fn)
    string.(split(n, _GW_NUSV_SEP; keepempty = false))
end

function _has_usvvalue(fn::String, hint)
    hint = string(hint)
    values = _parse_nusv(fn)
    for v in values
        hint == v && return true
    end
    return false
end
