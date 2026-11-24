if SERVER then return end
local COLS, ROWS = 6, 8
local SLOT, GAP = 62, 4
local HEADER = 56
local BOX_DRAG = "grust_item"
BoxPanel = BoxPanel or {}
function GRUST_CloseLargeBox()
    if IsValid(BoxPanel) then BoxPanel:Remove() end
    BoxPanel = nil
end

function GRUST_OpenLargeBox(ent)
    GRUST_CloseLargeBox()
    OpenInventory()
    local w = COLS * (SLOT + GAP) + GAP + 16
    local h = HEADER + ROWS * (SLOT + GAP) + GAP + 8
    BoxPanel = vgui.Create("DPanel", GRUST_TEST)
    BoxPanel:SetSize(w, h)
    BoxPanel:SetPos(ScrW() - w - 40, (ScrH() - h) / 2)
    BoxPanel:SetMouseInputEnabled(true)
    BoxPanel:MoveToFront()
    BoxPanel.BoxEnt = ent
    BoxPanel.HasEnt = IsValid(ent)
    BoxPanel.Items = {}
    BoxPanel.Slots = {}
    BoxPanel.ItemPanels = {}
    BoxPanel.Paint = function(s, pw, ph)
        draw.RoundedBox(0, 0, 0, pw, ph, Color(30, 30, 30, 200))
        draw.SimpleText("LOOT", "DermaDefaultBold", 8, 6, color_white)
        surface.SetDrawColor(0, 0, 0, 140)
        surface.DrawRect(0, 24, pw, 26)
        draw.SimpleText("Large Wooden Box", "DermaDefaultBold", 8, 37, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    for i = 1, COLS * ROWS do
        local col = (i - 1) % COLS
        local row = math.floor((i - 1) / COLS)
        local slot = vgui.Create("DPanel", BoxPanel)
        slot:SetSize(SLOT, SLOT)
        slot:SetPos(8 + GAP + col * (SLOT + GAP), HEADER + GAP + row * (SLOT + GAP))
        slot.SlotID = i
        slot.BoxEnt = ent
        slot.Paint = function(s, sw, sh)
            surface.SetDrawColor(55, 58, 52, 230)
            surface.DrawRect(0, 0, sw, sh)
            if s:IsHovered() then
                surface.SetDrawColor(255, 255, 255, 30)
                surface.DrawRect(0, 0, sw, sh)
            end
        end

        slot:SetMouseInputEnabled(true)
        slot.OnMousePressed = function(s, code)
            if code ~= MOUSE_RIGHT then return end
            if not IsValid(BoxPanel) or not BoxPanel.Items[s.SlotID] then return end
            net.Start("grust_LargeBoxTake")
            net.WriteEntity(BoxPanel.BoxEnt)
            net.WriteUInt(s.SlotID, 6)
            net.SendToServer()
        end

        slot:Receiver(BOX_DRAG, function(s, panels, dropped)
            if not dropped then return end
            local from = panels[1]
            if not IsValid(from) then return end
            local fromSlot = from:GetParent()
            if not IsValid(fromSlot) or not fromSlot.SlotID then return end

            net.Start("grust_LargeBoxMove")
            net.WriteEntity(BoxPanel.BoxEnt)
            net.WriteUInt(fromSlot.Container or 0, 2)
            net.WriteUInt(fromSlot.SlotID, 8)
            net.WriteUInt(s.SlotID, 6)
            net.SendToServer()
        end)

        BoxPanel.Slots[i] = slot
    end
end

local function BuildBoxItemPanels()
    if not IsValid(BoxPanel) then return end
    for i, panel in pairs(BoxPanel.ItemPanels or {}) do
        if IsValid(panel) then panel:Remove() end
    end
    BoxPanel.ItemPanels = {}

    for slotID, item in pairs(BoxPanel.Items or {}) do
        local slot = BoxPanel.Slots[slotID]
        if not IsValid(slot) then continue end

        local itemPanel = vgui.Create("DPanel", slot)
        itemPanel:SetSize(SLOT - 8, SLOT - 8)
        itemPanel:SetPos(4, 4)
        itemPanel.ItemID = item.id
        itemPanel:Droppable(BOX_DRAG)
        itemPanel.OnMousePressed = function(self, code)
            if code ~= MOUSE_LEFT then return end
            self:MouseCapture(true)
            self:DragMousePress(code)
        end
        itemPanel.OnMouseReleased = function(self, code)
            self:MouseCapture(false)
            self:DragMouseRelease(code)
        end
        itemPanel.Paint = function(_, w, h)
            local def = RustOfficial.GetItem(item.id)
            if def and def.image then
                local mat = Material(def.image)
                if mat and not mat:IsError() then
                    surface.SetDrawColor(255, 255, 255)
                    surface.SetMaterial(mat)
                    surface.DrawTexturedRect(4, 4, w - 8, h - 8)
                end
            end
            draw.SimpleText("x" .. item.amt, "DermaDefaultBold", w - 4, h - 4, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
        end

        BoxPanel.ItemPanels[slotID] = itemPanel
    end
end

net.Receive("grust_OpenLargeBox", function() GRUST_OpenLargeBox(net.ReadEntity()) end)
net.Receive("grust_LargeBoxSync", function()
    local ent = net.ReadEntity()
    local items = {}
    for _ = 1, net.ReadUInt(6) do
        local slot = net.ReadUInt(6)
        items[slot] = {
            id = net.ReadString(),
            amt = net.ReadUInt(16)
        }
    end
    if IsValid(BoxPanel) and BoxPanel.BoxEnt == ent then
        BoxPanel.Items = items
        BuildBoxItemPanels()
    end
end)

hook.Add("Think", "grust_largebox_autoclose", function()
    if not IsValid(BoxPanel) or not BoxPanel.HasEnt then return end
    local ent = BoxPanel.BoxEnt
    if not IsValid(ent) or ent:GetPos():DistToSqr(LocalPlayer():GetPos()) > 200 * 200 then GRUST_CloseLargeBox() end
end)

concommand.Add("grust_testbox", function() GRUST_OpenLargeBox(NULL) end)
concommand.Add("grust_closebox", GRUST_CloseLargeBox)
