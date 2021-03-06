# TEST: Function registration in a module.
# ------------------------------------------------
module MyModule
    using ModelingToolkit, DiffEqBase, LinearAlgebra, Test
    @parameters t x
    @variables u(t)
    @derivatives Dt'~t

    function do_something(a)
        a + 10
    end
    @register do_something(a)

    eq  = Dt(u) ~ do_something(x)
    sys = ODESystem([eq], t, [u], [x])
    fun = ODEFunction(sys)

    @test_broken fun([0.5], [5.0], 0.) == [15.0]
end

# TEST: Function registration in a nested module.
# ------------------------------------------------
module MyModule2
    module MyNestedModule
        using ModelingToolkit, DiffEqBase, LinearAlgebra, Test
        @parameters t x
        @variables u(t)
        @derivatives Dt'~t

        function do_something_2(a)
            a + 20
        end
        @register do_something_2(a)

        eq  = Dt(u) ~ do_something_2(x)
        sys = ODESystem([eq], t, [u], [x])
        fun = ODEFunction(sys)

        @test_broken fun([0.5], [3.0], 0.) == [23.0]
    end
end

# TEST: Function registration outside any modules.
# ------------------------------------------------
using ModelingToolkit, DiffEqBase, LinearAlgebra, Test
@parameters t x
@variables u(t)
@derivatives Dt'~t

function do_something_3(a)
    a + 30
end
@register do_something_3(a)

eq  = Dt(u) ~ do_something_3(x)
sys = ODESystem([eq], t, [u], [x])
fun = ODEFunction(sys)

@test_broken fun([0.5], [7.0], 0.) == [37.0]
