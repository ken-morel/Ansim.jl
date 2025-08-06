abstract type ShapePrimitive end
draw!(scr::Screen, s::ShapePrimitive) = drawon(s, scr)
Base. |>(scr::Screen, sh::ShapePrimitive) = drawon(sh, scr)


mutable struct VLine <: ShapePrimitive
    pos::SPos
    height::UInt
    ch::Ch
end
vline(y::Integer, x::Integer, h::Integer, c::Ch = Ch('│')) = VLine((y, x), h, c)
drawon(ln::VLine, scr::Screen) = linev!(scr, ln.pos, (ln.pos[1] + ln.height, ln.pos[2]), ln.ch)


mutable struct HLine <: ShapePrimitive
    pos::SPos
    width::UInt
    ch::Ch
end
hline(y::Integer, x::Integer, w::Integer, c::Ch = Ch('─')) = HLine((y, x), w, c)
drawon(ln::HLine, scr::Screen) = lineh!(scr, ln.pos, (ln.pos[1], ln.pos[2] + ln.width), ln.ch)

mutable struct Box <: ShapePrimitive
    pos::SPos
    size::SPos
end
