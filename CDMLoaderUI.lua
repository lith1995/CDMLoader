local ADDON_NAME, _ = ...
local ADDON = LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)

CDMLoaderUIButtonMixin = {}


function CDMLoaderUIButtonMixin:OnLoad()
    if self.iconFile then
        self.Icon:SetTexture(self.iconFile)
    end
end
function CDMLoaderUIButtonMixin:OnMouseDown(button)
	if button == "LeftButton" then
		self.Icon:SetPoint("CENTER", -1, -1);
		end
	end
function CDMLoaderUIButtonMixin:OnMouseUp(button)
	if button == "LeftButton" then
		self.Icon:SetPoint("CENTER", -2, 0);
		PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB);
	end
end

function CDMLoaderUIButtonMixin:OnEnter()
	if self.tooltipText then
		local tooltip = GetAppropriateTooltip();
		tooltip:SetOwner(self, "ANCHOR_RIGHT", -4, -4);
		tooltip:SetText(self.tooltipText);
		tooltip:Show();
	end
end
function CDMLoaderUIButtonMixin:OnLeave()
	GetAppropriateTooltip():Hide();
end

function CDMLoaderUIButtonMixin:SetTextToFit(text)
	self:SetText(text);
	self:FitToText();
end

function CDMLoaderUIButtonMixin:Onclick_loadCDMLayout()
	ADDON:LoadCDMLayout()
end
function CDMLoaderUIButtonMixin:Onclick_saveCDMLayout()
	ADDON:SaveCDMLayout()
end