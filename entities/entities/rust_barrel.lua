AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Barrels"
ENT.Category = ""
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Models = "models/environment/misc/barrel_v2.mdl"
ENT.Pos = NULL
if SERVER then
	function ENT:Initialize()
		self:SetModel(self.Models)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then phys:Wake() end
		local rnd = math.random(1, 2)
		if rnd == 1 then
			self:SetHealth(35)
			self:SetColor(Color(200, 165, 115))
		else
			self:SetHealth(50)
			self:SetColor(Color(80, 120, 205))
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

	local LootItems = {
		{
			Item = "RoadSign",
			Model = "models/items/roadsigns.mdl",
		},
		{
			Item = "MetalPipe",
			Model = "models/items/metalpipe.mdl",
		}
	}

	function ENT:RespawnItem()
		local Pos = self:GetPos()
		timer.Simple(300, function()
			local ent = ents.Create("rust_barrel")
			ent:SetPos(Pos)
			ent:SetModel("models/environment/misc/barrel_v2.mdl")
			ent:PhysicsInit(SOLID_VPHYSICS)
			ent:SetMoveType(MOVETYPE_NONE)
			ent:SetSolid(SOLID_VPHYSICS)
			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then phys:Wake() end
			local rnd = math.random(1, 2)
			if rnd == 1 then
				ent:SetHealth(35)
				ent:SetColor(Color(200, 165, 115))
			else
				ent:SetHealth(50)
				ent:SetColor(Color(80, 120, 205))
			end

			ent:Spawn()
			ent:Activate()
		end)
	end

	function ENT:SpawnLootable()
		self:RespawnItem()
		for i = 1, 2 do
			local loot = LootItems[i]
			local ent = ents.Create("item_bag")
			ent:SetItemName(loot.Item)
			ent:SetSizeItem(1)
			ent:SetModel(loot.Model)
			ent:Spawn()
			ent:Activate()
			ent:SetPos(self:GetPos() + self:GetForward() * 40 + self:GetUp() * 40)
		end
	end

	function ENT:OnTakeDamage(dmg)
		local dps = dmg:GetDamage()
		self:SetHealth(self:Health() - dps)
		if self:Health() <= 0 then
			self:SpawnLootable()
			self:Remove()
		end
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