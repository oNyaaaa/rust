ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Workbench Level 1"
ENT.Category = "Rust"
ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Model = "models/deployable/workbench_tier3.mdl"
ENT.WorkbenchLevel = 1

function ENT:SetupDataTables()
    self:NetworkVar("Float", 0, "Healthz")
    self:NetworkVar("Float", 1, "MaxHealthz")
    self:NetworkVar("Entity", 0, "Owner")
    self:NetworkVar("Bool", 0, "IsOpen")
end