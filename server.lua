QBCore = exports['qb-core']:GetCoreObject()
RegisterServerEvent("r3_robclothes:Check", function(id)
    local source = source
    local Player = QBCore.Functions.GetPlayer(id)
    if Player.PlayerData.metadata.isdead then
        TriggerClientEvent("r3_robclothes:Wear", source)
        TriggerClientEvent("r3_robclothes:Wear", id)
    end
end)