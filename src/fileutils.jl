_mkdir(path) = mkpath(dirname(path))

_write(filename::AbstractString, x, onerr = -1) = 
    try; write(filename, x) catch _; onerr end 

_read(filename::AbstractString, T, onerr = nothing) = 
    try; read(filename, T) catch _; onerr end 


_readdir(dir, onerr = String[]; join::Bool = false, sort::Bool = true) = 
    try; readdir(dir; join, sort) catch _; onerr end 

function _readdir(f::Function, dir; kwargs...)
    for file in _readdir(dir; kwargs...)
        f(file)
    end
end

_rm(path) = try; rm(path; recursive = true, force = true) catch _; nothing end

function _foldersize(dir)
    size = 0
    for (root, _, files) in walkdir(dir)
        size += sum(filesize.(joinpath.(root, files)))
    end
    return size
end

_cp(src::AbstractString, dst::AbstractString) = try
    _mkdir(dst)
    cp(src, dst; force = true) 
catch _; nothing end

# get the rel path from basename(startpath)
function _relbasepath(path, startpath)
	stoppath = basename(startpath)

	relpath_ = ""
	leftpath = path
	while true
		leftpath, base = splitdir(leftpath)
		(base == stoppath) && break
		relpath_ = isempty(relpath_) ? base : joinpath(base, relpath_)
		(leftpath == dirname(leftpath)) && break
	end

	return relpath_
end

_filesize(path::String) = isfile(path) ? filesize(path) : 0

function _countbytes(path::AbstractString)
    nb = 0
    isfile(path) || return nb
    open(path, "r") do io
        while !eof(io)
            read(io, UInt8)
            nb += 1
        end
    end
    return nb
end

function _merge_dirs(src::AbstractString, dst::AbstractString)
    src = abspath(src)
    dst = abspath(dst)
    for srci in _readdir(src; join = true)
        desti = replace(srci, src => dst)
        _cp(srci, desti)
    end
end

function _clear_git_repo_wdir(gl_repo)
    for path in _readdir(gl_repo; join = true)
        endswith(path, ".git") && continue
        _rm(path)
    end
end

function _dirname(path::AbstractString, n::Int = 1)
    for _ in 1:n
        path = dirname(path)
    end
    return path
end