using GWUtils
using Test

@testset "GWUtils.jl" begin
    
    include("log_and_listen_tests.jl")
    include("exportall_tests.jl") # Better at the end

end
