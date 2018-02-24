include("Mew.jl")
include("J_FAC.jl")

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


