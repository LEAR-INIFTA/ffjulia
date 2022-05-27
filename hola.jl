println("hola julia")
using CSV, DataFrames, Plots, StatsPlots, ScikitLearn, LsqFit



a = CSV.read("NQ D 600 nm 400 us Delta OD KV 1_75 Ar 20 disparos.txt", 
                DataFrame, header=["time", "OD", "discard"], skipto=1011, drop=["discard"])

@df a scatter(
    :time,
    :OD
)

b = a[3:end, :]

# @df b Plots.plot(:time, :OD)


f(t, p) = p[1] .+ p[2]* exp.(-p[3]*t)

p0 =  [1e-3,1e-3,3e-4]

fit = curve_fit(f, b.time, b.OD, p0)

### Residuals plot

plot!(b.time, f(b.time, fit.param), linewidth=3)

fit.param

covar = estimate_covar(fit)

steerr = standard_errors(fit)


Plots.savefig("hola.png")