-- game made as part of the LÖVE2d library

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

    gearIcon = Love.graphics.newImage("sprites/gear.png")

    crossImage = function()
        return Love.graphics.newImage("sprites/crosses/" .. crossTable[math.random(#crossTable)] .. ".png")
    end
    noughtImage = function()
        return Love.graphics.newImage("sprites/noughts/" .. noughtTable[math.random(#noughtTable)] .. ".png")
    end
    scalingFactor = 1.2 -- figure image scaling factor
    imageScale = (scalingFactor * 512)  -- 512 - original image size

    strokes = {Love.graphics.newImage("sprites/strokes/stroke0.png"),
               Love.graphics.newImage("sprites/strokes/stroke1.png"),
               Love.graphics.newImage("sprites/strokes/stroke2.png"),
               Love.graphics.newImage("sprites/strokes/stroke3.png"),
               Love.graphics.newImage("sprites/strokes/stroke4.png"),
               Love.graphics.newImage("sprites/strokes/stroke5.png"),
               Love.graphics.newImage("sprites/strokes/stroke6.png"),} 

    beepSound = Love.audio.newSource("sounds/beepSound.mp3", "static")
    gameStartSound = Love.audio.newSource("sounds/gameStarted.mp3", "static")
    moveMadeSound = Love.audio.newSource("sounds/moveMade.mp3", "static")
    gameEndSound = Love.audio.newSource("sounds/gameEnded.mp3", "static")
    welcomeSound = Love.audio.newSource("sounds/welcomeSound.mp3", "static")

    mainFont = Love.graphics.newFont("fonts/atop-font/Atop-R99O3.ttf", 50)

    colorPalette = "bright"
    gridSize = "3x3"
    difficulty = "normal"
    gameMode = "continuous"
    sound = "on"

    if colorPalette == "dark" then
        r_back, g_back, b_back, a_back = 20/255, 20/255, 40/255, 0
        Love.graphics.setBackgroundColor(r_back, g_back, b_back, a_back)
        r_line, g_line, b_line, a_line = 235/255, 216/255, 61/255, 1
        r_stroke, g_stroke, b_stroke, a_stroke = 235/255, 216/255, 61/255, 0.7
    else
        r_back, g_back, b_back, a_back = 255/255, 251/255, 219/255, 0
        Love.graphics.setBackgroundColor(r_back, g_back, b_back, a_back)
        r_line, g_line, b_line, a_line = 235/255, 216/255, 61/255, 1
        r_stroke, g_stroke, b_stroke, a_stroke = 235/255, 216/255, 61/255, 0.7
        r_text, g_text, b_text, a_text = 235/255, 231/255, 189/255, 0.5
    end
    


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
        
    if gameStarted == true and gameOver == false and screenUpdated == true then
        cellWidth = windowWidth / 3
        cellHeight = windowHeight / 3
        if moves >= 6 then
            if (cell[1] == cell[2] and cell[2] == cell[3] and cell[1] ~= "empty") then
                winner = cell[1]
            end
            if (cell[4] == cell[5] and cell[5] == cell[6] and cell[4] ~= "empty") then
                if winner == "unknown" then 
                    winner = cell[4]
                else
                    winner = "draw"
                end
            end
            if (cell[7] == cell[8] and cell[8] == cell[9] and cell[7] ~= "empty") then
                if winner == "unknown" then 
                    winner = cell[7]
                else
                    winner = "draw"
                end
            end
            if (cell[1] == cell[4] and cell[4] == cell[7] and cell[1] ~= "empty") then
                if winner == "unknown" then 
                    winner = cell[1]
                else
                    winner = "draw"
                end
            end
            if (cell[2] == cell[5] and cell[5] == cell[8] and cell[2] ~= "empty") then
                if winner == "unknown" then 
                    winner = cell[2]
                else
                    winner = "draw"
                end
            end
            if (cell[3] == cell[6] and cell[6] == cell[9] and cell[3] ~= "empty") then
                if winner == "unknown" then 
                    winner = cell[3]
                else
                    winner = "draw"
                end
            end
            if (cell[1] == cell[5] and cell[5] == cell[9] and cell[1] ~= "empty") then
                if winner == "unknown" then 
                    winner = cell[1]
                else
                    winner = "draw"
                end
            end
            if (cell[3] == cell[5] and cell[5] == cell[7] and cell[3] ~= "empty") then
                if winner == "unknown" then 
                    winner = cell[3]
                else
                    winner = "draw"
                end
            end
        end

        if winner ~= "unknown" then
            gameOver = true
            sleep(0.5)
            Love.audio.play(gameEndSound)
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
        
        if colorPalette == "bright" then
            Love.graphics.setColor( r_text, g_text, b_text, a_text )
            Love.graphics.draw(gearIcon, windowWidth * 0.9, windowHeight * 0.03, 0, windowWidth / (13*imageScale), windowHeight / (13*imageScale))
        else
            Love.graphics.setColor(10/255, 10/255, 40/255, 1)
            Love.graphics.draw(gearIcon, windowWidth * 0.9, windowHeight * 0.03, 0, windowWidth / (13*imageScale), windowHeight / (13*imageScale))
            Love.graphics.setColor( r_text, g_text, b_text, a_text )
        end
        drawCenteredText(Love.graphics.newText(mainFont, "TIC-TAC-TOE"), windowWidth * 0.26, windowHeight * 0.25, 0, windowWidth / 600, windowHeight / 600,"messageText")
        drawCenteredText(Love.graphics.newText(mainFont, "Play with Computer"), windowWidth * 0.24, windowHeight * 0.64, 0, windowWidth / 1050, windowHeight / 1050,"messageText")
        drawCenteredText(Love.graphics.newText(mainFont, "Play with Friend"), windowWidth * 0.27, windowHeight * 0.765, 0, windowWidth / 1050, windowHeight / 1050,"messageText")
        ------- remove to settings page later
        

    elseif gameStarted == true and gameOver == false then
        if colorPalette == "dark" then
            r_back, g_back, b_back, a_back = 20/255, 20/255, 40/255, 0
            Love.graphics.setBackgroundColor(r_back, g_back, b_back, a_back)
            r_line, g_line, b_line, a_line = 255/255, 103/255, 77/255, 1
            r_stroke, g_stroke, b_stroke, a_stroke = 235/255, 216/255, 61/255, 0.7
        else
            r_back, g_back, b_back, a_back = 255/255, 251/255, 219/255, 0
            Love.graphics.setBackgroundColor(r_back, g_back, b_back, a_back)
            r_line, g_line, b_line, a_line = 20/255, 20/255, 40/255, 1
            r_stroke, g_stroke, b_stroke, a_stroke = 20/255, 20/255, 40/255, 0.7
        end
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
                    cell[cellNumber] = "O"
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
            drawCenteredText(Love.graphics.newText(mainFont, "CROSS WINS!"), windowWidth * 0.28, windowHeight * 0.3, 0, windowWidth / 700, windowHeight / 700,"messageText")
        elseif winner == "O" then
            drawCenteredText(Love.graphics.newText(mainFont, "NOUGHT WINS!"), windowWidth * 0.26, windowHeight * 0.3, 0, windowWidth / 700, windowHeight / 700,"messageText")
        else
            drawCenteredText(Love.graphics.newText(mainFont, "IT'S A DRAW!"), windowWidth * 0.28, windowHeight * 0.3, 0, windowWidth / 700, windowHeight / 700,"messageText")
        end

        drawCenteredText(Love.graphics.newText(mainFont, "Back to Main Menu"), windowWidth * 0.26, windowHeight * 0.635, 0, windowWidth / 1000, windowHeight / 1000,"messageText")
        drawCenteredText(Love.graphics.newText(mainFont, "Click to Restart"), windowWidth * 0.28, windowHeight * 0.835, 0, windowWidth / 1000, windowHeight / 1000,"messageText")
        
    else
        -- gameStarted == false and gameOver == true
        drawCenteredText(Love.graphics.newText(mainFont, "Settings"), windowWidth * 0.35, windowHeight * 0.15, 0, windowWidth / 800, windowHeight / 800,"settingsText")
        drawCenteredText(Love.graphics.newText(mainFont, "Color Palette: " .. colorPalette), windowWidth * 0.15, windowHeight * 0.42, 0, windowWidth / 1000, windowHeight / 1000,"settingsText")
        drawCenteredText(Love.graphics.newText(mainFont, "Grid Size: " .. gridSize), windowWidth * 0.15, windowHeight * 0.49, 0, windowWidth / 1000, windowHeight / 1000,"settingsText")
        drawCenteredText(Love.graphics.newText(mainFont, "Difficulty: " .. difficulty), windowWidth * 0.15, windowHeight * 0.56, 0, windowWidth / 1000, windowHeight / 1000,"settingsText")
        drawCenteredText(Love.graphics.newText(mainFont, "Game mode: " .. gameMode), windowWidth * 0.15, windowHeight * 0.63, 0, windowWidth / 1000, windowHeight / 1000,"settingsText")
        drawCenteredText(Love.graphics.newText(mainFont, "Sound: " .. sound), windowWidth * 0.15, windowHeight * 0.70, 0, windowWidth / 1000, windowHeight / 1000,"settingsText")
        drawCenteredText(Love.graphics.newText(mainFont, "Return "), windowWidth * 0.15, windowHeight * 0.85, 0, windowWidth / 1000, windowHeight / 1000,"settingsText")
        drawCenteredText(Love.graphics.newText(mainFont, "made by: @TheStelmach"), windowWidth * 0.69, windowHeight * 0.97, 0, windowWidth / 2200, windowHeight / 2200,"settingsText")
    end
    
    screenUpdated = true
end

function makeBoard()

    if gameStarted == false and gameOver == false then
        if mouseX >= windowWidth * 0.2 and mouseX <= windowWidth * 0.8 and
           mouseY >= windowHeight * 0.6 and mouseY <= windowHeight * 0.68 then
            print("Play with Computer - Not implemented yet!")
            Love.audio.play(beepSound)
        elseif mouseX >= windowWidth * 0.2 and mouseX <= windowWidth * 0.8 and
            mouseY >= windowHeight * 0.75 and mouseY <= windowHeight * 0.83 then
            gameStarted = true
            Love.audio.play(gameStartSound)
            sleep(0.5)  -- debounce
        elseif mouseX >= windowWidth * 0.9 and mouseY <= windowHeight * 0.1 then
            gameOver = true
            Love.audio.play(beepSound)
        else
        end

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
        if mouseX >= windowWidth * 0.22 and mouseX <= windowWidth * 0.55 and
           mouseY >= windowHeight * 0.6 and mouseY <= windowHeight * 0.68 then
            print("Back to Main Menu - Restarting Game!")
            gameStarted = false
            gameOver = false
            screenUpdated = false
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
            sleep(0.5)  -- debounce
        elseif mouseX >= windowWidth * 0.22 and mouseX <= windowWidth * 0.55 and
               mouseY >= windowHeight * 0.8 and mouseY <= windowHeight * 0.88 then
            print("Restarting Game!")
            gameStarted = true
            gameOver = false
            screenUpdated = false
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
            sleep(0.5) -- debounce
        end
    else
        if mouseY >= windowHeight * 0.41 and mouseY <= windowHeight * 0.47 then
            print("Palette changed")
            if colorPalette == "bright" then
                colorPalette = "dark"
                r_back, g_back, b_back, a_back = 20/255, 20/255, 40/255, 0
                Love.graphics.setBackgroundColor(r_back, g_back, b_back, a_back)
            else
                colorPalette = "bright"
                r_back, g_back, b_back, a_back = 255/255, 251/255, 219/255, 0
                Love.graphics.setBackgroundColor(r_back, g_back, b_back, a_back)
            end
            Love.audio.play(beepSound)
        elseif mouseY >= windowHeight * 0.48 and mouseY <= windowHeight * 0.54 then
            print("Grid size changed")
            if gridSize == "3x3" then
                gridSize = "4x4"
            elseif gridSize == "4x4" then
                gridSize = "5x5"
            else
                gridSize = "3x3"
            end
            Love.audio.play(beepSound)
        elseif mouseY >= windowHeight * 0.55 and mouseY <= windowHeight * 0.61 then
            print("Difficulty changed")
            if difficulty == "simple" then
                difficulty = "normal"
            elseif difficulty == "normal" then
                difficulty = "impossible"
            else
                difficulty = "simple"
            end
            Love.audio.play(beepSound)
        elseif mouseY >= windowHeight * 0.62 and mouseY <= windowHeight * 0.68 then
            print("Game mode changed")
            if gameMode == "continuous" then
                gameMode = "limited moves"
            else
                gameMode = "continuous"
            end
            Love.audio.play(beepSound)
        elseif mouseY >= windowHeight * 0.69 and mouseY <= windowHeight * 0.75 then
            print("Sound toggled")
            if sound == "on" then
                sound = "off"
                Love.audio.setVolume(0)
            else
                sound = "on"
                Love.audio.setVolume(1)
            end 
            Love.audio.play(beepSound)
        elseif mouseY >= windowHeight * 0.84 and mouseY <= windowHeight * 0.9 then
            print("Returning to Main Menu")
            gameOver = false
            Love.audio.play(beepSound)
        end

        drawCenteredText(Love.graphics.newText(mainFont, "Color Palette: " .. colorPalette), windowWidth * 0.15, windowHeight * 0.42, 0, windowWidth / 1000, windowHeight / 1000,"settingsText")
        drawCenteredText(Love.graphics.newText(mainFont, "Grid Size: " .. gridSize), windowWidth * 0.15, windowHeight * 0.49, 0, windowWidth / 1000, windowHeight / 1000,"settingsText")
        drawCenteredText(Love.graphics.newText(mainFont, "Difficulty: " .. difficulty), windowWidth * 0.15, windowHeight * 0.56, 0, windowWidth / 1000, windowHeight / 1000,"settingsText")
        drawCenteredText(Love.graphics.newText(mainFont, "Game mode: " .. gameMode), windowWidth * 0.15, windowHeight * 0.63, 0, windowWidth / 1000, windowHeight / 1000,"settingsText")
        drawCenteredText(Love.graphics.newText(mainFont, "Sound: " .. sound), windowWidth * 0.15, windowHeight * 0.70, 0, windowWidth / 1000, windowHeight / 1000,"settingsText")
        drawCenteredText(Love.graphics.newText(mainFont, "Return "), windowWidth * 0.15, windowHeight * 0.85, 0, windowWidth / 1000, windowHeight / 1000,"settingsText")
        
    end
end

function Love.mousepressed( x, y, button)
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
    elseif color == "settingsText" then
        Love.graphics.setColor( 119/255, 118/255, 188/255, 0.75)
    elseif color == "messageText" then
	    Love.graphics.setColor( r_back, g_back, b_back, 0.75)
    else
        Love.graphics.setColor( 0, 0, 1, 1)
    end
    Love.graphics.draw(text, x, y, r, sx, sy)
    
end



-- TO DO LIST:
-- DARK/BRIGHT COLOR MODE TOGGLE IN SETTINGS - done
-- IMPLEMENT AI FOR PLAYING VS COMPUTER 
-- ONLINE MULTIPLAYER (USING WEB SOCKETS)
