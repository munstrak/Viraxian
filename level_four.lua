-- LEVEL FOUR
enemies = {}
flying_enemies = {}
flagships = {}

left_marigin = 70 
right_marigin = SCREEN_WIDTH - 134
bgm = love.audio.newSource("assets/music/Serce.mp3", "stream")
bgm:setLooping(true)

--[[
local enemy = create_enemy("prion", 306, 52, false, 1)
table.insert(enemies, enemy)
enemy = create_enemy("virus", 306, 102, true, 1)
table.insert(enemies, enemy)
enemy = create_enemy("virus", 356, 102, true, 1)
table.insert(enemies, enemy)

local enemy = create_enemy("prion", 406, 52, false, 2)
table.insert(enemies, enemy)
enemy = create_enemy("virus", 406, 102, true, 2)
table.insert(enemies, enemy)
enemy = create_enemy("virus", 456, 102, true, 2)
table.insert(enemies, enemy)
]]
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

for i=0,5 do
  local enemy = create_enemy("virus", i*(32 + 20) + 308, 154)
  table.insert(enemies, enemy)
end   

for i=0,7 do
  local enemy = create_enemy("bacteria", i*(32 + 20) + 254, 212)
  table.insert(enemies, enemy)
end 

for i=0,7 do
  local enemy = create_enemy("bacteria", i*(32 + 20) + 254, 277)
  table.insert(enemies, enemy)
end   

for i=0,7 do
  local enemy = create_enemy("bacteria", i*(32 + 20) + 254, 342)
  table.insert(enemies, enemy)
end   

for i=0,5 do
  local enemy = create_enemy("bacteria", i*(32 + 20) + 308, 407)
  table.insert(enemies, enemy)
end
