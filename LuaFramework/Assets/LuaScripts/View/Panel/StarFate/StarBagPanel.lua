local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os
local CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleButton,GUIStyleTextField,string,AssetPath = 
CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleButton,GUIStyleTextField,string,AssetPath
local AssetType,GetFirstKey,CharacterType,DrawItemCell,ItemType = AssetType,GetFirstKey,CharacterType,DrawItemCell,ItemType
local AssetType,ItemType,DrawItemCell = AssetType,ItemType,DrawItemCell
local error,CFG_star = error,CFG_star
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mSceneManager = nil
local mHeroManager = nil
local mCommonlyFunc = nil
local mFriendChatPanel = nil
local mHarborPanel = nil
local mScenePanel = nil
local mCharViewPanel = nil
local mFriendFindPanel = nil
local mRelationManager = require "LuaScript.Control.Data.RelationManager"
local mAlert = nil
local mSystemTip = nil
local mStarSetPanel = nil
local mStarGetPanel = nil
local mStarFateManager = nil
local mStarViewPanel = nil

module("LuaScript.View.Panel.StarFate.StarBagPanel")

local mScrollPositionY = 0

function Init()
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mFriendChatPanel = require "LuaScript.View.Panel.Friend.FriendChatPanel"
	mHarborPanel = require "LuaScript.View.Panel.Harbor.HarborPanel"
	mScenePanel = require "LuaScript.View.Panel.ScenePanel"
	mCharViewPanel = require "LuaScript.View.Panel.View.CharViewPanel"
	-- mRelationManager = require "LuaScript.Control.Data.RelationManager"
	mFriendFindPanel = require "LuaScript.View.Panel.Friend.FriendFindPanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mStarSetPanel = require "LuaScript.View.Panel.StarFate.StarSetPanel"
	mStarGetPanel = require "LuaScript.View.Panel.StarFate.StarGetPanel" 
	mStarFateManager = require "LuaScript.Control.Data.StarFateManager"
	mStarViewPanel = require "LuaScript.View.Panel.StarFate.StarViewPanel"
	IsInit = true
end

function OnGUI()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(83.5,37.5,1016.75-50,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg51_2")
	GUI.DrawTexture(79,115,980,512,image)
	
	GUI.Label(525.5,48,84.2,30,"星运背包", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	
	local spacing = 118
	local mStarList = mStarFateManager.GetRestStarList()
	mCount = math.ceil(#mStarList/7)*7
	_,mScrollPositionY = GUI.BeginScrollView(120, 170, 950, 348, 0, mScrollPositionY, 0, 0, 900, spacing * mCount/7)
		for i=1,mCount do
			local x = (i-1)% 7 * 125 + 25
			local y = math.floor((i-1)/7) * spacing
			
			local star = mStarList[i]
			local showY = y - mScrollPositionY / GUI.modulus
			if showY > -spacing  and showY < spacing*3 and star then
				DrawStar(x, y, star, i)
			end
		end
	GUI.EndScrollView()
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(135,533,285,60,image)
	local starPoint = mStarFateManager.GetStarPoint()
	GUI.Label(200,153+395,84.2,30,"星魂数量: "..starPoint, GUIStyleLabel.Center_22_Lime_Art)
	
	
	if GUI.Button(432,518,283,83,nil, GUIStyleButton.StarTakeBtn2) then
		mPanelManager.Show(mStarGetPanel)
		mPanelManager.Hide(OnGUI)
	end
	if GUI.Button(728,518,283,83,nil, GUIStyleButton.StarSkillBtn2) then
		mPanelManager.Show(mStarSetPanel)
		mPanelManager.Hide(OnGUI)
	end
	if GUI.Button(1060,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		local hero = mHeroManager.GetHero()
		if hero.SceneType == SceneType.Harbor then
			mPanelManager.Show(mHarborPanel)
			mPanelManager.Hide(OnGUI)
		else
			mPanelManager.Show(mScenePanel)
			mPanelManager.Hide(OnGUI)
			mSceneManager.SetMouseEvent(true)
		end
	end
end

function DrawStar(x, y, star, index)
	if star then
		if DrawItemCell(CFG_star[star.bid], ItemType.Star, x-8, y-8, 100, 100) then
			mStarViewPanel.SetData(star)
			mPanelManager.Show(mStarViewPanel)
		end
		
		if GUI.Button(x-20, y-18+93, 61, 55, "升级", GUIStyleButton.Transparent_Art_25) then
			mStarFateManager.RequestLevelUp(star.index)
		end
		if GUI.Button(x-25+65, y-18+93, 61, 55, "分解", GUIStyleButton.Transparent_Art_25) then
			mStarFateManager.BreakStar(star.index)
		end
	end
end
