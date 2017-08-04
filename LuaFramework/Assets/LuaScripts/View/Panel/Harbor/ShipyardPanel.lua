local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os
local CFG_ship,CFG_buildDesc,CFG_harbor,PackatHead,Packat_Harbor,GUIStyleButton,ConstValue,Packat_Ship,error,EventType = 
CFG_ship,CFG_buildDesc,CFG_harbor,PackatHead,Packat_Harbor,GUIStyleButton,ConstValue,Packat_Ship,error,EventType
local AssetType,AppearEvent,string = AssetType,AppearEvent,string
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mNetManager = nil
-- local mHeroManager = nil
local mShipManager = nil
local mCharManager = nil
local mCommonlyFunc = nil
local mViewShipPanel = nil
local mGoodsManager = nil
local mLabManager = nil
local mAlert = nil
local mSelectAlert = nil
local mSystemTip = nil
local mSetManager = nil
local mFleetPanel = nil
local mVipManager = nil
local mMainPanel = nil
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"

module("LuaScript.View.Panel.Harbor.ShipyardPanel") -- 船坞界面
FullWindowPanel = true
mUseIndexList = {1,2,3}
local mCurUseCount = nil
local mMaxUseCount = 3

local mScrollPositionY = 0
mPage = 1

local mCouldBuildShips = nil
local mCostTip = nil

local mRestShips = nil

function Init()
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mGoodsManager = require "LuaScript.Control.Data.GoodsManager"
	mLabManager = require "LuaScript.Control.Data.LabManager"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mShipManager = require "LuaScript.Control.Data.ShipManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mViewShipPanel = require "LuaScript.View.Panel.Harbor.ShipViewPanel"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mEventManager = require "LuaScript.Control.EventManager"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mFleetPanel = require "LuaScript.View.Panel.Fleet.FleetPanel"
	mVipManager = require "LuaScript.Control.Data.VipManager"
	
	mEventManager.AddEventListen(nil, EventType.RefreshUseShip, RefreshUseShip)
	mEventManager.AddEventListen(nil, EventType.RefreshRestShip, RefreshRestShip)
	
	
	IsInit = true
end

function Display()
	mPage = 1
	mCostTip = mSetManager.GetCostTip()
	mRestShips = mShipManager.GetRestShip()
	
	if mHarborManager.HarborIsMy() then
		local hero = mHeroManager.GetHero()
		mShipManager.RequestBuildList(hero.harborId)
		mScrollPositionY = 9999
	else
		mScrollPositionY = 0
	end
end

