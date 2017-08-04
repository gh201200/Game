local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os
local CFG_ship,CFG_buildDesc,ConstValue,GUIStyleButton,string,CsStringSub,EventType = 
CFG_ship,CFG_buildDesc,ConstValue,GUIStyleButton,string,CsStringSub,EventType
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
local mAlert = nil
local mSystemTip = nil
local mEventManager = nil

module("LuaScript.View.Panel.Family.FamilyNoticePanel") -- 联盟公告栏编辑页面
panelType = ConstValue.AlertPanel
local mNotice = nil

function SetData(notice)
	mNotice = notice
end

function Init()
	mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mEventManager = require "LuaScript.Control.EventManager"
	
	mEventManager.AddEventListen(nil, EventType.FamilyDel, FamilyDel)
	
	IsInit = true
end

function FamilyDel()
	mPanelManager.Hide(OnGUI)
end

function OnGUI()
	if not IsInit then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg2_2")
	GUI.DrawTexture(278,118,618.6,387.3,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Text/notice")
	GUI.DrawTexture(510,144,145,38,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/notice")
	GUI.DrawTexture(343,188,490,208,image)
	
	
	local mNewNotice = GUI.TextArea(360,208,454,200,mNotice,GUIStyleLabel.Left_25_White_WordWrap) -- 输入框
	if string.len(mNewNotice) > ConstValue.NoticeMaxLength then
		if CsStringSub then
			mNewNotice = CsStringSub(mNewNotice,0,ConstValue.NoticeMaxLength)
		else
			return
		end
	end
	mNotice = mNewNotice
	
	if GUI.Button(408, 408, 111, 53, "确定",GUIStyleButton.ShortOrangeArtBtn) then
		if #mNotice <= 0 then
			mSystemTip.ShowTip("公告不能为空")
			return
		end
		mNotice = mCommonlyFunc.CheckWord(mNotice)
		mFamilyManager.RequestChangeNotice(mNotice)
		mPanelManager.Hide(OnGUI)
	end
	if GUI.Button(652, 408, 111, 53, "取消",GUIStyleButton.ShortOrangeArtBtn) then
		mPanelManager.Hide(OnGUI)
	end
	
	
	if GUI.Button(818, 108, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end