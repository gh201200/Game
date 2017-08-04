local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,GUIStyleButton,ActionType,AssetPath,SceneType = 
Color,os,ConstValue,pairs,math,GUIStyleButton,ActionType,AssetPath,SceneType
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mBattleListPanel = require "LuaScript.View.Panel.View.BattleListPanel"
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mBattleFieldManager = require "LuaScript.Control.Data.BattleFieldManager"
module("LuaScript.View.Tip.BattleListTip")


function OnGUI()
	-- print(1)
	local hero = mHeroManager.GetHero()
	
	local battleList = mBattleFieldManager.GetBattleFieldList()
	if not battleList[1] then
		return
	end
	
	local offsetX = 0
	local offsetY = 0
	if GUI.Button(925+offsetX,425+offsetY,88,88,nil,GUIStyleButton.BattleList) then
		mPanelManager.Show(mBattleListPanel)
	end
end
