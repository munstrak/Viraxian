bacteria_img = love.graphics.newImage("assets/bakteria.png")
virus_img = love.graphics.newImage("assets/wirus.png")
prion_img = love.graphics.newImage("assets/prion.png")

function create_enemy(enemytype, x, y, escort, flagship)
  local enemy = {}
  enemy.x = x
  enemy.y = y
  enemy.swarmx = x
  enemy.swarmy = y
  enemy.velocity = 100
  enemy.veldir = -1
  enemy.shots_number = BACTERIA_SHOTS
  enemy.shooting_freq = 1.5 -- czas do pierwszego strzalu w sekundach
  if enemytype == "bacteria" then
    enemy.type = "bacteria"
    enemy.hitx = enemy.x + 19
    enemy.hity = enemy.y
    enemy.width = 26
    enemy.height = 43
    enemy.points = 30
    enemy.speed = BACTERIA_SPEED
    enemy.points_when_flying = 60
    enemy.recoil = BACTERIA_SHOT_RECOIL
  end
  if enemytype == "virus" then
    enemy.type = "virus"
    enemy.points = 40
    enemy.width = 20
    enemy.height = 19
    enemy.hitx = enemy.x + 23
    enemy.hity = enemy.y + 23    
    enemy.speed = VIRUS_SPEED
    enemy.points_when_flying = 80
    enemy.recoil = BACTERIA_SHOT_RECOIL
    enemy.isEscort = escort or false
    enemy.flagshipNumber = flagship or 0
  end
  if enemytype == "prion" then
    enemy.type = "prion"
    enemy.number = flagship
    enemy.points = 80
    enemy.width = 18
    enemy.height = 52
    enemy.hitx = enemy.x + 21
    enemy.hity = enemy.y + 7    
    enemy.speed = VIRUS_SPEED
    enemy.points_when_flying = 150
    enemy.recoil = BACTERIA_SHOT_RECOIL
    enemy.flagshipNumber = flagship or 0
  end  
  return enemy
end 

