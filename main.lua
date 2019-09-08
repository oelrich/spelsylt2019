splashy_alpha = 0
text_first_alpha = 0
text_second_alpha = 0
text_red = .5
text_green = 1
text_blue = 1

function love.load()
  love.graphics.setFont(love.graphics.newFont("assets/fonts/KeyVirtue.ttf",64))
  image = love.graphics.newImage("assets/sprites/splashy.png")
end

function love.update(dt)
  require("lurker").update()
  if text_blue > 0 then
    text_blue = text_blue - (1/7 * dt)
    text_green = text_green - (1/5 * dt)
  end
  if splashy_alpha < 1 then
    splashy_alpha = splashy_alpha + (1 / 5 * dt)
  end
  if splashy_alpha > 0.01 then
    text_first_alpha = text_first_alpha + (1/5 * dt)
    if text_first_alpha > 0.5 then
      text_second_alpha = text_first_alpha * text_first_alpha * text_first_alpha
    end
  end
    
end

local function intro()
  love.graphics.setColor(1,1,1,splashy_alpha)
  love.graphics.draw(image,280,-30,0.5,2,2,0,0)
  love.graphics.setColor(text_red,text_green,text_blue,text_first_alpha)
  love.graphics.print("I'm gonna eat you little fishy!", 40, 300)
  love.graphics.setColor(text_red,text_green,text_blue,text_second_alpha)
  love.graphics.print("'Cause I like little fish!", 260, 400)

end

local function tutorial()
  love.graphics.print("W", 400, 100)
  love.graphics.print("A", 300, 200)
  love.graphics.print("S", 500, 200)
  love.graphics.print("D", 400, 300)
end

function love.draw()
  intro()

end
