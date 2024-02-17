GM.Name = "Nextbot Run"
GM.Author = "n1clude"

DeriveGamemode("base")

function GM:Initialize()
    -- Remove concommands that allow players to spawn props, sweps etc.
    -- concommand.Remove("gm_spawn")
    -- concommand.Remove("gm_spawnsent")
    -- concommand.Remove("gm_spawnswep")
    -- concommand.Remove("gm_spawnvehicle")
    -- concommand.Remove("gm_giveswep")
end
