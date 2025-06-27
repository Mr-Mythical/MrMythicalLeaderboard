--[[
TimeUtils.lua - Time Formatting Utilities

Purpose: Provides time formatting and manipulation functions
Dependencies: None
Author: Braunerr
--]]

local MrMythicalLeaderboard = MrMythicalLeaderboard or {}
MrMythicalLeaderboard.TimeUtils = {}

local TimeUtils = MrMythicalLeaderboard.TimeUtils

--- Formats milliseconds into a readable time string
--- @param timeMs number Time in milliseconds
--- @return string Formatted time string (e.g., "5:23")
function TimeUtils.formatTime(timeMs)
    local totalSeconds = math.floor(timeMs / 1000)
    local minutes = math.floor(totalSeconds / 60)
    local seconds = totalSeconds % 60
    return string.format("%d:%02d", minutes, seconds)
end
