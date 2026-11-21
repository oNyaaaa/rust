GRUST_GHOST = GRUST_GHOST or {}
function GRUST_GHOST:MakeGhostEntity(model, pos, angle)
    local ply = LocalPlayer()
    local tr = ply:GetEyeTrace()
    pos = pos or tr.HitPos + tr.HitNormal * 32
    angle = ang or Angle(0, 0, 0)
    util.PrecacheModel(model)
    self:ReleaseGhostEntity()
    self.GhostEntity = ents.CreateClientProp(model)
    self.GhostEntity:SetModel(model)
    self.GhostEntity:SetPos(pos)
    self.GhostEntity:SetAngles(angle)
    self.GhostEntity:Spawn()
    self.GhostEntity:PhysicsDestroy()
    self.GhostEntity:SetMoveType(MOVETYPE_NONE)
    self.GhostEntity:SetNotSolid(true)
    self.GhostEntity:SetRenderMode(RENDERMODE_TRANSCOLOR)
    self.GhostEntity:SetColor(Color(255, 255, 255, 150))
    return self.GhostEntity
end

function GRUST_GHOST:ReleaseGhostEntity()
    if self.GhostEntity then
        if not IsValid(self.GhostEntity) then
            self.GhostEntity = nil
            return
        end

        self.GhostEntity:Remove()
        self.GhostEntity = nil
    end
end

hook.Add("HUDPaint", "ConfigureGRust", function()
    local ent = LocalPlayer():GetEyeTrace().Entity
    if not (IsValid(ent) and ent.GetHealthz) then return end
    local mins, maxs = ent:WorldSpaceAABB()
    local topPos = Vector((mins.x + maxs.x) / 2, (mins.y + maxs.y) / 2, maxs.z + 5)
    local scr = topPos:ToScreen()
    if not scr.visible then return end
    local hp = ent:GetHealthz()
    local maxHp = 100 -- change to the entity's real max health
    local w, h = 100, 8
    local frac = math.Clamp(hp / maxHp, 0, 1)
    if hp >= 100 then return end
    draw.RoundedBox(0, scr.x - w / 2, scr.y, w, h, Color(0, 0, 0, 180))
    draw.RoundedBox(0, scr.x - w / 2, scr.y, w * frac, h, Color(255, 255, 255))
end)