ITEMS:RegisterItem("LowGradeFueld", {
    Name = "Low Grade Fuel",
    Info = "For syringes",
    InfoTag = "LowGradeFueld",
    Category = "Resources",
    model = "materials/items/resources/low_grade_fuel.png",
    Weapon = "",
    Count = 5,
    Stackable = true,
    StackSize = 150,
    IzAdmin = true,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "Cloth",
                    AMOUNT = 20,
                },
                {
                    ITEM = "AnimalFat",
                    AMOUNT = 30
                }
            },
        }
    end,
}, "Resources")

ITEMS:RegisterItem("Crude", {
    Name = "Crude Oil",
    Info = "For syringes",
    InfoTag = "Crude",
    Category = "ADMIN",
    model = "materials/items/resources/crude_oil.png",
    Weapon = "",
    Count = 5,
    Stackable = true,
    StackSize = 150,
    IzAdmin = true,
    Craft = function()
        return {
            {
                CanCraft = true,
                Time = 30,
                {
                    ITEM = "nothing",
                    AMOUNT = 0,
                },
            },
        }
    end,
}, "ADMIN")