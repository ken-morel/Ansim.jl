struct Terminal
    stdin::IO
    stdout::IO
    stderr::IO
end

getterminal() = Terminal(Base.stdin, Core.stdout, Core.stderr)

withterminal(f::Function, t::Terminal) = redirect_stdio(f; stdin = t.stdin, stdout = t.stdout)

clear(t::Terminal) = Ansim

import REPL

function size(t::Terminal)
    term = REPL.Terminals.TTYTerminal("", t.stdin, t.stdout, t.stderr)
    return try
        REPL.Terminals.raw!(term, true)
        print(t.stdout, "\e[18t")
        flush(t.stdout)
        response = ""
        while true
            char = read(t.stdin, Char)
            response *= string(char)
            if char == 't'
                break
            end
        end
        m = match(r"^\e\[8;(\d+);(\d+)t$", response)
        if m !== nothing
            rows = parse(Int, m.captures[1])
            cols = parse(Int, m.captures[2])
            return (rows, cols)
        else
            return (-1, -1) # Indicate failure
        end
    finally
        REPL.Terminals.raw!(term, false)
    end
end

# --- ANSI Constants ---

const CSI = "\e["

# Style
const STYLE_DIM = "$(CSI)2m"
const STYLE_NORMAL = "$(CSI)22m"
const STYLE_BRIGHT = "$(CSI)1m"
const STYLE_RESET_ALL = "$(CSI)0m"

# Clearing
const CLEAR_ENTIRE_SCREEN = "$(CSI)2J"
const CLEAR_FROM_CURSOR_DOWN = "$(CSI)J"
const CLEAR_FROM_CURSOR_UP = "$(CSI)1J"
const CLEAR_ENTIRE_LINE = "$(CSI)2K"
const CLEAR_FROM_CURSOR_RIGHT = "$(CSI)K"
const CLEAR_FROM_CURSOR_LEFT = "$(CSI)1K"


# --- High-level Functions ---

"""
    clear()

Clears the entire terminal screen and moves the cursor to the top-left corner.
"""
function clear(t::Terminal)
    print(t.stdout, CLEAR_ENTIRE_SCREEN, "\e[H")
    return flush(t.stdout)
end

# --- Color Handling ---

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
