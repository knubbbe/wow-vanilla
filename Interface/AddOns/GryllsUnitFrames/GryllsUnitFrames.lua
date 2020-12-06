-- GryllsUnitFrames
-- Adds HP & Power values to the unit frames
-- based on CT_UnitFrames (http://addons.us.to/addon/ct)
-- MobHealth3 support

GryllsUnitFrames_Settings = {
    party = true,
    value = true,
    percent = false,
    both = false,
    short = false,
    colorhealth = true,
    colorpower = true,
    colorname = true,
    valuefont = "frizqt__",
    valuesize = 11,
    combat = false,
    namefont = "frizqt__",
    namesize = 11,
}

function GryllsUnitFrames_OnLoad()
    _G = getfenv()
    this:RegisterEvent("ADDON_LOADED")
    this:RegisterEvent("VARIABLES_LOADED")
    this:RegisterEvent("PLAYER_ENTERING_WORLD")
    this:RegisterEvent("UNIT_MANA")
    this:RegisterEvent("UNIT_MAXMANA")
    this:RegisterEvent("UNIT_HEALTH")
    this:RegisterEvent("UNIT_RAGE")
    this:RegisterEvent("UNIT_MAXRAGE")
    this:RegisterEvent("UNIT_FOCUS")
    this:RegisterEvent("UNIT_MAXFOCUS")
    this:RegisterEvent("UNIT_ENERGY")
    this:RegisterEvent("UNIT_MAXENERGY")
	this:RegisterEvent("UNIT_DISPLAYPOWER")
    this:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
    this:RegisterEvent("PARTY_MEMBERS_CHANGED")
    this:RegisterEvent("PLAYER_TARGET_CHANGED")
    this:RegisterEvent("UNIT_PET")

    SLASH_GRYLLSUNITFRAMES1 = "/gryllsunitframes"
    SLASH_GRYLLSUNITFRAMES2 = "/guf"
    SlashCmdList["GRYLLSUNITFRAMES"] = gryllsunitframes_commands

    DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames loaded - use /gryllsunitframes or /guf for options")
end

function gryllsunitframes_commands(msg, editbox)
    local yellow = "FFFFFF00"
    local orange = "FFFF9900"

    local function fontnum(msg)
        local startPos = string.find(msg, "%d")
        local numstr = string.sub(msg, startPos)
        if tonumber(numstr) then
            DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: font size set to |c"..yellow..numstr.."|r")
            return numstr            
        else
            DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: unable to set font size to |c"..yellow..numstr.."|r as it is not a number, please try again")
        end
    end

    if msg == "" then   
        DEFAULT_CHAT_FRAME:AddMessage("|c"..orange.."GryllsUnitFrames options:|r")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..yellow.."/guf party|r - toggles display of party values")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..yellow.."/guf value|r - shows options for displaying health/power values")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..yellow.."/guf color|r - shows options for coloring name/health/power values")   
        DEFAULT_CHAT_FRAME:AddMessage("|c"..yellow.."/guf font|r - shows options for changing the font")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..yellow.."/guf combat|r - toggles hiding the combat text shown on the portrait")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..yellow.."/guf reset|r - resets all options to default")
    -- reset
    elseif msg == "reset" then
        GryllsUnitFrames_resetVariables()
        DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: options reset to default")
        GryllsUnitFrames_updateNameFont()
        GryllsUnitFrames_updateValueFont()
        GryllsUnitFrames_updateUnitFrames()
    -- combat
    elseif msg == "combat" then
        if GryllsUnitFrames_Settings.combat then
            GryllsUnitFrames_Settings.combat = false
            DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: combat text hidden")
        else
            GryllsUnitFrames_Settings.combat = true
            DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: combat text shown")
        end
        GryllsUnitFrames_combat()
    -- party options
    elseif msg == "party" then
        if GryllsUnitFrames_Settings.party then
            GryllsUnitFrames_Settings.party = false
            DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: party values hidden")
        else
            GryllsUnitFrames_Settings.party = true
            DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: party values shown")
        end
        GryllsUnitFrames_setPartyVisibility()
    -- value options
    elseif msg == "value" then
        DEFAULT_CHAT_FRAME:AddMessage("|c"..orange.."GryllsUnitFrames value options:|r")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..yellow.."/guf value value|r - shows health/mana as a value (requires MobHealth for enemy values)")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..yellow.."/guf value percent|r - shows health/mana as a percentage")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..yellow.."/guf value both|r - shows health/mana as value and percentage")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..yellow.."/guf value short|r - toggles short values e.g. 10.1k instead of 10,100")
    elseif msg == "value value" then
        GryllsUnitFrames_Settings.value = true
        GryllsUnitFrames_Settings.percent = false
        GryllsUnitFrames_Settings.both = false
        DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: values shown")
        GryllsUnitFrames_updateUnitFrames()  
    elseif msg == "value percent" then
        GryllsUnitFrames_Settings.value = false
        GryllsUnitFrames_Settings.percent = true
        GryllsUnitFrames_Settings.both = false
        DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: percent shown")
        GryllsUnitFrames_updateUnitFrames()
    elseif msg == "value both" then
        GryllsUnitFrames_Settings.value = false
        GryllsUnitFrames_Settings.percent = false
        GryllsUnitFrames_Settings.both = true
        DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: values and percent shown")
        GryllsUnitFrames_updateUnitFrames()
    elseif msg == "value short" then
        if GryllsUnitFrames_Settings.short then
            GryllsUnitFrames_Settings.short = false
            DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: short values off")
            GryllsUnitFrames_updateUnitFrames()
        else
            GryllsUnitFrames_Settings.short = true
            DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: short values on")
            GryllsUnitFrames_updateUnitFrames()
        end
    -- color options
    elseif msg == "color" then
        DEFAULT_CHAT_FRAME:AddMessage("|c"..orange.."GryllsUnitFrames color options:|r")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..yellow.."/guf color name|r - toggles class/reaction color names")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..yellow.."/guf color health|r - toggles health coloring")
        DEFAULT_CHAT_FRAME:AddMessage("health coloring will show green when over 75%, orange when under 75%, yellow when under 50% and red when under 20%")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..yellow.."/guf color power|r - toggles power coloring")
        DEFAULT_CHAT_FRAME:AddMessage("power coloring will show the relevant colors for mana, rage, energy and focus")
    elseif msg == "color name" then
        if GryllsUnitFrames_Settings.colorname then
            GryllsUnitFrames_Settings.colorname = false
            DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: name coloring off")
            GryllsUnitFrames_updateUnitFrames()
            GryllsUnitFrames_tot()
        else
            GryllsUnitFrames_Settings.colorname = true
            DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: name coloring on")
            GryllsUnitFrames_updateUnitFrames()
            GryllsUnitFrames_tot()
        end
    elseif msg == "color health" then
        if GryllsUnitFrames_Settings.colorhealth then
            GryllsUnitFrames_Settings.colorhealth = false
            DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: health coloring off")
            GryllsUnitFrames_updateUnitFrames()
        else
            GryllsUnitFrames_Settings.colorhealth = true
            DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: health coloring on")
            GryllsUnitFrames_updateUnitFrames()
        end
    elseif msg == "color power" then
        if GryllsUnitFrames_Settings.colorpower then
            GryllsUnitFrames_Settings.colorpower = false
            DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: power coloring off")
            GryllsUnitFrames_updateUnitFrames()
        else
            GryllsUnitFrames_Settings.colorpower = true
            DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: power coloring on")
            GryllsUnitFrames_updateUnitFrames()
        end
    -- font options
    elseif msg == "font" then
        DEFAULT_CHAT_FRAME:AddMessage("|c"..orange.."GryllsUnitFrames font options:|r")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..orange.."name/value|r = choose name or value")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..orange.."number|r = choose a number")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..yellow.."/guf font|r |c"..orange.."name/value |c"..yellow.."size |c"..orange.."number|r")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..yellow.."/guf font|r |c"..orange.."name/value |c"..yellow.."arialn|r")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..yellow.."/guf font|r |c"..orange.."name/value |c"..yellow.."frizqt|r")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..yellow.."/guf font|r |c"..orange.."name/value |c"..yellow.."morpheus|r")
        DEFAULT_CHAT_FRAME:AddMessage("|c"..yellow.."/guf font|r |c"..orange.."name/value |c"..yellow.."skurri|r")
    -- value
    elseif msg == "font value arialn" then
        GryllsUnitFrames_Settings.valuefont = "arialn"
        GryllsUnitFrames_updateValueFont()
        DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: value using arialn font")
    elseif msg == "font value frizqt" then
        GryllsUnitFrames_Settings.valuefont = "frizqt__"
        GryllsUnitFrames_updateValueFont()
        DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: value using frizqt font")
    elseif msg == "font value morpheus" then
        GryllsUnitFrames_Settings.valuefont = "morpheus"
        GryllsUnitFrames_updateValueFont()
        DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: value using morpheus font")
    elseif msg == "font value skurri" then
        GryllsUnitFrames_Settings.valuefont = "skurri"
        GryllsUnitFrames_updateValueFont()
        DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: value using skurri font")
    elseif string.find(msg, "font value size %d") then
        GryllsUnitFrames_Settings.valuesize = fontnum(msg)
        GryllsUnitFrames_updateValueFont()
    -- name
    elseif msg == "font name arialn" then
        GryllsUnitFrames_Settings.namefont = "arialn"
        GryllsUnitFrames_updateNameFont()
        DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: name using arialn font")
    elseif msg == "font name frizqt" then
        GryllsUnitFrames_Settings.namefont = "frizqt__"
        GryllsUnitFrames_updateNameFont()
        DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: name using frizqt font")
    elseif msg == "font name morpheus" then
        GryllsUnitFrames_Settings.namefont = "morpheus"
        GryllsUnitFrames_updateNameFont()
        DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: name using morpheus font")
    elseif msg == "font name skurri" then
        GryllsUnitFrames_Settings.namefont = "skurri"
        GryllsUnitFrames_updateNameFont()
        DEFAULT_CHAT_FRAME:AddMessage("GryllsUnitFrames: name using skurri font")    
    elseif string.find(msg, "font name size %d") then
        GryllsUnitFrames_Settings.namesize = fontnum(msg)
        GryllsUnitFrames_updateNameFont()
    end
