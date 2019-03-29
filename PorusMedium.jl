module PorusMedium

export AnalyticSolution, BarenblattSolution, SeparableSolution

function barenblatt(x::Float64, t::Float64)
	A=0.16666666666667
	if A >= ((x^2)/(6*(t^0.6666667)))
		return (t^(-0.333333333))*(A-((x^2)/(6*(t^0.6666667))))
	else
		return 0
	end
end;

function B(x::Array{Float64,1},t::Float64)
	return map(u->barenblatt(u,t),x)
end;

Separable(x,t)=-x^2/(6*t)
SeparableSolution(x,t)=map(a->Separable(a,t),x)
Barenblatt_like(x,t)=0.1666666667*((36.0/(t^0.333333333))- (x^2)/t)
blSol(x,t)=map(a->Barenblatt_like(a,t),x)
AnalyticSolution=blSol
BarenblattSolution=B

end
