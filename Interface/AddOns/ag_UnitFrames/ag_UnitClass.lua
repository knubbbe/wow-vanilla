local AceOO = AceLibrary("AceOO-2.0")
local L = AceLibrary("AceLocale-2.0"):new("ag_UnitFrames")

local print = function(msg) if msg then DEFAULT_CHAT_FRAME:AddMessage(msg) end end

-- HOOKS

aUF.hooks = {}

function aUF.hooks.hookShowHide(frame)
	local show, hide = frame.Show, frame.Hide
	frame.Show = function(self)
		if (not self.isVisibleFlag) then
			show(self)
			self.isVisibleFlag = true
		end
	end
	frame.Hide = function(self)
		if (self.isVisibleFlag) then
			hide(self)
			self.isVisibleFlag = false
		end
	end
	frame.WillHide = function(self)
		self.doShow = false
	end
	frame.WillShow = function(self)
		self.doShow = true
	end
	frame.DoShowHide = function(self)
		if (self.doShow) then self:Show() else self:Hide() end
	end
	
	frame:Show()
end

--[[function aUF.hooks.hookSetText(frame)
	local settext = frame.SetText
	frame.SetText = function(self, text)
		if (self.lasttext ~= text) then
			self.lasttext = text
			settext(self, text)
		end
	end
end]]

function aUF.hooks.hookSetTexture(frame)
	local settexture = frame.SetTexture
	frame.SetTexture = function(self, texture)
		if (self.lasttexture ~= texture) then
			self.lasttexture = texture
			settexture(self, texture)
		end
	end
end

--[[function aUF.hooks.hookSetVertexColor(frame)
	local setvertexcolor = frame.SetVertexColor
	frame.SetVertexColor = function(self, r, g, b)
		if (self.lastr ~= r or self.lastg ~= g or self.lastb ~= b) then
			self.lastr, self.lastg, self.lastb = r, g, b
			setvertexcolor(self, r, g, b)
		end
	end
end]]

-- UNIT CLASS

aUF.classes = {}
aUF.classes.aUFunit = AceOO.Class("AceEvent-2.0","AceHook-2.0")
aUF.classes.aUFunitXP = AceOO.Class(aUF.classes.aUFunit)
aUF.classes.aUFunitCombo = AceOO.Class(aUF.classes.aUFunit)
aUF.classes.aUFunitMetro = AceOO.Class(aUF.classes.aUFunit)
aUF.classes.aUFunitRaid = AceOO.Class(aUF.classes.aUFunit)

function aUF.classes.aUFunit.prototype:init(name,unit,db)
	aUF.classes.aUFunit.super.prototype.init(self)
	
	self.name = name
	self:CreateFrame()
	self:Reset(unit,db)
	self.eventsRegistered = false
	self:RegisterEvents(true)
end

function aUF.classes.aUFunit.prototype:Reset(unit,db)
	if unit then
		self.unit = unit
		if not db then
			self.type = string.gsub(unit, "%d", "")
		else
			self.type = db
		end
		_,_,self.number = string.find(unit, "(%d+)")
		if not self.number then
			self.number = 1
		end
		if string.find(unit,"pet") then
			if self.type == "partypet" or self.type == "raidpet" then
				self.parent = string.gsub(unit,"pet","")
			else
				self.parent = "player"
			end
		end
	end
	self.flags = {}
	self.flags.disabled = {}
	self.aCount = 0
	self.database = aUF.db.profile[self.type]
	self:LoadScale()
	self:LoadPosition()
	self:ApplyTheme()
	self:BorderBackground()
	self:BarTexture()
	self:StatusBarsColor()
	self:UpdateAll()
end

