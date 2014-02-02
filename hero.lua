hero = {} -- new table for the hero

function hero.load()  
  
  hero.avatar = love.graphics.newImage("assets/ship2.png")
  
  hero.x = SCREEN_WIDTH/2 -- x,y coordinates of the hero
  hero.y = 680
  hero.hitx = hero.x + 8
  hero.hity = hero.y + 8
  hero.width = 48
  hero.height = 48
  hero.speed = HERO_SPEED
  hero.shots = {}
  
end

function hero.update(dt)
  
  -- MOVEMENT
  if love.keyboard.isDown("left") then
    if hero.x > left_marigin then
      hero.x = hero.x - hero.speed*dt
    end
  elseif love.keyboard.isDown("right") then
    if hero.x < right_marigin then
      hero.x = hero.x + hero.speed*dt
    end
  end
  
  hero.hitx = hero.x + 8
  
  local remEnemy = {}
  local remFlyingEnemy = {}
  local remShot = {}
  
    -- update the shots
  for i,v in ipairs(hero.shots) do
    -- move them up up up
    v.y = v.y - dt * 500
 
    -- mark shots that are not visible for removal
    if v.y < 0 then
      table.insert(remShot, i)
    end
       
    -- check for collision with enemies
    for ii,vv in ipairs(enemies) do
      if CheckCollision(v.x,v.y,2,5,vv.hitx,vv.hity,vv.width,vv.height) then
        -- mark that enemy for removal
        if vv.type == "prion" then
          BreakFormation(vv.flagshipNumber)
        end
        table.insert(remEnemy, ii)
        score = score + vv.points
        -- mark the shot to be removed
        table.insert(remShot, i)
      end
    end
    
    -- check for collision with enemies
    for ii,vv in ipairs(flying_enemies) do
      if CheckCollision(v.x,v.y,2,5,vv.hitx,vv.hity,vv.width,vv.height) then
        -- mark that enemy for removal
        if vv.type == "prion" then
          BreakFormation(vv.flagshipNumber)
        end
        table.insert(remFlyingEnemy, ii)
        score = score + vv.points_when_flying
        -- mark the shot to be removed
        table.insert(remShot, i)
      end
    end    

  end
  
  -- check for collision with kamikaze enemies
  for i,v in ipairs(flying_enemies) do
    if CheckCollision(hero.hitx, hero.hity, hero.width, hero.height, v.hitx, v.hity, v.width, v.height) then
      if v.type == "prion" then
          BreakFormation(v.flagshipNumber)
      end
      table.insert(remFlyingEnemy, i)
      lives = lives - 1
    end
  end
  
  -- remove the marked enemies
  table.sort(remEnemy, function(a,b) return a>b end)
  for i,v in ipairs(remEnemy) do
    table.remove(enemies, v)
  end
  
  table.sort(remFlyingEnemy, function(a,b) return a>b end)
  for i,v in ipairs(remFlyingEnemy) do
    table.remove(flying_enemies, v)
  end
  
  -- remove marked shots
  table.sort(remShot, function(a,b) return a>b end)
  for i,v in ipairs(remShot) do
    table.remove(hero.shots, v)
  end
  
end

function shoot()
  if #hero.shots >= HERO_SHOTS then return end
  local shot = {}
  shot.x = hero.x+8+hero.width/2
  shot.y = hero.y
  table.insert(hero.shots, shot)
  player_signals:emit('player_shoot')
end

function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

function BreakFormation(formationNumber)
  for i,v in ipairs(enemies) do
    if v.flagshipNumber == formationNumber then
      v.flagshipNumber = 0
    end
  end
  for i,v in ipairs(flying_enemies) do
    if v.flagshipNumber == formationNumber then
      v.flagshipNumber = 0
    end
  end  
end

return hero