function (@main)(::Vector{String})::Int
    scr = screen(50, 30)
    line!(scr, (1, 1), (30, 50), Ch('|'))
    display(scr; border = true)
    return 0
end
