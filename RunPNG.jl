include(MEWDIR*"Mew2.jl")

using Base.Threads

jobs = Dict{String,Vector{Float64}}()

for element in ARGS
  N=try
	parse(Int64,element)
  catch
	
end

X=makeMesh(3,0)





