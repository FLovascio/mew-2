include("/.astro/users2/lovascio/src/DUSTY/setups/dustyWave/WaveCalc.jl")

function makeWave(t::Float64, init::Array{Float64})
	wave=deepcopy(init)
	h=L/(length(init))
	for i=1:length(init)
		x=h*i-0.5*h
		wave[i]=real(P0-abs(P1)*exp(im*(Omeg*t+k*x+angle(P1))))
	end
	return wave
end

function LN(data::Array{Float64},theoretical::Array{Float64},N::Float64)
	L=0.
	for i=1:length(data)
		L=L+abs(data[i]^N -theoretical[i]^N)
	end
	L=(1.0/convert(Float64,length(data)))*L
end

function makeWaveInit(init::Array{Float64})
	wave=deepcopy(init)
	h=L/(length(init))
	X=zeros(length(init))
	for i=1:length(init)
		x=h*i-0.5*h
		wave[i]=real(P0-abs(P1)*exp(im*(k*x+angle(P1))))
		X[i]=x
	end
	return (X,wave)
end
