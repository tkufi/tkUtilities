return {
	Sequences = {
		GreenButton = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("89ff77")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("007500")),
		}),

		RedButton = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("ff7777")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("750000")),
		}),

		GreyButton = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("828282")),
			ColorSequenceKeypoint.new(1, Color3.fromHex("4e4e4e")),
		}),
	},
	Solid = {
		White = Color3.fromHex("ffffff"),

		DefaultTextColor = Color3.fromHex("ffffff"),
		DefaultPlaceholderColor = Color3.fromHex("dddddd"),

		PrimaryColor = Color3.fromHex("002f6c"),
		RedColor = Color3.fromHex("6c0000"),
		GreenColor = Color3.fromHex("086c00"),

		WindowBackground = Color3.fromRGB(31, 31, 31),
		WindowBlack = Color3.new(0, 0, 0),

		DisabledButton = Color3.fromRGB(70, 70, 70),
	},
}
