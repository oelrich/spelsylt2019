Tutorial = {}
Tutorial.center = {}
Tutorial.forward = {}
Tutorial.left = {}
Tutorial.right = {}
Tutorial.back = {}
Tutorial.rot = 0
Tutorial.x = 0
Tutorial.y = 0
Tutorial.center.x = 400
Tutorial.center.y = 200
Tutorial.forward.x = 400
Tutorial.forward.y = 100
Tutorial.forward.a = .4
Tutorial.left.x = 300
Tutorial.left.y = 200
Tutorial.left.a = 3.4
Tutorial.right.x = 500
Tutorial.right.y = 200
Tutorial.right.a = 2.4
Tutorial.back.x = 400
Tutorial.back.y = 300
Tutorial.back.a = .9
Tutorial.e = {}
Tutorial.e.r = 1
Tutorial.e.g = 0
Tutorial.e.b = 0
Tutorial.e.a = 1
Tutorial.tut = {}
Tutorial.tut.r = 0
Tutorial.tut.g = .3
Tutorial.tut.b = .5
Tutorial.tut.a = 1
total = 0
offs = 0
pressed = ""
function draw_tutorial()
  love.graphics.setColor(Tutorial.tut.r, Tutorial.tut.g, Tutorial.tut.b, Tutorial.tut.a)
  love.graphics.print("Move over the red letter", 50, 50)
  love.graphics.print("and press that key!", 100, 100)
  love.graphics.setColor(Tutorial.e.r, Tutorial.e.g, Tutorial.e.b, Tutorial.e.a)
  love.graphics.print("E", 300, 300)
  love.graphics.setColor(Tutorial.tut.r, Tutorial.tut.g, Tutorial.tut.b, Tutorial.tut.a)
  love.graphics.push()
  love.graphics.translate(Tutorial.center.x + Tutorial.x, Tutorial.center.y + Tutorial.y)
  love.graphics.rotate(Tutorial.rot + math.pi * 0.5)
  love.graphics.translate(-Tutorial.center.x - Tutorial.x, -Tutorial.center.y - Tutorial.y)
  love.graphics.print("W", Tutorial.forward.x, Tutorial.forward.y)
  love.graphics.print("A", Tutorial.left.x, Tutorial.left.y)
  love.graphics.print("S", Tutorial.back.x, Tutorial.back.y)
  love.graphics.print("D", Tutorial.right.x, Tutorial.right.y)
  love.graphics.pop()
  love.graphics.print(Tutorial.x, 0, 400)
  love.graphics.print(Tutorial.y, 0, 450)
end

function update_tutorial(dt)
  total = total + dt
  offs = 10 * math.sin(10 * total)
  if love.keyboard.isDown("w") then
    Tutorial.y = Tutorial.y + 10 * math.sin(Tutorial.rot)
    Tutorial.x = Tutorial.x + 10 * math.cos(Tutorial.rot)
  elseif love.keyboard.isDown("s") then
    Tutorial.y = Tutorial.y - 10 * math.sin(Tutorial.rot)
    Tutorial.x = Tutorial.x - 10 * math.cos(Tutorial.rot)
  end
  
  if love.keyboard.isDown("a") then
    Tutorial.rot = Tutorial.rot - dt * 5
  elseif love.keyboard.isDown("d") then
    Tutorial.rot = Tutorial.rot + dt * 5
  end

  Tutorial.forward.x = Tutorial.x + 400
  Tutorial.forward.y = Tutorial.y + 100 + offs
  Tutorial.left.x = Tutorial.x + 300 - offs
  Tutorial.left.y = Tutorial.y + 200
  Tutorial.right.x = Tutorial.x + 500 + offs
  Tutorial.right.y = Tutorial.y + 200
  Tutorial.back.x = Tutorial.x + 400
  Tutorial.back.y = Tutorial.y + 300 - offs
end

function keypressed_tutorial(key)
  if key == "e" then
    Tutorial.y = Tutorial.y
  end
  pressed = key
end

Tutorial.draw = draw_tutorial
Tutorial.update = update_tutorial
Tutorial.keypressed = keypressed_tutorial