end

function GryllsUnitFrames_resetVariables()
    GryllsUnitFrames_Settings.party = true
    GryllsUnitFrames_Settings.value = true
    GryllsUnitFrames_Settings.percent = false
    GryllsUnitFrames_Settings.both = false
    GryllsUnitFrames_Settings.short = false
    GryllsUnitFrames_Settings.colorname = true
    GryllsUnitFrames_Settings.colorhealth = true
    GryllsUnitFrames_Settings.colorpower = true    
    GryllsUnitFrames_Settings.valuefont = "frizqt__"
    GryllsUnitFrames_Settings.valuesize = 11
    GryllsUnitFrames_Settings.combat = false
    GryllsUnitFrames_Settings.namefont = "frizqt__"
    GryllsUnitFrames_Settings.namesize = 11
end

function GryllsUnitFrames_OnEvent(event)
    if event == "ADDON_LOADED" then
        if not Grylls_PlayerFrame then      
            GryllsUnitFrames_createFrames()
            GryllsUnitFrames_tot()
            GryllsUnitFrames_setup()
        end
    end

    if event == "VARIABLES_LOADED" then
        GryllsUnitFrames_updateNameFont()
        GryllsUnitFrames_updateValueFont()
        GryllsUnitFrames_setPartyVisibility()
        GryllsUnitFrames_combat()               
    end

    if event == "PLAYER_ENTERING_WORLD" then
        GryllsUnitFrames_colorName("player", PlayerFrame)        
        GryllsUnitFrames_updateHealth("player", Grylls_PlayerFrame)
        GryllsUnitFrames_updatePower("player", Grylls_PlayerFrame)
        GryllsUnitFrames_updatePartyFrames()
        GryllsUnitFrames_hideStatusBarText()
    end

    if event == "PLAYER_TARGET_CHANGED" then
        GryllsUnitFrames_colorName("target", TargetFrame)
        GryllsUnitFrames_updateHealth("target", Grylls_TargetFrame)
        GryllsUnitFrames_updatePower("target", Grylls_TargetFrame)
    end

    if event == "PARTY_MEMBERS_CHANGED" then
        GryllsUnitFrames_updatePartyFrames()
    end

    if event == "UNIT_PET" then
        if arg1 == "player" then -- runs for player pet only
            GryllsUnitFrames_colorName("pet", PetFrame)
            GryllsUnitFrames_updateHealth("pet", Grylls_PetFrame)
            GryllsUnitFrames_updatePower("pet", Grylls_PetFrame)
        end
    end

    if (event == "UNIT_HEALTH" or "UNIT_MAXHEALTH") then
        if arg1 == "player" then
            GryllsUnitFrames_updateHealth(arg1, Grylls_PlayerFrame)
        elseif arg1 == "pet" then
            GryllsUnitFrames_updateHealth(arg1, Grylls_PetFrame)
        elseif arg1 == "target" then
            GryllsUnitFrames_updateHealth(arg1, Grylls_TargetFrame)
        elseif arg1 == "party1" then
            GryllsUnitFrames_updateHealth(arg1, Grylls_PartyMemberFrame1)
        elseif arg1 == "party2" then
            GryllsUnitFrames_updateHealth(arg1, Grylls_PartyMemberFrame2)
        elseif arg1 == "party3" then
            GryllsUnitFrames_updateHealth(arg1, Grylls_PartyMemberFrame3)
        elseif arg1 == "party4" then
            GryllsUnitFrames_updateHealth(arg1, Grylls_PartyMemberFrame4)
        end
    end

    if (event == "UNIT_MANA" or "UNIT_DISPLAYPOWER" or "UNIT_RAGE" or "UNIT_FOCUS" or "UNIT_ENERGY" or "UPDATE_SHAPESHIFT_FORMS" or "UNIT_MAXMANA" or "UNIT_MAXRAGE" or "UNIT_MAXENERGY" or "UNIT_MAXFOCUS") then      
        if arg1 == "player" then
            GryllsUnitFrames_updatePower(arg1, Grylls_PlayerFrame)
        elseif arg1 == "pet" then
            GryllsUnitFrames_updatePower(arg1, Grylls_PetFrame)
        elseif arg1 == "target" then
            GryllsUnitFrames_updatePower(arg1, Grylls_TargetFrame)
        elseif arg1 == "party1" then
            GryllsUnitFrames_updatePower(arg1, Grylls_PartyMemberFrame1)
        elseif arg1 == "party2" then
            GryllsUnitFrames_updatePower(arg1, Grylls_PartyMemberFrame2)
        elseif arg1 == "party3" then
            GryllsUnitFrames_updatePower(arg1, Grylls_PartyMemberFrame3)
        elseif arg1 == "party4" then
            GryllsUnitFrames_updatePower(arg1, Grylls_PartyMemberFrame4)
        end
    end
