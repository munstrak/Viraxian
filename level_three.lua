-- LEVEL THREE
enemies = {}
flying_enemies = {}

left_marigin = 70 
right_marigin = SCREEN_WIDTH - 134
bgm = love.audio.newSource("assets/music/Watroba.mp3", "stream")
bgm:setLooping(true)


for i=0,5 do
  local enemy = create_enemy("virus", i*(32 + 20) + 306, 52)
  table.insert(enemies, enemy)
end   

for i=0,7 do
  local enemy = create_enemy("virus", i*(32 + 20) + 254, 102)
  table.insert(enemies, enemy)
end   

for i=0,11 do
  local enemy = create_enemy("bacteria", i*(32 + 20) + 150, 162)
  table.insert(enemies, enemy)
end 

for i=0,9 do
  local enemy = create_enemy("bacteria", i*(32 + 20) + 202, 227)
  table.insert(enemies, enemy)
end

for i=0,7 do
  local enemy = create_enemy("bacteria", i*(32 + 20) + 254, 292)
  table.insert(enemies, enemy)
end   
