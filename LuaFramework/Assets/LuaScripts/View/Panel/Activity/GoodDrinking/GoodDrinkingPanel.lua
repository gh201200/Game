local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty = ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty
local AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,ActivityType = 
AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,ActivityType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mPanelManager = nil
local mHarborManager = nil
local mHarborSignupPanel = nil
local mRechargePanel = nil
local mActivityManager = nil
local mAlert = nil

module("LuaScript.View.Panel.Activity.GoodDrinking.GoodDrinkingPanel")

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mHarborSignupPanel = require "LuaScript.View.Panel.Activity.HarborBattle.HarborSignupPanel"
	mRechargePanel = require "LuaScript.View.Panel.Recharge.RechargePanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	
	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end
	local activity = mActivityManager.GetActivity(ActivityType.GoodDrinking)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/goodDrink")
	GUI.DrawTexture(80,100,1024,512,image)
	if activity.state and GUI.Button(80,100,900,350,nil,GUIStyleButton.Transparent) then
		mActivityManager.RequestDrink()
	end
	if activity.state then
		GUI.Button(723, 151, 155, 134, nil, GUIStyleButton.DrinkingBtn)
	else
		GUI.Button(723, 151, 155, 134, nil, GUIStyleButton.DrinkingBtn_2)
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg36_1")
	GUI.DrawTexture(611,315,182,124,image)
	GUI.DrawTexture(828,315,182,124,image)
	
	if activity.drink1 then
		GUI.Label(611,368,179,30,"中午\n(12点~13点)\n已参与", GUIStyleLabel.MCenter_30_Orange_Art, Color.Black)
	elseif activity.state1 then
		GUI.Label(611,368,179,30,"中午\n(12点~13点)\n可参与", GUIStyleLabel.MCenter_30_Lime_Art, Color.Black)
	else
		GUI.Label(611,368,179,30,"中午\n(12点~13点)", GUIStyleLabel.MCenter_30_Gray2_Art)
	end
	
	if activity.drink2 then
		GUI.Label(828,368,179,30,"下午\n(18点~19点)\n已参与", GUIStyleLabel.MCenter_30_Orange_Art, Color.Black)
	elseif activity.state2 then
		GUI.Label(828,368,179,30,"下午\n(18点~19点)\n可参与", GUIStyleLabel.MCenter_30_Lime_Art, Color.Black)
	else
		GUI.Label(828,368,179,30,"下午\n(18点~19点)", GUIStyleLabel.MCenter_30_Gray2_Art)
	end	
end