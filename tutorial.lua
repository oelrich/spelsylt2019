Tutorial = {}
Tutorial.forward = {x = -20, y = -105}
Tutorial.left = {x = -95, y = -30}
Tutorial.right = {x = 55, y = -30}
Tutorial.back = {x = -20, y = 45}
Tutorial.playing = false
Tutorial.direction = 0
Tutorial.bounce = {offs = 0, total = 0}
Tutorial.pos = {x = 200, y = 200}
Tutorial.high_score = 0
Tutorial.score = 0
Tutorial.energy = 1
Tutorial.alive = true
Tutorial.moved = false
Tutorial.attacked = false
Tutorial.chewing = 0
Tutorial.turned = false
Tutorial.target = {r = 1, g = 0, b = 0, a = 1}
Tutorial.target.pos = {x = 300, y = 300, r = 75, d = 0, v = 1}
Tutorial.tut = {r = 0, g = .5, b = .9, a = 1}

local function target_left()
  return Tutorial.target.pos.x
end
local function target_right()
  return Tutorial.target.pos.x + Tutorial.target.pos.r
end
local function on_target_x()
  return Tutorial.pos.x >= target_left() and Tutorial.pos.x <= target_right()
end
local function target_top()
  return Tutorial.target.pos.y
end
local function target_bottom()
  return Tutorial.target.pos.y + Tutorial.target.pos.r
end
local function on_target_y()
  return Tutorial.pos.y <= target_bottom() and Tutorial.pos.y >= target_top()
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
  love.graphics.rotate(Tutorial.direction + math.pi * 0.5)
  love.graphics.translate(-Tutorial.pos.x, -Tutorial.pos.y)
  love.graphics.setColor(.7,.7,0,1)
  love.graphics.print(".", Tutorial.pos.x, Tutorial.pos.y- 70)
  love.graphics.setColor(.1,.4,.1,1)
  love.graphics.print("W", bouncy_x(0, Tutorial.forward.x), bouncy_y(1,Tutorial.forward.y))
  love.graphics.print("A", bouncy_x(1, Tutorial.left.x), bouncy_y(0, Tutorial.left.y))
  love.graphics.print("S", bouncy_x(0, Tutorial.back.x), bouncy_y(-1, Tutorial.back.y))
  love.graphics.print("D", bouncy_x(-1, Tutorial.right.x), bouncy_y(0, Tutorial.right.y))
  love.graphics.pop()
end

local function draw_energy()
  local energy = -500 * Tutorial.energy
  love.graphics.setColor(Tutorial.tut.r, Tutorial.tut.g, Tutorial.tut.b, Tutorial.tut.a)
  love.graphics.rectangle("line", 10, 510, 20, -500)
  love.graphics.setColor(1 - (Tutorial.energy * Tutorial.energy), .7 * Tutorial.energy, .3 * Tutorial.energy, 1)
  love.graphics.rectangle("fill", 10, 510, 20, energy)
end

local function draw_living_tutorial()
  draw_energy()
  if Tutorial.playing then
    love.graphics.setColor(Tutorial.target.r, Tutorial.target.g, Tutorial.target.b, Tutorial.target.a)
    love.graphics.print("><>", Tutorial.target.pos.x, Tutorial.target.pos.y)
    love.graphics.setColor(Tutorial.tut.r, Tutorial.tut.g, Tutorial.tut.b, Tutorial.tut.a)
    love.graphics.print("Score: "..math.floor(Tutorial.score), 10, 510)
  else
    love.graphics.setColor(Tutorial.tut.r, Tutorial.tut.g, Tutorial.tut.b, Tutorial.tut.a)
    love.graphics.print("Move over the red fish", 50, 50)
    love.graphics.print("and press 'e' to eat it!", 100, 100)
    love.graphics.setColor(Tutorial.target.r, Tutorial.target.g, Tutorial.target.b, Tutorial.target.a)
    love.graphics.print("><>", 300, 300)
  end
  draw_protagonist()
end

function draw_tutorial()
  if Tutorial.alive then
    draw_living_tutorial()
  else
    love.graphics.setColor(Tutorial.tut.r, Tutorial.tut.g, Tutorial.tut.b, Tutorial.tut.a)
    love.graphics.print("Oh, no!", 300, 50)
    love.graphics.print("The Grim Fish Reaper Got You :'(", 15, 150)
    love.graphics.print("Try again?", 300, 250)
    love.graphics.print("(Y)es           (Q)uit", 200, 300)
    love.graphics.setColor(0,1,.5,1)
    if Tutorial.high_score < Tutorial.score then
      love.graphics.print("Your score of "..math.floor(Tutorial.score), 50, 400)
      love.graphics.print("beat the highscore of "..math.floor(Tutorial.high_score).."!", 50, 450)
    else
      love.graphics.print("Score: "..math.floor(Tutorial.score), 300, 400)
    end
  end
end

