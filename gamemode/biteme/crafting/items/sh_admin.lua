ITEMS:RegisterItem("Cloth", {
    Name = "Cloth",
    Info = "For bandages etc",
    Category = "ADMIN",
    InfoTag = "Cloth",
    model = "materials/items/resources/cloth.png",
    Weapon = "",
    Count = 50,
    Stackable = true,
    StackSize = 500,
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
}, "ADMIN")

ITEMS:RegisterItem("AnimalFat", {
    Name = "Animal Fat",
    Info = "For bandages etc",
    InfoTag = "AnimalFat",
    Category = "ADMIN",
    model = "materials/items/resources/animal_fat.png",
    Weapon = "",
    Count = 50,
    Stackable = true,
    StackSize = 200,
    IzAdmin = true,
    Craft = function()
        return {
            {
                Time = 0,
                CanCraft = false,
                {
                    ITEM = "AnimalFat",
                    AMOUNT = 0,
                },
            },
        }
    end,
}, "ADMIN")

ITEMS:RegisterItem("Wood", {
    Name = "Wood",
    Info = "For upgrading your base!",
    InfoTag = "Wood",
    Category = "ADMIN",
    model = "materials/items/resources/wood.png",
    Weapon = "",
    Count = 50,
    Stackable = true,
    StackSize = 2000,
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
}, "ADMIN")

ITEMS:RegisterItem("Metal", {
    Name = "Metal Fragments",
    Info = "For Pickaxes etc",
    InfoTag = "Metal",
    Category = "ADMIN",
    model = "materials/items/resources/metal_fragments.png",
    Weapon = "",
    Count = 50,
    Stackable = true,
    StackSize = 2000,
    IzAdmin = true,
    Craft = function()
        return {
            {
                Time = 0,
                CanCraft = false,
                {
                    ITEM = "Metal",
                    AMOUNT = 0,
                },
            },
        }
    end,
}, "ADMIN")

ITEMS:RegisterItem("HQMetal", {
    Name = "HQ Metal",
    Info = "HQ Metal",
    InfoTag = "HQMetal",
    Category = "ADMIN",
    model = "materials/items/resources/hqmetal.png",
    Weapon = "",
    Count = 50,
    Stackable = true,
    StackSize = 2000,
    IzAdmin = true,
    Craft = function()
        return {
            {
                Time = 0,
                CanCraft = false,
                {
                    ITEM = "HQMetal",
                    AMOUNT = 0,
                },
            },
        }
    end,
}, "ADMIN")

ITEMS:RegisterItem("HQMetal", {
    Name = "HQ Metal",
    Info = "HQ Metal",
    InfoTag = "HQMetal",
    Category = "ADMIN",
    model = "materials/items/resources/hqmetal.png",
    Weapon = "",
    Count = 50,
    Stackable = true,
    StackSize = 2000,
    IzAdmin = true,
    Craft = function()
        return {
            {
                Time = 0,
                CanCraft = false,
                {
                    ITEM = "HQMetal",
                    AMOUNT = 0,
                },
            },
        }
    end,
}, "ADMIN")

ITEMS:RegisterItem("RoadSign", {
    Name = "RoadSign",
    Info = "RoadSign",
    InfoTag = "RoadSign",
    Category = "ADMIN",
    model = "materials/items/resources/road_signs.png",
    Weapon = "",
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
                    ITEM = "HQMetal",
                    AMOUNT = 0,
                },
            },
        }
    end,
}, "ADMIN")

ITEMS:RegisterItem("MetalPipe", {
    Name = "MetalPipe",
    Info = "MetalPipe",
    InfoTag = "MetalPipe",
    Category = "ADMIN",
    model = "materials/items/resources/metal_pipe.png",
    Weapon = "",
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
                    ITEM = "HQMetal",
                    AMOUNT = 0,
                },
            },
        }
    end,
}, "ADMIN")