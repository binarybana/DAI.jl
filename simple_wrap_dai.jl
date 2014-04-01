using Clang

context = wrap_c.init(output_file="dai_wrap.jl",
    common_file="dai_common.jl",
    header_library=x->"\"src2/libdaiwrap.so\"",
    clang_includes=["../libdai/include"]
    )

headers = ["src2/dai.h"]
wrap_c.wrap_c_headers(context, headers)

# build shared library
cd("src2") do 
    run(`clang++ -shared -fPIC -o libdaiwrap.so -ldai -lgmp -lgmpxx -L../../libdai/lib -I../../libdai/include dai.cpp`)
end

