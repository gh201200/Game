local _G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,SplitString,CFG_task,require,table,PackatHead,Packat_Quest = 
_G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,SplitString,CFG_task,require,table,PackatHead,Packat_Quest
local ByteArray,EventType,AppearEvent,CFG_taskAward,ReplaceString,os,math,SceneType,CFG_harbor,CFG_randomTask = 
ByteArray,EventType,AppearEvent,CFG_taskAward,ReplaceString,os,math,SceneType,CFG_harbor,CFG_randomTask
local CFG_action,CFG_product,PanelIndex,CFG_EnemyPosition,Packat_Player,CFG_ship,Color,CFG_Enemy = 
CFG_action,CFG_product,PanelIndex,CFG_EnemyPosition,Packat_Player,CFG_ship,Color,CFG_Enemy
local mGuidePanel = nil
local mNetManager = nil
local mDialogPanel = nil
local mPanelManager = nil
local mHeroTip = nil
local mActionOpenTip = nil
local mHeroManager = nil
local mActionManager = nil
local mShipManager = nil
local mHarborManager = nil
local mSceneManager = nil
local mLabManager = nil
local mMainPanel = nil
local mGuideManager = nil
local mTaskTip = nil
local mCharManager = nil
local mCopyMapPanel = nil
local mMoveManager = nil
local mAnimationManager = nil
local mSailorToTeam = nil
local mGoodsManager = nil
local mTurntablePanel = nil
local mHarborManger = nil
local mCommonlyFunc = nil
local mSetManager = nil
local mShopPanel = nil
local mSystemTip = nil
local mShipyardPanel = nil
local mFleetPanel = nil
local mTavernPanel = nil
local mSailorPanel = nil
local mLabPanel = nil
local mHeroPanel = nil
local mMainBuildPanel = nil
local mFamilyPanel = nil
local mItemPanel = nil
local mTreasureManager = nil
module("LuaScript.Control.Data.TaskManager")

local mMainTaskProgress = 0
local mMainTaskId = 0
local mRandomTaskId = 0

local mDoingList = nil
local mDoingListById = nil
local mAutoCompleteTaskList = {}
local mFinishList = nil

local mRandomTaskInfo = nil

local mRefreshing = nil
local mTaskTasking = nil

-- 世界任务
local mGlobalMission = nil

function Init()
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mGuidePanel = require "LuaScript.View.Panel.Task.GuidePanel"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mDialogPanel = require "LuaScript.View.Panel.Task.DialogPanel"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mMoveManager = require "LuaScript.Control.Scene.MoveManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mHeroTip = require "LuaScript.View.Tip.HeroTip"
	mActionOpenTip = require "LuaScript.View.Tip.ActionOpenTip"
	mActionManager = require "LuaScript.Control.ActionManager"
	mShipManager = require "LuaScript.Control.Data.ShipManager"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mLabManager = require "LuaScript.Control.Data.LabManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mGuideManager = require "LuaScript.Control.Data.GuideManager"
	mAnimationManager = require "LuaScript.Control.Data.AnimationManager"
	mTaskTip = require "LuaScript.View.Tip.TaskTip"
	mCopyMapPanel = require "LuaScript.View.Panel.CopyMap.CopyMapPanel"
	mSailorToTeam = require "LuaScript.View.Animation.SailorToTeam"
	mGoodsManager = require "LuaScript.Control.Data.GoodsManager"
	mTurntablePanel = require "LuaScript.View.Panel.Turntable.TurntablePanel"
	mHarborManger = require "LuaScript.Control.Scene.HarborManager"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mShopPanel = require "LuaScript.View.Panel.Harbor.ShopPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mShipyardPanel = require "LuaScript.View.Panel.Harbor.ShipyardPanel"
	mFleetPanel = require "LuaScript.View.Panel.Fleet.FleetPanel"
	mTavernPanel = require "LuaScript.View.Panel.Harbor.TavernPanel"
	mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
	mLabPanel = require "LuaScript.View.Panel.Harbor.LabPanel"
	mHeroPanel = require "LuaScript.View.Panel.HeroPanel"
	mMainBuildPanel = require "LuaScript.View.Panel.Harbor.MainBuildPanel"
	mFamilyPanel = require "LuaScript.View.Panel.Family.FamilyPanel"
	mItemPanel = require "LuaScript.View.Panel.Item.ItemBagPanel"
	mTreasureManager = require "LuaScript.Control.Scene.TreasureManager"
	
	mNetManager.AddListen(PackatHead.QUEST, Packat_Quest.SEND_ADD_QUEST, SEND_ADD_QUEST)
	mNetManager.AddListen(PackatHead.QUEST, Packat_Quest.SEND_QUEST_FINISH, SEND_QUEST_FINISH)
	mNetManager.AddListen(PackatHead.QUEST, Packat_Quest.SEND_QUEST_PARAM, SEND_QUEST_PARAM)
	mNetManager.AddListen(PackatHead.QUEST, Packat_Quest.SEND_ALL_FINISHED_QUEST, SEND_ALL_FINISHED_QUEST)
	mNetManager.AddListen(PackatHead.QUEST, Packat_Quest.SEND_ALL_QUEST, SEND_ALL_QUEST)
	mNetManager.AddListen(PackatHead.QUEST, Packat_Quest.SEND_RANDOM_QUEST_INFO, SEND_RANDOM_QUEST_INFO)
	mNetManager.AddListen(PackatHead.QUEST, Packat_Quest.SEND_DEL_QUEST, SEND_DEL_QUEST)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_GLOBAL_MISSION_STATE, SEND_GLOBAL_MISSION_STATE)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_GLOBAL_MISSION_DATA_CHG, SEND_GLOBAL_MISSION_DATA_CHG)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_GLOBAL_MISSION_ADD, SEND_GLOBAL_MISSION_ADD)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_GLOBAL_MISSION_END, SEND_GLOBAL_MISSION_END)
	
	mEventManager.AddEventListen(nil, EventType.OnCloseDialogPanel, ShowNextMainTask)
	mEventManager.AddEventListen(nil, EventType.IntoHarbor, ShowNextMainTask)
	mEventManager.AddEventListen(nil, EventType.ShowNextMainTask, ShowNextMainTask)
	mEventManager.AddEventListen(nil, EventType.OnLoadComplete, OnLoadComplete)
	mEventManager.AddEventListen(nil, EventType.CheckAllTask, CheckAllTask)
