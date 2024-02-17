AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("nextbots.lua")

util.AddNetworkString("client_chat_print")
function ClientChatPrint(message)
    net.Start("client_chat_print", true)
    net.WriteString(message)
    net.Broadcast()
end

function GM:OnReloaded()
    RemoveNextbots()
end

function GM:PreCleanupMap()
    RemoveNextbots()
end

hook.Add("PlayerInitialSpawn", "NbrNotifyEmptyList", function()
    if #NextbotList == 0 then
        ClientChatPrint([[Looks like the gamemode was not properly set up. 
        If you're the owner of this server, check the data 
        folder for nbr_nextbots.json and add bots in there.]])
    end
end)

function GM:PlayerLoadout(ply)
    ply:Give(GetConVar("nbr_defaultweapon"):GetString())
end

function GM:Think()
    if #NextbotList == 0 then return end -- if user hasn't filled out the file, don't do anything
    if #player.GetHumans() != 0 then
        if (#SpawnedNextbots < GetConVar("nbr_maxbots"):GetInt()) and (#player.GetHumans() + GetConVar("nbr_botoverflow"):GetInt() > #SpawnedNextbots) then
            SpawnNextbot(player.GetHumans()[math.random(#player.GetHumans())])
            ClientChatPrint("A new enemy has appeared ...")
        end
    else
        RemoveNextbots()
    end
end

hook.Add("PlayerSay", "NbrChatCommands", function(ply, text)
    local command = string.Explode(" ", text)
    if command[1] == "!help" then
        ClientChatPrint("!count - how much nextbots are on the map right now.\n" .. "!suicide - use this if you're stuck.")
    elseif command[1] == "!count" then
        ClientChatPrint("There are " .. #SpawnedNextbots .. " nextbots on the map.")
    elseif command[1] == "!suicide" then
        ply:Kill()
        return false
    elseif command[1] == "!reset" then
        if ply:IsAdmin() then RemoveNextbots() end
    end
end)
