local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os
local CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleButton,GUIStyleTextField,string,AssetPath = 
CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleButton,GUIStyleTextField,string,AssetPath
local AssetType,GetFirstKey,CharacterType = AssetType,GetFirstKey,CharacterType
local error,CFG_star,CFG_starSkill = error,CFG_star,CFG_starSkill
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
-- local mStarSkillPanel = nil
local mStarViewPanel = nil
local mStarFateManager = nil
local mStarSelectPanel = nil
local mStarSkillSelectPanel = nil
local mStarSkillViewPanel = nil

module("LuaScript.View.Panel.StarFate.StarSetPanel")

-- local mStarList = {[1] = {{id=1,level=1,pos=1},{id=2,level=1,pos=1},{id=3,level=1,pos=1},{id=3,level=1,pos=1},},
					-- [2] = {{id=1,level=1,pos=2}}}

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
	mStarViewPanel = require "LuaScript.View.Panel.StarFate.StarViewPanel"
	-- mStarSkillPanel = require "LuaScript.View.Panel.StarFate.StarSkillPanel"
	mStarFateManager = require "LuaScript.Control.Data.StarFateManager"
	mStarSelectPanel = require "LuaScript.View.Panel.StarFate.StarSelectPanel"
	mStarSkillSelectPanel = require "LuaScript.View.Panel.StarFate.StarSkillSelectPanel"
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
	
	GUI.Label(525.5,48,84.2,30,"技能", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	
	local count = 0
	local mStarList = mStarFateManager.GetDutyStarList()
	local mSkillList = mStarFateManager.GetSkillList()
	for i=1,3 do
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
		GUI.DrawTexture(118,53+i*118,905,114,image)
		
		local index = 0
		for j=1,7 do
			local x = (j-1) * 112 + 135
			local y = (i-1) * 118 + 185
			
			local star = nil
			if mStarList[i][j] then
				star = mStarList[i][j]
			end
			if star then
				DrawStar(x, y, star)
				index = index + 1
			elseif mLastSolt and ((index + 1 == j and mStarList[i][1]) 
						or (index + 1 == j and mStarList[i-1] and mStarList[i-1][1])
						or (index == 0 and i == 1 and j == 1)) then
				local image = mAssetManager.GetAsset("Texture/Gui/Bg/starSlot_1")
				if GUI.TextureButton(x,y,83,84,image) then
					-- local 
					function select(star)
						if star then
							mStarFateManager.RequestSetStar(star.index, i)
						end
						mPanelManager.Show(OnGUI)
					end
					mStarSelectPanel.SetData(nil, select)
					mPanelManager.Show(mStarSelectPanel)
					mPanelManager.Hide(OnGUI)
				end
			else
				local image = mAssetManager.GetAsset("Texture/Gui/Bg/starSlot_2")
				GUI.DrawTexture(x,y,83,84,image)
			end
		end
		count = count + index
		
		local list = mStarFateManager.GetStarSkillList(i, mStarList[i])
		if mSkillList and mSkillList[i].id then
			-- if list[2] then
				if GUI.Button(906,125+i*118,100,30, nil, GUIStyleButton.Transparent) then
					-- function func(index, skill)
						-- if index and skill then
							-- mStarFateManager.RequestSetSkill(index, skill)
						-- end
						-- mPanelManager.Show(OnGUI)
					-- end
					mStarSkillSelectPanel.SetData(i,list,selectSkill)
					mPanelManager.Show(mStarSkillSelectPanel)
					mPanelManager.Hide(OnGUI)
					
					-- for _,skill in pairs(list) do
						-- mStarFateManager.InitStarSkillLevel(skill, mStarList[i])
					-- end
				end
			-- end
			local cfg_starSkill = CFG_starSkill[mSkillList[i].id]
			local image = mAssetManager.GetAsset("Texture/Icon/StarSkill/"..cfg_starSkill.resId)
			if GUI.TextureButton(906,61+i*118,100,100,image) then
				-- if list[2] then
					function f()
						-- function func(index, skill)
							-- if index and skill then
								-- mStarFateManager.RequestSetSkill(index, skill)
							-- end
							-- mPanelManager.Show(OnGUI)
						-- end
						mStarSkillSelectPanel.SetData(i,list,selectSkill)
						mPanelManager.Show(mStarSkillSelectPanel)
						mPanelManager.Hide(OnGUI)
						
						-- for _,skill in pairs(list) do
							-- mStarFateManager.InitStarSkillLevel(skill, mStarList[i])
						-- end
					end
					mStarSkillViewPanel.SetData(mSkillList[i], f)
				-- end
				mPanelManager.Show(mStarSkillViewPanel)
			end
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/skill_"..mSkillList[i].quality, AssetType.Icon)
			GUI.DrawTexture(906,61+i*118,100,100,image)
			
			-- if list[2] then
				GUI.Label(906,130+i*118,100,30, "更换技能", GUIStyleLabel.Center_22_Lime_Art,Color.Black)
			-- end
		else
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg51_3")
			if GUI.TextureButton(906,61+i*118,100,100,image) then
				mStarSkillSelectPanel.SetData(i,{},selectSkill)
				mPanelManager.Show(mStarSkillSelectPanel)
				mPanelManager.Hide(OnGUI)
			end
			GUI.Label(906,61+i*118,100,100, "选择\n技能", GUIStyleLabel.MCenter_25_White_Art)
		end
	end
	local hero = mHeroManager.GetHero()
	local mSoltCount = 4 + math.floor(hero.level/5) + math.floor(hero.vipLevel/5)
	mLastSolt = count < math.min(mSoltCount, 21)
	
	-- local starPoint = mStarFateManager.GetStarPoint()
	GUI.Label(140,140,84.2,30,"星运槽数量: "..(mSoltCount-count), GUIStyleLabel.Left_25_White)
	-- GUI.Label(350,140,84.2,30,"星魂数量: "..starPoint, GUIStyleLabel.Left_25_White)
	GUI.Label(700,140,84.2,30,"每提升五级开放一个星运槽", GUIStyleLabel.Left_25_White)
	
	
	if GUI.Button(432,518,283,83,nil, GUIStyleButton.StarTakeBtn2) then
		mPanelManager.Show(mStarGetPanel)
		mPanelManager.Hide(OnGUI)
	end
	if GUI.Button(728,518,283,83,nil, GUIStyleButton.StarBgBtn2) then
		mPanelManager.Show(mStarBagPanel)
		mPanelManager.Hide(OnGUI)
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(135,533,285,60,image)
	local starPoint = mStarFateManager.GetStarPoint()
	GUI.Label(200,153+395,84.2,30,"星魂数量: "..starPoint, GUIStyleLabel.Center_22_Lime_Art)
	
	-- if GUI.Button(728,518,283,83,nil, GUIStyleButton.StarSkillListBtn) then
		-- mPanelManager.Show(mStarSkillPanel)
		-- mPanelManager.Hide(OnGUI)
	-- end
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


function selectSkill(index,skill)
	if index and skill then
		mStarFateManager.RequestSetSkill(index, skill)
	end
	mPanelManager.Show(OnGUI)
end

function DrawStar(x, y, star)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/starSlot_1")
	if GUI.TextureButton(x,y-10,83,84,image) then
		mStarViewPanel.SetData(star)
		mPanelManager.Show(mStarViewPanel)
	end
	
	-- local cfg_star = CFG_star[star.bid]
	-- local image = mAssetManager.GetAsset("Texture/Icon/Star/"..cfg_star.resId)
	-- GUI.DrawTexture(x-25,y-28,128,128,image)
	DrawItemCell(CFG_star[star.bid], ItemType.Star, x-8, y-18, 100, 100) 
	
	if GUI.Button(x - 18, y + 73, 50, 30, "升级", GUIStyleButton.Transparent_Art_25) then
		mStarFateManager.RequestLevelUp(star.index)
	end
	if GUI.Button(x + 38, y + 73, 50, 30, "卸下", GUIStyleButton.Transparent_Art_25) then
		mStarFateManager.RequestSetStar(star.index, 0)
	end
end
