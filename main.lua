local Gamestate = require "gamestate" -- gamestates
local hero = require "hero"
Camera = require "camera"
Timer = require "timer"
Signals = require "signal"

--require("mobdebug").start()

require("AnAL") -- animations
require("sick") -- highscore
require("enemies")

require("constants")

local menu = {}
local game = {}
local intro = {}
local cutscene = {}
local pause = {}
local game_over = {}



function love.load(arg) 
  
  --gameTimer = Timer.new()
  highscore.set("ViraxianHS.txt", 1, "Player", 0)

  -- fonts
  level_small_font = love.graphics.setNewFont("assets/MiniMasa.ttf", 50)
  level_big_font = love.graphics.setNewFont("assets/MiniMasa.ttf", 70)
  hud_font = love.graphics.setNewFont("assets/MiniMasa.ttf", 30)
  pause_font_selected = love.graphics.setNewFont("assets/MiniMasa.ttf", 50)
  pause_font = love.graphics.setNewFont("assets/MiniMasa.ttf", 30)
  pause_font_big = love.graphics.setNewFont("assets/MiniMasa.ttf", 70)
  go_font = love.graphics.setNewFont("assets/MiniMasa.ttf", 40)
  
  
  -- sounds
  menu_music = love.audio.newSource("assets/music/Menu.mp3", "stream")
  menu_music:setLooping(true)
  player_shoot_sfx = love.audio.newSource("assets/sfx/player_shoot.wav", "stream")
  enemy_shoot_sfx = love.audio.newSource("assets/sfx/enemy_shoot.wav", "stream")
  menu_down_sfx = love.audio.newSource("assets/sfx/menu_down.wav", "stream")
  menu_up_sfx = love.audio.newSource("assets/sfx/menu_up.wav", "stream")
  heart_beat_sfx = love.audio.newSource("assets/sfx/heart_beat.wav", "stream")
  
  player_signals = Signals.new()
  enemy_signals = Signals.new()
  menu_signals = Signals.new()
  
  Gamestate.registerEvents()
  Gamestate.switch(menu) 
  
end

-- MENU --
function menu:init()
  menu_bg = love.graphics.newImage("assets/menu_bg.jpg")
  button = love.graphics.newImage("assets/przyciski.png")
  
  buttons = {}
  buttons.newgame = true
  buttons.options = false
  buttons.credits = false
  buttons.quitgame = false
  
end  

function menu:enter()
  start_game = false
  menu_signals:register('menu_down', function () love.audio.play(menu_down_sfx); love.audio.rewind(menu_down_sfx) end)
  menu_signals:register('menu_up', function () love.audio.play(menu_up_sfx); love.audio.rewind(menu_up_sfx) end)
  buttonNewGame = newAnimation(button, 512, 128, 0, 0)
  buttonNewGame:setMode("loop")
  buttonNewGame:seek(2)
  buttonOptions = newAnimation(button, 512, 128, 0, 0)
  buttonOptions:setMode("loop")
  buttonCredits = newAnimation(button, 512, 128, 0, 0)
  buttonCredits:setMode("loop")
  buttonExit = newAnimation(button, 512, 128, 0, 0)
  buttonExit:setMode("loop")
  
  love.audio.stop()
  love.audio.rewind(menu_music)
  love.audio.play(menu_music)
  alpha = {255}
  Timer.tween(1, alpha, {0}, 'out-expo')
end  

function menu:update(dt)
  
  if start_game == true then
    Timer.update(dt)
    if alpha[1] < 5 then
      if STARTING_LEVEL:sub(1,8) == "cutscene" then
        Gamestate.switch(cutscene, STARTING_LEVEL)
      else
        --Gamestate.switch(game, STARTING_LEVEL)
        Gamestate.switch(intro)
      end 
    end
  end
end

