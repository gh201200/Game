local GUI,RunLuaScript,Language,_G,os,print,Application,KeyCode,Input,Event,UnityEventType,Vector2,SceneType,require,EventType = 
GUI,RunLuaScript,Language,_G,os,print,Application,KeyCode,Input,Event,UnityEventType,Vector2,SceneType,require,EventType
local pairs,ConstValue,Directory,GUIStyleButton,GUIStyleTextField,Color,GUIStyleLabel,string,CsStringSub,error = 
pairs,ConstValue,Directory,GUIStyleButton,GUIStyleTextField,Color,GUIStyleLabel,string,CsStringSub,error
local ActionType = ActionType
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
local mFriendPanel = nil
local mActionManager = require "LuaScript.Control.ActionManager"
module("LuaScript.View.Panel.Friend.FriendChatPanel")
panelType = ConstValue.AlertPanel

local mMsgStr = ""
local mSendMsgStr = ""
local mScrollPositionY = 0
local mChar = nil

function Init()
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mFriendPanel = require "LuaScript.View.Panel.Friend.FriendPanel"
	mEventManager.AddEventListen(nil,EventType.OnPrivateChat,OnPrivateChat)
	IsInit = true
end

function SetData(char)
	mChar = char
end

function Display()
	OnPrivateChat()
	mMouseEventState = mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false)
end

function Hide()
	mSceneManager.SetMouseEvent(mMouseEventState)
end

function OnPrivateChat(target, type, param)
	if param and not mActionManager.GetActionOpen(ActionType.Friend) then
		mFriendPanel.AddEvent(1, param.fid)
		return
	end
	if param and (not visible or not mChar or (param.fid ~= mChar.id and param.toId ~= mChar.id)) then
		local info = "有新的私信,请在"
		info = info .. mCommonlyFunc.BeginColor(Color.CyanStr)
		info = info .. "菜单•好友"
		info = info .. mCommonlyFunc.EndColor()
		info = info .. "处查看"
		mSystemTip.ShowTip(info, Color.LimeStr)
		
		-- print(param)
		mFriendPanel.AddEvent(1, param.fid)
		return
	end

	local mMsgList = mChatManager.GetPrivateMsgList(mChar.id)
	mMsgStr = ""
	if mMsgList then
		for k,msg in pairs(mMsgList) do
			local str = mCommonlyFunc.BeginColor(Color.YellowStr)
			str = str .. os.date("%X", msg.time)
			str = str .. mCommonlyFunc.EndColor()
			str = str .. mCommonlyFunc.BeginColor("#9ae0feff")
			str = str .. "[" .. msg.fname .. "]: "
			str = str .. mCommonlyFunc.EndColor()
			str = str .. msg.info
			str = str .. mCommonlyFunc.Linefeed()
			mMsgStr = mMsgStr .. str
		end
	end
	-- mMsgStr = mMsgStr .. mCommonlyFunc.LineHeight(30)
	mScrollPositionY = 99999
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/chatBg")
	GUI.DrawTexture(284.5,105.5,551,389,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(330,178,459,220,image,0,0,1,1,20,20,20,20)
	GUI.Label(512.5,138,124,50, "与\""..mChar.name.."\"私聊窗口", GUIStyleLabel.Center_30_Brown_Art) 
	local height = GUI.GetTextHeight(mMsgStr, 440, GUIStyleLabel.Left_20_White_WordWrap)
	_,mScrollPositionY = GUI.BeginScrollView(330, 180, 480, 215, 0, mScrollPositionY, 0, 0, 459, height)
		GUI.Label(10,5,440,height, mMsgStr, GUIStyleLabel.Left_20_White_WordWrap, Color.Black)
	GUI.EndScrollView()
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/text_4")
	GUI.DrawTexture(315,418,385,53,image,0,0,1,1,15,23,15,23)
	local newMsgStr = GUI.TextArea(315,418,380,53, mSendMsgStr, GUIStyleTextField.Transparent_25)
	
	if string.len(newMsgStr) > ConstValue.MaxMsgLength then
		if CsStringSub then
			newMsgStr = CsStringSub(newMsgStr,0,ConstValue.MaxMsgLength)
		else
			return
		end
	end
	mSendMsgStr = newMsgStr
	
	if GUI.Button(699,419,111,53, "发送", GUIStyleButton.ShortOrangeArtBtn) then
		if #mSendMsgStr == 0 then
			return
		end
		mSendMsgStr = mCommonlyFunc.CheckWord(mSendMsgStr)
		mChatManager.SendMsg(2, mChar.id, mSendMsgStr)
		mSendMsgStr = ""
	end
	
	if GUI.Button(762.5,90.5,77,63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end