-- LEVEL TWO
enemies = {}
flying_enemies = {}

left_marigin = 70 
right_marigin = SCREEN_WIDTH - 134
bgm = love.audio.newSource("assets/music/Nos.mp3", "stream")
bgm:setLooping(true)

for i=0,7 do
  local enemy = create_enemy("bacteria", i*(32 + 20) + 254, 62)
  --enemy.x = i * (enemy.width + 30) + 100
  --enemy.y = enemy.height + 100
  table.insert(enemies, enemy)
end  
    
for i=0,9 do
  local enemy = create_enemy("bacteria", i*(32 + 20) + 202, 132)
  --enemy.x = i * (enemy.width + 30) + 100
  --enemy.y = enemy.height + 100
  table.insert(enemies, enemy)
end
    
for i=0,11 do
  local enemy = create_enemy("bacteria", i*(32 + 20) + 150, 202)
  table.insert(enemies, enemy)
end 