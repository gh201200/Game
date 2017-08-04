local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Goods,CFG_task,Camera,Screen = 
print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Goods,CFG_task,Camera,Screen
local PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent = 
PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent
local CFG_ship,EventType,CFG_guide,SplitString,ActionType,CFG_Equip,GUI,CFG_copyMap,CsWorldToScreenPoint,GetTransform = 
CFG_ship,EventType,CFG_guide,SplitString,ActionType,CFG_Equip,GUI,CFG_copyMap,CsWorldToScreenPoint,GetTransform
local CFG_harbor,CFG_starSkill,ConstValue = CFG_harbor,CFG_starSkill,ConstValue

local mAssetManager = nil
local mEventManager = nil
local mNetManager = nil
local mShipManager = nil
local mGuidePanel = nil
local mShopPanel = nil
local mTaskManager = nil
local mPanelManager = nil
local mShopBuyPanel = nil
local mShipyardPanel = nil
local mTavernPanel = nil
local mMainPanel = nil
local mEquipViewPanel = nil
local mEquipUpPanel = nil
local mCopyMapViewPanel = nil
local mCopyMapPanel = nil
local mMainBuildPanel = nil
local mBuildViewPanel = nil
local mItemBagPanel = nil
local mSailorPanel = nil
local mEquipSelectPanel = nil
local mSetManager = nil
-- local mMoveSelectPanel = nil
local mMapPanel = nil
local mHarborIntoPanel = nil
local mCommonlyFunc = nil
local mHeroManager = nil
local mCharViewPanel = nil
local mCharManager = nil
local mSceneManager = nil
local mGoodsManager = nil
local mActionOpenTip = nil
local mMoveManager = nil
local mAlert = nil
local mSelectAlert = nil
local mBattleAwardPanel = nil
local mSailorViewPanel = nil
local mSailorSelectPanel = nil
local mTaskPanel = nil
local mHeroPanel = nil
local mShipSelectPanel = nil
local mShipTeamCreatePanel = nil
local mFleetPanel = nil
local mReceiveAwardPanel = nil
local mPromptAlert = nil
local mStarFateManager = nil
-- local mStarSetPanel = nil
-- local mStarGetPanel = nil
-- local mStarSelectPanel = nil
-- local mStarSkillViewPanel = nil
local mItemViewPanel = nil
local mHarborManager = nil
local mMainPanel = nil
module("LuaScript.Control.Data.GuideManager")
local mGuideList = {}
local mLog = {}
local mStopGuide = false

