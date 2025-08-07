function (@main)(::Vector{String})::Int
    scr = screen(20, 10) |> hline(3, 3, 20)
    lbl = label(
        "Hello world, what is your name?";
        margin = (1, 1, 1, 1),
        padding = (1, 1, 1, 1),
        border = simple_border(),
    )
    draw!(scr, lbl)
    display(scr; border = true)
    return 0
end
