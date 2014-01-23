-- LEVEL TWO
enemies = {}
flying_enemies = {}

left_marigin = 10 
right_marigin = SCREEN_WIDTH - 74

for i=0,10 do
  local enemy = create_enemy("virus", i*(32 + 20) + 150, 80)
  --enemy.x = i * (enemy.width + 30) + 100
  --enemy.y = enemy.height + 100
  table.insert(enemies, enemy)
end  
    
for i=0,10 do
  local enemy = create_enemy("virus", i*(32 + 40) + 100, 132)
  --enemy.x = i * (enemy.width + 30) + 100
  --enemy.y = enemy.height + 100
  table.insert(enemies, enemy)
end
    
for i=0,10 do
  local enemy = create_enemy("bacteria", i*(32 + 40) + 100, 202)
  table.insert(enemies, enemy)
end 