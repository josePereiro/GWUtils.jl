println()
println("-"^60)
@info("Testing", file = basename(@__FILE__))
println()

## ------------------------------------------------------
# Test
let

    testdir = joinpath(@__DIR__, "_testing")
    test_scripts = ["test_script_1.jl", "test_script_2.jl"]
    _rm(testdir)
    mkpath(testdir)
    
    pids = Dict()
    test_flags = Dict()
    test_tokens = String[]

    try

        # create scripts
        for name in test_scripts
            path = joinpath(testdir, name)

            token = string(hash(path))
            push!(test_tokens, token)

            write(path, 
                """
                    using GWUtils
                    using Logging

                    rotlog = _tee_logger(@__DIR__, basename(@__FILE__))
                    token = \"$(token)\"

                    _with_logger(rotlog) do

                        while true
                            @info("INFO", getpid(), token)
                            sleep(1.0)
                        end

                    end
                """
            )
        end

        # spawn
        for script in test_scripts
            path = joinpath(testdir, script)
            pid_ = _spawn_bash("julia --startup-file=no --project $(path)"; ignorestatus = true)
            pids[path] = pid_
        end

        from_beginning = false
        dl = DirListener(testdir; from_beginning) do path
            _is_log_file(path)
        end

        test_passed = false
        for t in 1:100

            dir_bytes = _readbytes!(dl)
            for (path, bytes) in dir_bytes

                @test true
                
                str = String(bytes)

                # print
                println()
                println("From ", basename(path))
                println(str)
                println()

                # test
                @show values(test_flags)
                get!(test_flags, path, false)
                test_flags[path] |= any(contains.(str, test_tokens))
            end

            test_passed = !isempty(test_flags) && all(values(test_flags)) 
            @show values(test_flags)
            @show test_passed
            test_passed && break

            sleep(1.0)
        end

        @test test_passed

    finally
        for pid in values(pids)
            _force_kill(pid)
        end
        _rm(testdir)
    end
    
end