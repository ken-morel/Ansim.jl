struct Page
    child::Widget
end


mutable struct Application
    page::Page
    terminal::Terminal
end

function mainloop(app::Application)
    clear(app.terminal)
    display(app)
    return 0
end
function display(app::Application)
    return withterminal(app.terminal) do
        display(app.page)
    end
end
