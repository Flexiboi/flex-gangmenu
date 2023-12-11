Config = {}
Config.Debug = true

Config.CanStealFromStash = true -- If other people can try and steal money from the safe

Config.Stashes = {
    [1] = {
        cost = 1000,
        slots = 10,
        weight = 1000
    },
    [2] = {
        cost = 2000,
        slots = 10,
        weight = 1000
    },
    [3] = {
        cost = 3000,
        slots = 10,
        weight = 1000
    },
}

Config.TakeMoneyTime = 10 -- seconds
Config.StealStress = math.random(1, 3)
Config.SecurityUpgrades = {
    [1] = {
        cost = 0, -- Amount it cost to buy
        info = 'Easy minigame', -- Info on upgrade page
        game = 'easy', -- name after 'flex-gangmenu:server:{thisname}' to trigger the minigame / event they need to complete
    },
    [2] = {
        cost = 1000, -- Amount it cost to buy
        info = 'Harder minigame', -- Info on upgrade page
        game = 'easy', -- name after 'flex-gangmenu:server:{thisname}' to trigger the minigame / event they need to complete
    },
    [3] = {
        cost = 3000, -- Amount it cost to buy
        info = 'Hardest minigame', -- Info on upgrade page
        game = 'medium', -- name after 'flex-gangmenu:server:{thisname}' to trigger the minigame / event they need to complete
    },
    [4] = {
        cost = 5000, -- Amount it cost to buy
        info = 'Guard spawn', -- Info on upgrade page
        game = 'hard', -- name after 'flex-gangmenu:server:{thisname}' to trigger the minigame / event they need to complete
    },
}

Config.MenuLocs = {
    [1] = {
        target = true, -- False player in out event
        gangname = 'ballas',
        location = vector3(440.5, -980.09, 30.89),
        heading = 2.73,
        stealminimum = math.random(100,300), -- this random amount times securitylv
    }
}