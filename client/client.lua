local QBCore = exports['qb-core']:GetCoreObject()
local MenuZones = {}
local TargetZones = {}
local PlayerData = {}
local PlayerGang = {}

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(100)
        CreateZones()
        PlayerData = QBCore.Functions.GetPlayerData()
        PlayerGang = PlayerData.gang
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Wait(100)
    CreateZones()
    PlayerData = QBCore.Functions.GetPlayerData()
    PlayerGang = PlayerData.gang
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(GangInfo)
    PlayerGang = GangInfo
end)

function CreateZones()
    for k, v in pairs(Config.MenuLocs) do
        if not v.target then
            MenuZones[#MenuZones + 1] = BoxZone:Create(v.location, 1.5, 1.5, {
                name = 'gangmenuzone' .. k,
                debugPoly = Config.Debug,
                heading = v.heading,
                minZ = v.location.z - 1,
                maxZ = v.location.z + 1,
            })

            MenuZones[#MenuZones]:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    exports['qb-core']:DrawText('[E] '..Lang:t("info.openmenu"), 'left')
                    if IsControlJustReleased(0, 38) or IsDisabledControlJustReleased(0, 38) then
                        exports['qb-core']:KeyPressed(38)
                        OpenGangMenu(k, v.gangname)
                    end
                else
                    exports['qb-core']:HideText()
                end
            end)
        else
            TargetZones[#TargetZones + 1] = exports['qb-target']:AddBoxZone('gangmenutarget' .. k, v.location, 0.5, 0.5, {
                name = 'gangmenutarget' .. k,
                heading = v.heading,
                debugPoly = Config.Debug,
                minZ = v.location.z - 0.3,
                maxZ = v.location.z + 0.3,
            }, {
                options = {
                    {
                        type = 'client',
                        icon = 'fa fa-clipboard',
                        label = Lang:t("info.openmenu"),
                        action = function()
                            OpenGangMenu(k, v.gangname)
                        end,
                    }
                },
                distance = 1.5
            })
        end
    end
end

function OpenGangMenu(id, gang)
    print('open')
    QBCore.Functions.TriggerCallback('flex-gangmenu:server:getinfo', function(info)
        if info then
            if PlayerGang.name == gang then
                SendNUIMessage({
                    type = 'open',
                    safeid = id,
                    username = info.firstname,
                    gang = info.gang,
                    isgangboss = info.isgangboss,
                    gangmembers = info.gangmembers,
                    cashbalance = info.cash,
                    safebalance = info.balance,
                    stashlv = info.stashlv,
                    stashupgrade = Config.Stashes[info.stashlv+1],
                    securitylv = info.securitylv,
                    securityupgrade = Config.SecurityUpgrades[info.securitylv+1],
                    transactions = info.transactions
                })
                SetNuiFocus(true, true)
            else
                if Config.CanStealFromStash then
                    StealMoney(info.securitylv, id, gang)
                else
                    QBCore.Functions.Notify(Lang:t('error.notingang'), 'error', 5000)
                end
            end
        end
    end, gang)
end

function StealMoney(lv, id, gang)
    TriggerEvent('flex-gangmenu:server:'..Config.SecurityUpgrades[lv].game, id, gang)
    TriggerServerEvent('hud:server:GainStress', Config.StealStress)
end

function updateGangMenu(id, gang)
    QBCore.Functions.TriggerCallback('flex-gangmenu:server:getinfo', function(info)
        if info then
            SendNUIMessage({
                type = 'update',
                safeid = id,
                username = info.firstname,
                gang = info.gang,
                isgangboss = info.isgangboss,
                gangmembers = info.gangmembers,
                cashbalance = info.cash,
                safebalance = info.balance,
                stashlv = info.stashlv,
                stashupgrade = Config.Stashes[info.stashlv+1],
                securitylv = info.securitylv,
                securityupgrade = Config.SecurityUpgrades[info.securitylv+1],
                transactions = info.transactions
            })
        end
    end, gang)
end

-- NUI
RegisterNUICallback('closeMenu', function(_, cb)
    SetNuiFocus(false)
end)

RegisterNUICallback('openStash', function(data, cb)
    TriggerServerEvent("inventory:server:OpenInventory", "stash", data.gang, { maxweight = Config.Stashes[data.stashlv].weight, slots = Config.Stashes[data.stashlv].slots, })
end)

RegisterNUICallback('kickMember', function(data, cb)
    TriggerServerEvent('flex-gangmenu:server:kickmember', data.cid)
    Wait(500)
    updateGangMenu(data.safeid, data.gang)
end)

RegisterNUICallback('promoteMember', function(data, cb)
    TriggerServerEvent('flex-gangmenu:server:promotemember', data.cid)
    Wait(500)
    updateGangMenu(data.safeid, data.gang)
end)

RegisterNUICallback('demoteMember', function(data, cb)
    TriggerServerEvent('flex-gangmenu:server:demotemembner', data.cid)
    Wait(500)
    updateGangMenu(data.safeid, data.gang)
end)

RegisterNUICallback('depositMoney', function(data, cb)
    TriggerServerEvent('flex-gangmenu:server:depositmoney', data.amount)
    Wait(500)
    updateGangMenu(data.safeid, data.gang)
end)

RegisterNUICallback('withdrawMoney', function(data, cb)
    TriggerServerEvent('flex-gangmenu:server:withdrawmoney', data.amount)
    Wait(500)
    updateGangMenu(data.safeid, data.gang)
end)

RegisterNUICallback('upgradeStash', function(data, cb)
    TriggerServerEvent('flex-gangmenu:server:upgradestash', data.gang, data.cost, data.lv)
    Wait(500)
    updateGangMenu(data.safeid, data.gang)
end)

RegisterNUICallback('upgradeAlarm', function(data, cb)
    TriggerServerEvent('flex-gangmenu:server:upgradealarm', data.gang, data.cost, data.lv)
    Wait(500)
    updateGangMenu(data.safeid, data.gang)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for k, v in pairs(MenuZones) do
            MenuZones[k]:destroy()
        end

        for k, v in pairs(TargetZones) do
            exports['qb-target']:RemoveZone('gangmenutarget'..k)
        end
    end
end)