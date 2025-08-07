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

function drawborder!(scr::Screen, border::Border, rect::Rect)
    h, w = rect.size
    (h <= 0 || w <= 0)  && Rect(rect.pos, (0, 0))
    charsstring = border.char isa Char ? repeat(string(border.char), 6) : join(border.char)
    length(charsstring) != 6 && error(
        "drawborder!: border.char must be a Char or a 6-element collection, but got $(border.char)"
    )
    chars = Ch.(collect(charsstring), (border.fg,), (border.bg,))
    by, bx = rect.pos
    ey, ex = (by, bx) .+ (h, w) .- 1
    if h > 1 && w > 1
        xr = (bx + 1):(ex - 1)
        yr = (by + 1):(ey - 1)
        println(Int.(xr), " and ", Int.(yr))
        scr.data[by, bx] = chars[1]    # top left
        scr.data[by, xr] .= chars[3]   # top
        scr.data[by, ex] = chars[2]    # top right
        scr.data[yr, ex] .= chars[4]   # right
        scr.data[ey, ex] = chars[6]    # bottom right
        scr.data[ey, xr] .= chars[3]   # bottom
        scr.data[ey, bx] = chars[5]    # bottom left
        scr.data[yr, bx] .= chars[4]   # left
    elseif h == 1 && w == 1
        scr.data[by, bx] = BoxChars.SQUARE_LOZENGE
    elseif h == 1
        scr.data[by, bx] = chars[1]
        scr.data[by, (bx + 1):(ex - 1)] .= chars[3]
        scr.data[by, ex] = chars[2]
    elseif w == 1
        scr.data[by, bx] = chars[1]
        scr.data[(by + 1):(ey - 1), bx] .= chars[4]
        scr.data[ey, bx] = chars[5]
    end
    return Rect(rect.pos .+ 1, max.(rect.size .- 2))
end
