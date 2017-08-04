local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel


local mAssetManager = nil
local mGUIStyleManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mPromptAlert = nil
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
module("LuaScript.View.Alert.Alert") -- 提示信息窗口，蓝色按钮

local mOkFunction = nil
local mCancelFunction = nil
-- local mTitle = nil
local mInfo = nil
local mOKBtnStr = nil
local mCancelBtnStr = nil
mMouseEventState = nil
notAutoClose = true
panelType = ConstValue.AlertPanel
-- local mShow = false

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mPromptAlert = require "LuaScript.View.Alert.PromptAlert"
	IsInit = true
end

function Display()
	mMouseEventState = mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false)
end

function Show(info, okFunction, cancelFunction, okBtnStr, cancelBtnStr)
	if mPromptAlert.visible then
		return
	end
	mInfo = mCommonlyFunc.BeginColor(Color.BrownStr) .. info
	mInfo = mInfo .. mCommonlyFunc.EndColor() 
	mOkFunction = okFunction
	mCancelFunction = cancelFunction
	mOKBtnStr = okBtnStr or Language[25]
	mCancelBtnStr = cancelBtnStr or Language[9]
	mPanelManager.Show(OnGUI)
	
	-- mMouseEventState = mSceneManager.GetMouseEventState()
	-- mSceneManager.SetMouseEvent(false)
end

function OnGUI()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/alertBg")
	GUI.DrawTexture(286,150,560,341,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Text/tip")
	GUI.DrawTexture(486,182,133,34,image)
	GUI.Label(350, 238, 424.2, 150, mInfo, GUIStyleLabel.Left_25_White_WordWrap)
	
	if GUI.Button(368, 372, 166, 77, mOKBtnStr, GUIStyleButton.BlueBtn) then
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(mMouseEventState)
		if mOkFunction then
			mOkFunction()
		end
	end
	
	if GUI.Button(588, 372, 166, 77, mCancelBtnStr, GUIStyleButton.BlueBtn) then
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(mMouseEventState)
		if mCancelFunction then
			mCancelFunction()
		end
	end
	
	if GUI.Button(780, 133, 77, 63, nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(mMouseEventState)
	end
end