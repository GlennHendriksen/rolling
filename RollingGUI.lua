fr = CreateFrame("Frame", "Rolling_Frame", UIParent, "BasicFrameTemplateWithInset")
fr:ClearAllPoints()
fr:SetSize(300, 230)
fr:SetPoint("CENTER", UIParent, "CENTER")
fr:SetMovable(true)
fr:EnableMouse(true)
fr:SetUserPlaced(true)
fr:SetScript("OnMouseDown", fr.StartMoving)
fr:SetScript("OnMouseUp", function (self)
    fr:StopMovingOrSizing()
    RollingI.XPos = self:GetLeft()
    RollingI.YPos = self:GetBottom()
end)
fr:SetScript("OnHide", function (self)
	RollingFrameOpen = false
	if RollingForItem == true then
		RollingForItem = nil
		Rolling["Page"][0] = {}
		Rolling["Page"][0] = nil
		resetsite()
		fr.roll:Hide()
	end
end)
fr:SetScript("OnShow", function (self)
	RollingFrameOpen = true
end)

fr.icon = {}

fr.icon.right = CreateFrame("Button", nil, fr, "GameMenuButtonTemplate")
fr.icon.right:SetPoint("Right", fr, "TOP", 140, -40)
fr.icon.right:SetSize(32, 32)
fr.icon.right.overlay = fr.icon.right:CreateTexture(nil, "OVERLAY")
fr.icon.right.overlay:SetPoint("Right", fr, "TOP", 140, -40)
fr.icon.right.overlay:SetSize(32, 32)
fr.icon.right.overlay:SetTexture("interface/addons/Rolling/img/Right.blp")
fr.icon.right:RegisterForClicks("AnyUp")
fr.icon.right:SetScript("OnEnter", function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:ClearLines()
	if Page+1 > table.getn(Rolling["Page"]) then
		GameTooltip:AddLine("Page: "..Page.."/"..table.getn(Rolling["Page"]))
	else
		local weaponname = GetItemInfo(tostring(Rolling["Page"][Page+1]["Item"]))
		GameTooltip:AddLine("Page: "..Page.."/"..table.getn(Rolling["Page"]).."\n"..Rolling["Page"][Page+1]["Item"].."\nFrom: "..Rolling["Page"][Page+1]["from"])
	end
	GameTooltip:Show() 
end)
fr.icon.right:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)
fr.icon.right:SetScript("OnMouseDown", function(self)
	if Page < table.getn(Rolling["Page"]) then
		Page = Page + 1
		GameTooltip:ClearLines()
		if Page+1 > table.getn(Rolling["Page"]) then
			GameTooltip:AddLine("Page: "..Page.."/"..table.getn(Rolling["Page"]))
		else
			local weaponname = GetItemInfo(tostring(Rolling["Page"][Page+1]["Item"]))
			GameTooltip:AddLine("Page: "..Page.."/"..table.getn(Rolling["Page"]).."\n"..Rolling["Page"][Page+1]["Item"].."\nFrom: "..Rolling["Page"][Page+1]["from"])
		end
		if RollingStart == Page then
			fr.ennd:Show()
			fr.reroll:Show()
			fr.cancel:Show()
		else
			fr.ennd:Hide()
			fr.reroll:Hide()
			fr.cancel:Hide()
		end
		refreshsite(Page)
		GameTooltip:Show() 
	end
end)

