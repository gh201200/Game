local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel
local AssetPath = AssetPath

local mAssetManager = nil
local mGUIStyleManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"

module("LuaScript.View.Panel.PowerUp.PowerUpViewPanel")

local mInfo = nil
local mName = nil
local mScrollView = 0
local mScrollPositionY = 0
panelType = ConstValue.AlertPanel

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	IsInit = true
	-- print("init")
end

function SetData(name, info)
	mName = name
	mInfo = info
	
	mScrollView = GUI.GetTextHeight(info, 427, GUIStyleLabel.Left_25_White_WordWrap)
	mScrollPositionY = 0
end

function OnGUI()
	local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_Bg31_1)
	GUI.DrawTexture(286,150,560,427,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(346,241,443,255,image,0,0,1,1,15,15,15,15)

	GUI.Label(500, 190, 144, 150, mName, GUIStyleLabel.Center_35_Brown_Art)
	
	_,mScrollPositionY = GUI.BeginScrollView(356,242,457,250, 0,mScrollPositionY, 0, 0,427, mScrollView,3)
		GUI.Label(0, 0, 427, mScrollView, mInfo, GUIStyleLabel.Left_25_Redbean_WordWrap)
	GUI.EndScrollView()
	
	if GUI.Button(773, 138, 77, 63, nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end