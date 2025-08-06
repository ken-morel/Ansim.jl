function (@main)(::Vector{String})::Int
    scr = screen(50, 30) |> line!(
        (1, 1), (30, 50), Ch('|')
    ) |> text!(
        (15, 10), "Hello world, what is your name pls?"^3, Ch()
    )

    display(scr; border = true)
    return 0
end
