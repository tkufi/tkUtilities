local CollectionService = game:GetService("CollectionService")
local CoreGui = game:GetService("CoreGui")
local Debris = game:GetService("Debris")
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

function MakeMotor6D(p0, p1, in_place)
	local cf
	if in_place then
		cf = p0.CFrame:ToObjectSpace(p1.CFrame)
	end

	p1.Anchored = true
	for _, joint in pairs(p1:GetJoints()) do
		if (joint.Part0 == p0 and joint.Part1 == p1) or (joint.Part0 == p1 and joint.Part1 == p0) then
			joint.Parent = nil
		end
	end

	local motor = Instance.new("Motor6D")
	motor.Name = p1.Name
	motor.Part0 = p0
	motor.Part1 = p1
	if cf then
		motor.C0 = cf
	end
	motor.Parent = p0

	p1.Anchored = false

	return motor
end

function ValidateDoor(DoorFolder: Folder & { Parent: Model }): (boolean, string?)
	if not DoorFolder:IsA("Folder") then
		return false, "Door is not a Folder"
	end

	DoorFolder.Parent:AddTag("DoorModel")

	local DoorWeld = DoorFolder:FindFirstChild("DoorWeld", true) :: BasePart?
	if not DoorWeld then
		return false, "Door does not contain a DoorWeld"
	end

	local Hinge = DoorFolder:FindFirstChild("Hinge", true) :: BasePart?
	if not Hinge then
		return false, "Door does not contain a Hinge (BasePart)"
	end

	local M6D = Hinge:FindFirstChildOfClass("Motor6D")

	if not M6D then
		M6D = MakeMotor6D(Hinge, DoorWeld, true)
		warn(`Made the Motor6D for {DoorFolder:GetFullName()}`)
	end

	if not M6D:GetAttribute("OpenAngle") then
		M6D:SetAttribute("OpenAngle", -90)
	end

	if M6D.MaxVelocity == 0 then
		M6D.MaxVelocity = 0.1
	end

	local WholeDoor = DoorFolder:FindFirstChild("WholeDoor") :: BasePart
	if not WholeDoor then
		return false, "No WholeDoor Folder Found."
	end

	local Handle = WholeDoor:FindFirstChild("Handle") :: BasePart
	if not Handle then
		return false, "No Handle Found"
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

	for _, v in pairs(DoorFolder:GetDescendants()) do
		if (not v:IsA("BasePart")) or v.Name == "Hinge" then
			continue
		end
		v.Anchored = false
	end

	return true
end

return function(Fusion: any, FusionPlugin: any, EmberUtilities: any)
	local ButtonConfig = {}

	local Styles = EmberUtilities.Styles
	local WindowButton = require(Styles.WindowButton)

	--
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
						local Success, ErrorMsg = ValidateDoor(v)
						if Success then
							MakeHighlightGreen(v.Parent)
							print(`"{v:GetFullName()}" has passed validation`)
							continue
						end

						MakeHighlightRed(v)
						warn(`"{v:GetFullName()}" has failed validation. \nReason: {ErrorMsg}`)
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
