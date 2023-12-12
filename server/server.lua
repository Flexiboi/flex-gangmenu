local QBCore = exports['qb-core']:GetCoreObject()

function GetGangMembers(gang)
	local member = {}
	local players = MySQL.query.await("SELECT * FROM `players` WHERE `gang` LIKE '%" .. gang .. "%'", {})
	if players[1] ~= nil then
		for _, value in pairs(players) do
            member[#member + 1] = {
                cid = value.citizenid,
                grade = json.decode(value.gang).grade,
                name = json.decode(value.charinfo).firstname .. ' ' .. json.decode(value.charinfo).lastname
            }
		end
	end
	return member
end

function GetTransactions(gang)
	local transaction = {}
	local transactions = MySQL.query.await("SELECT * FROM `gangtransactions` WHERE `gang` LIKE '%" .. gang .. "%'", {})
	if transactions[1] ~= nil then
		for _, value in pairs(transactions) do
            local time = MySQL.query.await("SELECT DATE_FORMAT(`last_updated`, '%m/%d/%y, %h:%m:%s') FROM `gangtransactions` WHERE `id` LIKE '%" .. value.id .. "%'", {})
            transaction[#transaction + 1] = {
                id = value.id,
                amount = value.amount,
                name = value.name,
                type = value.type,
                time = time[1]["DATE_FORMAT(`last_updated`, '%m/%d/%y, %h:%m:%s')"]
            }
		end
	end
	return transaction
end

QBCore.Functions.CreateCallback('flex-gangmenu:server:getinfo', function(source, cb, gang)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerGang = QBCore.Functions.GetPlayer(source).PlayerData.gang
    local info = {}

    local result = MySQL.query.await('SELECT * FROM gangmenu WHERE gang = ?', { gang })
    if result[1] ~= nil then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.cash = Player.PlayerData.money['cash']
        info.gang = result[1].gang
        info.gangmembers = GetGangMembers(gang)
        info.balance = result[1].balance
        info.stashlv = result[1].stashlv
        info.securitylv = result[1].securitylv
        info.transactions = GetTransactions(gang)

        cb(info)
    else
        MySQL.Async.execute('INSERT INTO gangmenu (gang, balance, stashlv, securitylv) VALUES (?, ?, ?, ?)', { gang, 0, 1, 1 })

        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.cash = Player.PlayerData.money['cash']
        info.gang = gang
        info.balance = 0
        info.stashlv = 1
        info.securitylv = 1

        cb(info)
    end
end)

RegisterServerEvent("flex-gangmenu:server:kickmember", function(cid, id, gang)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerGang = QBCore.Functions.GetPlayer(source).PlayerData.gang

    if not PlayerGang.isboss then return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.notgangboss'), 'error') end

    if PlayerGang.isboss or Player.PlayerData.citizenid == cid then
        return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.cantkickself'), 'error')
    end

    local Target = QBCore.Functions.GetPlayerByCitizenId(cid)
    if target ~= nil then
        Target.Functions.SetGang('none', 0)
    end

    TriggerClientEvent('flex-gangmenu:client:updateGangMenu', src, id, gang)
end)

RegisterServerEvent("flex-gangmenu:server:promotemember", function(cid, id, gang)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerGang = QBCore.Functions.GetPlayer(source).PlayerData.gang

    if not PlayerGang.isboss then return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.notgangboss'), 'error') end

    if PlayerGang.isboss or Player.PlayerData.citizenid == cid then
        return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.cantpromoteself'), 'error')
    end

    local Target = QBCore.Functions.GetPlayerByCitizenId(cid)
    local TargetGang = QBCore.Functions.GetPlayer(source).PlayerData.gang
    if target ~= nil then
        Target.Functions.SetGang(TargetGang.name, TargetGang.level + 1)
    end

    TriggerClientEvent('flex-gangmenu:client:updateGangMenu', src, id, gang)
end)

