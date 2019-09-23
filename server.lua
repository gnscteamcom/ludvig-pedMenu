local auths = {}

ESX.RegisterServerCallback('ludvig-pedmenu:addPedMenu', function(source, cb, args)

    if inArray(auths, args) then
        table.remove(auths, args[1])
        return false
    else
        table.insert(auths, args[1])
        return true
    end
end)

ESX.RegisterServerCallback('ludvig-pedmenu:checkAccess', function(source, cb, args)

    if inArray(auths, args) then
        return false
    else
        return true
    end
end)

--returns TRUE if value contains, else FALSE
local inArray = function(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end