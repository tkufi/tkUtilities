return {
	Lighting = {
		["Ambient"] = Color3.fromRGB(70, 70, 70),
		["Brightness"] = 1.5,
		["ColorShift_Bottom"] = Color3.fromRGB(0, 0, 0),
		["ColorShift_Top"] = Color3.fromRGB(68, 68, 68),
		["ClockTime"] = 12,
		["EnvironmentDiffuseScale"] = 0,
		["EnvironmentSpecularScale"] = 0,
		["GlobalShadows"] = true,
		["OutdoorAmbient"] = Color3.fromRGB(117, 118, 129),
		["ShadowSoftness"] = 0.1,
		["GeographicLatitude"] = 15,
	},

	Atmosphere = {
		Density = 0.3,
		Offset = 0.25,
		Color = Color3.fromRGB(199, 199, 199),
		Decay = Color3.fromRGB(106, 112, 125),
		Glare = 0,
		Haze = 0,
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
		Insensity = 1,
		Size = 24,
		Threshold = 2,
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
