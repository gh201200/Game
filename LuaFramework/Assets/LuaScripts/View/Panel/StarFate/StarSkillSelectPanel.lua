local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os
local CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleButton,GUIStyleTextField,string,AssetPath = 
CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleButton,GUIStyleTextField,string,AssetPath
local AssetType,GetFirstKey,CharacterType = AssetType,GetFirstKey,CharacterType
local error,CFG_starSkill,SkillType = error,CFG_starSkill,SkillType
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
local mAlert = require "LuaScript.View.Alert.Alert"
local mSystemTip = nil
local mStarGetPanel = require "LuaScript.View.Panel.StarFate.StarGetPanel"
local mStarBagPanel = nil
local mStarSetPanel = nil
local mStarSkillViewPanel = nil
local mStarFateManager = require "LuaScript.Control.Data.StarFateManager"
module("LuaScript.View.Panel.StarFate.StarSkillSelectPanel")

local mIndex = nil
local mList = nil
local mList2 = nil
local mSelectFunc = nil
local mDutySkill = nil
function SetData(index, list, selectFunc)
	mIndex = index
	mList = list
	mSelectFunc = selectFunc
	mDutySkill = mStarFateManager.GetSkillListByIndext(index)
	
	local _,list2 = mStarFateManager.CouldActionSkills(index)
	for k,skill in pairs(list) do
		if list2[skill.id] and list2[skill.id].quality <= skill.quality then
			list2[skill.id] = nil
		end
	end
	
	mList2 = {}
	for _,skill in pairs(list2) do
		table.insert(mList2, skill)
	end
	
	if #mList + #mList2 == 0 then
		function f()
			mPanelManager.Hide(OnGUI)
			mPanelManager.Show(mStarGetPanel)
		end
		mAlert.Show("没有足够星运来组成技能，前往占星？",f)
	end
