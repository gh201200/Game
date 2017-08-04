local _G,Screen,Language,GUI,ByteArray,print,Texture2D,Input,math,Event,UnityEventType,MouseButton = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,Input,math,Event,UnityEventType,MouseButton
local PackatHead,Packat_Account,Packat_Player,require,KeyCode,pairs,table,os,ConstValue = 
PackatHead,Packat_Account,Packat_Player,require,KeyCode,pairs,table,os,ConstValue
local GUIStyleLabel,Color,SceneType,GUIStyleButton = GUIStyleLabel,Color,SceneType,GUIStyleButton
local CFG_copyMapLevel,CFG_copyMap = CFG_copyMapLevel,CFG_copyMap
local AssetType,CFG_guide,error = AssetType,CFG_guide,error
local mPanelManager = require "LuaScript.Control.PanelManager"
local mAlert = require "LuaScript.View.Alert.Alert"
local mAutoBusinessManager = require "LuaScript.Control.Data.AutoBusinessManager"

module("LuaScript.View.Tip.AutoBusinessTip")
local mStr = nil
local visible = false

function SetData(str)
	mStr = str
end


function ShowTip()
	visible = true
end

function HideTip()
	visible = false
end

function OnGUI()
	if not visible then
		return
	end
	GUI.Label(575, 395, 0, 0, mStr, GUIStyleLabel.Center_30_Yellow, Color.Black)

	if GUI.Button(575+200,395,132, 63,"取消", GUIStyleButton.ShortOrangeArtBtn) then
		function okFunc()
			mPanelManager.Hide(OnGUI)
			mAutoBusinessManager.StopAutoBusiness()
		end
		mAlert.Show("是否停止自动跑商？", okFunc)
	end
end