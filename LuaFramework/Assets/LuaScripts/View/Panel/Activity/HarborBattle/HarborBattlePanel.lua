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
local mActivityManager = nil

module("LuaScript.View.Panel.Activity.HarborBattle.HarborBattlePanel")
local mStr = "活动目标：攻占港口\n报名时间：<color=lime>每周二四六日  16:00~19:00</color>\n活动时间：<color=lime>周二四六日  20:00~21:00</color>\n活动奖励：可获得联盟贡献、强化石、元宝、活力丹等。"


function Init()
	-- print(111)
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mHarborSignupPanel = require "LuaScript.View.Panel.Activity.HarborBattle.HarborSignupPanel"
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	IsInit = true
end

-- function Display()
	-- mHarborManager.RequestHarborBattleState()
-- end

function SetData(type, harborId, money)
	mType = type
	mHarborId = harborId
	mMoney = money + 10
	mMinMoney = money + 1
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/harborBattle")
	GUI.DrawTexture(80,100,1024,512,image)
	GUI.Label(366,318,650,30,mStr, GUIStyleLabel.Left_25_White_WordWrap, Color.Black)
	-- GUI.Label(295,250,84.2,30,Language[191], GUIStyleLabel.Left_20_White, Color.Black)
	-- local mHarborBattleState = mHarborManager.GetHarborBattleState()
	local activity = mActivityManager.GetActivity(ActivityType.HarborBattle)

	local oldEnabled = GUI.GetEnabled()
	if not activity.state then
		GUI.SetEnabled(false)
	end
	if GUI.Button(800, 188, 121, 121, nil, GUIStyleButton.SignupBtn) then
		mPanelManager.Show(mHarborSignupPanel)
	end
	if not activity.state then
		GUI.SetEnabled(oldEnabled)
	end
end
	