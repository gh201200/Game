ConstValue = {
	MinBulletInterval = 0.2,
	BulletFlyTime = 0.7,
	BulletFlyHeight = 20,
	DefaultFontSize = 30,
	DefaultOutlineWidth = 1,
	SceneTipLastTime = 2,
	SystemTipLastTime = 5,
	HeroTipLastTime = 3,
	AddItemTipLastTime = 1,
	TaskTipLastTime = 7,
	ChatTipLastTime = 5,
	
	AlertPanel = 1,
	CommonPanel = 2,
	-- HotfixPanel = 4,
	TipPanel = 3,
	GuidePanel = 4,
	LoadPanel = 5,
	
	HarborType = 1,
	PlayerType = 2,
	SendType = 3,
	PositionType = 4,
	IntoHarborType = 5,
	AttackPlayerType = 6,
	AttackNearType = 7,
	TreasureType = 8,
	BattleField = 9,
	PanelType = 10,
	
	NameMaxLength = 7,
	NoticeMaxLength = 48,
	MaxMsgLength = 50,
	
	EquipMaxStar = 6,
	BuildMaxLevel = 33,
	LabMaxLevel = 33,
	
	MaxSailorCount = 18,
	
	MenuShowTime = 10,
	
	ConnectTime = 5000,
	
	UploadTime = 0.3,
	
	UpdateFrinedTime = 10,
	UpdateFamilyTime = 10,
	UpdateShipTeamTime = 10,
	
	ResHarborPath = "GameObj/harbor/%d",
	ResShipPath = "GameObj/ships/%d",
	ResTreasurePath = "GameObj/chest/%d",
	ResSkillPath = "GameObj/skill/%d",
	BattleTargetPath = "GameObj/BattleTarget",
	GuiBgPath = "Texture/Gui/Bg/",
	GuiTextPath = "Texture/Gui/Text/",
	GuiButtonPath = "Texture/Gui/Button/",
	
	SimsunFont = "font/simsun",
	
	MapEmpty = "map/empty",
	MapWavePath = "GameObj/wave",
	
	WorldChannel = 1,
	PrivateChannel = 2,
	FamilyChannel = 3,
	
	AutoCompleteTask = 23,
	
	MaxShipCount = 90,
	
	MaxConnectCount = 10,
}


local csConfig = CsFindType("Config")
ConstValue.ResPath = Config.ResPath
ConstValue.DataPath = Config.DataPath

ConstValue.GuiVipPath = {
	[0] =  "Texture/Gui/Text/v0",
	[1] =  "Texture/Gui/Text/v1",
	[2] =  "Texture/Gui/Text/v2",
	[3] =  "Texture/Gui/Text/v3",
	[4] =  "Texture/Gui/Text/v4",
	[5] =  "Texture/Gui/Text/v5",
	[6] =  "Texture/Gui/Text/v6",
	[7] =  "Texture/Gui/Text/v7",
	[8] =  "Texture/Gui/Text/v8",
	[9] =  "Texture/Gui/Text/v9",
	[10] = "Texture/Gui/Text/v10",
	[11] = "Texture/Gui/Text/v11",
	[12] = "Texture/Gui/Text/v12",
	[13] = "Texture/Gui/Text/v13",
	[14] = "Texture/Gui/Text/v14",
	[15] = "Texture/Gui/Text/v15",
}

--VIPÃæ°åµÄVIPlevelÍ¼±ê
ConstValue.vipGuiImagePath = {
	[0] =  "Texture/Gui/Text/vip0",
	[1] =  "Texture/Gui/Text/vip1",
	[2] =  "Texture/Gui/Text/vip2",
	[3] =  "Texture/Gui/Text/vip3",
	[4] =  "Texture/Gui/Text/vip4",
	[5] =  "Texture/Gui/Text/vip5",
	[6] =  "Texture/Gui/Text/vip6",
	[7] =  "Texture/Gui/Text/vip7",
	[8] =  "Texture/Gui/Text/vip8",
	[9] =  "Texture/Gui/Text/vip9",
	[10] = "Texture/Gui/Text/vip10",
	[11] = "Texture/Gui/Text/vip11",
	[12] = "Texture/Gui/Text/vip12",
	[13] = "Texture/Gui/Text/vip13",
	[14] = "Texture/Gui/Text/vip14",
	[15] = "Texture/Gui/Text/vip15",
}