function Hide()
	mCouldBuildShips = nil
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
	
	if mHarborManager.HarborIsMy() then
		local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
		GUI.DrawTexture(519.2,36.8,526.8,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
		
		if mPage == 1 then
			GUI.Button(88.35,38.3,134,58, "订单", GUIStyleButton.PagBtn_2)
		elseif GUI.Button(88.35,38.3,134,58, "订单", GUIStyleButton.PagBtn_1) then
			mPage = 1
			mScrollPositionY = 9999
			AppearEvent(nil, EventType.OnRefreshGuide)
		end
		
		if mPage == 2  then
			GUI.Button(232.95,38.3,134,58, Language[76], GUIStyleButton.PagBtn_2)
		elseif GUI.Button(232.95,38.3,134,58, Language[76], GUIStyleButton.PagBtn_1) then
			mPage = 2
			mScrollPositionY = 0
			AppearEvent(nil, EventType.OnRefreshGuide)
		end
		
		if mPage == 3  then
			GUI.Button(377.25,38.3,134,58, Language[81], GUIStyleButton.PagBtn_2)
		elseif GUI.Button(377.25,38.3,134,58, Language[81], GUIStyleButton.PagBtn_1) then
			mPage = 3
			mScrollPositionY = 0
			
			AppearEvent(nil, EventType.OnRefreshGuide)
		end
	else
		mPage = 3
		
		local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
		GUI.DrawTexture(83.5,37.5,1016.75-50,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
		
		GUI.Label(525.5,48,84.2,30,"船厂", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	end
	
	local hero = mHeroManager.GetHero()
	local harbor = CFG_harbor[hero.harborId]	
	
	if mPage == 1 then
		if not mCouldBuildShips then
			mCouldBuildShips = GetCouldBuildShips()
		end
		
		GUI.Label(238.65,140,82.7,30,"名字", GUIStyleLabel.Center_35_Black)
		GUI.Label(456.3-15,140,111.45,30,"花费", GUIStyleLabel.Center_35_Black)
		GUI.Label(613.15-15,140,74.2,30,"战斗力", GUIStyleLabel.Center_35_Black)
		GUI.Label(753-10,140,81.95,30,"耗时", GUIStyleLabel.Center_35_Black)
		GUI.Label(887.65-17,140,82.7,30,"操作", GUIStyleLabel.Center_35_Black)
		
		local spacing = 145
		local count = #mCouldBuildShips
		_,mScrollPositionY = GUI.BeginScrollView(154, 185.8, 900, 421.95, 0, mScrollPositionY, 0, 0, 850, spacing * count-15)
			for k,ship in pairs(mCouldBuildShips) do
				local y = (k-1)*spacing
				local showY = y - mScrollPositionY / GUI.modulus
				if showY > -spacing  and showY < spacing*3 then
					DrawShipBuild(0, y, k, ship)
				end
			end
			
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
			if count < 1 then
				GUI.DrawTexture(0,spacing*0,830,130.4,image)
			end
			if count < 2 then
				GUI.DrawTexture(0,spacing*1,830,130.4,image)
			end
			if count < 3 then
				GUI.DrawTexture(0,spacing*2,830,130.4,image)
			end
		GUI.EndScrollView()
	elseif  mPage == 2 then
		GUI.Label(238.65,140,82.7,30,"名字", GUIStyleLabel.Center_35_Black)
		GUI.Label(456.3-15,140,111.45,30,"花费", GUIStyleLabel.Center_35_Black)
		GUI.Label(613.15-15,140,74.2,30,"战斗力", GUIStyleLabel.Center_35_Black)
		GUI.Label(753-10,140,81.95,30,"耗时", GUIStyleLabel.Center_35_Black)
		GUI.Label(887.65-17,140,82.7,30,"操作", GUIStyleLabel.Center_35_Black)
		
		
		local mBuildShips = mShipManager.GetBuildShips(hero.harborId)
		if mBuildShips and mBuildShips.ships then
			local time =  mBuildShips.finishTime + mBuildShips.startTime - os.oldClock
			local spacing = 145
			local count = #mBuildShips.ships
			_,mScrollPositionY = GUI.BeginScrollView(154, 185.8, 900, 421.95, 0, mScrollPositionY, 0, 0, 850, spacing * count)
				for k,shipId in pairs(mBuildShips.ships) do
					local y = (k-1)*spacing
					local showY = y - mScrollPositionY / GUI.modulus
					if showY > -spacing  and showY < spacing*3 then
						local cfg_ship = CFG_ship[shipId]
						DrawShipBuilding(0, y, time, cfg_ship, k)
					end
					time = -1
				end
				
				local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
				if count < 1 then
					GUI.DrawTexture(0,spacing*0,830,130.4,image)
				end
				if count < 2 then
					GUI.DrawTexture(0,spacing*1,830,130.4,image)
				end
				if count < 3 then
					GUI.DrawTexture(0,spacing*2,830,130.4,image)
				end
				
			GUI.EndScrollView()
		end
	elseif  mPage == 3 then
		if not mCurUseCount then
			mCurUseCount = mShipManager.GetUseCount()
		end
		
		GUI.Label(238.65,140,82.7,30,"名字", GUIStyleLabel.Center_35_Black)
		GUI.Label(456.3-17+60,140,111.45,30,"战斗力", GUIStyleLabel.Center_35_Black)
		-- GUI.Label(613.15-13,140,74.2,30,"耐久", GUIStyleLabel.Center_35_Black)
		-- GUI.Label(613-13,140,81.95,30,"状态", GUIStyleLabel.Center_35_Black)
		GUI.Label(797.65,140,82.7,30,"操作", GUIStyleLabel.Center_35_Black)
		

		local spacing = 145
		local count = #mRestShips
		_,mScrollPositionY = GUI.BeginScrollView(154, 185.8, 900, 421.95, 0,mScrollPositionY, 0, 0, 850, spacing * count)
			for k,ship in pairs(mRestShips) do
				local y = (k-1)*spacing
				local showY = y - mScrollPositionY / GUI.modulus
				if showY > -spacing  and showY < spacing*3 then
					DrawShipStore(0, y, k, ship)
				end
			end
			
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
			if count < 1 then
				GUI.DrawTexture(0,spacing*0,830,130.4,image)
			end
			if count < 2 then
				GUI.DrawTexture(0,spacing*1,830,130.4,image)
			end
			if count < 3 then
				GUI.DrawTexture(0,spacing*2,830,130.4,image)
			end
		GUI.EndScrollView()
		
	end
	
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
	end
end


function DrawShipBuild(x, y, index, ship)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,830,130.4,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_0")
	GUI.DrawTexture(18,y+30.55,80,80,image)
	local image = mAssetManager.GetAsset("Texture/Icon/Ship/"..ship.resId, AssetType.Icon)
	if GUI.TextureButton(x+7, y+20, 86, 86, image) then
		mViewShipPanel.SetData(nil, ship.id)
		mPanelManager.Show(mViewShipPanel)
	end
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg10_1")
	-- GUI.DrawTexture(18,y+30.55,84,84,image)
	
	local price = ship.price * mVipManager.ShipBuildCost()
	GUI.Label(110+35, y+54.2, 74.2, 30, ship.titleName, GUIStyleLabel.MCenter_30_Redbean_Art)
	local costStr = mCommonlyFunc.GetShortNumber(price)
	GUI.Label(315.9, y+54.2, 52.2, 30, costStr, GUIStyleLabel.Center_25_Black)
	GUI.Label(450.9, y+54.2, 64.2, 30, mCommonlyFunc.GetShipPower(ship.id), GUIStyleLabel.Center_25_Black)
	local speed = mLabManager.ShipBuildSpeed() + mVipManager.ShipBuildSpeed()
	local cd = mCommonlyFunc.GetShipBuildCd(ship.time)
	local cdStr = mCommonlyFunc.GetChnTime(cd)
	GUI.Label(587.9, y+54.2, 76.2, 30, cdStr, GUIStyleLabel.Center_25_Black)
	
	local shipyardLevel = mHarborManager.GetShipyardLevel()
	if ship.unlockLevel > shipyardLevel then
		GUI.Label(730, y + 54, 54.2, 30, ship.unlockLevel.."级船厂解锁", GUIStyleLabel.Center_20_Red, Color.Black)
	else
		local hero = mHeroManager.GetHero()
		local harborInfo = mHarborManager.GetHarborInfo(hero.harborId)
		if harborInfo and harborInfo.masterType == 1 and ship.contribute > 0 then
			GUI.Label(692, y + 10, 130.55, 64.8, string.format("港口联盟\n额外消耗%d贡献",ship.contribute), GUIStyleLabel.Center_20_Lime, Color.Black)
			y = y + 20
		end
		if GUI.Button(692, y + 38.2, 130.55, 64.8, Language[76], GUIStyleButton.ShortOrangeArtBtn) then
			if not mCommonlyFunc.HaveMoney(price) then
				return
			end
			RequestBuildShip(ship.id)
		end
	end
	-- GUI.Label(250, 40, 150, 30, infoStr, GUIStyleLabel.Left_35_Red, Color.Black)
end

function DrawShipBuilding(x, y, time, ship, index)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,830,130.4,image)

	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_0")
	GUI.DrawTexture(18,y+30.55,80,80,image)
	local image = mAssetManager.GetAsset("Texture/Icon/Ship/"..ship.resId, AssetType.Icon)
	if GUI.TextureButton(x+7, y+20, 86, 86, image) then
		mViewShipPanel.SetData(nil, ship.id)
		mPanelManager.Show(mViewShipPanel)
	end
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg10_1")
	-- GUI.DrawTexture(18,y+30.55,84,84,image)
	
	GUI.Label(110+35, y+54.2, 74.2, 30, ship.titleName, GUIStyleLabel.MCenter_30_Redbean_Art)
	local price = ship.price * mVipManager.ShipBuildCost()
	local costStr = mCommonlyFunc.GetShortNumber(price)
	GUI.Label(315.9, y+54.2, 52.2, 30, costStr, GUIStyleLabel.Center_25_Black)
	GUI.Label(450.9, y+54.2, 64.2, 30, mCommonlyFunc.GetShipPower(ship.id), GUIStyleLabel.Center_25_Black)
	
	if time > 0 then
		local timeStr = mCommonlyFunc.GetFormatTime(time)
		GUI.Label(587.9, y+54.2, 76.2, 30, timeStr, GUIStyleLabel.Center_25_Black)
		if GUI.Button(692, y+38.2, 130.55, 64.8, Language[140], GUIStyleButton.ShortOrangeArtBtn) then
			
			local money = mCommonlyFunc.CdToMoney(time)
			if mCostTip then
				function OkFunc(showTip)
					if not mCommonlyFunc.HaveGold(money) then
						return
					end
					requestAddSpeed()
					mCostTip = not showTip
				end
				mSelectAlert.Show("是否花费"..money.."元宝,快速完成？", OkFunc)
			else
				if not mCommonlyFunc.HaveGold(money) then
					return
				end
				requestAddSpeed()
			end
		end
	else
		GUI.Label(587.9, y+54.2, 76.2, 30, Language[104], GUIStyleLabel.Center_25_Black)
		if GUI.Button(692, y+38.2, 130.55, 64.8, Language[9], GUIStyleButton.ShortOrangeArtBtn) then
			requestCancelBuilding(index)
		end
	end
end

function DrawShipStore(x, y, index, ship)
	local cfg_ship = CFG_ship[ship.bid]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,830,130.4,image)

	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_0")
	GUI.DrawTexture(18,y+30.55,80,80,image)
	local image = mAssetManager.GetAsset("Texture/Icon/Ship/"..cfg_ship.resId, AssetType.Icon)
	if GUI.TextureButton(x+7, y+20, 86, 86, image) then
		mViewShipPanel.SetData(ship, ship.bid)
		mPanelManager.Show(mViewShipPanel)
	end
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg10_1")
	-- GUI.DrawTexture(18,y+30.55,84,84,image)
	
	GUI.Label(110+35, y+54.2, 74.2, 30, cfg_ship.titleName, GUIStyleLabel.MCenter_30_Redbean_Art)
	GUI.Label(315.9+60, y+54.2, 52.2, 30,  mCommonlyFunc.GetShipPower(ship.bid), GUIStyleLabel.Center_25_Black)
	-- GUI.Label(450.9, y+54.2, 64.2, 30,  "99/99", GUIStyleLabel.Center_25_Black)
	
	-- if ship.duty == 0 then
		-- GUI.Label(447.9, y+54.2, 76.2, 30, "闲置中", GUIStyleLabel.Center_25_Black)
		
		-- if mCurUseCount >= mMaxUseCount then
			-- GUI.Label(552, y+54.2, 130.55, 64.8, "无空位", GUIStyleLabel.Center_25_Black)
		-- else
			if GUI.Button(552, y+38.2, 130.55, 64.8, Language[79], GUIStyleButton.ShortOrangeArtBtn) then
				mPanelManager.Show(mFleetPanel)
				mPanelManager.Hide(OnGUI)
			end
		-- end
		
		if GUI.Button(690, y+38.2, 130.55, 64.8, "出售", GUIStyleButton.ShortOrangeArtBtn) then
			function okFunc()
				mShipManager.RequestDelShip(ship.index)
			end
			mAlert.Show("销毁可收回50%的造价,是否确定销毁？", okFunc)
		end
		
	-- else
		-- GUI.Label(447.9, y+54.2, 76.2, 30, "已编制", GUIStyleLabel.Center_25_Black)
		-- if GUI.Button(622, y+38.2, 130.55, 64.8, Language[80], GUIStyleButton.ShortOrangeArtBtn) then
			-- if mGoodsManager.HaveGoods(ship) then
				-- mAlert.Show("船只下阵后货物将损坏，确定下阵?", function()
					-- RequestSetDuty(ship.index, false)
					-- mGoodsManager.ClearGoods(ship)
				-- end)
			-- else
				-- RequestSetDuty(ship.index, false)
				-- mGoodsManager.ClearGoods(ship)
			-- end
		-- end
	-- end
end

function GetCouldBuildShips()
	local ships = {}
	
	local shipyardLevel = mHarborManager.GetShipyardLevel()
	for k,ship in pairs(CFG_ship) do
		if ship.unlockLevel <= shipyardLevel + 1 and ship.couldBuild == 1 then
			table.insert(ships, ship)
		end
	end
	return ships
end

function RefreshUseShip()
	mCurUseCount = mShipManager.GetUseCount()
end

function RefreshRestShip()
	mRestShips = mShipManager.GetRestShip()
end

-- function RequestSetDuty(index, duty)
	-- print("requestSetDuty", index, duty)
	-- mShipManager.RequestSetDuty(index, duty)
-- end

function RequestBuildShip(shipId)
	mShipManager.CLIENT_REQUEST_ADD_BUILD(shipId)
end

function requestCancelBuilding(index)
	mShipManager.CLIENT_REQUEST_DEL_BUILD(index)
end

function requestAddSpeed()
	mShipManager.CLIENT_REQUEST_SPEED_BUILD()
end

-- function RequestUp()
	-- print("RequestUp")
	-- local cs_ByteArray = ByteArray.Init()
	-- ByteArray.WriteByte(cs_ByteArray,PackatHead.HARBOR)
	-- ByteArray.WriteByte(cs_ByteArray,Packat_Harbor.CLIENT_REQUEST_UP_SHIP_FAC)
	-- mNetManager.SendData(cs_ByteArray)
-- end

-- function RequestAddSpeed()
	-- print("RequestAddSpeed")
	-- local cs_ByteArray = ByteArray.Init()
	-- ByteArray.WriteByte(cs_ByteArray,PackatHead.HARBOR)
	-- ByteArray.WriteByte(cs_ByteArray,Packat_Harbor.CLIENT_REQUEST_FAST_SHIP_UP)
	-- mNetManager.SendData(cs_ByteArray)
-- end