local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,GUIStyleButton,ActionType,AssetPath,SceneType = 
Color,os,ConstValue,pairs,math,GUIStyleButton,ActionType,AssetPath,SceneType

local mPanelManager = nil
local mCommonlyFunc = nil
local mGUIStyleManager = nil
local mAssetManager = nil
local mLoadPanel = nil
local mHeroManager = nil
local mAlert = nil
local mActionManager = nil
local mSetManager = nil
local mProtectPanel = nil

module("LuaScript.View.Panel.Main.Protect") -- 主界面战斗/和平模式切换信息

function Init()
	
	mPanelManager = require "LuaScript.Control.PanelManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mLoadPanel = require "LuaScript.View.Panel.LoadPanel"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mAlert = require "LuaScript.View.Alert.Alert"
	mActionManager = require "LuaScript.Control.ActionManager"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mProtectPanel = require "LuaScript.View.Panel.View.Guide.ProtectPanel"
end

function OnGUI()

	local hero = mHeroManager.GetHero()
	
	if not hero.protectState or not mSetManager.GetProtectState() then
		visible = false
		return
	end
	if hero.SceneType ~= SceneType.Normal then
		visible = false
		return
	end
	visible = true

	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/p34")
	GUI.DrawTexture(828,15,290,55,image)
	local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_Protect)
	GUI.DrawTexture(819,5,47,66,image)
	
	local time = hero.protectTime + hero.protectUpdateTime - os.oldClock
	local timeStr = mCommonlyFunc.GetFormatTime(time)
	GUI.Label(877,31,0,50,"保护时间: "..timeStr,GUIStyleLabel.Left_25_Lime)
	
	-- if GUI.Button(15,165,70,70,nil,GUIStyleButton.Transparent) then
		-- mPanelManager.Show(mProtectPanel)
	-- end
end
