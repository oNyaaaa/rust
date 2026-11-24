ITEMS:RegisterItem("Turret", {
    Name = "Auto Turret",
    Info = "Auto Turret to kill enemies",
    InfoTag = "Turret",
    Category = "Electrical",
    model = "materials/items/deployable/auto_turret.png",
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
}, "Electrical")