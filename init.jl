ENV["JULIA_PKG_SERVER"] = "https://mirrors.ustc.edu.cn/julia"
using Pkg
Pkg.activate(".")
# tmppath="./AES"
# if isdir(tmppath)
#     Pkg.develop(path=tmppath)
# else
#     Pkg.add("AES")
# end
# Pkg.add("JSON3")

Pkg.develop(path="./NcmDump")