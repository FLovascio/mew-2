include(MEWDIR*"Mew2.jl")

directory=ARGS[1]

using Base.Threads

maxrange = try
	parse(Int64,ARGS[2])
catch
	println("ARG 2 is not a number, use a number")
	exit()
end

cd(directory)

X=makeMesh(3,0)

function animateVar(i,range,X)
	if( mod(i,3) == 1)
		FFAnimateVorticity(range, X);
	elseif( mod(i,3) == 2)
		FFAnimate("energy",range,X);
	else
		FFAnimateFd(25.0,range, X);
	end
	return 0;
end


for i=1:3
	animateVar(i,1:maxrange, X)
end










