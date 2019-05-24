module fargoRead

export makeDimensions, getsize_64, get_name, fargo_read, makeMesh

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

function makeMesh()
	fx=open("domain_x.dat")
	xmesh=map(x->parse(Float64,x),readlines(fx))
	fy=open("domain_y.dat")
	ymesh=map(x->parse(Float64,x),readlines(fy))
	fz=open("domain_z.dat")
	zmesh=map(x->parse(Float64,x),readlines(fz))
	return Dict("x"=>xmesh,"y"=>ymesh,"z"=>zmesh)
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
