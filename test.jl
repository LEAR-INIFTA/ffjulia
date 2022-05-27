include("FitFlashPhotolysisTrace.jl")
include("LoopDir.jl")

using .FitFlashPhotolysisTrace, .LoopDir
using Plots, StatsPlots, Statistics, DataFrames
using EasyFit,CSV, LsqFit

fitTrace("NQ D 600 nm 400 us Delta OD KV 1_75 Ar 20 disparos.txt")

filename = "NQ stock 600 nm 400 us Delta OD KV 1_75 Ar 20 disparos.txt"

# plotTrace(dirpath1*filename)

split(filename, " ")[2]

# readdir("FlashPhotolysis/2022_5_13/")

dirpath1 = "FlashPhotolysis/2022_5_13/"
dirpath2 = "FlashPhotolysis/2022_5_20/"

ph9 = loopDir(dirpath1)
ph10 = loopDir(dirpath2,"10")

ph9 = filter(:As3 => x -> x >= 0, ph9)

print(ph10)

@df ph9 scatter(
    :As3,
    :invTau
)

@df ph10 scatter(
    :As3,
    :invTau
)

df3 = combine(groupby(ph10, :As3), :invTau => mean)

both = "FlashPhotolysis/2022_5_20/NQ C 600 nm 400 us Delta OD KV 1_80 Ar 20 disparos.txt"
trace = CSV.read(both, DataFrame, 
        header=["time", "OD", "discard"], skipto=1011, drop=["discard"])

trace = trace[1:1000,:]

mv10 = movavg(trace.OD,10)
mv100 = movavg(trace.OD,100)

plot(trace.time,[trace.OD,mv10.x, mv100.x])

function model(time,p)
    p[1] .+ p[2]* exp.(-p[3]*time)
end

p0 = [1e-3,1e-2,1e-5]

fit = curve_fit(model, trace.time, trace.OD, p0)
fitmv10 = curve_fit(model, trace.time, mv10.x, p0)
fitmv100 = curve_fit(model, trace.time, mv100.x, p0)

function plotFits(trace, fits)
    for fit in fits
        plot!(trace.time,model(trace.time,fit.param), linewidth=3)
    end
    # plot!(trace.time,model(trace.time,fitmv10.param), linewidth=3)
    # plot!(trace.time,model(trace.time,fitmv100.param), linewidth=3)
end

plotFits(trace, fit, fitmv10, fitmv100)

fit.param
fitmv10.param
fitmv100.param