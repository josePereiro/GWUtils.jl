function _write_toml(fn::AbstractString, dat::Dict; sorted = true)
    _mkdir(fn)
    open(fn, "w") do io
        TOML.print(io, dat; sorted)
        return fn
    end
end

_write_toml(fn; kwargs...) = _write_toml(fn, TkeyDict(kwargs, Symbol))

function _read_toml(fn)
    !isfile(fn) && return Dict{String, Any}()
    try; return TOML.parsefile(fn)
    catch err
        (err isa Base.TOML.ParserError) && return Dict{String, Any}()
        rethrow(err)
    end
end

function _merge_toml(fn::AbstractString, dat::Dict; sorted = true)
    toml = _read_toml(fn)
    merge!(toml, dat)
    _write_toml(fn, toml)
end

# function _haspairs(fn::AbstractString, p, ps...)
#     dat = _read_toml(fn)
#     _haspairs(dat, p, ps...)
# end

# function _haskeys(fn::AbstractString, k, ks...)
#     dat = _read_toml(fn)
#     return _haskeys(dat, k, ks...)
# end