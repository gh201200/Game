local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel
local AssetPath = AssetPath

local mAssetManager = nil
local mGUIStyleManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mSetManager = nil
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"

module("LuaScript.View.Panel.View.Guide.ProtectPanel") -- 和平和战争模式切换

local mInfo = "您当前处于保护状态,该状态将免受玩家攻击.使用免战牌可延长保护时间,攻击玩家或玩家商队保护时间立即结束."
local mName = "保护"
local mScrollView = 0
local mScrollPositionY = 0
panelType = ConstValue.AlertPanel

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mScrollView = GUI.GetTextHeight(mInfo, 427, GUIStyleLabel.Left_25_White_WordWrap)+10
	
	IsInit = true
end

function OnGUI()
	local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_Bg31_1)
	GUI.DrawTexture(286,150,560,427,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(346,241,443,255,image,0,0,1,1,15,15,15,15)
	GUI.Label(500, 190, 144, 150, mName, GUIStyleLabel.Center_35_Brown_Art)
	
	_,mScrollPositionY = GUI.BeginScrollView(356,242,457,250, 0,mScrollPositionY, 0, 0,427, mScrollView)
		GUI.Label(0, 10, 427, mScrollView, mInfo, GUIStyleLabel.Left_25_Redbean_WordWrap)
	GUI.EndScrollView()
	
	if GUI.Button(773, 138, 77, 63, nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
	if mSetManager.GetProtectState() then
		if GUI.Button(645, 495, 128, 32, nil, GUIStyleButton.ShowBtn_5) then
			mSetManager.SetProtectState(false)
		end
	else
		if GUI.Button(645, 495, 128, 32, nil, GUIStyleButton.ShowBtn_1) then
			mSetManager.SetProtectState(true)
		end
	end
end