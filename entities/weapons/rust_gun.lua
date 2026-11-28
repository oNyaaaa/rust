AddCSLuaFile()
SWEP.ViewModel = "models/weapons/darky_m/rust/c_ak47u.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_ak47u.mdl"
SWEP.DrawCrosshair = true
SWEP.UseHands = true
SWEP.DrawAmmo = false
SWEP.Primary.Automatic = true
SWEP.Primary.DefaultClip = 30
SWEP.Primary.ClipSize = 120
SWEP.Primary.Ammo = SWEP.TakeAmmo
SWEP.Secondary.ClipSize = 120
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
function SWEP:Initialize()
    self:SetHoldType("ar2")
    self.delay = 0
    self.Clicked = false
    self.Reloaded = false
    self.Clapped = 0
    self:SetClip1(30)
end

SWEP.IronSightsPos = Vector(-4, -5.2, 2.1)
SWEP.IronSightsAng = Vector(1.4, 1, 0)
function SWEP:GetViewModelPosition(pos, ang)
    local aiming = self:GetNWBool("IronSights", false) -- or however you track ADS
    -- smooth blend between hip and ADS
    self.BlendPos = self.BlendPos or 0
    self.BlendPos = Lerp(FrameTime() * 10, self.BlendPos, aiming and 1 or 0)
    if self.BlendPos > 0.001 then
        local offset = self.IronSightsPos
        local rot = self.IronSightsAng
        ang = Angle(ang.p, ang.y, ang.r) -- copy so we don't mutate the original
        ang:RotateAroundAxis(ang:Right(), rot.x * self.BlendPos)
        ang:RotateAroundAxis(ang:Up(), rot.y * self.BlendPos)
        ang:RotateAroundAxis(ang:Forward(), rot.z * self.BlendPos)
        pos = pos + ang:Right() * offset.x * self.BlendPos + ang:Forward() * offset.y * self.BlendPos + ang:Up() * offset.z * self.BlendPos
    end
    return pos, ang
end

function SWEP:TakeAmmos(ply)
    if CLIENT then return end
    local hasitem = GInv_RemoveItem(ply, self.TakeAmmo, 1)
    self:SetNWBool("HasAmmo", FindExistingItemBool(ply, self.TakeAmmo) and true or false)
    return hasitem
end

function SWEP:FindAmmo(ply)
    if CLIENT then return self:GetNWBool("HasAmmo", false) end
    return FindExistingItemBool(ply, self.TakeAmmo) and true or false
end

function SWEP:PrimaryAttack()
    local pl = self:GetOwner()
    if not IsValid(pl) then return end
    -- only the server knows about inventory ammo
    if not self:FindAmmo(pl) then return end
    self:SetNextPrimaryFire(CurTime() + self.Primary.NextFire)
    self:EmitSound(self.Primary.Sound)
    pl:SetAnimation(PLAYER_ATTACK1)
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    local bullet = {}
    bullet.Num = 1
    bullet.Src = pl:GetShootPos()
    bullet.Dir = pl:GetAimVector()
    bullet.Spread = Vector(0.04, 0.04, 0)
    bullet.Tracer = 1
    bullet.Force = 1
    bullet.Damage = 25
    bullet.Attacker = pl
    if SERVER then pl:LagCompensation(true) end
    pl:FireBullets(bullet)
    if SERVER then pl:LagCompensation(false) end
    -- recoil after the shot so it doesn't affect the aim vector
    pl:ViewPunch(Angle(-math.Rand(0.4, 0.5), math.Rand(-0.2, 0.2), 0))
    if SERVER then self:TakeAmmos(pl) end
end

function SWEP:Think()
end

function SWEP:Think()
    if CLIENT then return end
    local pl = self:GetOwner()
    if IsValid(pl) then self:SetNWBool("IronSights", pl:KeyDown(IN_ATTACK2)) end
    if not IsValid(pl) then return end
    local has = FindExistingItemBool(pl, self.TakeAmmo) and true or false
    if self:GetNWBool("HasAmmo", false) ~= has then self:SetNWBool("HasAmmo", has) end
end

function SWEP:SecondaryAttack()
end