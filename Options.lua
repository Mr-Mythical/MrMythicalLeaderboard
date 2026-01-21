--[[
Mr. Mythical Leaderboard Options Panel

This module handles the creation and management of the settings panel for the
Mr. Mythical Leaderboard addon. It uses a global registry pattern to coordinate
with other Mr. Mythical addons to avoid duplicate category creation.

Author: Braunerr
--]]

_G.MrMythicalLeaderboard = _G.MrMythicalLeaderboard or {}

local Options = {}

-- Export the Options module immediately so it's available to other files
_G.MrMythicalLeaderboard.Options = Options

-- Configuration data
local DEFAULTS = {
    enabled = true,
    showScore = true,
    rosterDisplay = "off"
}

-- Expose defaults
Options.DEFAULTS = DEFAULTS

local DROPDOWN_OPTIONS = {
    rosterDisplay = {
        { text = "Off", value = "off" },
        { text = "Names Only", value = "names" },
        { text = "Names + Realm", value = "names_realm" }
    }
}

local TOOLTIPS = {
    enabled = "Enable or disable the Mr. Mythical Leaderboard addon functionality.",
    showScore = "Display the Mythic+ score in keystone tooltips.",
    rosterDisplay = "Choose how to display the roster in keystone tooltips:\n\n" ..
        "|cffffffffOff:|r Don't show roster information\n\n" ..
        "|cffffffffNames Only:|r Show player names and classes only\n\n" ..
        "|cffffffffNames + Realm:|r Show player names, classes, and realm names"
}

--- Creates a setting with appropriate UI element
--- @param category table The settings category
--- @param name string Display name for the setting
--- @param key string Database key for the setting
--- @param settingType string "boolean", "string", or "number"
--- @param tooltip string Tooltip text
--- @param options? table For dropdown settings only
--- @return table Setting object with setting and initializer
local function createSetting(category, name, key, settingType, tooltip, options)
    local defaultValue = DEFAULTS[key]
    local setting = Settings.RegisterAddOnSetting(category, name, key, MrMythicalLeaderboardDB, settingType, name,
        defaultValue)
    setting:SetValueChangedCallback(function(_, value)
        MrMythicalLeaderboardDB[key] = value
    end)

    local initializer
    if settingType == "boolean" then
        initializer = Settings.CreateCheckbox(category, setting, tooltip)
    else -- dropdown for string/number
        local function getOptions()
            -- Fallback: build menu entries compatible with Blizzard_Menu on older clients.
            local dropdownOptions = {}
            local menuRadio = (_G.MenuButtonType and _G.MenuButtonType.Radio)
                or (_G.Enum and Enum.MenuItemType and Enum.MenuItemType.Radio)
                or 1                    -- numeric fallback commonly used for Radio
            for _, option in ipairs(options) do
                table.insert(dropdownOptions, {
                    text = option.text,
                    label = option.text,
                    value = option.value,
                    controlType = menuRadio,
                    -- Mark selected state and provide a handler to update the setting.
                    checked = function() return setting:GetValue() == option.value end,
                    func = function() setting:SetValue(option.value) end,
                })
            end
            return dropdownOptions
        end
        initializer = Settings.CreateDropdown(category, setting, getOptions, tooltip)
    end

    initializer:SetSetting(setting)
    return { setting = setting, initializer = initializer }
end

--- Initialize the addon settings panel
function Options.initializeSettings()
    MrMythicalLeaderboardDB = MrMythicalLeaderboardDB or {}

    -- Set defaults for any missing values
    for key, default in pairs(DEFAULTS) do
        if MrMythicalLeaderboardDB[key] == nil then
            MrMythicalLeaderboardDB[key] = default
        end
    end

    -- Migrate old settings to new format if they exist
    if MrMythicalLeaderboardDB.showRoster ~= nil or MrMythicalLeaderboardDB.showRealm ~= nil then
        local oldShowRoster = MrMythicalLeaderboardDB.showRoster
        local oldShowRealm = MrMythicalLeaderboardDB.showRealm
        
        if not oldShowRoster then
            MrMythicalLeaderboardDB.rosterDisplay = "off"
        elseif oldShowRealm then
            MrMythicalLeaderboardDB.rosterDisplay = "names_realm"
        else
            MrMythicalLeaderboardDB.rosterDisplay = "names"
        end
        
        MrMythicalLeaderboardDB.showRoster = nil
        MrMythicalLeaderboardDB.showRealm = nil
    end

    -- Call settings panel creation directly
    Options.createSettingsPanel()
end

function Options.createSettingsPanel()
    -- Use a global registry to coordinate with the sibling Mr. Mythical addon
    if not _G.MrMythicalSettingsRegistry then
        _G.MrMythicalSettingsRegistry = {}
    end

    local registry = _G.MrMythicalSettingsRegistry
    local parentCategory = nil

    -- Check if the sibling addon already created the parent category
    if registry.parentCategory then
        parentCategory = registry.parentCategory
    else
        -- Create the parent category
        parentCategory = Settings.RegisterVerticalLayoutCategory("Mr. Mythical")
        registry.parentCategory = parentCategory
        registry.createdBy = "MrMythicalLeaderboard"
        Settings.RegisterAddOnCategory(parentCategory)
    end

    -- Create our subcategory under the parent
    local category = Settings.RegisterVerticalLayoutSubcategory(parentCategory, "Leaderboard")

    registry.subCategories = registry.subCategories or {}
    registry.subCategories["Leaderboard"] = category

    local layout = SettingsPanel:GetLayout(category)

    -- Helper function to add section header
    local function addHeader(name, tooltip)
        local headerData = { name = name, tooltip = tooltip }
        local headerInitializer = Settings.CreateElementInitializer("SettingsListSectionHeaderTemplate", headerData)
        layout:AddInitializer(headerInitializer)
    end

    -- Define all settings in a table-driven way
    local settingsConfig = {
        {
            header = { name = "General Settings", tooltip = "Main leaderboard functionality settings" },
            settings = {
                {
                    name = "Enable Leaderboard",
                    key = "enabled",
                    type = "boolean",
                    tooltip = TOOLTIPS.enabled
                }
            }
        },
        {
            header = { name = "Tooltip Display Options", tooltip = "Settings that control what information is shown in keystone tooltips" },
            settings = {
                {
                    name = "Show Score",
                    key = "showScore",
                    type = "boolean",
                    tooltip = TOOLTIPS.showScore
                },
                {
                    name = "Roster Display",
                    key = "rosterDisplay",
                    type = "string",
                    tooltip = TOOLTIPS.rosterDisplay,
                    options = DROPDOWN_OPTIONS.rosterDisplay
                }
            }
        }
    }

    -- Create all settings
    for _, section in ipairs(settingsConfig) do
        if section.header then
            addHeader(section.header.name, section.header.tooltip)
        end

        for _, setting in ipairs(section.settings) do
            createSetting(category, setting.name, setting.key, setting.type, setting.tooltip, setting.options)
        end
    end
end

-- Utility function for other addons to check integration status
function Options.getIntegrationInfo()
    local registry = _G.MrMythicalSettingsRegistry
    if not registry then
        return {
            integrated = false,
            reason = "No global registry found"
        }
    end

    return {
        integrated = registry.parentCategory ~= nil,
        parentExists = registry.parentCategory ~= nil,
        createdBy = registry.createdBy,
        leaderboardExists = registry.subCategories and registry.subCategories["Leaderboard"] ~= nil,
        parentName = registry.parentCategory and registry.parentCategory.GetName and registry.parentCategory:GetName() or nil
    }
end
