* Check SAF options menu
* Make oUF_NotRaidDebuffs work better with charges
    * cf line 188 -->s check for maxcharges, too
    * Rework to handle UnitAura payload

* Transition own libs to the new UnitAura payload

* Fix oUF_Hanks AltPower

* Integrate all into SanUI: oUF_GCD, oUF_Hank,

* Castbar
    * Player: Fix  PIPs
    * Target: Show if not interruptible etc

* Powerbar
    * Color change for chicken (see Modeswitch/powerbar.lua) needs to be checked
    * What's update_surge doing, do we still need this?

* /sanui buffs does not work anymore
