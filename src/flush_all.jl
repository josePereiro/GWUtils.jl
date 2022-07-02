function _flush_all()
    Base.flush(stdout)
    Base.flush(stderr)
    Base.Libc.flush_cstdio()
end