#Tools for studying density distributions

module densityTools
export dustToMass

function dustToMass(P,rho,cs²)
	return 1.0.-(P./(cs².*rho))
end

end
