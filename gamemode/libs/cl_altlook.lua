-- ALT free look: true over-the-shoulder POV.
-- Hold ALT: the local body is drawn and the camera sits behind/right of it,
-- looking around freely while the body + weapon stay locked. Release: eases back.
AltLook = AltLook or {}
AltLook.Key = KEY_LALT
AltLook.LerpSpeed = 15
AltLook.MaxYaw = 90
AltLook.MaxPitch = 1
AltLook.MouseScale = 0.022
AltLook.Shoulder = Vector(8, -40, 6) -- right, back, up (camera behind the body)
AltLook.Yaw = 0
AltLook.Pitch = 0
AltLook.Blend = 0
AltLook.View = {}
function AltLook.IsActive()
    return input.IsKeyDown(AltLook.Key)
end

function AltLook.IsMoving()
    return math.abs(AltLook.Yaw) > 0.01 or math.abs(AltLook.Pitch) > 0.01
end

function AltLook.Angle()
    return Angle(AltLook.Pitch, -AltLook.Yaw, 0)
end

function AltLook.IsViewing()
    return AltLook.IsActive() or AltLook.Blend > 0.01
end

hook.Add("CalcView", "AltLook.View", function(ply, origin, angles, fov, znear, zfar)
    local active = AltLook.IsActive()
    AltLook.Blend = Lerp(FrameTime() * AltLook.LerpSpeed, AltLook.Blend, active and 1 or 0)
    if not active and not AltLook.IsMoving() and AltLook.Blend <= 0.001 then
        AltLook.Yaw = 0
        AltLook.Pitch = 0
        return
    end

    if not active then
        AltLook.Yaw = Lerp(FrameTime() * AltLook.LerpSpeed, AltLook.Yaw, 0)
        AltLook.Pitch = Lerp(FrameTime() * AltLook.LerpSpeed, AltLook.Pitch, 0)
    end

    local turn = AltLook.Angle()
    local out = AltLook.View
    local s = AltLook.Shoulder * AltLook.Blend
    -- Anchor the offset to the locked body angles so left/right behave the same
    -- (using the free-look direction made the body occlude one side).
    out.angles = angles + turn
    out.origin = origin + angles:Right() * s.x + angles:Forward() * s.y + angles:Up() * s.z
    return out
end)

-- Draw the local body so the camera actually sits over a shoulder.
-- Capture the mouse so the body/weapon stay locked instead of swinging.
hook.Add("InputMouseApply", "AltLook.Mouse", function(cmd, x, y, angles)
    if not AltLook.IsActive() then return end
    AltLook.Yaw = math.Clamp(AltLook.Yaw + x * AltLook.MouseScale, -AltLook.MaxYaw, AltLook.MaxYaw)
    AltLook.Pitch = math.Clamp(AltLook.Pitch + y * AltLook.MouseScale, -AltLook.MaxPitch, AltLook.MaxPitch)
    return true
end)

-- Hide the first-person viewmodel while the shoulder cam is active