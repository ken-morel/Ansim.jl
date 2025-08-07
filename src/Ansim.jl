module Ansim

cpad(t::String, l::Integer, c::Char = ' ') = lpad(t * c^((l - length(t)) ÷ 2), l, c)

include("BoxChars.jl")

include("rect.jl")
include("term.jl")
include("screen.jl")

include("primitive.jl")


include("widget/widget.jl")


include("main.jl")

end # module Ansim
