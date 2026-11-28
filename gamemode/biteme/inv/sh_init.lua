RustOfficial = RustOfficial or {}
RustOfficial.GhostGD = {}
RustOfficial.GhostGD.GhostModel = ""
if SERVER then
    util.AddNetworkString("SendClientinfoGDL")
    util.AddNetworkString("GarageDoorPlaceL")
    util.AddNetworkString("GInventory")
    util.AddNetworkString("SendDatagRust")
    net.Receive("SendDatagRust", function(len, ply)
        net.Start("GInventory")
        net.WriteTable(ply.GInv)
        net.Send(ply)
    end)

    local IDS = {
        ["rust_furnace"] = "Furnace",
        ["sent_garagedoor"] = "GarageDoor",
        ["sent_door_dd_metal"] = "DoubleDoorMetal",
        ["sent_door_dd_wood"] = "DoubleDoorWood",
        ["sent_door_dd_hq"] = "Arm_Double_Door",
        ["rust_tc"] = "ToolCupboard",
        ["sent_door"] = "WoodDeployDoor",
        ["sent_metal_door"] = "MetalDeployDoor",
        ["sent_arm_door"] = "ArmouredDeployDoor",
        ["rust_keylock"] = "KeyLock",
        ["rust_keypad"] = "KeyPad",
        ["sent_stonebarricade"] = "StoneBarricade",
        ["sent_woodbarricade"] = "WoodBarricade",
        ["sent_repairtable"] = "RepairTable",
        ["sent_repairbench"] = "RepairBench",
        ["sent_sleepingbag"] = "SleepingBag",
        ["sent_bed"] = "Bed",
        ["sent_windowbars"] = "WindowBars",
        ["sent_windowglass"] = "WindowGlass",
        ["sent_embrasureh"] = "Embrasureh",
        ["sent_vembrasureh"] = "vEmbrasureh",
        ["sent_shopfront"] = "ShopFront",
        ["sent_auto_turret"] = "Turret",
        ["rust_largebox"] = "LargeBox",
        ["rust_smallbox"] = "WoodSmallBox",
        ["rust_workbench_1"] = "WorkBench1",
        ["rust_workbench_2"] = "WorkBench2",
        ["rust_workbench_3"] = "WorkBench3",
    }

    net.Receive("GarageDoorPlaceL", function(len, ply)
        if ply.CanBuild then return end
        local bang = net.ReadString()
        local pos, ang, name = DEPLOY:GetSocket(ply, bang)
        if name ~= "doorwayl" and IDS[bang] == "GarageDoor" then return end
        if name ~= "doorwayl" and IDS[bang] == "ShopFront" then return end
        if name ~= "doorwayl" and IDS[bang] == "DoubleDoorMetal" then return end
        if name ~= "doorwayl" and IDS[bang] == "DoubleDoorWood" then return end
        if name ~= "doorwayl" and IDS[bang] == "Arm_Double_Door" then return end
        if name ~= "sent_foundation" and IDS[bang] == "ToolCupboard" then return end
        DEPLOY:SetSocket(ply, bang, pos, ang)
        GInv_RemoveItem(ply, IDS[bang], 1)
        SendInv(ply)
    end)
end

