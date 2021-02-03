ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("craftSystem")
AddEventHandler("craftSystem", function(i, j)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    local noCount = false
    local TotalWant = 0
    local PlayerWant = 0
    if xPlayer ~= nil then
        for l=1, #Config.Places[i].Items[j].requ, 1 do
            TotalWant =  TotalWant + Config.Places[i].Items[j].requ[l].count
            PlayerWant = PlayerWant + xPlayer.getInventoryItem(Config.Places[i].Items[j].requ[l].name).count
            if xPlayer.getInventoryItem(Config.Places[i].Items[j].requ[l].name).count <= Config.Places[i].Items[j].requ[l].count - 1 then
                noCount = true
            end
        end
        if noCount == false then
            for l=1, #Config.Places[i].Items[j].requ, 1 do
                xPlayer.removeInventoryItem(Config.Places[i].Items[j].requ[l].name, Config.Places[i].Items[j].requ[l].count)
            end
            Citizen.Wait(10)
            xPlayer.addInventoryItem(Config.Places[i].Items[j].name, Config.Places[i].Items[j].count)
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =  tostring(Config.Places[i].Items[j].count)..'adet'..Config.Places[i].Items[j].label..'Ürettin'})
        else
            TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text =  tostring(TotalWant - PlayerWant) ..' adet daha malzeme lazım'})
        end
    end
end)

ESX.RegisterServerCallback('craft:getMoney', function(source, cb, money)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
    if xPlayer ~= nil then
        if xPlayer.getInventoryItem('cash').count >= money then
            xPlayer.removeInventoryItem('cash', money)
            cb(true)
        else
            cb(false)
        end
    end
end)
