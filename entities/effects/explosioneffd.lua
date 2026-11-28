local matFire = "effects/fire_cloud1"
local matSmoke = "particle/particle_noisesphere"
local matSpark = "effects/yellowflare"
function EFFECT:Init(data)
    local origin = data:GetOrigin()
    local scale = data:GetScale() or 1
    if scale <= 0 then scale = 1 end
    local emitter = ParticleEmitter(origin, true)
    if not IsValid(emitter) then return end
    -- fireball
    for i = 0, 40 do
        local pos = Vector(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1))
        local p = emitter:Add(matFire, origin + pos * 8 * scale)
        if p then
            p:SetVelocity(pos * 350 * scale + Vector(0, 0, 60))
            p:SetLifeTime(0)
            p:SetDieTime(math.Rand(0.4, 0.9))
            p:SetStartAlpha(255)
            p:SetEndAlpha(0)
            local size = math.Rand(40, 80) * scale
            p:SetStartSize(size)
            p:SetEndSize(0)
            p:SetRoll(math.Rand(0, 360))
            p:SetRollDelta(math.Rand(-40, 40))
            p:SetGravity(Vector(0, 0, -80))
            p:SetColor(255, math.Rand(120, 200), 60)
        end
    end

    -- smoke
    for i = 0, 24 do
        local pos = Vector(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1))
        local p = emitter:Add(matSmoke, origin + pos * 16 * scale)
        if p then
            p:SetVelocity(pos * 120 * scale + Vector(0, 0, 90))
            p:SetLifeTime(0)
            p:SetDieTime(math.Rand(1.5, 3))
            p:SetStartAlpha(200)
            p:SetEndAlpha(0)
            local size = math.Rand(40, 70) * scale
            p:SetStartSize(size)
            p:SetEndSize(size * 3)
            p:SetRoll(math.Rand(0, 360))
            p:SetRollDelta(math.Rand(-20, 20))
            p:SetGravity(Vector(0, 0, 25))
            p:SetColor(50, 50, 50)
        end
    end

    -- sparks
    for i = 0, 16 do
        local pos = Vector(math.Rand(-1, 1), math.Rand(-1, 1), math.Rand(-1, 1))
        local p = emitter:Add(matSpark, origin)
        if p then
            p:SetVelocity(pos * 600 * scale)
            p:SetLifeTime(0)
            p:SetDieTime(math.Rand(0.3, 0.6))
            p:SetStartAlpha(255)
            p:SetEndAlpha(0)
            p:SetStartSize(math.Rand(6, 12) * scale)
            p:SetEndSize(0)
            p:SetGravity(Vector(0, 0, -400))
            p:SetColor(255, 220, 120)
        end
    end

    emitter:Finish()
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end