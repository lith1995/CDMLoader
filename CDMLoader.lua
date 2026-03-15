
local ADDON_NAME, _ = ...
local ADDON = LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)
local InCombat = InCombatLockdown
local Reload = C_UI.Reload
local CooldownViewerSettings = _G.CooldownViewerSettings
local CooldownViewer = _G.C_CooldownViewer
local playerUnit = "player"

-- Helper to get CDM layout status and handle error printing
local function GetCDMLayoutStatus(self)
	local _, _, ClassID = UnitClass(playerUnit)

	local importString = self.db.profile.CDMLayout[ClassID]
	local currentLayout = CooldownViewer.GetLayoutData()
	local isUpToDate = importString and (importString == currentLayout)
	return importString, currentLayout, ClassID, isUpToDate
end

local function IsCooldownViewerAvailable(self)
	if InCombat() then
		self:Print("|cffFF0000Cooldown Viewer is not available while in combat.")
		return false
	end
	local isAvailable, errorMsg = CooldownViewer.IsCooldownViewerAvailable()
	if not isAvailable then
		self:Print("|cffFF0000Cooldown Viewer is not available: " .. (errorMsg or "Unknown error"))
		return false
	end
	return true
end

local function load(self, importString)
	CooldownViewer.SetLayoutData(importString)
	Reload()
	self:Print("Cooldown Manager Layout Loaded.")
end

function ADDON:IsLayoutUpToDate()
		if not IsCooldownViewerAvailable(self) then return end
		local importString, _, _, isUpToDate = GetCDMLayoutStatus(self)
		if not isUpToDate then
			if self.db.profile.autoLoadCDMLayout then
				load(self, importString)
			else
				self:Print("|cffFF0000Cooldown Manager Layout is outdated use \"/cdm load\" to update it.|r")
			end
		end
end

function ADDON:LoadCDMLayout()
	if not IsCooldownViewerAvailable(self) then return end

	local importString, _, _, isUpToDate = GetCDMLayoutStatus(self)
	if not importString then
		self:Print("No saved layout found for your class.")
		return
	end
	if isUpToDate then
		self:Print("Cooldown Manager Layout is already up to date.")
		return
	end
	if self.db.profile.autoAcceptDialog then
		load(self, importString)
	else
		ADDON:ConfirmDialog("Loading the saved layout will overwrite your current layout. Do you want to continue?", function() load(self, importString) end)
	end	
end

local function save(self, currentLayout, ClassID)
	self.db.profile.CDMLayout[ClassID] = currentLayout
	self:Print("Cooldown Manager Layout Saved.")
end

function ADDON:SaveCDMLayout()
	if not IsCooldownViewerAvailable(self) then return end

	local wasSettingsOpen = CooldownViewerSettings:IsShown()
	if wasSettingsOpen then CooldownViewerSettings:Hide() end
	local _, currentLayout, ClassID, isUpToDate = GetCDMLayoutStatus(self)
	if isUpToDate then
		self:Print("Saved Cooldown Manager Layout is already up to date.")
	else
		if self.db.profile.autoAcceptDialog then
			save(self, currentLayout, ClassID)
		else
			ADDON:ConfirmDialog("Saving a new layout will overwrite your saved layout. Do you want to continue?", function() save(self, currentLayout, ClassID) end)
		end
	end
	if wasSettingsOpen then CooldownViewerSettings:Show() end
end

function ADDON:OpenCDMSettings()
	if not IsCooldownViewerAvailable(self) then return end
	if not CooldownViewerSettings:IsShown() then
		CooldownViewerSettings:Show()
	end
end

