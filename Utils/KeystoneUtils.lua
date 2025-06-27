--[[
KeystoneUtils.lua - Keystone Data Processing Utilities for Leaderboard

Purpose: Parses and processes Mythic+ keystone data and links for leaderboard display
Dependencies: None
Author: Braunerr
--]]

local MrMythicalLeaderboard = MrMythicalLeaderboard or {}
MrMythicalLeaderboard.KeystoneUtils = {}

local KeystoneUtils = MrMythicalLeaderboard.KeystoneUtils

--- Extracts the item string from a keystone hyperlink
--- @param keystoneLink string The full keystone link from chat or tooltip
--- @return string|nil The item string portion, or nil if not found
function KeystoneUtils.extractItemString(keystoneLink)
    return string.match(keystoneLink, "keystone[%-?%d:]+")
end

--- Extracts the keystone level from a keystone link
--- @param keystoneLink string The keystone link or item string
--- @return number|nil The keystone level, or nil if not found
function KeystoneUtils.extractKeystoneLevel(keystoneLink)
    local keyField = select(4, strsplit(":", keystoneLink))
    if keyField then
        return tonumber(string.sub(keyField, 1, 2))
    end
    return nil
end

--- Extracts the map ID from a keystone link
--- @param keystoneLink string The keystone link or item string
--- @return number|nil The map ID, or nil if not found
function KeystoneUtils.extractMapID(keystoneLink)
    local linkParts = { strsplit(":", keystoneLink) }
    if #linkParts >= 3 then
        return tonumber(linkParts[3])
    end
    return nil
end

--- Validates if a link is a keystone link
--- @param link string The link to validate
--- @return boolean True if the link is a valid keystone link
function KeystoneUtils.isKeystoneLink(link)
    return link and link:find("keystone:") ~= nil
end

--- Parses all keystone data from a link in one call
--- @param keystoneLink string The keystone link to parse
--- @return table|nil Table with itemString, level, and mapID, or nil if invalid
function KeystoneUtils.parseKeystoneData(keystoneLink)
    if not KeystoneUtils.isKeystoneLink(keystoneLink) then
        return nil
    end
    
    local itemString = KeystoneUtils.extractItemString(keystoneLink)
    if not itemString then
        return nil
    end
    
    local level = KeystoneUtils.extractKeystoneLevel(itemString)
    local mapID = KeystoneUtils.extractMapID(itemString)
    
    if not level or not mapID then
        return nil
    end
    
    return {
        itemString = itemString,
        level = level,
        mapID = mapID
    }
end
