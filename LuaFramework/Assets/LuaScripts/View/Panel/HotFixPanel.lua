local GUI,RunLuaScript,Language,_G,os,print,Application,KeyCode,Input,Event,UnityEventType,Vector2,GUIStyleButton,cs_Base, EventType = 
GUI,RunLuaScript,Language,_G,os,print,Application,KeyCode,Input,Event,UnityEventType,Vector2,GUIStyleButton,cs_Base, EventType
local Directory,ConstValue,math,GUIUtility,Color,Loader,require,tostring,GUIStyleLabel,platform,SceneType = 
Directory,ConstValue,math,GUIUtility,Color,Loader,require,tostring,GUIStyleLabel,platform,SceneType
local VersionCode,CleanCache,CFG_star,ItemType,DrawItemCell = VersionCode,CleanCache,CFG_star,ItemType,DrawItemCell
local mPanelManager = require "LuaScript.Control.PanelManager"
local mAlertManager = require "LuaScript.View.Alert.Alert"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCameraManager = require "LuaScript.Control.CameraManager"
local mPathManager = nil
local mActivityManager = nil
local mHeroManager = nil
local mClosePanel = nil
local mLoadPanel = nil
local mCommonlyFunc = nil
local mSDK = nil
local mAlert = nil
local mSystemTip = nil
local mGMChatPanel = nil
local mTimer = require "LuaScript.Common.Timer"
local mEventManager = require "LuaScript.Control.EventManager"
module("LuaScript.View.Panel.HotFixPanel") 
panelType = ConstValue.TipPanel
notAutoClose = true

starid = 1

function Init()
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mPathManager = require "LuaScript.Control.Scene.PathManager"
	mClosePanel = require "LuaScript.View.Panel.ClosePanel"
	mLoadPanel = require "LuaScript.View.Panel.LoadPanel"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mSDK = require "LuaScript.Mode.Object.SDK"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mGMChatPanel = require "LuaScript.View.Panel.Chat.GMChatPanel"
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	mEventManager.AddEventListen(nil, EventType.ShowExitPanel, ShowExitPanel)
end

function ShowExitPanel()
	if mLoadPanel.visible then
		return
	end
	mAlertManager.Show("是否要退出游戏?", mCommonlyFunc.QuitGame)
end

function OnGUI()
	-- local image = mAssetManager.GetAsset("Texture/Gui/black")
	-- GUI.DrawTexture(0, 0,100,100,image)
	-- DrawItemCell(CFG_star[starid], ItemType.Star, 0, 0, 100, 100)
	
	if not mAlert.visible and Input.GetKeyDown(KeyCode.Escape) then
		local mHero = mHeroManager.GetHero()
		if mHero and mHero.SceneType == SceneType.Battle then
			mSystemTip.ShowTip("战斗中不能退出游戏")
			return
		end
		if platform == "yj" or platform == "91" or platform == "91IOS" or (platform == "uc" and VersionCode > 6) then
			mSDK.ExitGame()
		else
			if mLoadPanel.visible then
				return
			end
			mAlertManager.Show("是否要退出游戏?", mCommonlyFunc.QuitGame)
		end
	end
	if not _G.IsDebug then
		return
	end
	
	
	local serverTime = mActivityManager.GetServerTime()
	if serverTime then
		GUI.Label(0,525-142-120,111, 53,os.date("%y-%m-%d %H-%M-%S",serverTime),GUIStyleLabel.Left_20_White)
	end
	
	local hero = mHeroManager.GetHero()
	-- if hero then
		-- GUI.Label(0,525-142-140,111, 53,hero.x .. " " .. hero.y,GUIStyleLabel.Left_20_White)
	-- end
	
	if GUI.Button(0,525-142-60,111, 53,"GM指令",GUIStyleButton.ShortOrangeBtn) then
		mPanelManager.Show(mGMChatPanel)
	end
	
	if GUI.Button(0,525-142,111, 53, Language[2], GUIStyleButton.ShortOrangeBtn) then
		if not platform then
			RunLuaScript("load")
		else
			HotFix()
		end
	end
	
	-- local csVector3 = Input.GetMousePosition()
	-- csClickPoint = mCameraManager.ScreenPointToWorld(csVector3.x,csVector3.y)
	-- if csClickPoint then
		-- local x = csClickPoint.x
		-- local y = csClickPoint.z
		-- GUI.Label(300,200,100,30, tostring(mPathManager.CouldWalk(x,y,0)),GUIStyleLabel.Left_25_White)
	-- end
	
	-- local t = os.time() - 1
	-- if _G.GUISecondTime[-t] then
		-- GUI.Label(0,0,100,30, "FPS:".._G.GUISecondTime[-t],GUIStyleLabel.Left_25_White)
	-- end

	-- if _G.GUISecondTime[t] then
		-- GUI.Label(0,230+30,100,30, math.floor(_G.GUISecondTime[t]*10000)/10000 ,GUIStyleLabel.Left_25_White)
	-- end

	-- if _G.UpdateSecondTime[t] then
		-- GUI.Label(0,260+30,100,30, math.floor(_G.UpdateSecondTime[t]*10000)/10000 ,GUIStyleLabel.Left_25_White)
	-- end
	
	-- if _G.EventSecondTime[t] then
		-- GUI.Label(0,290+30,100,30, math.floor(_G.EventSecondTime[t]*10000)/10000 ,GUIStyleLabel.Left_25_White)
	-- else
		-- GUI.Label(0,290+30,100,30, 0 ,GUIStyleLabel.Left_25_White)
	-- end
		
end

function HotFix()
	function f(load)
		print("load web hotfix.lua")
		RunLuaScript(load.text)
	end
	CleanCache()
	Loader.Load("http://47.93.230.239/game/hotfix.lua", f, true)
end