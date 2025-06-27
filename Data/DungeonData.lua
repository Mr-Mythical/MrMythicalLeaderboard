--[[
DungeonData.lua - Mythic+ Dungeon Map Data for Leaderboard

Purpose: Contains mapping data for all current season Mythic+ dungeons for leaderboard
Dependencies: None
Author: Braunerr
--]]

local MrMythicalLeaderboard = MrMythicalLeaderboard or {}

MrMythicalLeaderboard.DungeonData = {
    MYTHIC_MAPS = {
        { id = 506, name = "Cinderbrew Meadery" },
        { id = 504, name = "Darkflame Cleft" },
        { id = 370, name = "Mechagon Workshop" },
        { id = 525, name = "Operation: Floodgate" },
        { id = 499, name = "Priory of the Sacred Flame" },
        { id = 247, name = "The MOTHERLODE!!" },
        { id = 500, name = "The Rookery" },
        { id = 382, name = "Theater of Pain" }
    }
}

_G.MrMythicalLeaderboard = MrMythicalLeaderboard
