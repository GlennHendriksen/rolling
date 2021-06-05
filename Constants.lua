Rolling = {}
Rolling["Class"] = {"none", "Plate", "Plate", "Chain", "Leather", "Cloth", "Plate", "Chain", "Cloth", "Leather", "Leather", "Leather"}
Rolling["Class"]["Color"] = {"C79C6E", "F58CBA", "ABD473", "FFF569", "FFFFFF", "C41F3B", "0070DE", "69CCF0", "9482C9", "00FF96", "FF7D0A", "A330C9"}
                            --Warrior, Pala,    Hunter,     Rouge,    Priest,   DeathKinght,Shaman, Mage,    Warlock,   Monk,    Druide,    DemonHunter
Rolling["Color"] = {"ffff00", "0099ff", "663300"}
Rolling["Page"] = {}
Page = 0
RollingStart = false
RollingForItem = false
RollingFrameOpen = false
RollingPlayers = {}
C_ChatInfo.RegisterAddonMessagePrefix("RollingManager")

local _, _, pc = UnitClass("player")
PlayerClass = Rolling["Class"][pc]
PlayerRealm = GetRealmName()

function addPage(item, from)
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
    local subauthor = select(1, strsplit("-", from))
    if not RollingPlayers[subauthor] then
        return
    end    
    loop = true
    local page = 0
    while (loop) do 
        if Rolling["Page"][page] == nil then
            loop = false
        else
            page = page + 1
        end
    end
    Rolling["Page"][page] = {}
    Rolling["Page"][page]["Player"] = {}
    Rolling["Page"][page]["Item"] = item
    Rolling["Page"][page]["from"] = from
    Rolling["Page"][page]["status"] = 0
    print("|cff00ccff[Rolling]|cffe2bd16 An item has been added.")
    if RollingFrameOpen == false then
        Page = page
        refreshsite(Page)
        fr:Show()
    end
    return page
end

function refreshsite(page) 
    looptimer = 1
    message = ""
    if (Rolling["Page"][page]) then
        for i, v in spairs(Rolling["Page"][page]["Player"], function(t,a,b) return t[b] < t[a] end) do
            if looptimer <= 3 then
                if Rolling["Class"][RollingPlayers[i]["Class"]] ~= Rolling["Class"][RollingPlayers[select(1,strsplit("-", Rolling["Page"][page]["from"], 2))]["Class"]] then
                    fr.txt[looptimer]:SetText("|cFFFF0000Class item not specified.")
                else
                    fr.txt[looptimer]:SetText("")
                end
                fr.win[looptimer]:Show()
                local playerid = RollingPlayers[i]["Class"]
                message = message.."|cff"..Rolling["Color"][looptimer].."["..looptimer.."] |cff"..Rolling["Class"]["Color"][playerid]..""..i.." |cffffff00 rolled a |cff0099ff"..v.."\n\n"
                looptimer = looptimer + 1
            else
                return
            end
        end
        if RollingFrameOpen == true then
            if RollingStart == Page then
                looptimer = 0
                for i, v in spairs(Rolling["Page"][RollingStart]["Player"], function(t,a,b) return t[b] < t[a] end) do
                    if looptimer <= 3 then
                        fr.win[looptimer+1]:Show()
                        looptimer = looptimer + 1
                    else
                        return
                    end
                end
            end
        end
        fr.text:SetText(message)
        local weaponname = GetItemInfo(tostring(Rolling["Page"][page]["Item"]))
        if weaponname == nil then
            weaponname = "Error..."
        end
        fr.txt4:SetText(Rolling["Page"][page]["Item"].."\nFrom: "..Rolling["Page"][page]["from"])
        fr.icon.overlay:SetTexture(GetItemIcon(Rolling["Page"][page]["Item"]))
        if RollingStart == false then
            if RollingForItem ~= true then
                fr.start:Show()
            end
        end
    end
end

function resetsite()
    RollingStart = false
    fr.cancel:Hide()
    fr.reroll:Hide()
    fr.ennd:Hide()
    fr.win[1]:Hide()
    fr.win[2]:Hide()
    fr.win[3]:Hide()
    fr.txt[1]:Hide()
    fr.txt[2]:Hide()
    fr.txt[3]:Hide()
    fr.start:Show()
    fr.title:SetText("Rolling Manager")
end