Intro = {}
Intro.splash = love.graphics.newImage("assets/sprites/splashy.png")
Intro.splash_x = 140
Intro.splash_y = -30
Intro.splash_offset_x = 0
Intro.splash_offset_y = 0
Intro.splash_orientation = 0.5
Intro.splash_r = 1
Intro.splash_g = 1
Intro.splash_b = 1
Intro.splash_a = 0
Intro.splash_scale = 2
Intro.text_first = 0
Intro.text_second = 0
Intro.text_first_alpha = 0
Intro.text_second_alpha = 0
Intro.text_red = .5
Intro.text_green = 1
Intro.text_blue = 1

local function draw_splash()
  love.graphics.setColor(Intro.splash_r,Intro.splash_g,Intro.splash_b, Intro.splash_a)
  love.graphics.draw(Intro.splash,Intro.splash_x,Intro.splash_y,
    Intro.splash_orientation,Intro.splash_scale,Intro.splash_scale,Intro.splash_offset_x,Intro.splash_offset_y)
end

function draw_intro()
  draw_splash()
  love.graphics.setColor(Intro.text_red,Intro.text_green,Intro.text_blue,Intro.text_first_alpha)
  love.graphics.print("I'm gonna eat you little fishy!", 40, 300)
  love.graphics.setColor(Intro.text_red,Intro.text_green,Intro.text_blue,Intro.text_second_alpha)
  love.graphics.print("'Cause I like little fish!", 260, 400)
end

local function update_colours(dt)
  Intro.text_red = Intro.text_red + (0 * dt)
  Intro.text_blue = Intro.text_blue - (1/7 * dt)
  Intro.text_green = Intro.text_green - (1/5 * dt)
end


local function update_alphas(dt)
  if Intro.splash_a < 1 then
    Intro.splash_a = Intro.splash_a + (1 / 5 * dt)
  end
  if Intro.splash_a > 0.01 then
    Intro.text_first_alpha = Intro.text_first_alpha + (1/5 * dt)
    if Intro.text_first_alpha > 0.5 then
      Intro.text_second_alpha = Intro.text_first_alpha * Intro.text_first_alpha * Intro.text_first_alpha
    end
  end
end

local function update_locations(dt)
  Intro.splash_x = Intro.splash_x + (5* dt)
end


local function update_intro(dt)
  update_colours(dt)
  update_alphas(dt)
  update_locations(dt)
end


Intro.update = update_intro
Intro.draw = draw_intro
