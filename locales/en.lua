local Translations = {
    succes = {
        withdraw = 'Withdrawn money from gangsafe',
        upgradestash = 'You upgraded your stash level!',
        upgradesecurity = 'You upgraded your security level!',
        stolemoney = 'You have stolen %{value}!'
    },
    error = {
        notingang = 'You are not in this gang!',
        cantkickself = 'You can not kick yourself..',
        cantpromoteself = 'You can not promote yourself..',
        cantdemoteself = 'You can not demote yourself..',
        notgangboss = 'You are not the boss here..',
        nomoney = 'There is not enough money available to upgrade..',
        stashmaxlv = 'You already have max lv!',
        securitymax = 'You already own max lv security!',
        safeempty = 'This safe seems empty..',
        aleredtgang = 'Oh no, the alarm went off..',
    },
    info = {
        openmenu = 'Open menu',
        deposit = 'Deposited to gangsafe',
        safebreached = 'Alarm from your safe is going off..',
        grabmoney = 'Grabbing money from safe..',
    },
    target = {

    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
