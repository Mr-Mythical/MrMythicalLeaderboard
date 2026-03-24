--[[
DungeonData.lua - Mythic+ Dungeon Map Data for Leaderboard

Purpose: Contains mapping data for all current season Mythic+ dungeons for leaderboard
Dependencies: None
Author: Braunerr
--]]

local MrMythicalLeaderboard = MrMythicalLeaderboard or {}

MrMythicalLeaderboard.DungeonData = {
    MYTHIC_MAPS = {
        { id = 402, name = "Algeth'ar Academy" },
        { id = 558, name = "Magisters' Terrace" },
        { id = 560, name = "Maisara Caverns" },
        { id = 559, name = "Nexus-Point Xenas" },
        { id = 556, name = "Pit of Saron" },
        { id = 239, name = "Seat of the Triumvirate" },
        { id = 161, name = "Skyreach" },
        { id = 557, name = "Windrunner Spire" }
    }
}

_G.MrMythicalLeaderboard = MrMythicalLeaderboard
