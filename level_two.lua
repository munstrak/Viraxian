-- LEVEL TWO
enemies = {}
flying_enemies = {}

left_marigin = 70 
right_marigin = SCREEN_WIDTH - 134

for i=0,10 do
  local enemy = create_enemy("bacteria", i*(32 + 30) + 150, 62)
  --enemy.x = i * (enemy.width + 30) + 100
  --enemy.y = enemy.height + 100
  table.insert(enemies, enemy)
end  
    
for i=0,10 do
  local enemy = create_enemy("bacteria", i*(32 + 30) + 150, 132)
  --enemy.x = i * (enemy.width + 30) + 100
  --enemy.y = enemy.height + 100
  table.insert(enemies, enemy)
end
    
for i=0,10 do
  local enemy = create_enemy("bacteria", i*(32 + 30) + 150, 202)
  table.insert(enemies, enemy)
end 