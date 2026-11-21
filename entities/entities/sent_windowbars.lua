AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Turret"
ENT.Radius = 360
ENT.Idle = true
ENT.Models = "models/darky_m/rust/woodenbars.mdl"
function ENT:Initialize()
    if CLIENT then return end
    self:SetModel("models/darky_m/rust/woodenbars.mdl")
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
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
        local WALL_LENGTH = 110 -- match your DEPLOY.ClassDist entry for the wall class
        local mins, maxs = self:OBBMins(), self:OBBMaxs()
        local sx, sy = maxs.x - mins.x, maxs.y - mins.y
        local len = math.max(sx, sy)
        if len > 0 and len < WALL_LENGTH then
            local k = WALL_LENGTH / len
            -- scale only the longer horizontal axis; thickness and height stay as-is
            local WALL_HEIGHT = 105 -- set to your floor-to-ceiling distance
            local sz = maxs.z - mins.z
            local kz = (sz > 0 and sz < WALL_HEIGHT) and (WALL_HEIGHT / sz) or 1
            self:SetRenderBounds(Vector(mins.x * k, mins.y * k, mins.z * kz), Vector(maxs.x * k, maxs.y * k, maxs.z * kz))
            local pivot = Vector((mins.x + maxs.x) / 2, (mins.y + maxs.y) / 2, mins.z)
            local m = Matrix()
            m:Translate(pivot)
            m:Scale(sx >= sy and Vector(k, 1, kz) or Vector(1, k, kz))
            m:Translate(-pivot)
            self:EnableMatrix("RenderMultiply", m)
        end
    end
end