AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
util.AddNetworkString("grust_OpenSmall")
util.AddNetworkString("grust_SmallSync")
util.AddNetworkString("grust_SmallMove")
util.AddNetworkString("grust_SmallTake")
local MODEL = "models/deployable/wooden_box.mdl"
local FALLBACK = "models/props_junk/wood_crate001a.mdl"
local USE_DIST = 200 * 200

local function GiveToPlayer(ply, id, amt)
    if not IsValid(ply) or not ply.GInv then return false end
    local def = RustOfficial.GetItem(id)
    if not def then return false end
    local max = def.Max or 1
    local left = amt
    while left > 0 do
        local ok, slot = false, nil
        for i = 1, 24 do
            local sd = ply.GInv[i]
            if not sd or not next(sd) then ok, slot = true, i break end
        end
        if not ok then break end
        local cur = ply.GInv[slot] and ply.GInv[slot]["Inventory"]
        local space = max - ((cur and cur.Count) or 0)
        local add = math.min(space, left)
        if add <= 0 then break end
        ply.GInv[slot] = ply.GInv[slot] or {}
        ply.GInv[slot]["Inventory"] = { id = id, dur = 100, Count = add, slot = slot, wModel = def.wModel, weapon = def.weapon }
        left = left - add
    end
    if left < amt then
        SendInv(ply)
        return true
    end
    return false
end

function ENT:Initialize()
    self:SetModel(util.IsValidModel(MODEL) and MODEL or FALLBACK)
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()
    if IsValid(phys) then phys:Wake() end
    self.Inv = {}
end

function ENT:SendContents(ply)
    local count = 0
    for _ in pairs(self.Inv) do count = count + 1 end
    net.Start("grust_SmallSync")
    net.WriteEntity(self)
    net.WriteUInt(count, 6)
    for slot, item in pairs(self.Inv) do
        net.WriteUInt(slot, 6)
        net.WriteString(item.id)
        net.WriteUInt(item.amt, 16)
    end
    net.Send(ply)
end

function ENT:Use(activator)
    if not IsValid(activator) or not activator:IsPlayer() then return end
    net.Start("grust_OpenSmall")
    net.WriteEntity(self)
    net.Send(activator)
    self:SendContents(activator)
end

local function Validate(ply, ent)
    if not IsValid(ent) or ent:GetClass() ~= "rust_smallbox" then return false end
    return ply:GetPos():DistToSqr(ent:GetPos()) <= USE_DIST
end

net.Receive("grust_SmallMove", function(len, ply)
    local ent = net.ReadEntity()
    local fromContID = net.ReadUInt(2)
    local fromSlot = net.ReadUInt(8)
    local boxSlot = net.ReadUInt(6)
    if not Validate(ply, ent) then return end
    if boxSlot < 1 or boxSlot > ent.NumSlots then return end

    local CONT_ID = { [0] = "Inventory", [1] = "HotBar", [2] = "Clothing", [3] = "Box" }
    local fromCont = CONT_ID[fromContID]
    if not fromCont then return end

    local existing = ent.Inv[boxSlot]
    local fromItem, sd
    if fromCont == "Box" then
        if fromSlot < 1 or fromSlot > ent.NumSlots then return end
        fromItem = ent.Inv[fromSlot]
        if not fromItem then return end
    else
        sd = ply.GInv and ply.GInv[fromSlot]
        if not sd then return end
        fromItem = sd[fromCont]
        if not fromItem then return end
    end

    local id, amt = fromItem.id, fromItem.Count or fromItem.amt or 1

    if existing then
        local def = RustOfficial.GetItem(existing.id)
        local max = def and def.Max or 1
        local space = max - existing.amt
        if fromItem.id == existing.id and space > 0 then
            local moved = math.min(amt, space)
            existing.amt = existing.amt + moved
            local left = amt - moved
            if left <= 0 then
                if fromCont == "Box" then ent.Inv[fromSlot] = nil else sd[fromCont] = nil end
            else
                if fromCont == "Box" then ent.Inv[fromSlot].amt = left else fromItem.Count = left end
            end
            if fromCont ~= "Box" then SendInv(ply) end
            ent:SendContents(ply)
            return
        end
        return
    end

    if fromCont == "Box" then
        ent.Inv[fromSlot] = nil
    else
        sd[fromCont] = nil
        if fromItem.weapon and not ply:HasWeapon(fromItem.weapon) then
            local def = RustOfficial.GetItem(id)
            if def and def.func then def.func(ply) end
        end
        SendInv(ply)
    end
    ent.Inv[boxSlot] = { id = id, amt = amt }
    ent:SendContents(ply)
end)

net.Receive("grust_SmallTake", function(len, ply)
    local ent = net.ReadEntity()
    local boxSlot = net.ReadUInt(6)
    if not Validate(ply, ent) then return end
    local item = ent.Inv[boxSlot]
    if not item then return end
    if GiveToPlayer(ply, item.id, item.amt) then
        ent.Inv[boxSlot] = nil
        ent:SendContents(ply)
    end
end)
