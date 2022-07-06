local TWPB = CreateFrame("Frame")

TWPB:RegisterEvent("ADDON_LOADED")

TWPB:SetScript("OnEvent", function()
    if event then
        if event == "ADDON_LOADED" and arg1 == 'TWPowerBar' then
            if not TWPB_HP then TWPB_HP = 1 end
            if not TWPB_P then TWPB_P = 1 end
            if TWPB_HP == 1 then
                getglobal("TWPowerBarHPText"):Show()
            else
                getglobal("TWPowerBarHPText"):Hide()
            end
            if TWPB_P == 1 then
                getglobal("TWPowerBarPowerText"):Show()
            else
                getglobal("TWPowerBarPowerText"):Hide()
            end
        end
    end
end)
--TWPB_HP

SLASH_TWPB1 = "/twpb"
SlashCmdList["TWPB"] = function(cmd)
    if cmd then
        if string.sub(cmd, 1, 3) == 'hp' then
            if TWPB_HP == 1 then
                TWPB_HP = 0
                DEFAULT_CHAT_FRAME:AddMessage('TWPowerBar: Hp text is now hidden');
                getglobal("TWPowerBarHPText"):Hide()
            else
                TWPB_HP = 1
                DEFAULT_CHAT_FRAME:AddMessage('TWPowerBar: Hp text is now visible');
                getglobal("TWPowerBarHPText"):Show()
            end
        end
        if string.sub(cmd, 1, 5) == 'power' then
            if TWPB_P == 1 then
                TWPB_P = 0
                DEFAULT_CHAT_FRAME:AddMessage('TWPowerBar: Power text is now hidden');
                getglobal("TWPowerBarPowerText"):Hide()
            else
                TWPB_P = 1
                DEFAULT_CHAT_FRAME:AddMessage('TWPowerBar: Power text is now visible');
                getglobal("TWPowerBarPowerText"):Show()
            end
        end
    end
end


function updatePowerBar()

    local power = UnitMana('player')

    getglobal("TWPowerBarHPText"):SetText(UnitHealth('player') .. '/' .. UnitHealthMax('player'))

    getglobal('TWPowerBarPower'):SetWidth(power * 200 / UnitManaMax('player'))
    getglobal('TWPowerBarHP'):SetWidth(UnitHealth('player') * 200 / UnitHealthMax('player'))
    getglobal('TWPowerBarHP'):SetBackdropColor(0.06, 1, 0.06, 1)

    if UnitPowerType('player') == 0 then --mana
        getglobal('TWPowerBarPower'):SetBackdropColor(0.06, 0.06, 1, 1)
        getglobal('TWPowerBarBackground'):Show()
        getglobal('TWPowerBarPower'):Show()
        getglobal('TWPowerBarPowerText'):SetText(power .. '/' .. UnitManaMax('player'))
    end

    if UnitPowerType('player') == 1 then --rage
        getglobal('TWPowerBarPower'):SetBackdropColor(1, 0.06, 0.06, 1)
        if power > 0 then
            getglobal('TWPowerBarBackground'):Show()
            getglobal('TWPowerBarPower'):Show()
            getglobal('TWPowerBarPowerText'):SetText(power)
        else
            getglobal('TWPowerBarBackground'):Hide()
            getglobal('TWPowerBarPower'):Hide()
        end
    end

    if UnitPowerType('player') == 3 then --energy

        getglobal('TWPowerBarPower'):SetBackdropColor(1, 0.96, 0.41, 1)
        getglobal('TWPowerBarBackground'):Show()
        getglobal('TWPowerBarPower'):Show()
        getglobal('TWPowerBarPowerText'):SetText(power)
    end
end