end

function GetNewCount()
	if mMainTaskId ~= 0 and not mSetManager.GetGuide() then
		local cfg_task = CFG_task[mMainTaskId]
		if cfg_task.guide ~= 0 then
			return 1
		end
	end
	return 0
end

function Reset()
	mMainTaskProgress = 0
	mMainTaskId = 0
	mRandomTaskId = 0

	mDoingList = nil
	mDoingListById = nil
	mAutoCompleteTaskList = {}
	mFinishList = nil

	mRandomTaskInfo = nil

	mRefreshing = nil
	mTaskTasking = nil
	
	mGlobalMission = nil
end

function OnLoadComplete()
	-- print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	-- print(mAutoMove)
	ShowNextMainTask()
	
	local mainTask = GetMainTask()
	if mAutoMove and mainTask then
		mAutoMove = false
		
		local cfg_task = CFG_task[mainTask.id]
		-- print(cfg_task.autoMove2)
		if cfg_task.autoMove2 == 1 then
			AutoMove(nil,nil,mainTask)
		end
	end
end

function IsFinished(id)
	if mFinishList and mFinishList[id] then
		return true
	end
end

function IsGeted(id)
	if mDoingListById and mDoingListById[id] then
		return true
	end
end

function CheckAllTask()
	local hero = mHeroManager.GetHero()
	if not hero or not hero.SceneType then
		return
	end
	-- print(mAutoCompleteTaskList)
	local destoryList = nil
	for k,task in pairs(mAutoCompleteTaskList) do
		-- print(CheckCompleteTask(task))
		if CheckCompleteTask(task) then
			-- print(2222)
			destoryList = destoryList or {}
			destoryList[k] = true
			RequestCompleteTask(task.id)
			
			FinishQuest(task.id, false)
		end
	end
	
	if destoryList then
		for k,v in pairs(destoryList) do
			mAutoCompleteTaskList[k] = nil
		end
	end
end

function ShowTaskTip()
	if GetNewCount() == 1 then
		local cfg_task = CFG_task[mMainTaskId]
		local task = GetMainTask()
		-- mTaskTip.ShowTip(task.desc, cfg_task.guide and cfg_task.guide ~= 0)
	end
end

