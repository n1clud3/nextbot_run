AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("nextbots.lua")

function GM:OnReloaded()
    RemoveNextbots()
end

function GM:PreCleanupMap()
    RemoveNextbots()
end

hook.Add("PlayerInitialSpawn", "NbrNotifyEmptyList", function()
    if #availableNextbots == 0 then
        PrintMessage(HUD_PRINTTALK, "Looks like the gamemode was not properly set up. If you're the owner of this server, check the data folder for nbr_nextbots.json and add bots in there.")
    end
end)

function GM:PlayerLoadout(ply)
    ply:Give(GetConVar("nbr_defaultweapon"):GetString())
end

function GM:Think()
    if #availableNextbots == 0 then return end -- if user hasn't filled out the file, don't do anything
    if #player.GetHumans() != 0 then
        if #spawnedNextbots < GetConVar("nbr_maxbots"):GetInt() then
            if #player.GetHumans() + 2 > #spawnedNextbots then
                SpawnNextbot(player.GetHumans()[math.random(#player.GetHumans())])
                PrintMessage(HUD_PRINTTALK, "A new nextbot has arrived...")
            end
        end
    else
        RemoveNextbots()
    end
end

hook.Add("PlayerSay", "NbrChatCommands", function(ply, text)
    local command = string.Explode(" ", text)
    if command[1] == "!help" then
        PrintMessage(HUD_PRINTTALK, "!count - how much nextbots are on the map right now.\n".."!suicide - use this if you're stuck.")
    elseif command[1] == "!count" then
        PrintMessage(HUD_PRINTTALK, "There are "..#spawnedNextbots.." nextbots on the map.")
    elseif command[1] == "!suicide" then
        ply:Kill()
    elseif command[1] == "!reset" then
        if ply:IsAdmin() then RemoveNextbots() end
    end
end)
