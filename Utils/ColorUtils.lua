--[[
ColorUtils.lua - Color Calculation and Gradient Utilities for Leaderboard

Purpose: Provides color interpolation and gradient calculation functions for leaderboard
Dependencies: ConfigData for color constants
Author: Braunerr
--]]

local MrMythicalLeaderboard = MrMythicalLeaderboard or {}
MrMythicalLeaderboard.ColorUtils = {}

local ColorUtils = MrMythicalLeaderboard.ColorUtils
local ConfigData = MrMythicalLeaderboard.ConfigData

--- Interpolates between color stops to create a smooth gradient color
--- @param normalizedValue number A value between 0 and 1 representing position in gradient
--- @param colorStops table Array of color stops, each with .rgbInteger property
--- @return string WoW color code in format |cffRRGGBB
function ColorUtils.interpolateColorFromStops(normalizedValue, colorStops)
    -- Clamp value to valid range
    normalizedValue = math.max(0, math.min(1, normalizedValue))
    
    local numStops = #colorStops
    local scaledIndex = normalizedValue * (numStops - 1) + 1
    local lowerIndex = math.floor(scaledIndex)
    local upperIndex = math.min(lowerIndex + 1, numStops)
    local interpolationFactor = scaledIndex - lowerIndex

    -- Get RGB values for interpolation
    local lowerRed, lowerGreen, lowerBlue = unpack(colorStops[lowerIndex].rgbInteger)
    local upperRed, upperGreen, upperBlue = unpack(colorStops[upperIndex].rgbInteger)
    
    -- Linear interpolation between colors
    local finalRed = lowerRed + (upperRed - lowerRed) * interpolationFactor
    local finalGreen = lowerGreen + (upperGreen - lowerGreen) * interpolationFactor
    local finalBlue = lowerBlue + (upperBlue - lowerBlue) * interpolationFactor

    return string.format("|cff%02x%02x%02x", finalRed, finalGreen, finalBlue)
end

--- Calculates a gradient color for a value within a specified domain
--- @param value number The value to colorize
--- @param domainMin number Minimum value of the domain
--- @param domainMax number Maximum value of the domain
--- @param colorStops table Array of color stops for the gradient
--- @return string WoW color code, or white if plain colors are enabled
function ColorUtils.calculateGradientColor(value, domainMin, domainMax, colorStops)
    -- Check if plain colors are enabled (default to false if not set)
    local plainColors = MrMythicalLeaderboardDB and MrMythicalLeaderboardDB.plainScoreColors
    if plainColors then
        return ConfigData.COLORS.WHITE
    end
    
    local normalizedValue = (value - domainMin) / (domainMax - domainMin)
    -- Invert the ratio so higher values get "better" colors
    normalizedValue = 1 - normalizedValue
    
    return ColorUtils.interpolateColorFromStops(normalizedValue, colorStops)
end

--- Gets class color for a given class name
--- @param className string The class name to get color for
--- @return string WoW color code
function ColorUtils.getClassColor(className)
    local white = (MrMythicalLeaderboard.ConfigData and MrMythicalLeaderboard.ConfigData.COLORS.WHITE) or "|cffffffff"
    
    local classColors = {
        ["Death Knight"] = "|cffc41e3a",
        ["Demon Hunter"] = "|cffa330c9",
        ["Druid"] = "|cffff7c0a",
        ["Evoker"] = "|cff33937f",
        ["Hunter"] = "|cffaad372",
        ["Mage"] = "|cff3fc7eb",
        ["Monk"] = "|cff00ff98",
        ["Paladin"] = "|cfff48cba",
        ["Priest"] = white,
        ["Rogue"] = "|cffffff00",
        ["Shaman"] = "|cff0070dd",
        ["Warlock"] = "|cff8788ee",
        ["Warrior"] = "|cffc69b6d",
    }
    return classColors[className] or white
end
