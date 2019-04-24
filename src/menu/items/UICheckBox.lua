---@type table
local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = 38 },
    Text = { X = 8, Y = 3, Scale = 0.33 },
    LeftBadge = { Y = -2, Width = 40, Height = 40 },
    RightBadge = { X = 385, Y = -2, Width = 40, Height = 40 },
    RightText = { X = 420, Y = 4, Scale = 0.35 },
    SelectedSprite = { Dictionary = "commonmenu", Texture = "gradient_nav", Y = 0, Width = 431, Height = 38 },
}

---@type table
local SettingsCheckbox = {
    Dictionary = "commonmenu", Textures = {
        "shop_box_blankb", -- 1
        "shop_box_tickb", -- 2
        "shop_box_blank", -- 3
        "shop_box_tick", -- 4
        "shop_box_crossb", -- 5
        "shop_box_cross", -- 6
    },
    X = 380, Y = -6, Width = 50, Height = 50
}

RageUI.CheckboxStyle = {
    Tick = 1,
    Cross = 2
}

---StyleCheckBox
---@param Selected number
---@param Checked boolean
---@param Box number
---@param BoxSelect number
---@return nil
local function StyleCheckBox(Selected, Checked, Box, BoxSelect)

    ---@type table
    local CurrentMenu = RageUI.CurrentMenu;

    if Selected then
        if Checked then
            RageUI.RenderSprite(SettingsCheckbox.Dictionary, SettingsCheckbox.Textures[Box], CurrentMenu.X + SettingsCheckbox.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsCheckbox.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsCheckbox.Width, SettingsCheckbox.Height)
        else
            RageUI.RenderSprite(SettingsCheckbox.Dictionary, SettingsCheckbox.Textures[1], CurrentMenu.X + SettingsCheckbox.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsCheckbox.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsCheckbox.Width, SettingsCheckbox.Height)
        end
    else
        if Checked then
            RageUI.RenderSprite(SettingsCheckbox.Dictionary, SettingsCheckbox.Textures[BoxSelect], CurrentMenu.X + SettingsCheckbox.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsCheckbox.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsCheckbox.Width, SettingsCheckbox.Height)
        else
            RageUI.RenderSprite(SettingsCheckbox.Dictionary, SettingsCheckbox.Textures[3], CurrentMenu.X + SettingsCheckbox.X + CurrentMenu.WidthOffset, CurrentMenu.Y + SettingsCheckbox.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsCheckbox.Width, SettingsCheckbox.Height)
        end
    end
end

---CheckBoxLockBadgeColor
---@param Selected boolean
---@return table
local function CheckBoxLockBadgeColor(Selected)
    if Selected then
        return 0, 0, 0, 255
    else
        return 163, 159, 148, 255
    end
end

---Checkbox
---@param Label string
---@param Description string
---@param Checked boolean
---@param Callback function
---@return nil
---@public
function RageUI.Checkbox(Label, Description, Checked, Style, Callback)

    ---@type table
    local CurrentMenu = RageUI.CurrentMenu;

    if CurrentMenu ~= nil then
        if CurrentMenu() then

            ---@type number
            local Option = RageUI.Options + 1

            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then

                ---@type number
                local Selected = CurrentMenu.Index == Option

                ItemsWrapper.ItemsSafeZone(CurrentMenu)

                ---@type boolean
                local Hovered = ItemsWrapper.ItemsMouseBounds(CurrentMenu, Selected, Option, SettingsButton);

                if Selected then
                    RageUI.RenderSprite(SettingsButton.SelectedSprite.Dictionary, SettingsButton.SelectedSprite.Texture, CurrentMenu.X, CurrentMenu.Y + SettingsButton.SelectedSprite.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.SelectedSprite.Width + CurrentMenu.WidthOffset, SettingsButton.SelectedSprite.Height)
                end

                if type(Style) == "table" then
                    if Style.Enabled == true or Style.Enabled == nil then
                        if Selected then
                            RageUI.RenderText(Label, CurrentMenu.X + SettingsButton.Text.X, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.Text.Scale, 0, 0, 0, 255)
                        else
                            RageUI.RenderText(Label, CurrentMenu.X + SettingsButton.Text.X, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.Text.Scale, 245, 245, 245, 255)
                        end
                    else
                        ---@type table
                        local LeftBadge = RageUI.BadgeStyle.Lock

                        ---@type number
                        local LeftBadgeOffset = ((LeftBadge == RageUI.BadgeStyle.None or tonumber(LeftBadge) == nil) and 0 or 27)

                        if Selected then
                            RageUI.RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.Text.Scale, 0, 0, 0, 255)
                        else
                            RageUI.RenderText(Label, CurrentMenu.X + SettingsButton.Text.X + LeftBadgeOffset, CurrentMenu.Y + SettingsButton.Text.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 0, SettingsButton.Text.Scale, 163, 159, 148, 255)
                        end
                        if LeftBadge ~= RageUI.BadgeStyle.None and tonumber(LeftBadge) ~= nil then
                            RageUI.RenderSprite(RageUI.GetBadgeDictionary(LeftBadge, Selected), RageUI.GetBadgeTexture(LeftBadge, Selected), CurrentMenu.X, CurrentMenu.Y + SettingsButton.LeftBadge.Y + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, SettingsButton.LeftBadge.Width, SettingsButton.LeftBadge.Height, nil, CheckBoxLockBadgeColor(Selected))
                        end
                    end

                    if Style.Style ~= nil then
                        if Style.Style == RageUI.CheckboxStyle.Tick then
                            StyleCheckBox(Selected, Checked, 2, 4)
                        elseif Style.Style == RageUI.CheckboxStyle.Cross then
                            StyleCheckBox(Selected, Checked, 5, 6)
                        else
                            StyleCheckBox(Selected, Checked, 2, 4)
                        end
                    else
                        StyleCheckBox(Selected, Checked, 2, 4)
                    end

                    if Selected and (CurrentMenu.Controls.Select.Active or (Hovered and CurrentMenu.Controls.Click.Active)) and (Style.Enabled == true or Style.Enabled == nil) then
                        RageUI.PlaySound(RageUI.Settings.Audio.Library, RageUI.Settings.Audio.Select)
                        Checked = not Checked
                    end

                    if Selected and (CurrentMenu.Controls.Select.Active or (Hovered and CurrentMenu.Controls.Click.Active)) and (Style.Enabled == false) then
                        RageUI.PlaySound(RageUI.Settings.Audio.Library, RageUI.Settings.Audio.Error)
                        Checked = false
                    end

                else
                    error("UICheckBox Style is not a `table`")
                end

                RageUI.ItemOffset = RageUI.ItemOffset + SettingsButton.Rectangle.Height

                ItemsWrapper.ItemsDescription(CurrentMenu, Description, Selected)

                Callback(Hovered, Selected, ((CurrentMenu.Controls.Select.Active or (Hovered and CurrentMenu.Controls.Click.Active)) and Selected), Checked)
            end
            RageUI.Options = RageUI.Options + 1
        end
    end
end