RegisterServerEvent("flex-gangmenu:server:demotemembner", function(cid, id, gang)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerGang = QBCore.Functions.GetPlayer(source).PlayerData.gang

    if not PlayerGang.isboss then return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.notgangboss'), 'error') end

    if PlayerGang.isboss or Player.PlayerData.citizenid == cid then
        return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.cantdemoteself'), 'error')
    end

    local Target = QBCore.Functions.GetPlayerByCitizenId(cid)
    local TargetGang = QBCore.Functions.GetPlayer(source).PlayerData.gang
    if target ~= nil then
        Target.Functions.SetGang(TargetGang.name, TargetGang.level + 1)
    end

    TriggerClientEvent('flex-gangmenu:client:updateGangMenu', src, id, gang)
end)

RegisterServerEvent("flex-gangmenu:server:depositmoney", function(amount, id, gang)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerGang = QBCore.Functions.GetPlayer(source).PlayerData.gang
    if Player ~= nil and PlayerGang ~= nil then
        local result = MySQL.query.await('SELECT balance FROM gangmenu WHERE gang = ?', { PlayerGang.name })
        if result[1] then
            local newbalance = result[1].balance + amount
            if newbalance >= 0 then
                if Player.Functions.RemoveMoney("cash", amount, Lang:t("succes.withdraw")) then
                    MySQL.Async.execute('UPDATE gangmenu SET balance = ? WHERE gang = ?', {newbalance, PlayerGang.name})
                    MySQL.query.await('INSERT INTO gangtransactions (gang, name, type, amount) VALUES (?, ?, ?, ?)', { PlayerGang.name, Player.PlayerData.charinfo.firstname .. ' '..Player.PlayerData.charinfo.lastname, 'deposit', amount})
                end
            end
        end
        TriggerClientEvent('flex-gangmenu:client:updateGangMenu', src, id, PlayerGang.name)
    end
end)

RegisterServerEvent("flex-gangmenu:server:withdrawmoney", function(amount, id, gang)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerGang = QBCore.Functions.GetPlayer(source).PlayerData.gang
    if Player ~= nil and PlayerGang ~= nil then
        local result = MySQL.query.await('SELECT balance FROM gangmenu WHERE gang = ?', { PlayerGang.name })
        if result[1] then
            local newbalance = result[1].balance - amount
            if newbalance >= 0 then
                if Player.Functions.AddMoney("cash", amount, Lang:t("succes.withdraw")) then
                    MySQL.Async.execute('UPDATE gangmenu SET balance = ? WHERE gang = ?', {newbalance, PlayerGang.name})
                    MySQL.query.await('INSERT INTO gangtransactions (gang, name, type, amount) VALUES (?, ?, ?, ?)', { PlayerGang.name, Player.PlayerData.charinfo.firstname .. ' '..Player.PlayerData.charinfo.lastname, 'withdraw', amount})
                end
            end
        end
        TriggerClientEvent('flex-gangmenu:client:updateGangMenu', src, id, gang)
    end
end)

