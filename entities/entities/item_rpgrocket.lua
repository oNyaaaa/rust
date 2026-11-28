AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Wall"
ENT.Category = ""
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Models = "models/weapons/darky_m/rust/rocket.mdl"
if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Models)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then phys:Wake() end
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
		if SERVER then
			local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetScale(1)
			util.Effect("bigsmoke", effectdata)
		end
	end

	function ENT:OnTakeDamage(dmg)
	end

	function ENT:OnRemove()
	end

	function ENT:Use(btn, ply)
	end

	function ENT:StartTouch(entity)
		return false
	end

	function ENT:EndTouch(entity)
		return false
	end

	function ENT:PhysicsCollide(data, collider)
		local pos = data.HitPos
		if SERVER then
			local ed = EffectData()
			ed:SetOrigin(pos)
			util.Effect("explosioneffd", ed)
			-- splash damage
			for _, ply in ipairs(ents.FindInSphere(pos, 200)) do
				if IsValid(ply) then
					local dist = (ply:GetPos() - pos):Length()
					ply:TakeDamage(math.max(0, 200 - dist), ply)
				end
			end
		end

		util.ScreenShake(pos, 500, 25, 1, 256 * 2)
		self:Remove()
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