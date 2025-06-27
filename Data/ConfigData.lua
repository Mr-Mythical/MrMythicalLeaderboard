--[[
ConfigData.lua - Configuration Constants for Leaderboard

Purpose: Central configuration data and color constants for leaderboard addon
Dependencies: None
Author: Braunerr
--]]

local MrMythicalLeaderboard = MrMythicalLeaderboard or {}

MrMythicalLeaderboard.ConfigData = {
    COLORS = {
        WHITE = "|cffffffff",
        GOLD = "|cffffcc00",
        GREEN = "|cff00ff00",
        GRAY = "|cff808080",
        BLUE = "|cff0088ff",
        RED = "|cffff0000",
    },

    REGION_MAP = {
        [1] = "us",
        [2] = "kr",
        [3] = "eu",
        [4] = "tw",
        [5] = "cn"
    }
}

_G.MrMythicalLeaderboard = MrMythicalLeaderboard