RegisterServerEvent("flex-gangmenu:server:upgradestash", function(gang, cost, lv, id)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerGang = QBCore.Functions.GetPlayer(source).PlayerData.gang

    if not PlayerGang.isboss then return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.notgangboss'), 'error') end

    local result = MySQL.query.await('SELECT * FROM gangmenu WHERE gang = ?', { gang })
    if result[1] then
        if result[1].balance >= cost then
            if #Config.Stashes > lv then
                local newbalance = result[1].balance - cost
                MySQL.Async.execute('UPDATE gangmenu SET balance = ? WHERE gang = ?', {newbalance, gang})
                MySQL.Async.execute('UPDATE gangmenu SET stashlv = ? WHERE gang = ?', {result[1].stashlv+1, gang})
                TriggerClientEvent('QBCore:Notify', src, Lang:t("succes.upgradestash"), 'error')
            else
                TriggerClientEvent('QBCore:Notify', src, Lang:t("error.stashmaxlv"), 'error')
            end
        elseif Player.Functions.RemoveMoney("cash", amount, Lang:t("succes.upgradestash")) then
            if #Config.Stashes > lv then
                MySQL.Async.execute('UPDATE gangmenu SET stashlv = ? WHERE gang = ?', {result[1].stashlv+1, gang})
                TriggerClientEvent('QBCore:Notify', src, Lang:t("succes.upgradestash"), 'error')
            else
                TriggerClientEvent('QBCore:Notify', src, Lang:t("error.stashmaxlv"), 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.nomoney"), 'error')
        end
        TriggerClientEvent('flex-gangmenu:client:updateGangMenu', src, id, gang)
    end
end)

RegisterServerEvent("flex-gangmenu:server:upgradealarm", function(gang, cost, lv, id)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local PlayerGang = QBCore.Functions.GetPlayer(source).PlayerData.gang
    
    if not PlayerGang.isboss then return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.notgangboss'), 'error') end

    local result = MySQL.query.await('SELECT * FROM gangmenu WHERE gang = ?', { gang })
    if result[1] then
        if result[1].balance >= cost then
            if #Config.SecurityUpgrades > lv then
                local newbalance = result[1].balance - cost
                MySQL.Async.execute('UPDATE gangmenu SET balance = ? WHERE gang = ?', {newbalance, gang})
                MySQL.Async.execute('UPDATE gangmenu SET securitylv = ? WHERE gang = ?', {result[1].securitylv+1, gang})
                TriggerClientEvent('QBCore:Notify', src, Lang:t("succes.upgradesecurity"), 'error')
            else
                TriggerClientEvent('QBCore:Notify', src, Lang:t("error.securitymax"), 'error')
            end
        elseif Player.Functions.RemoveMoney("cash", cost, Lang:t("succes.upgradesecurity")) then
            if #Config.SecurityUpgrades > lv then
                MySQL.Async.execute('UPDATE gangmenu SET securitylv = ? WHERE gang = ?', {result[1].securitylv+1, gang})
                TriggerClientEvent('QBCore:Notify', src, Lang:t("succes.upgradesecurity"), 'error')
            else
                TriggerClientEvent('QBCore:Notify', src, Lang:t("error.securitymax"), 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.nomoney"), 'error')
        end
        TriggerClientEvent('flex-gangmenu:client:updateGangMenu', src, id, gang)
    end
end)

RegisterServerEvent("flex-gangmenu:server:stealmoney", function(id, gang)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    TriggerClientEvent('QBCore:Notify', src, Lang:t("succes.aleredtgang", {}), 'error')

    local result = MySQL.query.await('SELECT * FROM gangmenu WHERE gang = ?', { gang })
    if result[1] then
        local amount = Config.MenuLocs[id].stealminimum * result[1].securitylv
        if result[1].balance >= amount then
            if Player.Functions.AddMoney("cash", amount, Lang:t("succes.stolemoney")) then
                local newbalance = result[1].balance - amount
                MySQL.Async.execute('UPDATE gangmenu SET balance = ? WHERE gang = ?', {newbalance, gang})
                MySQL.query.await('INSERT INTO gangtransactions (gang, name, type, amount) VALUES (?, ?, ?, ?)', { gang, 'Anonymouse', 'withdraw', amount})
                TriggerClientEvent('QBCore:Notify', src, Lang:t("succes.stolemoney", { value = amount }), 'error')
            end
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.safeempty"), 'error')
        end
    end
end)

RegisterServerEvent("flex-gangmenu:server:notifygang", function(gang)
    local members = GetGangMembers(gang)
    for _, value in pairs(members) do
        local Player = QBCore.Functions.GetPlayerByCitizenId(value.cid)
        TriggerClientEvent('QBCore:Notify', Player.PlayerData.source, Lang:t("info.safebreached"), 'error')
    end
end)