if not file.Exists("nbr_nextbots.json", "DATA") then file.Write("nbr_nextbots.json", "[]") end

NextbotList = util.JSONToTable(file.Read("nbr_nextbots.json"))
local nextbotSelector = math.random(#NextbotList)
SpawnedNextbots = {}

local function findRandomSpot()
    local random_spawn = Vector(math.Rand(-16000, 16000), math.Rand(-16000, 16000), math.Rand(-16000, 16000))
    local nav_areas = navmesh.Find(random_spawn, 16000, 16000, 16000)

    if #nav_areas > 0 then
        --PrintTable(nav_areas)
        local random_spot = nav_areas[1]:GetCenter()
        --print(random_spot)

        return random_spot
    else
        return findRandomSpot()
    end
end

function SpawnNextbot()
    NextbotList = util.JSONToTable(file.Read("nbr_nextbots.json"))
    local nextbot = NextbotList[nextbotSelector]
    if nextbotSelector == #NextbotList then
        nextbotSelector = 1
    else
        nextbotSelector = nextbotSelector + 1
    end
    print("Going to create " .. nextbot)
    local ent = ents.Create(nextbot)

    ent:SetPos(findRandomSpot())
    ent:Spawn()
    table.insert(SpawnedNextbots, ent)
end

function RemoveNextbots()
    if #SpawnedNextbots == 0 then return end -- if there are no nextbots, don't do anything
    for a,bot in ipairs(SpawnedNextbots) do -- iterate through table of bots 
        bot:Remove()
        SpawnedNextbots[a] = nil -- empty nextbot
    end
    print("Despawned all nextbots.")
end