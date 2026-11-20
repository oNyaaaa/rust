util.AddNetworkString("gRustCupboard")
util.AddNetworkString("gRustCupboardMove")
util.AddNetworkString("gRustCupboardClose")
util.AddNetworkString("gRustCupboardDrop")
RustCupboard = RustCupboard or {}
-- cost per 24 hours (matches the screenshot)
-- which resources can be charged (order = order shown on the panel)
RustCupboard.Resources = {
    {
        id = "Wood",
        name = "Wood"
    },
    {
        id = "Stone",
        name = "Stone"
    },
    {
        id = "Metal",
        name = "Metal Fragments"
    },
    {
        id = "HQMetal",
        name = "HQ Metal"
    },
}

-- amount per 24h for ONE piece (placeholder numbers, tune these)
RustCupboard.PieceBase = {
    sent_foundation = 40,
    sent_wall = 20,
    sent_ceiling = 30,
    sent_doorway = 15,
    sent_stairs = 25,
    sent_door = 10,
}

-- which resource each tier is charged in. A tier that isn't listed (twig) is free.
RustCupboard.TierResource = {
    twig = "Wood",
    wood = "Wood",
    stone = "Stone",
    metal = "Metal",
    hqm = "HQMetal",
}

RustCupboard.DefaultTier = "twig" -- used when a piece's tier can't be read, so it charges nothing
RustCupboard.BuildRadius = 625
local TIER_MATCH = {
    -- checked in order, so "hqmetal" matches hqm before metal
    {"hq", "hqm"},
    {"armor", "hqm"},
    {"twig", "twig"},
    {"stone", "stone"},
    {"metal", "metal"},
    {"sheet", "metal"},
    {"wood", "wood"},
}

local TIER_NUMBER = {
    [1] = "twig",
    [2] = "wood",
    [3] = "stone",
    [4] = "metal",
    [5] = "hqm"
}

local function MatchTier(raw)
    if isnumber(raw) then return TIER_NUMBER[raw] end
    if isstring(raw) and raw ~= "" then
        local s = string.lower(raw)
        for _, m in ipairs(TIER_MATCH) do
            if string.find(s, m[1], 1, true) then return m[2] end
        end
    end
end

function RustCupboard.GetTier(e)
    local t = MatchTier(e.Tier) or MatchTier(e.BuildTier) or MatchTier(e.Upgrade) or MatchTier(e.Level) or MatchTier(e.Material) or MatchTier(e.Mat) or MatchTier(e:GetNWString("Tier", "")) or MatchTier(e:GetNWInt("Tier", 0)) or MatchTier(e.GetTier and e:GetTier()) or MatchTier(e:GetMaterial()) or MatchTier(e:GetModel())
    return t or RustCupboard.DefaultTier
end

function RustCupboard.CalcCost(ent)
    local totals = {}
    for _, e in ipairs(ents.FindInSphere(ent:GetPos(), RustCupboard.BuildRadius)) do
        local base = RustCupboard.PieceBase[e:GetClass()]
        local res = base and RustCupboard.TierResource[RustCupboard.GetTier(e)]
        if res then totals[res] = (totals[res] or 0) + base end
    end

    local out = {}
    for _, r in ipairs(RustCupboard.Resources) do
        if (totals[r.id] or 0) > 0 then
            out[#out + 1] = {
                id = r.id,
                name = r.name,
                amount = totals[r.id]
            }
        end
    end
    return out
end

function RustCupboard.Refresh(ent)
    ent.Cost = RustCupboard.CalcCost(ent)
end

RustCupboard.GridSize = 30
RustCupboard.ToolSize = 5
RustCupboard.MaxDistSqr = 200 * 200
RustCupboard.UpkeepTick = 60 -- seconds between upkeep consumption
-- ---------- storage helpers ----------
function RustCupboard.Init(ent)
    ent.Grid = ent.Grid or {}
    ent.ToolRow = ent.ToolRow or {}
    ent.Owed = ent.Owed or {}
end

function RustCupboard.Count(ent, id)
    local total = 0
    for i = 1, RustCupboard.GridSize do
        local it = ent.Grid[i]
        if it and it.id == id then total = total + it.amount end
    end
    return total
end

