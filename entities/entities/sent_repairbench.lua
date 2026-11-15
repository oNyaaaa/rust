AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Turret"
ENT.Radius = 360
ENT.Idle = true
ENT.Models = "models/deployable/repair_bench.mdl"
function ENT:Initialize()
    if CLIENT then return end
    self:SetModel("models/deployable/repair_bench.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    self:SetHealth(500)
    self:DropToFloor()
end

function ENT:Think()
    if CLIENT then return end
end