#Tools for studying velocity distributions

module distributionTools
export fullWidthHalfMax

using Base.Threads

findMax(A)=(argmax(A),A[argmax(A)])

function subtractHalfMax(A)
	i,Max=findMax(A)
	return A.-(Max/2.0)
end

function signChange(A)
	HA=deepcopy(A)
	for i ∈ CartesianIndices(A[2:end,:])
		HA=sign(A[i]*A[i+CartesianIndex(1,0)])
	end
	HA[1,:].=0
	HA[end,:].=0
	HA[:,1].=0
	HA[:,end].=0
	return HA
end

function FWHM(HA)
	HWA=deepcopy(HA)
	for i ∈ CartesianIndices(HA)
		HHA=HA[i]<0?1:0
	end
	return HHA
end

function fullWidthHalfMax(A)
	return FWHM(signChange(subtractHalfMax(A)))
end

end
