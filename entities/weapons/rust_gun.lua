AddCSLuaFile()
SWEP.ViewModel = "models/weapons/darky_m/rust/c_ak47u.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_ak47u.mdl"
SWEP.DrawCrosshair = true
SWEP.UseHands = true
SWEP.Primary.Automatic = true
SWEP.Primary.DefaultClip = 30
SWEP.Primary.ClipSize = 120
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Sound = "weapons/rust_distant/ak74u-attack.mp3"
SWEP.Primary.NextFire = 0.1
SWEP.Secondary.ClipSize = 0
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
    self:SetClip2(120)
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

function SWEP:PrimaryAttack()
    local pl = self:GetOwner()
    if self.Primary.DefaultClip <= 0 then return end
    if not self:CanPrimaryAttack() then
        self.Reloaded = false
        return
    end

    if not IsValid(pl) then return end
    if SERVER and pl.ConsumeDurabilityForWeapon then pl:ConsumeDurabilityForWeapon(self) end
    pl:SetAnimation(PLAYER_ATTACK1)
    self:EmitSound(self.Primary.Sound)
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self:SetNextPrimaryFire(CurTime() + self.Primary.NextFire)
    local bullet = {}
    bullet.Num = 1
    bullet.Src = pl:GetShootPos()
    bullet.Dir = pl:GetAimVector()
    bullet.Spread = Vector(0.04, 0.04, 0)
    bullet.Tracer = 3
    bullet.Force = 1
    bullet.Damage = 25
    bullet.Attacker = pl
    pl:FireBullets(bullet)
    local BulletsFire = math.random(0.4, 0.5)
    pl:SetEyeAngles(pl:GetAngles() - Angle(BulletsFire, BulletsFire, 0))
    self:TakePrimaryAmmo(1)
    self.Reloaded = false
    self.Clapped = self.Clapped + 1
end

function SWEP:Reload()
    if self.delay >= CurTime() then return end
    self.delay = CurTime() + 1
    if self.Reloaded then return end
    self:SendWeaponAnim(ACT_VM_RELOAD)
    self.Clapped = 0
    timer.Simple(5, function() self.Reloaded = true end)
    self:SetNextPrimaryFire(CurTime() + 5)
end

function SWEP:Think()
    if SERVER then
        local pl = self:GetOwner()
        if IsValid(pl) then self:SetNWBool("IronSights", pl:KeyDown(IN_ATTACK2)) end
    end
end

function SWEP:SecondaryAttack()
end