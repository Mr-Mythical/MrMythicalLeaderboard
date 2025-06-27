--[[
Core.lua - Mr. Mythical Leaderboard Core Logic

Purpose: Displays top Mythic+ runs from Raider.IO with keystone tooltips
Dependencies: Data modules and utility functions
Author: Braunerr
--]]

local MrMythicalLeaderboard = MrMythicalLeaderboard or {}

local LeaderboardData = MrMythicalLeaderboard.Data
local GradientsData = MrMythicalLeaderboard.GradientsData
local ColorUtils = MrMythicalLeaderboard.ColorUtils
local TimeUtils = MrMythicalLeaderboard.TimeUtils
local GRADIENTS = GradientsData.GRADIENTS
local DUNGEONS = {}

local defaults = {
    showScore = true,
    enabled = true,
    rosterDisplay = "off",
}

local function initializeSettings()
    if not MrMythicalLeaderboardDB then
        MrMythicalLeaderboardDB = {}
        for key, value in pairs(defaults) do
            MrMythicalLeaderboardDB[key] = value
        end
    else
        for key, value in pairs(defaults) do
            if MrMythicalLeaderboardDB[key] == nil then
                MrMythicalLeaderboardDB[key] = value
            end
        end
    end
end

local function initializeDungeonMapping()
    if not MrMythicalLeaderboard.DungeonData then
        return
    end
    
    DUNGEONS = {}
    for _, dungeon in ipairs(MrMythicalLeaderboard.DungeonData.MYTHIC_MAPS) do
        local slug = dungeon.name:lower():gsub("[^%w ]", ""):gsub(" ", "-")
        if dungeon.name == "Mechagon Workshop" then
            slug = "operation-mechagon-workshop"
        elseif dungeon.name == "Operation: Floodgate" then
            slug = "operation-floodgate" 
        elseif dungeon.name == "Priory of the Sacred Flame" then
            slug = "priory-of-the-sacred-flame"
        elseif dungeon.name == "The MOTHERLODE!!" then
            slug = "the-motherlode"
        elseif dungeon.name == "The Rookery" then
            slug = "the-rookery"
        elseif dungeon.name == "Theater of Pain" then
            slug = "theater-of-pain"
        elseif dungeon.name == "Cinderbrew Meadery" then
            slug = "cinderbrew-meadery"
        elseif dungeon.name == "Darkflame Cleft" then
            slug = "darkflame-cleft"
        end
        
        DUNGEONS[dungeon.id] = {
            name = dungeon.name,
            slug = slug
        }
    end
end

--- Event handler for addon initialization
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local addonName = ...
        if addonName == "MrMythicalLeaderboard" then
            initializeSettings()
            LeaderboardData = MrMythicalLeaderboard.Data
            initializeDungeonMapping()
            
            if MrMythicalLeaderboard.Options then
                MrMythicalLeaderboard.Options.initializeSettings()
            end
            
            MrMythicalLeaderboard.setupTooltipHooks()
        end
    end
end)

_G.MrMythicalLeaderboard = MrMythicalLeaderboard

function MrMythicalLeaderboard.showHighestKeys()
    if not LeaderboardData or not LeaderboardData.dungeons then
        print("|cff00ff00Mr. Mythical Leaderboard:|r |cffff0000No leaderboard data available.|r")
        return
    end
    
    local sortedDungeons = {}
    for dungeonSlug, dungeonData in pairs(LeaderboardData.dungeons) do
        if dungeonData.runs and #dungeonData.runs > 0 then
            local topRun = dungeonData.runs[1]
            table.insert(sortedDungeons, {
                slug = dungeonSlug,
                data = dungeonData,
                run = topRun,
                score = topRun.score
            })
        end
    end
    
    table.sort(sortedDungeons, function(a, b) return a.score > b.score end)
    
    print("|cff00ff00Mr. Mythical Leaderboard:|r Highest Keys (sorted by score):")
    print(string.rep("-", 80))
    
    for _, entry in ipairs(sortedDungeons) do
        local topRun = entry.run
        local dungeonData = entry.data
        local timeStr = TimeUtils.formatTime(topRun.time)
        local chestStr = topRun.chests > 0 and " (+" .. topRun.chests .. ")" or ""
        
        local timeSaved = topRun.keystoneTime - topRun.time
        local timeSavedStr = TimeUtils.formatTime(timeSaved)
        local timeSavedColor = timeSaved > 0 and "|cff00ff00" or "|cffff0000"            if MrMythicalLeaderboardDB.showScore then
                print(string.format("|cffffffff%s:|r |cffff8000+%d|r in |cff00ff00%s|r%s - %s%.1f|r score (%s-%s|r under timer)", 
                    dungeonData.name, topRun.level, timeStr, chestStr, 
                    ColorUtils.calculateGradientColor(topRun.score, 165, 500, GRADIENTS), topRun.score, 
                    timeSavedColor, timeSavedStr))
            else
                print(string.format("|cffffffff%s:|r |cffff8000+%d|r in |cff00ff00%s|r%s (%s-%s|r under timer)", 
                    dungeonData.name, topRun.level, timeStr, chestStr, 
                    timeSavedColor, timeSavedStr))
            end
    end
    
    if LeaderboardData.lastUpdated then
        local timeString = date("%Y-%m-%d %H:%M:%S", LeaderboardData.lastUpdated)
        print("|cff888888Last updated: " .. timeString .. "|r")
    end
