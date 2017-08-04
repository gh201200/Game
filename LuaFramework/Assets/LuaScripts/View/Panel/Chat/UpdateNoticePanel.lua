local GUI,RunLuaScript,Language,_G,os,print,Application,KeyCode,Input,Event,UnityEventType,Vector2,SceneType,require,EventType = 
GUI,RunLuaScript,Language,_G,os,print,Application,KeyCode,Input,Event,UnityEventType,Vector2,SceneType,require,EventType
local pairs,ConstValue,Directory,GUIStyleButton,GUIStyleTextField,Color,GUIStyleLabel,string,CFG_item,table = 
pairs,ConstValue,Directory,GUIStyleButton,GUIStyleTextField,Color,GUIStyleLabel,string,CFG_item,table
local Screen,UpdateNoticeUrl,Loader,NoticeVersionUrl,tonumber,platform = 
Screen,UpdateNoticeUrl,Loader,NoticeVersionUrl,tonumber,platform
local mPanelManager = require "LuaScript.Control.PanelManager"
local mAlertManager = require "LuaScript.View.Alert.Alert"
local mTimer = require "LuaScript.Common.Timer"
local mChatManager = require "LuaScript.Control.Data.ChatManager"
local mEventManager = nil
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mSettingPanel = nil
local mHeroManager = nil
local mMainPanel = nil
local mSceneManager = nil
local mSetManager = nil

module("LuaScript.View.Panel.Chat.UpdateNoticePanel")

local mHeight = 0
local mScrollPositionY = 0
local mNoticeList = nil
local mVersion = nil

function Init()
	ReadNoticeVersion()
	
	mSetManager = require "LuaScript.Control.System.SetManager"
	mSettingPanel = require "LuaScript.View.Panel.SettingPanel"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	
	IsInit = true
end

function GetNewCount()
	if mVersion and mVersion ~= mSetManager.GetNotice() then
		return 1
	end
	return 0
end

function ReadNoticeVersion()
	function complete(csLoader)
		mVersion = tonumber(csLoader.text)
	end
	Loader.Load(NoticeVersionUrl, complete, true)
end

function GetVersion()
	return mVersion
end

function Display()
	function complete(csLoader)
		mNoticeList = RunLuaScript(csLoader.text)
		
		for i=#mNoticeList,1,-1 do
			if mNoticeList[i].platform and mNoticeList[i].platform ~= platform then
				table.remove(mNoticeList,i)
			end
		end
		-- for k,v in pairs(mNoticeList) do
			-- v.info = v.info .. mCommonlyFunc.LineHeight(40)
		-- end
	end
	Loader.Load(UpdateNoticeUrl, complete, true)
	mScrollPositionY = 0
end

function OnGUI()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(83.5,37.5,1016.75-50,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	GUI.Label(525.5,48,84.2,30,"公告", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	
	if not mNoticeList then
		GUI.Label(412, 453, 336, 40, "正在获取更新公告.....", GUIStyleLabel.Center_35_LightGreen_Art, Color.Black)
	else
		_,mScrollPositionY = GUI.BeginScrollView(240,130,830,460, 0, mScrollPositionY, 0, 0, 800, mHeight)
			mHeight = 20
			for k,notice in pairs(mNoticeList) do
				mHeight = mHeight + DrawNotice(mHeight, notice)
			end
		GUI.EndScrollView()
	end
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
	end
end

function DrawNotice(y, notice)
	local height = GUI.GetTextHeight(notice.info, 700, GUIStyleLabel.Left_25_Redbean_WordWrap)
	
	GUI.Label(0,y,700,30, notice.name, GUIStyleLabel.Center_35_Brown_Art)
	GUI.Label(0,y+55,700,height, notice.info, GUIStyleLabel.Left_25_Redbean_WordWrap)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg28_2")
	GUI.DrawTexture(83.5,y+height+20,512,32,image)
	
	return height+105
end