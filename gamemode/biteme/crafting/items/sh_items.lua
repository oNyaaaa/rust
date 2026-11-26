ITEMS:RegisterItem("Furnace", {
    Name = "Furnace",
    Info = "Furnace!",
    Category = "Items",
    InfoTag = "Furnace",
    model = "materials/items/deployable/furnace.png",
    Weapon = nil,
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 1,
                {
                    ITEM = "Stone",
                    AMOUNT = 0,
                },
                {
                    ITEM = "LowGradeFueld",
                    AMOUNT = 0,
                },
            },
        }
    end,
}, "Items")

ITEMS:RegisterItem("SmallOilRifinary", {
    Name = "Small Oil Refinery",
    Info = "Small Oil Refinery refine lowgrade fuel!",
    InfoTag = "SmallOilRifinary",
    Category = "Items",
    model = "materials/items/deployable/small_oil_refinery.png",
    Weapon = "rust_deploy_smalloil",
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Stone",
                    AMOUNT = 250,
                },
                {
                    ITEM = "LowGradeFueld",
                    AMOUNT = 150,
                },
            },
        }
    end,
}, "Items")

ITEMS:RegisterItem("LargeBox", {
    Name = "Large Wood Box",
    Info = "Storage",
    InfoTag = "LargeBox",
    Category = "Items",
    model = "materials/items/deployable/large_wood_box.png",
    Weapon = nil,
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Stone",
                    AMOUNT = 250,
                },
                {
                    ITEM = "Low Grade Fuel",
                    AMOUNT = 150,
                },
            },
        }
    end,
}, "Items")

ITEMS:RegisterItem("WoodSmallBox", {
    Name = "Wood Storage Box",
    Info = "Storage",
    InfoTag = "WoodSmallBox",
    Category = "Items",
    model = "materials/items/deployable/wood_box.png",
    Weapon = "rust_deploy_woodsmallbox",
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Stone",
                    AMOUNT = 250,
                },
                {
                    ITEM = "Low Grade Fuel",
                    AMOUNT = 150,
                },
            },
        }
    end,
}, "Items")

ITEMS:RegisterItem("WorkBench1", {
    Name = "Workbench Level 1",
    Info = "Craft advanced items and blueprints",
    InfoTag = "WorkBench1",
    Category = "Items",
    model = "materials/items/deployable/workbench_tier1.png",
    Weapon = nil,
    Count = 1,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Wood",
                    AMOUNT = 500,
                },
                {
                    ITEM = "MetalFragments",
                    AMOUNT = 100,
                },
                {
                    ITEM = "Scrap",
                    AMOUNT = 50,
                },
            },
        }
    end,
}, "Items")

ITEMS:RegisterItem("WorkBench2", {
    Name = "Workbench Level 2",
    Info = "Unlocking tiers 2 etc",
    InfoTag = "WorkBench2",
    Category = "Items",
    model = "materials/items/deployable/workbench_tier2.png",
    Weapon = "rust_deploy_workbenchlvl2",
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
}, "Items")

ITEMS:RegisterItem("WorkBench3", {
    Name = "Workbench Level 3",
    Info = "Unlocking tiers 3 etc",
    InfoTag = "WorkBench3",
    Category = "Items",
    model = "materials/items/deployable/workbench_tier3.png",
    Weapon = "rust_deploy_workbenchlvl3",
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
}, "Items")

ITEMS:RegisterItem("rust_deploy_rust_vendingmachine", {
    Name = "Vending Machine",
    Info = "Buy stuff",
    Category = "Items",
    model = "materials/items/deployable/vending_machine.png",
    Weapon = "rust_deploy_rust_vendingmachine",
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
}, "Items")

ITEMS:RegisterItem("rust_deploy_rust_chair", {
    Name = "Chair",
    Info = "Sit feel comf",
    Category = "Items",
    model = "materials/items/deployable/chair.png",
    Weapon = "rust_deploy_rust_chair",
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
}, "Items")


