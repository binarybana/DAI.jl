using Clang.cindex

DAILOC="/home/bana/GSP/research/samc/samcnet/deps/libdai/include"

function wrap_dai_file(
	fname::ASCIIString, namespace::ASCIIString, class::ASCIIString, ofname::ASCIIString, 
	funcs::Vector{Symbol}, exclude::Vector{Symbol}=Symbol[]
	)
	topcu = cindex.parse_header("$DAILOC/dai/$fname"; cplusplus = true, args = ["-I$DAILOC"])

	namespace = cindex.search(topcu, namespace)
	cls = mapreduce(x->cindex.search(x, class), vcat, namespace)

	of = open("$(ofname).cc", "w")
	ofjl = open("$(ofname).jl", "w")
	println(of, "//c++ -shared -fPIC $(ofname).cc -o $(ofname)")
	println(of, "#include <dai/$fname>")
	println(of, "extern \"C\" {")
	#println(map(cindex.spelling,children(topcu)))
	for c in cls
		length(children(c)) == 0 && continue
		println(name(c))
		#println(length(children(c)))
		#println(cindex.spelling(children(c)[1]))
		
		MethodCount = Dict{Symbol, Int}()
		for decl in children(c)
			const declname = symbol(strip(spelling(decl)))
			wrapped = Any[]
			if (declname in funcs) && ( (isa(decl, cindex.CXXMethod)) || isa(decl, cindex.Constructor))

				#check for public
				Clang.cindex.getCXXAccessSpecifier(decl)==1 || continue

			    id = (MethodCount[declname] = get(MethodCount, declname, 0) + 1)
			    if (symbol("$(declname)$(id)") in exclude)
			    	println("excluding $(name(c))::$(declname)::$(id)")
			    	continue
			    end
			    Clang.wt.wrap(of, decl, id)
			    Clang.wt.wrapjl(ofjl, decl, id)
					#Clang.wt.wrapjl(ofjl, ":libdai",decl, id)
			end 
		end
	end
	println(of, "} //extern C")
	close(of)
	close(ofjl)
end

mkpath("gen")
wrap_dai_file("var.h", "dai", "Var", "gen/var", [:states, :label]) 
