#Tools for studying density distributions

module densityTools
export fd

function fd(P,rho,cs²)
	return 1.0.-(P./(cs².*rho))
end

function cooling(P,rho,cs²,X)
	
end

end
