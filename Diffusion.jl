#LETS CALCULATE STUFF!!


#FREE PARAMETERS
Rho0=50.0
Rho1=0.1
k=1.0
ts=10.0
Cs=1.0
fd=0.2

#DEPENDENT PARAMETERS
F_Omeg()=(im*(Cs^2)*ts*fd*k*k)+sqrt(complex(-1*(Cs^4)*(ts^2)*(fd^2)*(k^4)+4*(k^2)*(Cs^2)*(1-fd)))
F_P1(Omeg::Complex, P0::Real)=((im*P0)/(im*Omeg+((Cs^2)*ts*k*((1-Rho0)/((Cs^2)*Rho0)))))*(Rho1*Omeg/Rho0)
F_P0()=(Cs^2)*(1-fd)*(Rho0)
F_V1(Omeg::Complex, P1::Complex)=(k/(Rho0*Omeg))*P1

OMEGA=F_Omeg();

#TIME PROGRESSION
P_t(P0,P1,t,x)=P0+P1*e^(im*(OMEGA*t+k*x))
function newP(P0,P1,t,x)
	NewP=deepcopy(P0)
	#for i=1:size(P0)
		NewP=P_t(P0,P1,t,x)
	#end
	return NewP
end

#=function newP0(P0,t,x)
	NewP=deepcopy(P0)
	for i=1:size(P0)
		NewP[i]=P_t(P0[i],t,x)
	end
	return NewP
end
=#

#=function make_init(step_number)
	p0=F_P0()
	F_P1=F_P1(OMEGA,p0)
	step_size= 
	for i=1:step_number
=#

