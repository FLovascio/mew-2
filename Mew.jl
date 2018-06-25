#includes
using Base.read
using Base.eof
import Base.read
import Base.eof
using Plots
using LaTeXStrings
import Plots
include("Diffusion.jl")
#gr()
plotlyjs()
#splash screen
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

#type

#plot themes

#functions
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
		Dats=Array{Float64}(f_size)
		for i= 1:f_size
				Dats[i]=read(f,Float64)
		end
		return Dats
end;

function test(readData)
		println(readData)
end;

function get_name(file::String)
		splt=split(file,".")
		name=splt[1]
		return name
end;

function to_mesh(file::String, dimensions::UInt16, mesh_size::Array{Int,1})
		data=read(file)
		if dimensions==1
			mesh=Array{Float64}(mesh_size[1])
				mesh=data
				return mesh
		end
		if dimensions==2
			mesh=Array{Float64}(mesh_size[1], mesh_size[2])
				for i=1:mesh_size[1]
						for j=1:mesh_size[2]
								mesh[i,j]=data[i*j]
						end
				end
				return mesh
		end
		if dimensions==3
			mesh=Array{Float64}(mesh_size[1], mesh_size[2], mesh_size[3])
				for i=1:mesh_size[1]
						for j=1:mesh_size[2]
								for k=1:mesh_size[3]
										mesh[i,j,k]=data[i*j*k]
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
		list=filter(x -> contains(x, ".dat"),readdir())
		list=filter(x -> contains(x, "gas"),list)
#		list=filter(x -> contains(x, "00"),list)
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
	list=filter(x->contains(x,".dat"),readdir())
	list=filter(x -> contains(x, "gas"*ID*string(number)*"."),list)
	DATA=read(list[1])
  return maximum(DATA)
end;

function peak_find(ID::String)
		list=filter(x->contains(x,".dat"),readdir())
		list=filter(x->contains(x,"gas"*ID),list)
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
	list=filter(x -> contains(x, "gas"*ID*string(number)*"."),files)
	println(list)
	#list=filter(x -> contains(x, ID),list)
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
	#end
end;

function ConcPlt(ID::String, inizio::Int, fine::Int, intervallo::Int)
	I=inizio
	files=get_directory()
	list=filter(x -> contains(x, "gas"*ID*string(I)*"."),files)
	println(list)
	#list=filter(x -> contains(x, ID),list)
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
		list=filter(x -> contains(x, "gas"*ID*string(I)*"."),files)
		println(list)
		#list=filter(x -> contains(x, ID),list)
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
		names=filter(x -> contains(x, ID), names)
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
	list=filter(x -> contains(x, "gas"*ID*string(number)*"."),files)
	println(list)
	#list=filter(x -> contains(x, ID),list)
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
		list=filter(x->contains(x,".dat"),readdir())
		list=filter(x->contains(x,"gas"*ID),list)
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

println("Loaded!")
