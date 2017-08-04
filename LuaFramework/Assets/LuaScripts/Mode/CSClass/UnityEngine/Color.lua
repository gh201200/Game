Color = {}
Color.Init = function(r, g, b, a)
	r = math.max(0.001, r)
	g = math.max(0.001, g)
	b = math.max(0.001, b)
	a = math.max(0.001, (a or 1))
	
	-- if CsCreateColor then
		-- local color = CsCreateColor(r, g, b, a)
		-- return color
	-- elseif Color.example then
		-- Color.example.r = r
		-- Color.example.g = g
		-- Color.example.b = b
		-- Color.example.a = a
		-- return Color.example
	-- else
		-- local cs_Args = NewObjectArr(r, g, b, a)
		-- local cs_ConvertFuncs = NewObjectArr("System.Convert", "ToSingle", 
									-- "System.Convert", "ToSingle",
									-- "System.Convert", "ToSingle",
									-- "System.Convert", "ToSingle")
		-- return cs_Base:InitClass("UnityEngine.Color", cs_Args, cs_ConvertFuncs)
	-- end
	
	
	return UnityEngine.Color.New(r, g, b, a)
end

local CSColor = CsFindType("UnityEngine.Color")
Color.Red = UnityEngine.Color.red
Color.White = UnityEngine.Color.white
Color.Black = UnityEngine.Color.black
Color.Gray = UnityEngine.Color.gray
Color.Gray2 = Color.Init(60/255, 60/255, 60/255)
Color.Blue = UnityEngine.Color.blue
Color.DeepBlue = Color.Init(0x2A/255, 0x4C/255, 0x55/255)
Color.Green = UnityEngine.Color.green
Color.Yellow = UnityEngine.Color.yellow
Color.Green2 = Color.Init(102/255, 1, 0)
Color.Lime = Color.Init(0, 1, 0)
Color.Orange = Color.Init(0xff/255, 0x53/255, 0x21/255)
Color.LightYellow = Color.Init(255/255, 255/255, 204/255)
Color.LightGreen = Color.Init(204/255, 255/255, 153/255)
Color.LightBlue = Color.Init(0xa2/255, 255/255, 153/255)
Color.Brown = Color.Init(153/255, 51/255, 0)
Color.Brown2 = Color.Init(0x68/255, 0x2d/255, 0x04/255)
Color.Brown3 = Color.Init(1, 0x99/255, 0)
-- Color.LightBrown = Color.Init(0xee, 0x88/255, 0)
Color.Yellowish = Color.Init(255/255, 255/255, 204/255)
Color.Redbean = Color.Init(106/255, 49/255, 65/255)
Color.ChannelColor1 = Color.Init(0x22/255, 0xaa/255, 0x88/255)
Color.ChannelColor2 = Color.Init(0x66/255, 0x33/255, 0x66/255)
Color.ChannelColor3 = Color.Init(0xcc/255, 0x33/255, 0/255)
Color.ChannelSelectColor = Color.Init(0x8A/255, 0x45/255, 0/255)
Color.SimpleYellow = Color.Init(248/255, 176/255, 82/255)
Color.SimpleYellow2 = Color.Init(236/255, 255/255, 146/255)
Color.Cyan = Color.Init(0, 1, 1)
-- print(Color.SimpleYellow2)
Color.LevelUp = Color.Init(1, 188/255, 0)
Color.PowerChange = Color.Init(1, 240/255, 85/255)
Color.LightGreen2 = Color.Init(224/255, 255/255, 224/255)
Color.Purple = Color.Init(213/255, 154/255, 1)
Color.Naturals = Color.Init(254/255, 207/255, 20/255)
Color.Earth = Color.Init(220/255, 167/255, 83/255)
Color.Yellow2 = Color.Init(0xff/255, 0x99/255, 0x33/255)
Color.Yellow3 = Color.Init(216/255, 240/255, 14/255)

Color.Light = Color.Init(0, 0.3, 0, 0.3)
Color.Empty = Color.Init(1, 1, 1, 0)

Color.SelectMoney1 = Color.Init(153/255, 204/255, 0)


Color.LinkRed = Color.Init(179/255, 33/255, 36/255)
Color.LinkBlue = Color.Init(25/255, 10/255, 113/255)

-- Color.SelectMoney2 = Color.Init(1, 1, 1, 0)

-- Color.ChannelColorStr1 = "#66cc99"
-- Color.ChannelColorStr2 = "#663366ff"
-- Color.ChannelColorStr3 = "#CC3300ff"

Color.NaturalsStr = "FECF14"
Color.RedStr = "ff0000"
Color.WhiteStr = "ffffff"
Color.BlackStr = "000000"
Color.GrayStr = "808080"
Color.BlueStr = "0063d2"
Color.DeepBlueStr = "2a4c55"
Color.GreenStr = "008000"
Color.OrangeStr = "ff5321"
Color.LimeStr = "00ff00"
Color.CyanStr = "00ffff"
Color.PurpleStr = "cd55eb"
Color.RedbeanStr = "642022"
Color.BrownStr = "543903"
Color.Brown2Str = "682d04"
Color.YellowStr = "ffff00"
Color.ChannelColorStr1 = "229966"
Color.ChannelColorStr2 = "663366"
Color.ChannelColorStr3 = "CC3300"
Color.SimpleYellowStr = "F8B052"

Color.example = Color.Init(0.3, 0.3, 0.3, 0.3)