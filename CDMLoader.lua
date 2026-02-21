
local ADDON_NAME, _ = ...
local ADDON = LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)
local InCombat = InCombatLockdown
local Reload = C_UI.Reload
local CooldownViewerSettings = _G.CooldownViewerSettings
local CooldownViewer = _G.C_CooldownViewer
local playerUnit = "player"
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

-- Create a button with the CDMLoaderUIButtonMixin and set its properties
local function CreateCDMButton(name, tooltipText, iconFile, onClick, shift)
	local buttonsize = 58
	local offset = shift * buttonsize
	local button = CreateFrame("Button", name, CooldownViewerSettings, "CDMTabButtonTemplate")
	button:SetPoint("TOP", CooldownViewerSettings.AurasTab, "BOTTOM", 0, -3 - offset)
	button.tooltipText = tooltipText
	button:SetIcon("Interface/AddOns/CDMLoader/Media/ButtonIcons/" .. iconFile .. ".tga")
	button:SetScript("OnClick", onClick)
	return button
end

-- Helper to get CDM layout status and handle error printing
local function GetCDMLayoutStatus(self)
	local _, _, ClassID = UnitClass(playerUnit)
	local isAvailable, errorMsg = CooldownViewer.IsCooldownViewerAvailable()
	if not isAvailable then
		self:Print("Cooldown Viewer is not available: " .. (errorMsg or "Unknown error"))
		return nil, nil, nil, false
	end
	local importString = self.db.profile.CDMLayout[ClassID]
	local currentLayout = CooldownViewer.GetLayoutData()
	return importString, currentLayout, ClassID, true
end

function ADDON:IsLayoutUpToDate()
		local importString, currentLayout, _, isAvailable = GetCDMLayoutStatus(self)
		if not isAvailable then return end
		if importString and importString ~= currentLayout then
			if self.db.profile.autoLoadCDMLayout then
				CooldownViewer.SetLayoutData(importString)
				self:Print("Cooldown Manager Layout Loaded.")
			else
				self:Print("|cffFF0000Cooldown Manager Layout is outdated use \"/cdm load\" to update it.|r")
			end
		end
end

function ADDON:LoadCDMLayout()
		if InCombat() then
			self:Print("Cannot load layout while in combat.")
			return
		end
		local importString, currentLayout, _, isAvailable = GetCDMLayoutStatus(self)
		if not isAvailable then return end
		if not importString then
			self:Print("No saved layout found for your class.")
			return
		end
		if importString == currentLayout then
			self:Print("Cooldown Manager Layout is already up to date.")
			return
		end
		CooldownViewer.SetLayoutData(importString)
		Reload()
		self:Print("Cooldown Manager Layout Loaded.")
end

function ADDON:SaveCDMLayout()
		if InCombat() then
			self:Print("Cannot save layout while in combat.")
			return
		end
		local _, _, ClassID, isAvailable = GetCDMLayoutStatus(self)
		if not isAvailable then return end
		local wasSettingsOpen = CooldownViewerSettings:IsShown()
		if wasSettingsOpen then CooldownViewerSettings:Hide() end
		self.db.profile.CDMLayout[ClassID] = CooldownViewer.GetLayoutData()
		if wasSettingsOpen then CooldownViewerSettings:Show() end
		self:Print("Cooldown Manager Layout Saved.")
end

function ADDON:OpenCDMSettings()
	if InCombat() or not CooldownViewerSettings then return end
	if not CooldownViewerSettings:IsShown() then
		CooldownViewerSettings:Show()
	end
end


function ADDON:InitCDMButtons()
	local shift = 0
	if IsAddOnLoaded('CooldownManagerCentered') then
		shift = shift + 1
	end
	
	CreateCDMButton("SaveCDMButton", "Save your current CDM layout", "SaveIcon", function() ADDON:SaveCDMLayout() end, shift)
	shift = shift + 1
	CreateCDMButton("LoadCDMButton", "Load your saved CDM layout", "LoadIcon", function() ADDON:LoadCDMLayout() end, shift)
end

