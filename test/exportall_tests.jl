println()
println("-"^60)
@info("Testing", file = basename(@__FILE__))
println()

## ------------------------------------------------------
module test1
    import GWUtils: @_exportall_underscore
    import GWUtils: @_exportall_uppercase
    
    const _test1_bla = 1
    const TEST1_BLA = 1
    
end
@test !(:_test1_bla in names(test1))
@test !(:TEST1_BLA in names(test1))

@test !isdefined(Main, :_test1_bla)
@test !isdefined(Main, :TEST1_BLA)
using .test1
@test !isdefined(Main, :_test1_bla)
@test !isdefined(Main, :TEST1_BLA)

## ------------------------------------------------------
# test
module test2
    import GWUtils: @_exportall_underscore
    import GWUtils: @_exportall_uppercase
    
    const _test2_bla = 1
    const TEST2_BLA = 1
    
    @_exportall_underscore
    @_exportall_uppercase
    
end
@test :_test2_bla in names(test2)
@test :TEST2_BLA in names(test2)

@test !isdefined(Main, :_test2_bla)
@test !isdefined(Main, :TEST2_BLA)
using .test2
@test isdefined(Main, :_test2_bla)
@test isdefined(Main, :TEST2_BLA)