module AstroSimBase

using PrecompileTools

export LoggingMode, NormalMode, ProgressMode, SilentMode
export GravityModel, Newton, MOND1983Milgrom, QUMOND
export DeviceType, CPU, GPU
export TimeIntegration, Euler, Leapfrog, RK4
export BoundaryCondition, Periodic, Dirichlet, Vacuum, Newman, Reflective

export traitstring, emptyfunction
export mkpathIfNotExist
export need_to_interrupt

# Traits
abstract type LoggingMode end
struct NormalMode <: LoggingMode end
"Logging with progress bar"
struct ProgressMode <: LoggingMode end
struct SilentMode <: LoggingMode end

"Gravity model. Supported: `Newton`, `MOND1983Milgrom`, `QUMOND`"
abstract type GravityModel end
"Traditional Newtonian gravity"
struct Newton <: GravityModel end
"Milgrom 1983 formula of MOND"
struct MOND1983Milgrom <: GravityModel end
"QUasi-linear MOdified Newtonian Dynamics"
struct QUMOND <: GravityModel end

abstract type DeviceType end
struct CPU <: DeviceType end
struct GPU <: DeviceType end

abstract type TimeIntegration end
"1st-order explicit Euler time integration"
struct Euler <: TimeIntegration end
"Leapfrog time integration"
struct Leapfrog <: TimeIntegration end
"4-th order Runge-Kutta time integration"
struct RK4 <: TimeIntegration end
#"Hierarchical time integration"
#struct Hierarchical <: TimeIntegration end

abstract type BoundaryCondition end
struct Periodic <: BoundaryCondition end
struct Dirichlet <: BoundaryCondition end
struct Vacuum <: BoundaryCondition end
struct Newman <: BoundaryCondition end
struct Reflective <: BoundaryCondition end


# Functions
"Better printing of trait types"
traitstring(t) = string(t)[1:end-2]

"""
function emptyfunction(args...) end

    Accept any outputs but doing nothing.

    It is designed for initializing callback functions
"""
function emptyfunction(args...) end

function mkpathIfNotExist(dir)
    if !isdir(dir)
        mkpath(dir)
    end
end

"""
function need_to_interrupt(OutputDir::String)

    If there is a file named `stop` in folder `OutputDir`, return true; else, return `false`.
"""
function need_to_interrupt(OutputDir::String)
    if isfile(joinpath(OutputDir, "stop"))
        return true
    else
        return false
    end
end

include("precompile.jl")

end # module AstroSimBase
