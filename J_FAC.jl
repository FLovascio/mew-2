#COMPILATION FLAGS
plotting_enabled=true

#PREAMBLE
import Plots
using Plots

#PLOTTING SETUP
using LaTeXStrings
pgfplots()

#Itrductory message
println("

    ___          ___         ___           ___     
   /  /\\        /  /\\       /  /\\         /  /\\    
  /  /:/       /  /:/_     /  /::\\       /  /:/    
 /__/::\\      /  /:/ /\\   /  /:/\\:\\     /  /:/     
 \\__\\/\\:\\    /  /:/ /:/  /  /:/~/::\\   /  /:/  ___ 
    \\  \\:\\  /__/:/ /:/  /__/:/ /:/\\:\\ /__/:/  /  /\\
     \\__\\:\\ \\  \\:\\/:/   \\  \\:\\/:/__\\/ \\  \\:\\ /  /:/
     /  /:/  \\  \\::/     \\  \\::/       \\  \\:\\  /:/ 
    /__/:/    \\  \\:\\      \\  \\:\\        \\  \\:\\/:/  
    \\__\\/      \\  \\:\\      \\  \\:\\        \\  \\::/   
                \\__\\/       \\__\\/         \\__\\/    
                                                     
")

#TYPES

type ScopeData
	t::Array{Float64,1}
	V::Array{Float64,1}
	#ScopeData(tt::Array{Any}, VV::Array{Any})=new(t,v)
end

type Spectrum
	A::Array{Complex128,1}
	f::Array{Float64,1}
end

#FUNCTION DEFINITIONS

#file reading block:

function read_file_to_array(name::String)
	f=open(name)
	return readlines(f)
end

function strip_header(file::Array)
	retarray = [file[i] for i = 24:length(file)]
	return retarray
end

function print_to_term(A::Array) #for debugging purposes
	println("Printing array to terminal: debugging feature\n")
	for i = 1:length(A)
		println(A[i])
#		println("\n")
	end
end

function print_to_term(A::ScopeData)
	println("Printing array to terminal: debugging feature\n")
	for i = 1:length(A.t)
		println(A.t[i],"	",A.V[i])
#		println("\n")
	end
end


function print_to_term2D(A, size::Int64)
	println("Printing a 2D array to terminal\n")
	for i = 1:size
		println(A[i][1]," ",A[i][2])
	end
end

function make_array1D(A,row)
	ret=Vector{String}
	for i= 1:size(A,1)
		append(ret,A[i,1])
end
	return ret
end

function get_float(A,q::Int)
	retvec=Float64[]
	for i =1:length(A)
		xy=[parse(Float64, ss) for ss in split(A[i], ",")]
		retvec=vcat(retvec,float(xy[q]))
	end
	return retvec
end

#End

#simple data processing

function strip_negative_time(dat::ScopeData)
	tN=Float64[]
	VN=Float64[]
	for i=1:length(dat.t)
		if dat.t[i]<0
			continue
		end
		tN=vcat(tN,dat.t[i])
		VN=vcat(VN,dat.V[i])
	end
	retdat=ScopeData(tN,VN)
end

function strip_positive_time(dat::ScopeData)
	tN=Float64[]
	VN=Float64[]
	for i=1:length(dat.t)
		if dat.t[i]<0
			tN=vcat(tN,dat.t[i])
			VN=vcat(VN,dat.V[i])
		end
	end
	retdat=ScopeData(tN,VN)
	return retdat
end

function read_to_SD(name::String)
	lines= read_file_to_array(name)
	println("read: ", name)
	dataLines= strip_header(lines)
	dataT= get_float(dataLines, 1)
	dataV= get_float(dataLines, 2)
	SD=ScopeData(dataT,dataV)
	return SD
end

#End

#Spectral Analysis

function mirror_flip(spectrum::Array{Float64})
	retspec=Float64[Int(floor(length(spectrum)/2))]
	for i= 1:Int(floor(length(spectrum)/2))
		retspec[i]=spectrum[i]+spectrum[length(spectrum)-i]
	end
end

function spectral_series(datset::Array{Float64})
	sdata=fft(datset)
	sdata=map(x->abs(x),sdata)
	return sdata
end

function offset(dat::ScopeData)
	VN=Float64[]
	for i=1:length(dat.t)
		if dat.t[i]<0
			VN=vcat(VN,dat.V[i])
		end
	end
	return mean(VN)
end

function num_integrate(dat::ScopeData)
	sum=0.0
	for i=2:length(dat.t)
		sum = sum+(((dat.V[i]+dat.V[i-1])*(dat.t[i]-dat.t[i-1]))/2)
	end
	return sum
end

function neg_to_zero(A::Complex128)
	if real(A)<=0.0
		return complex(0.0,0.0)
	end
	if real(A)>0.0
  	return A
	end
end

function neg_to_zero(A::Float64)
	if A<=0.0
		return 0.0
	end
	if A>0.0
  	return A
	end
end

function lowpass(x::Array{Complex128})
	for i= Int(floor(1*length(x)/50)):Int(floor(49*length(x)/50))
		x[i]=0
	end
	return x
end

function hipass(x::Array{Complex128})
	for i= 1:Int(floor(49*length(x)/100))
		x[i]=0
	end
	for i= Int(floor(51*length(x)/100)):length(x)
		x[i]=0
	end
	return x
end

function peakfind_real(data::Array{Complex128,1})
	location_1::Array{Number,0,0.0}
	location_2::Array{Number,0,0.0}
	for i= 1:Int(floor(length(data)/2))
		if real(data[i]) > location[2]
			location_1[1]=i
			location_1[2]=data[i]
		end
	end
	for i= Int(floor(length(data)/2)):length(data)
		if real(data[i]) > location[2]
			location_2[1]=i
			location_2[2]=data[i]
		end
	end
	location::Array{Int,location_1[1],location2[1]}
	return location
end

function peakfinder(data::Array{Float64,1})
	peak=0.0
	for i= 1:length(data)
		if data[i] > peak 
			peak=data[i]
		end
	end
	return peak
end

function strip_99()
end

function noise_cancel(noise::Array{Float64,1}, dirtySignal::Array{Float64,1})
	cleanSignal= Complex128[]
	SigPad= Float64[]
	SigPad= dirtySignal
	ftSig= fft(SigPad)
  println(summary(ftSig))
  Clean=Complex{Float64}[]
	Clean=lowpass(ftSig)
	cleanSignal=ifft(Clean)
	#cleanSignal=ifft(ftSig)
	cleanSignal=map(x->real(x), cleanSignal)
	#cleanSignal=map(x->abs(x), ftSig)
	return cleanSignal
end

function noise_cancel_lowpass(noise::Array{Float64,1}, dirtySignal::Array{Float64,1})
	cleanSignal= Complex128[]
	SigPad= Float64[]
	SigPad= dirtySignal
	ftSig= fft(SigPad)
  println(summary(ftSig))
  Clean=Complex{Float64}[]
	Clean=lowpass(ftSig)
	cleanSignal=ifft(Clean)
	#cleanSignal=ifft(ftSig)
	cleanSignal=map(x->real(x), cleanSignal)
	#cleanSignal=map(x->abs(x), ftSig)
	return cleanSignal
end

function noise_cancel_peak_find(noise::Array{Float64,1}, dirtySignal::Array{Float64,1})
	ftSig= fft(dirtySignal)
	peaks= peakfind_real(ftSig)
end

function Sigma_Noise(data::Array{Float64,1})
	mu=mean(data)
	return stdm(data,mu)
end

#End

#Data file methods

function print_data(data::ScopeData, name::String)
	datArray= [data.t, data.V]
	datArray= hcat(datArray...)
	nme=name*".dat"
	writedlm(nme, datArray)
end

#Directory logic

function search_directory(id::String)
	return filter(x -> contains(x, id),map(abspath, readdir()))
end

function get_name_from_dir(nme::String)
	list=split(nme,"/")
	return  String(list[length(list)])
end

function get_ID_from_name(nme::String)
	list=split(nme,".")
	list=map(x->String(x),list)
	return String(list[1])
end

function get_noise_files()
		Names=search_directory(".csv")
		Names=map(x->get_name_from_dir(x), Names)
		Noises=filter(x -> contains(x, "n"),Names)
		return Noises
end

function get_sig_files()
		Names=search_directory(".csv")
		Names=map(x->get_name_from_dir(x), Names)
		Sigs=filter!(x -> !(contains(x, "n")),Names)
		Sigs=filter!(x -> !(contains(x, "ANALS")),Sigs)
		return Sigs
end

#End


#Globals

Signal_Files=get_sig_files()
Noise_Files=get_noise_files()
Sigs=Signal_Files
Noises=Noise_Files

#End


#User Functions
function rescan()
		Sigs=get_sig_files()
		Noises=get_noise_files()
end

function fast_analysis(set::String)

	if set=="Noise"||set=="noise"
		NDATASTORE=["NAME" "integral" "std_dev"]	
		for i=1:length(Noises)
			SD=read_to_SD(Noises[i])
			SD.t=map(x->1000000*x,SD.t)
			SD.V=map(x->1000*x,SD.V)
			ofst=offset(SD)
			SDpos=strip_negative_time(SD)
			SDPoffset=SDpos
			SDPoffset.V=map(x->x-ofst, SDpos.V)
			SD.V=map(x->x-ofst, SD.V)
			println("integral: ",num_integrate(SDPoffset))
			integral=num_integrate(SDPoffset)
			sdev=Sigma_Noise(SD.V)
			println(sdev)
			
			plt=plot(SD.t,SD.V, xlabel=L"Time ($ \mu s$)")
			vline!([0.])
			ylabel!(L"Voltage (mV)")
			savefig(plt, get_ID_from_name(Noises[i]))
			
			#SPEC=spectral_series(SD.V)
			#plts=plot(SPEC)
			#savefig(plts, "SPEC_"*get_ID_from_name(Noises[i]))
			DATATEMP=[Noises[i] integral sdev]
			NDATASTORE=vcat(NDATASTORE,DATATEMP)
		end
		return NDATASTORE
	elseif set=="signals"||"Signals"
		DATASTORE=["NAME" "integral" "std_dev" "Peak" "sig to noise"]
		for i=1:length(Sigs)
			SD=read_to_SD(Sigs[i])
			SD.t=map(x->1000000*x,SD.t)
			SD.V=map(x->1000*x,SD.V)
			ofst=offset(SD)
			SDpos=strip_negative_time(SD)
			SDPoffset=SDpos
			SDPoffset.V=map(x->x-ofst, SDpos.V)
			SD.V=map(x->x-ofst, SD.V)
			println("integral: ",num_integrate(SDPoffset))
			integral=num_integrate(SDPoffset)
			NEG=strip_positive_time(SD)
			sdev=Sigma_Noise(NEG.V)
			Peak=peakfinder(SD.V)
			println("peak:", Peak)
			println("Sigma:",sdev)
			
			plt=plot(SD.t,SD.V, xlabel=L"Time ($\mu s$)")
			vline!([0.])
			ylabel!(L"Voltage (mV)")
			gui(plt)
			#savefig(plt, get_ID_from_name(Sigs[i]))
			
			#SPEC=spectral_series(SD.V)
			#plts=plot(SPEC)
			#savefig(plts, "SPEC_"*get_ID_from_name(Sigs[i]))
			sig_to_noise=Peak/sdev
			DATATEMP=[Sigs[i] integral sdev Peak sig_to_noise]
			DATASTORE=vcat(DATASTORE,DATATEMP)
		end
		return DATASTORE
	end
end

function Write_Analysis()
	writedlm("ANALS.csv", DATASTORE, ",")
	writedlm("NANALS.csv", NDATASTORE, ",")
end
