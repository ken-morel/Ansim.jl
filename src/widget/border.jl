struct Border
    fg::Color
    bg::Color
    char::Union{Ch, NTuple{6, Char}}
end

simple_border(col::Color = NoColor(true)) = Border(
    col,
    nothing,
    (
        BoxChars.TL, BoxChars.TR,
        BoxChars.H, BoxChars.V,
        BoxChars.BL, BoxChars.BR,
    ),
)

function drawborder(scr::Screen, border::Border, rect::Rect)
    chars::String = border.char isa Char ? border.char^6 : join(border.char)
    by, bx = rect.pos
    ey, ex = rect.pos .+ rect.size
    xr, yr = range(bx + 1, ex - 1), range(by + 1, ey - 1)
    scr.data[by, bx] = chars[1] #  + top left
    scr.data[by, xr] .= chars[3] # - top
    scr.data[by, ex] = chars[2] #  + top right
    scr.data[yr, ex] .= chars[4] # - right
    scr.data[ey, ex] = chars[6] #  + bottom right
    scr.data[ey, xr] .= chars[3] # -  bottom
    scr.data[ey, bx] = chars[5] #  + bottom left
    scr.data[yr, bx] .= chars[4] # - left
    return Rect(rect.pos .+ 1, rect.size .- 2)
end
