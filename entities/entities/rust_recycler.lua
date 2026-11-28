AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Recycler"
ENT.Category = ""
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.INPUT = {}
ENT.OUTPUT = {}
if SERVER then
	util.AddNetworkString("DockMain")
	util.AddNetworkString("gRustRecycler")
	util.AddNetworkString("Rust_recyclerInv")
	util.AddNetworkString("DockTogglezzz")
	util.AddNetworkString("grust_RecyclerMove")
	util.AddNetworkString("DockRelease")
	function ENT:Initialize()
		self:SetModel("models/environment/misc/recycler.mdl")
		self:PhysicsInitStatic(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:EnableMotion(false)
		end

		self.InputSlots, self.OutputSlots = {}, {}
		self.CD = 0
		self.OccupiedBy = nil
	end

	function ENT:SendContents(ply)
		net.Start("DockMain")
		net.WriteEntity(self)
		net.WriteTable({
			on = self.On or false,
			input = self.InputSlots,
			output = self.OutputSlots,
		})
		net.Send(ply)
	end

	local SLOT_COUNT = {
		input = 6,
		output = 6
	}

	local RECIPES = {
		GarageDoor = {
			Metal = 25
		},
		MetalPipe = {
			Metal = 25
		},
		RoadSign = {
			Metal = 25
		},
		Furnace = {
			Stone = 100
		},
		ToolCupboard = {
			Wood = 50
		},
		Hammer = {
			Wood = 55
		},
	}

	local CYCLE_TIME = 5 -- seconds per recycle step
	local function CanFit(out, recipe)
		local empty = 0
		for i = 1, 6 do
			if not out[i] then empty = empty + 1 end
		end

		for id in pairs(recipe) do
			local has = false
			for i = 1, 6 do
				if out[i] and out[i].id == id then
					has = true
					break
				end
			end

			if not has then empty = empty - 1 end
		end
		return empty >= 0
	end

	local function AddOutput(out, id, amount)
		for i = 1, 6 do
			if out[i] and out[i].id == id then
				out[i].count = out[i].count + amount
				return
			end
		end

		for i = 1, 6 do
			if not out[i] then
				out[i] = {
					id = id,
					dur = 100,
					count = amount
				}
				return
			end
		end
	end

	net.Receive("grust_RecyclerMove", function(_, ply)
		local ent = net.ReadEntity()
		local mode = net.ReadString()
		local kind = net.ReadString()
		local idx = net.ReadUInt(4)
		local name = net.ReadString()
		if not IsValid(ent) or ent:GetClass() ~= "rust_recycler" or not ent.InputSlots then return end
		if ply:GetPos():DistToSqr(ent:GetPos()) > 250 * 250 then return end
		if not SLOT_COUNT[kind] or idx < 1 or idx > SLOT_COUNT[kind] then return end
		local tbl = ({
			input = ent.InputSlots,
			output = ent.OutputSlots
		})[kind]

		local slot = tbl[idx]
		if mode == "put" then
			if kind == "output" then return end
			if kind == "input" and not RECIPES[name] then return end
			if not RustOfficial.GetItem(name) then return end
			if slot and slot.id ~= name then return end
			local has, amount = CalcItem(ply, name)
			if not has or amount <= 0 then return end
			GInv_RemoveItem(ply, name, amount)
			tbl[idx] = {
				id = name,
				dur = 100,
				count = (slot and slot.count or 0) + amount
			}
		elseif mode == "take" then
			if not slot then return end
			if not AddItemsToGmodCount(ply, slot.id, slot.dur, nil, slot.count) then return end
			tbl[idx] = nil
		else
			return
		end

		ent:SendContents(ply)
	end)

	function ENT:SpawnFunction(ply, tr)
		if not tr.Hit then return end
		local ent = ents.Create("rust_recycler")
		ent:SetPos(tr.HitPos + tr.HitNormal * 32)
		ent:Spawn()
		ent:Activate()
		return ent
	end

	net.Receive("gRustRecycler", function(len, ply)
		local str = net.ReadString()
		local ent = net.ReadEntity()
		local slotid = net.ReadFloat()
		if ent.CD >= CurTime() then return end
		ent.CD = CurTime() + 1
		if not ent.data then ent.data = {} end
		table.insert(ent.data, {slotid, str})
	end)

	function ENT:SetOn(state)
		if state == self.On then return end
		self.On = state
		if state then
			self:EmitSound("farming/recycle_start.wav")
			timer.Simple(1, function()
				if IsValid(self) and self.On then
					self.EmitSoundO = self:StartLoopingSound("farming/recycle_loop.wav")
				end
			end)
		else
			self:EmitSound("farming/recycle_stop.wav")
			self:StopLoopingSound(self.EmitSoundO)
		end
	end

	net.Receive("DockTogglezzz", function(_, ply)
		local ent = net.ReadEntity()
		if not IsValid(ent) or ent:GetClass() ~= "rust_recycler" then return end
		if ply:GetPos():DistToSqr(ent:GetPos()) > 250 * 250 then return end
		ent:SetOn(not ent.On)
		ent.NextCycle = CurTime() + CYCLE_TIME
		ent:SendContents(ply)
	end)

	net.Receive("DockRelease", function(_, ply)
		local ent = net.ReadEntity()
		if not IsValid(ent) or ent:GetClass() ~= "rust_recycler" then return end
		if ent.OccupiedBy == ply then
			ent.OccupiedBy = nil
			ent.viewer = nil
		end
	end)

	function ENT:Refresh()
		local v = self.OccupiedBy
		if IsValid(v) and v:GetPos():DistToSqr(self:GetPos()) < 250 * 250 then self:SendContents(v) end
	end

	function ENT:Think()
		self:NextThink(CurTime() + 1)
		if self.OccupiedBy and (not IsValid(self.OccupiedBy) or self.OccupiedBy:GetPos():DistToSqr(self:GetPos()) > 250 * 250) then
			self.OccupiedBy = nil
			self.viewer = nil
		end
		self:Refresh()
		if not self.On or CurTime() < (self.NextCycle or 0) then return true end
		local did = false
		for i = 1, 6 do
			local it = self.InputSlots[i]
			local recipe = it and RECIPES[it.id]
			if recipe and CanFit(self.OutputSlots, recipe) then
				local process = math.max(1, math.floor(it.count / 2))
				it.count = it.count - process
				if it.count <= 0 then self.InputSlots[i] = nil end
				for id, amt in pairs(recipe) do
					AddOutput(self.OutputSlots, id, amt * process)
				end

				did = true
			end
		end

		if did then
			self.NextCycle = CurTime() + CYCLE_TIME
		else
			self:SetOn(false) -- nothing to recycle, or outputs full
		end

		return true
	end

	function ENT:Use(activator)
		if not IsValid(activator) or not activator:IsPlayer() then return end
		if self.OccupiedBy and IsValid(self.OccupiedBy) and self.OccupiedBy ~= activator then return end
		self.OccupiedBy = activator
		self.viewer = activator
		self:SendContents(activator)
		self:EmitSound("farming/recycler_open.wav")
	end

	function ENT:OnTakeDamage(dmg)
	end

	function ENT:StartTouch(entity)
		return false
	end

	function ENT:EndTouch(entity)
		return false
	end

	function ENT:Touch(entity)
		return false
	end
end

if CLIENT then
	ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
	function ENT:Initialize()
	end

	function GRUST_RecyclerMove(ent, mode, kind, idx, name)
		net.Start("grust_RecyclerMove")
		net.WriteEntity(ent)
		net.WriteString(mode)
		net.WriteString(kind)
		net.WriteUInt(idx, 4)
		net.WriteString(name or "")
		net.SendToServer()
	end

	local function S(n)
		return math.Round(n * ScrH() / 1080)
	end

	surface.CreateFont("gRustRec_Title", {
		font = "Roboto Condensed",
		size = S(44),
		weight = 800
	})
	surface.CreateFont("gRustRec_Label", {
		font = "Roboto Condensed",
		size = S(20),
		weight = 800
	})
	surface.CreateFont("gRustRec_Amount", {
		font = "Roboto Condensed",
		size = S(20),
		weight = 700
	})

	local COL_TEXT = Color(240, 232, 224)
	local COL_LABEL = Color(200, 195, 190, 200)
	local COL_PANEL = Color(90, 90, 90, 90)
	local COL_SLOT = Color(0, 0, 0, 90)
	local COL_EMPTY = Color(120, 120, 120, 120)
	local COL_GREEN = Color(112, 140, 52)
	local COL_RED = Color(177, 68, 52)
	local COL_HOVER = Color(255, 255, 255, 20)

	local iconCache = {}
	local function GetIcon(path)
		if not path then return end
		iconCache[path] = iconCache[path] or Material(path, "smooth")
		return iconCache[path]
	end

	local function DrawSlot(x, y, size, slot)
		draw.RoundedBox(0, x, y, size, size, COL_SLOT)
		if slot and (slot.count or 0) > 0 then
			local info = RustOfficial.GetItem(slot.id)
			local mat = GetIcon(info and info.image)
			if mat then
				local pad = size * 0.12
				surface.SetMaterial(mat)
				surface.SetDrawColor(255, 255, 255)
				surface.DrawTexturedRect(x + pad, y + pad, size - pad * 2, size - pad * 2)
			end

			draw.SimpleText("x" .. string.Comma(slot.count), "gRustRec_Amount", x + size - S(6), y + size - S(4), COL_TEXT, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
		else
			local cx, cy, r = x + size / 2, y + size / 2, size * 0.22
			surface.SetDrawColor(COL_EMPTY)
			surface.DrawLine(cx - r, cy - r * 0.3, cx, cy - r)
			surface.DrawLine(cx, cy - r, cx + r, cy - r * 0.3)
			surface.DrawLine(cx + r, cy - r * 0.3, cx, cy + r)
			surface.DrawLine(cx, cy + r, cx - r, cy - r * 0.3)
			surface.DrawLine(cx - r, cy - r * 0.3, cx + r, cy - r * 0.3)
		end
	end

	local GRUST_RecyclerUI = NULL

	local function OpenRecycler(ent, data)
		if IsValid(GRUST_RecyclerUI) then GRUST_RecyclerUI:Remove() end
		local SLOT, GAP = S(86), S(7)
		local PW = S(570)
		local TITLE_H = S(55)
		local ROWS = 4
		local PH = ROWS * (SLOT + GAP) + GAP
		local CTRL_H = S(48)
		local W, H = PW, TITLE_H + PH + S(9) + CTRL_H

		hook.Run("ScoreboardShow")
		if not IsValid(GRUST_TEST) then return end

		local pnl = vgui.Create("DPanel", GRUST_TEST)
		GRUST_RecyclerUI = pnl
		pnl.ent, pnl.data = ent, data
		pnl:SetSize(W, H)
		local invBox = IsValid(GRUST_SLOTS) and GRUST_SLOTS:GetParent()
		local px = invBox and (invBox:GetX() + invBox:GetWide() + S(30)) or (ScrW() - W) / 2
		pnl:SetPos(math.min(px, ScrW() - W - S(10)), (ScrH() - H) / 2)

		pnl.Paint = function(self, w, h)
			local d = self.data or {}
			draw.SimpleText("RECYCLER", "gRustRec_Title", 0, 0, COL_TEXT)
			draw.RoundedBox(0, 0, TITLE_H, w, PH, COL_PANEL)

			local gridW = SLOT * 5 + GAP * 4
			local ox = (w - gridW) / 2

			draw.SimpleText("INPUT", "gRustRec_Label", ox, TITLE_H + S(8), COL_LABEL, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			for i = 1, 5 do
				local col, row = (i - 1) % 5, math.floor((i - 1) / 5)
				DrawSlot(ox + col * (SLOT + GAP), TITLE_H + S(20) + row * (SLOT + GAP), SLOT, d.input and d.input[i])
			end

			local oy = TITLE_H + S(20) + 2 * (SLOT + GAP) + S(10)
			draw.SimpleText("OUTPUT", "gRustRec_Label", ox, oy, COL_LABEL, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			for i = 1, 5 do
				local col, row = (i - 1) % 5, math.floor((i - 1) / 5)
				DrawSlot(ox + col * (SLOT + GAP), oy + S(12) + row * (SLOT + GAP), SLOT, d.output and d.output[i])
			end

			local cy = TITLE_H + PH + S(9)
			draw.RoundedBox(0, 0, cy, w, CTRL_H, COL_PANEL)
			draw.SimpleText("CONTROLS", "gRustRec_Label", S(12), cy + CTRL_H / 2, COL_TEXT, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		local btn = vgui.Create("DButton", pnl)
		btn:SetText("")
		btn:SetSize(S(135), CTRL_H)
		btn:SetPos(W - S(135), TITLE_H + PH + S(9))
		btn.Paint = function(self, w, h)
			local on = pnl.data and pnl.data.on
			draw.RoundedBox(0, 0, 0, w, h, on and COL_RED or COL_GREEN)
			if self:IsHovered() then draw.RoundedBox(0, 0, 0, w, h, COL_HOVER) end
			draw.SimpleText(on and "TURN OFF" or "TURN ON", "gRustRec_Label", w / 2, h / 2, COL_TEXT, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		btn.DoClick = function()
			net.Start("DockTogglezzz")
			net.WriteEntity(ent)
			net.SendToServer()
		end

		local function MakeSlot(kind, idx, x, y)
			local sp = vgui.Create("DButton", pnl)
			sp:SetText("")
			sp:SetPos(x, y)
			sp:SetSize(SLOT, SLOT)
			sp.recEnt, sp.kind, sp.idx = ent, kind, idx

			local function slotData()
				local d = pnl.data or {}
				return d[kind] and d[kind][idx]
			end

			sp.Paint = function(self)
				if self:IsHovered() then draw.RoundedBox(0, 0, 0, SLOT, SLOT, COL_HOVER) end
				if self:IsDragging() then
					local s = slotData()
					if s then DrawSlot(0, 0, SLOT, s) end
				end
			end

			local function take()
				if slotData() then GRUST_RecyclerMove(ent, "take", kind, idx) end
			end

			sp.DoRightClick, sp.DoDoubleClick = take, take
			if kind ~= "output" then
				sp:Droppable("grust_item")
				sp:Receiver("grust_item", function(self, panels, dropped)
					if not dropped then return end
					local name = panels[1] and panels[1].ItemID
					if name then GRUST_RecyclerMove(ent, "put", kind, idx, name) end
				end)
			end
		end

		local gridW = SLOT * 5 + GAP * 4
		local ox = (W - gridW) / 2
		for i = 1, 5 do
			local col, row = (i - 1) % 5, math.floor((i - 1) / 5)
			MakeSlot("input", i, ox + col * (SLOT + GAP), TITLE_H + S(20) + row * (SLOT + GAP))
		end

		local oy = TITLE_H + S(20) + 2 * (SLOT + GAP) + S(10)
		for i = 1, 5 do
			local col, row = (i - 1) % 5, math.floor((i - 1) / 5)
			MakeSlot("output", i, ox + col * (SLOT + GAP), oy + S(12) + row * (SLOT + GAP))
		end

		pnl.Think = function(self)
			if not IsValid(self.ent) or LocalPlayer():GetPos():DistToSqr(self.ent:GetPos()) > 250 * 250 or gui.IsGameUIVisible() then
				gui.HideGameUI()
				hook.Run("ScoreboardHide")
			end
		end
	end

	net.Receive("DockMain", function()
		local ent = net.ReadEntity()
		local data = net.ReadTable()
		if not IsValid(ent) then return end

		if IsValid(GRUST_RecyclerUI) and GRUST_RecyclerUI.ent == ent then
			GRUST_RecyclerUI.data = data
			return
		end

		OpenRecycler(ent, data)
	end)

	function ENT:Draw(flags)
		self:DrawModel(flags)
	end
end