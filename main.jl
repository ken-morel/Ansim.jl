include("./src/Ansim.jl")

using .Ansim

function (@main)(args::Vector{String})
    return Ansim.main(args)
end
