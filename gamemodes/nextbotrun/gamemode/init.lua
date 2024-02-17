AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("nextbots.lua")
include("sv_chat.lua")

DEFINE_BASECLASS("gamemode_base")

function GM:OnReloaded()
    RemoveNextbots()
end

function GM:PreCleanupMap()
    RemoveNextbots()
end

hook.Add("PlayerInitialSpawn", "NbrNotifyEmptyList", function()
    if #NextbotList == 0 then
        ClientChatBroadcast([[Looks like the gamemode was not properly set up. 
        If you're the owner of this server, check the data 
        folder for nbr_nextbots.json and add bots in there.]])
    end
end)

function GM:PlayerLoadout(ply)
    ply:Give(GetConVar("nbr_defaultweapon"):GetString())
end

function GM:PlayerSpawn(ply, tr)
    player_manager.SetPlayerClass(ply, "player_default")

    BaseClass.PlayerSpawn(self, ply, tr)
end

function GM:PlayerSetModel(ply)
    BaseClass.PlayerSetModel(self, ply)
end

function GM:Think()
    if #NextbotList == 0 then return end -- if user hasn't filled out the file, don't do anything
    if #player.GetHumans() != 0 then
        if (#SpawnedNextbots < GetConVar("nbr_maxbots"):GetInt()) and (#player.GetHumans() + GetConVar("nbr_botoverflow"):GetInt() > #SpawnedNextbots) then
            local bot_id = SpawnNextbot(player.GetHumans()[math.random(#player.GetHumans())])
            ClientChatBroadcast("A new enemy " .. Entity(bot_id):GetClass() .. " has appeared ...", NBR_COLOR_SERVERMSG)
            ClientAdminChatBroadcast("Entity ID: " .. bot_id, NBR_COLOR_SERVERMSG)
        end
    else
        RemoveNextbots()
    end
end

hook.Add("PlayerSay", "NbrChatCommands", function(ply, text)
    local command = string.Explode(" ", text)
    if command[1] == "!help" then
        ClientChatPrint(ply, "[ NEXTBOT RUN HELP ]", Color(255, 80, 40))
        ClientChatPrint(ply, "!count - how much nextbots are on the map right now.", NBR_COLOR_CLIENTGRAY)
        ClientChatPrint(ply, "!suicide - unalive yourself. Use if you're stuck.", NBR_COLOR_CLIENTGRAY)
        if ply:IsAdmin() then
            ClientChatPrint(ply, "[ HELP for admins ]", Color(255, 80, 40))
            ClientChatPrint(ply, "!reset - remove all nextbots currently roaming the map.", NBR_COLOR_CLIENTGRAY)
            ClientChatPrint(ply, "!removebot [ent_id] - remove bot with specified entity ID. Useful for removing \"Ignoring unreasonable position\" bots.", NBR_COLOR_CLIENTGRAY)
        end
        return false
    elseif command[1] == "!count" then
        ClientChatPrint(ply, "There are " .. #SpawnedNextbots .. " nextbots on the map.")
        return false
    elseif command[1] == "!suicide" then
        ply:Kill()
        ClientChatPrint("You we're too weak for this place ...")
        return false
    elseif command[1] == "!reset" then
        if ply:IsAdmin() then RemoveNextbots() end
        ClientChatBroadcast("Nextbots were removed.", NBR_COLOR_SERVERMSG)
        return false
    elseif command[1] == "!removebot" then
        if ply:IsAdmin() then
            local ent_id = tonumber(command[2])
            if ent_id == nil then
                ClientChatPrint(ply, "[!removebot] Incorrect entity ID.", Color(255, 40, 40))
                return false
            end
            local ent = Entity(ent_id)
            if ent:IsPlayer() then
                ClientChatPrint(ply, "[!removebot] Cannot remove a player!", Color(255, 40, 40))
                return false
            end
            ent:Remove()
            for a, bot in ipairs(SpawnedNextbots) do -- Remove entity from the list
                if bot == ent_id then
                    SpawnedNextbots[a] = nil
                end
            end
            ClientChatPrint(ply, "[!removebot] Bot was removed.", NBR_COLOR_CLIENTGRAY)
        end

        return false
    end
end)
