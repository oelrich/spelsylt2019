
function love.draw()
  font = love.graphics.newFont("assets/fonts/KeyVirtue.ttf",64)
  love.graphics.setFont(font)
  image = love.graphics.newImage("assets/sprites/splashy.png")
  love.graphics.draw(image,220,-30,0.5,2,2,0,0)
  love.graphics.print("I'm gonna eat you little fishy!", 40, 300)
  love.graphics.print("'Cause I like little fish'!", 280, 400)
end
