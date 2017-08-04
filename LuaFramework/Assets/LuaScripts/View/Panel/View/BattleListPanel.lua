local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,CFG_sign,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,CFG_sign,os
local ConstValue,GUIStyleButton,PackatHead,Packat_Player,UnityEventType,CsCurrentEventEqualsType = 
ConstValue,GUIStyleButton,PackatHead,Packat_Player,UnityEventType,CsCurrentEventEqualsType
local CharacterType,CFG_harbor = CharacterType,CFG_harbor
local mAssetManager = require "LuaScript.Control.AssetManager"
local mPanelManager = nil
local mMainPanel = nil
local mSceneManager = nil
local mCommonlyFunc = nil
local mCharManager = nil
local mBattleManager = nil
local mRelationManager = nil
local mNetManager = nil
local mSystemTip = nil
local mAlert = nil
local mHeroManager = nil
local mScrollPositionY = 0
local mBattleViewPanel = nil
local mBattleFieldManager = nil

module("LuaScript.View.Panel.View.BattleListPanel") -- 附近战场列表
panelType = ConstValue.AlertPanel
local tipStr = nil

function Init()
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mBattleManager = require "LuaScript.Control.Data.BattleFieldManager"
	mRelationManager = require "LuaScript.Control.Data.RelationManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mAlert = require "LuaScript.View.Alert.Alert"
	mBattleViewPanel = require "LuaScript.View.Panel.View.BattleViewPanel"
	mBattleFieldManager = require "LuaScript.Control.Data.BattleFieldManager"
	IsInit = true
	
	tipStr = mCommonlyFunc.BeginColor(ConstValue.RelationColorStr[2])
	tipStr = tipStr .. Language[137]
	tipStr = tipStr .. mCommonlyFunc.EndColor()
	tipStr = tipStr .. mCommonlyFunc.Linefeed()
	
	tipStr = tipStr .. mCommonlyFunc.BeginColor(ConstValue.RelationColorStr[3])
	tipStr = tipStr .. Language[138]
	tipStr = tipStr .. mCommonlyFunc.EndColor()
	tipStr = tipStr .. mCommonlyFunc.Linefeed()
	
	tipStr = tipStr .. mCommonlyFunc.BeginColor(ConstValue.RelationColorStr[4])
	tipStr = tipStr .. Language[139]
	tipStr = tipStr .. mCommonlyFunc.EndColor()
end

function Display()
	mSceneManager.SetMouseEvent(false)
	mScrollPositionY = 0
end

function OnGUI()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg23_1")
	GUI.DrawTexture(146,68,848,524,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg30_1")
	GUI.DrawTexture(187,98,757,443,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg28_2")
	GUI.DrawTexture(204,160,723,32,image)
	
	GUI.Label(469, 113, 164, 40, "战场列表", GUIStyleLabel.Center_45_LightYellow_Art)
	
	GUI.Label(755+67, 105, 104.2, 400, tipStr, GUIStyleLabel.Center_20_White_Art)
	
	local spacing = 85
	local battleList = mBattleFieldManager.GetBattleFieldList()
	local count = #battleList
	_,mScrollPositionY = GUI.BeginScrollView(204, 187, 760, 331, 0, mScrollPositionY, 0, 0, 723, spacing * count)
		for k,battle in pairs(battleList) do
			local y = (k-1)*spacing
			local showY = y - mScrollPositionY / GUI.modulus
			if showY > -spacing  and showY < spacing*4 then
				DrawBattle(y, battle)
			end
		end
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
		if count < 1 then
			GUI.DrawTexture(0,0,719,79,image)
		end
		if count < 2 then
			GUI.DrawTexture(0,spacing,719,79,image)
		end
		if count < 3 then
			GUI.DrawTexture(0,spacing*2,719,79,image)
		end
		if count < 4 then
			GUI.DrawTexture(0,spacing*3,719,79,image)
		end
	GUI.EndScrollView()

	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn19_1")
	GUI.DrawTexture(535,519,59,16,image)
	
	if GUI.Button(913, 57, 77, 63, nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
	end
end

function DrawBattle(y, battleField)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,719,79,image)
	
	GUI.Label(7, y+20, 536, 30, mCommonlyFunc.GetBattleShortInfo(battleField), GUIStyleLabel.Center_30_White)
	
	if GUI.Button(549, y+6, 166, 77, "查看", GUIStyleButton.BlueBtn) then
		mPanelManager.Hide(OnGUI)
		mBattleViewPanel.SetData(battleField.id)
		mPanelManager.Show(mBattleViewPanel)
	end
end

