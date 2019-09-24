ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local auths = {}

ESX.RegisterServerCallback('ludvig-pedmenu:addPedMenu', function(source, cb, args)

    print(inArray(auths, args))
    if inArray(auths, args) then
        table.remove(auths, tonumber(args))
        cb(false)
    else
        table.insert(auths, args)
        cb(true)
    end
end)

ESX.RegisterServerCallback('ludvig-pedmenu:checkAccess', function(source, cb)
    local src = ESX.GetPlayerFromId(source)

    if inArray(auths, src.identifier) then
        cb(true)
    else
        cb(false)
    end
end)

--returns TRUE if value contains, else FALSE
function inArray(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end
