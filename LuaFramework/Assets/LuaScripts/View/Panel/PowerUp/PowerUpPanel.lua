local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,GUIStyleButton,ActionType,AssetPath,CFG_powerUp,SceneType = 
Color,os,ConstValue,pairs,math,GUIStyleButton,ActionType,AssetPath,CFG_powerUp,SceneType
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mMainPanel = require "LuaScript.View.Panel.Main.Main"
local mLoadPanel = require "LuaScript.View.Panel.LoadPanel"
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mAlert = require "LuaScript.View.Alert.Alert"
local mActionManager = require "LuaScript.Control.ActionManager"
local mSceneManager = nil
local mPowerUpViewPanel = nil

module("LuaScript.View.Panel.PowerUp.PowerUpPanel")
local mScrollPositionY = 0

function Display()
	mSceneManager.SetMouseEvent(false)
end

function Hide()
	mSceneManager.SetMouseEvent(true)
end

function Init()
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mPowerUpViewPanel = require "LuaScript.View.Panel.PowerUp.PowerUpViewPanel"
	
	IsInit = true
end

function OnGUI()	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(83.5,37.5,1016.75-50,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	GUI.Label(525.5,48,84.2,30,"战斗力提升", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	
	local spacing = 102
	GUI.Label(228,140,82.7,30,"方式", GUIStyleLabel.Left_35_Black)
	GUI.Label(463,140,111.45,30,"推荐", GUIStyleLabel.Left_35_Black)
	GUI.Label(816,140,74.2,30,"操作", GUIStyleLabel.Left_35_Black)
	
	
	local count = #CFG_powerUp
	_,mScrollPositionY = GUI.BeginScrollView(154, 185.8, 900, 421.95, 0, mScrollPositionY, 0, 0, 850, spacing * count)
		for k,powerUp in pairs(CFG_powerUp) do
			local y = (k-1)*spacing
			local showY = y - mScrollPositionY / GUI.modulus
			if showY > -spacing  and showY < spacing*4 then
				DrawPowerUp(0, y, k, powerUp)
			end
		end
	GUI.EndScrollView()
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
		mScrollPositionY = 0
	end
end


function DrawPowerUp(x, y, index, powerUp)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,830,90,image)
	
	
	GUI.Label(35, y+31, 244, 30, powerUp.name, GUIStyleLabel.Left_35_Brown_Art)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/star_"..powerUp.effect)
	GUI.DrawTexture(280,y+13,64*powerUp.effect,64,image)
	
	-- if GUI.Button(660, y + 25, 61, 55, nil, GUIStyleButton.FriendChatBtn) then
		-- mPowerUpViewPanel.SetData(powerUp.name, powerUp.desc)
		-- mPanelManager.Show(mPowerUpViewPanel)
	-- end
	
	if GUI.Button(640, y + 25, 123, 63, "查 看", GUIStyleButton.ShortOrangeArtBtn) then
		mPowerUpViewPanel.SetData(powerUp.name, powerUp.desc)
		mPanelManager.Show(mPowerUpViewPanel)
	end

end
