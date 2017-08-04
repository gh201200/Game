local _G,Screen,Language,GUI,ByteArray,print,Texture2D,Input,math,Event,UnityEventType,MouseButton,CFG_map,AppearEvent = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,Input,math,Event,UnityEventType,MouseButton,CFG_map,AppearEvent
local PackatHead,Packat_Account,Packat_Player,require,KeyCode = PackatHead,Packat_Account,Packat_Player,require,KeyCode
local GUIStyleLabel,Color,SceneType,GUIStyleButton,EventType,CFG_send,AssetType,CFG_boss,CFG_EnemyPosition,CFG_Enemy = 
GUIStyleLabel,Color,SceneType,GUIStyleButton,EventType,CFG_send,AssetType,CFG_boss,CFG_EnemyPosition,CFG_Enemy
local CFG_harbor,pairs,table,ConstValue,MapTexture,_G,CsIsNull = 
CFG_harbor,pairs,table,ConstValue,MapTexture,_G,CsIsNull
local mAssetManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mHeroManager = nil
local mSetManager = nil

module("LuaScript.View.Panel.Mode.ModePanel")

panelType = ConstValue.AlertPanel

function Init()
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mSetManager = require "LuaScript.Control.System.SetManager"
	
	IsInit = true
end

function Display()
	mSceneManager.SetMouseEvent(false)
end

function Hide()
	mSceneManager.SetMouseEvent(true)
end

function OnGUI()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/modeBg")
	GUI.DrawTexture(200,15,758,638,image)
	
	GUI.Label(180+77,418,278,160,Language[209], GUIStyleLabel.Left_23_Brown_WordWrap)
	GUI.Label(691-79,418,278,160,Language[208], GUIStyleLabel.Left_23_Brown_WordWrap)
	
	local hero = mHeroManager.GetHero()
	if GUI.Button(259, 245, 313, 96,nil, GUIStyleButton.SelectMode) then
		mPanelManager.Hide(OnGUI)
		if hero.mode ~= 1 then
			mHeroManager.RequestSelectMode(1)
		end
	end
	
	if GUI.Button(594, 245, 313, 96,nil, GUIStyleButton.SelectMode) then
		mPanelManager.Hide(OnGUI)
		if hero.mode ~= 2 then
			mHeroManager.RequestSelectMode(2)
		end
	end
	
	if GUI.Button(885, 0, 77, 63, nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
	
	if mSetManager.GetBattleMode() then
		if GUI.Button(260, 553, 128, 32, nil, GUIStyleButton.ShowBtn_6) then
			mSetManager.SetBattleMode(false)
		end
	else
		if GUI.Button(260, 553, 128, 32, nil, GUIStyleButton.ShowBtn_3) then
			mSetManager.SetBattleMode(true)
		end
	end
end