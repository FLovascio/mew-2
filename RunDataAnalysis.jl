include(MEWDIR*"Mew2.jl")

directory=ARGS[1]


maxrange = try
	parse(Int64,ARGS[2])
catch
	println("ARG 2 is not a number, use a number")
	exit()
end

cd(directory)

X=makeMesh(3,0)

FFAnimateVorticity(1:maxrange, X)
FFAnimate("energy",0:maxrange,X)
FFAnimateFd(25.0,1:maxrange, X)












