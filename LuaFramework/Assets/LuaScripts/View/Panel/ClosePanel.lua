local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,Vector2,GUIStyleButton,GUIStyleLabel,os,CFG_harbor = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,Vector2,GUIStyleButton,GUIStyleLabel,os,CFG_harbor
local table,SceneType,EventType,Application,ConstValue, mSDK= table,SceneType,EventType,Application,ConstValue, mSDK
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mAudioManager = require "LuaScript.Control.System.AudioManager"
local mTimer = require "LuaScript.Common.Timer"
local mSceneManager = nil

module("LuaScript.View.Panel.ClosePanel")
panelType = ConstValue.TipPanel
notAutoClose = true
local mStartTime = 0

function Init()
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
end

function Display()
	mStartTime = os.oldClock
	mAudioManager.StopAudio()
	
	mTimer.SetTimeout(Application.Quit, 1)
	mSceneManager.SetMouseEvent(false)
end

function OnGUI()
	
	local image = mAssetManager.GetAsset("Texture/Gui/black")
	GUI.UnScaleDrawTexture(0,0,Screen.width,Screen.height,image)
	
	local overTime = os.oldClock - mStartTime
	local alpha = math.max(math.min((1-overTime), 0.5), 0)
	
	local color = Color.Init(alpha,alpha,alpha,alpha)
	local image = mAssetManager.GetAsset("Texture/Icon/" .. mSDK.logoName)
	GUI.UnScaleDrawTexture((Screen.width-512)/2,(Screen.height-512)/2,512,512,image,0,0,1,1,0,0,0,0,color)
end