function InitTaskTarget(task)
	-- print(1111111,task.id)
	local cfg_task = mCommonlyFunc.GetTaskCFG(task.id)
	-- if task.id > 10000 then
		-- cfg_task = CFG_randomTask[task.id]
	-- end
	local target = cfg_task.target
	
	if not target then
		target = SplitString(cfg_task.targetStr, "|")
		for i=1,#target,1 do
			target[i] = tonumber(target[i])
		end
		cfg_task.target = target
	end
	
	if target[1] == ConstValue.AutoCompleteTask then
		mAutoCompleteTaskList[task.id] = task
	end
end

function CheckCompleteTask(task)
	-- print("CheckCompleteTask")
	local hero = mHeroManager.GetHero()
	local cfg_task = mCommonlyFunc.GetTaskCFG(task.id)
	-- if task.id > 10000 then
		-- cfg_task = CFG_randomTask[task.id]
	-- end
	local target = cfg_task.target
	if target[2] == 1 then
		if hero.move then
			return false
		end
		if hero.map == target[3] and math.abs(hero.x - target[4]) < 200 and 
			math.abs(hero.y - target[5]) < 200 then
			return true
		end
	elseif target[2] == 2 then
		local harborsList = mHarborManager.GetHarborInfoList()
		local harborInfo = harborsList[hero.harborId]
		if harborInfo and harborInfo.buildInfos[target[3]] then
			local builInfo = harborInfo.buildInfos[target[3]]
			if (builInfo.level + 1 == target[4] and builInfo.cd > 0) or builInfo.level >= target[4] then
				return true
			end
		end
	elseif target[2] == 3 then
		local panelIndex = PanelIndex[target[3]]
		local panel = require(panelIndex.panel)
		if panelIndex.page then
			return panel.visible and panel.mPage == panelIndex.page
		else
			return panel.visible
		end
	elseif target[2] == 4 then
		local panelIndex = PanelIndex[target[3]]
		local panel = require(panelIndex.panel)
		return not panel.visible
	elseif target[2] == 5 then
		return mHarborManger.GetNewCount() == 0
	end
end

