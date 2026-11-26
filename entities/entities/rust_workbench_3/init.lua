AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("Workbench_OpenUI")
util.AddNetworkString("Workbench_CloseUI")
util.AddNetworkString("Workbench_CraftItem")
util.AddNetworkString("Workbench_CraftComplete")

local WORKBENCH_HEALTH = 250
local WORKBENCH_CRAFT_SPEED = 1.0

function ENT:Initialize()
    self:SetModel(self.Model)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if IsValid(phys) then
        phys:Wake()
        phys:EnableMotion(false)
    end

    self:SetHealthz(WORKBENCH_HEALTH)
    self:SetMaxHealthz(WORKBENCH_HEALTH)
    self:SetIsOpen(false)
    self.CraftQueue = {}
    self.CurrentCraft = nil
    self.CraftStartTime = 0
    self.CraftEndTime = 0

    self:DropToFloor()
end

function ENT:SpawnFunction(ply, tr)
    if not tr.Hit then return end
    local ent = ents.Create("rust_workbench_1")
    ent:SetPos(tr.HitPos + tr.HitNormal * 16)
    ent:SetAngles(Angle(0, ply:EyeAngles().y + 180, 0))
    ent:Spawn()
    ent:Activate()
    ent:SetOwner(ply)
    return ent
end

function ENT:Use(activator, caller)
    if not IsValid(activator) or not activator:IsPlayer() then return end
    if self:GetIsOpen() and self:GetOwner() ~= activator then
        activator:ChatPrint("Workbench is in use by another player")
        return
    end

    self:SetIsOpen(true)
    self:SetOwner(activator)
    net.Start("Workbench_OpenUI")
    net.WriteEntity(self)
    net.Send(activator)
end

function ENT:OnRemove()
    if IsValid(self:GetOwner()) then
        net.Start("Workbench_CloseUI")
        net.WriteEntity(self)
        net.Send(self:GetOwner())
    end
end

function ENT:OnTakeDamage(dmg)
    self:SetHealthz(math.max(0, self:GetHealthz() - dmg:GetDamage()))
    if self:GetHealthz() <= 0 then
        self:Destroy()
    end
end

function ENT:Destroy()
    local effect = EffectData()
    effect:SetOrigin(self:GetPos())
    effect:SetScale(2)
    util.Effect("Explosion", effect)

    self:EmitSound("physics/metal/metal_box_break" .. math.random(1, 2) .. ".wav", 100, 100)
    self:Remove()
end

function ENT:CanCraft(ply, itemID)
    local item = RustOfficial.GetItem(itemID)
    if not item then return false, "Invalid item" end

    if item.Craft and type(item.Craft) == "function" then
        local craftData = item.Craft()
        if not craftData then return false, "No crafting recipe" end

        for _, category in ipairs(craftData) do
            if istable(category) then
                for _, req in ipairs(category) do
                    if istable(req) and req.ITEM and req.AMOUNT then
                        local has = 0
                        for _, inv in pairs(ply.GRustInventory or {}) do
                            if inv.Inventory and inv.Inventory.id == req.ITEM then
                                has = has + (inv.Inventory.Count or 0)
                            end
                        end
                        if has < req.AMOUNT then
                            return false, "Missing " .. req.ITEM .. " (" .. has .. "/" .. req.AMOUNT .. ")"
                        end
                    end
                end
            end
        end
    end

    return true, "OK"
end

function ENT:TakeMaterials(ply, itemID)
    local item = RustOfficial.GetItem(itemID)
    if not item or not item.Craft then return end

    local craftData = item.Craft()
    if not craftData then return end

    for _, category in ipairs(craftData) do
        if istable(category) then
            for _, req in ipairs(category) do
                if istable(req) and req.ITEM and req.AMOUNT then
                    local remaining = req.AMOUNT
                    for _, inv in pairs(ply.GRustInventory or {}) do
                        if remaining <= 0 then break end
                        if inv.Inventory and inv.Inventory.id == req.ITEM then
                            local take = math.min(remaining, inv.Inventory.Count or 0)
                            if take > 0 then
                                GInv_RemoveItem(ply, req.ITEM, take)
                                remaining = remaining - take
                            end
                        end
                    end
                end
            end
        end
    end
end

function ENT:StartCraft(ply, itemID)
    if self.CurrentCraft then return false, "Already crafting" end

    local canCraft, reason = self:CanCraft(ply, itemID)
    if not canCraft then return false, reason end

    local item = RustOfficial.GetItem(itemID)
    local craftData = item.Craft()
    local craftTime = 10

    if craftData and craftData[1] and craftData[1].Time then
        craftTime = craftData[1].Time / WORKBENCH_CRAFT_SPEED
    end

    self:TakeMaterials(ply, itemID)

    self.CurrentCraft = {
        itemID = itemID,
        owner = ply,
        startTime = CurTime(),
        endTime = CurTime() + craftTime,
        item = item
    }

    self:SetIsOpen(true)

    net.Start("Workbench_CraftItem")
    net.WriteEntity(self)
    net.WriteString(itemID)
    net.WriteFloat(craftTime)
    net.Send(ply)

    timer.Create("Workbench_Craft_" .. self:EntIndex(), craftTime, 1, function()
        if not IsValid(self) or not IsValid(ply) then return end
        self:FinishCraft(ply, itemID)
    end)

    return true, "Crafting started"
end

function ENT:FinishCraft(ply, itemID)
    if not IsValid(self) or not IsValid(ply) then return end
    if self.CurrentCraft and self.CurrentCraft.itemID ~= itemID then return end

    self.CurrentCraft = nil

    local item = RustOfficial.GetItem(itemID)
    if item and item.Weapon then
        AddItemsToGmodCount(ply, itemID, 1, nil, 30)
    else
        AddItemsToGmodCount(ply, itemID, 1)
    end

    ply:EmitSound("ui/crafting_complete.wav", 75, 100)

    net.Start("Workbench_CraftComplete")
    net.WriteEntity(self)
    net.WriteString(itemID)
    net.Send(ply)
end

net.Receive("Workbench_CraftItem", function(len, ply)
    local workbench = net.ReadEntity()
    local itemID = net.ReadString()

    if not IsValid(workbench) or workbench:GetClass() ~= "rust_workbench_1" then return end
    if workbench:GetOwner() ~= ply then return end
    if ply:GetPos():DistToSqr(workbench:GetPos()) > 10000 then return end

    workbench:StartCraft(ply, itemID)
end)

net.Receive("Workbench_CloseUI", function(len, ply)
    local workbench = net.ReadEntity()
    if IsValid(workbench) and workbench:GetOwner() == ply then
        workbench:SetIsOpen(false)
        workbench:SetOwner(NULL)
    end
end)