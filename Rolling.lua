local _rollMessageTailRegex = RANDOM_ROLL_RESULT:gsub("%(", "%%("):gsub("%)", "%%)"):gsub("%%d", "(%%d+)"):gsub("%%%d+%$d", "(%%d+)"):gsub("%%s", ""):gsub("%%%d+%$s", "").. "$"
local fir = CreateFrame("Frame")
local name, addon = ...
local loginin = true
local version = GetAddOnMetadata(name, "Version")

function spairs(t, order)
    if not t then return end
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

local function itsitem(message)
    local result = select(3, string.find(string.lower(message), "roll (|.+|r)"))
    if not result then
        result = select(3, string.find(string.lower(message), "(|.+|r) roll"))
    end
    if not result then
        result = select(3, string.find(string.lower(message), "roll for (|.+|r)"))
    end
    if not result then
        result = select(3, string.find(string.lower(message), "someone need (|.+|r)"))
    end
    if not result then
        result = select(3, string.find(string.lower(message), "someone want (|.+|r)"))
    end
    if not result then
        result = select(3, string.find(string.lower(message), "(|.+|r) someone"))
    end
    if not result then
        return false
    else
        return select(3, string.find(message, "(|.+|r)"))
    end
end

fir:RegisterEvent("ADDON_LOADED")
fir:RegisterEvent("CHAT_MSG_ADDON")
fir:RegisterEvent("PLAYER_LOGIN")
fir:RegisterEvent("CHAT_MSG_WHISPER")
fir:RegisterEvent("CHAT_MSG_PARTY")
fir:RegisterEvent("CHAT_MSG_PARTY_LEADER")
fir:RegisterEvent("CHAT_MSG_RAID")
fir:RegisterEvent("CHAT_MSG_RAID_LEADER")
fir:RegisterEvent("CHAT_MSG_INSTANCE_CHAT")
--fir:RegisterEvent("LOOT_READY")
fir:RegisterEvent("CHAT_MSG_INSTANCE_CHAT_LEADER")
fir:SetScript("OnEvent",function(self,event,...)
    if(loginin == true and ((event == "ADDON_LOADED" and name == arg1) or (event == "PLAYER_LOGIN"))) then
        loginin = nil
        if not RollingI then RollingI = { } end
        if not RollingI.Version then RollingI.Version = version end
        if not RollingI.XPos then RollingI.XPos = 0 end
        if not RollingI.YPos then RollingI.YPos = 0 end
        if not RollingI.YPosFrame then RollingI.YPosFrame = 0 end
        if not RollingI.XPosFrame then RollingI.XPosFrame = 0 end
        if not RollingI.BiggerUIXPos then RollingI.BiggerUIXPos = 0 end
        if not RollingI.BiggerUIYPos then RollingI.BiggerUIYPos = 0 end
        if not RollingI.Default then RollingI.Default = {} end
        if not RollingI.Default.WinChat then RollingI.Default.WinChat = "%p won %i by Rolling with number %n." end
        if not RollingI.Default.Start then RollingI.Default.Start = "Roll %i." end
        if not RollingI.Default.Cancel then RollingI.Default.Cancel = "Sorry. it was a mistake. I cancel the roll!" end
        if not RollingI.Default.PickWinner then RollingI.Default.PickWinner = "I pick %p as Winner, because he really need it." end
        if not RollingI.Default.ReRolling then RollingI.Default.ReRolling = "Re-rolling %i..." end
        if not RollingI.Default.CancelMessage then RollingI.Default.CancelMessage = false end
        if not RollingI.Default.Timer then RollingI.Default.Timer = 3 end
        if not RollingI.Default.TimerCount then RollingI.Default.TimerCount = false end
        if not RollingI.WinChat then RollingI.WinChat = RollingI.Default.WinChat end
        if not RollingI.Start then RollingI.Start = RollingI.Default.Start end
        if not RollingI.CancelMessage then RollingI.CancelMessage = RollingI.Default.CancelMessage end
        if not RollingI.Cancel then RollingI.Cancel = RollingI.Default.Cancel end
        if not RollingI.TimerCount then RollingI.TimerCount = RollingI.Default.TimerCount end
        if not RollingI.Timer then RollingI.Timer = RollingI.Default.Timer end
        if not RollingI.PickWinner then RollingI.PickWinner = RollingI.Default.PickWinner end
        if not RollingI.ReRolling then RollingI.ReRolling = RollingI.Default.ReRolling end
        if not RollingI.Debugbutton then RollingI.Debugbutton = false end
        if RollingI.Version ~= version then print("|cff00ccff[Rolling]|cffe2bd16 Updating") print("|cff00ccff[Rolling]|cffe2bd16 Updating Finished.") RollingI.Version = version end
        fr:ClearAllPoints()
        RollingPlayerGUI:ClearAllPoints()
        fr:SetPoint("BOTTOMLEFT", RollingI.XPos, RollingI.YPos)
        RollingPlayerGUI:SetPoint("BOTTOMLEFT", RollingI.XPosFrame, RollingI.YPosFrame)
        fir:UnregisterEvent("ADDON_LOADED")
        fir:UnregisterEvent("PLAYER_LOGIN")
    elseif event == "CHAT_MSG_SYSTEM" then
        if not RollingStart == false then
            local msg, arg1 = ...
            if msg then
                local roll, min, max = msg:match(_rollMessageTailRegex)
                local name = msg:gsub("%s*" .. _rollMessageTailRegex, "")
                roll = tonumber(roll)
                min = tonumber(min)
                max = tonumber(max)
                if roll then
                    if roll and (min == 1 or min == 0) and max == 100 then
                        if not Rolling["Page"][RollingStart]["Player"][name] then
                            Rolling["Page"][RollingStart]["Player"][name] = roll
                            refreshsite(RollingStart)
                        else
                            print("|cFFFF0000"..name.. " tried to rolling twice.")
                        end
                    else
                        print("|cFFFF0000"..name.. " tried to cheat. Min: ("..min..") Max: ("..max..")")
                    end
                end
            end
        elseif RollingForItem == true then
            local msg, arg1 = ...
            if msg then
                local roll, min, max = msg:match(_rollMessageTailRegex)
                local name = msg:gsub("%s*" .. _rollMessageTailRegex, "")
                roll = tonumber(roll)
                min = tonumber(min)
                max = tonumber(max)
                if roll then
                    if roll and (min == 1 or min == 0) and max == 100 then
                        if not Rolling["Page"]["roll"]["Player"][name] then
                            Rolling["Page"]["roll"]["Player"][name] = roll
                            message = ""
                            local looptimer = 1
                            for i, v in spairs(Rolling["Page"]["roll"]["Player"], function(t,a,b) return t[b] < t[a] end) do
                                if looptimer <= 3 then
                                    message = message.."|cff"..Rolling["Color"][looptimer].."["..looptimer.."] |cff"..Rolling["Class"]["Color"][select(3, UnitClass(i))]..""..i.." |cffffff00 rolled a |cff0099ff"..v.."\n\n"
                                    looptimer = looptimer + 1
                                else
                                    return
                                end
                            end
                            RollingPlayerGUI.text:SetText(message)
                            local weaponname = GetItemInfo(tostring(Rolling["Page"]["roll"]["Item"]))
                            if weaponname == nil then
                                weaponname = "Error..."
                            end
                            RollingPlayerGUI.item:SetText(Rolling["Page"]["roll"]["Item"].."\nFrom: "..Rolling["Page"]["roll"]["from"])
                            RollingPlayerGUI.icon.overlay:SetTexture(GetItemIcon(Rolling["Page"]["roll"]["Item"]))
                        end
                    end
                end
            end
        end
    elseif event == "CHAT_MSG_WHISPER" then
        local message, author = ...
        local result = select(3, string.find(message, "(|.+|r)"))
        if result then
            local subname = select(1, strsplit("-", author))
            addPage(result, author)
        end
    elseif event == "CHAT_MSG_ADDON" then
        local prefix, message = ...
        if (prefix == "RollingManager") then
            local item, author, sender = strsplit(",", message)
            local subname = strsplit("-", author)
            if sender ~= UnitName("Player") then
                startandcheck(author, item)
            end
        end
    elseif event == "CHAT_MSG_PARTY" or event == "CHAT_MSG_PARTY_LEADER" or event == "CHAT_MSG_RAID" or event == "CHAT_MSG_RAID_LEADER" or event == "CHAT_MSG_INSTANCE_CHAT" or event == "CHAT_MSG_INSTANCE_CHAT_LEADER" then
        if RollingForItem ~= true then
            local player = select(2, ...)
            if select(1, strsplit("-", player)) ~= UnitName("Player") then
                local item = itsitem(select(1, ...)) 
                if item then
                    startandcheck(player, item)
                end
            end
        end
    elseif event == "LOOT_READY" then
        info = GetLootInfo()
        print(info)
        print(info.item)
        print(info.locked)
        print(info.quality)
        print(info.texture)

        print("Else!!!")
        local linkstext = ""
        for index = 1, GetNumLootItems() do
            if LootSlotHasItem(index) then
                local itemLink = GetLootSlotLink(index)
                linkstext = linkstext .. itemLink
            end
        end
        print(linkstext)
    end
end)

