using Pkg
Pkg.activate(".")
using NcmDump
for i in ARGS
    println(i)
    if isdirpath(i)
        files=first(walkdir(i))[3]
        files=i.*files
        Threads.@threads :dynamic for z in files
        println(z)
            ncmdecode(z)
        end
    else
        ncmdecode(i)
    end
end