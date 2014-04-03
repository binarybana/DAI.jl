using Clang

DAILOC="/home/bana/GSP/research/samc/samcnet/deps/libdai"

context = wrap_c.init(output_file="dai_wrap.jl",
    common_file="dai_common.jl",
    header_library=x->"\"src/libdaiwrap.so\"",
    clang_includes=["$DAILOC/include"]
    )

headers = ["src/dai.h"]
wrap_c.wrap_c_headers(context, headers)

# build shared library
cd("src") do 
    run(`clang++ -shared -fPIC -o libdaiwrap.so -ldai -lgmp -lgmpxx -L$DAILOC/lib -I$DAILOC/include dai.cpp`)
end

