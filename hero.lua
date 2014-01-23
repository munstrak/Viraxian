hero = {} -- new table for the hero

function hero.load()  
  
  hero.avatar = love.graphics.newImage("assets/ship2.png")
  
  hero.x = SCREEN_WIDTH/2 -- x,y coordinates of the hero
  hero.y = 650
  hero.width = 64
  hero.height = 64
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
  
  local remEnemy = {}
  local remFlyingEnemy = {}
  local remShot = {}
  
    -- update the shots
  for i,v in ipairs(hero.shots) do
    -- move them up up up
    v.y = v.y - dt * 500
 
    -- mark shots that are not visible for removal
    if current_level == "level_one" and v.y < (SCREEN_HEIGHT - SCREEN_HEIGHT/CAMERA_ZOOM_L1 + 10) then
      table.insert(remShot, i)
    elseif v.y < 0 then
      table.insert(remShot, i)
    end
       
    -- check for collision with enemies
    for ii,vv in ipairs(enemies) do
      if CheckCollision(v.x,v.y,2,5,vv.x,vv.y,vv.width,vv.height) then
        -- mark that enemy for removal
        table.insert(remEnemy, ii)
        score = score + vv.points
        -- mark the shot to be removed
        table.insert(remShot, i)
      end
    end
    
    -- check for collision with enemies
    for ii,vv in ipairs(flying_enemies) do
      if CheckCollision(v.x,v.y,2,5,vv.x,vv.y,vv.width,vv.height) then
        -- mark that enemy for removal
        table.insert(remFlyingEnemy, ii)
        score = score + vv.points_when_flying
        -- mark the shot to be removed
        table.insert(remShot, i)
      end
    end    

  end
  
  -- check for collision with kamikaze enemies
  for i,v in ipairs(flying_enemies) do
    if CheckCollision(hero.x, hero.y, hero.width, hero.height, v.x, v.y, v.width, v.height) then
      table.insert(remFlyingEnemy, i)
      lives = lives - 1
    end
  end

  -- remove the marked enemies
  for i,v in ipairs(remEnemy) do
    table.remove(enemies, v)
  end

  for i,v in ipairs(remFlyingEnemy) do
    table.remove(flying_enemies, v)
  end
  
  -- remove marked shots
  for i,v in ipairs(remShot) do
    table.remove(hero.shots, v)
  end
  
end

function shoot()
  if #hero.shots >= 5 then return end
  local shot = {}
  shot.x = hero.x+hero.width/2
  shot.y = hero.y
  table.insert(hero.shots, shot)
end

function CheckCollision(ax1,ay1,aw,ah, bx1,by1,bw,bh)
  local ax2,ay2,bx2,by2 = ax1 + aw, ay1 + ah, bx1 + bw, by1 + bh
  return ax1 < bx2 and ax2 > bx1 and ay1 < by2 and ay2 > by1
end

return hero