function startandcheck(playerit, iitem)
    local itemm, _, _, _, _, _, _, _, ItemLoc, icon = GetItemInfo(iitem)
    if itemm then
        if ItemLoc == "INVTYPE_AMMO" or ItemLoc == "INVTYPE_HEAD" or ItemLoc == "INVTYPE_NECK" or ItemLoc == "INVTYPE_SHOULDER" or ItemLoc == "INVTYPE_BODY" or ItemLoc == "INVTYPE_CHEST" or ItemLoc == "INVTYPE_ROBE" or ItemLoc == "INVTYPE_WAIST" or ItemLoc == "INVTYPE_LEGS" or ItemLoc == "INVTYPE_FEET" or ItemLoc == "INVTYPE_WRIST" or ItemLoc == "INVTYPE_HAND" or ItemLoc == "INVTYPE_FINGER" or ItemLoc == "INVTYPE_TRINKET" or ItemLoc == "INVTYPE_CLOAK" or ItemLoc == "INVTYPE_WEAPON" or ItemLoc == "INVTYPE_SHIELD" or ItemLoc == "INVTYPE_2HWEAPON" or ItemLoc == "INVTYPE_WEAPONMAINHAND" or ItemLoc == "INVTYPE_WEAPONOFFHAND" or ItemLoc == "INVTYPE_HOLDABLE" or ItemLoc == "INVTYPE_RANGED" or ItemLoc == "INVTYPE_THROWN" or ItemLoc == "INVTYPE_RANGEDRIGHT" or ItemLoc == "INVTYPE_RELIC" or ItemLoc == "INVTYPE_TABARD" or ItemLoc == "INVTYPE_BAG" or ItemLoc == "INVTYPE_QUIVER" then
            local doit = false
            if not ItemLoc == "INVTYPE_FINGER" or not ItemLoc == "INVTYPE_TRINKET" or not ItemLoc == "INVTYPE_CLOAK" then
                if PlayerClass == Rolling["Class"][RollingPlayers[select(1,strsplit("-", playerit,2))]["Class"]] then
                    doit = true
                end
            else
                doit = true 
            end
            if doit == true then
                RollingForItem = true
                fir:RegisterEvent("CHAT_MSG_SYSTEM")
                Rolling["Page"]["roll"] = {}
                Rolling["Page"]["roll"]["Player"] = {}
                Rolling["Page"]["roll"]["Item"] = iitem
                Rolling["Page"]["roll"]["from"] = playerit
                local numbers = GetNumGroupMembers()
                for i = 1, numbers, 1 do
                    local name = GetRaidRosterInfo(i)
                    local subname, realm = strsplit("-", name,2)
                    if not realm then
                        realm = PlayerRealm
                    end
                    local class = select(3, UnitClass("RAID"..i))
                    if not class then
                        class = select(3, UnitClass("PARTY"..i - 1))
                    end
                    if not class then
                        class = select(3, UnitClass("Player"))
                    end
                    RollingPlayers[subname] = {}
                    RollingPlayers[subname]["Realm"] = realm
                    RollingPlayers[subname]["Class"] = class
                end
                RollingPlayerGUI.icon.overlay:SetTexture(icon)
                RollingPlayerGUI.item:SetText(tostring(iitem).."\n|r"..playerit)
                RollingPlayerGUI.text:SetText("")
                RollingPlayerGUI:Show()
                if not RollingI.FirstTime then
                    print("|cff00ccff[Rolling]|cffe2bd16 I will tell you one time! This UI pop out only if someone other people wanted to roll thier item and if it match for you")
                    print("|cffe2bd16So if you don't need those item, just close it, and when another User roll it, it will pop it again.")
                    print("")
                    RollingI.FirstTime = true
                end
            end
        end
    end
