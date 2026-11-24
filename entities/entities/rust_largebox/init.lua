AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")
util.AddNetworkString("grust_OpenLargeBox")
util.AddNetworkString("grust_LargeBoxSync")
util.AddNetworkString("grust_LargeBoxMove")
util.AddNetworkString("grust_LargeBoxTake")
local MODEL = "models/deployable/large_wooden_box.mdl" -- swap for your real model path
local FALLBACK = "models/props_junk/wood_crate001a.mdl"
local USE_DIST = 200 * 200
-- TODO: hook these into your grust inventory (see grust_MoveItem / grust_LootTake / GInv_RemoveItem).
-- TakeFromPlayer must REMOVE the item from the player's inventory slot and return id, amount (or nil).
local function TakeFromPlayer(ply, slot)
    return nil
end

-- GiveToPlayer must ADD the item to the player's inventory and return true on success.
local function GiveToPlayer(ply, id, amt)
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
    self.Inv = {} -- [slot] = { id = "Wood", amt = 10 }
end

function ENT:SendContents(ply)
    local count = 0
    for _ in pairs(self.Inv) do
        count = count + 1
    end

    net.Start("grust_LargeBoxSync")
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
    -- code lock check goes here later
    -- net.Start("grust_OpenLargeBox")
    --net.WriteEntity(self)
    -- net.Send(activator)
    --self:SendContents(activator)
end

local function Validate(ply, ent)
    return IsValid(ent) and ent:GetClass() == "ent_rust_largebox" and ply:GetPos():DistToSqr(ent:GetPos()) <= USE_DIST
end

-- player inventory -> box
net.Receive("grust_LargeBoxMove", function(len, ply)
    local ent = net.ReadEntity()
    local fromSlot = net.ReadUInt(8)
    local boxSlot = net.ReadUInt(6)
    if not Validate(ply, ent) then return end
    if boxSlot < 1 or boxSlot > ent.NumSlots then return end
    if ent.Inv[boxSlot] then -- slot already taken
        return
    end

    local id, amt = TakeFromPlayer(ply, fromSlot)
    if not id then return end
    ent.Inv[boxSlot] = {
        id = id,
        amt = amt
    }

    ent:SendContents(ply)
end)

-- box -> player inventory
net.Receive("grust_LargeBoxTake", function(len, ply)
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