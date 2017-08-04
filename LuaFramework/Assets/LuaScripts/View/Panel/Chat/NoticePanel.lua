local GUI,RunLuaScript,Language,_G,os,print,Application,KeyCode,Input,Event,UnityEventType,Vector2,SceneType,require,EventType = 
GUI,RunLuaScript,Language,_G,os,print,Application,KeyCode,Input,Event,UnityEventType,Vector2,SceneType,require,EventType
local pairs,ConstValue,Directory,GUIStyleButton,GUIStyleTextField,Color,GUIStyleLabel,string,CFG_item,table = 
pairs,ConstValue,Directory,GUIStyleButton,GUIStyleTextField,Color,GUIStyleLabel,string,CFG_item,table
local Screen = Screen
local mPanelManager = require "LuaScript.Control.PanelManager"
local mAlertManager = require "LuaScript.View.Alert.Alert"
local mTimer = require "LuaScript.Common.Timer"
local mChatManager = require "LuaScript.Control.Data.ChatManager"
local mEventManager = nil
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mAssetManager = require "LuaScript.Control.AssetManager"

module("LuaScript.View.Panel.Chat.NoticePanel")
panelType = ConstValue.TipPanel
notShowGuide = true
notAutoClose = true

local mNoticeList = {}
local mNoticeStr = nil
local mNoticeWidth = nil
local mLastTime = 0

-- function Init()
	-- mEventManager.AddEventListen(nil,EventType.OnNotice,OnNotice)
	-- IsInit = true
-- end

function AddNotice(info, priority)
	local info = mCommonlyFunc.BeginColor(Color.YellowStr) .. info
	info =  info .. mCommonlyFunc.EndColor()
	if priority then
		table.insert(mNoticeList, 1, info)
	else
		if #mNoticeList <= 30 then
			table.insert(mNoticeList, info)
		end
	end
	mPanelManager.Show(OnGUI)
end

function OnGUI()
	-- mLastTime = mLastTime - os.deltaTime
	local speed = 160 * GUI.modulus
	if mLastTime <= os.oldClock then
		if mNoticeList[1] then
			mNoticeStr = table.remove(mNoticeList, 1)
			mNoticeWidth = GUI.GetTextSize(mNoticeStr, GUIStyleLabel.Left_30_White)
			mLastTime = os.oldClock + (mNoticeWidth + Screen.width) / speed
		else
			return
		end
	end
	if not mNoticeStr then
		mPanelManager.Hide(OnGUI)
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/noticeTip")
	GUI.UnScaleDrawTexture(0,0,Screen.width,51,image,0,0,1,1,75,0,0,0)
	
	GUI.UnScaleBeginGroup(80,0,Screen.width,50)
		GUI.UnScaleLabel(-mNoticeWidth+speed*(mLastTime-os.oldClock),8,169,50, mNoticeStr, GUIStyleLabel.Left_30_White_Unscale) 
	GUI.EndGroup()
end