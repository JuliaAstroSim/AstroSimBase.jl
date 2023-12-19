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
    end
end