fr.icon.left = CreateFrame("Button", nil, fr, "GameMenuButtonTemplate")
fr.icon.left:SetPoint("Right", fr, "TOP", 140-32, -40)
fr.icon.left:SetSize(32, 32)
fr.icon.left.overlay = fr.icon.left:CreateTexture(nil, "OVERLAY")
fr.icon.left.overlay:SetPoint("Right", fr, "TOP", 140-32, -40)
fr.icon.left.overlay:SetSize(32, 32)
fr.icon.left.overlay:SetTexture("interface/addons/Rolling/img/Left.blp")
fr.icon.left:RegisterForClicks("AnyUp")
fr.icon.left:SetScript("OnEnter", function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:ClearLines()
	if Page-1 <  0 then
		GameTooltip:AddLine("Page: "..Page.."/"..table.getn(Rolling["Page"]))
	else
		local weaponname = GetItemInfo(tostring(Rolling["Page"][Page-1]["Item"]))
		GameTooltip:AddLine("Page: "..Page.."/"..table.getn(Rolling["Page"]).."\n"..Rolling["Page"][Page-1]["Item"].."\nFrom: "..Rolling["Page"][Page-1]["from"])
	end
	GameTooltip:Show() 
end)
fr.icon.left:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)
fr.icon.left:SetScript("OnMouseDown", function(self)
	if Page > 0 then
		Page = Page - 1
		GameTooltip:ClearLines()
		if Page-1 <  0 then
			GameTooltip:AddLine("Page: "..Page.."/"..table.getn(Rolling["Page"]))
		else
			local weaponname = GetItemInfo(tostring(Rolling["Page"][Page-1]["Item"]))
			GameTooltip:AddLine("Page: "..Page.."/"..table.getn(Rolling["Page"]).."\n"..Rolling["Page"][Page-1]["Item"].."\nFrom: "..Rolling["Page"][Page-1]["from"])
		end
		if RollingStart == Page then
			fr.ennd:Show()
			fr.reroll:Show()
			fr.cancel:Show()
		else
			fr.ennd:Hide()
			fr.reroll:Hide()
			fr.cancel:Hide()
		end
		refreshsite(Page)
		GameTooltip:Show() 
	end
end)

