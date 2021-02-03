ESX                             = nil
local PlayerData                = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
	if Config.NPCEnable == true then
    	for _,v in pairs(Config.NPC) do
    	 	RequestModel(GetHashKey(v[7]))
    	 	while not HasModelLoaded(GetHashKey(v[7])) do
    	 	  Wait(1)
    	 	end
    	 	RequestAnimDict(v[8])
    	 	while not HasAnimDictLoaded(v[8]) do
    	 	  Wait(1)
    	 	end
    	 	ped =  CreatePed(4, v[6],v[1],v[2],v[3], 3374176, false, true)
    	 	SetEntityHeading(ped, v[5])
    	 	FreezeEntityPosition(ped, true)
    	 	SetEntityInvincible(ped, true)
    	 	SetBlockingOfNonTemporaryEvents(ped, true)
    	 	TaskPlayAnim(ped,v[8],v[9], 8.0, 0.0, -1, 1, 0, 0, 0, 0)
    	end
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(14)
    while true do
        Citizen.Wait(0)
        if Config.NPCEnable == true then
            local pos = GetEntityCoords(GetPlayerPed(-1), true)
            for _,v in pairs(Config.NPC) do
            	Citizen.Wait(0)
                if v[10] ~= 'all' then
                    if ESX.PlayerData ~= nil then
                        if ESX.PlayerData.job.name ~= nil and ESX.PlayerData.job.name == v[10] then
                            x = v[1]
                            y = v[2]
                            z = v[3]
                            if v[4] ~= false then
                                if(Vdist(pos.x, pos.y, pos.z, x, y, z) < Config.Range)then
                                    DrawText3D(x,y,z+2.10, v[4], 1.2, 1)
                                end
                            end
                        end
                    end
                else
                    x = v[1]
                    y = v[2]
                    z = v[3]
                    if v[4] ~= false then
                        if(Vdist(pos.x, pos.y, pos.z, x, y, z) < Config.Range)then
                            DrawText3D(x,y,z+2.10, v[4], 1.2, 1)
                        end
                    end
                end
            end
        end
    end
end)

function Craft(i)
	elements		= {
		 {label = 'Menü Kapat',   value = 'kapat'},
	}
	for j=1, #Config.Places[i].Items, 1 do
		table.insert(elements, {
			label = Config.Places[i].Items[j].label,
			value = j,
		})
	end
	
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'apcraft', {
        title    = Config.Places[i].title,
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'kapat' then
            menu.close()
        else
            menu.close()
        	TriggerServerEvent('craftSystem', i,  data.current.value)
        end
        menu.close()    
    end)
end

function Uni()
    elements        = {
         {label = 'Menü Kapat',   value = 'kapat'},
         {label = 'Silahı Tamir Et',   value = 'repair'},
         {label = 'Seri Numarası Sildir',   value = 'serial'},
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'repasr', {
        title    = 'Tamirci',
        align    = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'kapat' then
            menu.close()
        elseif data.current.value == 'repair' then
            ESX.TriggerServerCallback('craft:getMoney', function(result)
                if result then
                    exports["np-taskbar"]:taskBar(5000,"Silah Tamir Ediliyor")
                    TriggerEvent('disc-inventoryhud:repairhand', 20)
                    exports['mythic_notify']:SendAlert('error', 'Al Hayırlı Olsun!', 2500)
                else
                    exports['mythic_notify']:SendAlert('error', 'Beleşe bu devirde hayırdır', 2500)
                end
            end, 1000)    
        elseif data.current.value == 'serial' then
            ESX.TriggerServerCallback('craft:getMoney', function(result)
                print(result)
                if result then
                    exports["np-taskbar"]:taskBar(5000,"Silah Serisi Siliniyor")
                    TriggerEvent('disc-inventoryhud:deleteSerial')
                    exports['mythic_notify']:SendAlert('error', 'Al Hayırlı Olsun!', 2500)
                else
                    exports['mythic_notify']:SendAlert('error', 'Beleşe bu devirde hayırdır', 2500)
                end
            end, 5000)    
        else
            menu.close()
        end
        menu.close()    
    end)
end

Citizen.CreateThread(function()
    while true do
    	Citizen.Wait(5)
        if IsControlJustReleased(1, 51) then
            local pos = GetEntityCoords(GetPlayerPed(-1), true)
		    for k,v in pairs(Config.Places) do
		    	Citizen.Wait(0)
		  	    if v.job ~= 'all' then
		  		    if ESX.PlayerData ~= nil then
		  			    if ESX.PlayerData.job.name ~= nil and ESX.PlayerData.job.name == v.job then
            				if GetDistanceBetweenCoords(pos, v.coord.x, v.coord.y, v.coord.z, true) < Config.Range then
            				  	Craft(k)               
            				end
            			else
                            if GetDistanceBetweenCoords(pos, v.coord.x, v.coord.y, v.coord.z, true) < Config.Range then
            				     exports['mythic_notify']:DoHudText('inform', 'Sen kimsin ?')
                            end
            			end
            		end
            	else
            		if GetDistanceBetweenCoords(pos, v.coord.x, v.coord.y, v.coord.z, true) < Config.Range then
            		  	Craft(k)                
            		end
            	end
            end
            if Config.Repair then
            	for j,l in pairs(Config.RepairZones) do
    				Citizen.Wait(0)
            		local dist = GetDistanceBetweenCoords(pos, l.coord.x, l.coord.y, l.coord.z, true)
    	    		if dist <= Config.Range then
    	    			if l.job ~= 'all' then
    	    			    if ESX.PlayerData ~= nil then
    	    			        if ESX.PlayerData.job.name ~= nil and ESX.PlayerData.job.name == l.job then
                                    Uni()           
    	    			        else
    	    			            exports['mythic_notify']:DoHudText('inform', 'Sen kimsin ?')
    	    			        end
    	    			    end
    	    			else
                            Uni()    
    	    			end
    	    		end
    	    	end
    	    end
        end
    end
end)

--[[ ]]
-- RegisterCommand('silahkir', function()
--     TriggerEvent('disc-inventoryhud:repairhand', -9)
-- end)


function DrawText3D(x,y,z, text, scl, font) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(font)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextDropShadow()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
