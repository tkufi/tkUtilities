local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")

local LightingModules = {}

local Effects = {
	"Atmosphere",
	"Sky",
	"BloomEffect",
	"DepthOfFieldEffect",
	"SunRaysEffect",
	"ColorCorrectionEffect",
	"BlurEffect",
}

function ClearLighting()
	game:GetService("ChangeHistoryService"):SetWaypoint("Delete Stuff")
	for _, v in pairs(Lighting:GetChildren()) do
		if table.find(Effects, v.ClassName) then
			Debris:AddItem(v, 0.1)
		end
	end
end

function CreateClassWithData(ClassName, Data): Instance?
	local obj

	pcall(function()
		obj = Instance.new(ClassName)
		for i, v in pairs(Data) do
			obj[i] = v
		end
	end)

	return obj
end

function HandleLighting(Type: string)
	game:GetService("ChangeHistoryService"):SetWaypoint(Type .. " Lighting")

	for Index, Data: any in pairs(LightingModules[Type]) do
		if Index == "Lighting" then
			-- Assign values to the Lighting Class
			for i, v in pairs(Data) do
				Lighting[i] = v
			end
		else
			local instance = CreateClassWithData(Index, Data)
			if not instance then
				continue
			end
			instance.Parent = Lighting
		end
	end
end

return function(Fusion: any, FusionPlugin: any, EmberUtilities: any)
	local ButtonConfig = {}

	local Styles = EmberUtilities.Styles
	local ColorDB = require(Styles.ColorDB)
	local WindowButton = require(Styles.WindowButton)

	LightingModules.Morning = require(EmberUtilities.Resources.Morning)
	LightingModules.Afternoon = require(EmberUtilities.Resources.Afternoon)
	LightingModules.Evening = require(EmberUtilities.Resources.Evening)

	--
	local OnEvent = Fusion.OnEvent
	local Value = Fusion.Value
	local Out = Fusion.Out
	local Children = Fusion.Children
	local New = Fusion.New

	local DockWidget = FusionPlugin.DockWidget
	--

	local IsOpen = Value(false)

	function ButtonConfig:ToggleWidget()
		IsOpen:set(not IsOpen:get())
	end

	DockWidget "LightingWidget" {
		Title = "EU - Lighting Controls",
		Enabled = IsOpen,
		[Out "Enabled"] = IsOpen,
		[Children] = {
			New "UIPadding" {
				PaddingBottom = UDim.new(0, 5),
				PaddingLeft = UDim.new(0, 5),
				PaddingRight = UDim.new(0, 5),
				PaddingTop = UDim.new(0, 5),
			},

			New "UIListLayout" {
				Padding = UDim.new(0, 5),
			},

			WindowButton {
				Size = UDim2.new(1, 0, 0, 35),
				Text = "Clear All Lighting",
				OnClick = function()
					ClearLighting()
					print("Clearing the Lighting")
				end,
			},

			WindowButton {
				Size = UDim2.new(1, 0, 0, 35),
				Text = "Morning Lighting",
				OnClick = function()
					HandleLighting("Morning")
					print('Set the current lighting theme to "Morning"!')
				end,
			},

			WindowButton {
				Size = UDim2.new(1, 0, 0, 35),
				Text = "Afternoon Lighting",
				OnClick = function()
					HandleLighting("Afternoon")
					print('Set the current lighting theme to "Afternoon"!')
				end,
			},

			WindowButton {
				Size = UDim2.new(1, 0, 0, 35),
				Text = "Evening Lighting",
				OnClick = function()
					HandleLighting("Evening")
					print('Set the current lighting theme to "Evening"!')
				end,
			},
		},

		-- NON-REACTIVE
		Size = Vector2.new(250, 300),
		MinimumSize = Vector2.new(300, 400), --Defaults to .Size
	}

	ButtonConfig.ButtonProperties = {
		Active = true, --whether the button is shaded gray
		ClickableWhenViewportHidden = true,

		-- NON-REACTIVE
		Text = "Lighting Configuration",
		Tooltip = "Open example plugin's settings",
		Icon = "rbxassetid://130185424523099",
	}
	return ButtonConfig
end
