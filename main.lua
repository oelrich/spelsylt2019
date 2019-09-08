local Splashy = {}
Splashy.font = love.graphics.newFont("assets/fonts/KeyVirtue.ttf",64)
Splashy.image = love.graphics.newImage("assets/sprites/splashy.png")

require("intro")

function love.load()
  love.graphics.setFont(Splashy.font)
end

function love.update(dt)
  require("lurker").update()
  Intro.update(dt)
end


local function tutorial()
  love.graphics.print("W", 400, 100)
  love.graphics.print("A", 300, 200)
  love.graphics.print("S", 500, 200)
  love.graphics.print("D", 400, 300)
end

function love.draw()
  Intro.draw()
end
