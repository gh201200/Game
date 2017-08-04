local GUI,RunLuaScript,Language,_G,os,print,Application,KeyCode,Input,Event,UnityEventType,Vector2,SceneType,require,EventType = 
GUI,RunLuaScript,Language,_G,os,print,Application,KeyCode,Input,Event,UnityEventType,Vector2,SceneType,require,EventType
local pairs,ConstValue,Directory,GUIStyleButton,GUIStyleTextField,Color,GUIStyleLabel,string,CFG_item,math = 
pairs,ConstValue,Directory,GUIStyleButton,GUIStyleTextField,Color,GUIStyleLabel,string,CFG_item,math
local mPanelManager = require "LuaScript.Control.PanelManager"
local mAlertManager = require "LuaScript.View.Alert.Alert"
local mTimer = require "LuaScript.Common.Timer"
local mChatManager = require "LuaScript.Control.Data.ChatManager"
local mEventManager = nil
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHeroManager = nil
local mMainPanel = nil
local mSceneManager = nil
local mSystemTip = nil
local mItemManager = nil
local mAlert = nil
local mSelectAlert = nil
local mSetManager = nil
local mFamilyManager = nil
local mSDK = mSDK
module("LuaScript.View.Panel.Chat.GMChatPanel")
panelType = ConstValue.AlertPanel

local mMsgStr = ""
local mSendMsgStr = ""
local mScrollPositionY = 0
local mSelectChannel = false
local mSendChannel = 1
local mReciveChannel = -1
local mCostTip = nil

local mNewCount = 0
local mBottom = false

function GetNewCount()
	return math.min(mNewCount, 99)
end

function Hide()
	-- mSendChannel = 1
	mReciveChannel = -1
	mSelectChannel = false
	mSceneManager.SetMouseEvent(mMouseEventState)
end

function Display()
	mNewCount = 0
	OnRefreshChat()
	mMouseEventState = mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false)
	mCostTip = mSetManager.GetCostTip()
end

function Init()
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	mEventManager.AddEventListen(nil,EventType.OnRefreshChat,OnRefreshChat)
	IsInit = true
end

function SetChannel(channel)
	mSendChannel = channel
end

function OnRefreshChat(_,_,channel)
	if not visible and channel ~= -1 then
		mNewCount = mNewCount + 1
		return
	end
	
	channel = channel or mReciveChannel
	if mReciveChannel ~= -1 and mReciveChannel ~= channel then
		return
	end
	
	local mMsgList = mChatManager.GetMsgList(mReciveChannel)
	mMsgStr = ""
	for k,msg in pairs(mMsgList) do
		local color = ConstValue.ChannelColorStr[msg.channel]
		local str =  mCommonlyFunc.BeginColor(color)
		str = str .. "『" .. ConstValue.ChannelStr[msg.channel] .. "』"
		str = str .. mCommonlyFunc.EndColor()
		str = str .. mCommonlyFunc.BeginColor(Color.RedbeanStr)
		
		if msg.channel == 3 and msg.post >= 2 then
			str = str .. mCommonlyFunc.BeginColor(Color.RedStr)
			str = str .. "[" ..ConstValue.PostName[msg.post] .. "]"
			str = str .. mCommonlyFunc.EndColor()
		end
		if msg.fname then
			str = str .. msg.fname .. "("..msg.fid.."):"
		end
		str = str .. mCommonlyFunc.EndColor()
		str = str .. mCommonlyFunc.BeginColor(Color.BrownStr)
		str = str .. msg.info
		str = str .. mCommonlyFunc.EndColor()
		str = str .. mCommonlyFunc.Linefeed()
		mMsgStr = mMsgStr .. str
	end
	-- mMsgStr = mMsgStr .. mCommonlyFunc.LineHeight(30)
	
	if mBottom then
		mScrollPositionY = 99999
	end
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/chatBg")
	GUI.DrawTexture(178,56,753,531,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(265,185,591,261,image,0,0,1,1,20,20,20,20)
	
	GUI.Label(478,95,169,50, "聊天记录", GUIStyleLabel.Center_40_Brown_Art)
	if mSDK.GetChannelName() ~= "185sy" then
		GUI.Label(653,155,169,50, "(QQ群:390261959)", GUIStyleLabel.Left_25_Redbean)
	end
	
	local height = GUI.GetTextHeight(mMsgStr, 555, GUIStyleLabel.Left_20_White_WordWrap)
	_,mScrollPositionY,mBottom = GUI.BeginScrollView(265, 185, 591, 261, 0, mScrollPositionY, 0, 0, 560, height)
		GUI.Label(10,5,555,height, mMsgStr, GUIStyleLabel.Left_20_White_WordWrap)
	GUI.EndScrollView()
	-- GUI.Label(10,5,555,0, mScrollPositionY .. " " ..height, GUIStyleLabel.Left_20_White_WordWrap)

	GUI.Button(290,148,84,37, "全部", GUIStyleButton.ChannelSelectBtn_1)

	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/text_4")
	GUI.DrawTexture(343,483,406,67,image,0,0,1,1,15,23,15,23)
	local newMsgStr = GUI.TextArea(343,477,406,65, mSendMsgStr, GUIStyleTextField.MLeft_Transparent_30)
	if string.len(newMsgStr) <= ConstValue.MaxMsgLength then
		mSendMsgStr = newMsgStr
	end
	if GUI.Button(745,484,151,67, "发送", GUIStyleButton.ShortOrangeArtBtn) then
		if string.len(mSendMsgStr) == 0 then
			return
		end
		
		mChatManager.SendMsg(0, 0, mSendMsgStr)
		mSendMsgStr = ""
	end
	
	if GUI.Button(855,36,82,67, nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/channel_1")
	GUI.DrawTexture(212,483,135,65,image)
	if GUI.Button(208,493,135,43, "命令", GUIStyleButton["ChannelBtn_1"]) then
		mSelectChannel = true
	end
end