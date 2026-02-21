local ADDON_NAME, _ = ...
local ADDON = LibStub("AceAddon-3.0"):NewAddon(ADDON_NAME, "AceConsole-3.0", "AceEvent-3.0")
_G[ADDON_NAME] = ADDON -- store reference to addon

local AC = LibStub("AceConfig-3.0")
local ACD = LibStub("AceConfigDialog-3.0")

local defaults = {
	profile = {
		CDMLayout = {},
		autoLoadCDMLayout = false
	},
}
local options = {
	name = "CDMLoader",
	handler = ADDON,
	type = "group",
	args = {
		autoLoadCDMLayout = {
			type = "toggle",
			name = "Auto-load layout",
			desc = "|cffFF0000EXPERIMENTAL|r\nAutomatically load the saved Cooldown Manager layout on login.",
			get = "IsAutoLoad",
			set = "SetAutoLoad"
		},
	},
}

function ADDON:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("CDMLoaderDB", defaults, true)
	AC:RegisterOptionsTable("CDMLoader_options", options)
	self.optionsFrame = ACD:AddToBlizOptions("CDMLoader_options", "CDMLoader")

	local profiles = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)
	AC:RegisterOptionsTable("CDMLoaderProfiles", profiles)
	ACD:AddToBlizOptions("CDMLoaderProfiles", "Profiles", "CDMLoader")

	self:RegisterEvent("PLAYER_LOGIN", "IsLayoutUpToDate")
    self:RegisterChatCommand("cdm", "SlashCommand")
end

function ADDON:OnEnable()
	ADDON:InitCDMButtons()
end

function ADDON:OnDisable()
    -- Called when the addon is disabled
end

function ADDON:SlashCommand(msg)
	if msg == "load" then
		self:LoadCDMLayout()
	elseif msg == "save" then
		self:SaveCDMLayout()
	elseif msg == "" then
		self:OpenCDMSettings()
	elseif msg == "help" then
		self:Print("CDMLoader Commands:")
		self:Print("/cdm load - Load CooldownViewer Layout")
		self:Print("/cdm save - Save CooldownViewer Layout")
		self:Print("/cdm - Open CooldownViewer Settings")
		self:Print("/cdm help - Show this help message")
	else
		self:Print("Unknown command. Type /cdm help for a list of commands.")
	end
end


function ADDON:IsAutoLoad(info)
	return self.db.profile.autoLoadCDMLayout
end

function ADDON:SetAutoLoad(info, value)
	self.db.profile.autoLoadCDMLayout = value
end