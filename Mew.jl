#includes
using Base.read
using Base.eof
import Base.read
import Base.eof
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

function plot(file::String)
		println("reading from "*file)
		store=read(file)
		name=get_name(file)
		plt=plot(x=(1:length(store)), y=store, Guide.xlabel(), Guide.ylabel(),Geom.line)	
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
			plot(files[i])
		end
end



