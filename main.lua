---@diagnostic disable: lowercase-global


Love = require("love")
Figure = require("figure")
Socket = require "socket"

function Love.load()
    mouseX = 0
    mouseY = 0

    
    windowHeight = Love.graphics.getHeight( )
    windowWidth = Love.graphics.getWidth( ) 
    crossTable = {"cross1", "cross2", "cross3"}
    noughtTable = {"nought1", "nought2", "nought3"}

    crossImage = function()
        return Love.graphics.newImage("sprites/crosses/" .. crossTable[math.random(#crossTable)] .. ".png")
    end
    noughtImage = function()
        return Love.graphics.newImage("sprites/noughts/" .. noughtTable[math.random(#noughtTable)] .. ".png")
    end
    scalingFactor = 1.2 -- figure image scaling factor
    imageScale = (scalingFactor * 512)  -- 512 is the original image size

    strokes = {Love.graphics.newImage("sprites/stroke0.png"),
               Love.graphics.newImage("sprites/stroke1.png"),
               Love.graphics.newImage("sprites/stroke2.png"),
               Love.graphics.newImage("sprites/stroke3.png"),
               Love.graphics.newImage("sprites/stroke4.png"),
               Love.graphics.newImage("sprites/stroke5.png"),
               Love.graphics.newImage("sprites/stroke6.png"),} 

    beepSound = Love.audio.newSource("sounds/beepSound.mp3", "static")
    gameStartSound = Love.audio.newSource("sounds/gameStarted.mp3", "static")
    moveMadeSound = Love.audio.newSource("sounds/moveMade.mp3", "static")
    gameEndSound = Love.audio.newSource("sounds/gameEnded.mp3", "static")
    welcomeSound = Love.audio.newSource("sounds/welcomeSound.mp3", "static")

    mainFont = Love.graphics.newFont("fonts/atop-font/Atop-R99O3.ttf", 50)

    r_back, g_back, b_back, a_back = 255/255, 251/255, 219/255, 0
    Love.graphics.setBackgroundColor(r_back, g_back, b_back, a_back)
    r_line, g_line, b_line, a_line = 235/255, 216/255, 61/255, 1
    r_stroke, g_stroke, b_stroke, a_stroke = 235/255, 216/255, 61/255, 0.7


    r_circle, g_circle, b_circle, a_circle = 1, 1, 1, 1
    r_cross, g_cross, b_cross, a_cross = 1, 1, 1, 1

    gameStarted = false
    gameOver = false


    cellWidth = windowWidth / 3
    cellHeight = windowHeight / 3
    winner = "unknown"
    
    figure = {}
    maxFigures = 7

    for i = 1, maxFigures do
        figure[i] = Figure:new(i, 0, 0)
    end
    currentIndex = 1
    moves = 0

    cell = {
        "empty", "empty", "empty",
        "empty", "empty", "empty",
        "empty", "empty", "empty"
    }

    Love.audio.play(welcomeSound)
    screenUpdated = false
end

function Love.update()
    windowHeight = Love.graphics.getHeight( )
    windowWidth = Love.graphics.getWidth( )
        
    if gameStarted == false and gameOver == false and screenUpdated == true then
            if Love.mouse.isDown(1) then
                gameStarted = true
                -- Love.audio.play(gameStartSound)
                Love.audio.play(beepSound)
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
            gameOver = true
            sleep(0.5)
            Love.audio.play(gameEndSound)
        end
    elseif gameStarted == true and gameOver == true and screenUpdated == true then
        if Love.mouse.isDown(1) then
                gameOver = false

                -- Reset the game board
                for i = 1, 9 do
                    cell[i] = "empty"
                end
                for i = 1, maxFigures do
                    figure[i].row = 0
                    figure[i].col = 0
                    figure[i].player = "empty"
                end
                currentIndex = 1
                moves = 0
                winner = "unknown"
                Love.audio.play(beepSound)
                sleep(0.5)  -- Simple debounce to prevent multiple clicks
            end
    else
        
    end
end

function Love.draw()

    if gameStarted == false and gameOver == false then
        Love.graphics.setColor( r_stroke, g_stroke, b_stroke, a_stroke )
        Love.graphics.draw(strokes[1], windowWidth * 0.075, windowHeight * 0.1, 0, windowWidth / (2*imageScale), windowHeight / (2*imageScale))
        Love.graphics.draw(strokes[6], windowWidth * 0.22, windowHeight * 0.6, 0, windowWidth / (3*imageScale), windowHeight / (3*imageScale))
        Love.graphics.draw(strokes[3], windowWidth * 0.22, windowHeight * 0.75, 0, windowWidth / (3*imageScale), windowHeight / (4*imageScale))
        Love.graphics.setColor( r_stroke, g_stroke, b_stroke, 0.9 )
        drawCenteredText(Love.graphics.newText(mainFont, "TIC-TAC-TOE"), windowWidth * 0.26, windowHeight * 0.25, 0, windowWidth / 600, windowHeight / 600,"white")
        drawCenteredText(Love.graphics.newText(mainFont, "Play with Computer"), windowWidth * 0.24, windowHeight * 0.64, 0, windowWidth / 1050, windowHeight / 1050,"white")
        drawCenteredText(Love.graphics.newText(mainFont, "Play with Friend"), windowWidth * 0.27, windowHeight * 0.765, 0, windowWidth / 1050, windowHeight / 1050,"white")
        ------- remove to settings page later
        drawCenteredText(Love.graphics.newText(mainFont, "made by: @TheStelmach"), windowWidth * 0.69, windowHeight * 0.97, 0, windowWidth / 2200, windowHeight / 2200,"violet")
        

    elseif gameStarted == true and gameOver == false then
        Love.graphics.setColor( r_line, g_line, b_line, a_line )
        Love.graphics.line( cellWidth, 0, cellWidth, windowHeight)
        Love.graphics.line( 2 * cellWidth, 0, 2 * cellWidth, windowHeight)
        Love.graphics.line( 0, cellHeight, windowWidth, cellHeight)
        Love.graphics.line( 0, 2 * cellHeight, windowWidth, 2 * cellHeight)

        for i = 1, maxFigures do
            if figure[i].row ~= 0 and figure[i].col ~= 0 then
                local cellNumber = (figure[i].row - 1) * 3 + figure[i].col
                if figure[i].player == "X" then
                    cell[cellNumber] = "X"
                    Love.graphics.setColor( r_cross, g_cross, b_cross, a_cross )
                    Love.graphics.draw(figure[i].sprite, (figure[i].col - 1) * cellWidth + cellWidth * (scalingFactor - 1) / 2, 
                                            (figure[i].row - 1) * cellHeight + cellWidth * (scalingFactor - 1) / 2, 0, cellWidth / imageScale, cellHeight / imageScale)
                elseif figure[i].player == "O" then
                    cell[cellNumber] = "0"
                    Love.graphics.setColor( r_circle, g_circle, b_circle, a_circle )
                    Love.graphics.draw(figure[i].sprite, (figure[i].col - 1) * cellWidth + cellWidth * (scalingFactor - 1) / 2, 
                                            (figure[i].row - 1) * cellHeight + cellWidth * (scalingFactor - 1) / 2, 0, cellWidth / imageScale, cellHeight / imageScale)
                end
            end
        end

    elseif gameStarted == true and gameOver == true then
        Love.graphics.setColor( r_stroke, g_stroke, b_stroke, a_stroke )
        Love.graphics.draw(strokes[2], windowWidth * 0.08, windowHeight * 0.25, 0, windowWidth / (2*imageScale), windowHeight / (2*imageScale))
        Love.graphics.draw(strokes[4], windowWidth * 0.22, windowHeight * 0.6, 0, windowWidth / (3*imageScale), windowHeight / (3*imageScale))
        Love.graphics.draw(strokes[5], windowWidth * 0.08, windowHeight * 0.8, 0, windowWidth / (2*imageScale), windowHeight / (3*imageScale))
        if winner == "X" then
            drawCenteredText(Love.graphics.newText(mainFont, "CROSS WINS!"), windowWidth * 0.28, windowHeight * 0.3, 0, windowWidth / 700, windowHeight / 700,"white")
        elseif winner == "O" then
            drawCenteredText(Love.graphics.newText(mainFont, "NOUGHT WINS!"), windowWidth * 0.28, windowHeight * 0.3, 0, windowWidth / 700, windowHeight / 700,"white")
        else
            drawCenteredText(Love.graphics.newText(mainFont, "IT'S A DRAW!"), windowWidth * 0.28, windowHeight * 0.3, 0, windowWidth / 700, windowHeight / 700,"white")
        end

        drawCenteredText(Love.graphics.newText(mainFont, "Back to Main Menu"), windowWidth * 0.26, windowHeight * 0.635, 0, windowWidth / 1000, windowHeight / 1000,"white")
        drawCenteredText(Love.graphics.newText(mainFont, "Click to Restart"), windowWidth * 0.28, windowHeight * 0.835, 0, windowWidth / 1000, windowHeight / 1000,"white")
        
    else

        drawCenteredText(Love.graphics.newText(mainFont, "made by: @TheStelmach"), windowWidth * 0.69, windowHeight * 0.97, 0, windowWidth / 2200, windowHeight / 2200,"black")
        
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
            Love.audio.play(beepSound)

            return
        else
            screenUpdated = false
            if currentIndex == maxFigures then
                currentIndex = 1
            else
                currentIndex = currentIndex + 1
            end
            moves = moves + 1
            oldRow = figure[currentIndex].row
            oldCol = figure[currentIndex].col
            if oldRow ~= 0 and oldCol ~= 0 then
                cell[(oldRow - 1) * 3 + oldCol] = "empty"
            end
            figure[currentIndex].row = row
            figure[currentIndex].col = col
            if moves % 2 == 1 then
                figure[currentIndex].player = "X"
                figure[currentIndex].sprite = crossImage()
            else
                figure[currentIndex].player = "O"
                figure[currentIndex].sprite = noughtImage()
            end
            Love.audio.play(moveMadeSound)
            print("Cell clicked: Row " .. row .. ", Column " .. col)  
        end
    elseif gameStarted == true and gameOver == true then

    else

    end
end

function Love.mousepressed( x, y, button, istouch, presses )
    if button == 1 then
        mouseX = x
        mouseY = y  
        
        makeBoard()
    end
end

function sleep(sec)
    Socket.select(nil, nil, sec)
end

function drawCenteredText(text, x, y, r, sx, sy, color)
    if color == "yellow" then
        Love.graphics.setColor( 235/255, 216/255, 61/255, 0.75)
    elseif color == "black" then
        Love.graphics.setColor( 20/255, 20/255, 40/255, 1)
    elseif color == "violet" then
        Love.graphics.setColor( 119/255, 118/255, 188/255, 0.75)
    elseif color == "white" then
	    Love.graphics.setColor( r_back, g_back, b_back, 0.75)
    else
        Love.graphics.setColor( 0, 0, 1, 1)
    end
    Love.graphics.draw(text, x, y, r, sx, sy)
    
end