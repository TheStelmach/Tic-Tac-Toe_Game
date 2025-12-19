---@diagnostic disable: lowercase-global


love = require("love")
Figure = require("figure")

function love.load()
    mouseX = 0
    mouseY = 0
    
    windowHeight = love.graphics.getHeight( )
    windowWidth = love.graphics.getWidth( ) 

    beepSound = love.audio.newSource("beepSound.mp3", "static")
    gameEndSound = love.audio.newSource("gameEnded.mp3", "static")
    r_back, g_back, b_back, a_back = 255/255, 251/255, 219/255, 0
    love.graphics.setBackgroundColor(r_back, g_back, b_back, a_back)
    r_line, g_line, b_line, a_line = 235/255, 216/255, 61/255, 1
    r_cross, g_cross, b_cross, a_cross = 255/255, 103/255, 77/255, 1
    r_circle, g_circle, b_circle, a_circle = 119/255, 118/255, 188/255, 1


    gameStarted = false
    gameOver = false


    cellWidth = windowWidth / 3
    cellHeight = windowHeight / 3
    winner = "unknown"
    
    figure = {}
    maxFigures = 7

    for i = 1, maxFigures do
        figure[i] = Figure:new(i, 0, 0)
        print("Created figure index: " .. figure[i].index)
    end
    currentIndex = 1
    moves = 0

    cell = {
        "empty", "empty", "empty",
        "empty", "empty", "empty",
        "empty", "empty", "empty"
    }

    -- what if starting game menu is here?

end

function love.update()
    windowHeight = love.graphics.getHeight( )
    windowWidth = love.graphics.getWidth( )
        
    if gameStarted == false and gameOver == false then
        print("Game menu - Click to start the game")
        --Game:game_menu()  -- Placeholder for game menu logic
    elseif gameStarted == true and gameOver == false then
        game_running()  -- Placeholder for game running logic

    elseif gameStarted == true and gameOver == true then
        print("Game Over! Click to go back to menu.")
        game_over()

    else
    print("Unexpected game state!")
        
    end
end

function love.draw()

    love.graphics.setColor( r_line, g_line, b_line, a_line )
    love.graphics.line( cellWidth, 0, cellWidth, windowHeight)
    love.graphics.line( 2 * cellWidth, 0, 2 * cellWidth, windowHeight)
    love.graphics.line( 0, cellHeight, windowWidth, cellHeight)
    love.graphics.line( 0, 2 * cellHeight, windowWidth, 2 * cellHeight)

    for i = 1, maxFigures do
        if figure[i].row ~= 0 and figure[i].col ~= 0 then
            local cellNumber = (figure[i].row - 1) * 3 + figure[i].col
            if figure[i].player == "X" then
                cell[cellNumber] = "X"
                love.graphics.setColor( r_cross, g_cross, b_cross, a_cross )
                love.graphics.circle( "fill",
                                    (figure[i].col - 1) * cellWidth + cellWidth / 2,
                                    (figure[i].row - 1) * cellHeight + cellHeight / 2,
                                    math.min(cellWidth, cellHeight) / 2 - 10 ) -- REPLACE WITH SPRITES
            elseif figure[i].player == "O" then
                cell[cellNumber] = "0"
                love.graphics.setColor( r_circle, g_circle, b_circle, a_circle )
                love.graphics.circle( "fill",
                                    (figure[i].col - 1) * cellWidth + cellWidth / 2,
                                    (figure[i].row - 1) * cellHeight + cellHeight / 2,
                                    math.min(cellWidth, cellHeight) / 2 - 10 ) -- REPLACE WITH SPRITES
            end
        end
    end
    
end

function makeBoard()

    col = math.floor(mouseX / cellWidth) + 1
    row = math.floor(mouseY / cellHeight) + 1

    if currentIndex == maxFigures then
        currentIndex = 1
    else
        currentIndex = currentIndex + 1
    end
    moves = moves + 1
    figure[currentIndex].row = row
    figure[currentIndex].col = col
    if moves % 2 == 1 then
        figure[currentIndex].player = "X"
    else
        figure[currentIndex].player = "O"
    end
    love.audio.play(beepSound)
    print("Cell clicked: Row " .. row .. ", Column " .. col)  
end

function game_menu()
    -- Placeholder for game menu logic
    print("Game menu - Click to start the game")
    
end

function game_running()
    -- Placeholder for game running logic
    print("Game is running...")
    
    
        cellWidth = windowWidth / 3
        cellHeight = windowHeight / 3
        if moves >= 6 then
            if (cell[1] == cell[2] and cell[2] == cell[3] and cell[1] ~= "empty") then
                winner = cell[1]
            elseif (cell[4] == cell[5] and cell[5] == cell[6] and cell[4] ~= "empty") then
                winner = cell[4]
            elseif (cell[7] == cell[8] and cell[8] == cell[9] and cell[7] ~= "empty") then
                winner = cell[7]
            elseif (cell[1] == cell[4] and cell[4] == cell[7] and cell[1] ~= "empty") then
                winner = cell[1]
            elseif (cell[2] == cell[5] and cell[5] == cell[8] and cell[2] ~= "empty") then
                winner = cell[2]
            elseif (cell[3] == cell[6] and cell[6] == cell[9] and cell[3] ~= "empty") then
                winner = cell[3]
            elseif (cell[1] == cell[5] and cell[5] == cell[9] and cell[1] ~= "empty") then
                winner = cell[1]
            elseif (cell[3] == cell[5] and cell[5] == cell[7] and cell[3] ~= "empty") then
                winner = cell[3]
            end
        end

        if winner ~= "unknown" then
            love.audio.play(gameEndSound)
            print("Game Over! Winner: " .. winner)
            gameOver = true
        end
end

function game_over()
    
end

function love.mousepressed( x, y, button, istouch, presses )
    if button == 1 then
        mouseX = x
        mouseY = y  
        
        makeBoard()
    end
end
