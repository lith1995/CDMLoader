local ADDON, _ = ...
local CDMLoader = LibStub("AceAddon-3.0"):GetAddon(ADDON)
local InCombat = InCombatLockdown
local Reload = C_UI.Reload
local CooldownViewerSettings = _G.CooldownViewerSettings
local CooldownViewer = _G.C_CooldownViewer
local playerUnit = "player"


function CDMLoader:LoadCDMLayout()
	if InCombat() then
		self:Print("Cannot load layout while in combat.")
		return
	end
	local _, _, ClassID = UnitClass(playerUnit)
	local isCDMAVailable, CDMError = CooldownViewer.IsCooldownViewerAvailable()
	if isCDMAVailable then
		if self.db.profile.CDMLayout[ClassID] then
			local importString = self.db.profile.CDMLayout[ClassID]
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

function CDMLoader:SaveCDMLayout()
	if InCombat() then
		self:Print("Cannot save layout while in combat.")
		return
	end
	local _, _, ClassID = UnitClass(playerUnit)
	local isCDMAVailable, CDMError = CooldownViewer.IsCooldownViewerAvailable()
	if isCDMAVailable then
		CDMLayout = CooldownViewer.GetLayoutData()
		self.db.profile.CDMLayout[ClassID] = CDMLayout
		self:Print("Cooldown Manager Layout Saved.")
	else
		self:Print("Cooldown Viewer is not available: " .. CDMError)
	end
end

function CDMLoader:OpenCDMSettings()
	if InCombat() or not CooldownViewerSettings then return end
	if not CooldownViewerSettings:IsShown() then
		CooldownViewerSettings:Show()
	end
end

