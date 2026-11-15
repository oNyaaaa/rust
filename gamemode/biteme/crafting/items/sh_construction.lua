ITEMS:RegisterItem("ToolCupboard", {
    Name = "Tool Cupboard",
    Info = "For upkeep of the base!",
    InfoTag = "ToolCupboard",
    Category = "Construction",
    model = "materials/items/deployable/tool_cupboard.png",
    Weapon = "rust_deploy_tc",
    Count = 50,
    Stackable = true,
    StackSize = 1,
    IzAdmin = true,
    Craft = function()
        return {
            {
                Time = 0,
                CanCraft = false,
                {
                    ITEM = "Wood",
                    AMOUNT = 0,
                },
            },
        }
    end,
}, "Construction")

ITEMS:RegisterItem("WoodDeployDoor", {
    Name = "Wooden Door",
    Info = "Wooden Door For the door frame",
    InfoTag = "WoodDeployDoor",
    Category = "Construction",
    model = "materials/items/deployable/wooden_door.png",
    Weapon = "rust_deploy_door",
    Count = 50,
    Stackable = true,
    StackSize = 1,
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
}, "Construction")

ITEMS:RegisterItem("MetalDeployDoor", {
    Name = "Sheet Metal Door",
    Info = "Sheet Metal Door For the door frame",
    InfoTag = "MetalDeployDoor",
    Category = "Construction",
    model = "materials/items/deployable/metal_door.png",
    Weapon = nil,
    Count = 50,
    Stackable = true,
    StackSize = 1,
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
}, "Construction")

ITEMS:RegisterItem("ArmouredDeployDoor", {
    Name = "Armored Door",
    Info = "Armored Door For the door frame",
    InfoTag = "ArmouredDeployDoor",
    Category = "Construction",
    model = "materials/items/deployable/armored_door.png",
    Weapon = nil,
    Count = 50,
    Stackable = true,
    StackSize = 1,
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
}, "Construction")

ITEMS:RegisterItem("KeyLock", {
    Name = "Key Lock",
    Info = "Key locks used lock doors",
    InfoTag = "KeyLock",
    Category = "Construction",
    model = "materials/items/deployable/keylock.png",
    Weapon = nil,
    Count = 50,
    Stackable = true,
    StackSize = 1,
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
}, "Construction")

ITEMS:RegisterItem("KeyPad", {
    Name = "Keypad",
    Info = "Keypad used lock doors",
    InfoTag = "KeyPad",
    Category = "Construction",
    model = "materials/items/deployable/keypad.png",
    Weapon = "rust_deploy_codelock",
    Count = 50,
    Stackable = true,
    StackSize = 1,
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
}, "Construction")

ITEMS:RegisterItem("DoubleDoorWood", {
    Name = "Wood Double Door",
    Info = "Wood Double Door",
    InfoTag = "DoubleDoorWood",
    Category = "Construction",
    model = "materials/items/deployable/wood_double_door.png",
    Weapon = nil,
    Count = 50,
    Stackable = true,
    StackSize = 1,
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
}, "Construction")

ITEMS:RegisterItem("DoubleDoorMetal", {
    Name = "Sheet Metal Double Door",
    Info = "Sheet Metal Double Door",
    InfoTag = "DoubleDoorMetal",
    Category = "Construction",
    model = "materials/items/deployable/sheet_metal_double_door.png",
    Weapon = nil,
    Count = 50,
    Stackable = true,
    StackSize = 1,
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
}, "Construction")

ITEMS:RegisterItem("Arm_Double_Door", {
    Name = "Armored Double Door",
    Info = "Armored Double Door",
    InfoTag = "Arm_Double_Door",
    Category = "Construction",
    model = "materials/items/deployable/armored_double_door.png",
    Weapon = nil,
    Count = 50,
    Stackable = true,
    StackSize = 1,
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
}, "Construction")

ITEMS:RegisterItem("StoneBarricade", {
    Name = "Stone Barricade",
    Info = "Useful for pvp fights",
    InfoTag = "StoneBarricade",
    Category = "Construction",
    model = "materials/items/deployable/stone_barricade.png",
    Weapon = nil,
    Count = 50,
    Stackable = true,
    StackSize = 1,
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
}, "Construction")

