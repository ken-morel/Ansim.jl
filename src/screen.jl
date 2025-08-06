const SPos = Tuple{<:Integer, <:Integer}

struct Screen
    data::Matrix{Ch}
    width::UInt
    height::UInt
    Screen(w::Integer, h::Integer) = new(Matrix{Ch}(undef, h, w), w, h)
end

Base.getindex(s::Screen, y::Integer, x::Integer) = s.data[y, x]
Base.setindex!(s::Screen, c::Ch, y::Integer, x::Integer) = s.data[y, x] = c

clear!(scr::Screen, ch::Ch) = scr.data .= ch

function Base.display(scr::Screen; border::Bool = false)
    border && print('┌')
    border && for _ in 1:scr.width
        print('y')
    end
    border && println('┐')
    for y in 1:scr.height, x in 1:scr.width
        x == 1 && border && print('│')
        display(scr[y, x])
        x === scr.width && print(border ? "│\n" : "\n")
    end
    border && print('└')
    border && for _ in 1:scr.width
        print('─')
    end
    border && print('┘')
    return
end

function screen(w::Integer, h::Integer, ch::Ch = Ch())
    scr = Screen(w, h)
    clear!(scr, ch)
    return scr
end

# screen primitives

function linev!(s::Screen, from::SPos, to::SPos, ch::Ch)
    Yo, Xo = from
    Ye, Xe = to
    σy, σx = Ye - Yo, Xe - Xo
    for y in Yo:sign(σy):Ye
        x = Xo + (y - Yo)σx ÷ σy
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
    for x in Xo:sign(σx):Xe
        y = Yo + (x - Xo)σy ÷ σx
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

function text!(scr::Screen, pos::SPos, txt::String, style::Ch)
    y, x = pos
    striped = txt[begin:min(scr.width - x + 1, length(txt))]
    for (idx, ch) in enumerate(collect(striped))
        scr[y, x + idx - 1] = Ch(ch, style.fg, style.bg)
    end
    return scr
end
text!(p::SPos, t::String, c::Ch) = (s::Screen) -> text!(s, p, t, c)
