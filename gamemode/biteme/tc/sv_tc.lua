util.AddNetworkString("gRustCupboard")
util.AddNetworkString("gRustCupboardMove")
util.AddNetworkString("gRustCupboardClose")
util.AddNetworkString("gRustCupboardDrop")
RustCupboard = RustCupboard or {}
-- cost per 24 hours (matches the screenshot)
RustCupboard.Cost = {
    {
        id = "Wood",
        name = "Wood",
        amount = 35
    },
    {
        id = "Stone",
        name = "Stone",
        amount = 660
    },
    {
        id = "MetalOre",
        name = "Metal Fragments",
        amount = 1529
    },
}

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

-- seconds until the scarcest resource runs out
function RustCupboard.ProtectedSeconds(ent)
    local best = math.huge
    for _, c in ipairs(RustCupboard.Cost) do
        local secs = RustCupboard.Count(ent, c.id) / c.amount * 86400
        best = math.min(best, secs)
    end
    return math.floor(best == math.huge and 0 or best)
end

-- hand an item to the player. Hook this into your own inventory.
-- cupboard -> player inventory
function RustCupboard.GiveToPlayer(ply, item)
    return AddItemsToGmodCount(ply, item.id, item.dur or 100, nil, item.amount) and true or false
end

-- player inventory -> cupboard (takes the whole stack, same as your furnace "put")
function RustCupboard.TakeFromPlayer(ply, name)
    if not name or name == "" then
        print("[TC] no item name")
        return
    end

    local def = RustOfficial.GetItem(name)
    if not def then
        print("[TC] unknown item id:", name)
        return
    end

    local has, amount = CalcItem(ply, name)
    print("[TC] CalcItem", name, has, amount)
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
    RustCupboard.Init(ent)
    net.Start("gRustCupboard")
    net.WriteEntity(ent)
    net.WriteUInt(math.min(RustCupboard.ProtectedSeconds(ent), 4294967295), 32)
    net.WriteTable(RustCupboard.Cost)
    net.WriteTable(ent.ToolRow)
    net.WriteTable(ent.Grid)
    net.Send(ply)
end

net.Receive("gRustCupboardMove", function(_, ply)
    local ent = net.ReadEntity()
    local kind = net.ReadString()
    local idx = net.ReadUInt(8)
    print("[TC] move msg", ply, ent)
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

-- ---------- test command: look at a cupboard, then
-- rust_cupboard_add wood 500   (superadmin only)
concommand.Add("rust_cupboard_add", function(ply, _, args)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    local ent = IsValid(ply) and ply:GetEyeTrace().Entity
    if not IsValid(ent) or ent:GetClass() ~= "ent_rust_cupboard" then return end
    local id, amount = args[1], tonumber(args[2] or 0)
    for _, c in ipairs(RustCupboard.Cost) do
        if c.id == id and amount and amount > 0 then
            RustCupboard.AddItem(ent, c.id, c.name, amount, c.mat)
            SendCupboard(ply, ent)
            return
        end
    end
end)

-- ADAPTER: remove the item in the player's inventory slot and return
-- { id = "wood", name = "Wood", amount = 100, mat = "..." } or nil.
-- Replace the body with a call into your grust inventory.
net.Receive("gRustCupboardDrop", function(_, ply)
    print("[TC] drop msg received", ply)
    local ent = net.ReadEntity()
    local toKind = net.ReadString()
    local toIdx = net.ReadUInt(8)
    local fromKind = net.ReadString()
    local fromIdx = net.ReadUInt(8)
    local invName = net.ReadString()
    print("[TC drop]", ply, fromKind, fromIdx, invName)
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

concommand.Add("dump_grust_sv", function(ply)
    if IsValid(ply) and not ply:IsSuperAdmin() then return end
    for name, fn in pairs(net.Receivers) do
        if string.find(name, "grust", 1, true) then
            local info = debug.getinfo(fn, "S")
            print("=== " .. name, info.short_src, info.linedefined, info.lastlinedefined)
            local txt = file.Read(info.short_src, "GAME")
            if txt then
                local lines = string.Explode("\n", txt)
                for i = info.linedefined, info.lastlinedefined do
                    print(lines[i])
                end
            end
        end
    end
end)

concommand.Add("tc_dump", function(ply)
    local ent = IsValid(ply) and ply:GetEyeTrace().Entity
    if not IsValid(ent) or not ent.Grid then return end
    for i, it in pairs(ent.Grid) do
        print("[TC items]", i, it.id, it.name, it.amount)
    end
end)