end

function GryllsUnitFrames_setPartyVisibility()
    if GryllsUnitFrames_Settings.party then
        for i=1, 4 do
            _G["Grylls_PartyMemberFrame"..i]:Show()
        end
    else
        for i=1, 4 do
            _G["Grylls_PartyMemberFrame"..i]:Hide()
        end
    end
end

function GryllsUnitFrames_updateUnitFrames()
    GryllsUnitFrames_colorName("player", PlayerFrame)
    GryllsUnitFrames_updateHealth("player", Grylls_PlayerFrame)
    GryllsUnitFrames_updatePower("player", Grylls_PlayerFrame)
    GryllsUnitFrames_colorName("pet", PetFrame)
    GryllsUnitFrames_updateHealth("pet", Grylls_PetFrame)
    GryllsUnitFrames_updatePower("pet", Grylls_PetFrame)
    GryllsUnitFrames_colorName("target", TargetFrame)
    GryllsUnitFrames_updateHealth("target", Grylls_TargetFrame)
    GryllsUnitFrames_updatePower("target", Grylls_TargetFrame)
    GryllsUnitFrames_updatePartyFrames()
end

function GryllsUnitFrames_updatePartyFrames()
    if GryllsUnitFrames_Settings.party then
        for i=1, GetNumPartyMembers() do
            local arg = "party"..i
            local frame = _G["Grylls_PartyMemberFrame"..i]
            local nameframe = _G["PartyMemberFrame"..i]
            GryllsUnitFrames_colorName(arg, nameframe)
            GryllsUnitFrames_updateHealth(arg, frame)
            GryllsUnitFrames_updatePower(arg, frame)
        end
    end
