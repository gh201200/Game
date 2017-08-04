local _G,Screen,Language,GUI,ByteArray,print,Texture2D,EventType,ActionType = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,EventType,ActionType
local PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor,os,math = 
PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor,os,math

local mAlert = nil
local mAssetManager = nil
local mNetManager = nil
local mPanelManager = nil
local mEventManager = nil
local mSceneManager = nil
local mGUIStyleManager = nil
local mTavernPanel = nil
local mShopPanel = nil
local mShipyardPanel = nil
local mSystemTip = nil
local mHeroManager = nil
local mMainBuildPanel = nil
local mLabPanel = nil
local mShipManager = nil
local mCommonlyFunc = nil
local mCopyMapPanel = nil
local mActionManager = nil
local mHarborManager = nil
local mLoadPanel = nil
local mMainPanel = nil
local mOngoingTask = nil
module("LuaScript.View.Panel.Main.HarborBuild")

notAutoClose = true
local mMaxOffsetY = -130
local offsetY = mMaxOffsetY
local showTime = 0
local autoPanel = nil

function Init()
	mAlert = require "LuaScript.View.Alert.Alert"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mTavernPanel = require "LuaScript.View.Panel.Harbor.TavernPanel"
	mShopPanel = require "LuaScript.View.Panel.Harbor.ShopPanel"
	mShipyardPanel = require "LuaScript.View.Panel.Harbor.ShipyardPanel"
	mMainBuildPanel = require "LuaScript.View.Panel.Harbor.MainBuildPanel"
	mLabPanel = require "LuaScript.View.Panel.Harbor.LabPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mShipManager = require "LuaScript.Control.Data.ShipManager"
	mCopyMapPanel = require "LuaScript.View.Panel.CopyMap.CopyMapPanel"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mActionManager = require "LuaScript.Control.ActionManager"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mLoadPanel = require "LuaScript.View.Panel.LoadPanel"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mOngoingTask = require "LuaScript.View.Panel.Main.OngoingTask"
	
	mEventManager.AddEventListen(nil, EventType.OnLoadStart, loadStart)
	mEventManager.AddEventListen(nil, EventType.OnLoadComplete, ResetMaxOffsetY)
	-- mEventManager.AddEventListen(nil, EventType.IntoHarbor, ResetMaxOffsetY)
	
	IsInit = true
end

function ResetMaxOffsetY()
	showTime = os.oldClock
end

function AutoPanel(panel)
	autoPanel = panel
end

function loadStart()
	showTime = os.oldClock + 555555
end


function OnGUI()
	if not IsInit then
		return
	end
	
	-- offsetY = math.min(offsetY - os.deltaTime*mMaxOffsetY*2, 0)
	local overTime = os.oldClock - showTime
	if mLoadPanel.visible then
		overTime = 0
	end
	-- print(overTime,)
	offsetY = math.min((1-overTime*4) * mMaxOffsetY, 0)
	
	local hero = mHeroManager.GetHero()
	local cfg_harbor = CFG_harbor[hero.harborId]
	if not cfg_harbor then
		return
	end
	
	if overTime > 0.6 and autoPanel then
		mCommonlyFunc.AutoOpenlPanel(autoPanel)
		autoPanel = nil
	end
	
	
	local image = mAssetManager.GetAsset("Texture/Harbor/"..cfg_harbor.background)
	GUI.DrawPackerTexture(image)
	
	-- "酒馆"
	if GUI.Button(360.6+8,offsetY,138,143,nil, GUIStyleButton.TavernBtn) then
		mPanelManager.Hide(mMainPanel)
		mPanelManager.Show(mTavernPanel)
	end
	
	-- 交易所
	if GUI.Button(488.8+8,offsetY,138,143,nil, GUIStyleButton.ShopBtn) then
		RequestIntoShop()
	end
	
	-- 主城
	if GUI.Button(616.8+8,offsetY,138,143,nil, GUIStyleButton.MainBtn)then
		mPanelManager.Hide(mMainPanel)
		mPanelManager.Show(mMainBuildPanel)
	end
	
	-- 研究所
	if GUI.Button(744.8+8,offsetY,138,143,nil, GUIStyleButton.LabBtn) then
		mPanelManager.Hide(mMainPanel)
		mPanelManager.Show(mLabPanel)
	end
	
	-- 船厂
	if GUI.Button(872.8+8,offsetY,138,143,nil, GUIStyleButton.ShipyardBtn) then
		mPanelManager.Hide(mMainPanel)
		mPanelManager.Show(mShipyardPanel)
	end
	-- print(1005,offsetY,128,128,nil)
	-- 出港所
	if GUI.Button(1005,offsetY,128,128,nil, GUIStyleButton.LevelHarborBtn) then
		RequestLeaveHarbor()
	end
end

function RequestIntoShop()
	if mShipManager.CheckDutyShip(SetShipFunc) then
		mPanelManager.Hide(mMainPanel)
		mPanelManager.Show(mShopPanel)
	end
end

function RequestLeaveHarbor()
	if mShipManager.CheckDutyShip(SetShipFunc) then
		mHarborManager.RequestLeaveHarbor()
		mOngoingTask.OpenSwitch(true)
	end
end

function SetShipFunc()
	mPanelManager.Hide(mMainPanel)
end