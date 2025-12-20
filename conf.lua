function love.conf(t)
    t.window.title = "Tic-Tac-Toe"
    t.window.width = 600
    t.window.height = 600
    t.window.minwidth = 300      
    t.window.minheight = 300
    t.window.resizable = true
    t.modules.joystick = false
    t.modules.physics = false
end