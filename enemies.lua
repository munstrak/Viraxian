bacteria_img = love.graphics.newImage("assets/bakteria.png")
virus_img = love.graphics.newImage("assets/alien1.png")

function create_enemy(enemytype, x, y)
  local enemy = {}
  enemy.width = 64
  enemy.height = 64
  enemy.x = x
  enemy.y = y
  if enemytype == "bacteria" then
    enemy.type = "bacteria"
    enemy.points = 30
    enemy.speed = 70
    enemy.points_when_flying = 60
  end
  if enemytype == "virus" then
    enemy.type = "virus"
    enemy.points = 40
    enemy.speed = 90
    enemy.points_when_flying = 80
  end
  return enemy
end  

function update_enemies(dt)
  
  enleftx=SCREEN_WIDTH
  enrightx=0
  
  for i,v in ipairs(enemies) do
    if v.x < enleftx then
      enleftx = v.x
    end
    if v.x > enrightx then
      enrightx = v.x
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
    
    if v.y < v.swarmy and vector.length < 100*dt then
      v.x = v.swarmx
      v.y = v.swarmy
      table.insert(enemies,v)
      table.remove(flying_enemies,i)
    elseif v.y < v.swarmy then  
      v.x = v.x + (vector.x/vector.length)*100*dt
      v.y = v.y + (vector.y/vector.length)*100*dt
    elseif v.y < SCREEN_HEIGHT - 170 then 
      local herovector = {}
      herovector.x = hero.x - v.x
      herovector.y = hero.y - v.y
      herovector.length = math.sqrt(herovector.x*herovector.x + herovector.y*herovector.y)
      v.x = v.x + (herovector.x/herovector.length)*100*dt
      v.y = v.y + (herovector.y/herovector.length)*100*dt
    else
      v.y = v.y + 100*dt
    end
    if v.y > SCREEN_HEIGHT then
      v.x = v.swarmx
      v.y = 0
    end
  end
  
  if current_level ~= "level_one" then
    for i,v in ipairs(enemies) do
      v.x = v.x + dir*FORMATION_SPEED*dt
    end
    
    for i,v in ipairs(flying_enemies) do
      v.swarmx = v.swarmx + dir*FORMATION_SPEED*dt
    end  
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
          table.insert(flying_enemies,v)
          table.remove(enemies,i)
        end
      end
    end
end