end

function GryllsUnitFrames_formatNum(num)    
    local function GryllsUnitFrames_shortNum(num)
        -- short number eg 10100 = 10.1k
        if num <= 999 then
            return num       
        elseif num >= 1000000 then
            return format("%.1f mil", floor(num/1000000))
        elseif num >= 1000 then
            return format("%.1fk", floor(num/1000))
        end
    end    

    local function GryllsUnitFrames_defaultNum(num)
     -- default format with commas eg 10000 = 10,000
        -- http://lua-users.org/wiki/FormattingNumbers
        local formatted = num
            while true do  
            formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
            if (k==0) then
                break
            end
        end
        return formatted
    end

    if GryllsUnitFrames_Settings.short then
        return GryllsUnitFrames_shortNum(num)
    else
        return GryllsUnitFrames_defaultNum(num)
    end
end

function GryllsUnitFrames_updateHealth(unit, frame)
    if UnitExists(unit) then
        if UnitIsDead(unit) then
            frame.health:SetTextColor(128/255, 128/255, 128/255) -- grey
            frame.health:SetText("Dead")            
        elseif UnitIsGhost(unit) then
            frame.health:SetTextColor(1,1,1) -- white
            frame.health:SetText("Ghost")
        else
            local health = UnitHealth(unit)
            local max_health = UnitHealthMax(unit)
            local percent = health / max_health

            if GryllsUnitFrames_Settings.colorhealth then
                -- color health text based on health
                if percent <= 0.2 then
                    frame.health:SetTextColor(255/255, 0/255, 0/255) -- red
                elseif percent <= 0.5 then
                    frame.health:SetTextColor(255/255, 128/255, 0/255) -- legendary orange
                elseif percent <= 0.75 then
                    frame.health:SetTextColor(230/255, 204/255, 128/255) -- artifact gold
                else
                    frame.health:SetTextColor(30/255, 255/255, 0/255) -- uncommon green
                end
            else
                frame.health:SetTextColor(255/255, 255/255, 255/255) -- white
            end

            local percent = floor(percent*100)

            -- format hp text
            -- Limitations: we can only get friendly HP values if target is in our party and we can't get enemy HP values without mobhealth
            if GryllsUnitFrames_Settings.value then
                if (unit == "target") and MobHealth3 then
                    frame.health:SetText(GryllsUnitFrames_formatNum(MobHealth3:GetUnitHealth("target")))
                else
                    frame.health:SetText(GryllsUnitFrames_formatNum(health))
                end
            elseif GryllsUnitFrames_Settings.percent then
                    frame.health:SetText(percent)
            elseif GryllsUnitFrames_Settings.both then
                if unit == "target" then              
                    if (unit == "target") and MobHealth3 then
                        frame.health:SetText(GryllsUnitFrames_formatNum(MobHealth3:GetUnitHealth("target")).." ("..percent..")")
                    else
                        frame.health:SetText(GryllsUnitFrames_formatNum(health))
                    end
                elseif unit == "party1" or "party2" or "party3" or "party4" then
                    frame.health:SetText(GryllsUnitFrames_formatNum(health).." ("..percent..")")
                end
            end
        end
    end