end

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
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	-- mStarGetPanel = require "LuaScript.View.Panel.StarFate.StarGetPanel"
	mStarBagPanel = require "LuaScript.View.Panel.StarFate.StarBagPanel"
	mStarSetPanel = require "LuaScript.View.Panel.StarFate.StarSetPanel"
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
	
	local spacing = 150
	_,mScrollPositionY = GUI.BeginScrollView(118, 150, 950, 450, 0, mScrollPositionY, 0, 0, 900, indexY or 0)
		indexY = 0
		local count = #mList
		if count > 0 then
			GUI.Label(20,0,84.2,30,"可选技能", GUIStyleLabel.Left_30_Yellowish_Art)
			for k,starSkill in pairs(mList) do
				local x = (k-1) % 7 * spacing + 27
				local y = math.floor((k-1) / 7) * spacing + 30
				
				local showY = y - mScrollPositionY / GUI.modulus
				if showY > -spacing  and showY < spacing*4 then
					DrawStarSkill(x, y, starSkill, true)
				end
			end
			indexY = math.ceil(count/7) * spacing + 45
		end
		
		
		local count = #mList2
		if count > 0 then
			GUI.Label(20,indexY,84.2,30,"可激活技能", GUIStyleLabel.Left_30_Yellowish_Art)
			for k,starSkill in pairs(mList2) do
				local x = (k-1) % 7 * spacing + 27
				local y = math.floor((k-1) / 7) * spacing + indexY + 30
				
				local showY = y - mScrollPositionY / GUI.modulus
				if showY > -spacing  and showY < spacing*4 then
					DrawStarSkill(x, y, starSkill, false)
				end
			end
			indexY = indexY + (math.ceil(count/7)) * spacing + 45
		end
		
		
		spacing = 120
		GUI.Label(20,indexY,84.2,30,"全技能图鉴", GUIStyleLabel.Left_30_Yellowish_Art)
		local quality = 4
		local count = 0
		for k,starSkill in pairs(CFG_starSkill) do
			if starSkill["quality"..quality] == 1 then
				local x = count % 7 * spacing + 27
				local y = math.floor(count / 7) * spacing + indexY + 30
				
				local showY = y - mScrollPositionY / GUI.modulus
				if showY > -spacing  and showY < spacing*4 then
					DrawCfgStarSkill(x, y, starSkill,quality)
				end
				count = count + 1
			end
		end
		-- indexY = indexY + (math.ceil(count/7)) * spacing + 45
		
		
		local quality = 3
		for k,starSkill in pairs(CFG_starSkill) do
			if starSkill["quality"..quality] == 1 then
				local x = count % 7 * spacing + 27
				local y = math.floor(count / 7) * spacing + indexY
				
				local showY = y - mScrollPositionY / GUI.modulus
				if showY > -spacing  and showY < spacing*4 then
					DrawCfgStarSkill(x, y, starSkill,quality)
				end
				count = count + 1
			end
		end
		-- indexY = indexY + (math.ceil(count/7)) * spacing
		
		
		local quality = 2
		for k,starSkill in pairs(CFG_starSkill) do
			if starSkill["quality"..quality] == 1 then
				local x = count % 7 * spacing + 27
				local y = math.floor(count / 7) * spacing + indexY
				
				local showY = y - mScrollPositionY / GUI.modulus
				if showY > -spacing  and showY < spacing*4 then
					DrawCfgStarSkill(x, y, starSkill,quality)
				end
				count = count + 1
			end
		end
		-- indexY = indexY + (math.ceil(count/7)) * spacing
		
		
		local quality = 1
		for k,starSkill in pairs(CFG_starSkill) do
			if starSkill["quality"..quality] == 1 then
				local x = count % 7 * spacing + 27
				local y = math.floor(count / 7) * spacing + indexY
				
				local showY = y - mScrollPositionY / GUI.modulus
				if showY > -spacing  and showY < spacing*4 then
					DrawCfgStarSkill(x, y, starSkill,quality)
				end
				count = count + 1
			end
		end
		indexY = indexY + (math.ceil(count/7)) * spacing + 45
		-- if not mList[3] then
			-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
			-- GUI.DrawTexture(0,spacing*2,905,139,image)
		-- end
	GUI.EndScrollView()
	
	if GUI.Button(1060,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Hide(OnGUI)
		mSelectFunc()
	end
end

function DrawStarSkill(x, y, starSkill, have)
	local cfg_starSkill = CFG_starSkill[starSkill.id]

	local image = mAssetManager.GetAsset("Texture/Icon/StarSkill/"..cfg_starSkill.resId)
	if GUI.TextureButton(x+15,y+18,100,100,image) then
		mStarSkillViewPanel.SetData(starSkill)
		mPanelManager.Show(mStarSkillViewPanel)
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/skill_"..starSkill.quality, AssetType.Icon)
	GUI.DrawTexture(x+15,y+18,100,100,image)
	
	-- if GUI.Button(x+15, y+148.05, 111, 60,nil, GUIStyleButton.SelectBtn) then
		-- mPanelManager.Hide(OnGUI)
		-- mSelectFunc(mIndex,starSkill)
	-- end
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg50_2")
	-- GUI.DrawTexture(x+40, y+105,50,2,image)
	
	
	if mDutySkill.id == starSkill.id and mDutySkill.quality == starSkill.quality then
		local image = mAssetManager.GetAsset("Texture/Gui/Text/wear")
		GUI.DrawTexture(x+35, y+15,64,64,image)
	elseif GUI.Button(x+12, y+105, 111, 30, "选择", GUIStyleButton.Select_35_Art) then
		mPanelManager.Hide(OnGUI)
		if not have then
			mStarFateManager.SetStarBySkill(starSkill.id, starSkill.quality, mIndex)
		end
		mSelectFunc(mIndex,starSkill)
	end
end


function DrawCfgStarSkill(x, y, starSkill, quality)
	local image = mAssetManager.GetAsset("Texture/Icon/StarSkill/"..starSkill.resId)
	if GUI.TextureButton(x+15,y+18,100,100,image) then
		mStarSkillViewPanel.SetData({id=starSkill.id, quality=quality})
		mPanelManager.Show(mStarSkillViewPanel)
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/skill_"..quality, AssetType.Icon)
	GUI.DrawTexture(x+15,y+18,100,100,image)

end

