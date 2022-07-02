_err_str(err) = sprint(showerror, err, catch_backtrace())

"""
    print the err text
"""
_printerr(io::IO, err) = print(io, _err_str(err))
_printerr(err) = _printerr(stdout, err)