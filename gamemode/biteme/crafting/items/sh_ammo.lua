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

ITEMS:RegisterItem("Ammo_Pistol", {
    Name = "Pistol Ammo",
    Info = "For bandages etc",
    Category = "AMMO",
    InfoTag = "Ammo_Pistol",
    model = "materials/items/ammo/pistol_bullet.png",
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
    name = "Ammo_Pistol", -- Note that whenever picked up, the localization string will be '#BULLET_PLAYER_556MM_ammo'
    dmgtype = DMG_BULLET,
    tracer = TRACER_LINE,
    plydmg = 0, -- This can either be a number or a ConVar name.
    npcdmg = 0, -- Ditto.
    force = 2000,
    maxcarry = 120, -- Ditto.
    minsplash = 10,
    maxsplash = 5
})

ITEMS:RegisterItem("Ammo_Nails", {
    Name = "NailGun Ammo",
    Info = "For bandages etc",
    Category = "AMMO",
    InfoTag = "Ammo_Nails",
    model = "materials/items/ammo/nailgun_nails.png",
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
    name = "Ammo_Nails", -- Note that whenever picked up, the localization string will be '#BULLET_PLAYER_556MM_ammo'
    dmgtype = DMG_BULLET,
    tracer = TRACER_LINE,
    plydmg = 0, -- This can either be a number or a ConVar name.
    npcdmg = 0, -- Ditto.
    force = 2000,
    maxcarry = 120, -- Ditto.
    minsplash = 10,
    maxsplash = 5
})

ITEMS:RegisterItem("Ammo_Arrow", {
    Name = "Arrow Ammo",
    Info = "For bandages etc",
    Category = "AMMO",
    InfoTag = "Ammo_Arrow",
    model = "materials/entities/arrow.wooden.png",
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
    name = "Ammo_Arrow", -- Note that whenever picked up, the localization string will be '#BULLET_PLAYER_556MM_ammo'
    dmgtype = DMG_BULLET,
    tracer = TRACER_LINE,
    plydmg = 0, -- This can either be a number or a ConVar name.
    npcdmg = 0, -- Ditto.
    force = 2000,
    maxcarry = 120, -- Ditto.
    minsplash = 10,
    maxsplash = 5
})