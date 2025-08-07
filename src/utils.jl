"""
    cpad(t::String, l::Integer, c::Char = ' ')

Center-pads a string `t` to a total length of `l` using character `c`.
"""
cpad(t::String, l::Integer, c::Char = ' ') = lpad(t * c^((l - length(t)) ÷ 2), l, c)
