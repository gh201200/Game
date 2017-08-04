local _G,Screen,Language,GUI,ByteArray,print,Texture2D,CFG_harborProperty,CFG_buildDesc,os,Vector2,pairs
 = _G,Screen,Language,GUI,ByteArray,print,Texture2D,CFG_harborProperty,CFG_buildDesc,os,Vector2,pairs
local PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor = 
PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor
local ConstValue,CFG_buildUp,AppearEvent,EventType = ConstValue,CFG_buildUp,AppearEvent,EventType
local AssetType,math = AssetType,math
local mAssetManager = nil
local mNetManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mGUIStyleManager = nil
local mMainPanel = nil
local mTavernPanel = nil
local mShopPanel = nil
local mShipyardPanel = nil
local mSystemTip = nil
local mHeroManager = nil
local mCommonlyFunc = nil
local mBuildViewPanel = nil
local mHarborManager = nil
local mLabManager = nil
local mAlert = nil
local mSelectAlert = nil
local mSetManager = nil
local mItemManager = nil
module("LuaScript.View.Panel.Harbor.MainBuildPanel") -- 主城升级操作界面
mScrollPositionY = 0
FullWindowPanel = true
local mCostTip = nil
local switch = false

local Uptime = 0
local UpBuildId = 5

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mLabManager = require "LuaScript.Control.Data.LabManager"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mTavernPanel = require "LuaScript.View.Panel.Harbor.TavernPanel"
	mShopPanel = require "LuaScript.View.Panel.Harbor.ShopPanel"
	mShipyardPanel = require "LuaScript.View.Panel.Harbor.ShipyardPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mBuildViewPanel = require "LuaScript.View.Panel.Harbor.BuildViewPanel"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	AniBlinkStartTime()
	IsInit = true
	switch = true
end

function Display()
	-- mScrollPositionY = 0
	mCostTip = mSetManager.GetCostTip()
	switch = true
end

function Hide()
	mScrollPositionY = 0
	switch = false
end

function AniBlinkStartTime()
	Uptime = os.clock()
end

function SetUpBuildId(buildId)
	UpBuildId = buildId
	AniBlinkStartTime()
end