function AutoMove(_,_,task)
	-- print("AutoMove")
	mEventManager.RemoveEventListen(nil, EventType.MouseEventState, AutoMove)
	
	local cfg_task = mCommonlyFunc.GetTaskCFG(task.id)
	local target = cfg_task.target
	local hero = mHeroManager.GetHero()

	if hero.SceneType ~= SceneType.Harbor and  not mSceneManager.GetMouseEventState() then
		mEventManager.AddEventListen(nil, EventType.MouseEventState, AutoMove, task)
		return
	end
	if target[1] == 23 and target[2] == 1 then
		MoveToPoint(target[3],target[4],target[5])
	elseif target[1] == 23 and target[2] == 3 then
		local panelIndex = PanelIndex[target[3]]
		local panel = require(panelIndex.panel)
		if panelIndex.InHarbor then
			mHeroManager.GotoHarborPanel(panel, nil , panelIndex.SelfHarbor)
		else
			mCommonlyFunc.AutoOpenlPanel(panel)
		end
	elseif target[1] == 23 and target[2] == 5 then
		mCommonlyFunc.AutoOpenlPanel(mHeroPanel)
		mHeroPanel.mPage = 2
	elseif target[1] == 23 and target[2] == 2 then
		mHeroManager.GotoHarborPanel(mMainBuildPanel, mHarborManager.GetMaxLevelSelfHarborId())
	elseif target[1] == 20 then
		mHeroManager.IntoHarbor(target[2])
	elseif target[1] == 1 then
		if mCharManager.IsNearEnemy(target[2]) then
			local enemy = mCharManager.GetNearEnemy(target[2])
			if not enemy then
				mEventManager.AddEventListen(nil, EventType.MouseEventState, AutoMove, task)
				return
			end
			
			mHeroManager.SetTarget(ConstValue.AttackPlayerType, {char=enemy})
			mHeroManager.CheckAttackChar(enemy)
		else
			MoveToAttack(target[2])
		end
	elseif target[1] == 4 then
		mHeroManager.GotoHarborPanel(mMainBuildPanel, mHarborManager.GetMaxLevelSelfHarborId())
	elseif target[1] == 5 then
		mHeroManager.GotoHarborPanel(mLabPanel,nil,true)
	elseif target[1] == 6 then
		mHeroManager.GotoHarborPanel(mShipyardPanel,nil,true)
	elseif target[1] == 7 then
		mHeroManager.GotoHarborPanel(mTavernPanel)
	elseif target[1] == 8 then
		local cfg_harbor = CFG_harbor[hero.harborId]
		if cfg_harbor then
			for i=1,5 do
				if target[2] == cfg_harbor["product"..i] then
					mCommonlyFunc.AutoOpenlPanel(mShopPanel)
					return
				end
			end
		end
		local cfg_product = CFG_product[target[2]]
		mHeroManager.GotoHarborPanel(mShopPanel, cfg_product.harbor)
	elseif target[1] == 9 then
		if mGoodsManager.HaveEnoughGoods(target[2], target[3]-task.param) then
			mHeroManager.GotoHarborPanel(mShopPanel)
		else
			local cfg_product = CFG_product[target[2]]
			if cfg_product.harbor ~= hero.harborId then
				local cfg_harbor = CFG_harbor[cfg_product.harbor]
				mSystemTip.ShowTip("前往<"..cfg_harbor.name..">港口购买特产", Color.LimeStr)
			end
			mHeroManager.GotoHarborPanel(mShopPanel, cfg_product.harbor)
		end
	elseif target[1] == 10 then
		if #mShipManager.GetRestShipById(target[2]) == 0 then
			local cfg_ship = CFG_ship[target[2]]
			mSystemTip.ShowTip("请先制造<"..cfg_ship.name..">", Color.LimeStr)
			return
		end
		mHeroManager.GotoHarborPanel(mFleetPanel)
	elseif target[1] == 11 or target[1] == 12  or target[1] == 13 then
		mCommonlyFunc.AutoOpenlPanel(mSailorPanel)
	elseif target[1] == 14 then
		mCommonlyFunc.AutoOpenlPanel(mFamilyPanel)
	elseif target[1] == 15 then
		mHeroManager.IntoHarbor(target[2])
	elseif target[1] == 16 then
		mHeroManager.GotoHarborPanel(mCopyMapPanel)
	elseif target[1] == 19 then
		mCommonlyFunc.AutoOpenlPanel(mHeroPanel)
		mHeroPanel.mPage = 3
	elseif target[1] == 21 then
		mCommonlyFunc.AutoOpenlPanel(mItemPanel)
	elseif target[1] == 25 then
		local randomTask,mRandomTaskInfo = GetRandomTask()
		if not randomTask then
			mTavernPanel.mPage = 2
			mCommonlyFunc.AutoOpenlPanel(mTavernPanel)
		else
			AutoMove(_,_,randomTask)
		end
	elseif target[1] == 26 then
		if not mGoodsManager.HaveEnoughGoods(target[3], target[4]-task.param) then
			local cfg_product = CFG_product[target[3]]
			mHeroManager.IntoHarbor(cfg_product.harbor)
		else
			mHeroManager.IntoHarbor(target[2])
		end
	elseif target[1] == 28 then
		-- MoveToAttackByLevel(target[2])
		-- mHeroManager.Goto(2,2504,1153)
		local mToMapId,mToX,mToY = 2,2504,1453
		if hero.map == mToMapId then
			mSystemTip.ShowTip("请攻击该地区船队")
		else
			mHeroManager.SetTarget(ConstValue.PositionType, {map=mToMapId,x=mToX,y=mToY})
			if hero.SceneType == SceneType.Harbor then
				if mShipManager.CheckDutyShip(SetShipFunc) then
					mHarborManager.RequestLeaveHarbor()
				end
			else
				mHeroManager.Goto(mToMapId,mToX,mToY)
			end
		end
		
	elseif target[1] == 29 then
		local mTreasure = mTreasureManager.getTreasure()
		if not mTreasure then
			mSystemTip.ShowTip("请先在背包中查看藏宝图")
			return
		end
		if hero.map ~= 0  then
			mSystemTip.ShowTip("请先前往征服之海")
			return
		end
		mHeroManager.SetTarget(ConstValue.TreasureType, true)
		mHeroManager.Goto(hero.map, mTreasure.x, mTreasure.y)
	end
end


function CouldFly(task)
	local cfg_task = mCommonlyFunc.GetTaskCFG(task.id)
	-- if task.id > 10000 then
		-- cfg_task = CFG_randomTask[task.id]
	-- end
	
	local target = cfg_task.target
	if target[1] == 23 and target[2] == 1 then
		return true
	elseif target[1] == 20 then
		return true
	elseif target[1] == 1 then
		return true
	elseif target[1] == 8 then
		return true
	elseif target[1] == 15 then
		return true
	elseif target[1] == 26 then
		return true
	end
	return false
end

