local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- if not LocalPlayer:IsInGroup(3418971) then
-- 	return warn('Plugin EmberUtilities could not be loaded. Reason: "You are not in the Fed Studios group"')
-- end

local EmberUtilities = script.Parent

local Fusion = require(EmberUtilities.Fusion)
-- .Value, .Computed, .New
local OnEvent = Fusion.OnEvent
local Value = Fusion.Value
local Out = Fusion.Out
local Children = Fusion.Children
local ForValues = Fusion.ForValues

local FusionPlugin = require(EmberUtilities.Packages["fusion-plugin"])(Fusion, plugin)
local Toolbar = FusionPlugin.Toolbar
local ToolbarButton = FusionPlugin.ToolbarButton

local LightingButton = require(script.Parent.Buttons.Lighting)(Fusion:: any, FusionPlugin:: any, EmberUtilities:: any)
local DoorButton = require(script.Parent.Buttons.DoorValidator)(Fusion:: any, FusionPlugin:: any, EmberUtilities:: any)

Toolbar "EmberUtilities" {
	ToolbarButton "Lighting" {
		Active = LightingButton.ButtonProperties.Active,
		ClickableWhenViewportHidden = LightingButton.ButtonProperties.ClickableWhenViewportHidden,
		[OnEvent "Click"] = function()
			LightingButton:ToggleWidget()
		end,

		-- NON-REACTIVE
		Text = LightingButton.ButtonProperties.Text,
		Tooltip = LightingButton.ButtonProperties.Tooltip,
		Icon = LightingButton.ButtonProperties.Icon,
	},

    ToolbarButton "Door Validator" {
		Active = DoorButton.ButtonProperties.Active,
		ClickableWhenViewportHidden = DoorButton.ButtonProperties.ClickableWhenViewportHidden,
		[OnEvent "Click"] = function()
			DoorButton:ToggleWidget()
		end,

		-- NON-REACTIVE
		Text = DoorButton.ButtonProperties.Text,
		Tooltip = DoorButton.ButtonProperties.Tooltip,
		Icon = DoorButton.ButtonProperties.Icon,
	},
}

game:GetService("ChangeHistoryService"):SetEnabled(true)