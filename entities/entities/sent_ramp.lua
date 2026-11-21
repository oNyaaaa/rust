AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "wall"
ENT.Category = ""
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Models = "models/vasey/wood_house/wood_ramp.mdl"
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

	function ENT:SpawnFunction(ply, tr)
		if not tr.Hit then return end
		local ent = ents.Create("zombie_tree1")
		ent:SetPos(tr.HitPos + tr.HitNormal * 32)
		ent:Spawn()
		ent:Activate()
		return ent
	end

	function ENT:Think()
	end

	function ENT:Use(btn, ply)
	end

	function ENT:StartTouch(entity)
		return false
	end

	function ENT:EndTouch(entity)
		return false
	end

	function ENT:Touch(entity)
		return false
	end
end

if CLIENT then
	ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
	function ENT:Initialize()
	end

	function ENT:Draw()
		self:DrawModel()
	end
end