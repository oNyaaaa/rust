if SERVER then return end
local COLS, ROWS = 6, 8
local SLOT, GAP = 62, 4
local HEADER = 56
local BOX_DRAG = "YourDragName" -- must match the name your inventory slots use in :Droppable("...")
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
    BoxPanel = vgui.Create("DPanel")
    BoxPanel:SetSize(w, h)
    BoxPanel:SetPos(ScrW() - w - 40, (ScrH() - h) / 2)
    BoxPanel.BoxEnt = ent
    BoxPanel.HasEnt = IsValid(ent)
    BoxPanel.Items = {}
    BoxPanel.Slots = {}
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
        slot.Paint = function(s, sw, sh)
            surface.SetDrawColor(55, 58, 52, 230)
            surface.DrawRect(0, 0, sw, sh)
            if s:IsHovered() then
                surface.SetDrawColor(255, 255, 255, 30)
                surface.DrawRect(0, 0, sw, sh)
            end

            local item = IsValid(BoxPanel) and BoxPanel.Items[s.SlotID]
            if item then
                draw.SimpleText(item.id, "DermaDefault", sw / 2, sh / 2 - 6, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText("x" .. item.amt, "DermaDefaultBold", sw - 4, sh - 4, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
            end
        end

        -- right click a filled slot to take it back
        slot:SetMouseInputEnabled(true)
        slot.OnMousePressed = function(s, code)
            if code ~= MOUSE_RIGHT then return end
            if not IsValid(BoxPanel) or not BoxPanel.Items[s.SlotID] then return end
            net.Start("grust_LargeBoxTake")
            net.WriteEntity(BoxPanel.BoxEnt)
            net.WriteUInt(s.SlotID, 6)
            net.SendToServer()
        end

        -- drag an inventory item onto a box slot
        slot:Receiver(BOX_DRAG, function(s, panels, dropped)
            if not dropped then return end
            local from = panels[1]
            if not IsValid(from) or not from.SlotID then -- change SlotID if your slots use another field name
                return
            end

            net.Start("grust_LargeBoxMove")
            net.WriteEntity(BoxPanel.BoxEnt)
            net.WriteUInt(from.SlotID, 8)
            net.WriteUInt(s.SlotID, 6)
            net.SendToServer()
        end)

        BoxPanel.Slots[i] = slot
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

    if IsValid(BoxPanel) and BoxPanel.BoxEnt == ent then BoxPanel.Items = items end
end)

-- close when you walk away or the box is removed (the test panel with no entity is left alone)
hook.Add("Think", "grust_largebox_autoclose", function()
    if not IsValid(BoxPanel) or not BoxPanel.HasEnt then return end
    local ent = BoxPanel.BoxEnt
    if not IsValid(ent) or ent:GetPos():DistToSqr(LocalPlayer():GetPos()) > 200 * 200 then GRUST_CloseLargeBox() end
end)

-- test the layout without an entity
concommand.Add("grust_testbox", function() GRUST_OpenLargeBox(NULL) end)
concommand.Add("grust_closebox", GRUST_CloseLargeBox)