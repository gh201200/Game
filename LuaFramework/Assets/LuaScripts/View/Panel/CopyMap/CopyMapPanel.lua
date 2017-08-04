local _G,Screen,Language,GUI,ByteArray,print,Texture2D,Input,math,Event,UnityEventType,MouseButton = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,Input,math,Event,UnityEventType,MouseButton
local PackatHead,Packat_Account,Packat_Player,require,KeyCode,pairs,table = 
PackatHead,Packat_Account,Packat_Player,require,KeyCode,pairs,table
local GUIStyleLabel,Color,SceneType,GUIStyleButton = GUIStyleLabel,Color,SceneType,GUIStyleButton
local CFG_copyMapLevel,CFG_copyMap = CFG_copyMapLevel,CFG_copyMap
local AssetType,EventType = AssetType,EventType
local mAssetManager = nil
local mNetManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mCreateHeroPanel = nil
local mAccountManager = nil
local mMainPanel = nil
local mHeroManager = nil
local mCopyMapManager = nil
local mCopyMapViewPanel = nil
local mCopyMapCleanPanel = nil
module("LuaScript.View.Panel.CopyMap.CopyMapPanel")
notAutoClose = true
FullWindowPanel = true

local mCopyMapLevel = 1
local mShowCopyMapList = nil
function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mCreateHeroPanel = require "LuaScript.View.Panel.Login.CreateHeroPanel"
	mAccountManager = require "LuaScript.Control.Data.AccountManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mCopyMapViewPanel = require "LuaScript.View.Panel.CopyMap.CopyMapViewPanel"
	mCopyMapManager = require "LuaScript.Control.Data.CopyMapManager"
	mCopyMapCleanPanel = require "LuaScript.View.Panel.CopyMap.CopyMapCleanPanel"
	mEventManager = require "LuaScript.Control.EventManager"
	
	mEventManager.AddEventListen(nil, EventType.RefreshCopyMap, Display)
	
	IsInit = true
end

function Display()
	mCopyMapLevel = mCopyMapManager.GetMaxCopyMapLevel()
	mShowCopyMapList = GetCopyMapList(mCopyMapLevel)
	
	if mCopyMapManager.GetCleaning() then
		local cleanInfo = mCopyMapManager.GetCleanInfo()
		mCopyMapCleanPanel.SetData(cleanInfo.id)
		mPanelManager.Show(mCopyMapCleanPanel)
	end
end

function OnGUI()
    
	local hero = mHeroManager.GetHero()
	if hero.SceneType == SceneType.Battle then
		return
	end
	
	if not IsInit then
		return
	end
	local cfg_copyMapLevel = CFG_copyMapLevel[mCopyMapLevel]
	local image = mAssetManager.GetAsset("Texture/CopyMap/"..cfg_copyMapLevel.background,AssetType.CopyMap)
	GUI.DrawPackerTexture(image)

	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg20_1") -- 上部标题
	GUI.DrawTexture(426,0,332,111,image)
	GUI.Label(513,7.35,154,30,cfg_copyMapLevel.name,GUIStyleLabel.Center_35_LightGreen_Art)
	
	local maxCopyMapLevel = mCopyMapManager.GetMaxCopyMapLevel()
	for k,v in pairs(mShowCopyMapList) do -- 绘制副本入口
		local image = mAssetManager.GetAsset("Texture/Icon/SceneShip/"..v.icon, AssetType.Icon) 
		GUI.DrawTexture(v.x-12,v.y-12,150,150, image)--副本贴图
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg20_2") 
		GUI.DrawTexture(v.x-23,v.y-38,174,67, image)--副本名字背景
		GUI.Label(v.x+23,v.y-22,74,30,v.name,GUIStyleLabel.MCenter_30_Redbean_Art)
		if  k == #mShowCopyMapList and mCopyMapLevel == maxCopyMapLevel then
		    GUI.FrameAnimation(v.x +35,v.y+60,64,64,'CopyMapTip',7,0.1)
		end
		if GUI.TextureButton(v.x-12,v.y-20,150,165) then -- 透明按钮
			mCopyMapViewPanel.SetData(v.id)
			mPanelManager.Show(mCopyMapViewPanel)
		end
	end
	
	if mCopyMapLevel > 1 and GUI.Button(0,173,93,143,nil, GUIStyleButton.LeftBtn_3) then  --切换到上一大关
		mCopyMapLevel = mCopyMapLevel - 1
		mShowCopyMapList = GetCopyMapList(mCopyMapLevel)
	end
	
	-- local maxCopyMapLevel = mCopyMapManager.GetMaxCopyMapLevel()
	-- print(maxCopyMapLevel .. '能进入的最高副本等级')
	if mCopyMapLevel < maxCopyMapLevel and GUI.Button(1043,173,93,143,nil, GUIStyleButton.RightBtn_3) then  --切换到下一大关
		mCopyMapLevel = mCopyMapLevel + 1
		mShowCopyMapList = GetCopyMapList(mCopyMapLevel)
	end
	
	if GUI.Button(1059,-3,77,63,nil, GUIStyleButton.CloseBtn) then -- 关闭面板
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
	end
	
end

function GetCopyMapList(level) -- 获取当前等级副本的信息
	local maxCopyId = mCopyMapManager.GetMaxCopyMapId()
	local copyMapList = {}
	for k,cfg_copyMap in pairs(CFG_copyMap) do
		if cfg_copyMap.level == level and maxCopyId + 1 >= cfg_copyMap.id then
			table.insert(copyMapList, cfg_copyMap)
		end
	end
	return copyMapList
end