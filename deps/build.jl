using BinDeps

@BinDeps.setup

libdai = library_dependency("libdai")

#provides(Sources,URI("http://staff.science.uva.nl/~jmooij1/libDAI/libDAI-0.3.1.tar.gz"), libdai)

@BinDeps.install