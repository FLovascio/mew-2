#includes
Mew2Dir="~/src/DataAnalysis/Mew-2/";
push!(LOAD_PATH, Mew2Dir)
using	PorusMedium
using fargoRead
import Base.read
import Base.eof
using DelimitedFiles
using Plots
using LaTeXStrings
using Plots
using velocityTools
import densityTools

pyplot();

function FFPlot(name,number,X)
    data=fargo_read("gas"*name*string(number)*".dat");
    Vz0=toMesh(data,X,false);
    return surface(X["x"],X["y"],Vz0[:,:,1],framestyle=:box)
end

function FFContour(name,number,X)
    data=fargo_read("gas"*name*string(number)*".dat");
    Vz0=toMesh(data,X,false);
    return contour(X["x"],X["y"],Vz0[:,:,1],fill=true,framestyle=:box)
end

function FFHMap(name,number,X)
    data=fargo_read("gas"*name*string(number)*".dat");
    Vz0=toMesh(data,X,false);
    return heatmap(X["x"],X["y"],Vz0[:,:,1],xlabel="y",ylabel="x",framestyle=:box)
end

function FFHMap(name,number,X,col)
    data=fargo_read("gas"*name*string(number)*".dat");
    Vz0=toMesh(data,X,false);
    return heatmap(X["x"],X["y"],Vz0[:,:,1],xlabel="y",ylabel="x",color=col,framestyle=:box)
end

function FfdMap(cs²,number,X)
    data=fargo_read("gasenergy"*string(number)*".dat");
    P=toMesh(data,X,false);
    data=fargo_read("gasdens"*string(number)*".dat");
    ρ=toMesh(data,X,false);
    fD=densityTools.fd(P[:,:,1], ρ[:,:,1], cs²)
    return heatmap(X["x"],X["y"],fD,xlabel="y",ylabel="x",color=:pu_or,framestyle=:box)
end

function FVorticityMap(number,X)
    ω=readVorticity(i,X)
    heatmap(X["x"],X["y"],ω[:,:,1],xlabel="y",ylabel="x",colorbar_title="ω",color=:lime_grad,framestyle=:box)
end

function FFAnimate(name,range,X,col)
    an= @animate for i = range
                    data=fargo_read("gas"*name*string(i)*".dat");
                    Vz0=toMesh(data,X,false);
                    heatmap(X["x"],X["y"],Vz0[:,:,1],label="y",ylabel="x",color=col,framestyle=:box)
                 end
    gif(an, "./"*name*".gif", fps = 15)
end

function FFAnimate(name,range,X)
    an= @animate for i = range
                    data=fargo_read("gas"*name*string(i)*".dat");
                    Vz0=toMesh(data,X,false);
                    heatmap(X["x"],X["y"],Vz0[:,:,1],xlabel="y",ylabel="x",colorbar_title=name,color=:viridis,framestyle=:box)
                 end
    gif(an, "./"*name*".gif", fps = 15)
end

function FFAnimateVorticity(range,X)
    an= @animate for i = range
                    ω=readVorticity(i,X)
                    heatmap(X["x"],X["y"],ω[:,:,1],xlabel="y",ylabel="x",colorbar_title="ω",color=:lime_grad,framestyle=:box)
                 end
    gif(an, "./Vorticity.gif", fps = 15)
end

function FFAnimateFd(cs²,range,X)
    an= @animate for i = range
                    data=fargo_read("gasenergy"*string(i)*".dat");
                    P=toMesh(data,X,false);
                    data=fargo_read("gasdens"*string(i)*".dat");
                    ρ=toMesh(data,X,false);
                    fD=densityTools.fd(P[:,:,1], ρ[:,:,1], cs²)
                    heatmap(X["x"],X["y"],fD,xlabel="y",ylabel="x",color=:pu_or,framestyle=:box)
                 end
    gif(an, "./Fd.gif", fps = 15)
end

function readVorticity(time,X)
    data=fargo_read("gasvy"*string(time)*".dat");
    VyN=toMesh(data,X,false);
    data=fargo_read("gasvx"*string(time)*".dat");
    VxN=toMesh(data,X,false);
    ω=FDM_Vorticity(VxN,VyN,X)
    ω[1,:,:]=ω[2,:,:]
    ω[end,:,:]=ω[end-1,:,:]
    ω[:,1,:]=ω[:,2,:]
    ω[:,end,:]=ω[:,end-1,:]
    return ω
end


function help()
		println("
Please pass an arguement into this help function:
help(\"Mew\") for help with the Mew simulation output analyser
help(\"J_FAC\") for help with the Scope Analyser functions
						
						
Good Luck!"
						)
end

function help(Family::String)
		if Family=="Mew"
				println("to be implemented")
		elseif Family=="J_FAC"
				println("to be implemented")
		else 
				println("use a valid arguement, try help() for more info")
		end
end


