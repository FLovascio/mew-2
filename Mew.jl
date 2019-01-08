#includes
#using Base.read
#using Base.eof
import Base.read
import Base.eof
using DelimitedFiles
using Plots
using LaTeXStrings
import Plots
include("Diffusion.jl")
#gr()
plotly()
NOSPLASH=true
#splash screen
if(!NOSPLASH)
	println("
                              ##Welcome to µ-2##                                                                  
              ,,,,,,,,.                                  ,*/,.                 
              ./&@@@@@@&*,,                             ./&@@%**.              
                 ./@@@@@@@@(*                            /#@@@@@(,             
                   *%&@@@@@@(. ..,,,,,,***,,,,,,.       ,/@@@@@@@.             
                   .#%&@@@@@@,,(&@@@@@@@@@@@@@@@%/,,,. ,*@@@@@&&&/             
                   .(%%&@@@@@#,@@@@@@@@@@@@@@@@@@@@@@(,*&@@@@&&%%#             
                   ,#&@@@@@@@@(/@@@@@@@@@@@@@@@@@@@@@@@&,(@@&&%%%/             
                   /&@@@@@@@@@@/*@@@@@@@@@@@@@@@@@@@@@@@@@/,%%%%%.             
                 .//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&.#%%%              
                .*(@@@@@@@@@@&&&&&&&&&&&&&&@@@@@@@@@@@&&&&%%( #%(              
               **&@@@@@@@@@&&&&&&&&&&&&&&&&&,&&&&&&&&&&&&&%%%# /               
              */@@@@@@@@@@&&&&&&&&&&&&&&&&&&&,(&&&&&&&&&&&%%%%#                
             */@@@@@@@@@@&&&&%#,,%&&&&&&&&&&&&%,&&&&&&&&&&%%%%%(               
            */@@@@@@@@@@&&&&&%%%,%*,#&&&&&&&&&&&.%&&&&&&&&&%%%%%,              
           ,/&@@@@@@@@@&&&&&&%%/#@@*,*.(&&&&&&&&&,&&&&&&&&&&&%%%%              
           *(@@@@@@@&&&&&&&&%%%,....***/@#,&&&&&&&,#&&&&&&&&&&&%%#             
          ..#%&&&@@&&&&&&&&&%%%,....***%@@@.&&&&&&&*(&&&&&&&&%%%%#(            
            (#####%&&&&&&&&&*(%/...,**.@@@@&(&&&&%%%.&&&&&%%%######            
            ,(((((#%&&&&&&&&&&(..****.&@@@@@.&%%%%%%.&&&%%%%######             
             .((((((%%&&&&&&&&&&&%,.*@@@@@@@(/%%%%%/*&&%%%######(              
               /((((((%%&&&&&&&&&&&&&&/,#@@@@,#%%%,#&&%%%#####(                
                .((((((#%&&&&&&&&&&&&&&&&%*.##*%%%&&&&%%##..#.                 
                  /((((((#%&&&&&&&&&&&&&&&&&&&&%#/#&&&%%##,                    
                   *(((((((#%%&&&&&&&&&&&&&&&&&&&&&&&%%###(                    
                    .((((((((#%%%&&&&&&&&&&&&&&&&&&&&%%####*                   
                       /((((((((#%%%%%%&&&&&&&&&%%%%%%######*                  
                         *((((((((((##%%%%%%%%%%%%##.###**##.                  
                             *(((((((((((((/ .*(########/(.                    
                                 .,/(((((((((((((* .(*.                        
                                                                               
                                                                           ")

end
#type
#=type parameters
	Geometry::String #Cartesian, Cylindrical, Spherical
	Dimensions::Array{Bool} #x,y,z true or false
	Domains::Array{Tuple{Float64}} #Domains for each coordinate
	Dt::Float64 #timestep
end
=#
#plot themes

#functions
function readPar()
	f=open("variables.par")
	Lines=readlines(f)
	PAR::Array{Array{String}}
	#Par::parameters
	#=for S in lines
		tmp=split(S)
		PAR=hcat(PAR,tmp)
	end=#
	return Lines
end

function makeDimensions()
	Par=readPar()
	NX=filter(x->occursin(x,"NX"),Par)
	xDomain=convert(split(NX)[2],UInt16)
	NY=filter(x->occursin(x,"NY"),Par)
	yDomain=convert(split(NY)[2],UInt16)
	NZ=filter(x->occursin(x,"NZ"),Par)
	zDomain=convert(split(NZ)[2],UInt16)
	grid=[xDomain,yDomain,zDomain]
	return grid
end

#DIMENSIONS = makeDimensions()

function getsize_64(stream::IOStream)
		count =0
		while !eof(stream)
				#println(eof(stream))
				read(stream, Float64)
				count+=1
				#println(count)
		end
		close(stream)
		return count
end;

function read(filename::String)
		f=open(filename,"r")
		f_size=getsize_64(f)
		f=open(filename,"r")
		Dats=zeros(Float64,f_size)
		for i= 1:f_size
				Dats[i]=read(f,Float64)
		end
		return Dats
end;

function readParam()
end;

function test(readData)
		println(readData)
end;

function get_name(file::String)
		splt=split(file,".")
		name=splt[1]
		return name
end;

function to_mesh(file::String)
		data=read(file)
		dimensions=0
		X=false
		Y=false
		Z=false
		mesh_size=0
		if DIMENSIONS[1]>1
			dimensions+=1
			mesh_size=DIMENSIONS[1]
			X=true
		end
		if DIMENSIONS[2]>1
			if dimensions==1
				mesh_size=vcat(mesh_size,DIMENSIONS[2])
			else
				mesh_size=DIMENSIONS[2]
			end
			dimensions+=1
			Y=true
		end
		if DIMENSIONS[3]>1
			if dimensions>1
				mesh_size=vcat(mesh_size,DIMENSIONS[3])
			else
				mesh_size=DIMENSIONS[3]
			end
			dimensions+=1
			Z=true
		end


		if dimensions==1
			mesh=Array{Float64}(mesh_size[1])
				mesh=data
				return mesh
		end
		if dimensions==2
			mesh=Array{Float64}(mesh_size[1], mesh_size[2])
				for j=1:mesh_size[2]
						for i=1:mesh_size[1]
							mesh[i,j]=data[i+j*mesh_size[1]]
						end
				end
				return mesh
		end
		if dimensions==3
			mesh=Array{Float64}(mesh_size[1], mesh_size[2], mesh_size[3])
				for k=1:mesh_size[3]
						for j=1:mesh_size[2]
								for i=1:mesh_size[1]
									mesh[i,j,k]=data[i+j*mesh_size[1]+k*mesh_size[1]*mesh_size[2]]
								end
						end
				end 
				return mesh
		end
end;

function vertical_integration(strucured_data::Array{Float64,3})
		integrated_data=Array{Float64,2}
		for i=1:size(strucured_data,1)
				for j=1:size(strucured_data,2)
						tmp=0.0
						for k=1:size(strucured_data,3)
								tmp=tmp+strucured_data[i,j,k]
						end
						integrated_data[i,j]=tmp
				end
		end
end;

function plot1D(file::String)
		println("reading from "*file)
		plotname="tst"
		store=read(file)
		name=get_name(file)
		Rng=collect(1:length(store))
		return plot(Rng, store)	
end;

function get_directory()
		list=filter(x -> occursin(".dat",x),readdir())
		list=filter(x -> occursin("gas",x),list)
#		list=filter(x -> occursin(x, "00"),list)
		return list
end;

function get_outputs(fname::String)
		f=open(fname)
		all=readlines(f)
		Dats=Array{Float64}(length(all))
		Dats=map(x->parse(Float64,x), all)
		return Dats
end;

function peak_find(ID::String, n::Int)
	list=filter(x->occursin(".dat",x),readdir())
	list=filter(x -> occursin("gas"*ID*string(number)*".",x),list)
	DATA=read(list[1])
  return maximum(DATA)
end;

function peak_find(ID::String)
		list=filter(x->occursin(".dat",x),readdir())
		list=filter(x->occursin("gas"*ID,x),list)
		PEAKS=Array{Float64,2}
		for i=0:(length(list)-1)
				DATA=read("gas"*ID*string(i)*".dat")
				vcat(PEAKS,[i,maximum(DATA)])
		end
		return PEAKS
end;

#main

function Plt(ID::String, number::Int)
	files=get_directory()
	list=filter(x -> occursin("gas"*ID*string(number)*".",x),files)
	println(list)
	#list=filter(x -> occursin(x, ID),list)
	#for i=1:length(list)
	label=L"$V_z$"
	if ID=="dens"
		label=L"$\rho$"
	end
	if ID=="energy"
		label=L"$E$"
	end
	xlab=L"$Cell Number$"
	plt=plot1D(list[1])
	xlabel!(xlab)
	ylabel!(label)
	return plt
end;

function GenericPlot(ID::String, number::Int)
	files=get_directory()
	list=filter(x -> occursin("gas"*ID*string(number)*".",x),files)
	println(list)
	mesh=to_mesh(list)
	plt=plot(mesh,seriestype = :surface)
	return plt
end


function ConcPlt(ID::String, inizio::Int, fine::Int, intervallo::Int)
	I=inizio
	files=get_directory()
	list=filter(x -> occursin("gas"*ID*string(I)*".",x),files)
	println(list)
	#list=filter(x -> occursin(x, ID),list)
	#for i=1:length(list)
	label=L"$V_z$"
	if ID=="dens"
		label=L"$\rho$"
	end
	if ID=="energy"
		label=L"$E$"
	end
	xlab=L"$Cell Number$"
	plt=plot1D(list[1])
	xlabel!(xlab)
	ylabel!(label)
	I=I+intervallo

	while(I<fine)
		files=get_directory()
		list=filter(x -> occursin("gas"*ID*string(I)*".",x),files)
		println(list)
		#list=filter(x -> occursin(x, ID),list)
		#for i=1:length(list)
		label=L"$V_z$"
		if ID=="dens"
			label=L"$\rho$"
		end
		if ID=="energy"
			label=L"$E$"
		end
		xlab=L"$Cell Number$"
		println("reading from "*list[1])
		store=read(list[1])
		name=get_name(list[1])
		Rng=collect(1:length(store))
		plot!(Rng, store)
		I=I+intervallo
	end
	return plt
	#end
end;

function Gif(ID::String)
		names=get_directory()
		names=filter(x -> occursin(ID,x), names)
		anim = @animate for i=1:(length(names)-1)
    		plot1D("gas"*ID*string(i)*".dat")
		end
		gif(anim, "ID.gif", fps = 30)
end;

function Plot_Array(arr::Array{Float64,2})
		plt=plot(arr[1, ],arr[2, ])
		gui(plt)
end;

function Plot_Array(arr::Array{Float64,1})
		plt=plot(0:(length(arr)-1),arr)
		gui(plt)
end;

function latexPlot(ID::String, number::Int)
	pgfplots()
	files=get_directory()
	list=filter(x -> occursin("gas"*ID*string(number)*".",x),files)
	println(list)
	#list=filter(x -> occursin(x, ID),list)
	label=L"$V_z$"
	if ID=="dens"
		label=L"$\rho$"
	end
	if ID=="energy"
		label=L"$E$"
	end
	for i=1:length(list)
			plt=plot1D(list[i])
			xlabel!(list[i])
			ylabel!("Y")
			gui(plt)
	end
end;

function diffusion_calc(ID::String, position::Int)
		list=filter(x->occursin(".dat",x),readdir())
		list=filter(x->occursin("gas"*ID,x),list)
		#println(list)
		DATA=read("gas"*ID*string(0)*".dat")
		Point=DATA[position]
		#println(length(list))
		for i=1:length(list)-1
			DATA=read("gas"*ID*string(i)*".dat")
			Point=vcat(Point,DATA[position])
		end
	return Point
end;

function integrate_simpson(f::Array{Float64,1},h::Float64)
    sum_odd=0.0
    sum_even=0.0
    for i=2:convert(Int64,floor((length(f)-1)/2))
        sum_even+=f[(2*i)-1]
        sum_odd+=f[2*i]
    end
    integral=0.3333333333*h*(f[1]+4.0*sum_odd+2.0*(sum_even)+f[end])
    return integral
end

function Simpson(ID::String, time::Int, h::Float64);
	files=get_directory();
	list=filter(x -> occursin("gas"*ID*string(time)*".",x),files);
	println("reading from "*list[1]);
	DATA=read(list[1]);
	integral=integrate_simpson(DATA,h)
	return integral;
end;

ρd(ρ,P,cs2)=(ρ - P/cs2)

function MdArray(ρ,P,cs2)
	ρD=deepcopy(ρ)
	for i=1:length(ρ)
		ρD[i]=ρd(ρ[i],P[i],cs2)
	end
	return ρD
end

function dustMass(time::Int, cs2::Float64, h::Float64)
	P=read("gasenergy"*string(time)*".dat");
	ρ=read("gasdens"*string(time)*".dat");
	md=MdArray(ρ,P,cs2)
	integral=integrate_simpson(md,h)
	return integral
end

function dust_mass_t(beg::Int, en::Int, cs2::Float64, h::Float64)
	Masses=dustMass(beg,cs2,h)
	for i=beg+1:en
		Masses=vcat(Masses,dustMass(i,cs2,h))
	end
	return Masses
end




println("Loaded!")
