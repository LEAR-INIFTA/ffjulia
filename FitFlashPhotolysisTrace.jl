module FitFlashPhotolysisTrace

using CSV, DataFrames, LsqFit, Plots, StatsPlots

export fitTrace, getInvTau, plotTrace, getExpType

function model(time,p)
    p[1] .+ p[2]* exp.(-p[3]*time)
end


function fitTrace(filename::String, model = model)
    trace = CSV.read(filename, DataFrame, 
        header=["time", "OD", "discard"], skipto=1011, drop=["discard"])

    p0 = [1e-3,1e-2,1e-5]

    # function model(time,p)
    #     p[1] .+ p[2]* exp.(-p[3]*time)
    # end

    fit = curve_fit(model, trace.time, trace.OD, p0)

    # plot!(trace.time, model(trace.time, fit.param))

    return fit.param
end

function getInvTau(filename::String)::Float64
    trace = fitTrace(filename)
    return trace[3]
end

function getExpType(filepath) 
    file = split(filepath,"/")[end]
    exp = split(file, " ")[2]
    return exp
end

function plotTrace(filename)
    trace = CSV.read(filename, DataFrame, 
        header=["time", "OD", "discard"], skipto=1011, drop=["discard"])

    trace = trace[1:2000, :]
    fit = fitTrace(filename)

    plt = @df trace scatter(
        :time,
        :OD,
        title=getExpType(filename),
        alpha=0.2
    )
    plot!(plt,trace.time, model(trace.time, fit), lw=3)
    # plt = plot(trace.time,trace.OD, title=filename)
    # display(plt)
    return plt

    # params = fitTrace(filename)

    # plot!(trace.time, model(trace.time, params))

    # savefig(filename * ".png")
end

end