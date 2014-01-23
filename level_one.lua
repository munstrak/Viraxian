-- LEVEL ONE
enemies = {}
flying_enemies = {}

left_marigin = SCREEN_WIDTH - SCREEN_WIDTH/CAMERA_ZOOM_L1 - 40
right_marigin = SCREEN_WIDTH/CAMERA_ZOOM_L1 -20

for i=0,15 do
  local enemy = create_enemy("bacteria", i*(32+10)+SCREEN_WIDTH/2-300, 10)
  --enemy.x = i * (enemy.width + 30) + 100
  --enemy.y = enemy.height + 100
  table.insert(enemies, enemy)
 end 
 for i=0,15 do
  local enemy = create_enemy("bacteria", i*(32+10)+SCREEN_WIDTH/2-300, 10)
  --enemy.x = i * (enemy.width + 30) + 100
  --enemy.y = enemy.height + 100
  table.insert(enemies, enemy)
end 
--[[   
for i=0,10 do
  local enemy = create_enemy("bacteria", i*(32 + 40) + 100, 132)
  --enemy.x = i * (enemy.width + 30) + 100
  --enemy.y = enemy.height + 100
  table.insert(enemies, enemy)
end
    
for i=0,10 do
  local enemy = create_enemy("bacteria", i*(32 + 40) + 100, 202)
  table.insert(enemies, enemy)
end 
]]
