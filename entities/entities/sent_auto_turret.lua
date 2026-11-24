AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Turret"
ENT.Radius = 360
ENT.Idle = true
ENT.Models = "models/deployable/turret_base.mdl"
function AddTurret(ent, pos, ang, shelt)
    if CLIENT then return end
    local entz = ents.Create(shelt)
    entz:SetPos(pos)
    entz:SetAngles(ang)
    entz:Spawn()
    entz:Activate()
    entz:SetParent(ent)
    return entz
end

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "Healthz")
    self:NetworkVar("Float", 1, "MaxHealthz")
end

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/deployable/turret_base.mdl")
        self:PhysicsInitStatic(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self.yaw_pos = AddTurret(self, self:GetPos() + Vector(0, 0, 30), Angle(0, 0, 0), "rust_yaw_turret")
        self.pitch = AddTurret(self.yaw_pos, self:GetPos() + Vector(0, 0, 35), Angle(0, 0, 0), "rust_pitch_turret")
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

function FindTarget(ent,ply)
    local targ = NULL
    for k, v in pairs(player.GetAll()) do
        local distance = v:GetPos():Distance(ent:GetPos())
        if v == ent then continue end
        if ent.Owners == v then continue end
        if not v:Alive() then continue end
        if distance >= 0 then targ = v end
    end
    return targ
end

function ENT:Think()
    if CLIENT then return end
    local target = FindTarget(self,ply)
    if target == NULL then
        self.yaw_pos:SetAngles(Angle(0, math.sin(CurTime() * 0.5) * 90, 0))
        self.pitch:SetAngles(Angle(math.sin(CurTime() * 0.5) * 1, math.sin(CurTime() * 0.5) * 90, 0))
    elseif target and IsValid(target) then
        self.yaw_pos:SetAngles((self:GetPos() - target:GetPos()):Angle())
        self.pitch:SetAngles((self:GetPos() - target:GetPos()):Angle())
       local bullet = {}
        bullet.Num = 1
        bullet.Src = self:GetPos() + Vector(0, 0, 30)
        bullet.Dir = target:GetPos() - self:GetPos()
        bullet.Spread = Vector(0.01, 0.01, 0)
        bullet.Tracer = 1
        bullet.Force = 2
        bullet.Damage = 13
        self:FireBullets(bullet)
    end
end