local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('flex-gangmenu:server:easy', function(id, gang)
    exports['ps-ui']:Circle(function(success)
        if success then
            QBCore.Functions.Progressbar("grab_money_safe", Lang:t('info.grabmoney'), 1000 * Config.TakeMoneyTime, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "anim@heists@ornate_bank@grab_cash",
                anim = "grab",
                flags = 49,
            }, {}, {}, function()
                TriggerServerEvent("flex-gangmenu:server:stealmoney", id, gang)
            end, function()
                TriggerServerEvent("flex-gangmenu:server:notifygang", gang)
            end)
        else
            TriggerServerEvent("flex-gangmenu:server:notifygang", gang)
        end
    end, 5, 20)
end)

RegisterNetEvent('flex-gangmenu:server:medium', function(id, gang)
    exports['ps-ui']:Maze(function(success)
        if success then
            QBCore.Functions.Progressbar("grab_money_safe", Lang:t('info.grabmoney'), 1000 * Config.TakeMoneyTime, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "anim@heists@ornate_bank@grab_cash",
                anim = "grab",
                flags = 49,
            }, {}, {}, function()
                TriggerServerEvent("flex-gangmenu:server:stealmoney", id, gang)
            end, function()
                TriggerServerEvent("flex-gangmenu:server:notifygang", gang)
            end)
        else
            TriggerServerEvent("flex-gangmenu:server:notifygang", gang)
        end
    end, 20)
end)

RegisterNetEvent('flex-gangmenu:server:hard', function(id, gang)
    exports['ps-ui']:VarHack(function(success)
        if success then
            QBCore.Functions.Progressbar("grab_money_safe", Lang:t('info.grabmoney'), 1000 * Config.TakeMoneyTime, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = "anim@heists@ornate_bank@grab_cash",
                anim = "grab",
                flags = 49,
            }, {}, {}, function()
                TriggerServerEvent("flex-gangmenu:server:stealmoney", id, gang)
            end, function()
                TriggerServerEvent("flex-gangmenu:server:notifygang", gang)
            end)
        else
            TriggerServerEvent("flex-gangmenu:server:notifygang", gang)
        end
     end, 22, 10)
end)

RegisterNetEvent('flex-gangmenu:server:guards', function(id, gang)
    if success then
        QBCore.Functions.Progressbar("grab_money_safe", Lang:t('info.grabmoney'), 1000 * Config.TakeMoneyTime, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@heists@ornate_bank@grab_cash",
            anim = "grab",
            flags = 49,
        }, {}, {}, function()
            TriggerServerEvent("flex-gangmenu:server:stealmoney", id, gang)
        end, function()
            TriggerServerEvent("flex-gangmenu:server:notifygang", gang)
        end)
    else
        TriggerServerEvent("flex-gangmenu:server:notifygang", gang)
    end
end)