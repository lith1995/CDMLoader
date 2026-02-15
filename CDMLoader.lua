local ADDON_NAME, _ = ...
local ADDON = LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)
local InCombat = InCombatLockdown
local Reload = C_UI.Reload
local CooldownViewerSettings = _G.CooldownViewerSettings
local CooldownViewer = _G.C_CooldownViewer
local playerUnit = "player"



function ADDON:IsLayoutUpToDate()
	local _, _, ClassID = UnitClass(playerUnit)
	local isCDMAVailable, CDMError = CooldownViewer.IsCooldownViewerAvailable()

	if isCDMAVailable then
		local importString = self.db.profile.CDMLayout[ClassID]
		local currentLayout = CooldownViewer.GetLayoutData()
		if importString and importString ~= currentLayout then
			if self.db.profile.autoLoadCDMLayout then
				CooldownViewer.SetLayoutData(importString)
				self:Print("Cooldown Manager Layout Loaded.")
			else
				self:Print("|cffFF0000Cooldown Manager Layout is outdated use \"/cdm load\" to update it.|r")
				return
			end
		end
	else
		self:Print("Cooldown Viewer is not available: " .. CDMError)
	end
end

function ADDON:LoadCDMLayout()
	if InCombat() then
		self:Print("Cannot load layout while in combat.")
		return
	end
	local _, _, ClassID = UnitClass(playerUnit)
	local isCDMAVailable, CDMError = CooldownViewer.IsCooldownViewerAvailable()


	if isCDMAVailable then
		local importString = self.db.profile.CDMLayout[ClassID]
		local currentLayout = CooldownViewer.GetLayoutData()
		
		if importString == currentLayout then
			self:Print("Cooldown Manager Layout is already up to date.")
			return
		end

		if importString then
			CooldownViewer.SetLayoutData(importString)
			Reload()
			self:Print("Cooldown Manager Layout Loaded.")
		else
			self:Print("No saved layout found for your class.")
		end
	else
		self:Print("Cooldown Viewer is not available: " .. CDMError)
	end
end

function ADDON:SaveCDMLayout()
	if InCombat() then
		self:Print("Cannot save layout while in combat.")
		return
	end
	local _, _, ClassID = UnitClass(playerUnit)
	local isCDMAVailable, CDMError = CooldownViewer.IsCooldownViewerAvailable()
	if isCDMAVailable then
		local isCooldownViewerSettingsOpen = CooldownViewerSettings:IsShown()
		if isCooldownViewerSettingsOpen then
			CooldownViewerSettings:Hide()
		end
		local CDMLayout = CooldownViewer.GetLayoutData()
		self.db.profile.CDMLayout[ClassID] = CDMLayout
		if isCooldownViewerSettingsOpen then
			CooldownViewerSettings:Show()
		end
		self:Print("Cooldown Manager Layout Saved.")
	else
		self:Print("Cooldown Viewer is not available: " .. CDMError)
	end
end

function ADDON:OpenCDMSettings()
	if InCombat() or not CooldownViewerSettings then return end
	if not CooldownViewerSettings:IsShown() then
		CooldownViewerSettings:Show()
	end
end