function menu:draw(dt)
  
  love.graphics.setColor(255,255,255,alpha[1])
  love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
  love.graphics.draw(menu_bg)
  buttonNewGame:draw(256,280)
  love.graphics.print("Iniekcja", 425, 300, 0 , 1)
  buttonOptions:draw(256,380)
  love.graphics.print("Terapia", 425, 400, 0 , 1)
  buttonCredits:draw(256,480)
  love.graphics.print("Personel", 415, 500, 0 , 1)
  buttonExit:draw(256,580)
  love.graphics.print("Zejście", 430, 600, 0 , 1)
  
end

function menu:keyreleased(key)
  if key == "return" and buttons.newgame == true then
    start_game = true
  elseif key == "return" and buttons.exitgame == true then
    love.event.quit()
  end
  if key == "down" and buttons.newgame == true then
    buttons.newgame = false
    buttons.options = true
    buttonNewGame:seek((buttonNewGame:getCurrentFrame())%2 + 1 )
    buttonOptions:seek((buttonOptions:getCurrentFrame())%2 + 1 ) 
  elseif key == "down" and buttons.options == true then
    buttons.options = false
    buttons.credits = true 
    buttonCredits:seek((buttonCredits:getCurrentFrame())%2 + 1 )
    buttonOptions:seek((buttonOptions:getCurrentFrame())%2 + 1 )
  elseif key == "down" and buttons.credits == true then
    buttons.credits = false
    buttons.exitgame = true
    buttonCredits:seek((buttonCredits:getCurrentFrame())%2 + 1 )
    buttonExit:seek((buttonExit:getCurrentFrame())%2 + 1 )
  elseif key == "down" and buttons.exitgame == true then
    buttons.exitgame = false
    buttons.newgame = true
    buttonNewGame:seek((buttonNewGame:getCurrentFrame())%2 + 1 )
    buttonExit:seek((buttonExit:getCurrentFrame())%2 + 1 )
  elseif key == "up" and buttons.newgame == true then
    buttons.newgame = false
    buttons.exitgame = true  
    buttonNewGame:seek((buttonNewGame:getCurrentFrame())%2 + 1 )
    buttonExit:seek((buttonExit:getCurrentFrame())%2 + 1 )
  elseif key == "up" and buttons.options == true then
    buttons.newgame = true
    buttons.options = false
    buttonNewGame:seek((buttonNewGame:getCurrentFrame())%2 + 1 )
    buttonOptions:seek((buttonOptions:getCurrentFrame())%2 + 1 )
  elseif key == "up" and buttons.credits == true then
    buttons.options = true
    buttons.credits = false  
    buttonCredits:seek((buttonCredits:getCurrentFrame())%2 + 1 )
    buttonOptions:seek((buttonOptions:getCurrentFrame())%2 + 1 )
  elseif key == "up" and buttons.exitgame == true then
    buttons.credits = true
    buttons.exitgame = false
    buttonCredits:seek((buttonCredits:getCurrentFrame())%2 + 1 )
    buttonExit:seek((buttonExit:getCurrentFrame())%2 + 1 )
  end 
  if key == "up" then
    menu_signals:emit('menu_up')
  elseif key == "down" then
    menu_signals:emit('menu_down')
  end  
  
end

function menu:leave()
  love.audio.stop(menu_music)
end
-- LEVELS --

function game:init()
  hud_el = love.graphics.newImage("assets/test.png")
end


