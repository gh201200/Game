local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty = ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty
local AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField = 
AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil
-- 
local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mPanelManager = nil
local mHarborManager = nil
local mHarborSignupPanel = nil
local mRechargePanel = nil
local mAlert = nil
local mSystemTip = nil
local mActivityPanel = nil

module("LuaScript.View.Panel.Activity.CollectTreasureMap.CollectTreasureMapPanel")

local mStr = "活动目标：打败宝图护卫\n活动时间：<color=lime>13:00~13:30</color>     <color=lime>21:10~22:00</color>\n活动地点：<color=#00ff00>悉尼</color>附近\n活动奖励：攻击怪物可获得各种品质藏宝图残片。"

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	-- 
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mHarborSignupPanel = require "LuaScript.View.Panel.Activity.HarborBattle.HarborSignupPanel"
	mRechargePanel = require "LuaScript.View.Panel.Recharge.RechargePanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	mActivityPanel = require "LuaScript.View.Panel.Activity.ActivityPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	
	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/collectTreasureMap")
	GUI.DrawTexture(80,100,1024,512,image)
	
	GUI.Label(366,318,650,30,mStr, GUIStyleLabel.Left_25_White_WordWrap, Color.Black)
	
	if GUI.Button(764, 370, 128, 32, nil, GUIStyleButton.MoveBtn_3) then
		mHeroManager.Goto(0, 15440, 4287)
		mActivityPanel.Close()
		mSystemTip.ShowTip("前往活动地点附近")
	end
	if GUI.Button(892, 370, 128, 32, nil, GUIStyleButton.FlyBtn_2) then
		mHeroManager.RequestFly(0, 15440, 4287, 0)
		mActivityPanel.Close()
	end
end