local CollectionService = game:GetService("CollectionService")
function CalculateLightState(State, v)
	if not v then
		return
	end

	if v:IsA("BasePart") then
		if State then
			v.Material = Enum.Material.Neon
		else
			v.Material = Enum.Material.SmoothPlastic
		end
		
		for _,c in pairs(v:GetChildren()) do
			if c:IsA("Light") then
				c.Enabled = State
			end
		end
	elseif v:IsA("SpotLight") or v:IsA("SurfaceLight") or v:IsA("PointLight") then
		v.Enabled = State
		if v.Parent:IsA("BasePart") and v.Parent.Transparency < 1 then
			if State then
				v.Parent.Material = Enum.Material.Neon
			else
				v.Parent.Material = Enum.Material.SmoothPlastic
			end
		end
	end
end

return {
	SetTime = function(IsNight)
		for _, v in pairs(CollectionService:GetTagged("DayNight_Light")) do
			CalculateLightState(IsNight, v)
		end
	end,
}
