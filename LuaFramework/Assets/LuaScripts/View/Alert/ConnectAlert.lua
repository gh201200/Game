local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel
local Vector2,GUIUtility = Vector2,GUIUtility

local mAssetManager = nil
local mEventManager = nil

module("LuaScript.View.Alert.ConnectAlert") -- 读取数据提示界面

local pivotPoint = nil
local mAngle = 0
local mAlert = nil

notAutoClose = true
panelType = ConstValue.GuidePanel
-- local mShow = false

function Init()
	mAlert = require "LuaScript.View.Alert.Alert"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	IsInit = true
	
	pivotPoint = Vector2.New(GUI.HorizontalRestX(426+32-25),GUI.VerticalRestY(275+32-14))
	-- print(pivotPoint)
end

function PerGUI()
	if mAlert.visible then
		return
	end
	GUI.Button(0,0,1136,640,nil,GUIStyleButton.Transparent)
end

function OnGUI()
	if mAlert.visible then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg47_1")
	GUI.DrawTexture(396,238,342,122,image)
	
	mAngle = mAngle + 4
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/connectBg")
	-- GUI.DrawTexture(426,275,39,39,image)
	GUIUtility.RotateAroundPivot(mAngle, pivotPoint)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/connectBg")
		GUI.DrawTexture(426-25,275-14,64,64,image)
	GUIUtility.RotateAroundPivot(-mAngle, pivotPoint)
	GUI.Label(470, 282, 424.2, 150, "正在读取数据......", GUIStyleLabel.Left_25_White, Color.Black)
	
end