-- adds an item, stacking onto matching slots. Returns amount that did not fit.
function RustCupboard.AddItem(ent, id, name, amount, mat)
    RustCupboard.Init(ent)
    for i = 1, RustCupboard.GridSize do
        local it = ent.Grid[i]
        if it and it.id == id then
            it.amount = it.amount + amount
            return 0
        end
    end

    for i = 1, RustCupboard.GridSize do
        if not ent.Grid[i] then
            ent.Grid[i] = {
                id = id,
                name = name,
                amount = amount,
                mat = mat
            }
            return 0
        end
    end
    return amount
end

function RustCupboard.RemoveItem(ent, id, amount)
    for i = 1, RustCupboard.GridSize do
        local it = ent.Grid[i]
        if it and it.id == id then
            local take = math.min(it.amount, amount)
            it.amount = it.amount - take
            amount = amount - take
            if it.amount <= 0 then ent.Grid[i] = nil end
            if amount <= 0 then return 0 end
        end
    end
    return amount
end

function RustCupboard.ProtectedSeconds(ent)
    local best = math.huge
    for _, c in ipairs(ent.Cost or {}) do
        best = math.min(best, RustCupboard.Count(ent, c.id) / c.amount * 86400)
    end
    return math.floor(best == math.huge and 86400 * 999 or best)
end

-- hand an item to the player. Hook this into your own inventory.
-- cupboard -> player inventory
function RustCupboard.GiveToPlayer(ply, item)
    return AddItemsToGmodCount(ply, item.id, item.dur or 100, nil, item.amount) and true or false
end

-- player inventory -> cupboard (takes the whole stack, same as your furnace "put")
function RustCupboard.TakeFromPlayer(ply, name)
    if not name or name == "" then return end
    local def = RustOfficial.GetItem(name)
    if not def then return end
    local has, amount = CalcItem(ply, name)
    if not has or amount <= 0 then return end
    GInv_RemoveItem(ply, name, amount)
    return {
        id = name,
        name = def.name or name,
        amount = amount,
        dur = 100,
        mat = def.image
    }
end

-- ---------- networking ----------
function SendCupboard(ply, ent)
    if not IsValid(ent) then return end
    RustCupboard.Refresh(ent)
    RustCupboard.Init(ent)
    net.Start("gRustCupboard")
    net.WriteEntity(ent)
    net.WriteUInt(math.min(RustCupboard.ProtectedSeconds(ent), 4294967295), 32)
    net.WriteTable(ent.Cost)
    net.WriteTable(ent.ToolRow)
    net.WriteTable(ent.Grid)
    net.Send(ply)
end

net.Receive("gRustCupboardMove", function(_, ply)
    local ent = net.ReadEntity()
    local kind = net.ReadString()
    local idx = net.ReadUInt(8)
    if not IsValid(ent) or not ent.IsRustCupboard then return end
    if not ent.Authorized[ply:SteamID64()] then return end
    if ply:GetPos():DistToSqr(ent:GetPos()) > RustCupboard.MaxDistSqr then return end
    if kind ~= "grid" and kind ~= "tool" then return end
    RustCupboard.Init(ent)
    local tbl = (kind == "grid") and ent.Grid or ent.ToolRow
    local item = tbl[idx]
    if not item then return end
    if RustCupboard.GiveToPlayer(ply, item) then tbl[idx] = nil end
    SendCupboard(ply, ent)
end)

net.Receive("gRustCupboardClose", function(_, ply)
    local ent = net.ReadEntity()
    if IsValid(ent) and ent.Viewers then ent.Viewers[ply] = nil end
end)