function aUF.classes.aUFunit.prototype:RegisterEvents(allEvents,unregister)
	if not unregister and self.eventsRegistered == false then
		if self.unit == "player" or self.unit == "target" then
			self:RegisterEvent("UNIT_HEALTH", "UpdateHealth")
			self:RegisterEvent("UNIT_MANA",	"UpdatePower")
			self:RegisterEvent("UNIT_RAGE", "UpdatePower")
			self:RegisterEvent("UNIT_FOCUS", "UpdatePower")
			self:RegisterEvent("UNIT_ENERGY", "UpdatePower")
		else
			self:RegisterBucketEvent("UNIT_HEALTH",0.3, "UpdateHealth")
			self:RegisterBucketEvent({"UNIT_MANA","UNIT_RAGE","UNIT_FOCUS","UNIT_ENERGY"},0.5, "UpdatePower")
		end
		self:RegisterEvent("UNIT_AURA", "UpdateAuras")
		self:RegisterEvent("UNIT_COMBAT","UnitCombat")
		self:RegisterEvent("UNIT_SPELLMISS","UnitSpellmiss")
		self:RegisterEvent("UNIT_LEVEL", "UpdateTextStrings")
		self:RegisterEvent("UNIT_NAME_UPDATE", "UpdateTextStrings")
		self:RegisterEvent("UPDATE_FACTION", "UpdatePvP")
		self:RegisterEvent("PLAYER_FLAGS_CHANGED", "UpdatePvP")
		self:RegisterEvent("UNIT_FACTION", "UpdatePvP")
		self:RegisterEvent("PARTY_LEADER_CHANGED", "LabelsCheckLeader")
		self:RegisterEvent("PARTY_LOOT_METHOD_CHANGED", "LabelsCheckLoot")
		self:RegisterEvent("RAID_TARGET_UPDATE", "UpdateRaidTargetIcon")
		
		if self.flags.Portrait then
			self:RegisterEvent("UNIT_PORTRAIT_UPDATE", "UpdatePortrait")
		end
		
		-- Specific Events :(
		if self.type == "player" then
			self:RegisterEvent("PLAYER_REGEN_ENABLED", "UpdateInCombat")
			self:RegisterEvent("PLAYER_REGEN_DISABLED", "UpdateInCombat")
			self:RegisterEvent("PLAYER_UPDATE_RESTING", "UpdateResting")
		else
			if not self.inCombatSchedule then
				self.inCombatSchedule = self:ScheduleRepeatingEvent(self.UpdateInCombat, 0.5, self)
			end
		end
		if self.type == "partypet" or self.type == "pet" then
			self:RegisterEvent("UNIT_PET","UpdatePetAll")
		end
		
		if self.type == "pet" then
			self:RegisterEvent("UNIT_HAPPINESS","StatusBarsColor")
		end
			
		if allEvents == true then
			self:RegisterEvent("PLAYER_TARGET_CHANGED","UpdateHighlight")
			self:RegisterEvent("PARTY_MEMBERS_CHANGED","UpdateAll")
			self:RegisterEvent("RAID_ROSTER_UPDATE","UpdateAll")
			self:RegisterEvent("agUF_UpdateGroups", "UpdateVisibility")
		end
		self.eventsRegistered = true
	elseif self.eventsRegistered == true and unregister then
		local events = {
			"UNIT_AURA", "UNIT_HEALTH", "UNIT_MANA", "UNIT_RAGE",
			"UNIT_FOCUS", "UNIT_ENERGY", "UNIT_COMBAT", "UNIT_SPELLMISS",
			"UNIT_LEVEL", "UNIT_NAME_UPDATE", "UPDATE_FACTION",
			"PLAYER_FLAGS_CHANGED", "UNIT_PORTRAIT_UPDATE",
			"PARTY_LEADER_CHANGED", "PARTY_LOOT_METHOD_CHANGED",
			"PLAYER_REGEN_ENABLED", "PLAYER_REGEN_DISABLED",
			"PLAYER_UPDATE_RESTING", "RAID_TARGET_UPDATE",
		}
		for k,v in pairs(events) do
			if self:IsEventRegistered(v) then
				self:UnregisterEvent(v)
			end
		end
		if self.inCombatSchedule then
			self:CancelScheduledEvent(self.inCombatSchedule)
			self.inCombatSchedule = nil
		end
		self:UnregisterAllBucketEvents()
		self.eventsRegistered = false
	end
end

function aUF.classes.aUFunit.prototype:CreateFrame()
	local frameName = "aUF"..self.name
	self.framename = frameName
	
	self.frame = CreateFrame("Button",frameName,UIParent,"AGUnitTemplate")
	self.frame.name = self.name
	
	self.ClassText = getglobal(frameName.."_ClassText")
	self.NameLabel = getglobal(frameName.."_NameLabel")
	self.HitIndicator = getglobal(frameName.."_HitIndicator")
	self.HealthBar_BG = getglobal(frameName.."_HealthBar_BG")
	self.ManaBar_BG = getglobal(frameName.."_ManaBar_BG")
	self.XPBar_BG = getglobal(frameName.."_XPBar_BG")
	self.HealthBar = getglobal(frameName.."_HealthBar")
	self.HealthBar:SetScript("OnValueChanged",function() self:StatusBarsOnValueChanged(arg1) end)
	self.HealthBar:SetMinMaxValues(0,100)
	self.ManaBar = getglobal(frameName.."_ManaBar")
	self.ManaBar:SetMinMaxValues(0,100)
	self.XPBar = getglobal(frameName.."_XPBar")
	self.XPBar:SetMinMaxValues(0, 100)
	self.HealthText = getglobal(frameName.."_HealthText")
	self.ManaText = getglobal(frameName.."_ManaText")
	self.StatusText = getglobal(frameName.."_StatusText")
	self.Highlight = getglobal(frameName.."Highlight")
	self.Highlight:SetAlpha(0.5)
	self.DebuffHighlight = getglobal(frameName.."Debuff")
	self.DebuffHighlight:SetAlpha(0.7)
	self.RaidTargetIcon = getglobal(frameName.."_RaidTargetIcon")
	self.InCombatIcon = getglobal(frameName.."_InCombatIcon")
	self.PVPIcon = getglobal(frameName.."_PVPIcon")
	self.LeaderIcon = getglobal(frameName.."_LeaderIcon")
	self.MasterIcon = getglobal(frameName.."_MasterIcon")
	self.frame:SetScript("OnEnter",function() self:OnEnter() end)
	self.frame:SetScript("OnLeave",function() self:OnLeave() end)
	self.frame:SetScript("OnDragStart",function() self:OnDragStart(arg1) end)
	self.frame:SetScript("OnDragStop",function() self:OnDragStop(arg1) end)
	self.frame:SetScript("OnClick",function() self:OnClick(arg1) end)
	self.frame:SetScript("OnHide",function() this:StopMovingOrSizing() end)
	
	for i =1,20 do
		self["Aura"..i] = getglobal(frameName.."_Aura"..i)
		self["Aura"..i].Icon = getglobal(frameName.."_Aura"..i.."Icon")
		self["Aura"..i].Overlay = getglobal(frameName.."_Aura"..i.."Overlay")
		self["Aura"..i].Count = getglobal(frameName.."_Aura"..i.."Count")
		self["Aura"..i]:SetScript("OnEnter",function() self:AuraOnEnter() end)
		self["Aura"..i]:SetScript("OnLeave",function() GameTooltip:Hide() end)

		aUF.hooks.hookShowHide(self["Aura"..i])
		aUF.hooks.hookSetTexture(self["Aura"..i].Icon)
		
		self["Aura"..i]:Hide()
	end

	if string.find(self.name,"player") then
		self.XPBar_Rest = CreateFrame("StatusBar",frameName.."_XPBar_Rest",self.frame)
		self.XPBar_Rest:SetMinMaxValues(0, 100)
		self.XPBar:SetParent(self.XPBar_Rest)
	end

	if AceOO.inherits(self, aUF.classes.aUFunitCombo) then
		self:CreateCombos()
	end

	self.frame:SetMovable(true)
	self.frame:EnableMouse(true)
	self.frame:RegisterForDrag("LeftButton")
	self.frame:RegisterForClicks("LeftButtonUp","RightButtonUp","MiddleButtonUp","Button4Up","Button5Up")
end

function aUF.classes.aUFunit.prototype:CreatePortraitFrame()
	local frameName = "aUF"..self.name
	-- We're trying to be efficient and not create portrait frames unless the layout calls for them.
	if self.Portrait then return self.Portrait end
	
	self.Portrait = CreateFrame("Button", frameName.."_Portrait", self.frame)
	self.Portrait.Texture = self.Portrait:CreateTexture()
	self.Portrait.Texture:SetAllPoints(self.Portrait)
	self.Portrait:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 1, edgeFile = "", edgeSize = 0, insets = {left = 0, right = 0, top = 0, bottom = 0},})
	
	
	self.PortraitModel = CreateFrame("PlayerModel", frameName.."_PortraitModel", self.Portrait)
	self.PortraitModel:SetFrameLevel(self.Portrait:GetFrameLevel() + 1)
	self.PortraitModel:SetPoint("CENTER", self.Portrait, "CENTER", 0, 0)
	self.PortraitModel:SetScript("OnShow",function() this:SetCamera(0) end)
	self.Portrait:SetAlpha(self.frame:GetAlpha())
	
	self:UpdatePortrait()
	return self.Portrait
end

function aUF.classes.aUFunit.prototype:LoadScale()
	self.frame:SetScale(self.database.Scale)
	if self.subgroup then
		aUF.subgroups[self.subgroup]:LoadPosition()
		aUF.subgroups[self.subgroup]:UpdateScale()
	end
end

function aUF.classes.aUFunit.prototype:LoadPosition()
	if self.subgroup then return end
	if(aUF.db.profile.Positions[self.unit]) then
		local x = aUF.db.profile.Positions[self.unit].x
		local y = aUF.db.profile.Positions[self.unit].y
		local scale = self.frame:GetEffectiveScale()
		
		self.frame:SetPoint("TOPLEFT", UIParent,"TOPLEFT", x/scale, y/scale)
	else
		self.frame:SetPoint("CENTER", UIParent, "CENTER")
	end
end

function aUF.classes.aUFunit.prototype:SavePosition()
	local scale = self.frame:GetEffectiveScale()
	local worldscale = UIParent:GetEffectiveScale()
	
	local x,y = self.frame:GetLeft()*scale,self.frame:GetTop()*scale - (UIParent:GetTop())*worldscale
	if not aUF.db.profile.Positions[self.unit] then 
		aUF.db.profile.Positions[self.unit] = {}
	end
	
	aUF.db.profile.Positions[self.unit].x = x
	aUF.db.profile.Positions[self.unit].y = y
end