function AutoFly(task)
	-- print("AutoFly")
	
	local cfg_task = mCommonlyFunc.GetTaskCFG(task.id)
	-- if task.id > 10000 then
		-- cfg_task = CFG_randomTask[task.id]
	-- end
	
	local target = cfg_task.target
	local hero = mHeroManager.GetHero()

	if target[1] == 23 and target[2] == 1 then
		mHeroManager.RequestFly(target[3],target[4],target[5])
	elseif target[1] == 20 then
		mHeroManager.RequestFlyToHarbor(target[2])
	elseif target[1] == 1 then
		local cfg_EnemyPosition = CFG_EnemyPosition[target[2]]
		mHeroManager.RequestFly(cfg_EnemyPosition.MapID, cfg_EnemyPosition.X, cfg_EnemyPosition.Y, 0)
	elseif target[1] == 8 then
		local cfg_product = CFG_product[target[2]]
		mHeroManager.RequestFlyToHarbor(cfg_product.harbor)
	elseif target[1] == 15 then
		local cfg_harbor = CFG_harbor[target[2]]
		mHeroManager.RequestFly(cfg_harbor.mapId, cfg_harbor.x, cfg_harbor.y)
	elseif target[1] == 26 then
		if not mGoodsManager.HaveEnoughGoods(target[3], target[4]) then
			local cfg_product = CFG_product[target[3]]
			mHeroManager.RequestFlyToHarbor(cfg_product.harbor)
		else
			mHeroManager.RequestFlyToHarbor(target[2])
		end
	end
end

function MoveToAttack(eid)
	-- print("MoveToAttack",eid)
	local hero = mHeroManager.GetHero()
	local cfg_EnemyPosition = CFG_EnemyPosition[eid]
	mHeroManager.SetTarget(ConstValue.AttackNearType, eid)
	if not hero.SceneType then
		
	elseif hero.SceneType == SceneType.Harbor then
		if mShipManager.CheckDutyShip() then
			mHarborManager.RequestLeaveHarbor()
		end
	else
		mHeroManager.Goto(cfg_EnemyPosition.MapID, cfg_EnemyPosition.X,cfg_EnemyPosition.Y)
	end
end

function MoveToAttackByLevel(elevel)
	-- print("MoveToAttack",eid)
	local hero = mHeroManager.GetHero()
	for k,cfg_EnemyPosition in pairs(CFG_EnemyPosition) do
		local cfg_Enemy = CFG_Enemy[cfg_EnemyPosition.EnemyID]
		if cfg_Enemy.level >= elevel then
			mHeroManager.SetTarget(ConstValue.AttackNearType, cfg_EnemyPosition.EnemyID)
			if not hero.SceneType then
				
			elseif hero.SceneType == SceneType.Harbor then
				if mShipManager.CheckDutyShip() then
					mHarborManager.RequestLeaveHarbor()
				end
			else
				mHeroManager.Goto(cfg_EnemyPosition.MapID, cfg_EnemyPosition.X,cfg_EnemyPosition.Y)
			end
			break
		end
	end
end

function MoveToPoint(mapId, x, y)
	local hero = mHeroManager.GetHero()
	if not hero.SceneType then
		mHeroManager.SetTarget(ConstValue.PositionType, {map=mapId,x=x,y=y})
	elseif hero.SceneType == SceneType.Harbor then
		mHeroManager.SetTarget(ConstValue.PositionType, {map=mapId,x=x,y=y})
		if mShipManager.CheckDutyShip() then
			mHarborManager.RequestLeaveHarbor()
		end
	else
		mHeroManager.SetTarget(ConstValue.PositionType, {map=mapId,x=x,y=y})
		mHeroManager.Goto(mapId, x, y)
	end
end

function SEND_ADD_QUEST(cs_ByteArray)
	-- print("SEND_ADD_QUEST")
	mTaskTasking = false
	local id = ByteArray.ReadInt(cs_ByteArray)
	local param = 0
	local task = {id=id,param=param}
	table.insert(mDoingList, task)
	mDoingListById[id] = task
	InitTaskTarget(task)
	
	local cfg_task = mCommonlyFunc.GetTaskCFG(id)
	-- if task.id > 10000 then
		-- cfg_task = CFG_randomTask[task.id]
	-- end
	task.desc = ReplaceString(cfg_task.targetDesc, "param" ,tostring(param))
	-- mTaskTip.ShowTip(task.desc, cfg_task.guide and cfg_task.guide ~= 0)
	
	if task.id < 10000 then
		mMainTaskId = id
	else
		mRandomTaskId = id
	end
	
	if cfg_task.autoMove == 1 then
		AutoMove(nil,nil,task)
	end
	
	CheckAllTask()
	
	AppearEvent(nil,EventType.OnAddTask,id)
	
	if mActionManager.GetTask(id) then
		mActionManager.GetTask(id)
	else
		AppearEvent(nil,EventType.OnRefreshGuide)
	end