function Init()
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mMoveManager = require "LuaScript.Control.Scene.MoveManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mGoodsManager = require "LuaScript.Control.Data.GoodsManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mShipManager = require "LuaScript.Control.Data.ShipManager"
	mShopPanel = require "LuaScript.View.Panel.Harbor.ShopPanel"
	mShipyardPanel = require "LuaScript.View.Panel.Harbor.ShipyardPanel"
	mShopBuyPanel = require "LuaScript.View.Panel.Harbor.ShopBuyPanel"
	mGuidePanel = require "LuaScript.View.Panel.Task.GuidePanel"
	mTavernPanel = require "LuaScript.View.Panel.Harbor.TavernPanel"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mCopyMapViewPanel = require "LuaScript.View.Panel.CopyMap.CopyMapViewPanel"
	mCopyMapPanel = require "LuaScript.View.Panel.CopyMap.CopyMapPanel"
	mMainBuildPanel = require "LuaScript.View.Panel.Harbor.MainBuildPanel"
	mTaskManager = require "LuaScript.Control.Data.TaskManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mBuildViewPanel = require "LuaScript.View.Panel.Harbor.BuildViewPanel"
	mLabPanel = require "LuaScript.View.Panel.Harbor.LabPanel"
	mItemBagPanel = require "LuaScript.View.Panel.Item.ItemBagPanel"
	mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mSetManager = require "LuaScript.Control.System.SetManager"
	-- mMoveSelectPanel = require "LuaScript.View.Panel.Map.MoveSelectPanel"
	mMapPanel = require "LuaScript.View.Panel.Map.MapPanel"
	mHarborIntoPanel = require "LuaScript.View.Panel.Harbor.HarborIntoPanel"
	mCharViewPanel = require "LuaScript.View.Panel.View.CharViewPanel"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mActionOpenTip = require "LuaScript.View.Tip.ActionOpenTip"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
	mBattleAwardPanel = require "LuaScript.View.Panel.Battle.BattleAwardPanel"
	mSailorViewPanel = require "LuaScript.View.Panel.Sailor.SailorViewPanel"
	mSailorSelectPanel = require "LuaScript.View.Panel.Sailor.SailorSelectPanel"
	mTaskPanel = require "LuaScript.View.Panel.Task.TaskPanel"
	mHeroPanel = require "LuaScript.View.Panel.HeroPanel"
	mShipSelectPanel = require "LuaScript.View.Panel.Harbor.ShipSelectPanel"
	mShipTeamCreatePanel = require "LuaScript.View.Panel.ShipTeam.ShipTeamCreatePanel"
	mFleetPanel = require "LuaScript.View.Panel.Fleet.FleetPanel"
	mReceiveAwardPanel = require "LuaScript.View.Panel.Item.ReceiveAwardPanel"
	mPromptAlert = require "LuaScript.View.Alert.PromptAlert"
	mStarFateManager = require "LuaScript.Control.Data.StarFateManager"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	-- mStarSetPanel = require "LuaScript.View.Panel.StarFate.StarSetPanel"
	-- mStarGetPanel = require "LuaScript.View.Panel.StarFate.StarGetPanel"
	-- mStarSelectPanel = require "LuaScript.View.Panel.StarFate.StarSelectPanel"
	-- mStarSkillViewPanel = require "LuaScript.View.Panel.StarFate.StarSkillViewPanel"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
    
	-- 添加监听
	mEventManager.AddEventListen(nil,EventType.OnRefreshGuide,OnRefreshGuide)
	-- mEventManager.AddEventListen(nil,EventType.OnRefreshRedPoint,OnRefreshRedPoint)
	-- mEventManager.AddEventListen(nil,EventType.OnTavernRefresh,OnTavernRefresh)
	-- mEventManager.AddEventListen(nil,EventType.OnSelectSailor,OnSelectSailor)
end

function SetStopGuide(value)
	-- print("SetStopGuide", value)
	mStopGuide = value
end

function GetGuideList(type)
	if not mGuideList[type] then
		local list = {}
		for k,v in pairs(CFG_guide) do
			if v.type == type then
				table.insert(list, v)
			end
		end
		mGuideList[type] = list
	end
	return mGuideList[type]
end

function OnRefreshRedPoint()
	
end

function OnRefreshGuide()
	-- if not mSetManager.GetGuide() then
		-- return
	-- end
	-- print("OnRefreshGuide", mStopGuide)
	-- if mStopGuide then
		-- return
	-- end

	mPanelManager.Hide(mGuidePanel)
	-- print(1)
	if mActionOpenTip.visible then
		return
	end
-- print(2)
	local hero = mHeroManager.GetHero()
	if not hero then
		return
	end
