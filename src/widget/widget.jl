abstract type Widget end

@enum Justify J_Left J_Right J_Center


include("border.jl")
include("layout.jl")


include("widgets/frame.jl")
include("widgets/label.jl")
