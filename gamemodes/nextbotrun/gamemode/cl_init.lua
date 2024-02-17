include("shared.lua")

net.Receive("client_chat_print", function(len, ply)
    chat.AddText(net.ReadString())
end)
