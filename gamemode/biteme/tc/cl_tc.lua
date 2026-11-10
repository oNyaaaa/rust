surface.CreateFont("RC_Title", {
    font = "Roboto Condensed",
    size = 26,
    weight = 800
})

surface.CreateFont("RC_Head", {
    font = "Roboto Condensed",
    size = 16,
    weight = 800
})

surface.CreateFont("RC_Text", {
    font = "Roboto Condensed",
    size = 15,
    weight = 500
})

surface.CreateFont("RC_Amt", {
    font = "Roboto Condensed",
    size = 14,
    weight = 700
})

local C_BG = Color(38, 38, 36, 250)
local C_BOX = Color(58, 58, 55, 255)
local C_SLOT = Color(72, 74, 69, 255)
local C_HOVER = Color(110, 120, 90, 255)
local C_TXT = Color(195, 195, 190)
local C_GREEN = Color(150, 230, 30)
local C_RED = Color(230, 70, 50)
local function FormatTime(s)
    s = math.max(0, math.floor(s))
    return string.format("%dd %dh %dm %ds", math.floor(s / 86400), math.floor(s % 86400 / 3600), math.floor(s % 3600 / 60), s % 60)
end

local function DrawItem(item, x, y, w, h)
    if not item then return end
    if item.mat then
        surface.SetMaterial(Material(item.mat))
        surface.SetDrawColor(255, 255, 255)
        surface.DrawTexturedRect(x + 4, y + 4, w - 8, h - 8)
    else
        draw.SimpleText(string.sub(item.name or "?", 1, 3), "RC_Head", x + w / 2, y + h / 2, C_TXT, 1, 1)
    end

    if item.amount and item.amount > 1 then draw.SimpleText("x" .. item.amount, "RC_Amt", x + w - 4, y + h - 3, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGNMENT_BOTTOM or 4) end
end

local function CloseCupboard()
    if IsValid(RUST_CUPBOARD) then RUST_CUPBOARD:Remove() end
end