ConstValue.StarQuality = {
	[0] = 0,
	[1] = 1,
	[2] = 1,
	[3] = 1,
	[4] = 2,
	[5] = 2,
	[6] = 2,
	[7] = 3,
	[8] = 3,
	[9] = 4,
	[10] = 4,
}

ConstValue.QualityUpItem = {
	[1] = 19,
	[2] = 20,
	[3] = 21,
}


ConstValue.Quality = {
	[0] = Language[125],
	[1] = Language[126],
	[2] = Language[127],
	[3] = Language[128],
	[4] = Language[176],
	[5] = Language[223],
}

ConstValue.QualityColorStr = {
	[0] = Color.WhiteStr,
	[1] = Color.LimeStr,
	[2] = Color.BlueStr,
	[3] = Color.PurpleStr,
	[4] = Color.OrangeStr,
	[5] = Color.RedStr,
}

ConstValue.RandomTaskAwardRate = {
	[1] = 1,
	[2] = 1.5,
	[3] = 2,
	[4] = 3,
}

ConstValue.ShipEquipDuty = {
	[1] = Language[203],
	[2] = Language[204],
	[3] = Language[205],
}

-- ConstValue.EquipDestroyGem = {
	-- [0] = {type=1,id=1},
	-- [1] = {type=1,id=1},
	-- [2] = {type=1,id=1},
	-- [3] = {type=1,id=2},
	-- [4] = {type=1,id=3},
-- }

-- ConstValue.HarborY = {
	-- [1] = 52,
	-- [2] = 47,
	-- [3] = 86,
-- }

-- ConstValue.EquipDestroyGet = {
	-- [0] = function(equip) 
		-- local cfg_Equip = CFG_Equip[equip.id]
		-- local count = cfg_Equip.level/20 + 1 + (equip.star^3*1.8)/((cfg_Equip.quality+1)^2)
		-- return math.floor(count)
	-- end,
	-- [1] = function(equip) 
		-- local cfg_Equip = CFG_Equip[equip.id]
		-- local count = cfg_Equip.level/20 + 1 + (equip.star^3*1.8)/((cfg_Equip.quality+1)^2)
		-- return math.floor(count)
	-- end,
	-- [2] = function(equip) 
		-- local cfg_Equip = CFG_Equip[equip.id]
		-- local count = cfg_Equip.level/20 + 1 + (equip.star^3*1.8)/(cfg_Equip.quality^2)
		-- return math.floor(count)
	-- end,
	-- [3] = function(equip) 
		-- local cfg_Equip = CFG_Equip[equip.id]
		-- local count = cfg_Equip.level/20 + 1 + (equip.star^3*0.8)/(cfg_Equip.quality^2)
		-- return math.floor(count)
	-- end,
	-- [4] = function(equip) 
		-- local cfg_Equip = CFG_Equip[equip.id]
		-- local count = cfg_Equip.level/20 + 1 + (equip.star^3)/((cfg_Equip.quality+1)^2)
		-- return math.floor(count)
	-- end,
-- }

ConstValue.PropertyPower = {
	[1] = 1,
	[3] = 1,
	[5] = 0.25,
}

ConstValue.EquipType = {
	[1] = Language[93],
	[2] = Language[94],
	[3] = Language[95],
	[4] = Language[92],
	[5] = Language[96],
	[6] = Language[97],
}


ConstValue.ShipEquipType = {
	[1] = Language[193],
	[2] = Language[195],
	[3] = Language[194],
	[4] = Language[192],
	[5] = Language[213],
}

ConstValue.HarborMasterType = {
	[0] = Language[211],
	[1] = Language[212],
}