function game:enter(previous_state,level)
  
  dir = -1 --left
  
  game_alpha = {0}
  Timer.tween(LEVEL_BLACK_SCREEN, game_alpha, {255}, 'expo')
  
  
  for i, score, name in highscore() do
    highestscore = score
  end

  player_signals:register('player_shoot', function () love.audio.play(player_shoot_sfx); love.audio.rewind(player_shoot_sfx) end)
  enemy_signals:register('enemy_shoot', function () love.audio.play(enemy_shoot_sfx); love.audio.rewind(enemy_shoot_sfx) end)
  
  -- graphic assets
  if level == "level_one" then
    bg = love.graphics.newImage("assets/Level_1.jpg")
    lvl_txt = "Poziom 1"
    lvl_sub = "OKO"
  elseif level == "level_two" then
    bg = love.graphics.newImage("assets/Level_2.jpg")
    lvl_txt = "Poziom 2"
    lvl_sub = "NOS"
  elseif level == "level_three" then
    bg = love.graphics.newImage("assets/Level_3.jpg")
    lvl_txt = "Poziom 3"
    lvl_sub = "WĄTROBA"
  elseif level == "level_four" then
    bg = love.graphics.newImage("assets/Level_4.jpg")
    lvl_txt = "Poziom 4"
    lvl_sub = "SERCE"  
  elseif level == "level_five" then
    bg = love.graphics.newImage("assets/Level_5.jpg")
    lvl_txt = "Poziom 5"
    lvl_sub = "MÓZG"      
  end
  spaceship = love.graphics.newImage("assets/ship2.png")
  
  bacteria_anim = newAnimation(bacteria_img, 64, 64, 0.5, 2)
  bacteria_anim:setMode("loop")
  virus_anim = newAnimation(virus_img, 64, 64, 0.5, 3)
  virus_anim:setMode("bounce")
  prion_anim = newAnimation(prion_img, 64, 64, 0.5, 2)
  prion_anim:setMode("loop")
  
  enemies_shots = {}
  
  current_level = level
  
  if level == "level_one" then
    score = 0
    lives = 3
    timeToLaunchKamikaze = FIRST_KAMIKAZE
    hero.load()
    level_one = love.filesystem.load("level_one.lua")
    local load_level = level_one()
    --camera = Camera(CAMERA_POS_X_L1,CAMERA_POS_Y_L1,CAMERA_ZOOM_L1)
    camera = Camera(SCREEN_WIDTH/2,SCREEN_HEIGHT/2,1)
  elseif level == "level_two" then
    score = 0 -- wywalic w ostatecznej wersji
    lives = 3 -- wywalic
    timeToLaunchKamikaze = FIRST_KAMIKAZE
    hero.load()
    level_two = love.filesystem.load("level_two.lua")
    local load_level = level_two()    
    camera = Camera(SCREEN_WIDTH/2,SCREEN_HEIGHT/2,1)
  elseif level == "level_three" then
    score = 0 -- wywalic w ostatecznej wersji
    lives = 3 -- wywalic
    timeToLaunchKamikaze = FIRST_KAMIKAZE
    hero.load()
    level_three = love.filesystem.load("level_three.lua")
    local load_level = level_three()    
    camera = Camera(SCREEN_WIDTH/2,SCREEN_HEIGHT/2,1)    
  elseif level == "level_four" then
    score = 0 -- wywalic w ostatecznej wersji
    lives = 3 -- wywalic
    timeToLaunchKamikaze = FIRST_KAMIKAZE
    timeToLaunchPrion = 10
    timeToHeartBeat = HEART_BEAT
    hero.load()
    level_four = love.filesystem.load("level_four.lua")
    local load_level = level_four()    
    camera = Camera(SCREEN_WIDTH/2,SCREEN_HEIGHT/2,1)     
  elseif level == "level_five" then
    score = 0 -- wywalic w ostatecznej wersji
    lives = 3 -- wywalic
    timeToLaunchKamikaze = FIRST_KAMIKAZE
    timeToLaunchPrion = 10
    hero.load()
    level_four = love.filesystem.load("level_five.lua")
    local load_level = level_four()    
    camera = Camera(SCREEN_WIDTH/2,SCREEN_HEIGHT/2,1)      
  end
  
  love.audio.stop()
  love.audio.rewind(bgm)
  love.audio.play(bgm)  
  
end  

