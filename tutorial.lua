Tutorial = {}
Tutorial.forward = {x = 0, y = -75}
Tutorial.left = {x = -75, y = 0}
Tutorial.right = {x = 75, y = 0}
Tutorial.back = {x = 0, y = 75}
Tutorial.direction = 0 -- math.pi * 0.5
Tutorial.bounce = {offs = 0, total = 0}
Tutorial.pos = {x = 200, y = 200}
Tutorial.target = {r = 1, g = 0, b = 0, a = 1}
Tutorial.target.pos = {x = 300, y = 300, r = 50}
Tutorial.tut = {r = 0, g = .3, b = .5, a = 1}

local function target_left()
  return Tutorial.target.pos.x - Tutorial.target.pos.r
end
local function target_right()
  return Tutorial.target.pos.x + Tutorial.target.pos.r
end
local function on_target_x()
  return Tutorial.pos.x >= target_left() and Tutorial.pos.x <= target_right()
end
local function target_top()
  return Tutorial.target.pos.y + Tutorial.target.pos.r
end
local function target_bottom()
  return Tutorial.target.pos.y - Tutorial.target.pos.r
end
local function on_target_y()
  return Tutorial.pos.y >= target_bottom() and Tutorial.pos.y <= target_top()
end

local function on_target()
  return on_target_x() and on_target_y()
end

local function bouncy_x(d, val)
  return d * Tutorial.bounce.offs + Tutorial.pos.x + val
end

local function bouncy_y(d, val)
  return d * Tutorial.bounce.offs + Tutorial.pos.y + val
end


local function draw_protagonist()
  love.graphics.push()
  love.graphics.translate(Tutorial.pos.x, Tutorial.pos.y)
  love.graphics.rotate(Tutorial.direction)
  love.graphics.translate(-Tutorial.pos.x, -Tutorial.pos.y)
  love.graphics.print("W", bouncy_x(0, Tutorial.forward.x), bouncy_y(1,Tutorial.forward.y))
  love.graphics.print("A", bouncy_x(1, Tutorial.left.x), bouncy_y(0, Tutorial.left.y))
  love.graphics.print("S", bouncy_x(0, Tutorial.back.x), bouncy_y(-1, Tutorial.back.y))
  love.graphics.print("D", bouncy_x(-1, Tutorial.right.x), bouncy_y(0, Tutorial.right.y))
  love.graphics.pop()
end

function draw_tutorial()
  love.graphics.setColor(Tutorial.tut.r, Tutorial.tut.g, Tutorial.tut.b, Tutorial.tut.a)
  love.graphics.print("Move over the red letter", 50, 50)
  love.graphics.print("and press space!", 100, 100)
  love.graphics.setColor(Tutorial.target.r, Tutorial.target.g, Tutorial.target.b, Tutorial.target.a)
  love.graphics.print("E", 300, 300)
  love.graphics.setColor(Tutorial.tut.r, Tutorial.tut.g, Tutorial.tut.b, Tutorial.tut.a)
  love.graphics.print(Tutorial.pos.x, 0, 400)
  love.graphics.print(Tutorial.pos.y, 0, 450)
  if on_target() then
    love.graphics.print("on_target()", 0, 0)
  else
    love.graphics.print("no", 0, 0)
  end
  draw_protagonist()
end


local function update_bounce(dt)
  local new_total = Tutorial.bounce.total + dt
  new_total = new_total % 20
  Tutorial.bounce.total = new_total
  Tutorial.bounce.offs = 10 * math.sin(10 * Tutorial.bounce.total)
end

local function new_x(speed)
  return Tutorial.pos.x + speed * math.cos(Tutorial.direction)
end

local function new_y(speed)
  return Tutorial.pos.y + speed * math.sin(Tutorial.direction)
end

function update_tutorial(dt)
  update_bounce(dt)
  local speed = 10
  if love.keyboard.isDown("w") then
    Tutorial.pos = { x = new_x(speed), y = new_y(speed) }
  elseif love.keyboard.isDown("s") then
    Tutorial.pos = { x = new_x(-speed), y = new_y(-speed) }
  end
  
  if love.keyboard.isDown("a") then
    Tutorial.direction = Tutorial.direction - dt * 5
  elseif love.keyboard.isDown("d") then
    Tutorial.direction = Tutorial.direction + dt * 5
  end
end


function keypressed_tutorial(key)
  if key == "e" and on_target() then
    love.event.quit()
  end
end

Tutorial.draw = draw_tutorial
Tutorial.update = update_tutorial
Tutorial.keypressed = keypressed_tutorial