function aUF.classes.aUFunit.prototype:ApplyTheme()
		local themetable = aUF.Layouts[self.database.FrameStyle]
		if not themetable then return end
		
		self.flags.disabled = {}
		
		local manabarhide = false
		local xpbarhide = false
		local height = 0
		local width = 0
		
		if self.database.HideMana == true then
			self.flags.disabled.ManaBar_BG = true
		else
			self.flags.disabled.XPBar_BG = nil
		end

		if (self.unit ~= "player" and self.unit ~= "pet") or ((self.unit == "pet" or self.unit == "player") and self.database.ShowXP  == false) then
			self.flags.disabled.XPBar_BG = true
		else
			self.flags.disabled.XPBar_BG = nil
		end
		
		self.flags.ResizableBar = themetable.ResizableBar
		self.flags.BackgroundBarColor = themetable.BackgroundBarColor
		self.flags.AlphaBar = themetable.AlphaBar
		self.flags.RaidColorName = themetable.RaidColorName
		self.flags.ThemeName = themetable.Name
		self.flags.PetClassName = themetable.PetClassName
		self.flags.HappinessBar = themetable.HappinessBar
		self.flags.Portrait = themetable.Portrait
		
		if self.database.Portrait and self.flags.Portrait then
			self.flags.disabled.Portrait = nil
			if not self.Portrait then
				self:CreatePortraitFrame()
			end
		else
			self.flags.disabled.Portrait = true
			self.flags.Portrait = false
		end
		
		if self.unit == "target" then
			if themetable.ComboGFX == true then
				comboGFX = 1
			else
				comboGFX = 0
			end
		end
		
		height = themetable.ThemeData.all.FrameHeight
		width = themetable.ThemeData.all.FrameWidth
		
		if themetable.ThemeData[self.type] then
			if themetable.ThemeData[self.type].FrameHeight then
				height = themetable.ThemeData[self.type].FrameHeight
			end
			if themetable.ThemeData[self.type].FrameWidth then
				width = themetable.ThemeData[self.type].FrameWidth	
			end
		end
		
		if manabarhide == true then
			self.flags.RaidColorName = true
		end
		
		for k,v in themetable.ThemeData.all do
			if self[k] then self[k]:ClearAllPoints() end
		end
		local index = "all"
		for j = 1,2 do
			if j == 2 then
				index = self.type
			end
			if themetable.ThemeData[index] then
				for key, value in pairs(themetable.ThemeData[index]) do
					if self[key] and value.Hidden ~= true and not (self.flags.disabled[key]) then
						local useSecondary = false
						
						if value.Hide then
							self.flags.disabled[value.Hide] = true
						end
						
						if value.HeightAdd then
							height = height + value.HeightAdd
						end

						if value.Font then
							self[key]:SetFont(value.Font,value.FontSize)
						end
						
						local RelativeTo
						if value.RelativeTo then
							if themetable.ThemeData[index][value.RelativeTo]
							and (themetable.ThemeData[index][value.RelativeTo].Hidden == true 
							or not getglobal(self.framename.."_"..value.RelativeTo) 
							or self.flags.disabled[value.RelativeTo]) 
							and value.RelativeTo2 then
							
								if themetable.ThemeData[index][value.RelativeTo2]
								and (themetable.ThemeData[index][value.RelativeTo2].Hidden == true 
								or not getglobal(self.framename.."_"..value.RelativeTo2) 
								or self.flags.disabled[value.RelativeTo2]) 
								and value.RelativeTo3 then
								
									RelativeTo = self.framename.."_"..value.RelativeTo3
									useSecondary = 3
									
								else
								
									RelativeTo = self.framename.."_"..value.RelativeTo2
									useSecondary = 2
									
								end
							else
								RelativeTo = self.framename.."_"..value.RelativeTo
							end
						elseif not value.RelativeTo or not getglobal(self.framename.."_"..value.RelativeTo)  then
							RelativeTo = self.framename
						end
						
						if RelativeTo == self.framename.."_".."SELF_UNITFRAME" then
							RelativeTo = self.framename
						end
						
						if value.Width then
							if self.flags.Portrait == true and value.WidthP then
								self[key]:SetWidth(value.WidthP)
							elseif useSecondary and value["Width"..useSecondary] then
								self[key]:SetWidth(value["Width"..useSecondary])
							else
								self[key]:SetWidth(value.Width)
							end
						end
						
						if value.Height then
							self[key]:SetHeight(value.Height)
						end
						
						local x,y,Point,RelativePoint
						local positionSet = true
						if value.x and value.y and value.Point and value.RelativePoint and not useSecondary then
							x = value.x
							y = value.y
							Point = value.Point
							RelativePoint = value.RelativePoint
						elseif value.x2 and value.y2 and value.Point2 and value.RelativePoint2 and useSecondary == 2 then
							x = value.x2
							y = value.y2
							Point = value.Point2
							RelativePoint = value.RelativePoint2
						elseif value.x3 and value.y3 and value.Point3 and value.RelativePoint3 and useSecondary == 3 then
							x = value.x3
							y = value.y3
							Point = value.Point3
							RelativePoint = value.RelativePoint3			
						else
							positionSet = false
						end
						
						if positionSet == true then
							local pointAdjust
							if themetable.ResizableBar == true and self.database.LongStatusbars == false and (key == "HealthText" or key == "ManaText") then
								if Point == "RIGHT" then 
									pointAdjust = "LEFT"
								elseif Point == "LEFT" then 
									pointAdjust = "RIGHT"
								else
									pointAdjust = value.Point
								end
							else
								pointAdjust = Point
							end
							self[key]:ClearAllPoints()
							self[key]:SetPoint(pointAdjust, RelativeTo, RelativePoint, x, y)
						end
						
						if value.Visibility then
							for k, v in pairs(value.Visibility) do
								if self[v] then
									self[v]:Show()
								end
							end
						end
						if value.Justify then
							self[key]:SetJustifyH(value.Justify)
						end
					elseif self[key] and (value.Hidden or self.flags.disabled[key] == true ) then
						self[key]:Hide()
						if value.Visibility then
							for k, v in pairs(value.Visibility) do
								if self[v] then
									self.flags.disabled[v] = true
									self[v]:Hide()
								end
							end
						end
					end
				end
			end
		end
		for key,value in pairs(self.flags.disabled) do
			if self[key] then
				self[key]:Hide()
			end
		end
	
	self.frame:SetHeight(height)
	self.frame:SetWidth(100)
	if self.widthAdd then
		self.database.Width = width
	end
	
	if self.flags.ResizableBar == true and self.database.LongStatusbars == false then
		self.HealthBar_BG:SetWidth(self.HealthBar_BG:GetWidth() - self.HealthText:GetWidth())
		self.ManaBar_BG:SetWidth(self.ManaBar_BG:GetWidth() - self.ManaText:GetWidth())
	end
	
	self.widthAdd = 0
	self:SetWidth()

	if self.flags.Portrait then
		self.PortraitModel:SetWidth(self.Portrait:GetWidth()-2)
		self.PortraitModel:SetHeight(self.Portrait:GetHeight()-2)
	end
end

function aUF.classes.aUFunit.prototype:BorderBackground()
	local colortable
	local bordercolor = aUF.db.profile.FrameBorderColors
	local borderstyle = aUF.db.profile.BorderStyle
	
	if self.unit == "target" then
		colortable = aUF.db.profile.TargetFrameColors
	else
		colortable = aUF.db.profile.PartyFrameColors
	end
	
	self.frame:SetBackdrop({
				bgFile = "Interface\\ChatFrame\\ChatFrameBackground", tile = true, tileSize = 16,
				edgeFile = aUF.Borders[borderstyle].texture, edgeSize = aUF.Borders[borderstyle].size,
				insets = {left = aUF.Borders[borderstyle].insets, right = aUF.Borders[borderstyle].insets, top = aUF.Borders[borderstyle].insets, bottom = aUF.Borders[borderstyle].insets},
		})
	
	self.frame:SetBackdropColor(colortable.r,colortable.g,colortable.b,colortable.a)
	self.frame:SetBackdropBorderColor(bordercolor.r,bordercolor.g,bordercolor.b,bordercolor.a)

	if self.flags.Portrait then
		self.Portrait:SetBackdropBorderColor(self.frame:GetBackdropBorderColor())
		self.Portrait:SetBackdropColor(self.frame:GetBackdropColor())
	end
end

function aUF.classes.aUFunit.prototype:SetWidth()
	local widthAdd = 100
	if self.database.Width then widthAdd = self.database.Width end
	if not self.widthAdd then self.widthAdd = 0 end
	widthAdd = widthAdd - 100
	
	widthAdd =  widthAdd - self.widthAdd
	self.widthAdd = self.widthAdd + widthAdd
	
	self.frame:SetWidth(self.frame:GetWidth() + widthAdd)
	self.HealthBar_BG:SetWidth(self.HealthBar_BG:GetWidth() + widthAdd)
	self.ManaBar_BG:SetWidth(self.ManaBar_BG:GetWidth() + widthAdd)
	self.XPBar_BG:SetWidth(self.XPBar_BG:GetWidth() + widthAdd)
	
	if self.XPBar_Rest then
		self.XPBar_Rest:ClearAllPoints()
		self.XPBar_Rest:SetPoint("LEFT",self.XPBar_BG,"LEFT")
		self.XPBar_Rest:SetHeight(self.XPBar_BG:GetHeight())
		self.XPBar_Rest:SetWidth(self.XPBar_BG:GetWidth())
	end
	if self.XPBar then
		self.XPBar:ClearAllPoints()
		self.XPBar:SetPoint("LEFT",self.XPBar_BG,"LEFT")
		self.XPBar:SetHeight(self.XPBar_BG:GetHeight())
		self.XPBar:SetWidth(self.XPBar_BG:GetWidth())
	end
	if self.HealthBar then
		self.HealthBar:ClearAllPoints()
		self.HealthBar:SetPoint("LEFT",self.HealthBar_BG,"LEFT")
		self.HealthBar:SetHeight(self.HealthBar_BG:GetHeight())
		self.HealthBar:SetWidth(self.HealthBar_BG:GetWidth())
	end
	if self.ManaBar then
		self.ManaBar:ClearAllPoints()
		self.ManaBar:SetPoint("LEFT",self.ManaBar_BG,"LEFT")
		self.ManaBar:SetHeight(self.ManaBar_BG:GetHeight())
		self.ManaBar:SetWidth(self.ManaBar_BG:GetWidth())
	end
	self.Highlight:SetHeight(self.frame:GetHeight()-10)
	self.Highlight:SetWidth(self.frame:GetWidth()-10)
	self.DebuffHighlight:SetHeight(self.frame:GetHeight()-10)
	self.DebuffHighlight:SetWidth(self.frame:GetWidth()-10)
		
	if self.subgroup then
		aUF.subgroups[self.subgroup]:UpdateWidth()
	end
	
	self:AuraPosition()
