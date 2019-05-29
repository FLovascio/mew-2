module fargoRead

export makeDimensions, getsize_64, get_name, fargo_read, makeMesh, toMesh

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

function makeMesh(NGHY::Int64=3,NGHZ::Int64=3)
	fx=open("domain_x.dat")
	xmesh=map(x->parse(Float64,x),readlines(fx))
	fy=open("domain_y.dat")
	ymesh=map(x->parse(Float64,x),readlines(fy))
	fz=open("domain_z.dat")
	zmesh=map(x->parse(Float64,x),readlines(fz))
	return Dict("x"=>xmesh[1:end-1],"y"=>ymesh[1+NGHY:end-(NGHY+1)],"z"=>zmesh[1+NGHZ:end-(1+NGHZ)])
end

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

function fargo_read(filename::String)
	f=open(filename,"r")
	f_size=getsize_64(f)
	f=open(filename,"r")
	Dats=zeros(Float64,f_size)
	for i= 1:f_size
		Dats[i]=read(f,Float64)
	end
	return Dats
end;

function toCentered(mesh::Dict{String,Array{Float64,1}})
	if length(mesh["x"])>1
		xoffset=0.5*(mesh["x"][2]-mesh["x"][1])
	else
		xoffset=0.0
	end
	if length(mesh["x"])>1
		yoffset=0.5*(mesh["y"][2]-mesh["y"][1])
	else
		yoffset=0.
	end
	if length(mesh["x"])>1
		zoffset=0.5*(mesh["z"][2]-mesh["z"][1])
	else
		zoffset=0.
	end
	xticks=mesh["x"][1:end-1]
	yticks=mesh["y"][1:end-1]
	zticks=mesh["z"][1:end-1]
	xticks=xticks.+xoffset
	yticks=yticks.+yoffset
	zticks=zticks.+zoffset
	return Dict("x"=>xticks,"y"=>yticks,"z"=>zticks)
end

function toMesh(data::Array{Float64}, mesh::Dict{String,Array{Float64,1}}, centering::Bool)
	if centering
		newmesh=toCentered(mesh)
		xlength=length(newmesh["x"])
		ylength=length(newmesh["y"])
		zlength=length(newmesh["z"])
	else
		xlength=length(mesh["x"])
		ylength=length(mesh["y"])
		zlength=length(mesh["z"])
	end
	DataNew=zeros(Float64,xlength,ylength,zlength)
	counter=1
	for i=1:xlength
		for j=1:ylength
			for k=1:zlength
				DataNew[i,j,k]=data[counter]
				counter+=1
			end
		end
	end
	return DataNew
end

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

end
