# flex-gangmenu
# A qb based NUI gang menu

<strong>PREVIEW:</strong> https://streamable.com/ui1pxx

</br>

# WHAT IS IT?
</br>
A custom made gang menu for the qb framework!
</br>
</br>
Setup each safe location for each gang in the config.
</br>
Each gang member can acces the safe to diposit and see who is in the gang.
</br>
The gangleader can kick, promote, demote and upgrade.
</br>
Each safe is protected by a minigame that gets triggerd when people try to steal money (amount set in config and times the level of security) set in config.
</br>
I have made all colors ez changeable in css.
</br>
</br>
<strong>Upgrades include:</strong>
</br>
- Better security
</br>
- More storage
</br>
(You can define each stuff like cost or add more in the config.)
</br>
</br>

# HOW TO EDIT MINIGAMES
</br>
You can edit or make your own minigames that are triggerd when someone tries to steal money.
</br>
Edit the minigames in <strong>minigames.lua</strong>
</br>
On fail it sends a notify to all the gang members.

</br>
</br>

# SETUP
</br>
Add the sql file to your database.
</br>
Setup each gang / location in the config (Auto added to the config if the gang uses it for first time).
</br>
Setup each upgrade.
</br>
Edit the minigames to your liking.
</br>
Enjoy!
</br>
</br>

# DEPENDENCIES
</br>
- qb-core
</br>
- sql script
</br>
- ps-ui (or changes minigames)
</br>
</br>
</br>
# TODO
</br>
- Add a check if gang members are online
</br>
- Suggestions?
