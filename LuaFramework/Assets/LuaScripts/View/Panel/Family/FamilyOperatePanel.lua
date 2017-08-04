local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os
local CFG_ship,CFG_buildDesc,ConstValue,GUIStyleButton,EventType = 
CFG_ship,CFG_buildDesc,ConstValue,GUIStyleButton,EventType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mSceneManager = nil
local mHeroManager = nil
local mCommonlyFunc = nil
local mFamilySetPostPanel = nil
local mFriendChatPanel = nil
local mFamilyManager = nil
local mAlert = nil
local mCharViewPanel = nil
local mEventManager = nil

module("LuaScript.View.Panel.Family.FamilyOperatePanel") --点击成员弹出操作面板
local mMember = nil
panelType = ConstValue.AlertPanel
function SetData(member)
	mMember = member
end

function Init()
	mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mFamilySetPostPanel = require "LuaScript.View.Panel.Family.FamilySetPostPanel"
	mFriendChatPanel = require "LuaScript.View.Panel.Friend.FriendChatPanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	mCharViewPanel = require "LuaScript.View.Panel.View.CharViewPanel"
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
	GUI.DrawTexture(309.65,157.2,580.7,349,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(365,237.2,475,132.8,image, 0, 0, 1, 1, 15, 15, 15, 15)
	
	GUI.Label(484.85,190.7,249.2,20, mMember.name, GUIStyleLabel.Center_40_Redbean_Art)
	
	GUI.Label(391.2, 263.5, 150, 45, "职位: "..ConstValue.PostName[mMember.post], GUIStyleLabel.Left_25_Black)
	GUI.Label(610, 263.5, 100, 45, "贡献: "..mMember.contribute, GUIStyleLabel.Left_25_Black)
	GUI.Label(391.2, 315.5, 100, 45, "等级: "..mMember.level, GUIStyleLabel.Left_25_Black)
	GUI.Label(610, 315.5, 100, 45, "战斗力: "..mMember.power, GUIStyleLabel.Left_25_Black)
	
	local hero = mHeroManager.GetHero()
	if hero.name == mMember.name then
		GUI.SetEnabled(false)
	end
	
	if GUI.Button(358, 395, 111, 53, "私聊", GUIStyleButton.ShortOrangeArtBtn) then
		mPanelManager.Hide(OnGUI)
		mFriendChatPanel.SetData(mMember)
		mPanelManager.Show(mFriendChatPanel)
	end
	
	if GUI.Button(485, 395, 111, 53, "查看", GUIStyleButton.ShortOrangeArtBtn) then
		mCharViewPanel.SetData(mMember)
		mPanelManager.Show(mCharViewPanel)
		mPanelManager.Hide(OnGUI)
	end
	
	local oldEnabled = GUI.GetEnabled()
	if hero.post < 3 then
		GUI.SetEnabled(false)
	end
	if GUI.Button(614.1, 395, 111, 53, "任命", GUIStyleButton.ShortOrangeArtBtn) then
		mPanelManager.Hide(OnGUI)
		mFamilySetPostPanel.SetData(mMember)
		mPanelManager.Show(mFamilySetPostPanel)
	end
	if hero.post < 3 then
		GUI.SetEnabled(oldEnabled)
	end
	
	if hero.post <= mMember.post then
		GUI.SetEnabled(false)
	end
	if GUI.Button(735.9, 395, 111, 53, "开除", GUIStyleButton.ShortOrangeArtBtn) then
		KickMember()
		mPanelManager.Hide(OnGUI)
	end
	if hero.post <= mMember.post then
		GUI.SetEnabled(oldEnabled)
	end
	
	if hero.name == mMember.name then
		GUI.SetEnabled(true)
	end
	
	if GUI.Button(821.5, 148.5, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end

function KickMember() -- 踢人
	function OkFunc()
		mFamilyManager.RequestKick(mMember.id)
	end
	if mMember.contribute > 0 then
		mAlert.Show("开除后5小时内该成员不能加入联盟,本联盟资金将扣除"..mMember.contribute.."万,是否确定开除"..mMember.name.."?", OkFunc)
	else
		mAlert.Show("开除后5小时内该成员不能加入联盟,是否确定开除"..mMember.name.."?", OkFunc)
	end
end
