-- Cell class to handle individual cell logic

Figure = {}
Figure.__index = Figure

function Figure:new(index, row, col, sprite)
    local figure = {}  -- CREATE TABLE HERE
    setmetatable(figure, Figure)
    figure.row = row or 0
    figure.col = col or 0
    figure.index = index or 0
    figure.player = "empty"
    figure.sprite = sprite
    return figure
end
return Figure