end

function aUF.classes.aUFunit.prototype:BarTexture()
	local barstyle = aUF.db.profile.BarStyle
	
	self.HealthBar:SetStatusBarTexture(aUF.Bars[barstyle])
	self.ManaBar:SetStatusBarTexture(aUF.Bars[barstyle])
	self.XPBar:SetStatusBarTexture(aUF.Bars[barstyle])
	if self.XPBar_Rest then
		self.XPBar_Rest:SetStatusBarTexture(aUF.Bars[barstyle])
	end
	self.HealthBar_BG:SetTexture(aUF.Bars[barstyle])
	self.ManaBar_BG:SetTexture(aUF.Bars[barstyle])
	self.XPBar_BG:SetTexture(aUF.Bars[barstyle])
end

-- CLASS UPDATES

function aUF.classes.aUFunit.prototype:UpdateHighlight(entered)
	if (UnitExists("target") and UnitName("target") == UnitName(self.unit) and not (string.find(self.unit,"target")) and aUF.db.profile.HighlightSelected == true) or (entered == true and aUF.db.profile.HighlightSelected == true) then
		self.Highlight:Show()
	else
		self.Highlight:Hide()
	end
end

function aUF.classes.aUFunit.prototype:UpdatePetAll()
	if arg1 ~= self.parent then return end
	self:UpdateAll()
end

function aUF.classes.aUFunit.prototype:UpdateAll()
	if self:SetVisibility() then
		self:GroupingUpdate()
		self:StatusBarsColor()
		self:UpdateHealth(true)
		self:UpdatePower(true)
		self:UpdatePvP(true)
		self:UpdateAuras(true)
		self:UpdateRaidTargetIcon(true)
		self:UpdateResting()
		self:UpdateInCombat()
		self:LabelsCheckLeader()
		self:UpdateHighlight()
		self:UpdateTextStrings()
		if self.flags.Portrait then
			self:UpdatePortrait()
		end
		self:RegisterEvents()
		return true
	else
		self:GroupingUpdate(true)
		self:RegisterEvents(false,true)
		return false
	end
end

function aUF.classes.aUFunit.prototype:GroupingUpdate(hide)
	local oldGroup = self.subgroup
	
	if hide then
		self.subgroup = nil
	elseif string.find(self.type,"raid") then
	
		if aUF.db.profile.RaidGrouping == "byclass" then
			_, _, _, _, _, self.subgroup = GetRaidRosterInfo(self.number)
		elseif aUF.db.profile.RaidGrouping == "nogroup" then
			self.subgroup = nil
		elseif aUF.db.profile.RaidGrouping == "onebiggroup" then
			self.subgroup = "Raid"
		elseif aUF.db.profile.RaidGrouping == "byrole" then
			local _,eClass = UnitClass(self.unit)
			self.subgroup = "Raid"..(aUF.RaidRole[eClass] or "none")
		else
			_,_,self.subgroup = GetRaidRosterInfo(self.number)
		end
		
	elseif self.type == "party" or self.type == "partypet" then
	
		if aUF.db.profile.PartyGrouping == "withoutplayer" then
			self.subgroup = "partyParty"
		elseif aUF.db.profile.PartyGrouping == "nogroup" then
			self.subgroup = nil
		else
			self.subgroup = "partyPlayer"
		end
		
	elseif self.type == "pet" then
	
		if aUF.db.profile.PetGrouping == "nogroup" then
			self.subgroup = nil
		else
			self.subgroup = "partyPlayer"
		end
		
	elseif self.type == "player" then
	
		self.subgroup = "partyPlayer"
		
	end
	
	if oldGroup ~= self.subgroup then
		if oldGroup then
			aUF.changedSubgroups[oldGroup] = true
			if aUF.subgroups[oldGroup].group[self.type] and aUF.subgroups[oldGroup].group[self.type][self.name] then
				aUF.subgroups[oldGroup].group[self.type][self.name] = nil
			end
		end
		
		if self.subgroup then
			if not aUF.subgroups[self.subgroup] then
				aUF.subgroups[self.subgroup] = aUF.classes.aUFgroup:new(self.subgroup)
			end
			if not aUF.subgroups[self.subgroup].group[self.type] then
				aUF.subgroups[self.subgroup].group[self.type] = {}
			end
			aUF.subgroups[self.subgroup].group[self.type][self.name] = self
			aUF.changedSubgroups[self.subgroup] = true
		end
		
		self:ScheduleEvent("UpdateGroups", function() aUF:TriggerEvent("agUF_UpdateGroups") end, 0.1, self)
	elseif self.subgroup then
		self:UpdateVisibility()
	end
	if self.subgroup == nil then
		self:LoadPosition()
		self:UpdateVisibility()
	end
end

function aUF.classes.aUFunit.prototype:SetVisibility()
	if aUF:CheckVisibility(self.unit) == true then
		self.visible = true
		return true
	else
		self.visible = false
		return false
	end
end

function aUF.classes.aUFunit.prototype:UpdateVisibility()
	if self.visible == true then
		self.frame:Show()
	else
		self.frame:Hide()
	end
end

function aUF.classes.aUFunit.prototype:UpdatePortrait(stop)
	
	if aUF.db.profile.ThreeDimensionalPortraits then
		if self.visible == false then
			if stop then
				self.PortraitModel:SetModelScale(4.25)
				self.PortraitModel:SetPosition(0,0,-1.5)
				self.PortraitModel:SetModel("Interface\\Buttons\\talktomequestionmark.mdx")
			else
				--If a unit just joined the group, it's too early for this model-changing stuff to work.  I don't know why.  Therefore:
				aUF:ScheduleEvent(self.UpdatePortrait, 1, self, true)
			end
		else
			self.PortraitModel:SetUnit(self.unit)
			self.PortraitModel:SetCamera(0)
		end
		self.Portrait:SetBackdropBorderColor(self.frame:GetBackdropBorderColor())
		self.Portrait:SetBackdropColor(self.frame:GetBackdropColor())	
	else
		if self.visible == false then
			if stop then
				SetPortraitTexture(self.Portrait.Texture, self.unit)
			else
				aUF:ScheduleEvent(self.UpdatePortrait, 1, self, true)
			end
		else
			SetPortraitTexture(self.Portrait.Texture, self.unit)
		end
	end

end

-- ICONS

function aUF.classes.aUFunit.prototype:LabelsCheckLeader()
	self.LeaderIcon:Hide()
	if not ( self.type == "raid" or self.type == "party" or self.unit == "player") then return end
	if aUF.db.profile.ShowGroupIcons == true then
		if self.type == "raid" then
			local _, rank = GetRaidRosterInfo(self.number)
			if rank == 2 then
				self.LeaderIcon:Show()
			end
		elseif self.type == "party" and tonumber(GetPartyLeaderIndex()) == tonumber(self.number) then
			self.LeaderIcon:Show()
		elseif self.unit == "player" and IsPartyLeader() then
			self.LeaderIcon:Show()
		end
	end
end

