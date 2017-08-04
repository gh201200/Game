local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,Vector2,GUIStyleButton,GUIStyleLabel,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,Vector2,GUIStyleButton,GUIStyleLabel,os
local CFG_harbor =
CFG_harbor
local mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"

module("LuaScript.View.Panel.Family.FamilyRecordPanel") -- 联盟日志界面

local mScrollPositionY = 0

function Display()
	mScrollPositionY = 9999
end

function OnGUI()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(425,150,565,433.5,image, 0, 0, 1, 1, 15, 15, 15, 15)
	local logs = mFamilyManager.GetLogs()
	
	local height = GUI.GetTextHeight(logs, 500, GUIStyleLabel.Left_25_White_WordWrap,Color.Black)
	_,mScrollPositionY = GUI.BeginScrollView(425, 150, 600, 425, 0, mScrollPositionY, 0, 0, 500, height+10)
		GUI.Label(10, 10, 500, height, logs, GUIStyleLabel.Left_25_White_WordWrap,Color.Black)
	GUI.EndScrollView()
end