--[[
Mr. Mythical Leaderboard Options Panel

This module handles the creation and management of the settings panel for the 
Mr. Mythical Leaderboard addon. It uses a global registry pattern to coordinate
with other Mr. Mythical addons to avoid duplicate category creation.

Global Registry Pattern:
- Uses _G.MrMythicalSettingsRegistry to coordinate between sibling addons
- Prevents duplicate "Mr. Mythical" parent categories
- Allows any addon to create the parent category first
- Other addons create their own subcategories under the shared parent

Sibling Integration:
Both Mr. Mythical addons are siblings and follow the same pattern:
1. Check if _G.MrMythicalSettingsRegistry.parentCategory exists
2. If not, create the parent category and store it in the registry
3. If yes, use the existing parent category
4. Create own subcategory under the parent
5. Always mark registry.createdBy to track which addon created the parent

This ensures a clean "Mr. Mythical" -> "Keystone Tooltips"/"Leaderboard" hierarchy 
regardless of addon load order.

Author: Braunerr
--]]

local MrMythicalLeaderboard = MrMythicalLeaderboard or {}
local ConfigData = MrMythicalLeaderboard.ConfigData

local Options = {}

--- Creates a boolean setting with a checkbox
--- @param category table The settings category
--- @param name string Display name for the setting
--- @param key string Database key for the setting
--- @param defaultValue boolean Default value
--- @param tooltip string Tooltip text
--- @return table Setting object with setting and checkbox
local function createSetting(category, name, key, defaultValue, tooltip)
    local setting = Settings.RegisterAddOnSetting(category, name, key, MrMythicalLeaderboardDB, "boolean", name, defaultValue)
    setting:SetValueChangedCallback(function(_, value)
        MrMythicalLeaderboardDB[key] = value
    end)

    local initializer = Settings.CreateCheckbox(category, setting, tooltip)
    initializer:SetSetting(setting)

    return { setting = setting, checkbox = initializer }
end

--- Creates a dropdown setting
--- @param category table The settings category
--- @param name string Display name for the setting
--- @param key string Database key for the setting
--- @param defaultValue string Default value
--- @param tooltip string Tooltip text
--- @param options table Array of options with text and value
--- @return table Setting object with setting and dropdown
local function createDropdownSetting(category, name, key, defaultValue, tooltip, options)
    local setting = Settings.RegisterAddOnSetting(category, name, key, MrMythicalLeaderboardDB, "string", name, defaultValue)
    setting:SetValueChangedCallback(function(_, value)
        MrMythicalLeaderboardDB[key] = value
    end)

    local function getOptions()
        local dropdownOptions = {}
        for _, option in ipairs(options) do
            table.insert(dropdownOptions, {
                text = option.text,
                label = option.text,
                value = option.value,
            })
        end
        return dropdownOptions
    end

    local initializer = Settings.CreateDropdown(category, setting, getOptions, tooltip)

    return { setting = setting, dropdown = initializer }
end

--- Initialize the addon settings panel
function Options.initializeSettings()
    local defaults = {
        enabled = true,
        showScore = true,
        rosterDisplay = "off",
    }

    MrMythicalLeaderboardDB = MrMythicalLeaderboardDB or {}
    for key, default in pairs(defaults) do
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

    if not Settings or not Settings.RegisterVerticalLayoutCategory then
        return
    end

    local success = pcall(Options.createSettingsPanel)
    if not success then
        C_Timer.After(0.1, function()
            pcall(Options.createSettingsPanel)
        end)
    end
end

function Options.createSettingsPanel()
    if not Settings or not Settings.RegisterVerticalLayoutCategory then
        return
    end
    
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
        -- We need to create the parent category
        local success, result = pcall(function()
            return Settings.RegisterVerticalLayoutCategory("Mr. Mythical")
        end)
        
        if success and result then
            parentCategory = result
            registry.parentCategory = parentCategory
            registry.createdBy = "MrMythicalLeaderboard"
            
            local regSuccess = pcall(function()
                Settings.RegisterAddOnCategory(parentCategory)
            end)
        else
            -- Fallback: create a unique parent just for the leaderboard
            parentCategory = Settings.RegisterVerticalLayoutCategory("Mr. Mythical Leaderboard")
            Settings.RegisterAddOnCategory(parentCategory)
        end
    end
    
    if not parentCategory then
        return
    end
    
    -- Create our subcategory under the parent (using WoW-native subcategory method)
    local category
    
    -- Try the native subcategory registration method first
    local subcategorySuccess, subcategoryResult = pcall(function()
        return Settings.RegisterVerticalLayoutSubcategory(parentCategory, "Leaderboard")
    end)
    
    if subcategorySuccess and subcategoryResult then
        category = subcategoryResult
        
        registry.subCategories = registry.subCategories or {}
        registry.subCategories["Leaderboard"] = category
    else
        -- Fallback to the manual SetParentCategory method
        local altSuccess, altResult = pcall(function()
            local subCat = Settings.RegisterVerticalLayoutCategory("Leaderboard")
            subCat:SetParentCategory(parentCategory)
            return subCat
        end)
        
        if altSuccess and altResult then
            category = altResult
            registry.subCategories = registry.subCategories or {}
            registry.subCategories["Leaderboard"] = category
        else
            category = parentCategory
        end
    end
    
    local layout = SettingsPanel:GetLayout(category)
    if not layout then
        return
    end

    -- General Settings Header
    local generalHeaderData = {
        name = "General Settings",
        tooltip = "Main leaderboard functionality settings"
    }
    local generalHeaderInitializer = Settings.CreateElementInitializer("SettingsListSectionHeaderTemplate", generalHeaderData)
    layout:AddInitializer(generalHeaderInitializer)

    -- Enable/Disable addon
    createSetting(
        category,
        "Enable Leaderboard",
        "enabled",
        true,
        "Enable or disable the Mr. Mythical Leaderboard addon functionality."
    )

    -- Tooltip Display Settings Header
    local tooltipHeaderData = {
        name = "Tooltip Display Options",
        tooltip = "Settings that control what information is shown in keystone tooltips"
    }
    local tooltipHeaderInitializer = Settings.CreateElementInitializer("SettingsListSectionHeaderTemplate", tooltipHeaderData)
    layout:AddInitializer(tooltipHeaderInitializer)

    -- Show score in tooltips
    createSetting(
        category,
        "Show Score",
        "showScore",
        true,
        "Display the Mythic+ score in keystone tooltips."
    )

    -- Roster Display Mode
    local rosterDisplayOptions = {
        { text = "Off", value = "off" },
        { text = "Names Only", value = "names" },
        { text = "Names + Realm", value = "names_realm" }
    }

    createDropdownSetting(
        category,
        "Roster Display",
        "rosterDisplay",
        "off",
        "Choose how to display the roster in keystone tooltips:\n\n" ..
        "|cffffffffOff:|r Don't show roster information\n\n" ..
        "|cffffffffNames Only:|r Show player names and classes only\n\n" ..
        "|cffffffffNames + Realm:|r Show player names, classes, and realm names",
        rosterDisplayOptions
    )
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

-- Export the Options module
MrMythicalLeaderboard.Options = Options