function aUF.classes.aUFunit.prototype:LabelsCheckLoot()
	self.MasterIcon:Hide()
	if not ( self.unit == "player" or self.type == "party") then return end
	if aUF.db.profile.ShowGroupIcons == true then
		local _, lootMaster = GetLootMethod()
		if lootMaster then
			if self.unit == "player" and lootMaster == 0 then
				self.MasterIcon:Show()
			elseif self.unit ~= "player" and lootMaster > 0 then
				if lootMaster == self.number and not (string.find(self.unit,"pet")) then
					self.MasterIcon:Show()
				end
			end
		end
	end
end

function aUF.classes.aUFunit.prototype:UpdateRaidTargetIcon(byevent)
	if type(byevent) == "string" and byevent ~= self.unit then return end

	local index = GetRaidTargetIndex(self.unit)
	if ( index ) and aUF.db.profile[self.type].ShowRaidTargetIcon == true then
		SetRaidTargetIconTexture(self.RaidTargetIcon, index)
		self.RaidTargetIcon:Show()
	else
		self.RaidTargetIcon:Hide()
	end
end

function aUF.classes.aUFunit.prototype:UpdateInCombat()
	if aUF.db.profile[self.type].ShowInCombatIcon == true and UnitAffectingCombat(self.unit) then
		self.combat = true
--		print(self.unit)
	else
		self.combat = false
	end
	self:UpdateStatusIcon()
end

function aUF.classes.aUFunit.prototype:UpdateResting()
	if self.unit ~= "player" then return end
	if IsResting() then
		self.resting = true
	else
		self.resting = false
	end
	self:UpdateStatusIcon()
end

function aUF.classes.aUFunit.prototype:UpdateStatusIcon()
	if self.combat == true then
		self.InCombatIcon:Show()
		self.InCombatIcon:SetTexCoord(0.5,1,0,0.5)
	elseif self.resting == true then
		self.InCombatIcon:Show()
		self.InCombatIcon:SetTexCoord(0,0.5,0,0.421875)
	else
		self.InCombatIcon:Hide()
	end
end

function aUF.classes.aUFunit.prototype:UpdatePvP(byevent)
	if type(byevent) == "string" and byevent ~= self.unit then return end
	if aUF.db.profile.ShowPvPIcon == true then
		if ( UnitIsPVPFreeForAll(self.unit) ) then
			self.PVPIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-FFA")
			self.PVPIcon:Show()
		elseif ( UnitFactionGroup(self.unit) and UnitIsPVP(self.unit) ) then
			self.PVPIcon:SetTexture("Interface\\TargetingFrame\\UI-PVP-"..UnitFactionGroup(self.unit))
			self.PVPIcon:Show()
		else
			self.PVPIcon:Hide()
		end
	else
		self.PVPIcon:Hide()
	end
end

function aUF.classes.aUFunit.prototype:UpdateTextStrings()
	if self.visible then
		if aUF.HelperFunctions[self.type] then
			if aUF.HelperFunctions[self.type].HealthText and self.HealthText:IsShown() then
				aUF.HelperFunctions[self.type].HealthText(self.unit,self.HealthText)
				--Modified by Skela - Changes for Dynamic Texts - Health
				if aUF.db.profile.DynamicTexts and self.HealthText:GetText() ~= nil and aUF.Layouts[self.database.FrameStyle].ThemeData.all.HealthText.longText ~= nil and aUF.Layouts[self.database.FrameStyle].ThemeData.all.HealthText.longTextFontSize ~= nil then
					if string.len(self.HealthText:GetText()) >= aUF.Layouts[self.database.FrameStyle].ThemeData.all.HealthText.longText then
						self.HealthText:SetFont(aUF.Layouts[self.database.FrameStyle].ThemeData.all.HealthText.Font,aUF.Layouts[self.database.FrameStyle].ThemeData.all.HealthText.longTextFontSize)
					else
						self.HealthText:SetFont(aUF.Layouts[self.database.FrameStyle].ThemeData.all.HealthText.Font,aUF.Layouts[self.database.FrameStyle].ThemeData.all.HealthText.FontSize)
					end
				end
				--Modified by Skela - Changes for Dynamic Texts - Health
			end
			if aUF.HelperFunctions[self.type].ManaText and self.ManaText:IsShown() then
				aUF.HelperFunctions[self.type].ManaText(self.unit,self.ManaText)
				--Modified by Skela - Changes for Dynamic Texts - Mana
				if aUF.db.profile.DynamicTexts and self.Manatext ~= nil and self.Manatext:GetText() ~= nil and aUF.Layouts[self.database.FrameStyle].ThemeData.all.Manatext.longText ~= nil and aUF.Layouts[self.database.FrameStyle].ThemeData.all.Manatext.longTextFontSize ~= nil then
					if string.len(self.Manatext:GetText()) >= aUF.Layouts[self.database.FrameStyle].ThemeData.all.Manatext.longText then
						self.Manatext:SetFont(aUF.Layouts[self.database.FrameStyle].ThemeData.all.Manatext.Font,aUF.Layouts[self.database.FrameStyle].ThemeData.all.Manatext.longTextFontSize)
					else
						self.Manatext:SetFont(aUF.Layouts[self.database.FrameStyle].ThemeData.all.Manatext.Font,aUF.Layouts[self.database.FrameStyle].ThemeData.all.Manatext.FontSize)
					end
				end
				--Modified by Skela - Changes for Dynamic Texts - Mana
			end
			if aUF.HelperFunctions[self.type].NameText and self.NameLabel:IsShown() then
				aUF.HelperFunctions[self.type].NameText(self.unit,self.NameLabel)
				--Modified by Skela - Changes for Dynamic Texts - Name
				if aUF.db.profile.DynamicTexts and self.NameLabel:GetText() ~= nil and aUF.Layouts[self.database.FrameStyle].ThemeData.all.NameLabel.longText ~= nil and aUF.Layouts[self.database.FrameStyle].ThemeData.all.NameLabel.longTextFontSize ~= nil then
					if string.len(self.NameLabel:GetText()) >= aUF.Layouts[self.database.FrameStyle].ThemeData.all.NameLabel.longText then
						self.NameLabel:SetFont(aUF.Layouts[self.database.FrameStyle].ThemeData.all.NameLabel.Font,aUF.Layouts[self.database.FrameStyle].ThemeData.all.NameLabel.longTextFontSize)
					else
						self.NameLabel:SetFont(aUF.Layouts[self.database.FrameStyle].ThemeData.all.NameLabel.Font,aUF.Layouts[self.database.FrameStyle].ThemeData.all.NameLabel.FontSize)
					end
				end
				--Modified by Skela - Changes for Dynamic Texts - Name
			end
			if aUF.HelperFunctions[self.type].ClassText and self.ClassText:IsShown() then
				aUF.HelperFunctions[self.type].ClassText(self.unit,self.ClassText)
				--Modified by Skela - Changes for Dynamic Texts - Name
				if aUF.db.profile.DynamicTexts and self.ClassText ~= nil and self.ClassText:GetText() ~= nil and aUF.Layouts[self.database.FrameStyle].ThemeData.all.ClassText.longText ~= nil and aUF.Layouts[self.database.FrameStyle].ThemeData.all.ClassText.longTextFontSize ~= nil then
					if string.len(self.ClassText:GetText()) >= aUF.Layouts[self.database.FrameStyle].ThemeData.all.ClassText.longText then
						self.ClassText:SetFont(aUF.Layouts[self.database.FrameStyle].ThemeData.all.ClassText.Font,aUF.Layouts[self.database.FrameStyle].ThemeData.all.ClassText.longTextFontSize)
					else
						self.ClassText:SetFont(aUF.Layouts[self.database.FrameStyle].ThemeData.all.ClassText.Font,aUF.Layouts[self.database.FrameStyle].ThemeData.all.ClassText.FontSize)
					end
				end
				--Modified by Skela - Changes for Dynamic Texts - Name
			end
		end
	end
end

-- AURAS

