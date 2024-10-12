local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")

local Fusion = require(script.Parent.Parent.Fusion)

local New = Fusion.New
local OnEvent = Fusion.OnEvent
local Children = Fusion.Children

local ColorDB = require(script.Parent.ColorDB)

type Properties = {
	LayoutOrder: number?,
	Size: UDim2,
	PlaceholderText: Fusion.CanBeState<string> | string,
	Text: Fusion.CanBeState<string> | string,
	TextColor: Color3?,
	KeepText: boolean,
}

local function WindowTextBox(properties: Properties)
	local NewProperties = {
		LayoutOrder = properties.LayoutOrder or 1,

		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		Size = properties.Size or UDim2.new(0, 150, 0, 35),

		Text = properties.Text,
		PlaceholderText = properties.PlaceholderText,
		-- TextScaled = true,
		TextSize = 16,
		TextColor3 = properties.TextColor or ColorDB.Solid.DefaultTextColor,
		PlaceholderColor3 = properties.TextColor or ColorDB.Solid.DefaultPlaceholderColor,
		Font = Enum.Font.MontserratBold,
		ClearTextOnFocus = not properties.KeepText,

		BackgroundTransparency = 0,
		BackgroundColor3 = ColorDB.Solid.WindowBackground,

		[Children] = {
			New "UIPadding" {
				PaddingTop = UDim.new(0, 5),
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 5),
			},

			New "UICorner" {
				CornerRadius = UDim.new(0.15, 0),
			},
		} :: any,
	}

	return New "TextBox"(NewProperties)
end

return WindowTextBox