function OnGUI()
	if not IsInit then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(83.5,37.5,1016.75-50,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	GUI.Label(525.5,48,84.2,30,"主城", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	
	local hero = mHeroManager.GetHero()
	if not hero.harborId then
		return
	end
	
	local harbor = CFG_harbor[hero.harborId]
	local harborsList = mHarborManager.GetHarborInfoList()
	-- local level = harbor.level
	
	GUI.Label(238.65,140,82.7,30,"建筑", GUIStyleLabel.Left_35_Black)
	GUI.Label(418.65-12,140,82.7,30,"等级", GUIStyleLabel.Left_35_Black)
	GUI.Label(576.65-47,140,82.7,30,"花费", GUIStyleLabel.Left_35_Black)
	GUI.Label(704.1-17-15,140,160.95,30,"升级时间", GUIStyleLabel.Left_35_Black)
	GUI.Label(887.65-17,140,82.7,30,"操作", GUIStyleLabel.Left_35_Black)
	
	_,mScrollPositionY = GUI.BeginScrollView(154, 185.8, 900, 421.95, 0, mScrollPositionY, 0, 0, 850, 145 * 5)
		DrawBuild(hero.harborId, 1, 0)
		DrawBuild(hero.harborId, 2, 145)
		DrawBuild(hero.harborId, 3, 145 * 2)
		DrawBuild(hero.harborId, 4, 145 * 3)
		DrawTavern(hero.harborId, 5, 145 * 4)
	GUI.EndScrollView()
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn19_1")
	GUI.DrawTexture(537,605,59,16,image)
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
	end
end

function DrawBuild(harborId, buildId, y) -- 画出的单个建筑管理框
	local cfg_Harbor = CFG_harbor[harborId]
	local level = cfg_Harbor.level
	local harborsList = mHarborManager.GetHarborInfoList()
	local harborInfo = harborsList[harborId]
	local cfg_buildDesc = CFG_buildDesc[buildId]
	
	if harborInfo and harborInfo.buildInfos[buildId] then
		level = harborInfo.buildInfos[buildId].level
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,830,130.4,image)
	 
	local image = mAssetManager.GetAsset("Texture/Icon/Build/"..cfg_buildDesc.icon, AssetType.Icon) -- 绘制能够点击的建筑图标
	if GUI.TextureButton(22, 22+y, 85, 85, image) then
		mBuildViewPanel.SetData(buildId, level) -- 写入信息
		mPanelManager.Show(mBuildViewPanel)
	end
	-- 升级光效序列帧
	if buildId == UpBuildId then
		GUI.FrameAnimation_Once(0, 0+y, 128, 128,'upLevelStar',Uptime,9,0.1)	
	end
	
	GUI.Label(110, y+44.2, 74.2, 30, cfg_buildDesc.name, GUIStyleLabel.Left_35_Redbean_Art) -- 名字
	GUI.Label(280, y+54.2, 16.2, 30, level, GUIStyleLabel.Center_25_Black)  -- 等级
	
	
	local cost = 0
	local cd = 0
	if level < ConstValue.BuildMaxLevel then
		local cfg_buildUp = CFG_buildUp[level+1]
		cost = cfg_buildUp.price
		cd = cfg_buildUp.time
		local costStr = mCommonlyFunc.GetShortNumber(cost)
		local cdStr = mCommonlyFunc.GetChnTime(cd)
		GUI.Label(418-33, y+54.2, 52.2, 30, costStr, GUIStyleLabel.Center_25_Black) -- 升级花费
		GUI.Label(548-15, y+54.2, 112.2, 30, cdStr, GUIStyleLabel.Center_25_Black) -- 升级CD
	end
	
	if not mHarborManager.HarborIsMy() then -- 是否为己方港口
		GUI.Label(687,y+55,130.55,64.8,"不属于本势力", GUIStyleLabel.Center_25_Gray_Art)
	elseif not harborInfo then
		GUI.Label(692,y+40.2,130.55,64.8,"数据获取中", GUIStyleLabel.Center_25_Lime_Art, Color.Black)
	elseif harborInfo.buildInfos[buildId].cd > 0 then
		local cd = harborInfo.buildInfos[buildId].cd + harborInfo.buildInfos[buildId].updateTime - os.oldClock -- 升级倒计时
		-- print(cd)
		local csStr = mCommonlyFunc.GetFormatTime(cd) -- 转化为时间格式
		-- print(csStr)
		GUI.Label(707.9,y+99.5,104.2,45,csStr, GUIStyleLabel.Center_25_Red, Color.Black)
		if GUI.Button(692,y+38.2,130.55,64.8,Language[140], GUIStyleButton.ShortOrangeArtBtn) then -- 加速按钮
			if harborInfo.masterType == 1 then
				local hero = mHeroManager.GetHero()
				if hero.post < 2 then
					mSystemTip.ShowTip("只有盟主与副盟主才可进行该操作")
					return
				end
			end
		
			local money = mCommonlyFunc.CdToMoney(cd)--加速所需元宝
			function OkFunc(showTip)
				if not mCommonlyFunc.HaveGold(money) then
					return
				end
				RequestAddSpeed(buildId)
				mCostTip = not showTip
			end
			if mCostTip then
				mSelectAlert.Show("是否花费"..money.."元宝,快速完成？", OkFunc)
			else
				if not mCommonlyFunc.HaveGold(money) then
					return
				end
				RequestAddSpeed(buildId)
			end
		end
		if	cd < 0.5 then
			SetUpBuildId(buildId) --升级建筑
		end
	else
		if level >= ConstValue.BuildMaxLevel then
			GUI.Label(380,y+43,350,64.8,"已达最高等级", GUIStyleLabel.Center_40_Lime_Art, Color.Black)
		else
			if GUI.Button(692,y+38.2,130.55,64.8,Language[115], GUIStyleButton.ShortOrangeArtBtn) then -- 点击升级
				if buildId ~= 1 then
					local hero = mHeroManager.GetHero()
					local harborLevel = mHarborManager.GetBuildLevel(hero.harborId, 1)
					local buildLevel = mHarborManager.GetBuildLevel(hero.harborId, buildId)
					if buildLevel >= harborLevel then
						mSystemTip.ShowTip("主城等级太低,无法升级该建筑")
						return
					end
				end
				
				if CouldUpByCard(harborId, buildId) then -- 建筑升级卡
					function okFunc()
						RequestUpByCard(buildId)
					end
					
					function cancelFunc()
						RequestUp(harborId, cost, buildId)
					end
					mAlert.Show("是否使用建筑升级卡,直接升级该建筑?(达到限制等级会失败)",okFunc,cancelFunc)
				else
					RequestUp(harborId, cost, buildId)
				end
				
			end
		end
	end
end

function DrawTavern(harborId, buildId, y) -- 酒馆
	local cfg_buildDesc = CFG_buildDesc[buildId]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,830,130.4,image)
	
	
	local image = mAssetManager.GetAsset("Texture/Icon/Build/"..cfg_buildDesc.icon, AssetType.Icon)
	if GUI.TextureButton(22, 22+y, 85, 85, image) then
		mBuildViewPanel.SetData(buildId, 0)
		mPanelManager.Show(mBuildViewPanel)
	end
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg10_1")
	-- GUI.DrawTexture(18,y+30.55,84,84,image)

	GUI.Label(110, y+44.2, 74.2, 30, cfg_buildDesc.name, GUIStyleLabel.Left_35_Redbean_Art)
	GUI.Label(280, y+54.2, 16.2, 30, "无", GUIStyleLabel.Center_25_Black)
	GUI.Label(418-33, y+54.2, 52.2, 30, "无", GUIStyleLabel.Center_25_Black)
	GUI.Label(548, y+54.2, 54.2, 30, "无", GUIStyleLabel.Center_25_Black)
	GUI.Label(727, y+54.2, 54.2, 45, "无需升级", GUIStyleLabel.Center_25_Gray_Art)
