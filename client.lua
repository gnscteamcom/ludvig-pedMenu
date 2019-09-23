ESX = nil

local group = nil
Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(1)
    end

    while ESX.GetPlayerData() == nil do
        Citizen.Wait(10)
    end

    PlayerData = ESX.GetPlayerData()
end) 

RegisterNetEvent('es_admin:setGroup')
AddEventHandler('es_admin:setGroup', function(g)
	group = g
end)


--menyn som ska öppnas
local openPedMenu = function() 
    local elements = {}

    table.insert(elements, {label = "Return to default outfit", value = "return"})
    table.insert(elements, {label = "Choose a ped", value = "choose"})

    ESX.UI.Menu.CloseAll()
    
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'pedMenu',
        {
            title    = 'Would you like to return or choose a new ped?',
            align    = 'right',
            elements = elements,
        },
        function(data, menu)
            menu.close()
            
            if data.current.value == "return" then

                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                    local player

                    if skin.sex == 0 then
                        player = `mp_m_freemode_01`
                    else
                        player = `mp_f_freemode_01`
                    end

                    RequestModel(player)
                    while not HasModelLoaded(player) do
                        Wait(1)
                    end

                    SetPlayerModel(PlayerId(), player)
                    TriggerEvent('skinchanger:loadSkin', skin)

                end)
            elseif data.current.value == "choose" then
                openPedChooseMenu()
            end
            end,
            function(data, menu)
                menu.close()
            end
        )
end

local openPedChooseMenu = function() 

    ESX.UI.Menu.CloseAll()
        ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'choosePedMenu',
	{
        title    = 'What ped would you like to select?',
    }, function(data, menu)
            menu.close()
            local ped = GetHashKey(data.value)

            if data.value ~= nil and IsModelValid(ped) then
                SetPlayerModel(PlayerId(), ped)
            else
                ESX.ShowNotification("Please write any valid ped.")
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

RegisterCommand('PedAction', function(source, args)

    if group ~= "user" then
        TriggerServerCallback('ludvig-pedmenu:addPedMenu', function(access)
            if access then
                ESX.ShowNotification("Player added to access the menu. Please send the same message again to remove the permission.") 
            else
                ESX.ShowNotification("Player denied to access the menu. Please send the same message again to add permission again.") 
            end
        end, args[1])
    end
end)


RegisterCommand('OpenPedMenu', function(source)
    
    if group ~= "user" then
        TriggerServerCallback('ludvig-pedmenu:checkAccess', function(access)
            if access then
                ESX.ShowNotification("Menu opened.") 
            else
                ESX.ShowNotification("You are denied to access the menu. Please contact an administrator.") 
            end
        end, args[1])
    end
end)