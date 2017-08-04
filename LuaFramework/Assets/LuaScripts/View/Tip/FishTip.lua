local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,AssetPath,string = Color,os,ConstValue,pairs,math,AssetPath,string
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
local mAssetManager = require "LuaScript.Control.AssetManager"
module("LuaScript.View.Tip.FishTip")
notShowGuide = true
notAutoClose = true
panelType = ConstValue.TipPanel

local mStarTime = 0

function ShowTip()
	mStarTime = os.oldClock
	visible = true
	-- mPanelManager.Show(OnGUI)
end

function HideTip()
	visible = false
	-- mPanelManager.Hide(OnGUI)
end

function OnGUI()
	if not visible then
		return
	end
	local overTime = math.min(os.oldClock - mStarTime, 15)
	
	local mProgress = overTime/15
	local mProgressWidth =308*mProgress
	local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_RechargeBg_4)
	GUI.DrawTexture(395,422-230,mProgressWidth,25,image,0,0,mProgress,1)
	local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_FishBg)
	GUI.DrawTexture(360,403-230,378,61,image,0,0,1,1,75,75,0,0)
	local str = string.format(Language[206], math.floor(overTime/15*100),Language[207])
	GUI.Label(528, 427-230, 32, 30, str, GUIStyleLabel.Center_20_White, Color.Black)
end
