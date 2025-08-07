struct Screen
    data::Matrix{Ch}
    width::UInt
    height::UInt
    Screen(w::Integer, h::Integer) = new(Matrix{Ch}(undef, h, w), w, h)
end

function resize(scr::Screen, dms::SPos)
    new = screen(dms)
    blit!(new, scr, (1, 1))
    return new
end

getrect(s::Screen) = Rect((1, 1), (s.height, s.width))


Base.getindex(s::Screen, y::Integer, x::Integer) = s.data[y, x]
Base.setindex!(s::Screen, c::Ch, y::Integer, x::Integer) = s.data[y, x] = c
Base.size(s::Screen) = (s.height, s.width)

clear!(scr::Screen, ch::Ch = Ch()) = scr.data .= ch

function Base.display(scr::Screen; border::Bool = false)
    border && print(BoxChars.TL)
    border && for _ in 1:scr.width
        print(BoxChars.H)
    end
    border && println(BoxChars.TR)
    for y in 1:scr.height, x in 1:scr.width
        x == 1 && border && print(BoxChars.V)
        display(scr[y, x])
        x === scr.width && print(border ? BoxChars.V * "\n" : "\n")
    end
    border && print(BoxChars.BL)
    border && for _ in 1:scr.width
        print(BoxChars.H)
    end
    border && print(BoxChars.BR)
    return
end

function screen(w::Integer, h::Integer, ch::Ch = Ch())
    scr = Screen(w, h)
    clear!(scr, ch)
    return scr
end
screen(p::SPos, ch::Ch = Ch()) = screen(p[2], p[1], ch)

function blit!(scr::Screen, paint::Screen, pos::SPos)
    by, bx = pos
    src_h, src_w = size(paint)
    dst_h, dst_w = size(scr)

    # Determine the overlapping region
    copy_h = min(dst_h - by + 1, src_h)
    copy_w = min(dst_w - bx + 1, src_w)

    # Ensure we don't try to copy negative dimensions
    (copy_h <= 0 || copy_w <= 0) && return scr

    src_y_range = 1:copy_h
    src_x_range = 1:copy_w
    dst_y_range = by:(by + copy_h - 1)
    dst_x_range = bx:(bx + copy_w - 1)

    scr.data[dst_y_range, dst_x_range] = paint.data[src_y_range, src_x_range]
    return scr
end


# screen primitives

function linev!(s::Screen, from::SPos, to::SPos, ch::Ch)
    Yo, Xo = from
    Ye, Xe = to
    σy, σx = Ye - Yo, Xe - Xo
    bounds = getrect(s)
    for y in Yo:sign(σy):Ye
        x = Xo + (y - Yo)σx ÷ σy
        (y, x) ∉ bounds && continue
        s[y, x] = ch
    end
    return s
end

function lineh!(s::Screen, from::SPos, to::SPos, ch::Ch)
    Yo, Xo = from
    Ye, Xe = to
    σy, σx = Ye - Yo, Xe - Xo
    if σx == 0
        s[Yo, Xo] = ch
        return s
    end
    bounds = getrect(s)
    for x in Xo:sign(σx):Xe
        y = Yo + (x - Xo)σy ÷ σx
        (y, x) ∉ bounds && continue
        s[y, x] = ch
    end
    return s
end

function line!(s::Screen, from::SPos, to::SPos, ch::Ch)
    return if <(abs.(from .- to)...) # y difference less than x difference
        linev!(s, from, to, ch)
    else
        lineh!(s, from, to, ch)
    end
end
line!(f::SPos, t::SPos, c::Ch) = (s::Screen) -> line!(s, f, t, c)

function text!(scr::Screen, pos::SPos, txt::String, fg::Color, bg::Color)
    y, x = pos
    striped = txt[begin:min(scr.width - x + 1, length(txt))]
    for (idx, ch) in enumerate(collect(striped))
        scr[y, x + idx - 1] = Ch(ch, fg, bg)
    end
    return scr
end
text!(p::SPos, t::String, f::Color, b::Color = nothing) = (s::Screen) -> text!(s, p, t, f, b)

function box!(scr::Screen, pos::SPos, size::SPos, ch::Ch)
    scr[(pos[1]):(pos[1] + size[1]), (pos[2]):(pos[2] + size[2])] .= ch
    return scr
end
box!(pos::SPos, size::SPos, ch::Ch) = (scr::Screen) -> box!(scr, pos, size, ch)