end

function GryllsUnitFrames_updatePower(unit, frame)
    if UnitExists(unit) then
        if UnitIsDeadOrGhost(unit) then
            frame.power:SetText("")
        else
            local mana = UnitMana(unit) -- returns values for mana/energy/rage
            local max_mana = UnitManaMax(unit)
            local percent = mana / max_mana
            local percent = floor(percent*100)
            if not (percent >= 0) then
                percent = 0
            end

            if GryllsUnitFrames_Settings.colorpower then        
                -- color power text based on power type
                local powerType = UnitPowerType(unit) -- 0 = mana, 1 = rage, 3 = energy
                if powerType == 0 then -- mana
                    frame.power:SetTextColor(0/255, 204/255, 255/255) -- Blizzard Blue
                elseif powerType == 1 then -- rage
                    frame.power:SetTextColor(255/255, 107/255, 107/255) -- light Red
                elseif powerType == 2 then -- focus
                    frame.power:SetTextColor(1, 0.5, 0.25)
                elseif powerType == 3 then -- energy
                    frame.power:SetTextColor(230/255, 204/255, 128/255) -- artifact gold
                end
            else
                frame.power:SetTextColor(255/255, 255/255, 255/255) -- white
            end

            -- format power text
            if GryllsUnitFrames_Settings.value then
                frame.power:SetText(GryllsUnitFrames_formatNum(mana))
            elseif GryllsUnitFrames_Settings.percent then
                frame.power:SetText(percent)
            elseif GryllsUnitFrames_Settings.both then
                frame.power:SetText(GryllsUnitFrames_formatNum(mana).." ("..percent..")")
            end
        end
    end
end

