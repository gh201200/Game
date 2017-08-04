local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table
local SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property,EventType = 
SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property,EventType
local AssetType,CFG_ship,CFG_product,CFG_shipEquip,AppearEvent = 
AssetType,CFG_ship,CFG_product,CFG_shipEquip,AppearEvent
local DrawItemCell,ItemType = DrawItemCell,ItemType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mMainPanel = require "LuaScript.View.Panel.Main.Main"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mEquipUpPanel = nil
local mEquipDestroyPanel = nil
local mEquipViewPanel = nil
local mShipEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mCommonlyFunc = nil
local mSailorManager = nil
local mEventManager = nil
local mShipManager = nil
local mGoodsManager = nil
local mSystemTip = nil
local mShipEquipManager = nil
local mShipSelectPanel = nil
local mShipEquipViewPanel = nil
local mAlert = nil

module("LuaScript.View.Panel.Fleet.FleetPanel") -- 舰队界面

local mSelect = 1
local mPage = 1
local mScrollPositionY = 0
local mScrollPositionX1 = 0
local mScrollPositionX2 = 0
local mScrollPositionX3 = 0
FullWindowPanel = true

function Init()
	mShipManager = require "LuaScript.Control.Data.ShipManager"
	mSailorManager = require "LuaScript.Control.Data.SailorManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipDestroyPanel = require "LuaScript.View.Panel.Equip.EquipDestroyPanel"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	-- mEquipManager = require "LuaScript.Control.Data.EquipManager"
	mShipEquipSelectPanel = require "LuaScript.View.Panel.Equip.ShipEquipSelectPanel"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mEventManager = require "LuaScript.Control.EventManager"
	mGoodsManager = require "LuaScript.Control.Data.GoodsManager"
	mShipEquipManager = require "LuaScript.Control.Data.ShipEquipManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mShipSelectPanel = require "LuaScript.View.Panel.Harbor.ShipSelectPanel"
	mShipEquipViewPanel = require "LuaScript.View.Panel.Equip.ShipEquipViewPanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	
	mSelect = 1
	IsInit = true
end

function GetPag()
	return mPage
end

function GetSelect()
	return mSelect
end

function SetSelect(value)
	mSelect = value
end

function Hide()
	mSelect = 1
	mPage = 1
end

