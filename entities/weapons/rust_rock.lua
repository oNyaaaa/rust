AddCSLuaFile()
SWEP.Base = "rust_melee"
SWEP.ViewModel = "models/weapons/darky_m/rust/c_rock.mdl"
SWEP.WorldModel = "models/weapons/darky_m/rust/w_rock.mdl"
SWEP.DrawCrosshair = true
SWEP.DrawAmmo = false
SWEP.UseHands = true
SWEP.Primary.Automatic = true
SWEP.SNDSoundStrike = "tools/rock_strike_" .. math.random(1, 4) .. ".mp3"
SWEP.SNDSoundSwing = "tools/rock_swing.mp3"
SWEP.DelayOfSwing = 0.5
SWEP.Primary.Damaged = 25