RustOfficial.ITEMS = {
    Rock = {
        name = "Rock",
        color = Color(200, 60, 60),
        image = "materials/items/tools/rock.png",
        func = function(ply) ply:Give("rust_rock") end,
        weapon = "rust_rock",
        Max = 1,
        wModel = "models/weapons/darky_m/rust/w_rock.mdl",
        Craftable = true,
        BluePrint = false,
    },
    RoadSign = {
        name = "RoadSign",
        color = Color(200, 60, 60),
        image = "materials/items/resources/road_signs.png",
        func = function(ply) end,
        weapon = nil,
        Max = 100,
        wModel = "models/items/roadsigns.mdl",
        Craftable = true,
        BluePrint = false,
    },
    MetalPipe = {
        name = "MetalPipe",
        color = Color(200, 60, 60),
        image = "materials/items/resources/metal_pipe.png",
        func = function(ply) end,
        weapon = nil,
        Max = 100,
        wModel = "models/items/metalpipe.mdl",
        Craftable = true,
        BluePrint = false,
    },
    Charcoal = {
        name = "Charcoal",
        color = Color(200, 60, 60),
        image = "materials/items/resources/charcoal.png",
        func = function(ply) end,
        weapon = nil,
        Max = 2000,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    Sulfur = {
        name = "Sulfur",
        color = Color(200, 60, 60),
        image = "materials/items/resources/sulfur.png",
        func = function(ply) end,
        weapon = nil,
        Max = 2000,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    Metal = {
        name = "Metal Fragments",
        color = Color(200, 60, 60),
        image = "materials/items/resources/metal_fragments.png",
        func = function(ply) end,
        weapon = nil,
        Max = 2000,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = false,
        BluePrint = false,
    },
    Hammer = {
        name = "Hammer",
        color = Color(200, 60, 60),
        image = "materials/items/tools/hammer.png",
        func = function(ply) ply:Give("rust_hammer") end,
        weapon = "rust_hammer",
        Max = 1,
        wModel = "models/weapons/darky_m/rust/w_hammer.mdl",
        Craftable = true,
        BluePrint = false,
    },
    GarageDoor = {
        name = "Garage Door",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/garage_door.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_garagedoor")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = true,
    },
    WindowGlass = {
        name = "Reinforced Window Glass",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/reinforced_glass_window.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_windowglass")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = true,
    },
    ShopFront = {
        name = "Metal Shop Front",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/metal_shop_front.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_shopfront")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = true,
    },
    vEmbrasureh = {
        name = "Metal Vertical Embrasure",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/metal_horizontal_embrasure.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_vembrasureh")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = true,
    },
    Embrasureh = {
        name = "Metal Horizontal Embrasure",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/metal_horizontal_embrasure.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_embrasureh")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = true,
    },
    StoneBarricade = {
        name = "Stone Barricade",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/stone_barricade.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_stonebarricade")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = true,
    },
    WoodBarricade = {
        name = "Wood Barricade",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/wooden_barricade.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_woodbarricade")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = true,
    },
    WorkBench1 = {
        name = "WorkBench1",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/workbench_tier1.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("rust_workbench_1")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = true,
    },
    WorkBench2 = {
        name = "WorkBench2",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/workbench_tier2.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("rust_workbench_2")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = true,
    },
    WorkBench3 = {
        name = "WorkBench3",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/workbench_tier3.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("rust_workbench_3")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = true,
    },
    RepairBench = {
        name = "Repair Bench",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/repair_bench.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_repairbench")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = true,
    },
    RepairTable = {
        name = "Repair Table",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/research_table.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_repairtable")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = true,
    },
    SleepingBag = {
        name = "Sleeping Bag",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/sleeping_bag.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_sleepingbag")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = true,
    },
    Bed = {
        name = "Bed",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/bed.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_bed")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = true,
    },
    WindowBars = {
        name = "Wooden Window Bars",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/wood_window_bars.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_windowbars")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = true,
    },
    Builder = {
        name = "Building Plan",
        color = Color(200, 60, 60),
        image = "materials/items/misc/blueprint.png",
        func = function(ply) ply:Give("rust_builder") end,
        weapon = "rust_builder",
        Max = 1,
        wModel = "models/weapons/darky_m/rust/w_buildingplan.mdl",
        Craftable = true,
        BluePrint = false,
    },
    Wood = {
        name = "Wood",
        color = Color(200, 60, 60),
        image = "materials/items/resources/wood.png",
        func = function(ply) end,
        weapon = nil,
        Max = 2000,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = false,
        BluePrint = false,
    },
    Stone = {
        name = "Stone",
        color = Color(200, 60, 60),
        image = "materials/items/resources/stone.png",
        func = function(ply) end,
        weapon = nil,
        Max = 2000,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    SulfurOre = {
        name = "SulfurOre",
        color = Color(200, 60, 60),
        image = "materials/items/resources/sulfur_ore.png",
        func = function(ply) end,
        weapon = nil,
        Max = 2000,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    MetalOre = {
        name = "MetalOre",
        color = Color(200, 60, 60),
        image = "materials/items/resources/metal_ore.png",
        func = function(ply) end,
        weapon = nil,
        Max = 2000,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    HQMetal = {
        name = "HQMetal",
        color = Color(200, 60, 60),
        image = "materials/items/resources/hqmetal.png",
        func = function(ply) end,
        weapon = nil,
        Max = 2000,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    HQMetalOre = {
        name = "HQMetalOre",
        color = Color(200, 60, 60),
        image = "materials/items/resources/hqmetal_ore.png",
        func = function(ply) end,
        weapon = nil,
        Max = 2000,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    Furnace = {
        name = "Furnace",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/furnace.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("rust_furnace")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 2000,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    ToolCupboard = {
        name = "Tool Cupboard",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/tool_cupboard.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("rust_tc")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    WoodDeployDoor = {
        name = "Wood Door",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/wooden_door.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_door")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    MetalDeployDoor = {
        name = "Metal Door",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/metal_door.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_metal_door")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    Arm_Double_Door = {
        name = "Double Metal Door",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/armored_double_door.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_door_dd_hq")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    DoubleDoorMetal = {
        name = "Double Metal Door",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/sheet_metal_double_door.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_door_dd_metal")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    DoubleDoorWood = {
        name = "Double Metal Door",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/wood_double_door.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_door_dd_wood")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    ArmouredDeployDoor = {
        name = "Armoured Door",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/armored_door.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_arm_door")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    KeyLock = {
        name = "KeyLock",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/keylock.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("rust_keylock")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    KeyPad = {
        name = "KeyPad",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/keypad.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("rust_keypad")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    Turret = {
        name = "Turret",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/auto_turret.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("sent_auto_turret")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    SmallOilRifinary = {
        name = "SmallOilRifinary",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/small_oil_refinery.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("rust_oilrefinary")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    LargeBox = {
        name = "LargeBox",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/large_wood_box.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("rust_largebox")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    WoodSmallBox = {
        name = "WoodSmallBox",
        color = Color(200, 60, 60),
        image = "materials/items/deployable/wood_box.png",
        func = function(ply)
            if SERVER then
                ply.SelectedGarageDoor = nil
                net.Start("SendClientinfoGDL")
                net.WriteBool(true)
                net.WriteString("rust_smallbox")
                net.Send(ply)
            end
        end,
        weapon = nil,
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    LowGradeFueld = {
        name = "LowGradeFuel",
        color = Color(200, 60, 60),
        image = "materials/items/resources/low_grade_fuel.png",
        func = function(ply) end,
        weapon = nil,
        Max = 150,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    Crude = {
        name = "Crude",
        color = Color(200, 60, 60),
        image = "materials/items/resources/crude_oil.png",
        func = function(ply) end,
        weapon = nil,
        Max = 150,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    AnimalFat = {
        name = "Animal Fat",
        color = Color(200, 60, 60),
        image = "materials/items/resources/animal_fat.png",
        func = function(ply) end,
        weapon = nil,
        Max = 200,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    Cloth = {
        name = "Cloth",
        color = Color(200, 60, 60),
        image = "materials/items/resources/cloth.png",
        func = function(ply) end,
        weapon = nil,
        Max = 500,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    Ammo_556 = {
        name = "556 Ammo",
        color = Color(200, 60, 60),
        image = "materials/items/ammo/rifle_ammo.png",
        func = function(ply) end,
        weapon = nil,
        Max = 128,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    Ammo_Arrow = {
        name = "Arrow Ammo",
        color = Color(200, 60, 60),
        image = "materials/entities/arrow.wooden.png",
        func = function(ply) end,
        weapon = nil,
        Max = 128,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    Ammo_Nails = {
        name = "NailGun Ammo",
        color = Color(200, 60, 60),
        image = "materials/items/ammo/nailgun_nails.png",
        func = function(ply) end,
        weapon = nil,
        Max = 128,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    Ammo_Pistol = {
        name = "Pistol Ammo",
        color = Color(200, 60, 60),
        image = "materials/items/ammo/pistol_bullet.png",
        func = function(ply) end,
        weapon = nil,
        Max = 128,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    WoodenSpear = {
        name = "WoodenSpear",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/wooden_spear.png",
        func = function(ply) ply:Give("rust_woodenspear") end,
        weapon = "rust_woodenspear",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    StoneSpear = {
        name = "StoneSpear",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/stone_spear.png",
        func = function(ply) ply:Give("rust_stonespear") end,
        weapon = "rust_stonespear",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    SalavedSword = {
        name = "Salvaged Sword",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/salvaged_sword.png",
        func = function(ply) ply:Give("rust_salvagedsword") end,
        weapon = "rust_salvagedsword",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    SalavedClever = {
        name = "Salvaged Cleaver",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/salvaged_cleaver.png",
        func = function(ply) ply:Give("rust_salvagedcleaver") end,
        weapon = "rust_salvagedcleaver",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    StoneHatchet = {
        name = "StoneHatchet",
        color = Color(200, 60, 60),
        image = "materials/items/tools/stone_hatchet.png",
        func = function(ply) ply:Give("rust_stone_hatchet") end,
        weapon = "rust_stone_hatchet",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    StonePickaxe = {
        name = "StonePickaxe",
        color = Color(200, 60, 60),
        image = "materials/items/tools/stone_pickaxe.png",
        func = function(ply) ply:Give("rust_stone_pickaxe") end,
        weapon = "rust_stone_pickaxe",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    PickAxe = {
        name = "PickAxe",
        color = Color(200, 60, 60),
        image = "materials/items/tools/pickaxe.png",
        func = function(ply) ply:Give("rust_pickaxe") end,
        weapon = "rust_pickaxe",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    AssaultRifle = {
        name = "AssaultRifle",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/assault_rifle.png",
        func = function(ply, clips)
            ply:Give("rust_assaultrifle")
            ply:SelectWeapon("rust_assaultrifle")
        end,
        weapon = "rust_assaultrifle",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    M39Rifle = {
        name = "M39Rifle",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/m39.png",
        func = function(ply, clips)
            ply:Give("rust_m39_rifle")
            ply:SelectWeapon("rust_m39_rifle")
        end,
        weapon = "rust_m39_rifle",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    RustM92 = {
        name = "M92 Pistol",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/m92.png",
        func = function(ply, clips)
            ply:Give("rust_m92")
            ply:SelectWeapon("rust_m92")
        end,
        weapon = "rust_m92",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    RustM249 = {
        name = "RustM249",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/m249.png",
        func = function(ply, clips)
            ply:Give("rust_m249")
            ply:SelectWeapon("rust_m249")
        end,
        weapon = "rust_m249",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    RustMP5 = {
        name = "RustMP5",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/mp5.png",
        func = function(ply, clips)
            ply:Give("rust_mp5")
            ply:SelectWeapon("rust_mp5")
        end,
        weapon = "rust_mp5",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    RustNailGun = {
        name = "RustNailGun",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/nailgun.png",
        func = function(ply, clips)
            ply:Give("rust_nailgun")
            ply:SelectWeapon("rust_nailgun")
        end,
        weapon = "rust_nailgun",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    RustPython = {
        name = "Rust Python",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/python.png",
        func = function(ply, clips)
            ply:Give("rust_python")
            ply:SelectWeapon("rust_python")
        end,
        weapon = "rust_python",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    RustRevolver = {
        name = "Revolver",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/revolver.png",
        func = function(ply, clips)
            ply:Give("rust_revolver")
            ply:SelectWeapon("rust_revolver")
        end,
        weapon = "rust_revolver",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    RustSap = {
        name = "Semi-Automatic Pistol",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/sap.png",
        func = function(ply, clips)
            ply:Give("rust_sap")
            ply:SelectWeapon("rust_sap")
        end,
        weapon = "rust_sap",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    RustSar = {
        name = "Semi-Automatic Rifle",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/sar.png",
        func = function(ply, clips)
            ply:Give("rust_sar")
            ply:SelectWeapon("rust_sar")
        end,
        weapon = "rust_sar",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    RustSMG = {
        name = "Custom SMG",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/custom_smg.png",
        func = function(ply, clips)
            ply:Give("rust_smg")
            ply:SelectWeapon("rust_smg")
        end,
        weapon = "rust_smg",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    RustThompson = {
        name = "Custom Thompson",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/thompson.png",
        func = function(ply, clips)
            ply:Give("rust_thompson")
            ply:SelectWeapon("rust_thompson")
        end,
        weapon = "rust_thompson",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    RustLR300 = {
        name = "LR-300 Assault Rifle",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/lr300.png",
        func = function(ply, clips)
            ply:Give("rust_lr300")
            ply:SelectWeapon("rust_lr300")
        end,
        weapon = "rust_lr300",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    RustCrossBow = {
        name = "Crossbow",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/crossbow.png",
        func = function(ply, clips)
            ply:Give("rust_crossbow")
            ply:SelectWeapon("rust_crossbow")
        end,
        weapon = "rust_crossbow",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    RustHuntingBow = {
        name = "Hunting Bow",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/hunting_bow.png",
        func = function(ply, clips)
            ply:Give("rust_huntingbow")
            ply:SelectWeapon("rust_huntingbow")
        end,
        weapon = "rust_huntingbow",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
    RustBoltRifle = {
        name = "Bolt Action Rifle",
        color = Color(200, 60, 60),
        image = "materials/items/weapons/bolt_rifle.png",
        func = function(ply, clips)
            ply:Give("rust_boltrifle")
            ply:SelectWeapon("rust_boltrifle")
        end,
        weapon = "rust_boltrifle",
        Max = 1,
        wModel = "models/environment/misc/loot_bag.mdl",
        Craftable = true,
        BluePrint = false,
    },
}

function RustOfficial.GetItem(key)
    local items = RustOfficial.ITEMS -- adjust to your table name
    if items[key] then return items[key] end
    for id, def in pairs(items) do
        if def.name == key then return def, id end
    end
end

if CLIENT then
    local classes = ""
    net.Receive("SendClientinfoGDL", function()
        local ply = LocalPlayer()
        local bool = net.ReadBool()
        classes = net.ReadString()
        if IsValid(RustOfficial.GhostGD.Ghost) then RustOfficial.GhostGD.Ghost:Remove() end
        local function GetModelFor(class)
            local ent = scripted_ents.Get(class or "")
            if not ent then return end
            local m = ent.Model or ent.Models
            if istable(m) then m = m[1] end
            return isstring(m) and m or nil
        end

        local model = GetModelFor(classes)
        util.PrecacheModel(model)
        RustOfficial.GhostGD.Ghost = ClientsideModel(model)
        RustOfficial.GhostGD.GhostModel = model
        RustOfficial.GhostGD.Ghost:SetColor(Color(255, 255, 255, 120))
        ply.SelectedGarageDoor = true
    end)

    hook.Add("Think", "GarageDoor", function()
        local ply = LocalPlayer()
        if not RustOfficial.GhostGD then RustOfficial.GhostGD = {} end
        if not ply.CoolDownCDL then ply.CoolDownCD = 0 end
        if ply.SelectedGarageDoor and IsValid(RustOfficial.GhostGD.Ghost) then
            local pos, ang = DEPLOY:GetSocket(ply, classes)
            if not isvector(pos) or not isangle(ang) then return end
            RustOfficial.GhostGD.Ghost:SetPos(pos)
            RustOfficial.GhostGD.Ghost:SetAngles(ang)
            if ply:KeyDown(IN_ATTACK) and ply.CoolDownCD <= CurTime() then
                ply.SelectedGarageDoor = false
                net.Start("GarageDoorPlaceL")
                net.WriteString(classes)
                net.SendToServer()
                ply.CoolDownCD = CurTime() + 1
            end
        elseif ply.SelectedGarageDoor == false then
            if IsValid(RustOfficial.GhostGD.Ghost) then
                RustOfficial.GhostGD.Ghost:Remove()
                RustOfficial.GhostGD.Ghost = nil
            end
        end
    end)
end