function GryllsUnitFrames_createFrames()
    local function GryllsUnitFrames_setFrame(frame, healthbar, manabar)
        frame:SetFrameStrata("LOW")
        frame:SetFrameLevel(4)
        local font, size, outline = "Fonts\\Skurri.TTF", 11, "OUTLINE"

        frame.health = frame:CreateFontString(nil, "LOW")        
        frame.health:ClearAllPoints()           

        frame.power = frame:CreateFontString(nil, "LOW")        
        frame.power:ClearAllPoints()

        if (frame == Grylls_PlayerFrame) or (frame == Grylls_TargetFrame) then
            local y = 0.5
            frame.health:SetPoint("CENTER", healthbar, "CENTER", 0, y)
            frame.power:SetPoint("CENTER", manabar, "CENTER", 0, y)   
        elseif (frame == Grylls_PetFrame) or (frame == Grylls_TargetofTargetFrame) then
            frame.health:SetPoint("CENTER", healthbar, "CENTER", 0, 0)
            frame.power:SetPoint("CENTER", manabar, "CENTER", 0, -2)
        else
            local y = 0.5
            frame.health:SetPoint("CENTER", healthbar, "CENTER", 0, y)
            frame.power:SetPoint("CENTER", manabar, "CENTER", 0, y)
        end
    end

    Grylls_PlayerFrame = CreateFrame("Frame", "Grylls_PlayerFrame", PlayerFrame)
    GryllsUnitFrames_setFrame(Grylls_PlayerFrame, PlayerFrameHealthBar, PlayerFrameManaBar)

    Grylls_PetFrame = CreateFrame("Frame", "Grylls_PetFrame", PetFrame)
    GryllsUnitFrames_setFrame(Grylls_PetFrame, PetFrameHealthBar, PetFrameManaBar)
    
    Grylls_TargetFrame = CreateFrame("Frame", "Grylls_TargetFrame", TargetFrame)
    GryllsUnitFrames_setFrame(Grylls_TargetFrame, TargetFrameHealthBar, TargetFrameManaBar)

    Grylls_TargetofTargetFrame = CreateFrame("Frame", "Grylls_TargetofTargetFrame", TargetofTargetFrame)
    GryllsUnitFrames_setFrame(Grylls_TargetofTargetFrame, TargetofTargetHealthBar, TargetofTargetManaBar)

    Grylls_PartyMemberFrame1 = CreateFrame("Frame", "Grylls_PartyMemberFrame1", PartyMemberFrame1)
    GryllsUnitFrames_setFrame(Grylls_PartyMemberFrame1, PartyMemberFrame1HealthBar, PartyMemberFrame1ManaBar)

    Grylls_PartyMemberFrame2 = CreateFrame("Frame", "Grylls_PartyMemberFrame2", PartyMemberFrame2)
    GryllsUnitFrames_setFrame(Grylls_PartyMemberFrame2, PartyMemberFrame2HealthBar, PartyMemberFrame2ManaBar)

    Grylls_PartyMemberFrame3 = CreateFrame("Frame", "Grylls_PartyMemberFrame3", PartyMemberFrame3)
    GryllsUnitFrames_setFrame(Grylls_PartyMemberFrame3, PartyMemberFrame3HealthBar, PartyMemberFrame3ManaBar)

    Grylls_PartyMemberFrame4 = CreateFrame("Frame", "Grylls_PartyMemberFrame4", PartyMemberFrame4)
    GryllsUnitFrames_setFrame(Grylls_PartyMemberFrame4, PartyMemberFrame4HealthBar, PartyMemberFrame4ManaBar)
end

function GryllsUnitFrames_setup()
    TargetFrameNameBackground:SetAlpha(.5)
    TargetofTargetDeadText:SetText("")
end

function GryllsUnitFrames_colorName(unit, frame)
    if UnitExists(unit) then
        local thename -- implicit thename = nil

        -- set thename to the frame name
        if (unit == "targettarget") then
            thename = TargetofTargetName
        elseif (unit == "pet") then
            thename = PetName
        else
            thename = frame.name
        end
        
        if GryllsUnitFrames_Settings.colorname then
            if UnitIsPlayer(unit) then
                -- color by class
                local _, class = UnitClass(unit)
                local color = RAID_CLASS_COLORS[class]
                thename:SetTextColor(color.r, color.g, color.b)
            else
                -- not a player
                local creatureType = UnitCreatureType(unit)
                local friend = UnitIsFriend("player", unit)

                if friend then
                    if creatureType == "Demon" then -- friendly Warlock pet
                        thename:SetTextColor(148/255, 130/255, 201/255)
                    elseif creatureType == "Beast" then -- friendly Hunter pet
                        thename:SetTextColor(171/255, 212/255, 115/255)
                    else
                        thename:SetTextColor(255/255, 210/255, 0/255) -- default color
                    end
                else
                    -- enemy
                    -- color name by reaction
                    local r,g,b = GameTooltip_UnitColor(unit) 
                    thename:SetTextColor(r, g, b)
                end
            end
        else 
            -- not GryllsUnitFrames_Settings.colorname            
            thename:SetTextColor(255/255, 210/255, 0/255) -- default color
        end
        
    end
