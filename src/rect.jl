const SPos = Tuple{<:Integer, <:Integer}


struct Rect
    pos::SPos
    size::SPos
end

Base. ∈(p::SPos, r::Rect) = r.pos[1] <= p[1] < r.pos[1] + r.size[1] && r.pos[2] <= p[2] < r.pos[2] + r.size[2]


const EdgeConstraints = NTuple{4, Int}

removepadding(r::Rect, p::EdgeConstraints) = Rect(
    (r.pos[1] + p[1], r.pos[2] + p[4]),
    (r.size[1] - p[1] + p[3], r.size[2] - p[2] - p[4]),
)
