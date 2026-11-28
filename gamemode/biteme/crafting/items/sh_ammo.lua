ITEMS:RegisterItem("Ammo_556", {
    Name = "556 Ammo",
    Info = "For bandages etc",
    Category = "AMMO",
    InfoTag = "Ammo_556",
    model = "materials/items/ammo/rifle_ammo.png",
    Weapon = "",
    Count = 50,
    Stackable = true,
    StackSize = 128,
    IzAdmin = true,
    Craft = function()
        return {
            {
                Time = 0,
                CanCraft = false,
                {
                    ITEM = "Cloth",
                    AMOUNT = 0,
                },
            },
        }
    end,
}, "AMMO")

game.AddAmmoType({
    name = "Ammo_556", -- Note that whenever picked up, the localization string will be '#BULLET_PLAYER_556MM_ammo'
    dmgtype = DMG_BULLET,
    tracer = TRACER_LINE,
    plydmg = 0, -- This can either be a number or a ConVar name.
    npcdmg = 0, -- Ditto.
    force = 2000,
    maxcarry = 120, -- Ditto.
    minsplash = 10,
    maxsplash = 5
})