function game:update(dt)

  Timer.update(dt)
  if game_alpha[1] < 254 then return end
  
  hero.update(dt)
  update_enemies(dt)
  bacteria_anim:update(dt)
  virus_anim:update(dt)
  prion_anim:update(dt)
  
  if score > highestscore then
    highestscore = score
  end

  if lives <= 0 then
    local message = "Game Over"
    Gamestate.switch(game_over, message)
  end
  
    -- HEART BEAT
  if current_level == "level_four" then
    if timeToHeartBeat <= 0 then
      love.audio.rewind(heart_beat_sfx)
      love.audio.play(heart_beat_sfx)
      timeToHeartBeat = HEART_BEAT
    else
      timeToHeartBeat = timeToHeartBeat - dt
    end
  end
  
  if #enemies == 0 and #flying_enemies == 0 and current_level == "level_one" then
    Gamestate.switch(cutscene,"cutscene2")
  elseif #enemies == 0 and #flying_enemies == 0 and current_level == "level_two" then  
    Gamestate.switch(cutscene,"cutscene3")
    --camera:lookAt(hero.x, hero.y)
  elseif #enemies == 0 and #flying_enemies == 0 and current_level == "level_three" then  
    Gamestate.switch(cutscene,"cutscene4")
  elseif #enemies == 0 and #flying_enemies == 0 and current_level == "level_four" then  
    --local dx,dy = hero.x - camera.x, hero.y - camera.y
    --local dl = math.sqrt(dx*dx+dy*dy)
    --Timer.do_for(1, function() camera:move(dx,dy) end, function () camera:zoom(2) end)
    Gamestate.switch(cutscene,"cutscene5")
  elseif #enemies == 0 and #flying_enemies == 0 and current_level == "level_five" then  
    Gamestate.switch(cutscene,"cutscene6")    
  elseif #enemies == 0 and #flying_enemies == 0 and #flagships == 0 then
    local message = "You won!"
    Gamestate.switch(game_over, message)
  end
  
end  

function heroMoveToCenter(dt)
  local herovector = {}
  herovector.x = hero.x - SCREEN_WIDTH/2 
  herovector.y = hero.y - SCREEN_HEIGHT/2
  herovector.length = math.sqrt(herovector.x*herovector.x + herovector.y*herovector.y)
  hero.x = hero.x + herovector.x/herovector.length*dt
  hero.y = hero.y + herovector.y/herovector.length*dt
end  

