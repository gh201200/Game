local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,GUIStyleButton,ActionType,AssetPath = 
Color,os,ConstValue,pairs,math,GUIStyleButton,ActionType,AssetPath
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mMainPanel = require "LuaScript.View.Panel.Main.Main"
local mLoadPanel = require "LuaScript.View.Panel.LoadPanel"
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mAlert = require "LuaScript.View.Alert.Alert"
local mActionManager = require "LuaScript.Control.ActionManager"
local mPowerUpPanel = require "LuaScript.View.Panel.PowerUp.PowerUpPanel"

module("LuaScript.View.Panel.PowerUp.PowerUpTip")

local mNotShow = false

function ShowTip()
	visible = true
end

function OnGUI(offsetY)
	if not visible or mNotShow then
		return
	end
	
	local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_Bg31_1)
	GUI.DrawTexture(647-65,318+offsetY+40,360,150,image)
	-- GUI.DrawTexture(647-65,318+offsetY+40,360,175,image,0,0,1,1,27,35,27,50)
	
	GUI.Label(697-65,356+offsetY+30,0,50,Language[202],GUIStyleLabel.Left_30_Redbean_Art)
	
	if GUI.Button(683-65, 390+offsetY+40, 133, 60, "不再提示", GUIStyleButton.ShortOrangeBtn) then
		mNotShow = true
		visible = false
	end
	
	if GUI.Button(833-65, 390+offsetY+40, 133, 60, "查看详情", GUIStyleButton.ShortOrangeBtn) then
		visible = false
		mPanelManager.Show(mPowerUpPanel)
		mPanelManager.Hide(mMainPanel)
	end
	
	
	if GUI.Button(943-65, 302+offsetY+40, 77, 63, nil, GUIStyleButton.CloseBtn) then
		visible = false
	end
end
