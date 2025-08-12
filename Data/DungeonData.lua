--[[
DungeonData.lua - Mythic+ Dungeon Map Data for Leaderboard

Purpose: Contains mapping data for all current season Mythic+ dungeons for leaderboard
Dependencies: None
Author: Braunerr
--]]

local MrMythicalLeaderboard = MrMythicalLeaderboard or {}

MrMythicalLeaderboard.DungeonData = {
    MYTHIC_MAPS = {
        { id = 503, name = "Ara-kara, City of Echoes" },
        { id = 542, name = "Eco-Dome Al'dani" },
        { id = 378, name = "Halls of Atonement" },
        { id = 525, name = "Operation: Floodgate" },
        { id = 499, name = "Priory of the Sacred Flame" },
        { id = 392, name = "Tazavesh: So'leah's Gambit" },
        { id = 391, name = "Tazavesh: Streets of Wonder" },
        { id = 505, name = "The Dawnbreaker" }
    }
}

_G.MrMythicalLeaderboard = MrMythicalLeaderboard
