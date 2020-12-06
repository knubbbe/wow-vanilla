-- GryllsGlow
-- Creates oGlow like item border colors for the character frame

function GryllsGlow_OnLoad()
    this:RegisterEvent("PLAYER_ENTERING_WORLD")
    this:RegisterEvent("UNIT_INVENTORY_CHANGED")
    this:RegisterEvent("UPDATE_INVENTORY_ALERTS")
    DEFAULT_CHAT_FRAME:AddMessage("GryllsGlow loaded")
end

function GryllsGlow_OnEvent(event)
    if event == "PLAYER_ENTERING_WORLD" then
        GryllsGlow_createBorders()
        GryllsGlow_setBorders()
        GryllsGlow_colorBorders()
    end

    if event == "UNIT_INVENTORY_CHANGED" or "UPDATE_INVENTORY_ALERTS" then
        GryllsGlow_colorBorders()
    end
end

function GryllsGlow_colorBorders()
    for _, frame in pairs(GryllsGlow.Slots) do
        local slotName = string.sub(frame:GetName(), 8) -- Removes "Grylls_" from name
        local slotId = GetInventorySlotInfo(slotName) -- Return numeric slotId for the slotName
        -- check if the item in the slotID has a quality
        local quality = GetInventoryItemQuality("player", slotId) -- Return the quality of an inventory item or nil if the slot is empty
        if quality then
            frame:Hide()
            local r, g, b = GetItemQualityColor(quality) -- Returns RGB color codes for an item quality
            frame:SetBackdropBorderColor(r, g, b, 1) -- set color of slot
            frame:Show()
        else
            frame:Hide()
        end
    end
end

function GryllsGlow_setBorders()
    for _, frame in pairs(GryllsGlow.Slots) do
        frame:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
                        tile = true, edgeSize = 20,
                        insets = { left = 2, right = 2, top = 2, bottom = 2 }})
        frame:ClearAllPoints()
        local p = 4
        frame:SetPoint("TOPLEFT", frame:GetParent(), "TOPLEFT", -p, p)
        frame:SetPoint("BOTTOMRIGHT", frame:GetParent(), "BOTTOMRIGHT", p, -p)
    end
end

function GryllsGlow_createBorders()
    GryllsGlow = CreateFrame("Frame", "GryllsGlow")
    GryllsGlow.Slots = {}
    GryllsGlow.Slots.HeadSlot = CreateFrame("Frame", "Grylls_HeadSlot", CharacterHeadSlot)
    GryllsGlow.Slots.NeckSlot = CreateFrame("Frame", "Grylls_NeckSlot", CharacterNeckSlot)
    GryllsGlow.Slots.ShoulderSlot = CreateFrame("Frame", "Grylls_ShoulderSlot", CharacterShoulderSlot)
    GryllsGlow.Slots.BackSlot = CreateFrame("Frame", "Grylls_BackSlot", CharacterBackSlot)
    GryllsGlow.Slots.ChestSlot = CreateFrame("Frame", "Grylls_ChestSlot", CharacterChestSlot)
    GryllsGlow.Slots.ShirtSlot = CreateFrame("Frame", "Grylls_ShirtSlot", CharacterShirtSlot)
    GryllsGlow.Slots.TabardSlot = CreateFrame("Frame", "Grylls_TabardSlot", CharacterTabardSlot)
    GryllsGlow.Slots.WristSlot = CreateFrame("Frame", "Grylls_WristSlot", CharacterWristSlot)
    GryllsGlow.Slots.MainHandSlot = CreateFrame("Frame", "Grylls_MainHandSlot", CharacterMainHandSlot)
    GryllsGlow.Slots.SecondaryHandSlot = CreateFrame("Frame", "Grylls_SecondaryHandSlot", CharacterSecondaryHandSlot)
    GryllsGlow.Slots.RangedSlot = CreateFrame("Frame", "Grylls_RangedSlot", CharacterRangedSlot)
    GryllsGlow.Slots.HandsSlot = CreateFrame("Frame", "Grylls_HandsSlot", CharacterHandsSlot)
    GryllsGlow.Slots.WaistSlot = CreateFrame("Frame", "Grylls_WaistSlot", CharacterWaistSlot)
    GryllsGlow.Slots.LegsSlot = CreateFrame("Frame", "Grylls_LegsSlot", CharacterLegsSlot)
    GryllsGlow.Slots.FeetSlot = CreateFrame("Frame", "Grylls_FeetSlot", CharacterFeetSlot)
    GryllsGlow.Slots.Finger0Slot = CreateFrame("Frame", "Grylls_Finger0Slot", CharacterFinger0Slot)
    GryllsGlow.Slots.Finger1Slot = CreateFrame("Frame", "Grylls_Finger1Slot", CharacterFinger1Slot)
    GryllsGlow.Slots.Trinket0Slot = CreateFrame("Frame", "Grylls_Trinket0Slot", CharacterTrinket0Slot)
    GryllsGlow.Slots.Trinket1Slot = CreateFrame("Frame", "Grylls_Trinket1Slot", CharacterTrinket1Slot)
end