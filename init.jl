ENV["JULIA_PKG_SERVER"] = "https://mirrors.ustc.edu.cn/julia"
using Pkg
Pkg.activate(".")
<<<<<<< HEAD
# tmppath="./AES"
# if isdir(tmppath)
#     Pkg.develop(path=tmppath)
# else
#     Pkg.add("AES")
# end
# Pkg.add("JSON3")

Pkg.develop(path="./NcmDump")
=======
tmppath="./AES"
if isdir(tmppath)
    Pkg.develop(path=tmppath)
else
    Pkg.add("AES")
end
Pkg.add("JSON3")
>>>>>>> 4aea53143ae4967e1094421488341e17258d6035