end

function SEND_QUEST_PARAM(cs_ByteArray)
	-- print("SEND_QUEST_PARAM")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local param = ByteArray.ReadInt(cs_ByteArray)
	local task = mDoingListById[id]
	local cfg_task = mCommonlyFunc.GetTaskCFG(id)
	-- if task.id > 10000 then
		-- cfg_task = CFG_randomTask[task.id]
	-- end
	task.param = param
	task.desc = ReplaceString(cfg_task.targetDesc, "param" ,tostring(param))
	-- mTaskTip.ShowTip(task.desc, cfg_task.guide and cfg_task.guide ~= 0)
end

function SEND_QUEST_FINISH(cs_ByteArray)
	-- print("SEND_QUEST_FINISH")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local costGold = ByteArray.ReadBool(cs_ByteArray)
	FinishQuest(id, costGold)
end

function FinishQuest(id, costGold)
	if not mDoingListById[id] then
		return
	end
	for k,v in pairs(mDoingList) do
		if v.id == id then
			table.remove(mDoingList, k)
			break
		end
	end
	mDoingListById[id] = nil
	
	local cfg_task = mCommonlyFunc.GetTaskCFG(id)
	if id > 10000 then
		-- cfg_task = CFG_randomTask[id]
		if not costGold then
			mDialogPanel.SetData(id)
			mPanelManager.Show(mDialogPanel)
		end
	end
	if id < 10000 then
		mFinishList[id] = true
		mMainTaskId = 0
		mMainTaskProgress = id
		
		if cfg_task.animation ~= 0 then
			function overFunc()
				cfg_task.animation = 0
				cfg_task.animationPlay = nil
				ShowNextMainTask()
			end
			mAnimationManager.Start(cfg_task.animation, overFunc)
			cfg_task.animationPlay = true
		else
			ShowNextMainTask()
		end
	else
		mRandomTaskId = 0
	end
	
	if cfg_task.endId == 0 or id > 10000  then
		mHeroTip.ShowTip("<color=lime>任务:"..cfg_task.name.."完成</color>")
	else
		-- mTaskTip.ShowTip("")
	end
	mGuideManager.SetStopGuide(false)
	AppearEvent(nil,EventType.OnRefreshGuide)
end

function SEND_ALL_FINISHED_QUEST(cs_ByteArray)
	-- print("SEND_ALL_FINISHED_QUEST")
	mFinishList = {}
	local count = ByteArray.ReadInt(cs_ByteArray)
	local lastTaskId = 0
	for i=1,count,1 do
		local id = ByteArray.ReadInt(cs_ByteArray)
		mFinishList[id] = true
		lastTaskId = id
		
		-- local cfg_task = mCommonlyFunc.GetTaskCFG(id)
		-- if id > 10000 then
			-- cfg_task = CFG_randomTask[id]
		-- end
		-- if cfg_task.action and cfg_task.action ~= 0 then
			-- mActionManager.OpenAction(id)
		-- end
	end
	
	if mMainTaskProgress == 0 and count > 0 then
		mMainTaskProgress = lastTaskId
	end
	-- print(count, mMainTaskProgress, lastTaskId)
end

function SEND_ALL_QUEST(cs_ByteArray)
	-- print("SEND_ALL_QUEST")
	mDoingList = {}
	mDoingListById = {}
	local count = ByteArray.ReadInt(cs_ByteArray)
	-- print("count", count)
	for i=1,count,1 do
		local id = ByteArray.ReadInt(cs_ByteArray)
		local param = ByteArray.ReadInt(cs_ByteArray)
		-- print(id, param)
		local task = {id=id, param=param}
		table.insert(mDoingList, task)
		mDoingListById[id] = task
		InitTaskTarget(task)
		
		local cfg_task = mCommonlyFunc.GetTaskCFG(id)
		-- if task.id > 10000 then
			-- cfg_task = CFG_randomTask[task.id]
		-- end
		task.desc = ReplaceString(cfg_task.targetDesc, "param" ,tostring(param))
		-- if cfg_task.action and cfg_task.action ~= 0 then
			-- mActionManager.OpenAction(id)
		-- end
		
		if task.id < 10000 then
			mMainTaskId = id
			if cfg_task.autoMove == 1 then
				mAutoMove = true
			end
			
			-- mTaskTip.ShowTip(task.desc, cfg_task.guide and cfg_task.guide ~= 0)
		else
			mRandomTaskId = id
		end
	end