function game:draw(dt)
  
  love.graphics.setColor(255,255,255,255)
  love.graphics.setFont(level_small_font)
  love.graphics.printf(lvl_txt, 0, SCREEN_HEIGHT/2-200, SCREEN_WIDTH, "center")
  love.graphics.setFont(level_big_font)
  love.graphics.printf(lvl_sub, 0, SCREEN_HEIGHT/2-100, SCREEN_WIDTH, "center")
  
  
  -- fade in
  love.graphics.setBlendMode("alpha")
  love.graphics.setColor(255,255,255,game_alpha[1])
  love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
  
  
  love.graphics.setFont( hud_font )
  
  camera:attach()
  
  -- BACKGROUND
  love.graphics.draw(bg)
  
  -- HERO
  if game_alpha[1] >= 254 then love.graphics.setColor(255,255,255,255) end
  --love.graphics.rectangle("line", hero.hitx, hero.hity, hero.width, hero.height)
  love.graphics.draw(hero.avatar, hero.x, hero.y)
  for i,v in ipairs(hero.shots) do
    love.graphics.rectangle("fill", v.x, v.y, 2, 5)
  end
  
  -- HEART BEAT
  if current_level == "level_four" then
    if timeToHeartBeat <=0 then
        local orig_x, orig_y = camera:pos()
        Timer.do_for(1, function()
        camera:lookAt(orig_x + math.random(-4,4), orig_y + math.random(-4,4)) end, 
        function()
        -- reset camera position
        camera:lookAt(orig_x, orig_y)
      end)
    end
  end
  
  -- ENEMIES
  for i,v in ipairs(enemies) do
    if v.type == "bacteria" then
      bacteria_anim:draw(v.x, v.y) 
      --love.graphics.rectangle("line", v.hitx, v.hity, v.width, v.height)
    elseif v.type == "virus" then
      virus_anim:draw(v.x, v.y)
      --love.graphics.rectangle("line", v.hitx, v.hity, v.width, v.height)
    elseif v.type == "prion" then
      prion_anim:draw(v.x, v.y)
      --love.graphics.rectangle("line", v.hitx, v.hity, v.width, v.height)
    end
    
  end
 
  for i,v in ipairs(flying_enemies) do
    if v.type == "bacteria" then
      bacteria_anim:draw(v.x, v.y)
      --love.graphics.rectangle("line", v.hitx, v.hity, v.width, v.height)
    elseif v.type == "virus" then
      virus_anim:draw(v.x, v.y)
      --love.graphics.rectangle("line", v.hitx, v.hity, v.width, v.height)
    elseif v.type == "prion" then
      prion_anim:draw(v.x, v.y)
      --love.graphics.rectangle("line", v.hitx, v.hity, v.width, v.height)
    end  
  end
  
  love.graphics.setColor(255,255,0,255)
  for i,v in ipairs(enemies_shots) do
    love.graphics.rectangle("fill", v.x, v.y, 2, 5)
  end
  

  
  camera:detach()
  
  --if alpha[1] < 254 then return end
  
  -- HUD
  love.graphics.setColor(255,255,255,game_alpha[1])
  love.graphics.draw(hud_el)
  love.graphics.print("WYNIK: ", 10, 10, 0)
  love.graphics.print(score, 100, 10, 0)
  love.graphics.print("REKORD: ", SCREEN_WIDTH/2-90, 10)
  love.graphics.print(highestscore, SCREEN_WIDTH/2+29, 10)
  love.graphics.print("ENERGIA: ", SCREEN_WIDTH-200, 10)
  
  for i=0,lives-1 do
    love.graphics.draw(hero.avatar,SCREEN_WIDTH-95+(i*30), 8, 0, 0.5, 0.5)
  end
  
  
  
end

function game:keyreleased(key)
  if key == " " then
    shoot()
  end
end

function game:keypressed(key)
  if key == "escape" then
    Gamestate.push(pause)
  end
end

-- CUT SCENE

function cutscene:init()
  love.graphics.setColor(255,255,255,255)
  textbox = love.graphics.newImage("assets/text_box.png")
  serce = love.graphics.newImage("assets/serce.png")
  mozg = love.graphics.newImage("assets/mozg.png")
  cs_music = love.audio.newSource("assets/music/Cutscenki.mp3", "stream")
  cs_music:setLooping(true)
  char_font = love.graphics.setNewFont("assets/MiniMasa.ttf", 40)
  text_font = love.graphics.setNewFont("assets/MiniMasa.ttf", 30)  
end  

function cutscene:enter(previous_state,cutscene)
  cut_alpha = {0}
  Timer.tween(1, cut_alpha, {255}, 'out-expo')
  love.audio.stop()
  love.audio.rewind(cs_music)
  love.audio.play(cs_music)
  curr_cutscene = cutscene
  text_iter = 1
  if curr_cutscene == "cutscene1" then
    cutscene_to_load = love.filesystem.load("cut_scene_1.lua")
    --char = 1
    --time_to_char = TEXT_SPEED
  elseif curr_cutscene == "cutscene2" then
    cutscene_to_load = love.filesystem.load("cut_scene_2.lua")
  elseif curr_cutscene == "cutscene3" then
    cutscene_to_load = love.filesystem.load("cut_scene_3.lua")   
  elseif curr_cutscene == "cutscene4" then
    cutscene_to_load = love.filesystem.load("cut_scene_4.lua")    
  elseif curr_cutscene == "cutscene5" then
    cutscene_to_load = love.filesystem.load("cut_scene_5.lua")       
  end  
  local loaded_cutscene = cutscene_to_load()
end  