fr.icon.cross = CreateFrame("Button", nil, fr, "GameMenuButtonTemplate")
fr.icon.cross:SetPoint("Right", fr, "TOP", 140, -72)
fr.icon.cross:SetSize(32, 32)
fr.icon.cross.overlay = fr.icon.cross:CreateTexture(nil, "OVERLAY")
fr.icon.cross.overlay:SetPoint("Right", fr, "TOP", 140, -72)
fr.icon.cross.overlay:SetSize(32, 32)
fr.icon.cross.overlay:SetTexture("interface/addons/Rolling/img/cross.blp")
fr.icon.cross:RegisterForClicks("AnyUp")
fr.icon.cross:SetScript("OnEnter", function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:ClearLines()
	GameTooltip:AddLine("Are you sure you want remove this?\nThis can't be redo!")
	GameTooltip:Show() 
end)
fr.icon.cross:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)
--[[fr.icon.cross:SetScript("OnMouseDown", function(self)
	print(table.getn(Rolling["Page"]))
	if #Rolling["Page"] == 0 then
		print("|cff00ccff[Rolling]|cffe2bd16 There is no Page, so i closed the gui.")
		fr.Hide()
	else
		print("Before")
		for i=0, #Rolling["Page"], 1 do
			if Rolling["Page"] ~= nil then
				print("Exists Page :"..i)
			else
				print("No Page:"..i)
			end
		end
		fr.txt4:SetText("")
		print("|cff00ccff[Rolling]|cffe2bd16 Sucessfully removed.")
		Rolling["Page"][Page] = {}
		Rolling["Page"][Page] = nil
		print("After")
		if #Rolling["Page"] ~= 0 then
			for i=0, #Rolling["Page"], 1 do
				if Rolling["Page"][i] ~= nil then
					print("Exists Page :"..i)
				else
					print("No Page:"..i)
					print("Moving Page ".. i + 1 .." to Page "..i)
					Rolling["Page"][i] = {}
					Rolling["Page"][i]["Player"] = {}
					if Rolling["Page"][i+1] ~= nil then
						Rolling["Page"][i]["Item"] = Rolling["Page"][i+1]["Item"]
						Rolling["Page"][i]["from"] = Rolling["Page"][i+1]["from"]
						Rolling["Page"][i]["status"] = Rolling["Page"][i+1]["status"]
						Rolling["Page"][i+1] = {}
						Rolling["Page"][i+1] = nil
					end
				end
			end
			refreshsite(Page)
			print(#Rolling["Page"])
		else
			print("|cff00ccff[Rolling]|cffe2bd16 There is no Page left, so i closed the gui.")
			fr:Hide()
		end		
	end
end)]]

fr.start = CreateFrame("Button", nil, fr, "GameMenuButtonTemplate")
fr.start:SetPoint("Right", fr, "TOP", 130, -200)
fr.start:SetSize(260, 20)
fr.start:SetText("Start rolling")
fr.start:RegisterForClicks("AnyUp")
fr.start:SetScript("OnMouseDown", function(self) 
	startroll(Page)
end)
fr.start:Hide()

fr.ennd = CreateFrame("Button", nil, fr, "GameMenuButtonTemplate")
fr.ennd:SetPoint("Right", fr, "TOP", -50, -200)
fr.ennd:SetSize(80, 20)
fr.ennd:SetText("End")
fr.ennd:RegisterForClicks("AnyUp")
fr.ennd:SetScript("OnMouseDown", function(self) 
	if RollingStart == false then
		print("|cff00ccff[Rolling] |cFFFF0000You didn't start a roll.")
	else
		local PlacingName = {}
		local PlacingRoll = {}
		if Rolling["Page"][RollingStart]["Player"] then
			looptimer = 0
			for i, v in spairs(Rolling["Page"][RollingStart]["Player"], function(t,a,b) return t[b] < t[a] end) do
				looptimer = looptimer + 1
				PlacingName[looptimer] = i
				PlacingRoll[looptimer] = v
			end
			local text = RollingI.WinChat:gsub("%%i", Rolling["Page"][RollingStart]["Item"])
			local text = text:gsub("%%p", PlacingName[1])
			local text = text:gsub("%%n", PlacingRoll[1])
			SendChatMessage(text, group)
			local namewinner = PlacingName[1].."-"..RollingPlayers[PlacingName[1]]["Realm"]
			SendChatMessage("You won, please trade with "..Rolling["Page"][RollingStart]["from"], "WHISPER", "Common", namewinner)
			SendChatMessage("Player "..PlacingName[1].." won, please trade with him!", "WHISPER", "Common", Rolling["Page"][RollingStart]["from"])
			resetsite()
		else
			resetsite()
			fr.title:SetText("Rolling Manager")
			print("|cff00ccff[Rolling] |cFFFF0000No one wanted it.")
		end
	end
end)

fr.ennd:Hide()

fr.cancel = CreateFrame("Button", nil, fr, "GameMenuButtonTemplate")
fr.cancel:SetPoint("LEFT", fr, "TOP", 50, -200)
fr.cancel:SetSize(80, 20)
fr.cancel:SetText("Cancel")
fr.cancel:RegisterForClicks("AnyUp")
fr.cancel:SetScript("OnMouseDown", function(self) 
	if RollingStart == false then
		print("|cff00ccff[Rolling] |cFFFF0000You didn't started a roll.")
	else
		if RollingI.CancelMessage then
			SendChatMessage(RollingI.Cancel , group)
		end
		RollingStart = false
		resetsite()
	end
end)
fr.cancel:Hide()

fr.reroll = CreateFrame("Button", nil, fr, "GameMenuButtonTemplate")
fr.reroll:SetPoint("CENTER", fr, "TOP", 0, -200)
fr.reroll:SetSize(90, 20)
fr.reroll:SetText("Re-Roll")
fr.reroll:RegisterForClicks("AnyUp")
fr.reroll:SetScript("OnMouseDown", function(self)
	if not RollingStart == false then
		local text = RollingI.ReRolling:gsub("%%i", Rolling["Page"][RollingStart]["Item"])
		SendChatMessage(text" Addons by 'Rolling Manager'", group)
		Rolling["Page"][RollingStart]["Player"] = {} 
		refreshsite(RollingStart)
		resetsite()
	end
end)
fr.reroll:Hide()

fr.finishend = CreateFrame("Button", nil, fr, "GameMenuButtonTemplate")
fr.finishend:SetPoint("Right", fr, "TOP", 130, -200)
fr.finishend:SetSize(260, 20)
fr.finishend:SetText("Close / Finish")
fr.finishend:RegisterForClicks("AnyUp")
fr.finishend:Hide()

fr.title = fr:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
fr.title:SetPoint("LEFT", fr.TitleBg, "LEFT", 5, 0)
fr.title:SetText("Rolling Manager")

fr.timer = fr:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
fr.timer:SetPoint("LEFT", fr.TitleBg, "LEFT", 150, 0)

fr.recommend = fr:CreateFontString(nil, "ARTWORK")
fr.recommend:SetFont("Fonts\\ARIALN.ttf", 18, "OUTLINE")
fr.recommend:SetPoint("TOPLEFT", 10, -30)
fr.recommend:SetJustifyH("LEFT")

fr.recommended = fr:CreateFontString(nil, "ARTWORK")
fr.recommended:SetFont("Fonts\\ARIALN.ttf", 18, "OUTLINE")
fr.recommended:SetPoint("TOPLEFT", 10, -50)
fr.recommended:SetJustifyH("LEFT")

fr.text = fr:CreateFontString(nil, "ARTWORK")
fr.text:SetFont("Fonts\\ARIALN.ttf", 18, "OUTLINE")
fr.text:SetPoint("TOPLEFT", 10, -80)
fr.text:SetJustifyH("LEFT")

fr.txt = {}
fr.win = {}

fr.win[1] = CreateFrame("Button", nil, fr, "GameMenuButtonTemplate")
fr.win[1]:SetPoint("Right", fr, "TOP", 140, -94)
fr.win[1]:SetSize(60, 20)
fr.win[1]:SetText("Winner")
fr.win[1]:RegisterForClicks("AnyUp")
fr.win[1]:SetScript("OnMouseDown", function(self)
	if RollingStart == false then
		print("|cff00ccff[Rolling] |cFFFF0000You didn't started a roll.")
	else
		local PlacingName = {}
		local PlacingRoll = {}
		if Rolling["Page"][RollingStart]["Player"] then
			looptimer = 0
			for i, v in spairs(Rolling["Page"][RollingStart]["Player"], function(t,a,b) return t[b] < t[a] end) do
				looptimer = looptimer + 1
				PlacingName[looptimer] = i
				PlacingRoll[looptimer] = v
			end
			local text = RollingI.WinChat:gsub("%%i", Rolling["Page"][RollingStart]["Item"])
			local text = text:gsub("%%p", PlacingName[1])
			local text = text:gsub("%%n", PlacingRoll[1])
			SendChatMessage(text, group)
			local namewinner = PlacingName[1].."-"..RollingPlayers[PlacingName[1]]["Realm"]
			SendChatMessage("You won, please trade with "..Rolling["Page"][RollingStart]["from"], "WHISPER", "Common", namewinner)
			SendChatMessage("Player "..namewinner.." won, please trade with him!", "WHISPER", "Common", Rolling["Page"][RollingStart]["from"])
			resetsite()
		else
			resetsite()
			print("|cff00ccff[Rolling] |cFFFF0000No one wanted it.")
		end
	end
end)

fr.win[2] = CreateFrame("Button", nil, fr, "GameMenuButtonTemplate")
fr.win[2]:SetPoint("Right", fr, "TOP", 140, -130)
fr.win[2]:SetSize(60, 20)
fr.win[2]:SetText("Winner")
fr.win[2]:RegisterForClicks("AnyUp")
fr.win[2]:SetScript("OnMouseDown", function()
	if RollingStart == false then
		print("|cff00ccff[Rolling] |cFFFF0000You didn't started a roll.")
	else
		local PlacingName = {}
		local PlacingRoll = {}
		if Rolling["Page"][RollingStart]["Player"] then
			looptimer = 0
			for i, v in spairs(Rolling["Page"][RollingStart]["Player"], function(t,a,b) return t[b] < t[a] end) do
				looptimer = looptimer + 1
				PlacingName[looptimer] = i
				PlacingRoll[looptimer] = v
			end
			local text = RollingI.PickWinner:gsub("%%i", Rolling["Page"][RollingStart]["Item"])
			local text = text:gsub("%%p", PlacingName[2])
			local text = text:gsub("%%n", PlacingRoll[2])
			SendChatMessage(text, group)
			local namewinner = PlacingName[2].."-"..RollingPlayers[PlacingName[2]]["Realm"]
			SendChatMessage("You won, please trade with "..Rolling["Page"][RollingStart]["from"], "WHISPER", "Common", namewinner)
			SendChatMessage("Player "..namewinner.." won, please trade with him!", "WHISPER", "Common", Rolling["Page"][RollingStart]["from"])
			resetsite()
		else
			resetsite()
			print("|cff00ccff[Rolling] |cFFFF0000No one wanted it.")
		end
	end
end)

fr.win[3] = CreateFrame("Button", nil, fr, "GameMenuButtonTemplate")
fr.win[3]:SetPoint("Right", fr, "TOP", 140, -165)
fr.win[3]:SetSize(60, 20)
fr.win[3]:SetText("Winner")
fr.win[3]:RegisterForClicks("AnyUp")
fr.win[3]:SetScript("OnMouseDown", function()
	if RollingStart == false then
		print("|cff00ccff[Rolling] |cFFFF0000You didn't started a roll.")
	else
		local PlacingName = {}
		local PlacingRoll = {}
		if Rolling["Page"][RollingStart]["Player"] then
			looptimer = 0
			for i, v in spairs(Rolling["Page"][RollingStart]["Player"], function(t,a,b) return t[b] < t[a] end) do
				looptimer = looptimer + 1
				PlacingName[looptimer] = i
				PlacingRoll[looptimer] = v
			end
			local text = RollingI.PickWinner:gsub("%%i", Rolling["Page"][RollingStart]["Item"])
			local text = text:gsub("%%p", PlacingName[3])
			local text = text:gsub("%%n", PlacingRoll[3])
			SendChatMessage(text, group)
			local namewinner = PlacingName[3].."-"..RollingPlayers[PlacingName[3]]["Realm"]
			SendChatMessage("You won, please trade with "..Rolling["Page"][RollingStart]["from"], "WHISPER", "Common", namewinner)
			SendChatMessage("Player "..namewinner.." won, please trade with him!", "WHISPER", "Common", Rolling["Page"][RollingStart]["from"])
			resetsite()
		else
			resetsite()
			print("|cff00ccff[Rolling] |cFFFF0000No one wanted it.")
		end
	end
end)
fr.win[1]:Hide()
fr.win[2]:Hide()
fr.win[3]:Hide()

fr.txt[1] = fr:CreateFontString(nil, "ARTWORK")
fr.txt[1]:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")
fr.txt[1]:SetPoint("TOPLEFT", 10, -104)
fr.txt[1]:SetJustifyH("LEFT")

fr.txt[2] = fr:CreateFontString(nil, "ARTWORK")
fr.txt[2]:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")
fr.txt[2]:SetPoint("TOPLEFT", 10, -139)
fr.txt[2]:SetJustifyH("LEFT")

fr.txt[3] = fr:CreateFontString(nil, "ARTWORK")
fr.txt[3]:SetFont("Fonts\\ARIALN.ttf", 14, "OUTLINE")
fr.txt[3]:SetPoint("TOPLEFT", 10, -174)
fr.txt[3]:SetJustifyH("LEFT")

fr.txt4 = fr:CreateFontString(nil, "ARTWORK")
fr.txt4:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
fr.txt4:SetPoint("TOPLEFT", 50, -38)
fr.txt4:SetJustifyH("LEFT")

fr.icon = CreateFrame("Button", nil, fr, "GameMenuButtonTemplate")
fr.icon:SetPoint("Right", fr, "TOP", -100, -55)
fr.icon:SetSize(40, 40)
fr.icon.overlay = fr.icon:CreateTexture(nil, "OVERLAY")
fr.icon.overlay:SetPoint("Right", fr, "TOP", -100, -55)
fr.icon.overlay:SetSize(40, 40)
fr.icon.overlay:SetTexture(GetItemIcon(6948))
fr.icon:SetScript("OnEnter", function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	GameTooltip:ClearLines()
	--local id = GetItemInfoInstant(item)
	if Rolling["Page"][Page]["Item"] then
		local _, id = GetItemInfo(tostring(Rolling["Page"][Page]["Item"]))
		--GameTooltip:SetItemByID(id)
		GameTooltip:SetHyperlink(id)
	else
		local _, id = GetItemInfo("Ruhestein")
		GameTooltip:SetHyperlink(id)
	end
	GameTooltip:Show() 
end)
fr.icon:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
fr.icon:Show()

fr:Hide()