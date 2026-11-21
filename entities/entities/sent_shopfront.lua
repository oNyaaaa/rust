AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Window"
ENT.Radius = 360
ENT.Idle = true
ENT.Models = "models/darky_m/rust/shopfront.mdl"
function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "Healthz")
    self:NetworkVar("Float", 1, "MaxHealthz")
end

if SERVER then
    function ENT:Initialize()
        self.Entity:SetModel(self.Models)
        self:PhysicsInitStatic(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
            --phys:EnableMotion(false)
        end

        --local FOUNDATION_WIDTH = 145.78 -- from your foundation's OBB
        --local mins, maxs = self:OBBMins(), self:OBBMaxs()
        --local length = math.max(maxs.x - mins.x, maxs.y - mins.y)
        --if length > 0 then self:SetModelScale(FOUNDATION_WIDTH / length, 0) end
        self:SetHealthz(100)
        self.Ent_Health = 25
        self.Ent_HealthMax = 25
        --self:SetMaterial("Model/effects/vol_light001")
        self:DrawShadow()
        self.SpawnTime = 0
        self.EntCount = 0
        self:DropToFloor()
    end

    function ENT:OnTakeDamage(dmg)
        self:SetHealthz(self:GetHealthz() - dmg:GetDamage())
        if self:GetHealthz() <= 0 then self:Remove() end
    end
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