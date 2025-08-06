abstract type TColor end

const Color = Union{TColor, Nothing}

struct TrueColor <: TColor
    r::UInt8
    g::UInt8
    b::UInt8
end
struct NoColor <: TColor
    white::Bool
end
struct Color16 <: TColor
    code::UInt8
end

Base.convert(::Type{TColor}, u::UInt8) = Color16(u)


struct Ch
    ch::Char
    fg::Color
    bg::Color
    Ch(ch::Char, fg::Color, bg::Color) = new(ch, fg, bg)
    Ch(ch::Char) = new(ch, nothing, nothing)
    Ch() = new(' ', nothing, nothing)
end

Base.display(ch::Ch) = print(ch.ch)

# diy, upon tryal&error, found how to make Matrix{Ch} work

Base.length(::Ch) = 1
Base.iterate(c::Ch) = (c, nothing)
Base.iterate(::Ch, ::Nothing) = nothing