end

function RequestUp(harborId, cost, buildId) -- 升级建筑
	local harborsList = mHarborManager.GetHarborInfoList()
	local harborInfo = harborsList[harborId]
	if harborInfo.masterType == 0 then
		if not mCommonlyFunc.HaveMoney(cost) then
			return
		end
	else
		local hero = mHeroManager.GetHero()
		if hero.post < 2 then
			mSystemTip.ShowTip("只有盟主与副盟主才可进行该操作")
			return
		end
		if not mCommonlyFunc.HaveFamilyMoney(math.floor(cost/10000)) then
			return
		end
	end
	
	
	for k,buildInfo in pairs(harborInfo.buildInfos) do
		if buildInfo.cd > 0 then
			local cfg_buildDesc = CFG_buildDesc[k]
			mSystemTip.ShowTip("正在提升"..cfg_buildDesc.name.."等级")
		end
	end
	
	-- AppearEvent(nil, EventType.CheckAllTask)
	-- print("RequestUp", buildId)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.HARBOR)
	ByteArray.WriteByte(cs_ByteArray,ConstValue.BuildUpPack[buildId])
	mNetManager.SendData(cs_ByteArray)
end

function RequestUpByCard(buildId) -- 升级卡升级建筑
	print("RequestUpByCard", buildId)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.HARBOR)
	ByteArray.WriteByte(cs_ByteArray,Packat_Harbor.CLIENT_REQUEST_SPECIAL_UP_BUILDING)
	ByteArray.WriteByte(cs_ByteArray,buildId)
	mNetManager.SendData(cs_ByteArray)
	SetUpBuildId(buildId) --升级建筑
end

function CouldUpByCard(harborId, buildId)  -- 检测用户是否有建筑升级卡
	local cfg_harbor = CFG_harbor[harborId]
	local buildLevel = mHarborManager.GetBuildLevel(harborId, buildId)--曼森海26级以下建筑升级
	if mItemManager.GetItemCountById(191) > 0 and (cfg_harbor.mapId == 2) and buildLevel < 26 then
		return true
	end
end

function RequestAddSpeed(buildId) -- 请求加速完成
	-- print("RequestAddSpeed",buildId)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.HARBOR)
	ByteArray.WriteByte(cs_ByteArray,ConstValue.BuildFastUpPack[buildId])
	mNetManager.SendData(cs_ByteArray)
	SetUpBuildId(buildId) --升级建筑
	-- print("加速升级-------------------")
end