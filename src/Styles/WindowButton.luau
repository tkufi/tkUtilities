local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(script.Parent.Parent.Fusion)

local New = Fusion.New
local OnEvent = Fusion.OnEvent
local Children = Fusion.Children

local ColorDB = require(script.Parent.ColorDB)

type Properties = {
	LayoutOrder: number?,
	AutoButtonColor: boolean?,
	Color: Fusion.CanBeState<any> | any?,
	Transparency: number?,
	TextColor: Color3?,
	Text: Fusion.CanBeState<string> | string,
	Disabled: Fusion.CanBeState<boolean> | boolean?,
	OnClick: (() -> ())?,
	Size: UDim2,
}

local function WindowButton(properties: Properties)
	local NewProperties = {
		LayoutOrder = properties.LayoutOrder or 1,
		AutoButtonColor = properties.AutoButtonColor or false,
		BackgroundColor3 = Color3.fromRGB(178, 187, 204),
		BackgroundTransparency = properties.Transparency,

		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		Size = properties.Size or UDim2.new(0, 150, 0, 35),
		Text = "",

		[OnEvent "Activated"] = properties.OnClick or function()
			warn("No button callback set!")
		end,

		[Children] = {
			New "UIPadding" {
				PaddingTop = UDim.new(0, 5),
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
				PaddingBottom = UDim.new(0, 5),
			},

			New "UIGradient" {
				Color = properties.Color or ColorDB.Sequences.GreenButton,
				Rotation = 90,
			},

			New "TextLabel" {
				Text = properties.Text,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Font = Enum.Font.MontserratBold,
				Size = UDim2.new(1, 0, 0.5, 0),
				BackgroundTransparency = 1,
				TextScaled = true,
				TextColor3 = properties.TextColor or ColorDB.Solid.DefaultTextColor,
			},

			New "UICorner" {
				CornerRadius = UDim.new(0.15, 0),
			},
		} :: any,
	}

	local IsDisabled = false

	if typeof(properties.Disabled) == "table" and properties.Disabled.type == "State" then
		IsDisabled = properties.Disabled:get()
	elseif typeof(properties.Disabled) == "boolean" then
		IsDisabled = properties.Disabled
	end

	if IsDisabled then
		NewProperties.BackgroundColor3 = ColorDB.DisabledButton
	end

	return New "TextButton"(NewProperties)
end

return WindowButton
