require("intro")
require("tutorial")

local Splashy = {}
Splashy.font = love.graphics.newFont("assets/fonts/KeyVirtue.ttf",64)
Splashy.currentUpdate = Intro.update
Splashy.currentDraw = Intro.draw
Splashy.intro = true


function love.load()
  love.graphics.setFont(Splashy.font)
end

function love.update(dt)
  Splashy.currentUpdate(dt)
end

function love.keypressed(key)  
  if Splashy.intro then
    Splashy.intro = false
    Splashy.currentDraw = Tutorial.draw
    Splashy.currentUpdate = Tutorial.update
    Splashy.currentKeypressed = Tutorial.keypressed
  else
    if key == "q" then
      love.event.quit()
    else
      Splashy.currentKeypressed(key)
    end
  end
end

function love.draw()
  Splashy.currentDraw()
end