function cutscene:update(dt)
  --[[if #current_text < #next_text then
    if time_to_char <= 0 then
      local c = CodeFromUTF8(next_text:sub(char,char))
      current_text = current_text .. CodeToUTF8(c)
      char = char + 1
      time_to_char = TEXT_SPEED
    else
      time_to_char = time_to_char - dt
    end
  else
    char = 0
  end]]
  Timer.update(dt)
  current_text = texts_table[text_iter]
  current_character = characters_table[text_iter]
end

function cutscene:draw(dt)
  love.graphics.setColor(255,255,255,cut_alpha[1])
  --love.graphics.draw(bg)
  love.graphics.setBackgroundColor(0,0,0,0)	
    --love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
  if sides_table[text_iter] == "right" then
    love.graphics.draw(mozg, 0, 120)
    love.graphics.draw(textbox, 200, SCREEN_HEIGHT-250)
    love.graphics.setFont( char_font )
    love.graphics.printf(current_character, 225, SCREEN_HEIGHT-240, 750, "left")
    love.graphics.setFont( text_font )
    love.graphics.printf(current_text, 225, SCREEN_HEIGHT-200, 750, "left")
  elseif sides_table[text_iter] == "left" then  
    love.graphics.draw(serce, 400, 120)
    love.graphics.draw(textbox, 20, SCREEN_HEIGHT-250)
    love.graphics.setFont( char_font )
    love.graphics.printf(current_character, 45, SCREEN_HEIGHT-240, 750, "left")
    love.graphics.setFont( text_font )
    love.graphics.printf(current_text, 45, SCREEN_HEIGHT-200, 750, "left")    
  end
  
end