function aUF.classes.aUFunit.prototype:AuraPosition()
	local scale = (self.frame:GetWidth()/170)
	local style,position = self.database.AuraStyle,self.database.AuraPos	
	local yadjust = 0

	for i=1,20 do
		self["Aura"..i]:SetScale(scale)
	end
	
	if not (style == "OneLine") and (position == "Right" or position == "Left") then
		yadjust = (self.Aura1:GetHeight()/2)
	end
	
	self.Aura1:ClearAllPoints()
	
	if ( position == "Below" ) then
		self.Aura1:SetPoint("TOPLEFT",self.frame,"BOTTOMLEFT",5, 0)
	elseif ( position == "Above" ) then
		self.Aura1:SetPoint("BOTTOMLEFT",self.frame,"TOPLEFT",5, 0)
	elseif ( position == "Left" ) then
		self.Aura1:SetPoint("RIGHT",self.frame,"LEFT",0, yadjust)
	elseif ( position == "Right" ) then
		self.Aura1:SetPoint("LEFT",self.frame,"RIGHT",0, yadjust)
	end

	if ( position == "Left" ) then
		for i=2,20 do
			self["Aura"..i]:ClearAllPoints()
			if i == 11 then
				self["Aura"..i]:SetPoint("TOP",self.Aura1,"BOTTOM",0,-1)
			else
				self["Aura"..i]:SetPoint("RIGHT",self["Aura"..i-1],"LEFT",1,0)
			end
		end
	else
		for i=2,20 do
			self["Aura"..i]:ClearAllPoints()
			if i == 11 then
				if position == "Above" then
					self["Aura"..i]:SetPoint("BOTTOM",self.Aura1,"TOP",0,1)
				else
					self["Aura"..i]:SetPoint("TOP",self.Aura1,"BOTTOM",0,-1)
				end
			else
				self["Aura"..i]:SetPoint("LEFT",self["Aura"..i-1],"RIGHT",1,0)
			end
		end
	end
end

function aUF.classes.aUFunit.prototype:UpdateAuras(byevent)
	if type(byevent) == "string" and byevent ~= self.unit then return end
	
	if aUF.auraUpdates > 4 then 
		aUF.auraUpdatePool[self.name] = true
--		print(self.name.." add to pool")
		return 
	else
--		print(self.name.." update "..aUF.auraUpdates)
		aUF.auraUpdatePool[self.name] = nil 
		aUF.auraUpdates = aUF.auraUpdates + 1
	end
	
	local filter,style,AuraDebuffC = self.database.AuraFilter,self.database.AuraStyle,self.database.AuraDebuffC
	local dbcount,bcount,lastDebuff = 0,0,0
	local buttons,dFound
	
	self.DebuffHighlight:Hide()
	local hide = style == "Hide"
	
	for i=1,20 do
		if (not self.hidden) then self["Aura"..i]:Hide() end
		local debuff, _, t = aUF:UnitDebuff(self.unit,i,filter)
		if debuff then
			dbcount = dbcount + 1
			lastDebuff = i
			if not dFound then
				if t and AuraDebuffC == true and UnitIsFriend("player",self.unit) then
					self.DebuffHighlight:Show()
					self.DebuffHighlight:SetVertexColor(DebuffTypeColor[t].r, DebuffTypeColor[t].g, DebuffTypeColor[t].b)
					dFound = true
				end
			end
		end
		if UnitBuff(self.unit,i,filter) then
			bcount = bcount + 1
		end
	end
	
	if hide or bcount + dbcount == 0 then
		self.hidden = true
		return
	end
	self.hidden = false
	
	local position = self.database.AuraPos
	
	if (position == "Above" or position == "Below") and bcount + dbcount <= 10 then
		buttons = 10
	elseif style == "OneLine" then
		if (position == "Right" or position == "Left") and bcount + dbcount <= 10 then
			buttons = bcount + dbcount
		else
			buttons = 10
		end
	else
		buttons = 20
	end
	
	local x,z,a,borderColor
	local b = 1
	
	if (buttons > 10 and dbcount <= 10) then
		x = 11
		z = 1
		a = 10
	else
		x = buttons
		z = -1	
		a = bcount
	end
	
	for i=1,max(lastDebuff,a) do
		local buff, count, class = aUF:UnitDebuff(self.unit,i,filter)
		local buffFrame = self["Aura"..x]
		if buff and buffFrame then
			buffFrame.Icon:SetTexture(buff)
			buffFrame:Show()
			buffFrame.buffFilter = "HARMFUL"
			buffFrame.id = i
			if count > 1 then
				buffFrame.Count:SetText(count)
			else
				buffFrame.Count:SetText("")
			end
			if class then
				borderColor = DebuffTypeColor[class]
			else
				borderColor = DebuffTypeColor["none"]
			end
			buffFrame.Overlay:SetVertexColor(borderColor.r, borderColor.g, borderColor.b)
			buffFrame.Overlay:Show()
			x = x + z
		end
		buff, count = UnitBuff(self.unit,i,filter)
		buffFrame = self["Aura"..b]
		if buff and b <= a then
			buffFrame.Icon:SetTexture(buff)
			buffFrame:Show()
			buffFrame.buffFilter = "HELPFUL"
			buffFrame.id = i
			if count > 1 then
				buffFrame.Count:SetText(count)
			else
				buffFrame.Count:SetText("")
			end
			buffFrame.Overlay:Hide()
			b = b + 1
		end
	end
end

-- STATUSBAR STUFF

function aUF.classes.aUFunit.prototype:UpdateHealth(byevent)
	if type(byevent) =="table" and not byevent[self.unit] then return end
	local currValue,maxValue = UnitHealth(self.unit),UnitHealthMax(self.unit)
    local perc = currValue/maxValue * 100
	
	if ( not UnitExists(self.unit) or UnitIsDead(self.unit) or UnitIsGhost(self.unit) or not UnitIsConnected(self.unit) or maxValue == 1) then
		self.HealthBar:SetValue(0)
	else			
		self.HealthBar:SetValue(perc)
	end
	
	self:UpdateTextStrings()
end

function aUF.classes.aUFunit.prototype:UpdatePower(byevent)
	if type(byevent) =="table" and not byevent[self.unit] then return end
	local currValue,maxValue = UnitMana(self.unit),UnitManaMax(self.unit)
    local perc = currValue/maxValue * 100	
	local db = aUF.db.profile
	
	if ( not UnitExists(self.unit) or UnitIsDead(self.unit) or UnitIsGhost(self.unit) or not UnitIsConnected(self.unit) or (currValue == 1 and maxValue == 1) ) then
		self.ManaBar:SetValue(0)
	else
		if maxValue == 0 then
			self.ManaBar:SetValue(0)
		else
			self.ManaBar:SetValue(perc)
		end
	end
	
	local powertype = UnitPowerType(self.unit)
	if (self.powertype ~= powertype) then
		self.powertype = powertype
		
		local info = db.ManaColor[powertype]
		if self.flags.AlphaBar == true and info~=nil then
			self.ManaBar_BG:SetVertexColor(info.r,info.g,info.b,0.25)
		else
			self.ManaBar_BG:SetVertexColor(0,0,0,0.25)
		end
		if info~=nil then
			self.ManaBar:SetStatusBarColor(info.r,info.g,info.b,0.8)
		end
	end
	self:UpdateTextStrings()
end

function aUF.classes.aUFunit.prototype:StatusBarsColor()
	local db = aUF.db.profile
	local healthColor
	local _,Eclass = UnitClass(self.unit)

	if string.find(self.unit,"target") and not UnitIsFriend(self.unit, "player") and (aUF.db.profile.TargetShowHostile == true ) then
		healthColor = aUF:UtilFactionColors(self.unit)
		self.flags.BarColor = 1
	elseif self.unit == "pet" and self.flags.HappinessBar == true and Eclass ~= "WARLOCK" then
		local happiness = GetPetHappiness()
		if ( happiness == 1 ) then
			healthColor = aUF.ManaColor[1]
		elseif ( happiness == 2 ) then
			healthColor = aUF.ManaColor[3]
		else
			healthColor = db.HealthColor
		end
		self.flags.BarColor = 2
	elseif UnitIsFriend(self.unit, "player") and UnitIsPlayer(self.unit) and self.database.ClassColorBars == true and RAID_CLASS_COLORS[Eclass] then
		healthColor = RAID_CLASS_COLORS[Eclass]
		self.flags.BarColor = 3
	else
		healthColor = db.HealthColor
		self.flags.BarColor = 4
	end
	
	self.HealthBar:SetStatusBarColor(healthColor.r,healthColor.g,healthColor.b, 1)
	if self.flags.BackgroundBarColor == true then
		self.HealthBar_BG:SetVertexColor(healthColor.r,healthColor.g,healthColor.b,0.25)
	else
		self.HealthBar_BG:SetVertexColor(0,0,0,0.25)
	end

	-- mana
	local powertype = UnitPowerType(self.unit)
	local info = db.ManaColor[powertype]
	if self.flags.AlphaBar == true and info~=nil then
		self.ManaBar_BG:SetVertexColor(info.r,info.g,info.b,0.25)
	else
		self.ManaBar_BG:SetVertexColor(0,0,0,0.25)
	end
	if info~= nil then
		self.ManaBar:SetStatusBarColor(info.r,info.g,info.b,0.8)
	end
