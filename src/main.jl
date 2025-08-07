function welcome_page()
    lbl = label(
        "Hello world, what is your name?";
        margin = (1, 1, 1, 1),
        padding = (1, 1, 1, 1),
        border = rounded_border(),
        justify = J_Right,
        fg = TrueColor(52, 52, 152)
    )

    return Page(lbl)
end
function (@main)(::Vector{String})::Int
    lbl = scr = screen(15, 10)
    draw!(scr, lbl)
    display(scr; border = true)
    return 0
end
