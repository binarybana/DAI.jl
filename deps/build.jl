daipath = expanduser("../../misc/samcnet/deps/libdai")
if !isfile("libdaiwrap.so") || stat("libdaiwrap.so").mtime < stat("dai.cpp").mtime 
	run(`g++ dai.cpp -I$daipath/include -L$daipath/lib -ldai -lgmpxx -lm -shared -fPIC -Wl,-rpath,$(pwd()) -o libdaiwrap.so`)
end
!isfile("libdai.so") && run(`ln -s $daipath/lib/libdai.so .`)
#push!(DL_LOAD_PATH, pwd())

#using BinDeps

#@BinDeps.setup

##libdai_base = library_dependency("libdai_base",aliases=["libdai"])
#daipath = expanduser("~/GSP/research/samc/samcnet/deps/libdai")
##provides(Binaries,joinpath(daipath,"lib"),libdai_base)

#libdai = library_dependency("libdaiwrap")

#prefix=joinpath(BinDeps.depsdir(libdai),"usr")
#provides(BuildProcess,
	#(@build_steps begin
		#FileRule(joinpath(prefix,"lib","libdaiwrap.so"),@build_steps begin
		#`g++ dai.cpp -I$daipath/include -L$daipath/lib -ldai -lgmpxx -lm -shared -fPIC -o libdaiwrap.so`
		#`mkdir -p $prefix/lib`
		#`mv libdaiwrap.so $prefix/lib`
		#`ln -s $daipath/lib/libdai.so $prefix/lib/`
		#end)
	#end),libdai)

##provides(Sources,URI("http://staff.science.uva.nl/~jmooij1/libDAI/libDAI-0.3.1.tar.gz"), libdai)
## will need to modify the libdai config file to enable JunctionTree algorithm

#@BinDeps.install
