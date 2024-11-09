local CollectionService = game:GetService("CollectionService")
function CalculateLightState(State, v: BasePart)
	if not v then
		return
	end

	if not v:IsA("BasePart") then
		return
	end

	if State then
		v.Material = Enum.Material.Neon
	else
		v.Material = Enum.Material.SmoothPlastic
	end

	for _, c in pairs(v:GetChildren()) do
		if c:IsA("Light") then
			c.Enabled = State
		end
	end
end

return {
	SetTime = function(IsNight)
		for _, v in pairs(CollectionService:GetTagged("DynamicLights")) do
			CalculateLightState(IsNight, v :: BasePart)
		end
	end,
}
