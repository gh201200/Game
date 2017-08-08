local _G,Screen,Language,GUI,ByteArray,print,Texture2D,Vector2,pairs,CFG_buildDesc,os,ConstValue = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,Vector2,pairs,CFG_buildDesc,os,ConstValue
local PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor,CFG_lab = 
PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor,CFG_lab
local AssetType,string,math,table = AssetType,string,math,table
local mAssetManager = nil
local mNetManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mGUIStyleManager = nil
local mMainPanel = nil
local mTavernPanel = nil
local mShopPanel = nil
local mShipyardPanel = nil
local mLabViewPanel = nil
local mSystemTip = nil
local mHeroManager = nil
local mCommonlyFunc = nil
local mHarborManager = nil
local mLabManager = nil
local mAlert = nil
local mSelectAlert = nil
local mSetManager = nil
local mCostTip = nil
local mItemManager = nil
local mMainPanel = nil
local mSceneManager = nil
local mActivityManager = nil
local serverTime = nil
local BossNumber = 0
local mBossUpdataInfo = {}
local mAwardViewPanel = nil
local CFG_bossAward = CFG_bossAward

local CFG_boss,CFG_Enemy,CFG_EnemyPosition = CFG_boss,CFG_Enemy,CFG_EnemyPosition
module("LuaScript.View.Panel.BossList.BossListPanel") -- BOSS列表所界面
FullWindowPanel = true -- 铺满窗口
local mScrollPositionY = 0

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mTavernPanel = require "LuaScript.View.Panel.Harbor.TavernPanel"
	mShopPanel = require "LuaScript.View.Panel.Harbor.ShopPanel"
	mShipyardPanel = require "LuaScript.View.Panel.Harbor.ShipyardPanel"
	mLabViewPanel = require "LuaScript.View.Panel.Harbor.LabViewPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	mAwardViewPanel = require "LuaScript.View.Panel.BossList.AwardViewPanel"
	mBossUpdataInfo = {}
	
	IsInit = true
end

function Display()
    mPanelManager.Hide(mMainPanel)
	mSceneManager.SetMouseEvent(false)
	mScrollPositionY = 0
end

function GetNewCount() 
    BossNumber = 0
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mBossUpdataInfo = mSceneManager.GetBossListInfo()-- id xxx  time 0 ，1508033222，只要小于服务器时间就是刷了，否则会得到BOSS准确的刷新时间
    for	k , item in pairs(mBossUpdataInfo) do
		if item.BossTime == 0 then
			BossNumber = BossNumber + 1
		end
	end
	return BossNumber
end

function OnGUI()
	if not IsInit then
		return
	end
	
	serverTime = mActivityManager.GetServerTime()
	if not serverTime then
		print('获取服务器时间失败')
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(83.5,37.5,1016.75-50,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	GUI.Label(525.5,48,84.2,30,"BOSS挑战-平定四海", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	
	local hero = mHeroManager.GetHero()
	mBossUpdataInfo = mSceneManager.GetBossListInfo()  
	
	for	k , item in pairs(mBossUpdataInfo) do
	    -- print(item)
	end
	
	GUI.Label(200,140,82.7,30,"BOSS", GUIStyleLabel.Left_35_Black)
	GUI.Label(355,140,82.7,30,"名字", GUIStyleLabel.Left_35_Black)
	GUI.Label(516,140,82.7,30,"战斗力", GUIStyleLabel.Left_35_Black)
	GUI.Label(666,140,160.95,30,"刷新时间", GUIStyleLabel.Left_35_Black)
	GUI.Label(875,140,82.7,30,"操作", GUIStyleLabel.Left_35_Black)
	
	local spacing = 145
	local length = #CFG_boss
	_,mScrollPositionY = GUI.BeginScrollView(154, 185.8, 900, 421.95, 0, mScrollPositionY, 0, 0, 850, spacing * length)
		for boosID=1,length,1 do
			local y = (boosID-1)*spacing
			local showY = y - mScrollPositionY / GUI.modulus
			if showY > -spacing  and showY < spacing*3 then
				DrawLab(CFG_boss[boosID].eid,boosID, y)
			end
		end
	GUI.EndScrollView()
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn19_1")
	GUI.DrawTexture(537,605,59,16,image)
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
	end
end

function DrawLab(bossInfo,boosID,y)
	local BossInfo = CFG_Enemy[bossInfo]
	local BossLevel = CFG_boss[boosID].name
	local BossName = BossInfo.name
	local BossPower = BossInfo.power
	local BossPosition = CFG_EnemyPosition[bossInfo]
	local BossResID = BossInfo.resId
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,835,130.4,image)
	--头像
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..(BossInfo.quality or 1))
	GUI.DrawTexture(20+5, 11+y, 128, 128, image)
	local image = mAssetManager.GetAsset("Texture/Character/Header/"..BossResID, AssetType.Pic)
	GUI.DrawTexture(22+8, 15+y, 100, 100, image)
	GUI.Label(105+25, 92+y, 0, 30,  "Lv:"..(BossInfo.level or Language[162]), GUIStyleLabel.Right_25_White,Color.Black)
	
	--点击查看奖励
	if  GUI.Button(20, 11+y, 128, 128, nil, GUIStyleButton.Transparent) then
		mAwardViewPanel.SetData(0,bossInfo)
		mPanelManager.Show(mAwardViewPanel)
	end

	--名字
	GUI.Label(245, y+54.2, 0, 30, BossName, GUIStyleLabel.Center_25_Brown_Art)
	--等级
	-- GUI.Label(230, y+54.2, 16.2, 30, BossLevel, GUIStyleLabel.Center_25_Black)
	
	
	--战斗力
	GUI.Label(418-33, y+54.2, 52.2, 30,BossPower, GUIStyleLabel.Center_25_Black)
	--刷新倒计时
	local content = "已经刷新"
	
	for	k , item in pairs(mBossUpdataInfo) do
		if item.BossId == bossInfo then
			if item.BossTime > 0 then
				content = mCommonlyFunc.GetFormatTime(item.BossTime - serverTime)
			else
				content = "已经刷新"
			end
		end
	end
	GUI.Label(525, y+54.2, 112.2, 30,content, GUIStyleLabel.Center_25_Black)
	
	
	--传送、导航
	if  GUI.Button(692, y+12, 132, 53, "导航", GUIStyleButton.ShortOrangeArtBtn) then
			mHeroManager.Goto(0, BossPosition.X+50,BossPosition.Y+50)
			mPanelManager.Show(mMainPanel)
			mPanelManager.Hide(OnGUI)
			mSceneManager.SetMouseEvent(true)
	end
	
	if  GUI.Button(692, y+73, 132, 53, "传送", GUIStyleButton.ShortOrangeArtBtn) then
		mHeroManager.RequestFly(0, BossPosition.X-100, BossPosition.Y-100, 0)
	end
end



