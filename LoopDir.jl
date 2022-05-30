module LoopDir

using DataFrames, Plots

include("FitFlashPhotolysisTrace.jl")
using .FitFlashPhotolysisTrace

export loopDir

const CONCENTRACIONES = Dict("a" => 1.5e-3, "b" => 5e-4, "c" => 1.5e-4, "d" => 5e-5, 
        "stock" => 5e-3, "blanco" => 0)

function isTxt(filename::String)::Bool
    name = split(filename, ".")
    result = name[end] == "txt"
    return result
end

function getAsConcentrationFromFilename(filename::String)::Float64
    name = lowercase(split(filename, " ")[2])
    concentrationDict = Dict("a" => 1.5e-3, "b" => 5e-4, "c" => 1.5e-4, "d" => 5e-5, 
        "stock" => 5e-3, "blanco" => 0)
    if haskey(concentrationDict, name)
        return concentrationDict[name]
    else
        return -1.0
    end
end

function loopDir(dirpath::String, pH::String = "9.2")::DataFrame
    df=DataFrame(As3 = Float64[], invTau = Float64[], pH = String[])
    plts = []
    for file in readdir(dirpath)
        if isTxt(file)
            println(file)
            # println(fitTrace(dirpath * file))
            fileAndPath = dirpath * file
            concAs = getAsConcentrationFromFilename(fileAndPath)
            results = [concAs, getInvTau(fileAndPath,concAs), pH]
            println(results)
            push!(df, results)
            # push!(plts, plotTrace(fileAndPath))
            display(plotTrace(fileAndPath, concAs))
        end
    end
    return df
end

end #module