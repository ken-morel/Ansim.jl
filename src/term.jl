abstract type TColor end

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
    fg::TColor
    bg::TColor
    Ch(ch::Char, fg::TColor, bg::TColor) = new(ch, fg, bg)
    Ch(ch::Char) = new(ch, 0x0f, 0x00)
    Ch() = new(' ', 0x0f, 0x00)
end

Base.display(ch::Ch) = print(ch.ch)

# diy, upon tryal&error, found how to make Matrix{Ch} work

Base.length(::Ch) = 1
Base.iterate(c::Ch) = (c, nothing)
Base.iterate(::Ch, ::Nothing) = nothing
