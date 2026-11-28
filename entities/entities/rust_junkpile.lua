AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Junk Pile"
ENT.Category = ""
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Models = {"models/darky_m/rust/junkpiles/a.mdl", "models/darky_m/rust/junkpiles/b.mdl", "models/darky_m/rust/junkpiles/c.mdl", "models/darky_m/rust/junkpiles/d.mdl", "models/darky_m/rust/junkpiles/e.mdl", "models/darky_m/rust/junkpiles/f.mdl", "models/darky_m/rust/junkpiles/g.mdl"}
if SERVER then
	function ENT:Initialize()
		local model = self.Models[math.random(1, #self.Models)]
		self:SetModel(model)
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then phys:Sleep() end
		for i = 2, 4 do
			local attach = self:GetAttachment(i)
			if attach then
				local brl = math.random(1, 2) == 1 and "rust_barrel" or "rust_oilbarrel"
				local barrel = ents.Create(brl)
				if IsValid(barrel) then
					barrel:SetPos(attach.Pos)
					barrel:SetAngles(attach.Ang)
					barrel:Spawn()
					barrel:Activate()
				end
			end
		end
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