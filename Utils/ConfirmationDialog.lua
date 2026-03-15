local ADDON_NAME, _ = ...
local ADDON = LibStub("AceAddon-3.0"):GetAddon(ADDON_NAME)
local StaticPopup_Show = StaticPopup_Show
local StaticPopupDialogs = StaticPopupDialogs
local YES = YES
local NO = NO

StaticPopupDialogs[ADDON_NAME .. "_CONFIRM"] = {
    text = "%s",
    button1 = YES,
    button2 = NO,
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,

    OnAccept = function(self, data)
        if type(data.accept) == "function" then
            data.accept()  
        end
    end,

}


function ADDON:ConfirmDialog(message, onAccept)
    StaticPopup_Show(
        ADDON_NAME .. "_CONFIRM",
        message,
        nil,
        { accept = onAccept }
    )
end