function OnGUI()
	
	if not IsInit then
		return
	end

	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	
	if mPage == 1 then
		GUI.Button(88.35,38.3,134,58, "舰队", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(88.35,38.3,134,58, "舰队", GUIStyleButton.PagBtn_1) then
		mPage = 1
		AppearEvent(nil,EventType.OnRefreshGuide)
	end
	
	if mPage == 2  then
		GUI.Button(232.95,38.3,134,58, "货物", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(232.95,38.3,134,58, "货物", GUIStyleButton.PagBtn_1) then
		mPage = 2
		mScrollPositionX1 = 0
		mScrollPositionX2 = 0
		mScrollPositionX3 = 0
		AppearEvent(nil,EventType.OnRefreshGuide)
	end
	
	-- if mPage == 3 then
		-- GUI.Button(376,38.3,134,58, "船装", GUIStyleButton.PagBtn_2)
	-- elseif GUI.Button(376,38.3,134,58, "船装", GUIStyleButton.PagBtn_1) then
		-- mPage = 3
		-- mScrollPositionY = 0
	-- end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(521-140,37.5,536+140,58,image, 0, 0, 1, 1, 15, 15, 0, 0)

	if mPage == 1 then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/shipBg")
		GUI.DrawTexture(77,115,984,512,image)
		
		DrawShip(143, 1)
		DrawShip(283, 2)
		DrawShip(424, 3)
	
		local ship = mShipManager.GetDutyShip(mSelect)
		local equips = nil
		if ship then
			equips = mShipEquipManager.GetEquipsBySid(ship.index)
		end
		
		if equips then
			DrawEquip(545, 409, equips[1], 1)
			DrawEquip(798, 411, equips[2], 2)
			DrawEquip(672, 306, equips[3], 3)
			DrawEquip(376, 386, equips[4], 4)
		else
			DrawEquip(545, 409, nil, 1)
			DrawEquip(798, 411, nil, 2)
			DrawEquip(672, 306, nil, 3)
			DrawEquip(376, 386, nil, 4)
		end
		
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
		GUI.DrawTexture(309,157,150,36,image)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
		GUI.DrawTexture(309,157,150,36,image)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
		GUI.DrawTexture(313,194,140,145,image,0,0,1,1,20,20,20,20)
		
		if ship then
			local cfg_ship = CFG_ship[ship.bid]
			GUI.Label(316,165,136,36,cfg_ship.name, GUIStyleLabel.Center_22_LightGreen_Art, Color.Black)
			GUI.Label(317,200,136,36,"耐久:"..ship.life, GUIStyleLabel.Left_20_Brown)
			GUI.Label(317,227,136,36,"攻击:"..ship.attack, GUIStyleLabel.Left_20_Brown)
			GUI.Label(317,254,136,36,"防御:"..ship.defense, GUIStyleLabel.Left_20_Brown)
			GUI.Label(317,281,136,36,"血量:"..ship.hp, GUIStyleLabel.Left_20_Brown)
			GUI.Label(317,308,136,36,"战斗力:"..mCommonlyFunc.GetShipPower(cfg_ship.id, ship), GUIStyleLabel.Left_20_Brown)
		
			if GUI.Button(808,147,171,59, "更换船只", GUIStyleButton.OrangeBtn_3) then
				local resList = mShipManager.GetRestShip()
				if #resList == 0 then
					mSystemTip.ShowTip("没有空余船只")
					return
				end
				
				local hero = mHeroManager.GetHero()
				if not hero.harborId then
					mSystemTip.ShowTip("在港口内才可更换船只")
					return
				end
				
				function OkFunc()
					ChangeShip(mSelect)
				end
				
				
				if mGoodsManager.HaveGoods(ship) then
					mAlert.Show("更换船只将导致货物将损坏,确定更换?", OkFunc)
				else
					OkFunc()
				end
			end
			if GUI.Button(808,212,171,59, "一键装备", GUIStyleButton.OrangeBtn_3) then
				mShipEquipManager.RequestAutoWearEquip(ship.index)
			end
		end
	elseif mPage == 2 then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/shipBg")
		GUI.DrawTexture(77,115,984,512,image)
	
		DrawShip(143, 1)
		DrawShip(283, 2)
		DrawShip(424, 3)
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/produceBg")
		GUI.DrawTexture(289,136,711,443,image)
		
		local spacing = 120
		
		local ship = mShipManager.GetDutyShip(1)
		if ship then
			local cfgShip = CFG_ship[ship.bid]
			local goodsList = mGoodsManager.GetGoodsList()
			mScrollPositionX1,_ = GUI.BeginScrollView(367, 166, 602, 127, mScrollPositionX1, 0, 0, 0, spacing * ship.store, 107)
				for k,v in pairs(goodsList[1]) do
					if ship.store >= k then
						DrawGoods(k*spacing-spacing, 0, k, v)
					elseif k <= 5 then
						DrawGoods(k*spacing-spacing, 0, k, nil)
					end
				end
			GUI.EndScrollView()
		end
		
		local ship = mShipManager.GetDutyShip(2)
		if ship then
			local cfgShip = CFG_ship[ship.bid]
			local goodsList = mGoodsManager.GetGoodsList()
			mScrollPositionX2,_ = GUI.BeginScrollView(367, 301, 602, 127, mScrollPositionX2, 0, 0, 0, spacing * ship.store, 107)
				for k,v in pairs(goodsList[2]) do
					if ship.store >= k then
						DrawGoods(k*spacing-spacing, 0, k, v)
					elseif k <= 5 then
						DrawGoods(k*spacing-spacing, 0, k, nil)
					end
				end
			GUI.EndScrollView()
		end
		
		local ship = mShipManager.GetDutyShip(3)
		if ship then
			local cfgShip = CFG_ship[ship.bid]
			local goodsList = mGoodsManager.GetGoodsList()
			mScrollPositionX3,_ = GUI.BeginScrollView(367, 438, 602, 127, mScrollPositionX3, 0, 0, 0, spacing * ship.store, 107)
				for k,v in pairs(goodsList[3]) do
					if ship.store >= k then
						DrawGoods(k*spacing-spacing, 0, k, v)
					elseif k <= 5 then
						DrawGoods(k*spacing-spacing, 0, k, nil)
					end
				end
			GUI.EndScrollView()
		end
		
		if GUI.Button(352, 178, 40, 59,nil, GUIStyleButton.LeftBtn) then
			mScrollPositionX1 = 0
		end
		if GUI.Button(941, 178, 40, 59,nil, GUIStyleButton.RightBtn) then
			mScrollPositionX1 = 9999
		end
		if GUI.Button(352, 312, 40, 59,nil, GUIStyleButton.LeftBtn) then
			mScrollPositionX2 = 0
		end
		if GUI.Button(941, 312, 40, 59,nil, GUIStyleButton.RightBtn) then
			mScrollPositionX2 = 9999
		end
		if GUI.Button(352, 449, 40, 59,nil, GUIStyleButton.LeftBtn) then
			mScrollPositionX3 = 0
		end
		if GUI.Button(941, 449, 40, 59,nil, GUIStyleButton.RightBtn) then
			mScrollPositionX3 = 9999
		end
	elseif mPage == 3 then
		-- local spacing = 156
		-- local mEquipList = mShipEquipManager.GetEquips()
		-- local count = #mEquipList
		-- _,mScrollPositionY = GUI.BeginScrollView(154, 136.4, 900, 460.5, 0, mScrollPositionY, 0, 0, 850, spacing * count)
			-- for k,equip in pairs(mEquipList) do
				-- local y = (k-1)*spacing
				-- local showY = y - mScrollPositionY / GUI.modulus
				-- if showY > -spacing  and showY < spacing*3 then
					-- DrawFreeEquip(equip, y)
				-- end
			-- end
			
			-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
			-- if count < 1 then
				-- GUI.DrawTexture(0,spacing*0,830,144,image)
			-- end
			-- if count < 2 then
				-- GUI.DrawTexture(0,spacing*1,830,144,image)
			-- end
			-- if count < 3 then
				-- GUI.DrawTexture(0,spacing*2,830,144,image)
			-- end
		-- GUI.EndScrollView()
	end
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
	end
end

function ChangeShip(index)
	-- local select = index
	local resList = mShipManager.GetRestShip()
	if #resList == 0 then
		mSystemTip.ShowTip("没有空余船只")
		return
	end
	
	local hero = mHeroManager.GetHero()
	if not hero.harborId then
		mSystemTip.ShowTip("在港口内才可更换船只")
		return
	end
	
	
	function func(ship)
		if ship then
			mSelect = index
			mShipManager.RequestSetDuty(ship.index, index)
		end
		mPanelManager.Show(OnGUI)
	end
	mShipSelectPanel.SetData(func)
	mPanelManager.Show(mShipSelectPanel)
	mPanelManager.Hide(OnGUI)
end

function DrawShip(y, index)
	local ship = mShipManager.GetDutyShip(index)
	if mSelect == index then
		if GUI.Button(118,y,152,144, nil, GUIStyleButton.SelectBtn_4) and not ship then
			ChangeShip(index)
		end
	elseif GUI.Button(118,y,152,144, nil, GUIStyleButton.SelectBtn_3) then
		if ship then
			mSelect = index
		else
			ChangeShip(index)
		end
	end
	
	if not ship then
		GUI.Label(118,y,152,144, Language[196], GUIStyleLabel.MCenter_30_White_Art)
	else
		local cfg_ship = CFG_ship[ship.bid]
		local image = mAssetManager.GetAsset("Texture/Icon/Ship/"..cfg_ship.resId, AssetType.Icon)
		GUI.DrawTexture(126,y,125,125,image)
	end
end

function DrawEquip(x, y, equip, index)
	if equip then
		local cfg_shipEquip = CFG_shipEquip[equip.id]
		-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_"..cfg_shipEquip.quality)
		-- GUI.DrawTexture(x, y,80,80,image)
		
		-- local image = mAssetManager.GetAsset("Texture/Icon/ShipEquip/"..cfg_shipEquip.icon, AssetType.Icon)
		if DrawItemCell(cfg_shipEquip, ItemType.ShipEquip, x+5, y+5, 70, 70, true, false, false) then
			local ship = mShipManager.GetDutyShip(mSelect)
			mShipEquipViewPanel.SetData(ship, equip)
			mPanelManager.Show(mShipEquipViewPanel)
		end
		
	else
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_0")
		if GUI.TextureButton(x,y,80,80,image) then
			local ship = mShipManager.GetDutyShip(mSelect)
			if not ship then
				mSystemTip.ShowTip("请先配置船只")
				return
			end
			
			local resEquips = mShipEquipManager.GetEquipsByType(index)
			if #resEquips== 0 then
				mSystemTip.ShowTip("没有该类装备")
				return
			end
			
			
			local shipIndex = ship.index
			local select = mSelect
			function SelectFunc(equip)
				if equip then
					mShipEquipManager.RequestWearEquip(equip.index, shipIndex)
				end

				mSelect = select
				mPanelManager.Show(OnGUI)
			end
			
			mShipEquipSelectPanel.SetData(ship, index, SelectFunc)
			mPanelManager.Show(mShipEquipSelectPanel)
			mPanelManager.Hide(OnGUI)
		end
		
		GUI.Label(x, y+25, 80, 30, ConstValue.ShipEquipType[index], GUIStyleLabel.Center_30_White_Art, Color.Black)
	end
end

function DrawGoods(x, y, pos, prouceId)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/productSlot")
	GUI.DrawTexture(x+19,y,80,80,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg29_1")
	GUI.DrawTexture(x,y+82,122,25,image)
	if prouceId == nil then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg18_1")
		if GUI.TextureButton(x+23,y+6,71,68,image) then
			mSystemTip.ShowTip("更换高级船只或船装备可解锁该货仓", Color.LimeStr)
		end
		GUI.Label(x, y+82, 118, 25, "未解锁", GUIStyleLabel.Center_25_Red)
	elseif prouceId == 0 then
		GUI.Label(x, y+82, 118, 25, "无货物", GUIStyleLabel.Center_25_White)
	else
		local product = CFG_product[prouceId]
		local image = mAssetManager.GetAsset("Texture/Icon/Product/"..product.icon, AssetType.Icon)
		GUI.DrawTexture(x+23,y+3,72,72,image)
		GUI.Label(x, y+82, 118, 25, product.name, GUIStyleLabel.Center_25_White)
	end
end

-- function DrawFreeEquip(equip, y)
	-- local cfg_shipEquip = CFG_shipEquip[equip.id]
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	-- GUI.DrawTexture(0,y,830,144,image)
	
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..cfg_shipEquip.quality)
	-- GUI.DrawTexture(34.45, y+17,128,128,image)
	
	-- local image = mAssetManager.GetAsset("Texture/Icon/ShipEquip/"..cfg_shipEquip.icon, AssetType.Icon)
	-- if GUI.TextureButton(39.45, y+22, 100, 100, image) then
		-- mShipEquipViewPanel.SetData(nil, equip)
		-- mPanelManager.Show(mShipEquipViewPanel)
	-- end
	
	-- GUI.Label(180, y+19.6, 74.2, 30, cfg_shipEquip.name, GUIStyleLabel.Left_35_Redbean_Art)
	
	-- GUI.Label(188, y+73, 59.2, 30, Language[129], GUIStyleLabel.Left_20_Black)
	-- local qualityColor = ConstValue.QualityColorStr[cfg_shipEquip.quality]
	-- local infostr = mCommonlyFunc.BeginColor(qualityColor)
	-- infostr = infostr.. ConstValue.Quality[cfg_shipEquip.quality]
	-- infostr = infostr.. mCommonlyFunc.EndColor()
	-- GUI.Label(238, y+68, 74.2, 30, infostr, GUIStyleLabel.Center_30_White_Art, Color.Black)
	
	-- local infostr = "类型: " .. cfg_shipEquip.typeName
	-- GUI.Label(188, y+101, 74.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	
	-- GUI.Label(372, y+17, 440, 51, "附加技能:"..cfg_shipEquip.skillDesc, GUIStyleLabel.MLeft_20_Black_WordWrap)
	
	-- local infostr = CFG_property[cfg_shipEquip.propertyId1].type .. ": " .. mCommonlyFunc.GetShipEquipProperty(equip)
	-- GUI.Label(372, y+73, 114, 30, infostr, GUIStyleLabel.Left_20_Black)
	-- local infostr = Language[28] .. mCommonlyFunc.GetShipEquipPower(equip)
	-- GUI.Label(372, y+101, 134, 30, infostr, GUIStyleLabel.Left_20_Black)
	
	-- if equip.protect then
		-- if GUI.Button(680, y+70, 111, 60,"已锁定", GUIStyleButton.ShortOrangeArtBtn) then
			-- mShipEquipManager.RequestProtect(equip.index, 0)
		-- end
	-- else
		-- if GUI.Button(680, y+70, 111, 60,"未锁定", GUIStyleButton.ShortOrangeArtBtn) then
			-- mShipEquipManager.RequestProtect(equip.index, 1)
		-- end
	-- end
	
	-- if equip.sid ~= 0 then
		-- local image = mAssetManager.GetAsset("Texture/Gui/Text/wear")
		-- GUI.DrawTexture(36, y+15,64,64,image)
		
		-- local ship = mShipManager.GetShip(equip.sid)
		-- GUI.Label(560, y+78, 111, 60, ConstValue.ShipEquipDuty[ship.duty], GUIStyleLabel.Left_35_Brown_Art)
	-- end
-- end