local function OpenCupboard(ent, cost, protectedUntil, toolRow, grid)
    if IsValid(RUST_CUPBOARD) then RUST_CUPBOARD:Remove() end
    local W, H = 340, 640
    local f = vgui.Create("DFrame")
    RUST_CUPBOARD = f
    f:SetSize(W, H)
    f:SetPos(ScrW() - W - 40, ScrH() / 2 - H / 2)
    f:SetTitle("")
    f:ShowCloseButton(false)
    f:SetDraggable(false)
    f:MakePopup()
    f:SetKeyboardInputEnabled(false)
    f.Ent = ent
    f.CupSlots = {}
    f.HandleDrop = function(self, p)
        local mx, my = gui.MousePos()
        local fx, fy = self:LocalToScreen(0, 0)
        local inside = mx >= fx and my >= fy and mx < fx + self:GetWide() and my < fy + self:GetTall()
        if not inside then return false end
        for _, slot in ipairs(self:GetChildren()) do
            if slot.CupKind then
                local x, y = slot:LocalToScreen(0, 0)
                if mx >= x and mx < x + slot:GetWide() and my >= y and my < y + slot:GetTall() then
                    net.Start("gRustCupboardDrop")
                    net.WriteEntity(ent)
                    net.WriteString(slot.CupKind)
                    net.WriteUInt(slot.CupIndex, 8)
                    net.WriteString(p.CupKind or "inv")
                    net.WriteUInt(p.CupIndex or 0, 8)
                    net.WriteString(p.ItemID or "")
                    net.SendToServer()
                    return true
                end
            end
        end
        return true
    end

    f.Deposit = function(self, p)
        if not IsValid(p) or not p.ItemID then return end
        net.Start("gRustCupboardDrop")
        net.WriteEntity(ent)
        net.WriteString("grid")
        net.WriteUInt(0, 8) -- 0 = server picks the slot
        net.WriteString("inv")
        net.WriteUInt(0, 8)
        net.WriteString(p.ItemID)
        net.SendToServer()
    end

    f.OnRemove = function(self)
        if IsValid(self.Ent) then
            net.Start("gRustCupboardClose")
            net.WriteEntity(self.Ent)
            net.SendToServer()
        end
    end

    local close = vgui.Create("DButton", f)
    close:SetSize(28, 28)
    close:SetPos(W - 36, 8)
    close:SetText("")
    close.Paint = function(s, w, h)
        draw.RoundedBox(0, 0, 0, w, h, s:IsHovered() and C_RED or C_SLOT)
        draw.SimpleText("X", "RC_Head", w / 2, h / 2, color_white, 1, 1)
    end

    close.DoClick = CloseCupboard
    f.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, C_BG)
        draw.SimpleText("LOOT", "RC_Title", 12, 8, color_white)
        -- upkeep header
        draw.RoundedBox(0, 8, 44, w - 16, 22, C_BOX)
        draw.SimpleText("UPKEEP MANAGEMENT", "RC_Head", 16, 48, color_white)
        -- info box
        draw.RoundedBox(0, 8, 70, w - 16, 62, Color(50, 50, 48))
        draw.RoundedBox(16, 20, 84, 32, 32, Color(110, 110, 105))
        draw.SimpleText("i", "RC_Title", 36, 100, Color(50, 50, 48), 1, 1)
        draw.DrawText("Maintain the required amount of resources to\nprevent your base from decaying over time.\nBases left unattended without enough upkeep\nresources will be destroyed.", "RC_Text", 66, 76, C_TXT)
        -- cost box
        draw.RoundedBox(0, 8, 138, w - 16, 96, C_BOX)
        draw.SimpleText("Cost per 24 hours", "RC_Head", w / 2, 146, color_white, 1)
        local n = #cost
        local startX = w / 2 - (n * 60) / 2
        for i, c in ipairs(cost) do
            local x = startX + (i - 1) * 60
            local def = RustOfficial and RustOfficial.GetItem(c.id)
            if def and def.image then
                surface.SetMaterial(Material(def.image))
                surface.SetDrawColor(255, 255, 255)
                surface.DrawTexturedRect(x + 14, 168, 28, 28)
            end

            draw.SimpleText("x" .. c.amount, "RC_Amt", x + 28, 200, color_white, 1)
        end

        local left = protectedUntil - CurTime()
        if left > 0 then
            draw.SimpleText("Protected for " .. FormatTime(left), "RC_Head", w / 2, 214, C_GREEN, 1)
        else
            draw.SimpleText("NOT PROTECTED - DECAYING", "RC_Head", w / 2, 214, C_RED, 1)
        end
    end

    local function MakeSlot(parent, x, y, size, item, index, kind)
        local s = vgui.Create("DButton", parent)
        s:SetPos(x, y)
        s:SetSize(size, size)
        s:SetText("")
        s.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, (function()
                local mx, my = self:CursorPos()
                return mx >= 0 and my >= 0 and mx < w and my < h
            end)() and C_HOVER or C_SLOT)

            DrawItem(item, 0, 0, w, h)
        end

        s.CupKind, s.CupIndex = kind, index
        s.takeFn = function()
            if not item then return end
            s.TakeSent = CurTime()
            net.Start("gRustCupboardMove")
            net.WriteEntity(ent)
            net.WriteString(kind)
            net.WriteUInt(index, 8)
            net.SendToServer()
            item = nil -- hide it right away; the server refresh confirms or restores it
        end

        s.OnMousePressed = function(self, code)
            if item and code == MOUSE_LEFT then
                TC_GHOST = item
                self:MouseCapture(true)
                self:DragMousePress(code)
            end
        end

        s.OnMouseReleased = function(self, code)
            self:MouseCapture(false)
            if not item then return end
            self:DragMouseRelease(code)
            if code ~= MOUSE_LEFT then return end
            timer.Simple(0, function()
                if not IsValid(self) or (self.TakeSent or 0) > CurTime() - 0.3 then return end
                local mx, my = gui.MousePos()
                local fx, fy = parent:LocalToScreen(0, 0)
                if mx < fx or my < fy or mx > fx + parent:GetWide() or my > fy + parent:GetTall() then self.takeFn() end
            end)

            TC_GHOST = nil
        end

        s:Receiver("grust_item", function(self, panels, dropped)
            if not dropped then return end
            local p = panels[1]
            if not IsValid(p) then return end
            net.Start("gRustCupboardDrop")
            net.WriteEntity(ent)
            net.WriteString(kind)
            net.WriteUInt(index, 8)
            net.WriteString(p.CupKind or "inv")
            net.WriteUInt(p.CupIndex or 0, 8)
            net.WriteString(p.ItemID or "")
            net.SendToServer()
        end)

        s.DoRightClick = function()
            net.Start("gRustCupboardMove")
            net.WriteEntity(ent)
            net.WriteString(kind)
            net.WriteUInt(index, 8)
            net.SendToServer()
        end
        return s
    end

    -- top toolbox row (first slot is the icon, 5 item slots after)
    local x0, y0, size, gap = 8, 244, 50, 4
    local icon = vgui.Create("DPanel", f)
    icon:SetPos(x0, y0)
    icon:SetSize(size, size)
    icon.Paint = function(_, w, h)
        draw.RoundedBox(0, 0, 0, w, h, C_BOX)
        draw.SimpleText("[+]", "RC_Head", w / 2, h / 2, Color(120, 120, 115), 1, 1)
    end

    for i = 1, 5 do
        MakeSlot(f, x0 + i * (size + gap) + 2, y0, size, toolRow[i], i, "tool")
    end

    -- main grid 6 x 5
    local gy = y0 + size + 18
    for i = 0, 29 do
        local col, row = i % 6, math.floor(i / 6)
        MakeSlot(f, x0 + col * (size + gap) + 2, gy + row * (size + gap), size, grid[i + 1], i + 1, "grid")
    end

    f.NextClose = CurTime() + 0.5
    f.Think = function(self)
        if (self.DbgT or 0) < CurTime() then self.DbgT = CurTime() + 1 end
        if gui.IsGameUIVisible() then
            gui.HideGameUI()
            CloseCupboard()
            return
        end

        if not IsValid(ent) or LocalPlayer():GetPos():DistToSqr(ent:GetPos()) > 40000 then
            CloseCupboard()
            return
        end

        if input.IsKeyDown(KEY_E) then
            if self.Armed and self.NextClose < CurTime() then CloseCupboard() end
        else
            self.Armed = true
        end
    end
end

net.Receive("gRustCupboard", function()
    local ent = net.ReadEntity()
    local until_ = CurTime() + net.ReadUInt(32)
    local cost = net.ReadTable()
    local tools = net.ReadTable()
    local grid = net.ReadTable()
    OpenCupboard(ent, cost, until_, tools, grid)
    timer.Simple(0.05, function() if not IsValid(GRUST_TEST) then hook.Run("ScoreboardShow") end end)
end)

hook.Add("PostRenderVGUI", "TC_DragGhost", function()
    if not TC_GHOST then return end
    if not input.IsMouseDown(MOUSE_LEFT) or not IsValid(RUST_CUPBOARD) then
        TC_GHOST = nil
        return
    end

    local mx, my = gui.MousePos()
    surface.SetAlphaMultiplier(0.85)
    DrawItem(TC_GHOST, mx - 30, my - 30, 60, 60)
    surface.SetAlphaMultiplier(1)
end)

hook.Add("Think", "TC_DragDebug", function()
    local d = dragndrop.IsDragging()
    if d ~= TC_WasDragging then TC_WasDragging = d end
end)