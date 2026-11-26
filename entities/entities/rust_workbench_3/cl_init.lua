include("shared.lua")

local RUST_DARK = Color(25, 25, 25, 250)
local RUST_DARKER = Color(18, 18, 18, 250)
local RUST_ITEM_BG = Color(40, 40, 40, 250)
local RUST_ITEM_HOVER = Color(55, 55, 55, 250)
local RUST_SELECTED = Color(0, 110, 110, 255)
local RUST_ACCENT = Color(0, 150, 150, 255)
local RUST_TEXT = Color(210, 210, 190, 255)
local RUST_TEXT_DIM = Color(140, 140, 130, 255)
local RUST_GREEN = Color(100, 200, 100, 255)
local RUST_RED = Color(200, 80, 80, 255)
local RUST_ORANGE = Color(220, 160, 60, 255)

local WorkbenchPanel = nil
local CurrentWorkbench = nil
local SelectedCategory = nil
local ExpandedCategories = {}
local PlayerInventory = {}
local CraftQueue = {}

local function GetPlayerInventory()
    local ply = LocalPlayer()
    if not IsValid(ply) then return {} end
    return ply.GRustInventory or {}
end

local function GetItemCount(itemID)
    local inv = GetPlayerInventory()
    local count = 0
    for _, v in pairs(inv) do
        if v.Inventory and v.Inventory.id == itemID then
            count = count + (v.Inventory.Count or 0)
        end
    end
    return count
end

local function CanCraftItem(item)
    if not item.Craft then return false, "No recipe" end
    local craftData = item.Craft()
    if not craftData then return false, "No recipe data" end

    for _, category in ipairs(craftData) do
        if istable(category) then
            for _, req in ipairs(category) do
                if istable(req) and req.ITEM and req.AMOUNT then
                    local has = GetItemCount(req.ITEM)
                    if has < req.AMOUNT then
                        return false, "Need " .. req.ITEM .. " (" .. has .. "/" .. req.AMOUNT .. ")"
                    end
                end
            end
        end
    end
    return true, "OK"
end

local function GetCraftTime(item)
    if not item.Craft then return 10 end
    local craftData = item.Craft()
    if craftData and craftData[1] and craftData[1].Time then
        return craftData[1].Time
    end
    return 10
end

local function GetCraftRequirements(item)
    local reqs = {}
    if not item.Craft then return reqs end
    local craftData = item.Craft()
    if not craftData then return reqs end

    for _, category in ipairs(craftData) do
        if istable(category) then
            for _, req in ipairs(category) do
                if istable(req) and req.ITEM and req.AMOUNT then
                    local has = GetItemCount(req.ITEM)
                    table.insert(reqs, {
                        item = req.ITEM,
                        need = req.AMOUNT,
                        have = has
                    })
                end
            end
        end
    end
    return reqs
end

