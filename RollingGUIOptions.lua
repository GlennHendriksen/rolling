local Options = {}

Options.panel = CreateFrame( "Frame", "RollingFrameOptions", UIParent );
Options.panel.name = "Rolling Manager";
InterfaceOptions_AddCategory(Options.panel);

Options.panel.okay =
function(self)
	RollingI.Cancel = Options.Cancel:GetText()
	RollingI.Start = Options.Start:GetText()
	RollingI.WinChat = Options.Win:GetText()
	RollingI.CancelMessage = Options.Cancelbutton:GetChecked()
	RollingI.Timer = tonumber(Options.Timer:GetText())
	RollingI.TimerCount = Options.TimerCount:GetChecked()
	RollingI.Debugbutton = Options.Debugbutton:GetChecked()
	RollingI.ReRolling = Options.ReRolling:GetText()
	RollingI.PickWinner = Options.PickWinner:GetText()
end

Options.panel.cancel =
function(self)
	Options.Start:SetText(RollingI.Start)
    Options.Cancel:SetText(RollingI.Cancel)
    Options.Win:SetText(RollingI.WinChat)
    Options.Cancelbutton:SetChecked(RollingI.CancelMessage)
    Options.Timer:SetText(RollingI.Timer)
    Options.TimerCount:SetChecked(RollingI.TimerCount)
	Options.Debugbutton:SetChecked(RollingI.Debugbutton)
	Options.ReRolling:SetText(RollingI.ReRolling)
	Options.PickWinner:SetText(RollingI.PickWinner)
end

Options.panel.default =
function(self)
	Options.Start:SetText(RollingI.Default.Start)
    Options.Cancel:SetText(RollingI.Default.Cancel)
	Options.Win:SetText(RollingI.Default.WinChat)
	Options.ReRolling:SetText(RollingI.Default.ReRolling)
	Options.PickWinner:SetText(RollingI.Default.PickWinner)
    Options.Cancelbutton:SetChecked(false)
    RollingI.CancelMessage = false
    Options.Timer:SetText(RollingI.Default.Timer)
    Options.TimerCount:SetChecked(false)
    RollingI.TimerCount = false
    Options.Debugbutton:SetChecked(false)
    RollingI.Debugbutton = false
end

Options.panel:Hide()

local function all_my_buttons_OnEnter (self)
    GameTooltip:SetOwner (self, "ANCHOR_RIGHT")
    GameTooltip:SetText (self.tooltip_text, nil, nil, nil, nil, true)
    GameTooltip:Show()
end
local function all_my_buttons_OnLeave (self)
    GameTooltip_Hide()
end

local RollingMg=CreateFrame("Frame", "RMTitle", RollingFrameOptions)
	RollingMg:SetPoint("TOPLEFT", 10, -10)
	--RollingMg:SetScale(2.0)
	RollingMg:SetWidth(300)
	RollingMg:SetHeight(100)
	RollingMg:Show()

local RollingMgFS = RollingMg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	RollingMgFS:SetText('|cff00c0ffRolling Manager|r')
	RollingMgFS:SetPoint("TOPLEFT", 0, 0)
	RollingMgFS:SetFont("Fonts\\FRIZQT__.TTF", 20)

local RollingMgDS = RollingMg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	RollingMgDS:SetText('|cffdbc253Thanks for using my Addons,\nhere you can change some text like you want.\n%i = Item \n%p = Player\n%n = Number of roll|r')
	RollingMgDS:SetJustifyH("LEFT")
	RollingMgDS:SetPoint("TOPLEFT", 10, -33)
	RollingMgDS:SetFont("Fonts\\FRIZQT__.TTF", 15)

local versionFS = RollingFrameOptions:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	versionFS:SetText('|cff00c0ffv '.. GetAddOnMetadata(select(1, ...), "Version") ..'|r')
	versionFS:SetPoint("BOTTOMRIGHT", -10, 10)
	versionFS:SetFont("Fonts\\FRIZQT__.TTF", 12)

local Desc1 = RollingMg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Desc1:SetText('|cffdbc253If you roll a item.|r')
	Desc1:SetPoint("TOPLEFT", 2, -120)
	Desc1:SetFont("Fonts\\FRIZQT__.TTF", 12)

Options.Start = CreateFrame( "EditBox", nil, RollingFrameOptions , "InputBoxTemplate")
Options.Start:SetPoint("TOPLEFT", 20, -145)
Options.Start:SetWidth(500)
Options.Start:SetHeight(20)
Options.Start:SetAutoFocus(false)
Options.Start:SetMovable(false)

local Desc2 = RollingMg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Desc2:SetText('|cffdbc253If you cancel the roll.|r')
	Desc2:SetPoint("TOPLEFT", 2, -170)
	Desc2:SetFont("Fonts\\FRIZQT__.TTF", 12)

Options.Cancel = CreateFrame( "EditBox", nil, RollingFrameOptions , "InputBoxTemplate")
Options.Cancel:SetPoint("TOPLEFT", 20, -195)
Options.Cancel:SetWidth(500)
Options.Cancel:SetHeight(20)
Options.Cancel:SetAutoFocus(false)
Options.Cancel:SetMovable(false)

