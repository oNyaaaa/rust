ITEMS:RegisterItem("SalavedClever", {
    Name = "Salvaged Cleaver",
    Info = "Killing, Havesting",
    InfoTag = "SalavedClever",
    Category = "Weapons",
    model = "materials/items/weapons/salvaged_cleaver.png",
    Weapon = "rust_salvagedcleaver",
    Count = 1,
    Stackable = true,
    StackSize = 1,
    Craft = function()
        return {
            {
                Time = 0,
                CanCraft = false,
                {
                    ITEM = "Metal",
                    AMOUNT = 50,
                },
            },
        }
    end,
}, "Weapons")

ITEMS:RegisterItem("SalavedSword", {
    Name = "Salvaged Sword",
    Info = "Killing, Havesting",
    InfoTag = "SalavedSword",
    Category = "Weapons",
    model = "materials/items/weapons/salvaged_sword.png",
    Weapon = "rust_salvagedsword",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("WoodenSpear", {
    Name = "Wooden Spear",
    Info = "Killing, Havesting",
    InfoTag = "WoodenSpear",
    Category = "Weapons",
    model = "materials/items/weapons/wooden_spear.png",
    Weapon = "rust_woodenspear",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("StoneSpear", {
    Name = "Stone Spear",
    Info = "Killing, Havesting",
    InfoTag = "StoneSpear",
    Category = "Weapons",
    model = "materials/items/weapons/stone_spear.png",
    Weapon = "rust_stonespear",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("AssaultRifle", {
    Name = "Assault Rifle",
    Info = "Killing/Defending",
    InfoTag = "AssaultRifle",
    Category = "Weapons",
    model = "materials/items/weapons/assault_rifle.png",
    Weapon = "rust_assaultrifle",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("M39Rifle", {
    Name = "M39 Rifle",
    Info = "Killing/Defending",
    InfoTag = "M39Rifle",
    Category = "Weapons",
    model = "materials/items/weapons/m39.png",
    Weapon = "rust_m39_rifle",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("RustM92", {
    Name = "M92 Pistol",
    Info = "Killing/Defending",
    InfoTag = "RustM92",
    Category = "Weapons",
    model = "materials/items/weapons/m92.png",
    Weapon = "rust_m92",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("RustM249", {
    Name = "M249",
    Info = "Killing/Defending",
    InfoTag = "RustM249",
    Category = "Weapons",
    model = "materials/items/weapons/m249.png",
    Weapon = "rust_m249",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("RustMP5", {
    Name = "MP5",
    Info = "Killing/Defending",
    InfoTag = "RustMP5",
    Category = "Weapons",
    model = "materials/items/weapons/mp5.png",
    Weapon = "rust_mp5",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("RustNailGun", {
    Name = "Nailgun",
    Info = "Killing/Defending",
    InfoTag = "RustNailGun",
    Category = "Weapons",
    model = "materials/items/weapons/nailgun.png",
    Weapon = "rust_nailgun",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("RustPython", {
    Name = "Python Revolver",
    Info = "Killing/Defending",
    InfoTag = "RustPython",
    Category = "Weapons",
    model = "materials/items/weapons/python.png",
    Weapon = "rust_python",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("RustRevolver", {
    Name = "Revolver",
    Info = "Killing/Defending",
    InfoTag = "RustRevolver",
    Category = "Weapons",
    model = "materials/items/weapons/revolver.png",
    Weapon = "rust_revolver",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("RustSap", {
    Name = "Semi-Automatic Pistol",
    Info = "Killing/Defending",
    InfoTag = "RustSap",
    Category = "Weapons",
    model = "materials/items/weapons/sap.png",
    Weapon = "rust_sap",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("RustSar", {
    Name = "Semi-Automatic Rifle",
    Info = "Killing/Defending",
    InfoTag = "RustSar",
    Category = "Weapons",
    model = "materials/items/weapons/sar.png",
    Weapon = "rust_sar",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("RustSMG", {
    Name = "Custom SMG",
    Info = "Killing/Defending",
    InfoTag = "RustSMG",
    Category = "Weapons",
    model = "materials/items/weapons/custom_smg.png",
    Weapon = "rust_smg",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("RustThompson", {
    Name = "Custom Thompson",
    Info = "Killing/Defending",
    InfoTag = "RustThompson",
    Category = "Weapons",
    model = "materials/items/weapons/thompson.png",
    Weapon = "rust_thompson",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("RustLR300", {
    Name = "LR-300 Assault Rifle",
    Info = "Killing/Defending",
    InfoTag = "RustLR300",
    Category = "Weapons",
    model = "materials/items/weapons/lr300.png",
    Weapon = "rust_lr300",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("RustCrossBow", {
    Name = "Crossbow",
    Info = "Killing/Defending",
    InfoTag = "RustCrossBow",
    Category = "Weapons",
    model = "materials/items/weapons/crossbow.png",
    Weapon = "rust_crossbow",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("RustHuntingBow", {
    Name = "Hunting Bow",
    Info = "Killing/Defending",
    InfoTag = "RustHuntingBow",
    Category = "Weapons",
    model = "materials/items/weapons/hunting_bow.png",
    Weapon = "rust_huntingbow",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("rust_boltrifle", {
    Name = "Bolt Action Rifle",
    Info = "Killing/Defending",
    Category = "Weapons",
    model = "materials/items/weapons/bolt_rifle.png",
    Weapon = "rust_boltrifle",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("rust_waterpipe", {
    Name = "Waterpipe Shotgun",
    Info = "Killing/Defending",
    Category = "Weapons",
    model = "materials/items/weapons/waterpipe.png",
    Weapon = "rust_waterpipe",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("rust_rpg", {
    Name = "Rocket Launcher",
    Info = "Killing/Defending",
    Category = "Weapons",
    model = "materials/items/weapons/rocket_launcher.png",
    Weapon = "rust_rpg",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("rust_dbarrel", {
    Name = "Double Barrel Shotgun",
    Info = "Killing/Defending",
    Category = "Weapons",
    model = "materials/items/weapons/dbarrel.png",
    Weapon = "rust_dbarrel",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("rust_pumpshotgun", {
    Name = "Pump Shotgun",
    Info = "Killing/Defending",
    Category = "Weapons",
    model = "materials/items/weapons/pump_shotgun.png",
    Weapon = "rust_pumpshotgun",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("rust_spas12", {
    Name = "Spas-12 Shotgun",
    Info = "Killing/Defending",
    Category = "Weapons",
    model = "materials/items/weapons/spas12.png",
    Weapon = "rust_spas12",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("rust_combatknife", {
    Name = "Combat Knife",
    Info = "Killing/Defending",
    Category = "Weapons",
    model = "materials/items/weapons/combat_knife.png",
    Weapon = "rust_combatknife",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")

ITEMS:RegisterItem("rust_grenadelauncher", {
    Name = "Multiple Grenade Launcher",
    Info = "Killing/Defending",
    Category = "Weapons",
    model = "materials/items/weapons/grenade_launcher.png",
    Weapon = "rust_grenadelauncher",
    Count = 1,
    Stackable = true,
    StackSize = 1,
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
}, "Weapons")