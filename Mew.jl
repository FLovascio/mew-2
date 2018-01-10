#includes
using Base.read
using Base.eof
import Base.read
import Base.eof
using Gadfly
import Gadfly
#splash screen
println("
                              ##Welcome to MEW-2##                                                                  
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
dark_panel = Theme(
		panel_fill="grey",
		default_color="green",
		major_label_font_size=16pt,
		minor_label_font_size=14pt,
		major_label_color="black"
)

light_panel = Theme(
		panel_fill="white",
		default_color="green",
		major_label_font_size=16pt,
		minor_label_font_size=14pt,
		major_label_color="black"
)

#functions
function getsize_64(stream::IOStream)
		count =0
		while !eof(stream)
				read(stream, Float64)
				count+=1
		end
		close(stream)
		return count
end

function read(filename::String)
		f=open(filename,"r")
		f_size=getsize_64(f)
		f=open(filename,"r")
		Dats=Array{Float64}(f_size)
		for i= 1:f_size
				Dats[i]=read(f,Float64)
		end
		return Dats
end

function test(readData)
		println(readData)
end

function get_name(file::String)
		splt=split(file,".")
		name=splt[1]
		return name
end

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
end

function vertical_integration(strucured_data::Array{Float64,3})
		integrated_data=Array{Float64,2}
end 

function plot3D_Cartesian(file::String)
		println("reading from "*file)
		store=read(file)
		name=get_name(file)
		plt=plot(x=(1:length(store)), y=store, Guide.xlabel(), Guide.ylabel(),Geom.line)	
		draw(SVG(plotname*".svg", 16inch,		 9inch), plt)
end

function plot3D_Cylindrical(file::String)
		println("reading from "*file)
		store=read(file)
		name=get_name(file)
		plt=plot(x=(1:length(store)), y=store, Guide.xlabel(), Guide.ylabel(),Geom.line)	
		draw(SVG(plotname*".svg", 16inch,		 9inch), plt)
end

function plot3D_Spherical(file::String)
		println("reading from "*file)
		store=read(file)
		name=get_name(file)
		plt=plot(x=(1:length(store)), y=store, Guide.xlabel(), Guide.ylabel(),Geom.line)	
		draw(SVG(plotname*".svg", 16inch,		 9inch), plt)
end

function plot2D_Polar(file::String)
		println("reading from "*file)
		store=read(file)
		name=get_name(file)
		plt=plot(x=(1:length(store)), y=store, Guide.xlabel(), Guide.ylabel(),Geom.line)	
		draw(SVG(plotname*".svg", 16inch,		 9inch), plt)
end

function plot2D_Cartesian(file::String)
		println("reading from "*file)
		store=read(file)
		name=get_name(file)
		plt=plot(x=(1:length(store)), y=store, Guide.xlabel(), Guide.ylabel(),Geom.line)	
		draw(SVG(plotname*".svg", 16inch,		 9inch), plt)
end

function plot1D(file::String)
		println("reading from "*file)
		plotname="tst"
		store=read(file)
		name=get_name(file)
		plt=plot(x=(1:length(store)), y=store, Guide.xlabel("x"), Guide.ylabel("y"),Geom.line)	
		draw(SVG(plotname*".svg", 16inch,		 9inch), plt)
end

function get_directory()
		list=filter(x -> contains(x, ".dat"),readdir())
		return list
end

function get_outputs(fname::String)
		f=open(fname)
		all=readlines(f)
		Dats=Array{Float64}(length(all))
		Dats=map(x->parse(Float64,x), all)
		return Dats
end

#main
function main()
		files=get_directory()
		for i=1:length(files)
			plot1D(files[i])
		end
end

a=main()

