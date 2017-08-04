local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math = Color,os,ConstValue,pairs,math
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mHeroManager = nil
local mAssetManager = require "LuaScript.Control.AssetManager"
local mDialogPanel = require "LuaScript.View.Panel.Task.DialogPanel"
module("LuaScript.View.Tip.LevelUpTip")
notShowGuide = true
notAutoClose = true
panelType = ConstValue.TipPanel
local mTime = 0
local offset = 0

function Init()
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	
	
	IsInit = true
end

function ShowTip()
	mTime = 0
	mPanelManager.Show(OnGUI)
	
	if mDialogPanel.visible then
		offset = -90
	else
		offset = 0
	end
end

function OnGUI()
	mTime = mTime + os.deltaTime
	if mTime >= 4 then
		mPanelManager.Hide(OnGUI)
	end
	local hero = mHeroManager.GetHero()
	
	local y = 500 - math.sin(math.min(mTime,1.57)) * 80
	
	local image = mAssetManager.GetAsset("Texture/Gui/Text/levelup")
	GUI.DrawTexture(650,y+offset,281,39,image)
	GUI.Label(815,y+5+offset,40,20,hero.level,GUIStyleLabel.LevelUp_30, Color.Black)
end
