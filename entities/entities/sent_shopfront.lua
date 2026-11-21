AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Window"
ENT.Radius = 360
ENT.Idle = true
ENT.Models = "models/darky_m/rust/shopfront.mdl"
function ENT:Initialize()
    if CLIENT then return end
    self:SetModel("models/darky_m/rust/shopfront.mdl")
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetHealth(500)
    self:DropToFloor()
end

if CLIENT then
    ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
    function ENT:Initialize()
    end

    local DOOR_H = 140
    function ENT:ApplyDoorScale()
        if not self.DoorMatrix then
            local mins, maxs = self:GetModelBounds()
            local sz = maxs.z - mins.z
            if sz <= 0 then return end
            local kz = DOOR_H / sz
            local pivot = Vector((mins.x + maxs.x) / 2, (mins.y + maxs.y) / 2, mins.z)
            local m = Matrix()
            m:Translate(pivot)
            m:Scale(Vector(1.2, 1, kz))
            m:Translate(-pivot)
            local pad = Vector(64, 64, 64)
            self.DoorMatrix = m
            self.DoorBoundsMin = mins - pad
            self.DoorBoundsMax = Vector(maxs.x, maxs.y, mins.z + sz * kz) + pad
        end

        self:EnableMatrix("RenderMultiply", self.DoorMatrix)
        self:SetRenderBounds(self.DoorBoundsMin, self.DoorBoundsMax)
    end

    function ENT:Draw()
        self:ApplyDoorScale()
        self:DrawModel()
    end
end