local function CreateExpandableCategory(parent, categoryName, items)
    local container = vgui.Create("DPanel", parent)
    container:Dock(TOP)
    container:SetTall(30)
    container.Items = items
    container.Expanded = ExpandedCategories[categoryName] or false
    container.CategoryName = categoryName
    container.ChildPanels = {}

    local header = vgui.Create("DButton", container)
    header:Dock(TOP)
    header:SetTall(30)
    header:SetText("")
    header.Paint = function(s, w, h)
        local bg = container.Expanded and RUST_SELECTED or RUST_ITEM_BG
        if s:IsHovered() and not container.Expanded then bg = RUST_ITEM_HOVER end
        surface.SetDrawColor(bg)
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(RUST_ACCENT)
        surface.DrawRect(0, 0, 3, h)

        local icon = container.Expanded and "▼" or "▶"
        draw.SimpleText(icon .. "  " .. categoryName .. " (" .. #items .. ")", "DermaDefaultBold", 15, h / 2, RUST_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

        local craftable = 0
        for _, item in ipairs(items) do
            local can, _ = CanCraftItem(item)
            if can then craftable = craftable + 1 end
        end
        draw.SimpleText(craftable .. " craftable", "DermaDefault", w - 15, h / 2, RUST_TEXT_DIM, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end
    header.DoClick = function()
        container.Expanded = not container.Expanded
        ExpandedCategories[categoryName] = container.Expanded
        container:InvalidateLayout(true)
        parent:InvalidateLayout(true)
    end

    local content = vgui.Create("DPanel", container)
    content:Dock(TOP)
    content:SetVisible(container.Expanded)
    content.Paint = function() end

    container.PerformLayout = function(s, w, h)
        local headerH = 30
        header:SetTall(headerH)
        if container.Expanded then
            local childH = 0
            for _, child in ipairs(container.ChildPanels) do
                if IsValid(child) then
                    childH = childH + child:GetTall() + 2
                end
            end
            content:SetTall(childH)
            content:SetVisible(true)
            s:SetTall(headerH + childH)
        else
            content:SetTall(0)
            content:SetVisible(false)
            s:SetTall(headerH)
        end
    end

    local grid = vgui.Create("DIconLayout", content)
    grid:Dock(FILL)
    grid:SetSpaceX(4)
    grid:SetSpaceY(4)
    grid:SetBorder(4)

    for _, item in ipairs(items) do
        local canCraft, reason = CanCraftItem(item)
        local craftTime = GetCraftTime(item)
        local reqs = GetCraftRequirements(item)

        local btn = grid:Add("DButton")
        btn:SetSize(140, 160)
        btn:SetText("")
        btn.Item = item
        btn.CanCraft = canCraft
        btn.Reason = reason
        btn.CraftTime = craftTime
        btn.Requirements = reqs

        btn.Paint = function(s, w, h)
            local bg = RUST_ITEM_BG
            if s:IsHovered() then
                bg = canCraft and RUST_ACCENT or RUST_ITEM_HOVER
            end
            surface.SetDrawColor(bg)
            surface.DrawRect(0, 0, w, h)

            if not canCraft then
                surface.SetDrawColor(RUST_RED)
                surface.DrawRect(0, 0, w, 2)
            end

            local mat = Material(item.model or "materials/items/tools/rock.png", "smooth")
            if mat and not mat:IsError() then
                surface.SetMaterial(mat)
                surface.SetDrawColor(color_white)
                surface.DrawTexturedRect(10, 10, w - 20, w - 20)
            end

            draw.SimpleText(item.Name or "Unknown", "DermaDefault", w / 2, w + 5, RUST_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

            local timeText = string.format("%.0fs", craftTime)
            draw.SimpleText(timeText, "DermaDefault", w / 2, w + 22, RUST_TEXT_DIM, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

            local missing = 0
            for _, req in ipairs(reqs) do
                if req.have < req.need then missing = missing + 1 end
            end
            if missing > 0 then
                draw.SimpleText("Missing: " .. missing, "DermaDefault", w / 2, h - 18, RUST_RED, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            else
                draw.SimpleText("Ready to craft", "DermaDefault", w / 2, h - 18, RUST_GREEN, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
            end
        end

        btn.DoClick = function()
            if not canCraft then
                surface.PlaySound("buttons/button10.wav")
                return
            end
            surface.PlaySound("ui/buttonclick.wav")
            net.Start("Workbench_CraftItem")
            net.WriteEntity(CurrentWorkbench)
            net.WriteString(item.InfoTag)
            net.SendToServer()
        end

        btn.DoRightClick = function()
            local menu = DermaMenu()
            menu:AddOption("View Requirements", function()
                local reqPanel = vgui.Create("DFrame")
                reqPanel:SetSize(300, 200)
                reqPanel:Center()
                reqPanel:SetTitle(item.Name .. " Requirements")
                reqPanel:MakePopup()

                local scroll = vgui.Create("DScrollPanel", reqPanel)
                scroll:Dock(FILL)
                scroll:DockMargin(10, 10, 10, 10)

                for _, req in ipairs(reqs) do
                    local row = vgui.Create("DPanel", scroll)
                    row:Dock(TOP)
                    row:SetTall(30)
                    row:DockMargin(0, 2, 0, 2)
                    row.Paint = function(s, w, h)
                        surface.SetDrawColor(RUST_ITEM_BG)
                        surface.DrawRect(0, 0, w, h)
                        local haveColor = req.have >= req.need and RUST_GREEN or RUST_RED
                        draw.SimpleText(req.item, "DermaDefault", 10, h / 2, RUST_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
                        draw.SimpleText(req.have .. " / " .. req.need, "DermaDefault", w - 10, h / 2, haveColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
                    end
                end
            end)
            menu:Open()
        end

        table.insert(container.ChildPanels, btn)
    end

    return container
end

local function BuildWorkbenchUI(workbench)
    if IsValid(WorkbenchPanel) then WorkbenchPanel:Remove() end

    CurrentWorkbench = workbench
    PlayerInventory = GetPlayerInventory()
    ExpandedCategories = {}

    local scrW, scrH = ScrW(), ScrH()
    WorkbenchPanel = vgui.Create("DFrame")
    WorkbenchPanel:SetSize(scrW * 0.85, scrH * 0.85)
    WorkbenchPanel:Center()
    WorkbenchPanel:SetTitle("")
    WorkbenchPanel:MakePopup()
    WorkbenchPanel:ShowCloseButton(false)
    WorkbenchPanel.Paint = function(s, w, h)
        surface.SetDrawColor(Color(0, 0, 0, 220))
        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(RUST_DARK)
        surface.DrawRect(w * 0.02, h * 0.02, w * 0.96, h * 0.96)
    end

    local closeBtn = vgui.Create("DButton", WorkbenchPanel)
    closeBtn:SetSize(40, 40)
    closeBtn:SetPos(WorkbenchPanel:GetWide() - 50, 10)
    closeBtn:SetText("")
    closeBtn.Paint = function(s, w, h)
        local col = RUST_ITEM_BG
        if s:IsHovered() then col = Color(180, 50, 50, 255) end
        surface.SetDrawColor(col)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(RUST_TEXT)
        surface.DrawLine(10, 10, w - 10, h - 10)
        surface.DrawLine(w - 10, 10, 10, h - 10)
    end
    closeBtn.DoClick = function()
        net.Start("Workbench_CloseUI")
        net.WriteEntity(workbench)
        net.SendToServer()
        WorkbenchPanel:Remove()
    end

    local title = vgui.Create("DLabel", WorkbenchPanel)
    title:SetPos(20, 15)
    title:SetSize(400, 30)
    title:SetText("WORKBENCH LEVEL " .. (workbench.WorkbenchLevel or 1))
    title:SetFont("DermaLarge")
    title:SetTextColor(RUST_TEXT)

    local health = workbench:GetHealthz() or 0
    local maxHealth = workbench:GetMaxHealthz() or 250
    local healthPct = math.Clamp(health / maxHealth, 0, 1)

    local healthBar = vgui.Create("DPanel", WorkbenchPanel)
    healthBar:SetPos(20, 50)
    healthBar:SetSize(300, 20)
    healthBar.Paint = function(s, w, h)
        surface.SetDrawColor(RUST_DARKER)
        surface.DrawRect(0, 0, w, h)
        surface.SetDrawColor(healthPct > 0.5 and RUST_GREEN or (healthPct > 0.25 and RUST_ORANGE or RUST_RED))
        surface.DrawRect(0, 0, w * healthPct, h)
        draw.SimpleText("HP: " .. math.floor(health) .. " / " .. maxHealth, "DermaDefault", w / 2, h / 2, RUST_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    local leftPanel = vgui.Create("DPanel", WorkbenchPanel)
    leftPanel:SetPos(scrW * 0.02 + 10, 80)
    leftPanel:SetSize(scrW * 0.3, scrH * 0.85 - 100)
    leftPanel.Paint = function(s, w, h)
        surface.SetDrawColor(RUST_DARKER)
        surface.DrawRect(0, 0, w, h)
    end

    local categories = {}
    for _, v in pairs(ITEMS or {}) do
        if istable(v) and v.Category and v.InfoTag then
            if v.Category ~= "ADMIN" or LocalPlayer():IsAdmin() then
                categories[v.Category] = categories[v.Category] or {}
                table.insert(categories[v.Category], v)
            end
        end
    end

    local catScroll = vgui.Create("DScrollPanel", leftPanel)
    catScroll:Dock(FILL)
    catScroll:DockMargin(5, 5, 5, 5)
    local sbar = catScroll:GetVBar()
    sbar:SetHideButtons(true)
    sbar.Paint = function(s, w, h) surface.SetDrawColor(RUST_DARKER); surface.DrawRect(0, 0, w, h) end
    sbar.btnGrip.Paint = function(s, w, h) surface.SetDrawColor(RUST_ITEM_BG); surface.DrawRect(2, 0, w - 4, h) end

    local categoryOrder = {"Tools", "Construction", "Weapons", "Attire", "Medical", "Food", "Resources", "Electrical", "Traps", "Misc"}
    for _, catName in ipairs(categoryOrder) do
        if categories[catName] and #categories[catName] > 0 then
            local catPanel = CreateExpandableCategory(catScroll, catName, categories[catName])
            catPanel:Dock(TOP)
            catPanel:DockMargin(0, 0, 0, 4)
        end
    end

    for catName, items in pairs(categories) do
        if not table.HasValue(categoryOrder, catName) and #items > 0 then
            local catPanel = CreateExpandableCategory(catScroll, catName, items)
            catPanel:Dock(TOP)
            catPanel:DockMargin(0, 0, 0, 4)
        end
    end

    local rightPanel = vgui.Create("DPanel", WorkbenchPanel)
    rightPanel:SetPos(scrW * 0.02 + 10 + scrW * 0.3 + 10, 80)
    rightPanel:SetSize(scrW * 0.85 - scrW * 0.3 - 30, scrH * 0.85 - 100)
    rightPanel.Paint = function(s, w, h)
        surface.SetDrawColor(RUST_ITEM_BG)
        surface.DrawRect(0, 0, w, h)
        draw.SimpleText("Select an item to view details", "DermaLarge", w / 2, h / 2, RUST_TEXT_DIM, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    WorkbenchPanel.OnRemove = function()
        net.Start("Workbench_CloseUI")
        net.WriteEntity(workbench)
        net.SendToServer()
    end
end

net.Receive("Workbench_OpenUI", function()
    local workbench = net.ReadEntity()
    if IsValid(workbench) then
        BuildWorkbenchUI(workbench)
    end
end)

net.Receive("Workbench_CloseUI", function()
    if IsValid(WorkbenchPanel) then
        WorkbenchPanel:Remove()
    end
end)

net.Receive("Workbench_CraftItem", function()
    local workbench = net.ReadEntity()
    local itemID = net.ReadString()
    local craftTime = net.ReadFloat()

    if IsValid(WorkbenchPanel) then
        local craftIndicator = vgui.Create("DPanel", WorkbenchPanel)
        craftIndicator:SetSize(300, 60)
        craftIndicator:Center()
        craftIndicator:SetPos(craftIndicator:GetX(), craftIndicator:GetY() - 100)
        craftIndicator.StartTime = CurTime()
        craftIndicator.EndTime = CurTime() + craftTime
        craftIndicator.ItemID = itemID

        craftIndicator.Paint = function(s, w, h)
            local progress = math.Clamp((CurTime() - s.StartTime) / (s.EndTime - s.StartTime), 0, 1)
            surface.SetDrawColor(RUST_DARK)
            surface.DrawRect(0, 0, w, h)
            surface.SetDrawColor(RUST_ACCENT)
            surface.DrawRect(0, 0, w * progress, h)
            draw.SimpleText("Crafting " .. itemID .. "...", "DermaDefaultBold", w / 2, h / 2 - 10, RUST_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText(math.ceil(s.EndTime - CurTime()) .. "s", "DermaDefault", w / 2, h / 2 + 10, RUST_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        timer.Simple(craftTime, function()
            if IsValid(craftIndicator) then craftIndicator:Remove() end
        end)
    end
end)

net.Receive("Workbench_CraftComplete", function()
    LocalPlayer():EmitSound("ui/crafting_complete.wav", 75, 100)
    if IsValid(WorkbenchPanel) then
        BuildWorkbenchUI(CurrentWorkbench)
    end
end)

hook.Add("OnSpawnMenuClose", "WorkbenchClose", function()
    if IsValid(WorkbenchPanel) then
        WorkbenchPanel:Remove()
    end
end)