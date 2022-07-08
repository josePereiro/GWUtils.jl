const _GW_LOG_EXT = ".log"
_is_log_file(path) = endswith(path, _GW_LOG_EXT)

## ------------------------------------------------------------------------------
function _gw_filelog_formater(io, args)
    if isempty(args.message) && isempty(args.kwargs)
        # If empty just print a new line
        println(io)
    else
        # Separator
        timetag = Dates.format(now(), "HH:MM:SS.sss")
        println(io, "> ", args.level, " [", timetag , "]: ", args.message)
        for (k, v) in args.kwargs
            kstr = string(k)
            vstr = string(v)
            length(vstr) > 60 ? 
                println(io, kstr, ":\n ", vstr) :
                println(io, kstr, ": ", vstr)
        end
    end
end

_scape_all(str::AbstractString) = isempty(str) ? "" : string("\\", join(str, "\\"))

function _log_format_name(tag, date_format, ext)
    tag_part = isempty(tag) ? "" : string("-", _scape_all(tag))
    ext_part = isempty(ext) ? "" : _scape_all(ext)
    string(date_format, tag_part, ext_part)
end

_log_format_name(tag) = _log_format_name(tag, "yyyy-mm-dd--HH", _GW_LOG_EXT)

# This needs to be updated on __init__
const _GLOBAL_LOGGER = ConsoleLogger[] 

function _set_global_logger()
    empty!(_GLOBAL_LOGGER)
    push!(_GLOBAL_LOGGER, global_logger())
end

function _get_init_logger()
    isempty(_GLOBAL_LOGGER) ? global_logger() : first(_GLOBAL_LOGGER)
end

## ------------------------------------------------------------------------------
# loggers
function _rotating_logger(logdir, nametag)
    lname = _log_format_name(nametag)
    return DatetimeRotatingFileLogger(
        _gw_filelog_formater, logdir, lname; 
        always_flush = true
    )
end

function _tee_logger(logdir, nametag)
    mkpath(logdir)
    TeeLogger(
        _rotating_logger(logdir, nametag),
        _get_init_logger()
    )
end

## ------------------------------------------------------------------------------
function _with_logger(f::Function, logger)
    with_logger(logger) do
        try
            f()
        catch errobj
            err = _err_str(errobj)
            @error("ERROR", err)
            rethrow(errobj)
        end
    end
end

# function _last_logs(log_dir; deep = 1, filter = _is_log_file)
    
#     all_logs = _filterdir(
#         filter, log_dir; 
#         join = true, sort = true
#     )

#     isempty(all_logs) && return String[]
#     i1 = lastindex(all_logs)
#     i0 = max(1, i1 - deep + 1)
#     return all_logs[i1:-1:i0]
# end