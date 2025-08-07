module Ansi

using ..Ansim: TColor, TrueColor, NoColor, Color16, Color

import REPL

export get_terminal_size, fg_code, bg_code, Style

# --- Terminal Size ---

"""
    get_terminal_size() -> (rows::Int, cols::Int)

Gets the terminal size using ANSI escape codes.
"""
function get_terminal_size()
    term = REPL.Terminals.TTYTerminal("", stdin, stdout, stderr)
    return try
        REPL.Terminals.raw!(term, true)
        print(stdout, "\e[18t")
        flush(stdout)
        response = ""
        while true
            char = read(stdin, Char)
            response *= string(char)
            if char == 't'
                break
            end
        end
        m = match(r"^\e\[8;(\d+);(\d+)t$", response)
        if m !== nothing
            rows = parse(Int, m.captures[1])
            cols = parse(Int, m.captures[2])
            (rows, cols)
        else
            (-1, -1) # Indicate failure
        end
    finally
        REPL.Terminals.raw!(term, false)
    end
end

# --- Color Handling ---

const CSI = "\e["

const DIM = "$(CSI)2m"
const NORMAL = "$(CSI)22m"
const BRIGHT = "$(CSI)1m"
const RESET_ALL = "$(CSI)0m"

fg_code(c::TrueColor) = "$(CSI)38;2;$(c.r);$(c.g);$(c.b)m"
bg_code(c::TrueColor) = "$(CSI)48;2;$(c.r);$(c.g);$(c.b)m"

# ANSI 16-color palette
# 0-7: black, red, green, yellow, blue, magenta, cyan, white
# 8-15: bright black, bright red, ...
fg_code(c::Color16) = "$(CSI)$(c.code < 8 ? 30 + c.code : 82 + c.code)m"
bg_code(c::Color16) = "$(CSI)$(c.code < 8 ? 40 + c.code : 92 + c.code)m"

fg_code(c::NoColor) = "$(CSI)39m" # Reset foreground
bg_code(c::NoColor) = "$(CSI)49m" # Reset background

fg_code(::Nothing) = ""
bg_code(::Nothing) = ""

end # module Ansi

