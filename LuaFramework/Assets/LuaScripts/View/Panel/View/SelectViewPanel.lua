local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Packat_Player,PackatHead = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Packat_Player,PackatHead
local AssetType = AssetType
local GUIStyleButton,ConstValue = GUIStyleButton,ConstValue
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mCharViewPanel = nil
local mBattleViewPanel = nil
local mPanelManager = require "LuaScript.Control.PanelManager"
local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mNetManager = nil
local mCommonlyFunc = nil

module("LuaScript.View.Panel.View.SelectViewPanel") -- 查看选中玩家的详细信息
panelType = ConstValue.GuidePanel
local mChar = nil
local mShowX = 0
local mShowY = 0
local mMouseEventState = nil

function SetData(char)
	local position = Input.GetMousePosition()
	mShowX = GUI.UnHorizontalRestX(position.x)
	mShowY = GUI.UnVerticalRestY(Screen.height - position.y) - 45
	
	mChar = char
	-- print(mChar)
end


function Display()
	mMouseEventState = mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false)
end

function Hide()
	mSceneManager.SetMouseEvent(mMouseEventState)
end

-- local pathData = nil
function Init()
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mCharViewPanel = require "LuaScript.View.Panel.View.CharViewPanel"
	mBattleViewPanel = require "LuaScript.View.Panel.View.BattleViewPanel"
	IsInit = true
end

function PerGUI()
	if GUI.Button(mShowX-79, mShowY, 79, 93,nil, GUIStyleButton.ViewChar) then
		mCharViewPanel.SetData(mChar)
		mPanelManager.Hide(OnGUI)
		mPanelManager.Show(mCharViewPanel)
	end
	if GUI.Button(mShowX+5, mShowY, 84, 92,nil, GUIStyleButton.ViewBattle) then
		mBattleViewPanel.SetData(mChar.battleId)
		mPanelManager.Hide(OnGUI)
		mPanelManager.Show(mBattleViewPanel)
	end
	
	if GUI.Button(0, 0, 1136, 640,nil, GUIStyleButton.Transparent) then
		mPanelManager.Hide(OnGUI)
		-- mSceneManager.SetMouseEvent(true)
	end
end

function OnGUI()
	if not IsInit then
		return
	end
	
	GUI.Button(mShowX-79, mShowY, 79, 93,nil, GUIStyleButton.ViewChar)
	GUI.Button(mShowX+5, mShowY, 84, 92,nil, GUIStyleButton.ViewBattle)
	-- GUI.BeginGroup(127.55, 50.05, 1186, 640)
		-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg2_2")
		-- GUI.DrawTexture(101.3,42.05,795, 497, image)
		
		-- local image = mAssetManager.GetAsset("Texture/Character/HalfPic/1", AssetType.Pic)
		-- GUI.DrawTexture(196.2, 109.75, 288, 344, image, 0, 1-344/400, 1, 344/400)
		-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/herobg")
		-- GUI.DrawTexture(170, 89.05, 334, 397, image)
		
		-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
		-- GUI.DrawTexture(538.5,151.4,278.8,185.05,image,0,0,1,1,20,20,20,20)
		
		-- GUI.Label(467.35, 231.3, 256.2, 30,  mChar.name, GUIStyleLabel.Left_25_Redbean_Art)
		
		-- if GUI.Button(470.25, 295, 130.55, 64.8, "查看人物", GUIStyleButton.ShortOrangeBtn) then
			-- mCharViewPanel.SetData(mChar)
			-- mPanelManager.Hide(OnGUI)
			-- mPanelManager.Show(mCharViewPanel)
		-- end
		-- if GUI.Button(622.35, 295, 130.55, 64.8, "查看战场", GUIStyleButton.ShortOrangeBtn) then
			-- mBattleViewPanel.SetData(mChar.battleId)
			-- mPanelManager.Hide(OnGUI)
			-- mPanelManager.Show(mBattleViewPanel)
		-- end

		-- if GUI.Button(719.35, 177, 77, 63,nil, GUIStyleButton.CloseBtn) then
			-- mPanelManager.Hide(OnGUI)
			-- mSceneManager.SetMouseEvent(true)
		-- end
	-- GUI.EndGroup()
end