end

function GryllsUnitFrames_setValueFont(frame)    
    local font, size, outline
    if IsAddOnLoaded("GryllsFont") then
        font, size, outline = "Interface\\Addons\\GryllsFont\\Fonts\\unit.TTF", GryllsUnitFrames_Settings.valuesize, "OUTLINE"
    else        
        font, size, outline = "Fonts\\"..GryllsUnitFrames_Settings.valuefont..".TTF", GryllsUnitFrames_Settings.valuesize, "OUTLINE"
    end
    
    frame.health:SetFont(font, size, outline)
    frame.power:SetFont(font, size, outline)
end

function GryllsUnitFrames_updateValueFont()
    GryllsUnitFrames_setValueFont(Grylls_PlayerFrame)
    GryllsUnitFrames_setValueFont(Grylls_PetFrame)
    GryllsUnitFrames_setValueFont(Grylls_TargetFrame)
    GryllsUnitFrames_setValueFont(Grylls_TargetofTargetFrame)
    if GryllsUnitFrames_Settings.party then  
        for i=1, 4 do
            local frame = _G["Grylls_PartyMemberFrame"..i]
            GryllsUnitFrames_setValueFont(frame)
        end
    end    
end

function GryllsUnitFrames_updateNameFont()
    local font, size, outline
    if IsAddOnLoaded("GryllsFont") then
        font, size, outline = "Interface\\Addons\\GryllsFont\\Fonts\\unit.TTF", GryllsUnitFrames_Settings.valuesize, "OUTLINE"
    else        
        font, size, outline = "Fonts\\"..GryllsUnitFrames_Settings.namefont..".TTF", GryllsUnitFrames_Settings.namesize, "OUTLINE"
    end

    PlayerFrame.name:SetFont(font, size, outline)
    TargetFrame.name:SetFont(font, size, outline)
    TargetofTargetName:SetFont(font, size, outline)
    PetName:SetFont(font, size, outline)
    for i=1, 4 do
        local frame = _G["PartyMemberFrame"..i]        
        frame.name:SetFont(font, size, outline)
    end
end

function GryllsUnitFrames_combat()
    if GryllsUnitFrames_Settings.combat then
        PlayerFrame:RegisterEvent("UNIT_COMBAT")
        PetFrame:RegisterEvent("UNIT_COMBAT")        
    else
        PlayerFrame:UnregisterEvent("UNIT_COMBAT")
        PetFrame:UnregisterEvent("UNIT_COMBAT")
    end
end

function GryllsUnitFrames_hideStatusBarText()
    local hideFrame = CreateFrame("Frame")
    PlayerFrameHealthBarText:SetParent(hideFrame)    
    PlayerFrameManaBarText:SetParent(hideFrame)
    PetFrameHealthBarText:SetParent(hideFrame)    
    PetFrameManaBarText:SetParent(hideFrame)
    TargetDeadText:SetParent(hideFrame)
    hideFrame:Hide()
end

function GryllsUnitFrames_tot()
    local function updateHealth()
        GryllsUnitFrames_updateHealth("targettarget", Grylls_TargetofTargetFrame)        

        if GryllsUnitFrames_Settings.colorname then
            if totName ~= UnitName("targettarget") then -- does not run multiple times for the same target
                totName = UnitName("targettarget")
                GryllsUnitFrames_colorName("targettarget")
            end
        end
    end

    local function updatePower()
        GryllsUnitFrames_updatePower("targettarget", Grylls_TargetofTargetFrame)
    end

    local totName = nil
    TargetofTargetHealthBar:SetScript("OnValueChanged", updateHealth)
    TargetofTargetManaBar:SetScript("OnValueChanged", updatePower)
end