end

function aUF.classes.aUFunit.prototype:StatusBarsOnValueChanged(value)
	if ( aUF.db.profile.SmoothHealthBars == true ) then
		if self.flags.BarColor == 1 then
			self:SmoothTargetHealthBarOnValueChanged(value,aUF:UtilFactionColors(self.unit))
		elseif self.flags.BarColor == 4 then
			self:SmoothHealthBarOnValueChanged(value)
		end
	end
end

function aUF.classes.aUFunit.prototype:SmoothTargetHealthBarOnValueChanged(value,colortable)
	if ( not value ) then
		return
	end
	local r, g, b
	local min, max = this:GetMinMaxValues()
	if ( (value < min) or (value > max) ) then
		return
	end
	if ( (max - min) > 0 ) then
		value = (value - min) / (max - min)
	else
		value = 0
	end
	
	r = colortable.r*(0.35*value+0.65)
	g = colortable.g*(0.35*value+0.65)
	b = colortable.b*(0.35*value+0.65)
	this:SetStatusBarColor(r, g, b)
end
	
function aUF.classes.aUFunit.prototype:SmoothHealthBarOnValueChanged(value)
	if ( not value ) then
		return
	end
	local db = aUF.db.profile
	local r, g, b
	local min, max = this:GetMinMaxValues()
	if ( (value < min) or (value > max) ) then
		return
	end
	if ( (max - min) > 0 ) then
		value = (value - min) / (max - min)
	else
		value = 0
	end
	if(value > 0.5) then
		r = (db.HealthColor.r) + (((1-value) * 2)* (1-(db.HealthColor.r)))
		g = db.HealthColor.g
	else
		r = 1.0
		g = (db.HealthColor.g) - (0.5 - value)* 2 * (db.HealthColor.g)
	end
	b = db.HealthColor.b
	this:SetStatusBarColor(r, g, b)
end

-- MOUSE INTERACTION

function aUF.classes.aUFunit.prototype:OnDragStart(button)
	if self.subgroup then
		aUF.subgroups[self.subgroup]:OnDragStart(button)
		return
	end
	if button == "LeftButton" and (aUF.db.profile.Locked == false or IsAltKeyDown()) then
		self.frame:StartMoving()
	end
end

function aUF.classes.aUFunit.prototype:OnDragStop(button)
	if self.subgroup then
		aUF.subgroups[self.subgroup]:OnDragStop(button)
		return
	end
	self.frame:StopMovingOrSizing()
	self:SavePosition()
end
	
function aUF.classes.aUFunit.prototype:OnClick(button)
	--Modified by Skela - Changes for Menu on click
	if (IsAltKeyDown() or IsControlKeyDown()) and (button == "LeftButton" or button == "RightButton") and aUF.db.profile.MenuOnModifiedClick then
	--Modified by Skela - Changes for Menu on click
		aUF.dewdrop:Open(self.frame, 'children', aUF:CreateDewdrop(self.type),'cursorX', true, 'cursorY', true)
		return
	end
	if button == "LeftButton" then
		if SpellIsTargeting() then
			SpellTargetUnit(self.unit)
		elseif CursorHasItem() then
			if UnitIsUnit(self.unit, "player") then
				AutoEquipCursorItem()
			elseif UnitIsFriend(self.unit, "player") and UnitIsPlayer(self.unit) then
				DropItemOnUnit("target")
			end
		else
			TargetUnit(self.unit)
		end
	elseif button == "RightButton" then
		self:DropDownUnit(self.unit)
	end
end

function aUF.classes.aUFunit.prototype:OnEnter()
	self.frame.unit = self.unit
	self:UpdateHighlight(true)
	UnitFrame_OnEnter()
end

function aUF.classes.aUFunit.prototype:OnLeave()
	self:UpdateHighlight()
	UnitFrame_OnLeave()
end

function aUF.classes.aUFunit.prototype:DropDownUnit()
	local type = nil

	if self.unit == "player" then
		type = PlayerFrameDropDown
	elseif self.unit == "target" then
		type = TargetFrameDropDown
	elseif self.unit == "pet" then
		type = PetFrameDropDown
	elseif self.type == "party" then
		type = getglobal("PartyMemberFrame"..self.number.."DropDown")
	elseif string.find(self.unit, "raid") then
		type = FriendsDropDown
		this.unit = self.unit
		this.name = UnitName(self.unit)
		this.id = this:GetID()
		FriendsDropDown.displayMode = "MENU"
		FriendsDropDown.initialize = RaidFrameDropDown_Initialize
	end

	if self.number then this:SetID(self.number) end

	if type then
		HideDropDownMenu(1)
		type.unit = self.unit
		type.name = UnitName(self.unit)
		ToggleDropDownMenu(1, nil, type,"cursor")
		return true
	end
end

function aUF.classes.aUFunit.prototype:AuraOnEnter()
	if (not this:IsVisible()) then return end
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT")
	if ( this.buffFilter == "HELPFUL") then
		GameTooltip:SetUnitBuff(self.unit, this.id, self.database.AuraFilter)
	elseif ( this.buffFilter == "HARMFUL") then
		GameTooltip:SetUnitDebuff(self.unit, this.id, 0)
	end
end

function aUF.classes.aUFunit.prototype:UnitCombat(unit)
	if unit ~= self.unit then return end
	if not ( self.database.ShowCombat ) then return end
	self:CombatFeedback_OnCombatEvent(arg1, arg2, arg3, arg4, arg5)
end

function aUF.classes.aUFunit.prototype:UnitSpellmiss(unit)
	if unit ~= self.unit then return end
	if not ( self.database.ShowCombat ) then return end
	self:CombatFeedback_OnSpellMissEvent(arg1, arg2)
end

function aUF.classes.aUFunit.prototype:CombatFeedback_OnCombatEvent(unit, event, flags, amount, type)
	local fontHeight = 13
	local text = ""
	local r,g,b = 1,1,1
	if( event == "IMMUNE" ) then
		fontHeight = fontHeight * 0.75
		text = CombatFeedbackText[event]
	elseif ( event == "WOUND" ) then
		if ( amount ~= 0 ) then
			if ( flags == "CRITICAL" or flags == "CRUSHING" ) then
				fontHeight = fontHeight * 1.5
			elseif ( flags == "GLANCING" ) then
				fontHeight = fontHeight * 0.75
			end
			if ( type > 0 ) then
				r = 1.0
				g = 1.0
				b = 0.0
			end
			if UnitInParty(self.unit) or UnitInRaid(self.unit) then
				r = 1.0
				g = 0.0
				b = 0.0
			end
			text = "-"..amount
		elseif ( flags == "ABSORB" ) then
			fontHeight = fontHeight * 0.75
			text = CombatFeedbackText["ABSORB"]
		elseif ( flags == "BLOCK" ) then
			fontHeight = fontHeight * 0.75
			text = CombatFeedbackText["BLOCK"]
		elseif ( flags == "RESIST" ) then
			fontHeight = fontHeight * 0.75
			text = CombatFeedbackText["RESIST"]
		else
			text = CombatFeedbackText["MISS"]
		end
	elseif ( event == "BLOCK" ) then
		fontHeight = fontHeight * 0.75
		text = CombatFeedbackText[event]
	elseif ( event == "HEAL" ) then
		text = "+"..amount
		r = 0.0
		g = 1.0
		b = 0.0
		if ( flags == "CRITICAL" ) then
			fontHeight = fontHeight * 1.3
		end
	elseif ( event == "ENERGIZE" ) then
		text = amount
		r = 0.41
		g = 0.8
		b = 0.94
		if ( flags == "CRITICAL" ) then
			fontHeight = fontHeight * 1.3
		end
	else
		text = CombatFeedbackText[event]
	end

	self.feedbackStartTime = GetTime()

	local font = self.HitIndicator:GetFont()
	self.HitIndicator:SetFont(font,fontHeight,"OUTLINE")
	self.HitIndicator:SetText(text)
	self.HitIndicator:SetTextColor(r, g, b)
	self.HitIndicator:SetAlpha(0)
	self.HitIndicator:Show()
	self.HitIndicator:SetPoint("CENTER",self.frame,"CENTER")

	aUF.feedback[self.name] = true
	aUF:ScheduleRepeatingEvent("agUF_CombatSchedule",aUF.FeedbackUpdate, 0.05, aUF)
