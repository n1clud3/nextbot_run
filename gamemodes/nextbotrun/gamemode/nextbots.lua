if not file.Exists("nbr_nextbots.json", "DATA") then file.Write("nbr_nextbots.json", "[]") end

availableNextbots = util.JSONToTable(file.Read("nbr_nextbots.json"))
local nextbotSelector = math.random(#availableNextbots)
spawnedNextbots = {}

function SpawnNextbot()
    availableNextbots = util.JSONToTable(file.Read("nbr_nextbots.json"))
    local nextbot = availableNextbots[nextbotSelector]
    if nextbotSelector == #availableNextbots then
        nextbotSelector = 1
    else
        nextbotSelector = nextbotSelector + 1
    end
    print("Going to create "..nextbot)
    local ent = ents.Create(nextbot)
    local randomspawn = ents.FindByClass("info_player_start")[math.random(#ents.FindByClass("info_player_start"))]:GetPos()
    ent:SetPos(randomspawn)
    ent:Spawn()
    table.insert(spawnedNextbots, ent:GetClass())
end

function RemoveNextbots()
    if #spawnedNextbots == 0 then return end -- if there are no nextbots, don't do anything
    for a,bot in ipairs(spawnedNextbots) do -- iterate through table of bots 
        for b,ent in ipairs(ents.FindByClass(bot)) do
            ent:Remove()
        end
    end
    spawnedNextbots = {} -- empty nextbot table
    print("Despawned all nextbots.")
end