local function update_bounce(dt)
  local chew_frequency = 10
  local chew_amplitude = 5
  if Tutorial.chewing > 0 then
    Tutorial.chewing = Tutorial.chewing - dt
    chew_frequency = 5
    chew_amplitude = 100
  end
  local new_total = Tutorial.bounce.total + dt
  new_total = new_total % 20
  Tutorial.bounce.total = new_total
  Tutorial.bounce.offs = chew_amplitude * math.sin(chew_frequency * Tutorial.bounce.total)
end

local function delta_x(speed, angle)
  return speed * math.cos(angle)
end
local function delta_y(speed, angle)
  return speed * math.sin(angle)
end
local function new_x(speed)
  return Tutorial.pos.x + delta_x(speed, Tutorial.direction)
end
local function new_y(speed)
  return Tutorial.pos.y + delta_y(speed, Tutorial.direction)
end
local function movement_energy_expenditure(dt)
  Tutorial.energy = Tutorial.energy - 1/2 * dt
end
local function turn_energy_expenditure(dt)
  Tutorial.energy = Tutorial.energy - 1/30 * dt
end
local function attack_energy_expenditure()
  Tutorial.energy = Tutorial.energy - 0.1
end
local function update_energy(dt)
  Tutorial.energy = Tutorial.energy - 1/500 * dt
  if Tutorial.moved then
    movement_energy_expenditure(dt)
    Tutorial.moved = false
  end
  if Tutorial.turned then
    turn_energy_expenditure(dt)
    Tutorial.turned = false
  end
  if Tutorial.attacked then
    attack_energy_expenditure()
    Tutorial.attacked = false
  end
  if Tutorial.chewing > 0 then
    if on_target() then
      Tutorial.score = Tutorial.score + 1
      Tutorial.energy = Tutorial.energy + 0.005
      if Tutorial.energy >= 1 then
        Tutorial.energy = 1
      end
    end
  end
end

local function random_signed()
  if math.random() < math.random() then
    return -math.random()
  end
  return math.random()
end

local function update_target(dt)
  if Tutorial.chewing > 0 and on_target() then
    Tutorial.target.pos.d = Tutorial.target.pos.d + random_signed()
  else
    Tutorial.target.pos.d = Tutorial.target.pos.d + random_signed() * 0.1
    Tutorial.target.pos.v = 1
  end
  if Tutorial.target.pos.x > love.graphics.getWidth() - 70 then
    Tutorial.target.pos.d = Tutorial.target.pos.d - math.pi
  elseif Tutorial.target.pos.x < 0 then
    Tutorial.target.pos.d = Tutorial.target.pos.d + math.pi
  elseif Tutorial.target.pos.y > love.graphics.getHeight() - 50 then
    Tutorial.target.pos.d = Tutorial.target.pos.d - math.pi * 0.5
  elseif Tutorial.target.pos.y < -30 then
    Tutorial.target.pos.d = Tutorial.target.pos.d + math.pi * 0.5
  end
  Tutorial.target.pos.x = Tutorial.target.pos.x + delta_x(Tutorial.target.pos.v, Tutorial.target.pos.d)
  Tutorial.target.pos.y = Tutorial.target.pos.y + delta_y(Tutorial.target.pos.v, Tutorial.target.pos.d)
end

function update_tutorial(dt)
  if Tutorial.alive then
    update_bounce(dt)
    local speed = 10
    if love.keyboard.isDown("w") then
      Tutorial.moved = true
      Tutorial.pos = { x = new_x(speed), y = new_y(speed) }
    elseif love.keyboard.isDown("s") then
      Tutorial.moved = true
      Tutorial.pos = { x = new_x(-speed), y = new_y(-speed) }
    end
    if love.keyboard.isDown("a") then
      Tutorial.turned = true
      Tutorial.direction = Tutorial.direction - dt * 5
    elseif love.keyboard.isDown("d") then
      Tutorial.turned = true
      Tutorial.direction = Tutorial.direction + dt * 5
    end
    if Tutorial.playing then
      update_target(dt)
      Tutorial.score = Tutorial.score + dt
      update_energy(dt)
    end
    if Tutorial.energy <= 0 then
      if Tutorial.alive == true then
        Tutorial.score = Tutorial.score - 6
      end
      Tutorial.alive = false
    end
  end
end

function keypressed_tutorial(key)
  if Tutorial.alive then
    if key == "e" then
      if not Tutorial.playing and on_target() then
        Tutorial.playing = true
      end
      Tutorial.chewing = 4
      Tutorial.attacked = true
      Tutorial.target.v = 5
    end
  else
    if key == "y" then
      if Tutorial.score > Tutorial.high_score then
        Tutorial.high_score = Tutorial.score
      end
      Tutorial.direction = 0
      Tutorial.bounce = {offs = 0, total = 0}
      Tutorial.pos = {x = 200, y = 200}
      Tutorial.score = 0
      Tutorial.energy = 1
      Tutorial.alive = true
      Tutorial.moved = false
      Tutorial.attacked = false
      Tutorial.turned = false
    end
  end
end

Tutorial.draw = draw_tutorial
Tutorial.update = update_tutorial
Tutorial.keypressed = keypressed_tutorial