Options.Cancelbutton = CreateFrame("CheckButton", nil, RollingFrameOptions, "ChatConfigCheckButtonTemplate")
Options.Cancelbutton:SetPoint("TOPLEFT", 530, -195)
Options.Cancelbutton.tooltip_text = "If you press cancel, should the text show?"
Options.Cancelbutton:SetScript("OnEnter", all_my_buttons_OnEnter)
Options.Cancelbutton:SetScript("OnLeave", all_my_buttons_OnLeave)
Options.Cancelbutton:Show()

local Desc3 = RollingMg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Desc3:SetText('|cffdbc253If you end the roll.|r')
	Desc3:SetPoint("TOPLEFT", 2, -220)
	Desc3:SetFont("Fonts\\FRIZQT__.TTF", 12)

Options.Win = CreateFrame( "EditBox", nil, RollingFrameOptions , "InputBoxTemplate")
Options.Win:SetPoint("TOPLEFT", 20, -245)
Options.Win:SetWidth(500)
Options.Win:SetHeight(20)
Options.Win:SetAutoFocus(false)
Options.Win:SetMovable(false)

local Desc4 = RollingMg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Desc4:SetText('|cffdbc253If set then i will say after X seconds into chat countdown|r')
	Desc4:SetPoint("TOPLEFT", 2, -270)
	Desc4:SetFont("Fonts\\FRIZQT__.TTF", 12)

Options.Timer = CreateFrame( "EditBox", nil, RollingFrameOptions , "InputBoxTemplate")
Options.Timer:SetPoint("TOPLEFT", 20, -295)
Options.Timer:SetWidth(500)
Options.Timer:SetHeight(20)
Options.Timer:SetAutoFocus(false)
Options.Timer:SetMovable(false)

Options.TimerCount = CreateFrame("CheckButton", nil, RollingFrameOptions, "ChatConfigCheckButtonTemplate")
Options.TimerCount:SetPoint("TOPLEFT", 530, -295)
Options.TimerCount.tooltip_text = "Should i say every X seconds into chat if you put number?"
Options.TimerCount:SetScript("OnEnter", all_my_buttons_OnEnter)
Options.TimerCount:SetScript("OnLeave", all_my_buttons_OnLeave)
Options.TimerCount:Show()

local Desc5 = RollingMg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Desc5:SetText('|cffdbc253Pickin Winner.|r')
	Desc5:SetPoint("TOPLEFT", 2, -320)
	Desc5:SetFont("Fonts\\FRIZQT__.TTF", 12)

Options.PickWinner = CreateFrame( "EditBox", nil, RollingFrameOptions , "InputBoxTemplate")
Options.PickWinner:SetPoint("TOPLEFT", 20, -345)
Options.PickWinner:SetWidth(500)
Options.PickWinner:SetHeight(20)
Options.PickWinner:SetAutoFocus(false)
Options.PickWinner:SetMovable(false)

local Desc5 = RollingMg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Desc5:SetText('|cffdbc253Re-Rolling.|r')
	Desc5:SetPoint("TOPLEFT", 2, -370)
	Desc5:SetFont("Fonts\\FRIZQT__.TTF", 12)

Options.ReRolling = CreateFrame( "EditBox", nil, RollingFrameOptions , "InputBoxTemplate")
Options.ReRolling:SetPoint("TOPLEFT", 20, -395)
Options.ReRolling:SetWidth(500)
Options.ReRolling:SetHeight(20)
Options.ReRolling:SetAutoFocus(false)
Options.ReRolling:SetMovable(false)


local Desc5 = RollingMg:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	Desc5:SetText('|cffdbc253Debugs.|r')
	Desc5:SetPoint("TOPLEFT", 2, -420)
	Desc5:SetFont("Fonts\\FRIZQT__.TTF", 12)

Options.Debugbutton = CreateFrame("CheckButton", nil, RollingFrameOptions, "ChatConfigCheckButtonTemplate")
Options.Debugbutton:SetPoint("TOPLEFT", 20, -445)
Options.Debugbutton.tooltip_text = "Just for Devs. :)"
Options.Debugbutton:SetScript("OnEnter", all_my_buttons_OnEnter)
Options.Debugbutton:SetScript("OnLeave", all_my_buttons_OnLeave)
Options.Debugbutton:Show()

local f = CreateFrame("Frame")
local login3 = true
local function onevent(self, event, arg1, ...)
    if(login3 == true and ((event == "ADDON_LOADED" and name == arg1) or (event == "PLAYER_LOGIN"))) then
        login3 = nil
        if RollingI.Start then
        	Options.Start:SetText(RollingI.Start)
        	Options.Cancel:SetText(RollingI.Cancel)
        	Options.Win:SetText(RollingI.WinChat)
        	Options.Timer:SetText(RollingI.Timer)
        	Options.Cancelbutton:SetChecked(RollingI.CancelMessage)
        	Options.TimerCount:SetChecked(RollingI.TimerCount)
			Options.Debugbutton:SetChecked(RollingI.Debugbutton)
			Options.PickWinner:SetText(RollingI.PickWinner)
			Options.ReRolling:SetText(RollingI.ReRolling)
        end
    end
end

f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", onevent)