end

SLASH_ROLLING1 = "/rr"
SlashCmdList["ROLLING"] = function(msg)
    local arg, arg1, arg2 = strsplit(" ", msg, 3)
    bla = nil
    if arg ~= nil then
        if arg == "add" then
            _, bla = strsplit(" ", msg, 2)
            if bla ~= nil then
                addPage(bla, UnitName("Player").."-"..PlayerRealm)
            else
                print("|cff00ccff[Rolling] |cFFFF0000Invaild argument, Item not linked. '/rr roll [number] <Link>'")
            end
        elseif arg == "show" then
            fr:Show()
            RollingPlayerGUI:Show()
        end
    else
        fr:Show()
    end
end

function startroll (page)
    if RollingStart == false then
        local itemm, _, _, _, _, _, _, _, ItemLoc = GetItemInfo(Rolling["Page"][page]["Item"])
        if itemm then
            if ItemLoc == "INVTYPE_AMMO" or ItemLoc == "INVTYPE_HEAD" or ItemLoc == "INVTYPE_NECK" or ItemLoc == "INVTYPE_SHOULDER" or ItemLoc == "INVTYPE_BODY" or ItemLoc == "INVTYPE_CHEST" or ItemLoc == "INVTYPE_ROBE" or ItemLoc == "INVTYPE_WAIST" or ItemLoc == "INVTYPE_LEGS" or ItemLoc == "INVTYPE_FEET" or ItemLoc == "INVTYPE_WRIST" or ItemLoc == "INVTYPE_HAND" or ItemLoc == "INVTYPE_FINGER" or ItemLoc == "INVTYPE_TRINKET" or ItemLoc == "INVTYPE_CLOAK" or ItemLoc == "INVTYPE_WEAPON" or ItemLoc == "INVTYPE_SHIELD" or ItemLoc == "INVTYPE_2HWEAPON" or ItemLoc == "INVTYPE_WEAPONMAINHAND" or ItemLoc == "INVTYPE_WEAPONOFFHAND" or ItemLoc == "INVTYPE_HOLDABLE" or ItemLoc == "INVTYPE_RANGED" or ItemLoc == "INVTYPE_THROWN" or ItemLoc == "INVTYPE_RANGEDRIGHT" or ItemLoc == "INVTYPE_RELIC" or ItemLoc == "INVTYPE_TABARD" or ItemLoc == "INVTYPE_BAG" or ItemLoc == "INVTYPE_QUIVER" then
                if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) or IsInRaid(LE_PARTY_CATEGORY_INSTANCE) then
                    group = "INSTANCE_CHAT"
                elseif IsInRaid(0) then
                    group = "RAID"
                elseif IsInGroup(0) then
                    group = "PARTY"
                end
                if group then
                    if not ItemLoc == "INVTYPE_FINGER" or not ItemLoc == "INVTYPE_TRINKET" or not ItemLoc == "INVTYPE_CLOAK" then
                        classcheck = true
                    end
                    RollingStart = page
                    C_ChatInfo.SendAddonMessage("RollingManager", Rolling["Page"][page]["Item"]..","..Rolling["Page"][page]["from"]..","..UnitName("Player"), group)
                    fr.title:SetText("Rolling Manager. || Rolling at Page "..page)
                    fr.start:Hide()
                    fr.ennd:Show()
                    fr.cancel:Show()
                    fr.reroll:Show()
                    fir:RegisterEvent("CHAT_MSG_SYSTEM")
                    print("|cff00ccff[Rolling] |cFF00FF00Rolling started!")
                    local text1 = RollingI.Start:gsub("%%i", Rolling["Page"][page]["Item"])
                    SendChatMessage(text1, group)
                else
                    print("|cFFFF0000You can't start a roll without a Party or Raid.")
                end
            else
                print("|cff00ccff[Rolling] |cFFFF0000You can't roll this item!")
            end
        end
    else
        print("|cff00ccff[Rolling] |cFFFF0000You can't start more than one roll!")
    end
end