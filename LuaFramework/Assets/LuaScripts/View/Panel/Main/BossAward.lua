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
local mBattleAwardPanel = require "LuaScript.View.Panel.Battle.BattleAwardPanel"

module("LuaScript.View.Panel.Main.BossAward")
local mAwardList = {}

function Init()

end


function AddAward(award)
	table.insert(mAwardList, award)
end

function OnGUI()
	if not mAwardList[1] then
		return
	end
	
	if GUI.Button(865,430,76,78,nil,GUIStyleButton.BossAward) then
		mBattleAwardPanel.SetData(mAwardList[1])
		mPanelManager.Show(mBattleAwardPanel)
		
		table.remove(mAwardList, 1)
	end
end