function cutscene:keyreleased(key)
  if (key == "return" and text_iter == #texts_table) or (key == "escape") then
    if curr_cutscene == "cutscene1" then
      Gamestate.switch(game, "level_one")
    elseif curr_cutscene == "cutscene2" then
      Gamestate.switch(game, "level_two")
    elseif curr_cutscene == "cutscene3" then
      Gamestate.switch(game, "level_three") 
    elseif curr_cutscene == "cutscene4" then
      Gamestate.switch(game, "level_four") 
    elseif curr_cutscene == "cutscene5" then
      Gamestate.switch(game, "level_five")   
    end
  elseif key == "return" then
    text_iter = text_iter + 1
  end
end

-- INTRO

function intro:enter()
  
  intro_text = "Początkowo nic nie wskazywało na infekcję.\n\nBliższe badania wykazały jednak dziwne, choć niewytłumaczalne symptomy ogólnego osłabienia. Wykresy  procesów biochemicznych wyraźnie sugerowały zaburzenie funkcjonowania narządów. Coś kryło się we wnętrzu ciała.\n\nDecyzją lekarzy, nanorobot medyczny o nazwie Crap, otrzymuje zadanie wniknięcia do wnętrza organizmu, by znaleźć źródło dziwnego stanu pacjenta.\n\nPrzemierzając otchłanie jamy brzusznej, Crap nie zauważył jednak niczego podejrzanego. I właśnie wtedy czujniki nanorobota przechwyciły zakodowaną transmisję..."
  
end

function intro:draw(dt)
  love.graphics.setBackgroundColor(0,0,0)
  love.graphics.setFont( pause_font )
  love.graphics.setColor(255,255,255)
  love.graphics.printf(intro_text, 20, 120, SCREEN_WIDTH-20, 'center')  
end

function intro:keyreleased(key)
  if key == "return" or key == "escape" then
    Gamestate.switch(cutscene, "cutscene1")
  end
end

-- PAUSE

function pause:enter(from)
    self.from = from -- record previous state
    pause_selected = "resume"
end

function pause:draw()
    local W, H = love.graphics.getWidth(), love.graphics.getHeight()
    -- draw previous screen
    self.from:draw()
    love.graphics.setFont( pause_font_big )
    -- overlay with pause message
    love.graphics.setColor(0,0,0, 200)
    love.graphics.rectangle('fill', 0,0, W,H)
    love.graphics.setColor(255,255,255)
    love.graphics.printf('ŚPIĄCZKA', 0, H/2-120, W-50, 'center')
    
    if pause_selected == "exit" then
      love.graphics.setFont( pause_font_selected )
      love.graphics.printf('Odłącz', 0, H/2+30, W-50, 'center')
      love.graphics.setFont( pause_font )
      love.graphics.printf('Wybudź', 0, H/2-20, W-50, 'center')      
    elseif pause_selected == "resume" then
      love.graphics.setFont( pause_font )
      love.graphics.printf('Odłącz', 0, H/2+50, W-50, 'center')
      love.graphics.setFont( pause_font_selected )
      love.graphics.printf('Wybudź', 0, H/2-20, W-50, 'center')      
      
    end
    
end

function pause:keypressed(key)
    if key == 'escape' then
        Gamestate.pop() -- return to previous state
    elseif (key == "up" or key == "down") and pause_selected == "resume" then
      pause_selected = "exit"
    elseif (key == "up" or key == "down") and pause_selected == "exit" then
      pause_selected = "resume"
    elseif key == "return" and pause_selected == "resume" then
      Gamestate.pop()
    end
end

function pause:keyreleased(key)
  if key == "return" and pause_selected == "exit" then
      love.audio.stop(bgm)
      Gamestate.switch(menu)
  end  
end 

-- GAME OVER --

function game_over:init()
  go_bg = love.graphics.newImage("assets/game_over_bg.jpg")
end

function game_over:enter(previous_state, message)
  love.audio.stop()
  output = message
  if message == "Game Over" then
    go_music = love.audio.newSource("assets/music/Porazka.mp3", "stream")
  elseif message == "You won!" then
    go_music = love.audio.newSource("assets/music/Zwyciestwo.mp3", "stream")
  end
  love.audio.play(go_music)
  highscore.add("Player", highestscore)
  highscore.save()
end  

function game_over:draw(dt)
  love.graphics.draw(go_bg)
  love.graphics.setFont( go_font )
  love.graphics.print(output, 400, 300, 0)
  love.graphics.print("Your Score:", 350, 400)
  love.graphics.print(score, 650, 400)
  love.graphics.print("Press Enter to continue", 350, 500, 0)
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


function CodeToUTF8 (Unicode)
    if (Unicode <= 0x7F) then return string.char(Unicode); end;

    if (Unicode <= 0x7FF) then
      local Byte0 = 0xC0 + math.floor(Unicode / 0x40);
      local Byte1 = 0x80 + (Unicode % 0x40);
      return string.char(Byte0, Byte1);
    end;

    if (Unicode <= 0xFFFF) then
      local Byte0 = 0xE0 +  math.floor(Unicode / 0x1000);
      local Byte1 = 0x80 + (math.floor(Unicode / 0x40) % 0x40);
      local Byte2 = 0x80 + (Unicode % 0x40);
      return string.char(Byte0, Byte1, Byte2);
    end;

    return "";                                   -- ignore UTF-32 for the moment
  end;
  
  function CodeFromUTF8 (UTF8)
    local Byte0 = string.byte(UTF8,1);
    if (math.floor(Byte0 / 0x80) == 0) then return Byte0; end;

    local Byte1 = string.byte(UTF8,2) % 0x40;
    if (math.floor(Byte0 / 0x20) == 0x06) then
      return (Byte0 % 0x20)*0x40 + Byte1;
    end;

    local Byte2 = string.byte(UTF8,3) % 0x40;
    if (math.floor(Byte0 / 0x10) == 0x0E) then
      return (Byte0 % 0x10)*0x1000 + Byte1*0x40 + Byte2;
    end;

    local Byte3 = string.byte(UTF8,4) % 0x40;
    if (math.floor(Byte0 / 0x08) == 0x1E) then
      return (Byte0 % 0x08)*0x40000 + Byte1*0x1000 + Byte2*0x40 + Byte3;
    end;
  end;