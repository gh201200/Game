local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel


local mAssetManager = nil
local mGUIStyleManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
module("LuaScript.View.Alert.PromptAlert")

local mOkFunction = nil
local mInfo = nil

mMouseEventState = nil
notAutoClose = true
panelType = ConstValue.AlertPanel
-- local mShow = false

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	IsInit = true
end

function Show(info, okFunction)
	mInfo = mCommonlyFunc.BeginColor(Color.BrownStr) .. info
	mInfo = mInfo .. mCommonlyFunc.EndColor() 
	mOkFunction = okFunction
	
	if not visible then
		mPanelManager.Show(OnGUI)
		mMouseEventState = mSceneManager.GetMouseEventState()
		mSceneManager.SetMouseEvent(false)
	end	
end

function Hide()
	if mOkFunction then
		mOkFunction()
	end
end

function OnGUI()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/alertBg")
	GUI.DrawTexture(286,150,560,341,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Text/tip")
	GUI.DrawTexture(486,182,133,34,image)
	GUI.Label(350, 238, 424.2, 150, mInfo, GUIStyleLabel.Left_25_White_WordWrap)
	
	if GUI.Button(473, 372, 166, 77, Language[25], GUIStyleButton.BlueBtn) then
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(mMouseEventState)
	end
	
	if GUI.Button(780, 133, 77, 63, nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(mMouseEventState)
	end
end