local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os
local CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleTextField,GUIStyleButton,string,EventType = 
CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleTextField,GUIStyleButton,string,EventType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mEquipUpPanel = nil
local mHarborPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mCommonlyFunc = nil
local mViewShipPanel = nil
local mFamilyListPanel = nil
local mFamilyManager = nil
local mSystemTip = nil
local mFamilyPanel = nil

module("LuaScript.View.Panel.Family.FamilyCreatePanel")--联盟建立
local mFamilyName = ""
panelType = ConstValue.AlertPanel

function Init()
	mEventManager = require "LuaScript.Control.EventManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mFamilyListPanel = require "LuaScript.View.Panel.Family.FamilyListPanel"
	mFamilyPanel = require "LuaScript.View.Panel.Family.FamilyPanel"
	mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	
	mEventManager.AddEventListen(nil, EventType.FamilyCreate, FamilyCreate)		
	mEventManager.AddEventListen(nil, EventType.FamilyJoin, FamilyCreate)
	IsInit = true
end

function FamilyCreate()
	mPanelManager.Hide(OnGUI)
	-- mPanelManager.Show(mFamilyPanel)
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg31_1")
	GUI.DrawTexture(254.85,183.650,626,332,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(335.65,360,477.5,111,image,0,0,1,1,20,20,20,20)
	GUI.Label(474.85,225,184.2,50,"创建联盟", GUIStyleLabel.Center_45_Redbean_Art)
	
	-- GUI.BeginGroup(200, 20, 800, 200)
		GUI.Label(356.85,298,79.2,49, "名字: ", GUIStyleLabel.Center_30_Black)
		name = GUI.TextField(432.85,286,252,78, mFamilyName, GUIStyleTextField.Left_20_White_Short)
		if string.len(name) <= 6 then
			mFamilyName = name
		end
		if GUI.Button(690.85, 293, 111, 53, "创建", GUIStyleButton.ShortOrangeArtBtn) then
			RequestCreate(mFamilyName)
		end
	-- GUI.EndGroup()
	GUI.Label(357.15,389.5,94.2,300, "花费：100000银两", GUIStyleLabel.Left_30_Black_Art)
	
	if GUI.Button(820.45, 165, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end

function RequestCreate(name)
	if #name <= 0 then
		mSystemTip.ShowTip("名字不能为空")
		return
	end
	local hero = mHeroManager.GetHero()
	if hero.money < 100000 then
		mSystemTip.ShowTip("银两不足")
		return
	end
	-- print("RequestCreate")
	name = mCommonlyFunc.CheckWord(name)
	mFamilyManager.RequestCreate(name)
	
	mPanelManager.Hide(OnGUI)
end