function (@main)(::Vector{String})::Int
    scr = screen(20, 10) |> hline(3, 3, 20)
    lbl = label("Hello world, what is your name?")
    draw!(scr, lbl)
    display(scr; border = true)
    return 0
end
