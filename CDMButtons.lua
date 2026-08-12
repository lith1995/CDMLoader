local ADDON_NAME, _ = ...
local ADDON = LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)
local CooldownViewerSettings = _G.CooldownViewerSettings
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded

-- Create a button with the CDMLoaderUIButtonMixin and set its properties
local function CreateCDMButton(name, tooltipText, iconFile, onClick, relativeTo, offsetX)
	local offsetX = offsetX or 0
	local button = CreateFrame("Button", name, CooldownViewerSettings, "CDMTabButtonTemplate")
	button:SetPoint("TOP", relativeTo, "BOTTOM", 0, -3- offsetX)
	button.tooltipText = tooltipText
	button:SetIcon("Interface/AddOns/CDMLoader/Media/ButtonIcons/" .. iconFile .. ".tga")
	button:SetScript("OnClick", onClick)
	return button
end

function ADDON:InitCDMButtons()
	local offsetX = 0
	if IsAddOnLoaded('CooldownManagerCentered') then
		local buttonSize = 58
		local offsetMultiplier = 2
		offsetX = buttonSize * offsetMultiplier
	end
	local save_button = CreateCDMButton("SaveCDMButton", "Save your current CDM layout", "SaveIcon", function() ADDON:SaveCDMLayout() end, CooldownViewerSettings.GroupBuffsTab, offsetX)
	CreateCDMButton("LoadCDMButton", "Load your saved CDM layout", "LoadIcon", function() ADDON:LoadCDMLayout() end, save_button)
end