GM.Name = "Nextbot Run"
GM.Author = "n1clude"

DeriveGamemode("base")

include("sh_enums.lua")
AddCSLuaFile("sh_enums.lua")

function GM:Initialize()
    -- Remove concommands that allow players to spawn props, sweps etc.
    -- concommand.Remove("gm_spawn")
    -- concommand.Remove("gm_spawnsent")
    -- concommand.Remove("gm_spawnswep")
    -- concommand.Remove("gm_spawnvehicle")
    -- concommand.Remove("gm_giveswep")
end