-- print(3)
	if hero.SceneType == SceneType.Battle then
		if mBattleAwardPanel.IsVisible() and mBattleAwardPanel.enable and hero.level < 20 then
			mGuidePanel.SetData(2)
			mPanelManager.Show(mGuidePanel)
			return
		elseif hero.level > 1 then
			mPanelManager.Hide(mGuidePanel)
			return
		end
	end
	-- print(4)
	local task = mTaskManager.GetMainTask()
	if not task then
		return
	end
	local cfg_task = CFG_task[task.id]
	if cfg_task then
		-- cfg_task.guide = 17
		-- cfg_task.target[2] = 3
	end
	-- print(5)
	if cfg_task and cfg_task.guide ~= 0 then
		local guideList = GetGuideList(cfg_task.guide)
		if mAlert.enable or mSelectAlert.enable or mPromptAlert.enable then
			return
		end
		
		--出售特产引导
		if cfg_task.guide == 21 then
			if mMainPanel.enable and hero.SceneType == SceneType.Harbor then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mShopPanel.enable then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			end
		--出售特产引导
		elseif cfg_task.guide == 1 then
			if mMainPanel.enable and hero.SceneType == SceneType.Harbor and mGoodsManager.HaveGoodsByHero()  then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mShopPanel.enable and mGoodsManager.HaveGoodsByHero() then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			end
		-- 购买特产引导
		elseif cfg_task.guide == 2 then
			if mMainBuildPanel.enable then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mSailorPanel.enable then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mCopyMapPanel.enable then
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			elseif mFleetPanel.enable then
				mGuidePanel.SetData(guideList[4].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and hero.SceneType == SceneType.Harbor and mShopPanel.IsInit and mShopPanel.GetGoodsPosition(cfg_task.target[2]) ~= 0 then
				mGuidePanel.SetData(guideList[5].id)
				mPanelManager.Show(mGuidePanel)
			elseif mShopPanel.enable and not mShopBuyPanel.enable then
				local guid = guideList[6]
				guid.x = mShopPanel.GetGoodsPosition(cfg_task.target[2])
				if guid.x == 0 then
					return
				end
				mGuidePanel.SetData(guideList[6].id)
				mPanelManager.Show(mGuidePanel)
			elseif mShopBuyPanel.enable then
				mGuidePanel.SetData(guideList[7].id)
				mPanelManager.Show(mGuidePanel)
			end
			-- 造船
		elseif cfg_task.guide == 3 then
			if mMainBuildPanel.enable then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mLabPanel.enable then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mShopPanel.enable then
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and hero.SceneType == SceneType.Harbor and mHarborManager.HarborIsMy() then
				mGuidePanel.SetData(guideList[4].id)
				mPanelManager.Show(mGuidePanel)
			elseif mShipyardPanel.enable and mShipyardPanel.mPage == 1 and mHarborManager.HarborIsMy() then
				local guide = guideList[5]
				guide.y = 225 + (cfg_task.target[2] - 1) * 145
				
				mGuidePanel.SetData(guideList[5].id)
				mPanelManager.Show(mGuidePanel)
			end
			-- 上船
		elseif cfg_task.guide == 4 then
			local mCurUseCount = mShipManager.GetUseCount()
			-- print(mCurUseCount)
			if mShopPanel.enable then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mShipyardPanel.enable then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and not (mMainPanel.GetShowMode() == 0) then
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and mMainPanel.GetShowMode() == 0 then
				local guide = guideList[4]
				local x,y,width,height = mMainPanel.GetButtonPosition(ActionType.Fleet)
				guide.x = x
				guide.y = y
				guide.width = width
				guide.height = height
				if not guide.x then
					return
				end
				mGuidePanel.SetData(guideList[4].id)
				mPanelManager.Show(mGuidePanel)
			elseif mShipSelectPanel.enable then
				mGuidePanel.SetData(guideList[7].id)
				mPanelManager.Show(mGuidePanel)
			elseif mFleetPanel.enable and mCurUseCount == 3 and mFleetPanel.GetPag() == 1 then
				mGuidePanel.SetData(guideList[5].id)
				mPanelManager.Show(mGuidePanel)
			elseif mFleetPanel.enable and mFleetPanel.GetPag() == 1 then
				local count = cfg_task.target[4]
				local guid =  guideList[6]
				guid.y = 157 + mCurUseCount * 140
				mGuidePanel.SetData(guideList[6].id)
				mPanelManager.Show(mGuidePanel)
			-- elseif mStarSetPanel.enable then
				-- mGuidePanel.SetData(guideList[8].id)
				-- mPanelManager.Show(mGuidePanel)
			end
			-- 招募船员
		elseif cfg_task.guide == 5 then
			if mMainPanel.enable and hero.SceneType == SceneType.Harbor then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mTavernPanel.enable then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			end
			-- 银两刷新
		elseif cfg_task.guide == 6 then
			if mFleetPanel.enable then
				-- print(1111)
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mShopPanel.enable then
				-- print(2222)
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and hero.SceneType == SceneType.Harbor then
				-- print(3333)
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			elseif mTavernPanel.enable then
				local type = cfg_task.target[2]
				local guid =  guideList[4]
				if type == 1 then
					guid.x = 237
				elseif type == 2 then
					guid.x = 241 + 278
				else
					guid.x = 241 + 2 * 281 + 4
				end
				guid.y = 515
				
				mGuidePanel.SetData(guideList[4].id)
				mPanelManager.Show(mGuidePanel)
			end
			-- 元宝刷新
		elseif cfg_task.guide == 7 then
			if mFleetPanel.enable then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and hero.SceneType == SceneType.Harbor then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mTavernPanel.enable then
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			end
			-- 船员参战
		elseif cfg_task.guide == 8 then
			if mSailorViewPanel.enable then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mTavernPanel.enable then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and not (mMainPanel.GetShowMode() == 0) then
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and mMainPanel.GetShowMode() == 0 then
				local guide = guideList[4]
				local x,y,width,height = mMainPanel.GetButtonPosition(ActionType.Sailor)
				guide.x = x
				guide.y = y
				guide.width = width
				guide.height = height
				if not guide.x then
					return
				end
				mGuidePanel.SetData(guideList[4].id)
				mPanelManager.Show(mGuidePanel)
			elseif mSailorPanel.enable and mSailorPanel.GetPage() == 1 then
				local count = cfg_task.target[2]
				local guid =  guideList[5]
				guid.x = 179 + 93 * (count - 1)
				mGuidePanel.SetData(guideList[5].id)
				mPanelManager.Show(mGuidePanel)
			elseif mSailorSelectPanel.enable then
				mGuidePanel.SetData(guideList[6].id)
				mPanelManager.Show(mGuidePanel)
			end
			-- 穿戴装备
		elseif cfg_task.guide == 9 then
			if mFleetPanel.enable then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and not (mMainPanel.GetShowMode() == 0) then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and mMainPanel.GetShowMode() == 0 then
				local guide = guideList[3]
				local x,y,width,height = mMainPanel.GetButtonPosition(ActionType.Sailor)
				guide.x = x
				guide.y = y
				guide.width = width
				guide.height = height
				if not guide.x then
					return
				end
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			elseif mSailorPanel.enable and not mEquipViewPanel.enable and mSailorPanel.GetPage() == 1 then
				-- local cfg_Equip = CFG_Equip[cfg_task.target[2]]
				local guide = guideList[4]
				guide.x,guide.y = mSailorPanel.GetSlotPosition(cfg_task.target[2])
				
				mGuidePanel.SetData(guideList[4].id)
				mPanelManager.Show(mGuidePanel)
			elseif mEquipSelectPanel.enable  then
				mGuidePanel.SetData(guideList[5].id)
				mPanelManager.Show(mGuidePanel)
			end
			-- 装备强化
		elseif cfg_task.guide == 10 then
			local _,selectIndex = mSailorPanel.GetSelect()
			if mMainPanel.enable and not (mMainPanel.GetShowMode() == 0) then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and mMainPanel.GetShowMode() == 0 then
				local guide = guideList[2]
				local x,y,width,height = mMainPanel.GetButtonPosition(ActionType.Sailor)
				guide.x = x
				guide.y = y
				guide.width = width
				guide.height = height
				if not guide.x then
					return
				end
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mSailorPanel.enable and selectIndex == 1 and mSailorPanel.GetPage() == 1 then
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			elseif mSailorPanel.visible and mEquipViewPanel.enable and not mEquipUpPanel.enable  then
				mGuidePanel.SetData(guideList[4].id)
				mPanelManager.Show(mGuidePanel)
			-- elseif mEquipUpPanel.enable and mEquipUpPanel.mSelectGemId == 0 then
				-- mGuidePanel.SetData(guideList[5].id)
				-- mPanelManager.Show(mGuidePanel)
			elseif mEquipUpPanel.enable then
				mGuidePanel.SetData(guideList[6].id)
				mPanelManager.Show(mGuidePanel)
			end
			-- 打副本
		elseif cfg_task.guide == 11 then	
			-- print(11111111111111111111)
			-- print(hero.SceneType , SceneType.Harbor)
			local hero = mHeroManager.GetHero()
			if mSailorPanel.enable then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and hero.SceneType == SceneType.Harbor and mMainPanel.GetShowMode() == 0 then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and hero.SceneType == SceneType.Harbor and mMainPanel.GetShowMode() == 1 then
				ResetPositionByMenu(guideList[3].id, ActionType.CopyMap)
				if not guideList[3].x then
					return
				end
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			elseif mCopyMapPanel.enable and not mCopyMapViewPanel.enable and hero.SceneType == SceneType.Harbor  then
				local cfg_copyMap = CFG_copyMap[cfg_task.target[2]]
				local guide = guideList[4]
				guide.x = cfg_copyMap.x
				guide.y = cfg_copyMap.y + 13
				
				mGuidePanel.SetData(guideList[4].id)
				mPanelManager.Show(mGuidePanel)
			elseif mCopyMapPanel.visible and mCopyMapViewPanel.enable and hero.SceneType == SceneType.Harbor then
				mGuidePanel.SetData(guideList[5].id)
				mPanelManager.Show(mGuidePanel)
			end
			 -- 升级主城
		elseif cfg_task.guide == 12 then
			if mReceiveAwardPanel.enable then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mHeroPanel.enable then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mShopPanel.enable then
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and hero.SceneType == SceneType.Harbor  and mHarborManager.GetMaxLevelSelfHarborId() == hero.harborId then
				mGuidePanel.SetData(guideList[4].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainBuildPanel.enable and not mBuildViewPanel.enable  and mHarborManager.GetMaxLevelSelfHarborId() == hero.harborId then
				local buildId = cfg_task.target[2]
				if cfg_task.target[1] == 23 then
					buildId = cfg_task.target[3]
				end
				-- local cfg_copyMap = CFG_copyMap[cfg_task.target[2]]
				local guide = guideList[5]
				if buildId > 3 then
					guide.y = 2 * 145 + 226
					mMainBuildPanel.mScrollPositionY = GUI.modulus*(buildId-3) * 145 
				else
					guide.y = (buildId - 1) * 145 + 226
				end
				
				mGuidePanel.SetData(guideList[5].id)
				mPanelManager.Show(mGuidePanel)
			end
			-- 升级科技
		elseif cfg_task.guide == 13 then
			if mShopPanel.enable then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and hero.SceneType == SceneType.Harbor and mHarborManager.HarborIsMy() then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mLabPanel.enable and mHarborManager.HarborIsMy() then
				local cfg_copyMap = CFG_copyMap[cfg_task.target[2]]
				local guide = guideList[3]
				guide.y = (cfg_task.target[2] - 1) * 145 + 226
				
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			end
			-- 物品使用
		elseif cfg_task.guide == 14 then
			if mMainPanel.enable and not (mMainPanel.GetShowMode() == 0) then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and mMainPanel.GetShowMode() == 0 then
				local guide = guideList[2]
				local x,y,width,height = mMainPanel.GetButtonPosition(ActionType.Item)
				guide.x = x
				guide.y = y
				guide.width = width
				guide.height = height
				if not guide.x then
					return
				end
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mItemBagPanel.enable and not mItemViewPanel.enable then
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			elseif mItemViewPanel.enable then
				mGuidePanel.SetData(guideList[4].id)
				local guid =  guideList[4]
				-- guid.x,guid.y = mItemViewPanel.getUseBtnPos()
				mPanelManager.Show(mGuidePanel)
			end
			-- 移至港口
		elseif cfg_task.guide == 15 then
			-- print( cfg_task.target)
			local harborId = cfg_task.target[2]
			if mEquipUpPanel.enable then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mSailorPanel.enable then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mShopPanel.enable then
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			-- elseif mMapPanel.enable and not mMapPanel.GetMoveSelectVisible() then
				-- local cfg_harbor = CFG_harbor[harborId]
				-- mMapPanel.SetCenter(cfg_harbor.showX, cfg_harbor.showY)
				
				-- local x,y = mMapPanel.GetHarborPosition(harborId)
				-- local guid =  guideList[5]
				-- if GUI.modulus > 1 then
					-- guid.x = x + 55 - 32
					-- guid.y = y + 112 - 32
					
					-- guid.width = 60
					-- guid.heigth = 60
				-- else
					-- guid.x = x/GUI.modulus + 55 - 30/GUI.modulus
					-- guid.y = y/GUI.modulus + 112 - 32/GUI.modulus
					
					-- guid.width = 60/GUI.modulus
					-- guid.heigth = 60/GUI.modulus
				-- end
				-- print(guid.y)
				-- function OkFunc()
					-- print("1")
					-- mMapPanel.SelectHarbor(harborId)
				-- end
				
				-- mGuidePanel.SetData(guideList[5].id, OkFunc)
				-- mPanelManager.Show(mGuidePanel)
			-- elseif mMapPanel.enable and mMapPanel.GetMoveSelectVisible() then
				-- local x,y = mMapPanel.GetHarborPosition(harborId)
				-- local guid =  guideList[6]
				-- if GUI.modulus > 1 then
					-- guid.x = x - 60 + 55
					-- guid.y = y - 75 + 112
					
					-- guid.width = 71
					-- guid.heigth = 78
				-- else
					-- guid.x = x/GUI.modulus - 60/GUI.modulus + 55
					-- guid.y = y/GUI.modulus - 71/GUI.modulus + 112
					
					-- guid.width = 71/GUI.modulus
					-- guid.heigth = 78/GUI.modulus
				-- end
				-- function OkFunc()
					-- print("2")
					-- mHeroManager.GotoHarbor(harborId)
					
					-- local hero = mHeroManager.GetHero()
					-- if hero.SceneType ~= SceneType.Harbor then
						-- mPanelManager.Hide(mMapPanel)
						-- mPanelManager.Show(mMainPanel)
						-- mSceneManager.SetMouseEvent(true)
					-- end
				-- end
				-- mGuidePanel.SetData(guideList[6].id, OkFunc)
				-- mPanelManager.Show(mGuidePanel)
			-- elseif mHarborIntoPanel.enable and mHarborIntoPanel.mHarborId == harborId then
				-- mGuidePanel.SetData(guideList[7].id)
				-- mPanelManager.Show(mGuidePanel)
			-- elseif not mHeroManager.IsMoving() then
				-- mGuidePanel.SetData(guideList[4].id)
				-- mPanelManager.Show(mGuidePanel)
			end
			-- 攻占港口
		elseif cfg_task.guide == 16 then
			local harborId = cfg_task.target[2]
			if mHarborIntoPanel.enable and mHarborIntoPanel.mHarborId == harborId then
				mGuidePanel.SetData(guideList[4].id)
				mPanelManager.Show(mGuidePanel)
			end
			-- 加入联盟
		elseif cfg_task.guide == 17 then
			if mSailorViewPanel.enable then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mItemBagPanel.enable then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and not (mMainPanel.GetShowMode() == 0) then
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and mMainPanel.GetShowMode() == 0 then
				local guide = guideList[4]
				local x,y,width,height = mMainPanel.GetButtonPosition(ActionType.Family)
				guide.x = x
				guide.y = y
				guide.width = width
				guide.height = height
				if not guide.x then
					return
				end
				mGuidePanel.SetData(guideList[4].id)
				mPanelManager.Show(mGuidePanel)
			end
			--悬赏任务
		elseif cfg_task.guide == 18 then
			if mHeroManager.IsMoving() then
				mGuidePanel.SetData(1)
				mPanelManager.Show(mGuidePanel)
				return
			end
			local randomTask = mTaskManager.GetRandomTask()
			local hero = mHeroManager.GetHero()
			if mMainPanel.enable and hero.SceneType == SceneType.Harbor then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mTavernPanel.enable and mTavernPanel.mPage == 1 then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mTavernPanel.enable and mTavernPanel.mPage == 2 and not randomTask then
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			elseif mTavernPanel.enable and mTavernPanel.mPage == 2 and randomTask then
				mGuidePanel.SetData(guideList[4].id)
				mPanelManager.Show(mGuidePanel)
			end
			--攻击海盗
		elseif cfg_task.guide == 20 then
			-- print("!!!!!!!!!!!!!!!!")
			if mHeroManager.IsMoving() then
				mGuidePanel.SetData(1)
				mPanelManager.Show(mGuidePanel)
				return
			end
			local harborId = cfg_task.target[2]
			local hero = mHeroManager.GetHero()
			if hero.SceneType == SceneType.Normal and mSceneManager.GetMouseEventState() and not mCharViewPanel.enable then
				local enemy = mCharManager.GetNearEnemy(cfg_task.target[2])
				if enemy then
					mHeroManager.StopMove()
					function OkFunc()
						-- print(enemy)
						mCharViewPanel.SetData(enemy)
						mPanelManager.Show(mCharViewPanel)
						-- mSceneManager.SetMouseEvent(false)
					end
					
					local cs_Ship = mCharManager.GetCsShip(enemy.ships[1].id)
					local position = GetTransform(cs_Ship).position
					local x,y = CsWorldToScreenPoint(Camera.mainCamera,position.x,0,position.z)
					local guid =  guideList[1]
					guid.x = GUI.UnHorizontalRestX(x) - 50
					guid.y = GUI.UnVerticalRestY(Screen.height - y) - 84
					
					mGuidePanel.SetData(guideList[1].id, OkFunc)

					mPanelManager.Show(mGuidePanel)
					-- mSceneManager.SetMouseEvent(false)
				end
			elseif mCharViewPanel.enable then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			end
			-- 使用任务导航
		elseif cfg_task.guide == 22 then
			-- print("!!!!!!!!!!!!!!!!")
			-- if mHeroManager.IsMoving() then
				-- mGuidePanel.SetData(1)
				-- mPanelManager.Show(mGuidePanel)
				-- return
			-- end
			if mEquipUpPanel.enable then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mSailorPanel.enable then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and not (mMainPanel.GetShowMode() == 0) then
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			-- elseif mMainPanel.enable and mMainPanel.GetShowMode() == 0 then
				-- local guide = guideList[4]
				-- local x,y,width,height = mMainPanel.GetButtonPosition(ActionType.Task)
				-- guide.x = x
				-- guide.y = y
				-- guide.width = width
				-- guide.height = height
				-- if not guide.x then
					-- return
				-- end
				-- mGuidePanel.SetData(guideList[4].id)
				-- mPanelManager.Show(mGuidePanel)
			-- elseif mTaskPanel.enable then
				-- local guide = guideList[5]
				-- guide.x,guide.y = mTaskPanel.GetMovePosition(task)
				
				-- mGuidePanel.SetData(guideList[5].id)
				-- mPanelManager.Show(mGuidePanel)
			end
			-- 点击进入交易所
		elseif cfg_task.guide == 23 then
			-- print(11111)
			if mMainBuildPanel.enable then
				-- print(2222)
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mHeroPanel.enable then
				-- print(2222)
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and hero.SceneType == SceneType.Harbor then
			-- print(3333)
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			end
			-- 点击进入酒馆
		elseif cfg_task.guide == 24 then
			if mShopPanel.enable then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and hero.SceneType == SceneType.Harbor then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			end
			-- 点击进入研究所
		elseif cfg_task.guide == 25 then
			if mLabPanel.enable and mHarborManager.GetMaxLevelSelfHarborId() == hero.harborId then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and hero.SceneType == SceneType.Harbor and not mShipyardPanel.enable and mHarborManager.GetMaxLevelSelfHarborId() == hero.harborId then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			end
		-- 打开商队
		elseif cfg_task.guide == 26 then
			if mSailorViewPanel.enable then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mItemBagPanel.enable then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			-- elseif not mHeroPanel.enable and not mShipTeamCreatePanel.enable and not mSailorSelectPanel.enable 
				-- and not mShipSelectPanel.enable then
				-- mGuidePanel.SetData(guideList[3].id)
				-- mPanelManager.Show(mGuidePanel)
			elseif mHeroPanel.enable and mHeroPanel.mPage ~= 3 then
				mGuidePanel.SetData(guideList[4].id)
				mPanelManager.Show(mGuidePanel)
			end
		-- 创建商队
		elseif cfg_task.guide == 27 then
			-- if not mHeroPanel.enable and not mShipTeamCreatePanel.enable and not mSailorSelectPanel.enable 
				-- and not mShipSelectPanel.enable then
				-- mGuidePanel.SetData(guideList[1].id)
				-- mPanelManager.Show(mGuidePanel)
			-- else
			if mHeroPanel.enable and mHeroPanel.mPage ~= 3 then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mHeroPanel.enable and mHeroPanel.mPage == 3 then
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			elseif mShipTeamCreatePanel.enable and not mShipTeamCreatePanel.GetSelectSailor() then
				mGuidePanel.SetData(guideList[4].id)
				mPanelManager.Show(mGuidePanel)
			elseif mSailorSelectPanel.visible then
				-- print(111111)
				mGuidePanel.SetData(guideList[5].id)
				mPanelManager.Show(mGuidePanel)
			elseif mShipTeamCreatePanel.enable and not mShipTeamCreatePanel.GetSelectShip() then
				mGuidePanel.SetData(guideList[6].id)
				mPanelManager.Show(mGuidePanel)
			elseif mShipSelectPanel.visible then
				mGuidePanel.SetData(guideList[7].id)
				mPanelManager.Show(mGuidePanel)
			elseif mShipTeamCreatePanel.enable then
				mGuidePanel.SetData(guideList[8].id)
				mPanelManager.Show(mGuidePanel)
			end
		-- 领取港口收益
		elseif cfg_task.guide == 28 then
			if mMainPanel.enable and not (mMainPanel.GetShowMode() == 0) then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif not mHeroPanel.enable and mMainPanel.enable and mMainPanel.GetShowMode() == 0  then
				ResetPositionByMenu(guideList[2].id, ActionType.Hero)
				if guideList[2].x then
					mGuidePanel.SetData(guideList[2].id)
					mPanelManager.Show(mGuidePanel)
				end
			elseif mHeroPanel.enable and mHeroPanel.mPage ~= 2 then
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			elseif mHeroPanel.enable then
				mGuidePanel.SetData(guideList[4].id)
				mPanelManager.Show(mGuidePanel)
			end
		-- 使用技能
		elseif cfg_task.guide == 29 then
			if hero.SceneType == SceneType.Battle and not hero.moved then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif hero.SceneType == SceneType.Battle then
				local mActiveSkillList = mStarFateManager.GetActionSkillList()
				local ragePoint = mStarFateManager.GetRagePoint()
				local index = 0
				for k,skill in pairs(mActiveSkillList) do
					local cfg_starSkill = CFG_starSkill[skill.id]
					if cfg_starSkill.anger <= ragePoint then
						index = k + 1
					end
				end
				if index ~= 0 then
					mGuidePanel.SetData(guideList[index].id)
					mPanelManager.Show(mGuidePanel)
					return
				end
			end
		-- 穿戴装备
		elseif cfg_task.guide == 33 then
			if mFleetPanel.enable then
				mGuidePanel.SetData(guideList[1].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and not (mMainPanel.GetShowMode() == 0) then
				mGuidePanel.SetData(guideList[2].id)
				mPanelManager.Show(mGuidePanel)
			elseif mMainPanel.enable and mMainPanel.GetShowMode() == 0 then
				local guide = guideList[3]
				local x,y,width,height = mMainPanel.GetButtonPosition(ActionType.Sailor)
				guide.x = x
				guide.y = y
				guide.width = width
				guide.height = height
				if not guide.x then
					return
				end
				mGuidePanel.SetData(guideList[3].id)
				mPanelManager.Show(mGuidePanel)
			elseif mSailorPanel.enable and not mEquipViewPanel.enable then
				mGuidePanel.SetData(guideList[4].id)
				mPanelManager.Show(mGuidePanel)
			end
		end
		-- print(111)
		-- print(111)
		local alertList = mPanelManager.mPanelList[ConstValue.AlertPanel]
		-- print(not mGuidePanel.visible and hero.SceneType ~= SceneType.Battle and mMainPanel.enable and not alertList[1])
		if not mGuidePanel.visible and hero.SceneType ~= SceneType.Battle and mHeroManager.IsMoving() then
			mGuidePanel.SetData(1)
			mPanelManager.Show(mGuidePanel)
		elseif not mGuidePanel.visible and hero.SceneType ~= SceneType.Battle and mMainPanel.enable and not alertList[1] then
			mGuidePanel.SetData(3)
			mPanelManager.Show(mGuidePanel)
		end
	end
	
	-- mPanelManager.Hide(mGuidePanel)
end

function ResetPositionByMenu(guideId, actionType)
	local guide = CFG_guide[guideId]
	local x,y,width,height = mMainPanel.GetButtonPosition(actionType)
	guide.x = x
	guide.y = y
	guide.width = width
	guide.heigth = height
	-- if not guide.x then
		-- return
	-- end
end