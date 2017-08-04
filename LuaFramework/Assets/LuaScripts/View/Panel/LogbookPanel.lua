local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,Vector2,GUIStyleButton,GUIStyleLabel,os,CFG_harbor = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,Vector2,GUIStyleButton,GUIStyleLabel,os,CFG_harbor
local table,SceneType,EventType = table,SceneType,EventType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
module("LuaScript.View.Panel.LogbookPanel")

local mEventManager = nil
local mLogInfo = nil
local mHeroManager = nil
local mMainPanel = nil
local mPanelManager = nil
local mSceneManager = nil
local mLogbookManager = nil
local mScrollPositionY = 0

function Init()
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mLogbookManager = require "LuaScript.Control.Data.LogbookManager"
	mEventManager = require "LuaScript.Control.EventManager"
	
	IsInit = true
end

function Display()
	mScrollPositionY = 99999
end

function Hide()
	local mLogList = mLogbookManager.GetLogList()
	for k,v in pairs(mLogList) do
		v.old = true
	end
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	
	GUI.Label(0, 50, 1186, 40, Language[88], GUIStyleLabel.Center_35_Black)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(83.5,37.5,1016.75-50,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	GUI.Label(525.5,48,84.2,30,"航海日志", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	
	local mLogList = mLogbookManager.GetLogList()
	local spacing = 88
	local count = #mLogList
	_,mScrollPositionY = GUI.BeginScrollView(176, 151, 850, spacing * 5, 0, mScrollPositionY, 0, 0, 820, spacing * count)
		for i=1,count,1 do
			local log = mLogList[i]
			local y = (i-1)*spacing
			local showY = y - mScrollPositionY / GUI.modulus
			if showY > -spacing  and showY < spacing*5 then
				DrawLog(log, y)
			end
		end
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
		if count < 1 then
			GUI.DrawTexture(0,spacing*0,814.3,80,image)
		end
		if count < 2 then
			GUI.DrawTexture(0,spacing*1,814.3,80,image)
		end
		if count < 3 then
			GUI.DrawTexture(0,spacing*2,814.3,80,image)
		end
		if count < 4 then
			GUI.DrawTexture(0,spacing*3,814.3,80,image)
		end
		if count < 5 then
			GUI.DrawTexture(0,spacing*4,814.3,80,image)
		end
	GUI.EndScrollView()
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
		mScrollPositionY = 0
	end
end

function DrawLog(log, y)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,814,80,image)
	GUI.Label(43, 7+y, 113.1, 40, log.info, GUIStyleLabel.Left_25_White)
	if not log.old then
		local image = mAssetManager.GetAsset("Texture/Gui/Text/new")
		GUI.DrawTexture(674,y+11,101,52,image)
	end
end