-- ADAPTER: remove the item in the player's inventory slot and return
-- { id = "wood", name = "Wood", amount = 100, mat = "..." } or nil.
-- Replace the body with a call into your grust inventory.
net.Receive("gRustCupboardDrop", function(_, ply)
    local ent = net.ReadEntity()
    local toKind = net.ReadString()
    local toIdx = net.ReadUInt(8)
    local fromKind = net.ReadString()
    local fromIdx = net.ReadUInt(8)
    local invName = net.ReadString()
    if not IsValid(ent) or not ent.IsRustCupboard then return end
    if ply:GetPos():DistToSqr(ent:GetPos()) > RustCupboard.MaxDistSqr then return end
    if not ent.Authorized[ply:SteamID64()] then return end
    if toKind ~= "grid" and toKind ~= "tool" then return end
    RustCupboard.Init(ent)
    local dst = (toKind == "tool") and ent.ToolRow or ent.Grid
    local size = (toKind == "tool") and RustCupboard.ToolSize or RustCupboard.GridSize
    if toIdx == 0 and fromKind == "inv" then
        for i = 1, RustCupboard.GridSize do
            if ent.Grid[i] and ent.Grid[i].id == invName then
                toIdx = i
                break
            end
        end

        if toIdx == 0 then
            for i = 1, RustCupboard.GridSize do
                if not ent.Grid[i] then
                    toIdx = i
                    break
                end
            end
        end
    end

    if toIdx < 1 or toIdx > size then return end
    if fromKind == "inv" then
        local cur = dst[toIdx]
        if cur and cur.id ~= invName then return end
        local item = RustCupboard.TakeFromPlayer(ply, invName)
        if not item then return end
        if cur then
            cur.amount = cur.amount + item.amount
        else
            dst[toIdx] = item
        end
    elseif fromKind == "grid" or fromKind == "tool" then
        local src = (fromKind == "tool") and ent.ToolRow or ent.Grid
        local a, b = src[fromIdx], dst[toIdx]
        if not a or (src == dst and fromIdx == toIdx) then return end
        if b and b.id == a.id then
            b.amount = b.amount + a.amount
            src[fromIdx] = nil
        else
            src[fromIdx], dst[toIdx] = b, a
        end
    else
        return
    end

    SendCupboard(ply, ent)
end)

RustCupboard.DecayPerHour = 0.10 -- fraction of max health lost per hour when unprotected
RustCupboard.DecayNoTC = false -- also decay pieces with no cupboard in range?
local function DecayPiece(e, frac)
    local max = e:GetMaxHealth()
    if max <= 0 then max = e:Health() end
    if max <= 0 then return end
    local d = DamageInfo()
    d:SetDamage(math.max(1, math.floor(max * frac)))
    d:SetAttacker(game.GetWorld())
    d:SetInflictor(game.GetWorld())
    d:SetDamageType(DMG_GENERIC)
    e:TakeDamageInfo(d)
end

timer.Create("RustCupboard_Upkeep", RustCupboard.UpkeepTick, 0, function()
    local tcs = {}
    -- 1. upkeep drain + protected state for every cupboard
    for _, tc in ipairs(ents.FindByClass("rust_tc")) do
        if tc.IsRustCupboard then
            RustCupboard.Init(tc)
            RustCupboard.Refresh(tc)
            local frac = RustCupboard.UpkeepTick / 86400
            for _, c in ipairs(tc.Cost) do
                local owed = (tc.Owed[c.id] or 0) + c.amount * frac
                local take = math.floor(owed)
                tc.Owed[c.id] = owed - take
                if take > 0 then RustCupboard.RemoveItem(tc, c.id, take) end
            end

            tc.Protected = RustCupboard.ProtectedSeconds(tc) > 0
            tc:SetNWBool("Decaying", not tc.Protected)
            tcs[#tcs + 1] = tc
            for ply in pairs(tc.Viewers or {}) do
                if IsValid(ply) then
                    SendCupboard(ply, tc)
                else
                    tc.Viewers[ply] = nil
                end
            end
        end
    end

    -- 2. decay pieces that no protected cupboard covers
    local frac = RustCupboard.DecayPerHour * RustCupboard.UpkeepTick / 3600
    local r2 = RustCupboard.BuildRadius ^ 2
    for class in pairs(RustCupboard.PieceBase) do
        for _, e in ipairs(ents.FindByClass(class)) do
            local covered, protected = false, false
            for _, tc in ipairs(tcs) do
                if e:GetPos():DistToSqr(tc:GetPos()) <= r2 then
                    covered = true
                    if tc.Protected then
                        protected = true
                        break
                    end
                end
            end

            local decay = (covered and not protected) or (not covered and RustCupboard.DecayNoTC)
            if decay and hook.Run("RustCupboardDecayPiece", e, frac) ~= true then DecayPiece(e, frac) end
        end
    end
end)