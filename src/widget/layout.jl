abstract type Layout  end

struct Single <: Layout
    child::Widget
end

function draw!(scr::Screen, lay::Layout, rect::Union{Rect, Nothing} = nothing)
    return draw!(scr, lay.child, rect)
end

const EdgeConstraints = NTuple{4, Int}

function drawoutline!(scr::Screen, wid::Widget, rect::Union{Rect, Nothing})
    if isnothing(rect)
        rect = getrect(scr)
    end
    rect = removepadding(rect, wid.margin)
    if !isnothing(wid.border)
        rect = drawborder!(scr, wid.border, rect)
    end
    return removepadding(rect, wid.padding)
end
