local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,GUIStyleButton,ActionType,AssetPath = 
Color,os,ConstValue,pairs,math,GUIStyleButton,ActionType,AssetPath
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
local mAssetManager = require "LuaScript.Control.AssetManager"
-- local mScenePanel = require "LuaScript.View.Panel.ScenePanel"
-- local mHarborPanel = require "LuaScript.View.Panel.Harbor.HarborPanel"
local mLoadPanel = require "LuaScript.View.Panel.LoadPanel"
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mAlert = require "LuaScript.View.Alert.Alert"
local mActionManager = require "LuaScript.Control.ActionManager"
local mSetManager = require "LuaScript.Control.System.SetManager"
local mTreasurePanel = require "LuaScript.View.Panel.View.Guide.TreasurePanel"

module("LuaScript.View.Tip.TreasureTip")

local mStr = nil
local mLastTime = 0
local mX,mY = nil,nil
function ShowTip(x,y)
	mX,mY = x,y
	mStr = x .. " " .. y
	mLastTime = os.oldClock
	_visible = true
	-- print(11111)
	-- mPanelManager.Show(OnGUI)
end

function HideTip()
	-- print(22222)
	_visible = false
end

function OnGUI()
	-- print(1)
	if not _visible  then
		visible = false
		return
	end
	visible = true
	
	
	local offset = 0
	local offsetY = 150
	-- if mHarborPanel.visible and mActionManager.GetActionOpen(ActionType.CopyMap) then
		-- offset = 90
	-- end
	local overTime = math.min(os.oldClock - mLastTime,10)
	local color = Color.Init(0.6 + math.abs(math.sin(overTime)) * 0.4,0.1 + math.abs(math.cos(overTime)) * 0.9,0.1,1)
	local style = mGUIStyleManager.GetGUIStyle(GUIStyleLabel.LLeft_25_Change_Art)
	style.normal.textColor = color
	
	local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_Bg32_1)
	GUI.DrawTexture(offset+5,offsetY+165,256,64,image)
	GUI.Label(offset+85,offsetY+170,0,50,"点击寻宝",GUIStyleLabel.LLeft_25_Change_Art, Color.Black)
	
	local hero = mHeroManager.GetHero()
	if hero.map == 2 then
		GUI.Label(offset+60,offsetY+165,0,50,Language[201],GUIStyleLabel.Left_20_Red, Color.Black)
	end
	
	if GUI.Button(offset+5,offsetY+165,256,64,nil,GUIStyleButton.Transparent) then
		mHeroManager.Goto(0, mX, mY)
	end
end
