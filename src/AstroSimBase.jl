module AstroSimBase

using PrecompileTools
import Distributed.interrupt
import Base: length, iterate

export LoggingMode, NormalMode, ProgressMode, SilentMode
export GravityModel, Newton, MOND1983Milgrom, QUMOND
export DeviceType, CPU, GPU
export TimeIntegration, Euler, Leapfrog, RK4
export BoundaryCondition, Periodic, Dirichlet, Vacuum, Newman, Reflective

export traitstring, emptyfunction
export randin
export mkpathIfNotExist
export need_to_interrupt, interrupt

export findfirstzero, findzero, findfirstvalue, findvalue
export middle_exp

# Traits
abstract type LoggingMode end
struct NormalMode <: LoggingMode end
"Logging with progress bar"
struct ProgressMode <: LoggingMode end
struct SilentMode <: LoggingMode end

@inline length(p::T) where T <: LoggingMode = 1
@inline iterate(p::T) where T <: LoggingMode = (p,nothing)
@inline iterate(p::T,st) where T <: LoggingMode = nothing

"Gravity model. Supported: `Newton`, `MOND1983Milgrom`, `QUMOND`"
abstract type GravityModel end
"Traditional Newtonian gravity"
struct Newton <: GravityModel end
"Milgrom 1983 formula of MOND"
struct MOND1983Milgrom <: GravityModel end
"QUasi-linear MOdified Newtonian Dynamics"
struct QUMOND <: GravityModel end

@inline length(p::T) where T <: GravityModel = 1
@inline iterate(p::T) where T <: GravityModel = (p,nothing)
@inline iterate(p::T,st) where T <: GravityModel = nothing

abstract type DeviceType end
struct CPU <: DeviceType end
struct GPU <: DeviceType end

@inline length(p::T) where T <: DeviceType = 1
@inline iterate(p::T) where T <: DeviceType = (p,nothing)
@inline iterate(p::T,st) where T <: DeviceType = nothing

abstract type TimeIntegration end
"1st-order explicit Euler time integration"
struct Euler <: TimeIntegration end
"Leapfrog time integration"
struct Leapfrog <: TimeIntegration end
"4-th order Runge-Kutta time integration"
struct RK4 <: TimeIntegration end
#"Hierarchical time integration"
#struct Hierarchical <: TimeIntegration end

@inline length(p::T) where T <: TimeIntegration = 1
@inline iterate(p::T) where T <: TimeIntegration = (p,nothing)
@inline iterate(p::T,st) where T <: TimeIntegration = nothing

abstract type BoundaryCondition end
struct Periodic <: BoundaryCondition end
struct Dirichlet <: BoundaryCondition end
struct Vacuum <: BoundaryCondition end
struct Newman <: BoundaryCondition end
struct Reflective <: BoundaryCondition end

@inline length(p::T) where T <: BoundaryCondition = 1
@inline iterate(p::T) where T <: BoundaryCondition = (p,nothing)
@inline iterate(p::T,st) where T <: BoundaryCondition = nothing

# Functions
"Better printing of trait types"
traitstring(t) = string(t)[1:end-2]

"""
function emptyfunction(args...) end

    Accept any outputs but doing nothing.

    It is designed for initializing callback functions
"""
function emptyfunction(args...) end

"""
function mkpathIfNotExist(dir)

    If the `dir` does not exist, create the path.
"""
function mkpathIfNotExist(dir)
    if !isdir(dir)
        mkpath(dir)
    end
end

"""
function need_to_interrupt(OutputDir::String)

    If there is a file named `stop` in folder `OutputDir`, return true; else, return `false`.

## Keywords
- `remove`: if true, remove the `stop` file asynchronously
- `delay`: if true, wait for 0.1 second to avoid file locking error
"""
function need_to_interrupt(OutputDir::String; remove = false, delay = true)
    if isfile(joinpath(OutputDir, "stop"))
        if remove
            Threads.@spawn begin
                delay && sleep(0.1)
                rm(joinpath(OutputDir, "stop"), force = true)
            end
        end
        return true
    else
        return false
    end
end

function interrupt(OutputDir::String)
    f = open(joinpath(OutputDir, "stop"), "w")
    close(f)
end

"""
function randin(T, a, b)
function randin(a, b)

Generate uniform random number in `[a,b]`. It avoids error from `rand(a:b)` where `a` and `b` are `Unitful.Quantity`
"""
randin(T, a, b) = T(rand(T) * (b-a) + a)
randin(a, b) = rand() * (b-a) + a


"""
function findfirstzero(a::AbstractVector)

    find first zero point of discrete value array
"""
function findfirstzero(a::AbstractVector)
	findfirst(!iszero, diff(sign.(a)))
end

"""
function findzero(a::AbstractVector)
    
    find all zero points (indices of left-hand-side and right-hand-side boundaries) of discrete value array
"""
function findzero(a::AbstractVector)
    findall(!iszero, diff(sign.(a)))
end

"""
function findfirstvalue(a::AbstractVector, v)

    find zero point of discrete value array
"""
function findfirstvalue(a::AbstractVector, v)
    findfirstzero(a .- v)
end

"""
function findvalue(a::AbstractVector, v)

    find all value points (indices of left-hand-side and right-hand-side boundaries) of discrete value array
"""
function findvalue(a::AbstractVector, v)
    findzero(a .- v)
end


"""
function middle_exp(a::AbstractVector)

    Find 1/e value ralative to maximum and minimum
"""
function middle_exp(a::AbstractVector)
    (maximum(a) - minimum(a))/exp(1) - minimum(a)
end

include("precompile.jl")

end # module AstroSimBase