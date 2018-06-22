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

#PROGRAM LOGIC
P0=F_P0()
Omeg=F_Omeg()
P1=F_P1(Omeg, P0)
V1=F_V1(Omeg,P1)


