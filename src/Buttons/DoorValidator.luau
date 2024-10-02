local CollectionService = game:GetService("CollectionService")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")
local Selection = game:GetService("Selection")

local TrackedHighlights = {}

function EnableHighlights(DoorModel: Model?)
	if DoorModel then
		if MakeHighlightRed(DoorModel) then
			return
		end

		local Highlight = Instance.new("Highlight")
		Highlight.Adornee = DoorModel
		Highlight.Parent = CoreGui
		table.insert(TrackedHighlights, Highlight)
		return
	end

	for _, DoorModel in pairs(CollectionService:GetTagged("DoorModel")) do
		if MakeHighlightRed(DoorModel) then
			continue
		end

		local Highlight = Instance.new("Highlight")
		Highlight.Adornee = DoorModel
		Highlight.Parent = CoreGui
		table.insert(TrackedHighlights, Highlight)
	end
end

function DisableHighlights()
	for _, v in pairs(TrackedHighlights) do
		Debris:AddItem(v, 0)
	end
	TrackedHighlights = {}
end

function MakeHighlightGreen(DoorModel)
	for _, highlight: any in pairs(TrackedHighlights) do
		if highlight.Adornee == DoorModel then
			highlight.FillColor = Color3.new(0, 1, 0)
			return true
		end
	end
	return false
end

function MakeHighlightRed(DoorModel)
	for _, highlight: any in pairs(TrackedHighlights) do
		if highlight.Adornee == DoorModel then
			highlight.FillColor = Color3.new(1, 0, 0)
			return true
		end
	end
	return false
end

function ValidateDoor(DoorFolder: Folder & { Parent: Model }): boolean
	if not DoorFolder:IsA("Folder") then
		return false
	end

	DoorFolder.Parent:AddTag("DoorModel")

	local DoorWeld = DoorFolder:FindFirstChild("DoorWeld", true) :: BasePart?
	if not DoorWeld then
		return false
	end

	local Hinge = DoorFolder:FindFirstChild("Hinge", true) :: BasePart?
	if not Hinge then
		return false
	end

	if not Hinge:FindFirstChildOfClass("Motor6D") then
		warn(`{DoorFolder:GetFullName()} does not have a Motor6D within the hinge.`)
		return false
	end

	local WholeDoor = DoorFolder:FindFirstChild("WholeDoor") :: BasePart
	if not WholeDoor then
		return false
	end

	local Handle = WholeDoor:FindFirstChild("Handle") :: BasePart
	if not Handle then
		return false
	end

	local DoorParts = {}
	for _, v in pairs(WholeDoor:GetDescendants()) do
		if not v:IsA("BasePart") then
			continue
		end

		table.insert(DoorParts, v)
	end

	local weldPartPos = table.find(DoorParts, DoorWeld)
	if weldPartPos then
		table.remove(DoorParts, weldPartPos)
	end

	for _, v in pairs(DoorWeld:GetChildren()) do
		if (not v:IsA("Weld")) and (not v:IsA("WeldConstraint")) then
			continue
		end

		local tablePos = table.find(DoorParts, v.Part0 :: any) or table.find(DoorParts, v.Part1 :: any)
		if tablePos then
			table.remove(DoorParts, tablePos)
		end
	end

	for _, v in pairs(DoorParts) do
		local WeldConstraint = Instance.new("WeldConstraint")
		WeldConstraint.Parent = DoorWeld
		WeldConstraint.Part0 = DoorWeld
		WeldConstraint.Part1 = v
		WeldConstraint.Name = v.Name
	end

	return true
end

return function(Fusion: any, FusionPlugin: any, EmberUtilities: any)
	local ButtonConfig = {}

	local Styles = EmberUtilities.Styles
	local WindowButton = require(Styles.WindowButton)

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

		if IsOpen:get() then
			EnableHighlights()
		else
			DisableHighlights()
		end
	end

	local Widget = DockWidget "DoorWidget" {
		Title = "EU - Door Validation",
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
				Text = "Validate Selected Door(s)",
				OnClick = function()
					for _, v: any in pairs(Selection:Get()) do
						if ValidateDoor(v) then
							MakeHighlightGreen(v.Parent)
							print(`"{v:GetFullName()}" has passed validation`)
							continue
						end

						MakeHighlightRed(v)
						warn(`"{v:GetFullName()}" has failed validation`)
					end
				end,
			},
		},

		-- NON-REACTIVE
		Size = Vector2.new(250, 300),
		MinimumSize = Vector2.new(300, 400), --Defaults to .Size
	}

	Widget:GetPropertyChangedSignal("Enabled"):Connect(function()
		if not Widget.Enabled then
			DisableHighlights()
		end
	end)

	CollectionService:GetInstanceAddedSignal("DoorModel"):Connect(function(DoorModel)
		if Widget.Enabled then
			EnableHighlights(DoorModel :: Model)
		end
	end)

	ButtonConfig.ButtonProperties = {
		Active = true, --whether the button is shaded gray
		ClickableWhenViewportHidden = true,

		-- NON-REACTIVE
		Text = "Door Validator",
		Tooltip = "Ensure that doors are setup correctly.",
		Icon = "rbxassetid://11974681757",
	}
	return ButtonConfig
end
