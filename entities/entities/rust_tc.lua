AddCSLuaFile()
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Item Loot Drop"
ENT.Radius = 625 ^ 2
ENT.Models = "models/deployable/tool_cupboard.mdl"
if SERVER then
    util.AddNetworkString("TC_rust_Authorize")
    util.AddNetworkString("TC_rust_Authorize_Snd")
    function ENT:Initialize()
        self:SetModel("models/deployable/tool_cupboard.mdl")
        self:PhysicsInitStatic(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self.Authorized = {}
        self.IsRustCupboard = true
        self.Viewers = {}
        self.Owed = {}
        self.NextUpkeep = CurTime() + RustCupboard.UpkeepTick
    end

    function ENT:Think()
        for k, v in pairs(ents.FindInSphere(self:GetPos(), self.Radius)) do
            -- if not table.HasValue(self.Authorized, v:SteamID64()) then v.BB_Blocked = true end
        end
    end

    function ENT:Use(activator)
        if not IsValid(activator) or not activator:IsPlayer() then return end
        if self.Authorized[activator:SteamID64()] then
            self.Viewers[activator] = true
            SendCupboard(activator, self)
        else
            net.Start("TC_rust_Authorize_Snd")
            net.WriteEntity(self)
            net.Send(activator)
        end
    end

    net.Receive("TC_rust_Authorize", function(_, ply)
        local ent = net.ReadEntity()
        if not IsValid(ent) or not ent.IsRustCupboard then return end
        if ply:GetEyeTrace().Entity ~= ent then return end
        if ply:GetPos():DistToSqr(ent:GetPos()) > 40000 then return end
        ent.Authorized[ply:SteamID64()] = true
        ent.Viewers[ply] = true
        SendCupboard(ply, ent)
    end)
else
    net.Receive("TC_rust_Authorize_Snd", function()
        local ent = net.ReadEntity()
        net.Start("TC_rust_Authorize")
        net.WriteEntity(ent)
        net.SendToServer()
    end)
end