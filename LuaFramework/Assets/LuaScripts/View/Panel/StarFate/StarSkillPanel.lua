local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os
local CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleButton,GUIStyleTextField,string,AssetPath = 
CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleButton,GUIStyleTextField,string,AssetPath
local AssetType,GetFirstKey,CharacterType = AssetType,GetFirstKey,CharacterType
local error,CFG_starSkill = error,CFG_starSkill
local AssetType,ItemType,DrawItemCell = AssetType,ItemType,DrawItemCell
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
local mStarGetPanel = nil
local mStarBagPanel = nil
local mStarSetPanel = nil
local mStarViewPanel = nil
local mStarSkillViewPanel = nil
module("LuaScript.View.Panel.StarFate.StarSkillPanel")

-- local mStarList = {{id=1,level=1,pos=1},{id=2,level=1,pos=1},{id=3,level=1,pos=1},{id=3,level=1,pos=1},
-- {id=3,level=1,pos=1},{id=3,level=1,pos=1},{id=3,level=1,pos=1},{id=3,level=1,pos=1},{id=3,level=1,pos=1},
-- {id=3,level=1,pos=1},}
local mScrollPositionY = 0
local mSelectQuality = 4
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
	mStarGetPanel = require "LuaScript.View.Panel.StarFate.StarGetPanel"
	mStarBagPanel = require "LuaScript.View.Panel.StarFate.StarBagPanel"
	mStarSetPanel = require "LuaScript.View.Panel.StarFate.StarSetPanel"
	mStarViewPanel = require "LuaScript.View.Panel.StarFate.StarViewPanel"
	mStarSkillViewPanel = require "LuaScript.View.Panel.StarFate.StarSkillViewPanel"
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
	GUI.Label(525.5,48,84.2,30,"技能列表", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	
	
	local spacing = 118
	_,mScrollPositionY = GUI.BeginScrollView(118, 171, 950, 350, 0, mScrollPositionY, 0, 0, 900, spacing * (count or 3))
		count = 0
		for k,starSkill in pairs(CFG_starSkill) do
			if starSkill["quality"..mSelectQuality] == 1 then
				local y = count * spacing
				
				local showY = y - mScrollPositionY / GUI.modulus
				if showY > -spacing  and showY < spacing*3 then
					DrawStarSkill(0, y, starSkill)
				end
				count = count + 1
			end
		end
	GUI.EndScrollView()
	
	if mSelectQuality == 1 then
		GUI.Button(136,137,85,25,nil, GUIStyleButton.Quality_1_2)
	elseif GUI.Button(136,137,85,25,nil, GUIStyleButton.Quality_1_1) then
		mSelectQuality = 1
	end
	if mSelectQuality == 2 then
		GUI.Button(236,137,85,25,nil, GUIStyleButton.Quality_2_2)
	elseif GUI.Button(236,137,85,25,nil, GUIStyleButton.Quality_2_1) then
		mSelectQuality = 2
	end
	if mSelectQuality == 3 then
		GUI.Button(336,137,85,25,nil, GUIStyleButton.Quality_4_2)
	elseif GUI.Button(336,137,85,25,nil, GUIStyleButton.Quality_4_1) then
		mSelectQuality = 3
	end
	if mSelectQuality == 4 then
		GUI.Button(436,137,85,25,nil, GUIStyleButton.Quality_3_2)
	elseif GUI.Button(436,137,85,25,nil, GUIStyleButton.Quality_3_1) then
		mSelectQuality = 4
	end
	
	
	
	if GUI.Button(136,518,283,83,nil, GUIStyleButton.StarTakeBtn2) then
		mPanelManager.Show(mStarGetPanel)
		mPanelManager.Hide(OnGUI)
	end
	if GUI.Button(432,518,283,83,nil, GUIStyleButton.StarBgBtn2) then
		mPanelManager.Show(mStarBagPanel)
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

function DrawStarSkill(x, y, starSkill, index)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,905,114,image)
		
	local image = mAssetManager.GetAsset("Texture/Icon/StarSkill/"..starSkill.resId)
	if GUI.TextureButton(788,y+8,100,100,image) then
		mStarSkillViewPanel.SetData({id=starSkill.id, quality=mSelectQuality})
		mPanelManager.Show(mStarSkillViewPanel)
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/skill_"..mSelectQuality, AssetType.Icon)
	GUI.DrawTexture(788,y+8,100,100,image)
	
	DrawStar(17, y+14, mCommonlyFunc.GetStarByTAQ(starSkill.star1, mSelectQuality))
	DrawStar(17+112, y+14, mCommonlyFunc.GetStarByTAQ(starSkill.star2, mSelectQuality))
	DrawStar(17+112*2, y+14, mCommonlyFunc.GetStarByTAQ(starSkill.star3, mSelectQuality))
	DrawStar(17+112*3, y+14, mCommonlyFunc.GetStarByTAQ(starSkill.star4, mSelectQuality))
	DrawStar(17+112*4, y+14, mCommonlyFunc.GetStarByTAQ(starSkill.star5, mSelectQuality))
	DrawStar(17+112*5, y+14, mCommonlyFunc.GetStarByTAQ(starSkill.star6, mSelectQuality))
	DrawStar(17+112*6, y+14, mCommonlyFunc.GetStarByTAQ(starSkill.star7, mSelectQuality))
end


function DrawStar(x, y, star)
	if star then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/starSlot_1")
		GUI.DrawTexture(x,y,83,84,image)
		
		-- local image = mAssetManager.GetAsset("Texture/Icon/Star/"..star.resId)
		if DrawItemCell(star, ItemType.Star, x-8, y-8, 100, 100) then
			mStarViewPanel.SetData({bid=star.id,level=0})
			mPanelManager.Show(mStarViewPanel)
		end
	else
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/starSlot_2")
		GUI.DrawTexture(x,y,83,84,image)
	end
end
