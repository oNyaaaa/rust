AddCSLuaFile()

ENT.Base      = "base_anim"
ENT.Type      = "anim"
ENT.PrintName = "Tool Cupboard"
ENT.Radius    = 625
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
        self.Cost = {}
        RustCupboard.Init(self)
        self.NextUpkeep = CurTime() + RustCupboard.UpkeepTick
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

    function ENT:Think()
        if CurTime() < self.NextUpkeep then
            self:NextThink(CurTime() + 1)
            return true
        end
        self.NextUpkeep = CurTime() + RustCupboard.UpkeepTick

        -- recalculate the cost from the pieces around the cupboard
        RustCupboard.Refresh(self)

        -- each tick consumes tick/86400 of the 24h cost
        local frac = RustCupboard.UpkeepTick / 86400
        for _, c in ipairs(self.Cost) do
            local owed = (self.Owed[c.id] or 0) + c.amount * frac
            local take = math.floor(owed)
            self.Owed[c.id] = owed - take
            if take > 0 then RustCupboard.RemoveItem(self, c.id, take) end
        end

        local protected = RustCupboard.ProtectedSeconds(self) > 0
        self:SetNWBool("Decaying", not protected)
        if not protected then hook.Run("RustCupboardDecay", self) end

        -- refresh anyone who has it open
        for ply in pairs(self.Viewers) do
            if IsValid(ply) then SendCupboard(ply, self) else self.Viewers[ply] = nil end
        end

        self:NextThink(CurTime() + 1)
        return true
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