function update_enemies(dt)
  
  enleftx=SCREEN_WIDTH
  enrightx=0
  local remEnemyShots = {}
  local remFlyingEnemies = {}
  
  
  for i,v in ipairs(enemies) do
    if v.swarmx < enleftx then
      enleftx = v.swarmx
    end
    if v.swarmx > enrightx then
      enrightx = v.swarmx
    end
  end
  
  for i,v in ipairs(flying_enemies) do
    if v.swarmx < enleftx then
      enleftx = v.swarmx
    end
    if v.swarmx > enrightx then
      enrightx = v.swarmx
    end
  end
  
  if enleftx < 20 or enrightx > (SCREEN_WIDTH - 60) then
    dir = -dir
  end

  if timeToLaunchKamikaze <= 0 then
    LaunchKamikaze()
    if current_level == "level_one" then
      timeToLaunchKamikaze = love.math.random(KAMIKAZE_FREQ_MIN_L1,KAMIKAZE_FREQ_MAX_L1)
    else
      timeToLaunchKamikaze = love.math.random(KAMIKAZE_FREQ_MIN,KAMIKAZE_FREQ_MAX)
    end
  else
    timeToLaunchKamikaze = timeToLaunchKamikaze - dt
  end
  
  if current_level == "level_four" or current_level == "level_five" then
    if timeToLaunchPrion <= 0 then
      LaunchPrion(math.random(1,2))
      timeToLaunchPrion = love.math.random(5+(#enemies/10),10+(#enemies/10))
    else
      timeToLaunchPrion = timeToLaunchPrion - dt
    end
  end
  
  for i,v in ipairs(flying_enemies) do
    local vector = {}
    vector.x = v.swarmx - v.x
    vector.y = v.swarmy - v.y
    vector.length = math.sqrt(vector.x*vector.x + vector.y*vector.y)
    
    if (v.velocity >= -300 and v.velocity <= 300) then
      v.velocity = v.velocity + v.veldir*5
    else
      v.veldir = - v.veldir
      v.velocity = v.velocity + v.veldir*5
    end
    
    --print(i, " ", v.velocity)
    if v.y < v.swarmy and vector.length < 100*dt then
      v.x = v.swarmx
      v.y = v.swarmy
      table.insert(enemies,v)
      table.insert(remFlyingEnemies, i)

    elseif v.y < v.swarmy then  
      v.x = v.x + (vector.x/vector.length)*120*dt
      v.y = v.y + (vector.y/vector.length)*120*dt
      --v.shots_number = BACTERIA_SHOTS  -- TO DO zmienna liczba strzalow w zaleznosci od przeciwnika
    else 
      v.x = v.x + v.flyvectorx*70*dt + v.flyvectorx*v.velocity*dt
      v.y = v.y + v.flyvectory*100*dt
      if v.shooting_freq <= 0 and v.y < SCREEN_HEIGHT - 300 then
        enemy_shoot(v)
        if v.flagshipNumber == 1 or v.flagshipNumber == 2 then
          -- czestotliwosc strzalow dla szyku
          v.shooting_freq = love.math.random(KAMIKAZE_SHOT_FREQ_MIN,KAMIKAZE_SHOT_FREQ_MAX)/200
        else
          v.shooting_freq = love.math.random(KAMIKAZE_SHOT_FREQ_MIN,KAMIKAZE_SHOT_FREQ_MAX)/1000
        end
      else
        v.shooting_freq = v.shooting_freq - dt
      end
    --else
    --  v.y = v.y + 100*dt
    end
    if v.y > SCREEN_HEIGHT then
      v.x = v.swarmx
      v.shots_number = BACTERIA_SHOTS
      if current_level == "level_one" then
        v.y = -100
      else
        v.y = 0
      end
    end
    
    
    if v.type == "bacteria" then
        v.hitx = v.x + 19
        v.hity = v.y
    elseif v.type == "virus" then
        v.hitx = v.x + 23
        v.hity = v.y + 23
    elseif v.type == "prion" then
        v.hitx = v.x + 21
        v.hity = v.y + 7    
    end
  end
  
  -- check for hero hits
  for i,v in ipairs(enemies_shots) do
    if CheckCollision(hero.hitx, hero.hity, hero.width, hero.height, v.x, v.y, 2, 5) then
      table.insert(remEnemyShots, i)
      lives = lives - 1
    end
  end

  
  --[[
  for i,v in ipairs(flying_enemies) do
    for ii,vv in ipairs(v.shots) do
      if v.type == "bacteria" then
        vv.x = vv.x + vv.vectorx*300*dt
        vv.y = vv.y + vv.vectory*300*dt       
      end  
    end
  end
  ]]
  if current_level ~= "level_one" then
    for i,v in ipairs(enemies) do
      v.x = v.x + dir*FORMATION_SPEED*dt
      v.swarmx = v.x
      if v.type == "bacteria" then
          v.hitx = v.x + 19
          v.hity = v.y
      elseif v.type == "virus" then
          v.hitx = v.x + 23
          v.hity = v.y + 23
      elseif v.type == "prion" then
          v.hitx = v.x + 21
          v.hity = v.y + 7    
      end
    end
    
    for i,v in ipairs(flying_enemies) do
      v.swarmx = v.swarmx + dir*FORMATION_SPEED*dt
    end  
  end
  
  for i,v in ipairs(enemies_shots) do
    v.x = v.x + v.vectorx*250*dt
    v.y = v.y + v.vectory*250*dt
    if v.y < 0 then
      table.insert(remEnemyShots,i)
    end
  end
    
  -- remove marked shots
  table.sort(remEnemyShots, function(a,b) return a>b end)
  for i,v in ipairs(remEnemyShots) do
    table.remove(enemies_shots, v)
  end
  
  table.sort(remFlyingEnemies, function(a,b) return a>b end)
  for i,v in ipairs(remFlyingEnemies) do
    table.remove(flying_enemies, v)
  end
end

function LaunchKamikaze()
      local border_enemies = {}
      if current_level == "level_one" then
          for i,v in ipairs(enemies) do
            table.insert(border_enemies,i)
          end
      else
      for i,v in pairs(enemies) do
        if (v.x == enleftx and v.x > 150) or (v.x == enrightx and v.x < 874) then
          table.insert(border_enemies,i)
        end
      end
  end  
    if #border_enemies > 0 then
      local chosen_enemy = love.math.random(1,#border_enemies)
      for i,v in ipairs(enemies) do
        if i == border_enemies[chosen_enemy] then
          v.swarmx = v.x
          v.swarmy = v.y
          local herovector = {}
          herovector.x = hero.x - v.x + math.random(-50,50)
          herovector.y = hero.y - v.y
          herovector.length = math.sqrt(herovector.x*herovector.x + herovector.y*herovector.y)
          v.flyvectorx = (herovector.x/herovector.length)
          v.flyvectory = (herovector.y/herovector.length)
          if v.x == enright then
            v.veldir = 1
          elseif v.x == enleft then
            v.veldir = -1
            v.velocity = - v.velocity
          end
          table.insert(flying_enemies,v)
          table.remove(enemies,i)
        end
      end
    end
end

function LaunchPrion(flagshipNumber)
  local remPrions = {}
  local j = 1
  for i,v in ipairs(enemies) do
    if v.flagshipNumber == flagshipNumber then
      if j == 1 then 
        herovector = {}
        herovector.x = hero.x - v.x 
        herovector.y = hero.y - v.y
        herovector.length = math.sqrt(herovector.x*herovector.x + herovector.y*herovector.y)
        j = j + 1
      end
      v.swarmx = v.x
      v.swarmy = v.y
      v.flyvectorx = (herovector.x/herovector.length)
      v.flyvectory = (herovector.y/herovector.length) 

      table.insert(flying_enemies,v)
      table.insert(remPrions, i)
    end
  end
  
  table.sort(remPrions, function(a,b) return a>b end)
  
  for i,v in ipairs(remPrions) do
    table.remove(enemies,v)
  end
 
end


function enemy_shoot(enemy)
  if enemy.shots_number <= 0 then return end
  local shot = {}
  if enemy.type == "virus" then
    shot.x = enemy.x+(enemy.width*2)
    shot.y = enemy.y+(enemy.height*2)
  else  
    shot.x = enemy.x+enemy.width
    shot.y = enemy.y+enemy.height
  end  
  local herovector = {}
  herovector.x = hero.x - enemy.x + math.random(-enemy.recoil,enemy.recoil)
  herovector.y = hero.y - enemy.y
  herovector.length = math.sqrt(herovector.x*herovector.x + herovector.y*herovector.y)
  shot.vectorx = (herovector.x/herovector.length)
  shot.vectory = (herovector.y/herovector.length)
  shot.enemyx = enemy.x
  enemy.shots_number = enemy.shots_number - 1
  table.insert(enemies_shots, shot)
  enemy_signals:emit('enemy_shoot')
end