-- ConstValue.EquipPowerModulus = {
	-- [1] = Language[93],
	-- [2] = Language[94],
	-- [3] = Language[95],
	-- [4] = Language[92],
	-- [5] = Language[96],
	-- [6] = Language[97],
-- }

-- ConstValue.PropertyType = {
	-- attack = 1,
	-- defense = 1,
	-- hp = 0.25,
	-- gunCount = 0.25,
	-- store = 0.25,
	-- range = 0.25,
	-- rate = 0.25,
-- }

ConstValue.RelationStr = {
	-- [0] = Language[155],
	[1] = Language[155],
	[2] = Language[134],
	[3] = Language[133],
	[4] = Language[135],
}

ConstValue.RelationColorStr = {
	[1] = Color.WhiteStr,
	[2] = Color.CyanStr,
	[3] = Color.LimeStr,
	[4] = Color.RedStr,
}

ConstValue.ChannelStr = {
	[-1] = Language[98],
	[0] = Language[150],
	[1] = Language[151],
	-- [2] = "<color=" .. Color.RedbeanStr .. ">" .. Language[152] .. "</color>",
	[3] = Language[152],
	[4] = Language[188],
}

ConstValue.ChannelColorStr = {
	[0] = Color.ChannelColorStr1,
	[1] = Color.ChannelColorStr2,
	-- [2] = Color.RedbeanStr,
	[3] = Color.ChannelColorStr3,
	[4] = Color.RedbeanStr,
}
ConstValue.BuildUpPack = {
	[1] = Packat_Harbor.CLIENT_REQUEST_UP_MAIN_BUILDING,
	[2] = Packat_Harbor.CLIENT_REQUEST_UP_SHIP_FAC,
	[3] = Packat_Harbor.CLIENT_REQUEST_UP_LAB,
	[4] = Packat_Harbor.CLIENT_REQUEST_UP_SHOP,
}

ConstValue.BuildFastUpPack = {
	[1] = Packat_Harbor.CLIENT_REQUEST_FAST_MAIN_UP,
	[2] = Packat_Harbor.CLIENT_REQUEST_FAST_SHIP_UP,
	[3] = Packat_Harbor.CLIENT_REQUEST_FAST_LAB_UP,
	[4] = Packat_Harbor.CLIENT_REQUEST_FAST_SHOP_UP,
}

-- ConstValue.BuildUpCost = {
	-- [1] = function(lv) return (lv-1)*(lv-1)*(lv-1)*5000+20000 end,
	-- [2] = function(lv) return (lv-1)*(lv-1)*(lv-1)*4000+15000 end,
	-- [3] = function(lv) return (lv-1)*(lv-1)*(lv-1)*4000+15000 end,
	-- [4] = function(lv) return (lv-1)*(lv-1)*(lv-1)*4000+15000 end,
-- }

-- ConstValue.BuildUpCd = {
	-- [1] = function(lv) return lv*lv*lv*60 end,
	-- [2] = function(lv) return lv*lv*lv*45 end,
	-- [3] = function(lv) return lv*lv*lv*45 end,
	-- [4] = function(lv) return lv*lv*lv*45 end,
-- }

ConstValue.PostName = {
	[0] = Language[164],
	[1] = Language[165],
	[2] = Language[166],
	[3] = Language[167],
}

ConstValue.LogType = {
	[1] = Language[168],
	[2] = Language[169],
	[3] = Language[170],
	[4] = Language[171],
	[5] = Language[172],
	[6] = Language[173],
	[7] = Language[174],
	[8] = Language[175],
}

ConstValue.HeroHeaderPoint = {
	[1] = {11,12},
	[2] = {16,14},
	[3] = {14,14},
	[4] = {15,12},
	[5] = {16,14},
}

ConstValue.SailorBg = {
	[1] = {344,416},
	[2] = {252,527},
	[3] = {94,575},
	[4] = {94,573},
	[5] = {250,532},
	[6] = {344,416},
}

ConstValue.SignuperType = {
	[0] = Language[189],
	[1] = Language[190],
	[2] = Language[200],
}