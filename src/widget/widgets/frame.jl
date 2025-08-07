mutable struct Frame <: Widget
    content::Union{Layout, Nothing}
    border::Union{Nothing, Border}
end

function draw!(scr::Screen, wf::Frame, rect::Union{Rect, Nothing} = nothing)
    return draw!(scr, wf.content, rect)
end

frame() = Frame(nothing, nothing)
frame(l::Layout) = Frame(l, nothing)
frame(c::Widget) = Frame(Single(c), nothing)
