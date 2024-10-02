return {
	Lighting = {
		["Ambient"] = Color3.fromRGB(35, 35, 35),
		["Brightness"] = 1,
		["ColorShift_Bottom"] = Color3.fromRGB(0, 0, 0),
		["ColorShift_Top"] = Color3.fromRGB(68, 68, 68),
		["ClockTime"] = 0,
		["EnvironmentDiffuseScale"] = 0,
		["EnvironmentSpecularScale"] = 0,
		["GlobalShadows"] = true,
		["OutdoorAmbient"] = Color3.fromRGB(35, 35, 35),
		["ShadowSoftness"] = 0.1,
		["GeographicLatitude"] = 15,
	},

	Atmosphere = {
		Density = 0.27,
		Offset = 0.00,
		Color = Color3.fromRGB(52, 52, 52),
		Decay = Color3.fromRGB(0, 0, 0),
		Glare = 1.02,
		Haze = 0.05,
	},

	Sky = {
		MoonAngularSize = 5,
		MoonTextureId = "rbxasset://sky/moon.jpg",
		SkyboxBk = "rbxassetid://1013372167",
		SkyboxDn = "rbxassetid://1013372689",
		SkyboxFt = "rbxassetid://1013372167",
		SkyboxLf = "rbxassetid://1013372167",
		SkyboxRt = "rbxassetid://1013372167",
		SkyboxUp = "rbxassetid://1013372490",
		StarCount = 3000,
		SunAngularSize = 10,
		SunTextureId = "rbxasset://sky/sun.jpg",
	},

	BloomEffect = {
		Insensity = 1.5,
		Size = 24,
		Threshold = 1,
	},

	BlurEffect = {
		Enabled = false,
		Size = 40,
	},

	ColorCorrectionEffect = {
		Brightness = 0,
		Contrast = 0,
		Enabled = false,
		Saturation = 0,
		TintColor = Color3.new(1, 1, 1),
	},

	DepthOfFieldEffect = {
		Enabled = false,
		FarIntensity = 0.1,
		FocusDistance = 0.05,
		InFocusRadius = 30,
		NearIntensity = 0.75,
	},

	SunRaysEffect = {
		Enabled = true,
		Intensity = 0.01,
		Spread = 0.1,
	},
}
