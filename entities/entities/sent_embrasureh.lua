AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Window"
ENT.Radius = 360
ENT.Idle = true
ENT.Models = "models/deployable/horizontal_embrasure.mdl"
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

function ENT:Think()
    if CLIENT then return end
    local doors = 0
    for k, v in pairs(ents.FindInSphere(self:GetPos(), 30)) do
        if v:GetClass() == "sent_window" then doors = doors + 1 end
    end

    if doors <= 0 then self:Remove() end
end

if CLIENT then
    ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
    function ENT:Initialize()
    end

    function ENT:Draw(flags)
        -- Draw the model
        self:DrawModel(flags)
    end
end