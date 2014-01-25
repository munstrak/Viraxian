bacteria_img = love.graphics.newImage("assets/bakteria.png")
virus_img = love.graphics.newImage("assets/alien1.png")

function create_enemy(enemytype, x, y)
  local enemy = {}
  enemy.width = 64
  enemy.height = 64
  enemy.x = x
  enemy.y = y
  enemy.swarmx = x
  enemy.swarmy = y
  enemy.velocity = 100
  enemy.veldir = -1
  enemy.shots_number = BACTERIA_SHOTS
  enemy.shooting_freq = 1 -- czas do pierwszego strzalu w sekundach
  if enemytype == "bacteria" then
    enemy.type = "bacteria"
    enemy.points = 30
    enemy.speed = BACTERIA_SPEED
    enemy.points_when_flying = 60
    enemy.recoil = BACTERIA_SHOT_RECOIL
  end
  if enemytype == "virus" then
    enemy.type = "virus"
    enemy.points = 40
    enemy.speed = VIRUS_SPEED
    enemy.points_when_flying = 80
    enemy.recoil = BACTERIA_SHOT_RECOIL
  end
  return enemy
end  

function update_enemies(dt)
  
  enleftx=SCREEN_WIDTH
  enrightx=0
  local remEnemyShots = {}
  
  
  for i,v in ipairs(enemies) do
    if v.x < enleftx then
      enleftx = v.swarmx
    end
    if v.x > enrightx then
      enrightx = v.swarmx
    end
  end
  
  if enleftx < 10 or enrightx > (SCREEN_WIDTH - 50) then
    for i,v in ipairs(enemies) do
      v.y = v.y + 32
    end
    for i,v in ipairs(flying_enemies) do
      v.swarmy = v.swarmy + 32
    end
    dir = -dir
  end
    
  if timeToLaunchKamikaze <= 0 then
    LaunchKamikaze()
    timeToLaunchKamikaze = love.math.random(KAMIKAZE_FREQ_MIN_L1,KAMIKAZE_FREQ_MAX_L1)
  else
    timeToLaunchKamikaze = timeToLaunchKamikaze - dt
  end
  
  for i,v in ipairs(flying_enemies) do
    local vector = {}
    vector.x = v.swarmx - v.x
    vector.y = v.swarmy - v.y
    vector.length = math.sqrt(vector.x*vector.x + vector.y*vector.y)
    
    if v.velocity >= -300 and v.velocity <= 300 then
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
      table.remove(flying_enemies,i)
    elseif v.y < v.swarmy then  
      v.x = v.x + (vector.x/vector.length)*100*dt
      v.y = v.y + (vector.y/vector.length)*100*dt
      v.shots_number = BACTERIA_SHOTS  -- TO DO zmienna liczba strzalow w zaleznosci od przeciwnika
    else --v.y < SCREEN_HEIGHT - 170 then 
      local herovector = {}
      herovector.x = hero.x - v.x
      --if herovector.x >= 0 then
      --  herovector.x = herovector.x - 50
      --else
      --  herovector.x = herovector.x + 50
      --end
      herovector.y = hero.y - v.y
      herovector.length = math.sqrt(herovector.x*herovector.x + herovector.y*herovector.y)
      --v.x = v.x + (herovector.x/herovector.length)*v.velocity*dt
      --v.y = v.y + (herovector.y/herovector.length)*100*dt
      v.x = v.x + v.flyvectorx*v.velocity*dt
      v.y = v.y + v.flyvectory*100*dt
      if v.shooting_freq <= 0 and v.y < SCREEN_HEIGHT - 300 then
        enemy_shoot(v)
        v.shooting_freq = love.math.random(KAMIKAZE_SHOT_FREQ_MIN,KAMIKAZE_SHOT_FREQ_MAX)
      else
        v.shooting_freq = v.shooting_freq - dt
      end
    --else
    --  v.y = v.y + 100*dt
    end
    if v.y > SCREEN_HEIGHT then
      v.x = v.swarmx
      v.y = 0
    end
  end
  
  -- check for hero hits
  for i,v in ipairs(enemies_shots) do
    if CheckCollision(hero.x, hero.y, hero.width, hero.height, v.x, v.y, 2, 2) then
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
      v.swarmx = v.swarmx + dir*FORMATION_SPEED*dt
    end
    
    for i,v in ipairs(flying_enemies) do
      v.swarmx = v.swarmx + dir*FORMATION_SPEED*dt
    end  
  end
  
  for i,v in ipairs(enemies_shots) do
    v.x = v.x + v.vectorx*300*dt
    v.y = v.y + v.vectory*300*dt
    if v.y < 0 then
      table.insert(remEnemyShots,i)
    end
  end
    
  -- remove marked shots
  for i,v in ipairs(remEnemyShots) do
    table.remove(enemies_shots, v)
  end
end

function LaunchKamikaze()
  local border_enemies = {}
  if current_level == "level_one" then
      for i,v in ipairs(enemies) do
        table.insert(border_enemies,i)
      end
  else
      if enleftx > SCREEN_WIDTH - enrightx then      
        for i,v in ipairs(enemies) do
          if v.x == enleftx then
            table.insert(border_enemies,i)
          end
        end
      else
        for i,v in ipairs(enemies) do
          if v.x == enrightx then
            table.insert(border_enemies,i)
          end
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
          table.insert(flying_enemies,v)
          table.remove(enemies,i)
        end
      end
    end
end

function enemy_shoot(enemy)
  if enemy.shots_number <= 0 then return end
  local shot = {}
  shot.x = enemy.x+enemy.width/2
  shot.y = enemy.y
  local herovector = {}
  herovector.x = hero.x - enemy.x + math.random(-enemy.recoil,enemy.recoil)
  herovector.y = hero.y - enemy.y
  herovector.length = math.sqrt(herovector.x*herovector.x + herovector.y*herovector.y)
  shot.vectorx = (herovector.x/herovector.length)
  shot.vectory = (herovector.y/herovector.length)
  shot.enemyx = enemy.x
  enemy.shots_number = enemy.shots_number - 1
  table.insert(enemies_shots, shot)
end
