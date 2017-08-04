local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,AssetPath = Color,os,ConstValue,pairs,math,AssetPath
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mSetManager = require "LuaScript.Control.System.SetManager"
module("LuaScript.View.Tip.ChatTip")
notShowGuide = true
notAutoClose = true
panelType = ConstValue.TipPanel

local mStr = nil
local mLastTime = 0
local mHeight = 0

function ShowTip(msg)
	if not mSetManager.GetChatTip() then
		return
	end
	mStr = mCommonlyFunc.BeginColor(Color.YellowStr)
	if msg.fname then
		mStr = mStr .. msg.fname .. ":"
	end
	mStr = mStr .. mCommonlyFunc.EndColor()
	mStr = mStr .. msg.info
	
	mLastTime = os.oldClock
	mPanelManager.Show(OnGUI)
	mHeight = GUI.GetTextHeight(mStr, 600, GUIStyleLabel.Left_25_White_WordWrap)
end

function OnGUI()
	if mStr then
		local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_chatTip)
		GUI.DrawTexture(0,473,690,mHeight+10,image,0,0,1,1,38,61,45,1)
		
		local overTime = os.oldClock - mLastTime
		GUI.Label(51,478,600,30,mStr,GUIStyleLabel.Left_25_White_WordWrap, Color.Black)
		
		if overTime >= ConstValue.ChatTipLastTime then
			mStr = nil
			mPanelManager.Hide(OnGUI)
		end
	end
end
