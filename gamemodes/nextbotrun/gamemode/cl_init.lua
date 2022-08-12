include("shared.lua")

function GM:OnSpawnMenuOpen()
    if LocalPlayer():IsAdmin() then
        g_SpawnMenu:Open()
    end
end