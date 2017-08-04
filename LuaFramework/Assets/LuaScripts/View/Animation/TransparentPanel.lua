local _G,Screen,Language,GUI,ByteArray,print,Texture2D,Input,math,Event,UnityEventType,MouseButton = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,Input,math,Event,UnityEventType,MouseButton
local PackatHead,Packat_Account,Packat_Player,require,KeyCode,pairs,table,os,ConstValue = 
PackatHead,Packat_Account,Packat_Player,require,KeyCode,pairs,table,os,ConstValue
local GUIStyleLabel,Color,SceneType,GUIStyleButton = GUIStyleLabel,Color,SceneType,GUIStyleButton
local CFG_copyMapLevel,CFG_copyMap = CFG_copyMapLevel,CFG_copyMap
local AssetType,CFG_guide,error = AssetType,CFG_guide,error
module("LuaScript.View.Animation.TransparentPanel")
notAutoClose = true
panelType = ConstValue.GuidePanel
notShowGuide = true

local mGuideId = nil
local mFunc = nil

function Init()
	IsInit = true
end

function PerGUI()
	GUI.Button(0,0,1136,640,nil,GUIStyleButton.Transparent)
end

function OnGUI()
	
end