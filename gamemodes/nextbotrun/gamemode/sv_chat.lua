util.AddNetworkString("client_chat_broadcast")
function ClientChatBroadcast(message, color)
    color = color or Color(255, 255, 255)
    net.Start("client_chat_broadcast", true)
    net.WriteTable({message, color}, true)
    net.Broadcast()
end

util.AddNetworkString("client_chat_print")
function ClientChatPrint(ply, message, color)
    net.Start("client_chat_print", true)
    net.WriteTable({message, color}, true)
    net.Send(ply)
end

function ClientAdminChatBroadcast(message, color)
    color = color or Color(255, 255, 255)
    local players = player.GetAll()
    for _, ply in ipairs(players) do
        if ply:IsAdmin() then
            net.Start("client_chat_print", true)
            net.WriteTable({message, color}, true)
            net.Send(ply)
        end
    end
end