function _hash_file(fn::String)
    h0 = hash("")
    !isfile(fn) && return h0
    for line in eachline(fn)
        h0 = hash(line, h0)
    end
    return h0
end