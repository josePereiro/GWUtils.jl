#=
TODO: Make a track and print system

From the server side track all logs and task outs
From the client, track on demand (make also a loop for async tracking)

=#

## ------------------------------------------------------------------
mutable struct FileListener
    on_init::Function
    path::String
    cursor::Int
    size::Int

    FileListener(on_init, path) = new(on_init, path, -1, -1)
    function FileListener(path; from_beginning = true)
        return from_beginning ? 
            FileListener((path) -> (0, 0), path) :
            FileListener((path) -> (_countbytes(path), _filesize(path)), path)
    end
end

struct DirListener
    filter::Function
    on_init::Function
    path::String
    file_listeners::Dict{String, FileListener}

    DirListener(filter::Function, on_init::Function, path::AbstractString) = new(filter, on_init, path, Dict{String, FileListener}())
    function DirListener(filter::Function, path::AbstractString; from_beginning = true)
        from_beginning ? 
            DirListener(filter, (path) -> (0, 0), path) :
            DirListener(filter, (path) -> (_countbytes(path), _filesize(path)), path)
    end
    DirListener(path::AbstractString; from_beginning = true) = 
        DirListener((path) -> true, path; from_beginning)
end

## ------------------------------------------------------------------
function _readbytes!(fl::FileListener)

    bytes = UInt8[]

    # init check
    isfile(fl.path) || return bytes
    if (fl.cursor == -1) && (fl.size == -1)
        fl.cursor, fl.size = fl.on_init(fl.path) # modified itself (cursor, size)
    end

    # check size
    reg_size = fl.size
    curr_size = _filesize(fl.path)
    curr_size != reg_size || return bytes
    # @show fl

    # print
    open(fl.path, "r") do io
        skip(io, fl.cursor)
        new_bytes = read(io)
        if length(new_bytes) > 0
            fl.cursor += length(new_bytes)
            fl.size = curr_size
            bytes = new_bytes
        end
    end

    return bytes
end

function _readbytes!(dl::DirListener)
    dlbytes = Dict{String, Vector{UInt8}}()

    # init check
    isdir(dl.path) || return dlbytes

    # _readbytes!(fl)
    fls = dl.file_listeners
    for path in _readdir(dl.path; join = true)
        
        isfile(path) || continue
        dl.filter(path) || continue

        fl = get!(fls, path) do
            FileListener(dl.on_init, path)
        end
        bytes = _readbytes!(fl)
        isempty(bytes) && continue
        dlbytes[path] = bytes
    end
    return dlbytes
end