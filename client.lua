QBCore = exports['qb-core']:GetCoreObject()
local playerId = nil

exports['qb-target']:AddGlobalPlayer({
    options = {
        {
            type = "client",
            event = 'r3_robclothes:Rob',
            icon = "fas fa-cube",
            label = "Kiyafetleri Çal",
        },
    },
    distance = 3.0
})

local function ApplyClothes()
	local playerPed = PlayerPedId()
	if DoesEntityExist(playerPed) then
		Citizen.CreateThread(function()
			SetPedArmour(playerPed, 0)
			ClearPedBloodDamage(playerPed)
			ResetPedVisibleDamage(playerPed)
			ClearPedLastWeaponDamage(playerPed)
			ResetPedMovementClipset(playerPed, 0)
			local gender = QBCore.Functions.GetPlayerData().charinfo.gender
			if gender == 0 then
				TriggerEvent('qb-clothing:client:loadOutfit', Config.Uniforms.male)
			else
				TriggerEvent('qb-clothing:client:loadOutfit', Config.Uniforms.female)
			end
		end)
	end
end

RegisterNetEvent("r3_robclothes:Rob", function(entity)
    local player, distance = QBCore.Functions.GetClosestPlayer()
    playerId = GetPlayerServerId(player)
    TriggerServerEvent("r3_robclothes:Check", playerId)
end)

RegisterNetEvent("r3_robclothes:Wear", function()
    if playerId then
        exports['progressbar']:Progress({
            name = "robcloth",
            duration = 5000,
            label = "Kiyafetler Çalınıyor",
            useWhileDead = false,
            canCancel = true,
            controlDisables = {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,    
            },
            animation = {
                animDict = "mp_suicide",
                anim = "pill",
                flags = 49,
            },
            prop = {},
            propTwo = {}
        }, function(cancelled)
            if not cancelled then
                local playerIdx = GetPlayerFromServerId(playerId)
                local ped = GetPlayerPed(playerIdx)
                ClonePedToTarget(ped, PlayerPedId())
                playerId = nil
            end
        end) 
    else
        Wait(5200)
        ApplyClothes()
    end
end)