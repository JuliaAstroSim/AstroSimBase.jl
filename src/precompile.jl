@setup_workload begin
    @compile_workload begin
        # Traits
        NormalMode()
        ProgressMode()
        SilentMode()

        Newton()
        MOND1983Milgrom()
        QUMOND()

        CPU()
        GPU()

        Euler()
        Leapfrog()
        RK4()
        
        Periodic()
        Dirichlet()
        Vacuum()
        Newman()
        Reflective()

        # Functions
        emptyfunction()
        traitstring(CPU)

        middle_exp([0,1,exp(1),1,0])
        
        findfirstzero([-1, 0, 1])
        findzero([-1, 0, 1, 0, -1])
        findfirstvalue([1,2,3], 2)
        findvalue([1,2,3,2,1], 2)
    end
end
