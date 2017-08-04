local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os
local CFG_ship,CFG_buildDesc,ConstValue,GUIStyleButton,EventType = 
CFG_ship,CFG_buildDesc,ConstValue,GUIStyleButton,EventType
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
local mFamilyManager = nil
local mEventManager = nil
local mAlert = nil

module("LuaScript.View.Panel.Family.FamilySetPostPanel") -- 任命界面
local mMember = nil
panelType = ConstValue.AlertPanel
local mPostList = {
	{name ="盟主", desc="联盟的主宰", },
	{name ="副盟主", desc="联盟成员的管理者",},
	{name ="成员", desc="联盟中得忠实力量",},
}

function Init()
	mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mAlert = require "LuaScript.View.Alert.Alert"
	mEventManager = require "LuaScript.Control.EventManager"
	
	mEventManager.AddEventListen(nil, EventType.FamilyDel, FamilyDel)
	IsInit = true
end

function FamilyDel()
	mPanelManager.Hide(OnGUI)
end

function SetData(member)
	mMember = member
end

function OnGUI()
	if not IsInit then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg2_2")
	GUI.DrawTexture(309.65,157.2,580.7,349,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(357.95,290,484.05,170,image, 0, 0, 1, 1, 15, 15, 15, 15)
	
	
	GUI.Label(484.85,190.7,249.2,20, mMember.name, GUIStyleLabel.Center_40_Redbean_Art)

	GUI.Label(369.9, 240.5, 74.2, 45, "职位", GUIStyleLabel.Left_30_Black)
	GUI.Label(531.9, 240.5, 74.2, 45, "介绍", GUIStyleLabel.Left_30_Black)
	GUI.Label(748.9, 240.5, 74.2, 45, "操作", GUIStyleLabel.Left_30_Black)

	GUI.Label(366.9, 306.5, 60.2, 45, mPostList[1].name, GUIStyleLabel.Left_25_Black)
	GUI.Label(491.9, 306.5, 100, 45, mPostList[1].desc, GUIStyleLabel.Left_25_Black)
	if GUI.Button(731.9, 297.5, 111, 53, "任命",GUIStyleButton.ShortOrangeArtBtn) then
		function OkFunc()
			RequestSet(3)
		end
		mAlert.Show("禅让之后自己将变为成员，确定任命该玩家为盟主？",OkFunc)
	end
	
	GUI.Label(366.9, 362.5, 150, 45, mPostList[2].name, GUIStyleLabel.Left_25_Black)
	GUI.Label(491.9, 362.5, 100, 45, mPostList[2].desc, GUIStyleLabel.Left_25_Black)
	if GUI.Button(731.9, 354.5, 111, 53, "任命",GUIStyleButton.ShortOrangeArtBtn) then
		RequestSet(2)
	end
	
	GUI.Label(366.9, 414, 150, 45, mPostList[3].name, GUIStyleLabel.Left_25_Black)
	GUI.Label(491.9, 414, 100, 45, mPostList[3].desc, GUIStyleLabel.Left_25_Black)
	if GUI.Button(731.9, 409.5, 111, 53, "任命",GUIStyleButton.ShortOrangeArtBtn) then
		RequestSet(1)
	end
	
	
	if GUI.Button(821.5, 148.5, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end

function RequestSet(post)
	-- print("RequestSet")
	mFamilyManager.RequestSetPost(mMember.id, post)
	mPanelManager.Hide(OnGUI)
end