end

-- UNITXP CLASS

function aUF.classes.aUFunitXP.prototype:init(name,unit)
	aUF.classes.aUFunitXP.super.prototype.init(self,name,unit)
	self:RegisterXPEvents()
	self:UpdateXP()
	self:UpdateRep()
end

function aUF.classes.aUFunitXP.prototype:RegisterXPEvents()
	if self.unit == "player" then
		self:RegisterEvent("PLAYER_XP_UPDATE","UpdateXP")
		self:RegisterEvent("UPDATE_EXHAUSTION","UpdateXP")
		self:RegisterEvent("PLAYER_LEVEL_UP","UpdateXP")
	elseif self.unit == "pet" then
		self:RegisterEvent("UNIT_PET_EXPERIENCE","UpdateXP")
	end
end

function aUF.classes.aUFunitXP.prototype:UpdateRep(newLevel)
	if self.hooks["ReputationWatchBar_Update"] then
		self.hooks["ReputationWatchBar_Update"].orig(tonumber(newLevel))
	else
		self:Hook("ReputationWatchBar_Update", "UpdateRep")
	end
	local repname, repreaction, repmin, repmax, repvalue = GetWatchedFactionInfo()
	if ( repname and UnitLevel("player") == 60) then
		local color = aUF.RepColor[repreaction]
		repmax = repmax - repmin
		repvalue = repvalue - repmin
		repmin = 0
	
		if self.XPBar_Rest or repmax == 0 then
			self.XPBar_Rest:Hide()
		end
		
		self.XPBar:SetParent(self.frame)
		self.XPBar:Show()
		if repmax ~= 0 then
			self.XPBar:SetValue((repvalue/repmax)*100)
		else
			self.XPBar:SetValue(0)
		end
		self.XPBar:SetStatusBarColor(color.r, color.g, color.b)
		self.XPBar_BG:SetVertexColor(color.r, color.g, color.b, 0.25)
	end
	self:UpdateXP()
end

function aUF.classes.aUFunitXP.prototype:UpdateXP()
	local _,eClass = UnitClass("player")
	if self.unit == "pet" and eClass == "HUNTER" then
		return
	end
	local repname, repreaction, repmin, repmax, repvalue = GetWatchedFactionInfo()
	if ( self.database.ShowXP == true ) then
		if ((( UnitLevel("player") < MAX_PLAYER_LEVEL ) or not repname) and self.unit == "player") or (self.unit == "pet") then
			local priorXP = self.XPBar:GetValue()
			local restXP 
			local currXP, nextXP
			
			if self.unit == "player" then
				self.XPBar:SetParent(self.XPBar_Rest)
				currXP = UnitXP(self.unit)
				nextXP = UnitXPMax(self.unit)
				restXP = GetXPExhaustion()
			else
				currXP, nextXP = GetPetExperience()
			end
			
			if nextXP ~= 0 then
				self.XPBar:SetValue((currXP/nextXP)*100)
			else
				self.XPBar:SetValue(0)
			end
			
			if self.XPBar_Rest then
				if ( restXP and self.unit == "player" ) then
					self.XPBar_Rest:Show()
					if nextXP ~= 0 then
						self.XPBar_Rest:SetValue(((currXP+restXP)/nextXP)*100)
					else
						self.XPBar_Rest:SetValue(0)
					end
				else
					self.XPBar:SetParent(self.frame)
					self.XPBar:Show()
					self.XPBar_Rest:Hide()
				end
			end
			
			self.XPBar:SetStatusBarColor(0.8, 0, 0.7)
			if self.flags.BackgroundBarColor == true then
				self.XPBar_BG:SetVertexColor(0.8, 0, 0.7, 0.25)
			else
				self.XPBar_BG:SetVertexColor(0, 0, 0, 0.25)
			end
		end
	else
		self.XPBar:Hide()
		self.XPBar_BG:Hide()
		if self.XPBar_Rest then
			self.XPBar_Rest:Hide()
		end
	end
end

function aUF.classes.aUFunitCombo.prototype:init(name,unit)
	aUF.classes.aUFunitCombo.super.prototype.init(self,name,unit)
	self:RegisterComboEvents()
end

function aUF.classes.aUFunitCombo.prototype:RegisterComboEvents()
	self:RegisterEvent("PLAYER_COMBO_POINTS","UpdateComboPoints")
end

function aUF.classes.aUFunitCombo.prototype:CreateCombos()
	for i=1,5 do
		self["Combo"..i] = self.frame:CreateTexture(nil,"OVERLAY")
		self["Combo"..i]:SetTexture(aUF.imagePath.."combo.tga")
		self["Combo"..i]:SetHeight(10)
		self["Combo"..i]:SetWidth(10)
		self["Combo"..i]:Hide()
		if i > 1 then
			self["Combo"..i]:SetPoint("BOTTOMRIGHT",self["Combo"..i-1],"BOTTOMLEFT")
		end
	end
end

function aUF.classes.aUFunitCombo.prototype:UpdateComboPoints()
	local points = GetComboPoints()
	for i=0,4 do
		if points > i then
			self["Combo"..i+1]:Show()
		else
			self["Combo"..i+1]:Hide()
		end
	end
end

function aUF.classes.aUFunitMetro.prototype:init(name,unit)
	aUF.classes.aUFunitMetro.super.prototype.init(self,name,unit)
end

function aUF.classes.aUFunitMetro.prototype:UpdateMetro()	
	if self:SetVisibility() then
		self:UpdateHealth(true)
		self:UpdatePower(true)
		self:UpdateAuras(true)
		self:UpdateRaidTargetIcon(true)
		self:StatusBarsColor()
		self:UpdateTextStrings()
		if self.database.Portrait and self.flags.Portrait and self.unitName ~= UnitName(self.unit) then
			self:UpdatePortrait()
		end
	end
	self:UpdateVisibility()
	self.unitName = UnitName(self.unit)
end

function aUF.classes.aUFunitMetro.prototype:Start()
	if not self.database.HideFrame == true then
		self:UpdateMetro()
		if not self.schedule then
			self.schedule = self:ScheduleRepeatingEvent(self.UpdateMetro, 0.8, self)
		end
	end
end

function aUF.classes.aUFunitMetro.prototype:Stop()
	if self.schedule and self:IsEventScheduled(self.schedule) then
		self:CancelScheduledEvent(self.schedule)
		self.schedule = nil
	end
	self:UpdateMetro()
end

-- UNITRAID CLASS

function aUF.classes.aUFunitRaid.prototype:init(name,unit)
	aUF.classes.aUFunitRaid.super.prototype.init(self,name,unit)
	self:RegisterEvent("RAID_ROSTER_UPDATE","RosterUpdate")
	self:RosterUpdate()
end

function aUF.classes.aUFunitRaid.prototype:RosterUpdate()
	if aUF:CheckVisibility(self.unit) then
		self.inRaid = true
	end
	if self.inRaid == true then
		if self:UpdateAll() == true then
			self.inRaid = true
		else
			self.inRaid = false
		end
	end
end