end

function MrMythicalLeaderboard.setupTooltipHooks()
    if not MrMythicalLeaderboardDB.enabled then return end
    
    local originalSetHyperlink = GameTooltip.SetHyperlink
    GameTooltip.SetHyperlink = function(self, link, ...)
        originalSetHyperlink(self, link, ...)
        MrMythicalLeaderboard.handleKeystoneTooltip(self, link)
    end
    
    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip)
        if tooltip.GetItem then
            local _, link = tooltip:GetItem()
            if link then
                MrMythicalLeaderboard.handleKeystoneTooltip(tooltip, link)
            end
        end
    end)
end

function MrMythicalLeaderboard.handleKeystoneTooltip(tooltip, link)
    if not MrMythicalLeaderboardDB.enabled or not LeaderboardData then return end
    
    local challengeID = nil
    
    local keystoneData = MrMythicalLeaderboard.KeystoneUtils.parseKeystoneData(link)
    if keystoneData then
        challengeID = keystoneData.mapID
    else
        challengeID = MrMythicalLeaderboard.extractChallengeIDFromTooltip(tooltip)
    end
    
    if challengeID then
        MrMythicalLeaderboard.addLeaderboardToTooltip(tooltip, challengeID)
    end
end

function MrMythicalLeaderboard.extractChallengeIDFromTooltip(tooltip)
    if not tooltip or not tooltip.GetName then return nil end
    
    for i = 1, tooltip:NumLines() do
        local line = _G[tooltip:GetName() .. "TextLeft" .. i]
        if line then
            local text = line:GetText()
            if text then
                for challengeID, dungeonInfo in pairs(DUNGEONS) do
                    if text:find(dungeonInfo.name, 1, true) then
                        return challengeID
                    end
                end
            end
        end
    end
    
    return nil
end

function MrMythicalLeaderboard.addLeaderboardToTooltip(tooltip, challengeID)
    local dungeonInfo = DUNGEONS[challengeID]
    if not dungeonInfo then 
        return 
    end
    
    local dungeonData = LeaderboardData.dungeons[dungeonInfo.slug]
    if not dungeonData or not dungeonData.runs or #dungeonData.runs == 0 then 
        return 
    end
    
    tooltip:AddLine(" ")
    tooltip:AddLine("|cff00ff00World Record For This Key:|r")
    
    local topRun = dungeonData.runs[1]
    local timeStr = TimeUtils.formatTime(topRun.time)
    local chestStr = topRun.chests > 0 and " (+" .. topRun.chests .. ")" or ""
    
    local timeSaved = topRun.keystoneTime - topRun.time
    local timeSavedStr = TimeUtils.formatTime(timeSaved)
    local timeSavedColor = timeSaved > 0 and "|cff00ff00" or "|cffff0000"
    
    tooltip:AddLine(string.format("|cffff8000+%d|r in |cff00ff00%s|r%s (%s-%s|r under timer)", 
        topRun.level, timeStr, chestStr, timeSavedColor, timeSavedStr))
    
    if MrMythicalLeaderboardDB.showScore then
        tooltip:AddLine(string.format("Score: %s%.1f|r", 
            ColorUtils.calculateGradientColor(topRun.score, 165, 500, GRADIENTS), topRun.score))
    end
    
    local rosterDisplay = MrMythicalLeaderboardDB.rosterDisplay or "off"
    if rosterDisplay ~= "off" and topRun.roster and #topRun.roster > 0 then
        tooltip:AddLine(" ")
        tooltip:AddLine("|cff888888Roster:|r")
        for i, member in ipairs(topRun.roster) do
            if i > 5 then break end
            local classColor = ColorUtils.getClassColor(member.class)
            local memberText = classColor .. member.name .. "|r"
            
            if rosterDisplay == "names_realm" and member.realm then
                memberText = memberText .. " - " .. member.realm
            end
            
            tooltip:AddLine("  " .. memberText)
        end
    end
    
    tooltip:Show()
end

local function handleShowCommand()
    MrMythicalLeaderboard.showHighestKeys()
end

local function handleHelpCommand()
    print("|cff00ff00Mr. Mythical Leaderboard Commands:|r")
    print("  /mrmlb - Show highest keys for each dungeon")
    print("  /mrmlb help - Show this help")
    print("|cff888888Settings:|r Available under Interface > AddOns > Mr. Mythical > Leaderboard")
end

local function processSlashCommand(commandString)
    local args = {}
    for word in string.gmatch(commandString, "%S+") do
        table.insert(args, word)
    end
    
    local command = args[1] and args[1]:lower() or "show"
    
    if command == "help" then
        handleHelpCommand()
    else
        handleShowCommand()
    end
end

-- Register our own slash commands
SLASH_MRMYTHICALLEADERBOARD1 = "/mrmlb"
SlashCmdList["MRMYTHICALLEADERBOARD"] = processSlashCommand