ITEMS:RegisterItem("WoodBarricade", {
    Name = "Wooden Barricade Cover",
    Info = "Useful for pvp fights",
    InfoTag = "WoodBarricade",
    Category = "Construction",
    model = "materials/items/deployable/wooden_barricade.png",
    Weapon = nil,
    Count = 50,
    Stackable = true,
    StackSize = 1,
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
}, "Construction")

ITEMS:RegisterItem("RepairBench", {
    Name = "Repair Bench",
    Info = "Useful for repairing gears/weapons",
    InfoTag = "RepairBench",
    Category = "Construction",
    model = "materials/items/deployable/repair_bench.png",
    Weapon = nil,
    Count = 50,
    Stackable = true,
    StackSize = 1,
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
}, "Construction")

ITEMS:RegisterItem("RepairTable", {
    Name = "Repair Bench",
    Info = "Useful for researching stuff",
    InfoTag = "RepairTable",
    Category = "Construction",
    model = "materials/items/deployable/research_table.png",
    Weapon = nil,
    Count = 50,
    Stackable = true,
    StackSize = 1,
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
}, "Construction")

ITEMS:RegisterItem("SleepingBag", {
    Name = "Sleeping Bag",
    Info = "Spawn point",
    InfoTag = "SleepingBag",
    Category = "Construction",
    model = "materials/items/deployable/sleeping_bag.png",
    Weapon = nil,
    Count = 50,
    Stackable = true,
    StackSize = 1,
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
}, "Construction")

ITEMS:RegisterItem("Bed", {
    Name = "Bed",
    Info = "Spawn point",
    InfoTag = "Bed",
    Category = "Construction",
    model = "materials/items/deployable/bed.png",
    Weapon = nil,
    Count = 50,
    Stackable = true,
    StackSize = 1,
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
}, "Construction")

ITEMS:RegisterItem("WindowBars", {
    Name = "Wooden Window Bars",
    Info = "For windows",
    InfoTag = "WindowBars",
    Category = "Construction",
    model = "materials/items/deployable/wood_window_bars.png",
    Weapon = nil,
    Count = 50,
    Stackable = true,
    StackSize = 1,
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_glasswindow", {
    Name = "Reinforced Glass Window",
    Info = "For windows",
    Category = "Construction",
    model = "materials/items/deployable/reinforced_glass_window.png",
    Weapon = "rust_deploy_glasswindow",
    Count = 50,
    Stackable = true,
    StackSize = 150,
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_embrasureh", {
    Name = "Metal Horizontal Embrasure",
    Info = "For windows",
    Category = "Construction",
    model = "materials/items/deployable/metal_horizontal_embrasure.png",
    Weapon = "rust_deploy_embrasureh",
    Count = 50,
    Stackable = true,
    StackSize = 150,
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_v_embrasureh", {
    Name = "Metal Vertical Embrasure",
    Info = "For windows",
    Category = "Construction",
    model = "materials/items/deployable/metal_vertical_embrasure.png",
    Weapon = "rust_deploy_v_embrasureh",
    Count = 50,
    Stackable = true,
    StackSize = 150,
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
}, "Construction")

ITEMS:RegisterItem("rust_deploy_metal_sf", {
    Name = "Metal Shop Front",
    Info = "For windows",
    Category = "Construction",
    model = "materials/items/deployable/metal_shop_front.png",
    Weapon = "rust_deploy_metal_sf",
    Count = 50,
    Stackable = true,
    StackSize = 150,
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
}, "Construction")

ITEMS:RegisterItem("GarageDoor", {
    Name = "Garage Door",
    Info = "For door",
    InfoTag = "GarageDoor",
    Category = "Construction",
    model = "materials/items/deployable/garage_door.png",
    Weapon = nil,
    Count = 50,
    Stackable = true,
    StackSize = 1,
    IzAdmin = true,
    Craft = function()
        return {
            {
                Time = 0,
                CanCraft = false,
                {
                    ITEM = "MetalOre",
                    AMOUNT = 0,
                },
            },
        }
    end,
}, "Construction")