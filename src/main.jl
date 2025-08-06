function (@main)(::Vector{String})::Int
    scr = screen(50, 30) |> hline(3, 3, 20)
    display(scr; border = true)
    return 0
end
