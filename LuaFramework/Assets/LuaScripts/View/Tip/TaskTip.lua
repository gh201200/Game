local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,SceneType = Color,os,ConstValue,pairs,math,SceneType
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
local mSetManager = require "LuaScript.Control.System.SetManager"
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
module("LuaScript.View.Tip.TaskTip")
notShowGuide = true
notAutoClose = true
panelType = ConstValue.TipPanel

local mStr = nil
local mLastTime = 0
local mGuide = nil

function ShowTip(str, guide)
	-- print(guide)
	if not mSetManager.GetTaskTip() then
		return
	end
	mGuide = guide
	mStr = str
	mLastTime = os.oldClock
	mPanelManager.Show(OnGUI)
end

function OnGUI()
	local hero = mHeroManager.GetHero()
	if hero.SceneType == SceneType.Battle then
		return
	end
	if mStr then
		local overTime = os.oldClock - mLastTime
		local color = Color.Init(0.6 + math.abs(math.sin(overTime)) * 0.4,0.1 + math.abs(math.cos(overTime)) * 0.9,0.1,1)
		local style = mGUIStyleManager.GetGUIStyle(GUIStyleLabel.LLeft_30_Change_Art)
		style.normal.textColor = color
		
		GUI.Label(10,630,0,0,mStr,GUIStyleLabel.LLeft_30_Change_Art, Color.Black)
		
		if not mSetManager.GetGuide() and mGuide and mSetManager.GetTaskTip() then
			return
		end
		
		if overTime >= ConstValue.TaskTipLastTime then
			mStr = nil
			mPanelManager.Hide(OnGUI)
		end
	end
end
