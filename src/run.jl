# TODO: Use ExternalCmds

## ------------------------------------------------------------
# Utils
function _printcmd(str::String; len = 60)
    isempty(str) && return
    str = strip(str)
    if length(str) > len
        @info(string("\n", str, "\n", " "))
    else
        @info(str)
    end
end

## ------------------------------------------------------------
# read
function _read_cmd(cmd::Cmd;
        print_fun = _printcmd,
        ignorestatus = true, 
        verbose = true, 
        cmdkwargs...
    )
    cmd = Cmd(cmd; ignorestatus, cmdkwargs...)
    out = read(cmd, String)
    verbose && print_fun(out)
    return out
end

function _read_bash(src::String; 
        print_fun = _printcmd,
        ignorestatus = true, 
        verbose = true,
        cmdkwargs...
    )
    cmd = Cmd(`bash -c $(src)`; ignorestatus, cmdkwargs...)
    out = read(cmd, String)
    verbose && print_fun(out)
    return out
end

## ------------------------------------------------------------
# spawn
function _spawn_bash(src::String; cmdkwargs...)
    cmd = Cmd(`bash -c $(src)`; cmdkwargs...)
    proc = run(cmd; wait = false)
    return _try_getpid(proc)
end

function _spawn_cmd(cmd::Cmd)
    proc = run(cmd; wait = false)
    return _try_getpid(proc)
end

## ------------------------------------------------------------
# run
function _run_bash(src::String; cmdkwargs...)
    cmd = Cmd(`bash -c $(src)`; cmdkwargs...)
    run(cmd; wait = true)
    return nothing
end

## ------------------------------------------------------------
# cmd to string
function _to_string_cmd(cmd::Cmd)
    cmd_str = string(cmd)
    cmd_str = replace(cmd_str, r"\A\`" => "")
    cmd_str = replace(cmd_str, r"\`\Z" => "")
    return cmd_str
end

_julia_cmd_str() = _to_string_cmd(Base.julia_cmd())