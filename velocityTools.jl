#Tools for studying velocity distributions

module velocityTools
export FFT_Vorticity, FDM_Vorticity, parFDM_Vorticity, subtract_shear

using FFTW
using Base.Threads

function FFT_Vorticity(ux,uy)
end

function FDM_Vorticity(ux,uy,X)
	ω=deepcopy(ux)
	for j=2:(length(ux[:,1])-1)
		for i=2:(length(ux[1,:])-1)
			Δx=X["x"][i+1]-X["x"][i-1]
			Δy=X["y"][j+1]-X["y"][j-1]
			ω[i,j]=((uy[i+1,j,1]-uy[i-1,j,1])/Δx) -((ux[i,j+1,1]-ux[i,j-1,1])/Δy)
		end
	end
	ω[1,:,:]=ω[2,:,:]
	ω[end,:,:]=ω[end-1,:,:]
	ω[:,1,:]=ω[:,2,:]
	ω[:,end,:]=ω[:,end-1,:]
	return ω
end

function parFDM_Vorticity(ux,uy,X)
	ω=deepcopy(ux)
	@threads for j=2:(length(ux[:,1])-1)
		for i=2:(length(ux[1,:])-1)
			#Δx=X["x"][i+1]-X["x"][i-1]
			#Δy=X["y"][j+1]-X["y"][j-1]
			ω[i,j]=((uy[i+1,j,1]-uy[i-1,j,1])/(X["x"][i+1]-X["x"][i-1])) -((ux[i,j+1,1]-ux[i,j-1,1])/(X["y"][j+1]-X["y"][j-1])
)
		end
	end
	ω[1,:,:]=ω[2,:,:]
	ω[end,:,:]=ω[end-1,:,:]
	ω[:,1,:]=ω[:,2,:]
	ω[:,end,:]=ω[:,end-1,:]
	return ω
end
function streamFlow(ux,uy,linedensity,X)
	vx(x,y)=0
	vy(x,y)=0
end

function subtract_shear(u,X,Ω)
    v=deepcopy(u)
    for j=1:length(u[:,1])
        for i=1:length(u[1,:])
            v[i,j]=u[i,j]-X["y"][j]*Ω
        end
    end
    return v
end

end
