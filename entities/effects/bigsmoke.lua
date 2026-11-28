AddCSLuaFile()
local matSmoke = "effects/fire_cloud1"
function EFFECT:Init(data)
    local origin = data:GetOrigin()
    local scale = data:GetScale() or 1
    if scale <= 0 then scale = 1 end
    local emitter = ParticleEmitter(origin, true)
    if not IsValid(emitter) then return end
    for i = 0, 18 do
        local pos = Vector(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1))
        local p = emitter:Add(matSmoke, origin + pos * 8 * scale)
        if p then
            p:SetVelocity(pos * 40 * scale + Vector(0, 0, 35))
            p:SetLifeTime(0)
            p:SetDieTime(math.Rand(1.5, 3))
            p:SetStartAlpha(180)
            p:SetEndAlpha(0)
            local size = math.Rand(20, 35) * scale
            p:SetStartSize(size)
            p:SetEndSize(size * 4)
            p:SetRoll(math.Rand(0, 360))
            p:SetRollDelta(math.Rand(-15, 15))
            p:SetGravity(Vector(0, 0, 20))
            p:SetColor(64, 64, 64)
        end
    end

    emitter:Finish()
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end