end

function SEND_RANDOM_QUEST_INFO(cs_ByteArray)
	-- print("SEND_RANDOM_QUEST_INFO")
	mRandomTaskInfo = {}
	mRandomTaskInfo.id = ByteArray.ReadInt(cs_ByteArray)
	mRandomTaskInfo.quality = ByteArray.ReadByte(cs_ByteArray)
	mRandomTaskInfo.lastCount = ByteArray.ReadByte(cs_ByteArray)
	
	mRefreshing = nil
end

function SEND_DEL_QUEST(cs_ByteArray)
	-- print("SEND_DEL_QUEST")
	local id = ByteArray.ReadInt(cs_ByteArray)
	if id < 10000 then
		mMainTaskId = 0
	else
		mRandomTaskId = 0
	end
	
	for k,v in pairs(mDoingList) do
		if v.id == id then
			table.remove(mDoingList, k)
			break
		end
	end
	mDoingListById[id] = nil
end
	
function SEND_GLOBAL_MISSION_STATE(cs_ByteArray)
	-- print("SEND_GLOBAL_MISSION_STATE")
	mGlobalMission = {list={}}
	mGlobalMission.id = ByteArray.ReadInt(cs_ByteArray)
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count do
		local id = ByteArray.ReadInt(cs_ByteArray)
		local count = ByteArray.ReadInt(cs_ByteArray)
		mGlobalMission.list[id] = count
	end
end	

function SEND_GLOBAL_MISSION_DATA_CHG(cs_ByteArray)
	-- print("SEND_GLOBAL_MISSION_DATA_CHG")
	if not mGlobalMission then
		return
	end
	
	mGlobalMission.id = ByteArray.ReadInt(cs_ByteArray)
	
	local id = ByteArray.ReadInt(cs_ByteArray)
	local count = ByteArray.ReadInt(cs_ByteArray)
	mGlobalMission.list[id] = count
end
	
function RequestAddTask(id)
	if id > 10000 then
		return false
	end
	local cfg_task = CFG_task[id]
	if cfg_task.onlyShow == 1 then
		return false
	end
	mTaskTasking = true
	-- print("RequestAddTask", id)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.QUEST)
	ByteArray.WriteByte(cs_ByteArray,Packat_Quest.CLIENT_REQUEST_ADD_QUEST)
	ByteArray.WriteInt(cs_ByteArray,id)
	mNetManager.SendData(cs_ByteArray)
	
	return true
end

function RequestAddRandomTask()
	-- print("RequestAddRandomTask")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.QUEST)
	ByteArray.WriteByte(cs_ByteArray,Packat_Quest.CLIENT_REQUEST_ACCEPT_RANDOM_QUEST)
	mNetManager.SendData(cs_ByteArray)
end

function RequestRefreshRandomTask()
	if mRefreshing then
		return
	end
	-- print("RequestRefreshRandomTask")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.QUEST)
	ByteArray.WriteByte(cs_ByteArray,Packat_Quest.CLIENT_REQEUST_REFRESH_RANDOM_QUEST)
	mNetManager.SendData(cs_ByteArray)
	
	mRefreshing = true
end

function RequestFastCompleteRandomTask()
	-- print("RequestFastCompleteRandomTask")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.QUEST)
	ByteArray.WriteByte(cs_ByteArray,Packat_Quest.CLIENT_REQUEST_FAST_FINISH_RANDOM_QEUST)
	mNetManager.SendData(cs_ByteArray)
end

function RequestCompleteTask(id)
	-- print("RequestCompleteTask", id)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.QUEST)
	ByteArray.WriteByte(cs_ByteArray,Packat_Quest.CLIENT_REQUEST_FINISH_QUEST)
	ByteArray.WriteInt(cs_ByteArray,id)
	mNetManager.SendData(cs_ByteArray)
end

