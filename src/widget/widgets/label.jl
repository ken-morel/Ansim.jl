mutable struct Label <: Widget
    text::String
    fg::Color
    bg::Color
    border::Border
    padding::EdgeConstraints
    margin::EdgeConstraints
end

label(t::String) = Label(t, NoColor(true), nothing)

function draw!(scr::Screen, lbl::Label, rect::Union{Rect, Nothing} = nothing)
    rect = drawoutline!(scr, lbl, rect)
    lines = wrap(lbl.text, rect.size[2])
    lines = lines[1:min(length(lines), rect.size[1])]
    for (idx, ln) in enumerate(lines)
        text!(scr, (idx + rect.pos[1] - 1, rect.pos[2]), ln, lbl.fg, lbl.bg)
    end
    return scr
end

function wrap(text::String, max_len::Integer)
    words = split(text)
    lines = String[]
    current_line = ""

    for word in words
        if length(word) > max_len
            if !isempty(current_line)
                push!(lines, current_line)
            end
            push!(lines, word)
            current_line = ""
            continue
        end
        if isempty(current_line)
            current_line = word
        elseif length(current_line) + 1 + length(word) <= max_len
            current_line *= " " * word
        else
            push!(lines, current_line)
            current_line = word
        end
    end

    if !isempty(current_line)
        push!(lines, current_line)
    end

    return lines
end
