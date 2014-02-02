-- LEVEL FIVE
enemies = {}
flying_enemies = {}

left_marigin = 70 
right_marigin = SCREEN_WIDTH - 134
bgm = love.audio.newSource("assets/music/Mozg.mp3", "stream")
bgm:setLooping(true)


for i=0,1 do
  local enemy = create_enemy("prion", i*(32 + 20) + 414, 52, false, i+1)
  table.insert(enemies, enemy)
end   


for i=0,5 do
  if i == 1 or i == 2 then
    local enemy = create_enemy("virus", i*(32 + 20) + 308, 102, true, 1)
    table.insert(enemies, enemy)
  elseif i == 3 or i == 4 then
    local enemy = create_enemy("virus", i*(32 + 20) + 308, 102, true, 2)
    table.insert(enemies, enemy)
  else
    local enemy = create_enemy("virus", i*(32 + 20) + 308, 102)
    table.insert(enemies, enemy)
  end
end   

for i=0,7 do
  local enemy = create_enemy("virus", i*(32 + 20) + 254, 152)
  table.insert(enemies, enemy)
end   

for i=0,11 do
  local enemy = create_enemy("bacteria", i*(32 + 20) + 150, 212)
  table.insert(enemies, enemy)
end 

for i=0,7 do
  local enemy = create_enemy("bacteria", i*(32 + 20) + 254, 277)
  table.insert(enemies, enemy)
end   


for i=0,5 do
  local enemy = create_enemy("bacteria", i*(32 + 20) + 308, 342)
  table.insert(enemies, enemy)
end   

for i=0,3 do
  local enemy = create_enemy("bacteria", i*(32 + 20) + 362, 407)
  table.insert(enemies, enemy)
end