function ShowNextMainTask()
	if mSailorToTeam.visible then
		return
	end
	if mTurntablePanel.visible then
		return
	end
	if mTaskTasking then
		return
	end
	if mMainTaskId ~= 0 then
		return
	end
	local hero = mHeroManager.GetHero()
	if not hero.SceneType or hero.SceneType == SceneType.Battle then
		return
	end
	-- print("ShowNextMainTask!!!!!!!!!!!!!", mMainTaskId)
	local task = CFG_task[mMainTaskProgress]
	-- print(task)
	if not task and mMainTaskProgress == 0 then
		-- if hero.id%3 == 0 then
			mDialogPanel.SetData(1)
		-- elseif hero.id%3 == 1 then
			-- mDialogPanel.SetData(319)
		-- elseif hero.id%3 == 2 then
			-- mDialogPanel.SetData(320)
		-- end
		
		mPanelManager.Show(mDialogPanel)
	elseif task then
		-- 当前动画没播放完
		if task.animationPlay then
			return
		end
		
		local nextTask = CFG_task[task.lastTask]
		if not nextTask then
			return
		end
		if hero.level < nextTask.level then
			return
		end
		if nextTask.closePanel == 1 then
			ReturnMenu()
		end
		mDialogPanel.SetData(task.lastTask)
		mPanelManager.Show(mDialogPanel)
	end
	if mHeroManager.IsMoving() then
		mHeroManager.StopMove()
	end
end

function GetNextMainTask()
	local task = CFG_task[mMainTaskProgress]
	if not task then
		return
	end
	local nextTask = CFG_task[task.lastTask]
	return nextTask
end

function ReturnMenu()
	mPanelManager.AutoClose()
	mPanelManager.Hide(mCopyMapPanel)
	
	mPanelManager.Show(mMainPanel)
end

function GetDialogList(taskId)
	local cfg_task = mCommonlyFunc.GetTaskCFG(taskId)
	-- if taskId > 10000 then
		-- cfg_task = CFG_randomTask[taskId]
	-- end
	if not cfg_task.dialogList then
		local list = SplitString(cfg_task.dialog, "|")
		cfg_task.dialogList = list
	end
	return cfg_task.dialogList
end

function GetMainTask()
	if not mDoingListById then
		return nil
	end
	return mDoingListById[mMainTaskId]
end

function GetRandomTask()
	if not mDoingListById then
		return nil
	end
	local randomTask = mDoingListById[mRandomTaskId]
	if randomTask and mRandomTaskInfo then
		randomTask.quality = mRandomTaskInfo.quality
	end
	return randomTask,mRandomTaskInfo
end

function GetAward(cfg_task, task)
	if task and task.quality then
		if task.quality == 4 then
			RandomTaskAward = RandomTaskAward or {{type=0,awardId=27,count=1}}
			return RandomTaskAward
		end
		return
	end
	if not cfg_task.awardList then
		cfg_task.awardList = {}
		for k,taskAward in pairs(CFG_taskAward) do
			if taskAward.taskId == cfg_task.id or taskAward.taskId == cfg_task.endId then
				table.insert(cfg_task.awardList, taskAward)
			end
		end
	end
	return cfg_task.awardList
end

function GetGlobalMission()
	return mGlobalMission
end

function RequipGiveEquip(index)
	-- print("RequipGiveEquip")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.QUEST)
	ByteArray.WriteByte(cs_ByteArray,Packat_Quest.CLIENT_REQUEST_GIVE_EQUIP)
	ByteArray.WriteInt(cs_ByteArray,index)
	mNetManager.SendData(cs_ByteArray)
end

function RequestGiveUp()
	-- print("RequestGiveUp")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.QUEST)
	ByteArray.WriteByte(cs_ByteArray,Packat_Quest.CLIENT_REQUEST_GIVE_UP_RANDOM_QUEST)
	mNetManager.SendData(cs_ByteArray)
end

function RequipGlobalMission()
	-- print("RequipGlobalMission")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_REQUEST_GLOBAL_MISSION_STATE)
	mNetManager.SendData(cs_ByteArray)
end

function RequipGlobalGiveItem(id, type, count)
	-- print("RequipGiveEquip")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_REQUEST_GIVE_ITEM_TO_GLOBAL)
	ByteArray.WriteInt(cs_ByteArray,mGlobalMission.id)
	ByteArray.WriteInt(cs_ByteArray,id)
	ByteArray.WriteByte(cs_ByteArray,type)
	ByteArray.WriteInt(cs_ByteArray,count)
	mNetManager.SendData(cs_ByteArray)
end

function SEND_GLOBAL_MISSION_ADD()
	-- print("SEND_GLOBAL_MISSION_ADD")
	mGlobalMission = {id=0,list={}}
end

function SEND_GLOBAL_MISSION_END()
	-- print("RequipGiveEquip")
	mGlobalMission = nil
end