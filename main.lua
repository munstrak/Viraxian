local Gamestate = require "gamestate" -- gamestates
local hero = require "hero"
Camera = require("camera")
Timer = require "timer"

-- require("mobdebug").start()

require("AnAL") -- animations
require("sick") -- highscore
require("enemies")

require("constants")

local menu = {}
local game = {}
local game_over = {}



function love.load(arg) 
  
  --gameTimer = Timer.new()
  highscore.set("ViraxianHS.txt", 1, "Player", 0)

  Gamestate.registerEvents()
  Gamestate.switch(menu)
  
end

-- MENU --
function menu:init()
  menu_bg = love.graphics.newImage("assets/menu_bg.jpg")
  
  buttons = {}
  buttons.newgame = true
  buttons.options = false
  buttons.quitgame = false

  
end  

function menu:draw(dt)
  love.graphics.draw(menu_bg)
  
  love.graphics.print("New Game", 435, 350, 0 , 2)
  love.graphics.print("Options", 450, 400, 0 , 2)
  love.graphics.print("Exit Game", 440, 450, 0 , 2)
  
  if buttons.newgame == true then
    love.graphics.print("+", 410, 350, 0 , 2)
    love.graphics.print("+", 575, 350, 0 , 2)
  elseif buttons.options == true then
    love.graphics.print("+", 420, 400, 0 , 2)
    love.graphics.print("+", 560, 400, 0 , 2)
  elseif buttons.exitgame == true then
    love.graphics.print("+", 410, 450, 0 , 2)
    love.graphics.print("+", 575, 450, 0 , 2)
  end
  
end
--[[
function menu:update(dt)
  if love.keyboard.isDown("return") then
    Gamestate.switch(game)
  end
end
]]
function menu:keyreleased(key)
  if key == "return" and buttons.newgame == true then
    Gamestate.switch(game, "level_one")
  elseif key == "return" and buttons.exitgame == true then
    love.event.quit()
  end
  if key == "down" and buttons.newgame == true then
    buttons.newgame = false
    buttons.options = true
  elseif key == "down" and buttons.options == true then
    buttons.options = false
    buttons.exitgame = true 
  elseif key == "up" and buttons.options == true then
    buttons.newgame = true
    buttons.options = false
  elseif key == "up" and buttons.exitgame == true then
    buttons.options = true
    buttons.exitgame = false
  end 
    
end

-- LEVELS --

function game:init()
--  hero.load()  
--  score = 0
--  lives = 3
end


function game:enter(previous_state,level)
  
  dir = -1 --left
  
  for i, score, name in highscore() do
    highestscore = score
  end
  
  -- graphic assets
  if level == "level_one" then
    bg = love.graphics.newImage("assets/bg.png")
  else
    bg = love.graphics.newImage("assets/bg.png")
  end
  spaceship = love.graphics.newImage("assets/ship2.png")
  bacteria_anim = newAnimation(bacteria_img, 64, 64, 0.5, 2)
  bacteria_anim:setMode("loop")
  virus_anim = newAnimation(virus_img, 32, 32, 0.5, 1)
  virus_anim:setMode("loop")
  enemies_shots = {}
  
  current_level = level
  
  if level == "level_one" then
    score = 0
    lives = 3
    timeToLaunchKamikaze = FIRST_KAMIKAZE
    hero.load()
    level_one = love.filesystem.load("level_one.lua")
    local load_level = level_one()
    camera = Camera(CAMERA_POS_X_L1,CAMERA_POS_Y_L1,CAMERA_ZOOM_L1)
  elseif level == "level_two" then
    --score = 0 -- wywalic w ostatecznej wersji
    --lives = 3 -- wywalic
    timeToLaunchKamikaze = FIRST_KAMIKAZE
    hero.load()
    level_two = love.filesystem.load("level_two.lua")
    local load_level = level_two()    
    camera = Camera(SCREEN_WIDTH/2,SCREEN_HEIGHT/2,1)
  end
  
end  

function game:update(dt)
  
  hero.update(dt)
  update_enemies(dt)
  bacteria_anim:update(dt)
  virus_anim:update(dt)
  Timer.update(dt)
  
  if score > highestscore then
    highestscore = score
  end

  if lives <= 0 then
    local message = "Game Over"
    Gamestate.switch(game_over, message)
  end
  
  if #enemies == 0 and #flying_enemies == 0 and current_level == "level_one" then
    Gamestate.switch(game,"level_two")
    --camera:lookAt(hero.x, hero.y)
  elseif#enemies == 0 and #flying_enemies == 0 then
    local message = "You won!"
    Gamestate.switch(game_over, message)
  end
  
end  

function game:draw(dt)
  
  -- BACKGROUND
  love.graphics.draw(bg)

  camera:attach()
  -- HERO
  love.graphics.setColor(255,255,255,255)
  love.graphics.rectangle("line", hero.x, hero.y, hero.width, hero.height)
  love.graphics.draw(hero.avatar, hero.x, hero.y)
  love.graphics.setColor(255,255,255,255)
  for i,v in ipairs(hero.shots) do
    love.graphics.rectangle("fill", v.x, v.y, 2, 5)
  end
    
  -- ENEMIES
  for i,v in ipairs(enemies) do
    if v.type == "bacteria" then
      bacteria_anim:draw(v.x, v.y) 
    elseif v.type == "virus" then
      virus_anim:draw(v.x, v.y)
    end
  end
 
  for i,v in ipairs(flying_enemies) do
    if v.type == "bacteria" then
      bacteria_anim:draw(v.x, v.y)
    elseif v.type == "virus" then
      virus_anim:draw(v.x, v.y)
    end
  end
  
  love.graphics.setColor(255,255,255,255)
  for i,v in ipairs(enemies_shots) do
    love.graphics.rectangle("fill", v.x, v.y, 2, 2)
  end
  
  camera:detach()
  
  -- HUD
  
  love.graphics.print("SCORE: ", 10, 10, 0, 2, 2)
  love.graphics.print(score, 100, 10, 0, 2, 2)
  love.graphics.print("HIGH-SCORE: ", SCREEN_WIDTH/2-120, 10, 0, 2, 2)
  love.graphics.print(highestscore, SCREEN_WIDTH/2+50, 10, 0, 2, 2)
  love.graphics.print("LIVES: ", SCREEN_WIDTH-260, 10, 0, 2, 2)
  
  for i=0,lives-1 do
    love.graphics.draw(hero.avatar,SCREEN_WIDTH-180+(i*50), 0, 0, 0.75, 0.75)
  end
  
end

function game:keyreleased(key)
  if key == " " then
    shoot()
  end
end

-- GAME OVER --

function game_over:enter(previous_state, message)
  output = message
  highscore.add("Player", highestscore)
  highscore.save()
end  

function game_over:draw(dt)
  love.graphics.print(output, 400, 300, 0, 3, 3)
  love.graphics.print("Your Score:", 350, 400, 0, 3, 3)
  love.graphics.print(score, 650, 400, 0, 3, 3)
  love.graphics.print("Press Enter to continue", 350, 500, 0 , 2)
end

function game_over:update(dt)

end 

function game_over:keyreleased(key)
  if key == "return" then
    Gamestate.switch(menu)
  end
end

function love.update(dt)

end

function love.draw()
  
end