include("~/src/DataAnalysis/Mew-2/Mew2.jl")

directory=ARGS[1]
maxrange=ARGS[2]

cd(directory)

X=makeMesh(3,0)

FFAnimateVorticity(1:maxrange, X)
FFAnimate("energy",0:maxrange,X)
FFAnimateFd(25.0,1:maxrange, X)












