local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os
local CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleButton,GUIStyleTextField,string,AssetPath,platform,IPhonePlayer = 
CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleButton,GUIStyleTextField,string,AssetPath,platform,IPhonePlayer
local AssetType,GetFirstKey,CharacterType,CFG_star = AssetType,GetFirstKey,CharacterType,CFG_star
local error,IosTestScript = error,IosTestScript
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
local mStarBagPanel = nil
local mStarSetPanel = nil
local mStarViewPanel = nil
local mStarFateManager = nil
local mSetManager = nil
local mSelectAlert = nil

module("LuaScript.View.Panel.StarFate.StarGetPanel")
local mCostTip = nil

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
	mStarBagPanel = require "LuaScript.View.Panel.StarFate.StarBagPanel"
	mStarSetPanel = require "LuaScript.View.Panel.StarFate.StarSetPanel"
	mStarViewPanel = require "LuaScript.View.Panel.StarFate.StarViewPanel"
	mStarFateManager = require "LuaScript.Control.Data.StarFateManager"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
	IsInit = true
end

function Display()
	mCostTip = mSetManager.GetCostTip()
end

function OnGUI()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(83.5,37.5,1016.75-50,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg51_1")
	GUI.DrawTexture(79,115,980,512,image)
	
	GUI.Label(525.5,48,84.2,30,"占星", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	
	local count = 0
	local mStarList = mStarFateManager.GetTempStarList()
	for k,star in pairs(mStarList) do
		local x = count % 7 * 130 + 118
		local y = math.floor(count / 7) * 120 + 138
		DrawStar(x, y, star)

		count = count + 1
	end
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	-- GUI.DrawTexture(143,396,314,61,image)
	
	local starPoint = mStarFateManager.GetStarPoint()
	local scopeCount = mStarFateManager.GetLastScopeCount()
	local str = string.format("星魂数量:%d\n今日还可占星%d次",starPoint,scopeCount)
	GUI.Label(159,399,84.2,30,str, GUIStyleLabel.Left_25_White_Art)
	
	if GUI.Button(156,495,98,105,nil, GUIStyleButton.StarBgBtn) then
		mPanelManager.Show(mStarBagPanel)
		mPanelManager.Hide(OnGUI)
	end
	if GUI.Button(882,502,102,100,nil, GUIStyleButton.StarSkillBtn) then
		mPanelManager.Show(mStarSetPanel)
		mPanelManager.Hide(OnGUI)
	end
	
	local mSelectIndex = mStarFateManager.GetStarLevel()
	if mSelectIndex == 1 then
		if GUI.Button(262,508,99,91,nil, GUIStyleButton.StarGet1Btn) then
			RequestGetStar()
		end
	else
		GUI.Button(262,508,99,91,nil, GUIStyleButton.StarGet1Btn2)
	end
	
	if mSelectIndex == 2 then
		if GUI.Button(406,506,106,93,nil, GUIStyleButton.StarGet2Btn) then
			RequestGetStar()
		end
	else
		GUI.Button(406,506,106,93,nil, GUIStyleButton.StarGet2Btn2)
	end
	
	if mSelectIndex == 3 then
		if GUI.Button(558,501,100,100,nil, GUIStyleButton.StarGet3Btn) then
			RequestGetStar()
		end
	else
		GUI.Button(558,501,100,100,nil, GUIStyleButton.StarGet3Btn2)
	end
	
	if mSelectIndex == 4 then
		if GUI.Button(738,490,130,117,nil, GUIStyleButton.StarGet4Btn) then
			RequestGetStar()
		end
	else
		GUI.Button(738,490,130,117,nil, GUIStyleButton.StarGet4Btn2)
	end
	
	if GUI.Button(450,380,283,83,nil, GUIStyleButton.StarTakeBtn) then
		mStarFateManager.RequestTakeAllStar()
	end
	if GUI.Button(733,380,283,83,nil, GUIStyleButton.StarBreakBtn) then
		mStarFateManager.BreakStar()
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
	
	-- ios test script
	if IosTestScript then
		local image = mAssetManager.GetAsset("Texture/Gui/Button/activate_1")
		GUI.DrawTexture(670,524,64,64,image)
		return
	end
	
	if GUI.Button(670,524,64,64,nil, GUIStyleButton.ActivateBtn) then
		if not mCommonlyFunc.HaveGold(100) then
			return
		end
		if mCostTip then
			function okFun(showTip)
				mStarFateManager.RequestActivateStarFate()
				mCostTip = not showTip
			end
			mSelectAlert.Show("是否花费100元宝激活橙色星运", okFun)
		else
			if mSelectIndex == 4 then
				mSystemTip.ShowTip("橙色星运已经被激活")
			else
				mStarFateManager.RequestActivateStarFate()
			end
		end
	end
end

function DrawStar(x, y, star)
	if GUI.Button(x + 5, y + 93, 61, 55, "拾取", GUIStyleButton.Transparent_Art_25) then
		mStarFateManager.RequestTakeStar(star.index)
	end
	if GUI.Button(x + 65, y + 93, 61, 55, "分解", GUIStyleButton.Transparent_Art_25) then
		mStarFateManager.BreakStar(star.index)
	end
	
	local cfg_star = CFG_star[star.bid]
	-- local image = mAssetManager.GetAsset("Texture/Icon/Star/"..cfg_star.resId)
	if DrawItemCell(cfg_star, ItemType.Star, x, y, 100, 100)then
		mStarViewPanel.SetData(star)
		mPanelManager.Show(mStarViewPanel)
	end
end

function RequestGetStar()
	if not mCommonlyFunc.HaveMoney(10000) then
		return
	end
	
	if mStarFateManager.GetLastScopeCount() > 0 then
		mStarFateManager.RequestGetStar()
	else
		--ios test script
		if IosTestScript then
			mSystemTip.ShowTip("今日占星次数已用完")
			return
		end
		if not mCommonlyFunc.HaveGold(10) then
			return
		end
		if mCostTip then
			function okFun(showTip)
				mStarFateManager.RequestGetStar()
				mCostTip = not showTip
			end
			mSelectAlert.Show("是否花费10元宝购买1次占星次数", okFun)
		else
			mStarFateManager.RequestGetStar()
		end
	end
end