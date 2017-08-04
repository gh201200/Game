local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os
local CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleButton,EventType = 
CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleButton,EventType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mCommonlyFunc = nil
local mViewShipPanel = nil
local mMainPanel = nil
local mFamilyCreatePanel = nil
local mFamilyManager = nil
local mEventManager = nil
local mFamilyPanel = nil

module("LuaScript.View.Panel.Family.FamilyListPanel") -- 所有联盟的列表

local mScrollPositionY = 0
FullWindowPanel = true

function Init()
	mEventManager = require "LuaScript.Control.EventManager"
	mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mFamilyCreatePanel = require "LuaScript.View.Panel.Family.FamilyCreatePanel"
	mFamilyPanel = require "LuaScript.View.Panel.Family.FamilyPanel"
	
	mEventManager.AddEventListen(nil, EventType.FamilyCreate, FamilyCreate)
	mEventManager.AddEventListen(nil, EventType.FamilyJoin, FamilyCreate)
	
	IsInit = true
end

function FamilyCreate()
	if visible then
		mPanelManager.Show(mFamilyPanel)
		mPanelManager.Hide(OnGUI)
	end
end

function Display()
	mFamilyManager.RequestFamilyList()
end

function OnGUI()
	local hero = mHeroManager.GetHero()
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(83.5,37.5,1016.75-50,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	GUI.Label(525.5,48,84.2,30,"联盟列表", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	
	    -- GUI.BeginGroup(55, 50, 1200, 500)
		GUI.Label(250, 136, 150, 45, "名称", GUIStyleLabel.Left_35_Black)
		GUI.Label(414.6, 136, 100, 45, "等级", GUIStyleLabel.Left_35_Black)
		GUI.Label(580.4, 136, 100, 45, "盟主", GUIStyleLabel.Left_35_Black)
		GUI.Label(755.45, 136, 100, 45, "人数", GUIStyleLabel.Left_35_Black)
		GUI.Label(873.6, 136, 150, 45, "操作", GUIStyleLabel.Left_35_Black)
		
		local spacing = 93
		mFamilyList = mFamilyManager.GetFamilyList()
		if mFamilyList then
			local count = #mFamilyList
			local height = count * spacing
			_,mScrollPositionY = GUI.BeginScrollView(142.25, 186.3, 900, 4*spacing-10, 0,mScrollPositionY, 0, 0, 850, height)
				for k,family in pairs(mFamilyList) do
					local y = (k-1)*spacing
					local showY = y - mScrollPositionY / GUI.modulus
					if showY > -spacing  and showY < 4*spacing then
						DrawFamily(y, family)
					end
				end
				
				local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
				if count < 1 then
					GUI.DrawTexture(0,spacing*0,855.75,85.05,image)
				end
				if count < 2 then
					GUI.DrawTexture(0,spacing*1,855.75,85.05,image)
				end
				if count < 3 then
					GUI.DrawTexture(0,spacing*2,855.75,85.05,image)
				end
				if count < 4 then
					GUI.DrawTexture(0,spacing*3,855.75,85.05,image)
				end
			GUI.EndScrollView()
		else
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
			GUI.DrawTexture(142.25, 186.3+spacing*0,855.75,85.05,image)
			GUI.DrawTexture(142.25, 186.3+spacing*1,855.75,85.05,image)
			GUI.DrawTexture(142.25, 186.3+spacing*2,855.75,85.05,image)
			GUI.DrawTexture(142.25, 186.3+spacing*3,855.75,85.05,image)
		end
		-- local applyStr = ""
	-- GUI.EndGroup()
	if not hero.familyId then
		if GUI.Button(425, 555, 223,78, "创建", GUIStyleButton.OrangeBtn) then
			mPanelManager.Show(mFamilyCreatePanel)
		end
	end
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
	end
	-- GUI.Label(850, spacing*k-spacing, 100, 50, "双拳难", GUIStyleLabel.Center_30_White, Color.Black)
end

function DrawFamily(y, family)
	local hero = mHeroManager.GetHero()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,855.75,85.05,image)
	
	GUI.Label(32.75, y+23, 214.2, 50, family.name, GUIStyleLabel.Center_35_Redbean_Art)
	GUI.Label(285, y+26.35, 40.2, 50, family.level, GUIStyleLabel.Center_30_Black)
	GUI.Label(385, y+26, 179.2, 50, family.leaderName, GUIStyleLabel.Center_30_Redbean)
	GUI.Label(631, y+26, 40.2, 50, mFamilyManager.GetMemberCountInfo(family), GUIStyleLabel.Center_30_Black)
	
	local oldEnabled = GUI.GetEnabled()
	if hero.familyId then
		GUI.SetEnabled(false)
	end
	if family.isApplyed == 0 then
		if GUI.Button(713,y+15.9,111,53,"申请", GUIStyleButton.ShortOrangeArtBtn) then
			mFamilyManager.RequestJoin(family.id)
		end
	else
		GUI.Label(747, y+25.95, 44.2, 50, "已申请", GUIStyleLabel.Center_30_White, Color.Black)
	end
	
	if hero.familyId then
		GUI.SetEnabled(true)
	end
end

-- function RequestEnemy(id, value)
	-- hero.mFamily.enemyList[id] = value
-- end

-- function RequestApply(id)
	
	-- local hero = mHeroManager.GetHero()
	-- hero.mFamilyApplyList = hero.mFamilyApplyList or {}
	-- hero.mFamilyApplyList[id] = true
-- end

