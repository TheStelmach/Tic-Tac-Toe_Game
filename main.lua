---@diagnostic disable: lowercase-global


love = require("love")
Figure = require("figure")
socket = require "socket"

function love.load()
    mouseX = 0
    mouseY = 0
    
    windowHeight = love.graphics.getHeight( )
    windowWidth = love.graphics.getWidth( ) 

    crossImage = love.graphics.newImage("sprites/cross.png")
    noughtImage = love.graphics.newImage("sprites/nought.png")
    beepSound = love.audio.newSource("sounds/beepSound.mp3", "static")
    gameStartSound = love.audio.newSource("sounds/gameStarted.mp3", "static")
    moveMadeSound = love.audio.newSource("sounds/moveMade.mp3", "static")
    gameEndSound = love.audio.newSource("sounds/gameEnded.mp3", "static")
    welcomeSound = love.audio.newSource("sounds/welcomeSound.mp3", "static")
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

    love.audio.play(welcomeSound)
    screenUpdated = false
end

function love.update()
    windowHeight = love.graphics.getHeight( )
    windowWidth = love.graphics.getWidth( )
        
    if gameStarted == false and gameOver == false and screenUpdated == true then
        print("Game menu - Click to start the game")

            if love.mouse.isDown(1) then
                gameStarted = true
                -- love.audio.play(gameStartSound)
                love.audio.play(beepSound)
                print("Game Started!")
                sleep(0.5)  -- Simple debounce to prevent multiple clicks
            end
    elseif gameStarted == true and gameOver == false and screenUpdated == true then
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
            print("Game Over! Winner: " .. winner)
            gameOver = true
            sleep(0.5)
            love.audio.play(gameEndSound)
        end
    elseif gameStarted == true and gameOver == true and screenUpdated == true then

    else
        
    end
end

function love.draw()

    if gameStarted == false and gameOver == false then
        
    elseif gameStarted == true and gameOver == false then
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
                love.graphics.draw(crossImage, (figure[i].col - 1) * cellWidth + cellWidth * 0.15, 
                                            (figure[i].row - 1) * cellHeight + cellHeight * 0.05)
            elseif figure[i].player == "O" then
                cell[cellNumber] = "0"
                love.graphics.setColor( r_circle, g_circle, b_circle, a_circle )
                love.graphics.draw(noughtImage, (figure[i].col - 1) * cellWidth + cellWidth * 0.15, 
                                            (figure[i].row - 1) * cellHeight + cellHeight * 0.05)
            end
        end
    end

    elseif gameStarted == true and gameOver == true then
        

    else
        
    end
    
    screenUpdated = true
end

function makeBoard()
    
    if gameStarted == false and gameOver == false then


    elseif gameStarted == true and gameOver == false then
        col = math.floor(mouseX / cellWidth) + 1
        row = math.floor(mouseY / cellHeight) + 1

        if cell[(row - 1) * 3 + col] ~= "empty" then
            print("Cell already occupied! Choose another cell.")
            love.audio.play(beepSound)

            return
        else
            screenUpdated = false
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
            love.audio.play(moveMadeSound)
            print("Cell clicked: Row " .. row .. ", Column " .. col)  
        end
    elseif gameStarted == true and gameOver == true then

    else

    end
end

function love.mousepressed( x, y, button, istouch, presses )
    if button == 1 then
        mouseX = x
        mouseY = y  
        
        makeBoard()
    end
end

function sleep(sec)
    socket.select(nil, nil, sec)
end


As soon as I added sprites, the bug appeared where the first figures would disappear but I still cannot click on their cells