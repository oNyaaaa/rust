AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Window"
ENT.Radius = 360
ENT.Idle = true
ENT.Models = "models/deployable/vertical_embrasure.mdl"
function ENT:Initialize()
    if CLIENT then return end
    self:SetModel("models/deployable/vertical_embrasure.mdl")
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetHealth(500)
    self:DropToFloor()
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