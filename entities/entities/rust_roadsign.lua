AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
local RoadSignModels = {"models/environment/roadsigns/roadsign_b.mdl", "models/environment/roadsigns/roadsign_c.mdl", "models/environment/roadsigns/roadsign_d.mdl", "models/environment/roadsigns/roadsign_e.mdl", "models/environment/roadsigns/roadsign_f.mdl", "models/environment/roadsigns/roadsign_g.mdl"}
function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "Healthz")
    self:NetworkVar("Float", 1, "MaxHealthz")
end

function ENT:Initialize()
    if CLIENT then return end
    -- Pick a random roadsign model
    local randomModel = RoadSignModels[math.random(#RoadSignModels)]
    self:SetModel(randomModel)
    self:PhysicsInitStatic(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_NONE)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetHealthz(100)
    -- Roadsign health settings
    self:PrecacheGibs()
    -- Damage multipliers
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

function ENT:OnDestroyed(dmg)
    self:GibBreakClient(Vector(0, 0, 1))
    for i = 1, 2 do
        local loot = LootItems[i]
        local ent = ents.Create("item_bag")
        ent:SetItemName(loot.Item)
        ent:SetSizeItem(1)
        ent:SetModel(loot.Model)
        ent:Spawn()
        ent:Activate()
        ent:SetPos(self:GetPos() + self:GetUp() * 40)
    end
end

function ENT:OnTakeDamage(dmg)
    if CLIENT then return end
    self:SetHealthz(self:GetHealthz() - dmg:GetDamage())
    if self:GetHealthz() <= 0 then
        self:OnDestroyed(dmg)
        self:Remove()
    end
end