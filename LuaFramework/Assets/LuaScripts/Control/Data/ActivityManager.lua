local _G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,require,Directory,os,EventType,error,platform,IPhonePlayer = 
_G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,require,Directory,os,EventType,error,platform,IPhonePlayer
local PackatHead,Packat_Player,math,table,ByteArray,ActivityType,SceneType,Packat_Fish,Packat_Award,CFG_fishArea = 
PackatHead,Packat_Player,math,table,ByteArray,ActivityType,SceneType,Packat_Fish,Packat_Award,CFG_fishArea
local CFG_accumulatedAmount,CFG_DiceBox,IosTestScript, mSDK, VersionCode = CFG_accumulatedAmount,CFG_DiceBox,IosTestScript, mSDK, VersionCode
local mSetManager = nil
local mEventManager = nil
local mNetManager = nil
local mHeroManager = nil
local mGiftListManager = nil
local mFishTip = nil
local mTimeCheckManager = nil
local mAccountManager = nil
local mSystemTip = nil

module("LuaScript.Control.Data.ActivityManager")


local mServerTime = nil
local mServerStartTime = 0
local mServerUpdate = 0
local mActivityList = {}
local mActivityListById = {}


local mNewCount = 0

function Init()
	mSetManager = require "LuaScript.Control.System.SetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mGiftListManager = require "LuaScript.Control.Data.GiftListManager"
	mFishTip = require "LuaScript.View.Tip.FishTip"
	mTimeCheckManager = require "LuaScript.Control.System.TimeCheckManager"
	mAccountManager = require "LuaScript.Control.Data.AccountManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_SERVER_TIME, SEND_SERVER_TIME)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_LEVEL_AWARD_INFO, SEND_LEVEL_AWARD_INFO)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_DRINK_INFO, SEND_DRINK_INFO)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_FIRST_FILL_MONEY, SEND_FIRST_FILL_MONEY)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_TOTAL_FILL_MONEY, SEND_TOTAL_FILL_MONEY)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_SERVER_START_TIME, SEND_SERVER_START_TIME)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_TOTAL_COST_GOLD, SEND_TOTAL_COST_GOLD)
	mNetManager.AddListen(PackatHead.FISH, Packat_Fish.SEND_FISH_START, SEND_FISH_START)
	mNetManager.AddListen(PackatHead.FISH, Packat_Fish.SEND_FISH_STOP, SEND_FISH_STOP)
	mNetManager.AddListen(PackatHead.AWARD, Packat_Award.SEND_DICE_ITEM_INFO, SEND_DICE_ITEM_INFO)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_LEVEL_AWARD, SEND_LEVEL_AWARD)
	
	
	mEventManager.AddEventListen(nil, EventType.ConnectFailure, ConnectFailure)
	mEventManager.AddEventListen(nil, EventType.OnLoadComplete, SEND_FISH_STOP)
	
	-- mActivityListById[ActivityType.FirstRechange] = {id=ActivityType.FirstRechange, state=true} -- 首冲奖励直接发放
	-- mActivityListById[ActivityType.RechangeAward] = {id=ActivityType.RechangeAward, state=true} -- 充值一定额度奖励直接发放
	mActivityListById[ActivityType.LevelAward] = {id=ActivityType.LevelAward}
	mActivityListById[ActivityType.GoodDrinking] = {id=ActivityType.GoodDrinking}
	mActivityListById[ActivityType.HarborBattle] = {id=ActivityType.HarborBattle}
	mActivityListById[ActivityType.EnemyTreasure] = {id=ActivityType.EnemyTreasure}
	mActivityListById[ActivityType.EmenyAttack] = {id=ActivityType.EmenyAttack}
	mActivityListById[ActivityType.CollectTreasureMap] = {id=ActivityType.CollectTreasureMap}
	mActivityListById[ActivityType.GiftList] = {id=ActivityType.GiftList, state=true}
	mActivityListById[ActivityType.RMBShop] = {id=ActivityType.RMBShop, state=true}
	mActivityListById[ActivityType.DeadGame] = {id=ActivityType.DeadGame}
	mActivityListById[ActivityType.Fish] = {id=ActivityType.Fish}
	mActivityListById[ActivityType.CostAward] = {id=ActivityType.CostAward, state=true}  -- 消费一定量元宝后赠送礼包
	mActivityListById[ActivityType.GOODS] = {id=ActivityType.GOODS, state=true}
	mActivityListById[ActivityType.Gamble] = {id=ActivityType.Gamble, state=true} -- 秘境寻宝
	
	if VersionCode > 1 then
		mActivityListById[ActivityType.MonthCard] = {id=ActivityType.MonthCard, state=true} -- 月卡和终身卡购买，长期开启
	end
	
	--ios test script IOS屏蔽人民币购买功能
	if IosTestScript then
		mActivityListById[ActivityType.RMBShop] = nil
	end
	
	for k,v in pairs(mActivityListById) do
		table.insert(mActivityList, v)
	end
	-- table.sort(mActivityList, SortFunc)
end

function SortFunc(a, b)
	if a.state and not b.state then
		return true
	elseif not a.state and b.state then
		return false
	end
	return a.id < b.id
end

function GetNewCount()
	return mNewCount
end

function GetActivity(id)
	return mActivityListById[id]
end

function GetActivityList()
	return mActivityList
end

function GetServerTime()
	if not mServerTime then
		return
	end
	-- print("获取时间")
	return math.floor(mServerTime + os.oldClock - mServerUpdate)
end

local mLashRefresFishTime = 0
local mInFishArea = false
function CouldFish()
	local hero = mHeroManager.GetHero()
	if (hero.fish < 90 or FishActivity()) and hero.SceneType == SceneType.Normal then
		RefresFish()
		return mInFishArea
	end
end

function FishActivity()
	local serverTime = GetServerTime()
	if not serverTime then
		return
	end
	local timeTable = os.date("*t", serverTime)
	if timeTable.hour == 20 and timeTable.min >= 30 and (timeTable.wday == 2 or timeTable.wday == 4 or timeTable.wday == 6) then
		return true
	end
end

function RefresFish()
	if mLashRefresFishTime + 1 > os.oldTime then
		return
	end
	mLashRefresFishTime = os.oldTime
	local mHero = mHeroManager.GetHero()
	for k,v in pairs(CFG_fishArea) do
		if mHero.map == v.mapId and mHero.x >= v.starX and mHero.x <= v.endX and
			mHero.y >= v.starY and mHero.y <= v.endY then
			if not mInFishArea and (mHero.fish < 90 or FishActivity()) then
				mSystemTip.ShowTip("进入"..v.name..",发现大量鱼群")
			end
			mInFishArea = true
			return
		end
	end
	mInFishArea = false
end

function GetServerStartTime()
	return mServerStartTime
end

function GetServerStartOverTime()
	if not mServerTime then
		return
	end
	return math.floor(mServerTime + os.oldClock - mServerUpdate - mServerStartTime)
end

-- function test()
	-- local mServerId = mAccountManager.GetServerId()
	-- if mServerId == 4 then
		-- for k,v in pairs(CFG_DiceBox) do
			-- v.endTime = 0
		-- end
		
		-- CFG_accumulatedAmount[37] = nil
		-- CFG_accumulatedAmount[38] = nil
		-- CFG_accumulatedAmount[39] = nil
		-- CFG_accumulatedAmount[40] = nil
	-- end
-- end

function UpdateActivity()
	-- test()
	
	local serverTime = GetServerTime()
	if not serverTime then
		return
	end
	
	local timeTable = os.date("*t", serverTime)
	
	local hero = mHeroManager.GetHero()
	if not hero then
		return
	end
	-- if hero.firstRecharge then
		-- mActivityListById[ActivityType.FirstRechange] = nil
		
		-- for k,v in pairs(mActivityList) do
			-- if v.id == ActivityType.FirstRechange then
				-- table.remove(mActivityList, k)
				-- break
			-- end
		-- end
	-- end
	
	UpdateRMBActivity()
	UpdateGambleActivity()
	
	local activity = mActivityListById[ActivityType.GoodDrinking]
	local state1 = timeTable.hour == 12
	local state2 = timeTable.hour == 18
	local state = (state1 and not activity.drink1) or (state2 and not activity.drink2)
	activity.state = state
	activity.state1 = state1
	activity.state2 = state2
	
	
	local state1 = timeTable.hour >= 16 and timeTable.hour < 19 and (timeTable.wday == 1 or timeTable.wday == 3 or timeTable.wday == 5 or timeTable.wday == 7)
	local state2 = timeTable.hour >= 20 and timeTable.hour < 21 and (timeTable.wday == 1 or timeTable.wday == 3 or timeTable.wday == 5 or timeTable.wday == 7)
	local state = timeTable.hour >= 16 and timeTable.hour < 21 and (timeTable.wday == 1 or timeTable.wday == 3 or timeTable.wday == 5 or timeTable.wday == 7)
	mActivityListById[ActivityType.HarborBattle].state = state
	mActivityListById[ActivityType.HarborBattle].state1 = state1
	mActivityListById[ActivityType.HarborBattle].state2 = state2
	
	local state = timeTable.hour == 12
	mActivityListById[ActivityType.EnemyTreasure].state = state
	
	local state = (timeTable.hour == 13 and timeTable.min < 30) or (timeTable.hour == 21 and timeTable.min > 10)
	mActivityListById[ActivityType.CollectTreasureMap].state = state
	
	local state = (timeTable.hour == 19 and timeTable.min < 50)
	mActivityListById[ActivityType.EmenyAttack].state = state
	
	local state = timeTable.hour == 20 and timeTable.min < 30 and (timeTable.wday == 2 or timeTable.wday == 4 or timeTable.wday == 6)
	mActivityListById[ActivityType.DeadGame].state = state
	
	-- local state = (timeTable.hour == 15 and timeTable.min >= 30) or timeTable.hour == 16
	mActivityListById[ActivityType.Fish].state = hero.fish<90 or FishActivity()
	
	if mActivityListById[ActivityType.MonthCard] then
		mActivityListById[ActivityType.MonthCard].state = MonthCardTipSwitch()
	end
	
	local giftList = mGiftListManager.GetGiftList()
	mActivityListById[ActivityType.GiftList].state = false
	if giftList then
		for k,v in pairs(giftList) do
			if v.type >= 0 then
				mActivityListById[ActivityType.GiftList].state = true

				mNewCount = mNewCount + 1
			end
		end
	end
	
	-- UpdateLevelAward()
	
	table.sort(mActivityList, SortFunc)
	
	UpdateNewCount()
end

function MonthCardTipSwitch() -- 管理月卡和终生卡活动的提示
		local mMonthCard = mHeroManager.GetMonthCard()
		if not mMonthCard then
			return
		end
		local serverTime = GetServerTime()
		if not serverTime then
			return
		end
		local et1 = mMonthCard.monthCardEndTime1  --大于 servertime  则已购买
		local get1 = mMonthCard.monthCardGet1 	--0未领取奖励 1已领取
		local et2 = mMonthCard.monthCardEndTime2  -- 等于-1时已购买
		local get2 = mMonthCard.monthCardGet2     --0未领取奖励 1已领取
		if et1== nil or	et2== nil or get1== nil or get2 == nil then
		    return -- 刚开始游戏短暂延迟未接收到数据会报错，这里做限制
		end
        if et1 > serverTime and get1 == 1 and et2 == -1 and  get2 == 1  then
		   return false
		end  
	return true	
end

function UpdateRMBActivity() -- RMBShop列表
	local severId = mAccountManager.GetServerId()
	local serverStartOverTime = GetServerStartOverTime()
	local serverTime = GetServerTime()
	local hero = mHeroManager.GetHero()
	local rechageActivity = {}
	local costActivity = {}
	
	if not serverTime then
		return
	end
	-- print(severId)
	
	for k,v in pairs(CFG_accumulatedAmount) do
		if v.startTime > 1388505600 then
			if v.startTime <= serverTime and v.endTime > serverTime and v.starSever <= severId and
				v.endSever >= severId then
				if v.type == 1 then
					table.insert(rechageActivity, v)
				else
					table.insert(costActivity, v)
				end
			end
		else
			if v.startTime <= serverStartOverTime and v.endTime > serverStartOverTime and v.starSever <= severId and
				v.endSever >= severId then
				if v.type == 1 then
					table.insert(rechageActivity, v)
				else
					table.insert(costActivity, v)
				end
			end
		end
	end
	-- print(serverStartOverTime)
	-- if activity[5] then
		-- error("活动出错了 serverTime = "..serverTime.."  mServerTime = "..mServerTime.." mServerUpdate = " .. mServerUpdate)
	-- end
	if rechageActivity[1] then
		local info = mActivityListById[ActivityType.RechangeAward] or {}
		info.state = true
		info.id = ActivityType.RechangeAward
		local lastAwardGet =  false
		for k,v in pairs(rechageActivity) do
			lastAwardGet = hero.totalRecharge >= v.gold
			info["award"..k] = lastAwardGet
		end
		-- info.award1 = hero.totalRecharge >= activity[1].gold
		-- info.award2 = hero.totalRecharge >= activity[2].gold
		-- info.award3 = hero.totalRecharge >= activity[3].gold
		-- info.award4 = hero.totalRecharge >= activity[4].gold
		info.data = rechageActivity
		if lastAwardGet then
			mActivityListById[ActivityType.RechangeAward] = nil
			
			for k,v in pairs(mActivityList) do
				if v.id == ActivityType.RechangeAward then
					table.remove(mActivityList, k)
					break
				end
			end
		elseif not mActivityListById[ActivityType.RechangeAward] then
			mActivityListById[ActivityType.RechangeAward] = info
			table.insert(mActivityList, info)
		end
	elseif mActivityListById[ActivityType.RechangeAward] then
		mActivityListById[ActivityType.RechangeAward] = nil
		
		for k,v in pairs(mActivityList) do
			if v.id == ActivityType.RechangeAward then
				table.remove(mActivityList, k)
				break
			end
		end
	end
	
	if costActivity[1] then
		local info = mActivityListById[ActivityType.CostAward] or {}
		info.state = true
		info.id = ActivityType.CostAward
		local lastAwardGet =  false
		for k,v in pairs(costActivity) do
			lastAwardGet = hero.totalCost >= v.gold
			info["award"..k] = lastAwardGet
		end
		
		-- info.award1 = hero.totalCost >= activity[1].gold
		-- info.award2 = hero.totalCost >= activity[2].gold
		-- info.award3 = hero.totalCost >= activity[3].gold
		-- info.award4 = hero.totalCost >= activity[4].gold
		info.data = costActivity
		if lastAwardGet then
			mActivityListById[ActivityType.CostAward] = nil
			
			for k,v in pairs(mActivityList) do
				if v.id == ActivityType.CostAward then
					table.remove(mActivityList, k)
					break
				end
			end
		elseif not mActivityListById[ActivityType.CostAward] then
			mActivityListById[ActivityType.CostAward] = info
			table.insert(mActivityList, info)
		end
	elseif mActivityListById[ActivityType.CostAward] then
		mActivityListById[ActivityType.CostAward] = nil
		
		for k,v in pairs(mActivityList) do
			if v.id == ActivityType.CostAward then
				table.remove(mActivityList, k)
				break
			end
		end
	end
end

function UpdateGambleActivity()  -- 消费好礼
	local serverTime = GetServerTime()
	local severId = mAccountManager.GetServerId()
	-- print("UpdateGambleActivity",serverTime)
	-- print(serverTime > CFG_DiceBox[1].startTime)
	-- print(serverTime < CFG_DiceBox[126].endTime)
	
	--ios test script
	if IosTestScript then
		return
	end
	
	local serverStartOverTime = GetServerStartOverTime()
	local haveAward = false
	local awardList = {}
	for k,v in pairs(CFG_DiceBox) do
		if v.startTime < 1388505600 and v.startTime <= serverStartOverTime and v.endTime > serverStartOverTime and v.starSever <= severId and v.endSever >= severId then
			awardList[(v.index-1)%18 + 1] = v
			haveAward = true
		elseif v.startTime <= serverTime and v.endTime > serverTime and v.starSever <= severId and v.endSever >= severId then
			awardList[(v.index-1)%18 + 1] = v
			haveAward = true
		end
	end
	if haveAward then
		local activity = mActivityListById[ActivityType.Gamble] or {id=ActivityType.Gamble,state = true}
		activity.awardList = awardList
		if not mActivityListById[ActivityType.Gamble] then
			mActivityListById[ActivityType.Gamble] = activity
			table.insert(mActivityList, activity)
		end
	else
		if mActivityListById[ActivityType.Gamble] then
			mActivityListById[ActivityType.Gamble] = nil
			for k,v in pairs(mActivityList) do
				if v.id == ActivityType.Gamble then
					table.remove(mActivityList, k)
					break
				end
			end
		end
	end
end

function UpdateNewCount()
	mNewCount = 0
	
	local activity = mActivityListById[ActivityType.GoodDrinking] -- 酒馆
	if activity and activity.state then
		mNewCount = mNewCount + 1
	end
	
	local activity = mActivityListById[ActivityType.GiftList] -- 礼包列表
	if activity and activity.state then
		mNewCount = mNewCount + 1
	end
	
	local activity = mActivityListById[ActivityType.LevelAward] -- 等级礼包
	if activity and activity.state then
		mNewCount = mNewCount + 1
	end
end

function SEND_SERVER_TIME(cs_ByteArray)
	mServerTime = ByteArray.ReadInt(cs_ByteArray)
	mServerUpdate = os.oldClock
	
	mGiftListManager.Refresh()
	
	UpdateActivity()	
	mTimeCheckManager.WaitCheck()
end

function SEND_SERVER_START_TIME(cs_ByteArray)
	-- print("SEND_SERVER_START_TIME")
	mServerStartTime = ByteArray.ReadInt(cs_ByteArray)
	
	UpdateActivity()
end

function SEND_DRINK_INFO(cs_ByteArray)
	-- print("!!!!!!!SEND_DRINK_INFO")
	local activity = mActivityListById[ActivityType.GoodDrinking]
	activity.drink1 = ByteArray.ReadBool(cs_ByteArray)
	activity.drink2 = ByteArray.ReadBool(cs_ByteArray)
	-- print("!!!!!!!SEND_DRINK_INFO")
	UpdateActivity()
end

function SEND_FIRST_FILL_MONEY(cs_ByteArray)
	local hero = mHeroManager.GetHero()
	if hero then
		hero.firstRecharge = ByteArray.ReadInt(cs_ByteArray)
		--ios test script
		if IosTestScript then
			hero.firstRecharge = 1
		end
		
		UpdateActivity()
	end
end

function SEND_TOTAL_FILL_MONEY(cs_ByteArray)
	local hero = mHeroManager.GetHero()
	if hero then
		hero.totalRecharge = ByteArray.ReadInt(cs_ByteArray)
		UpdateActivity()
	end
end

function SEND_TOTAL_COST_GOLD(cs_ByteArray)
	local hero = mHeroManager.GetHero()
	if hero then
		hero.totalCost = ByteArray.ReadInt(cs_ByteArray)
		UpdateActivity()
	end
end

function SEND_LEVEL_AWARD(cs_ByteArray) -- 等级礼包
	print("SEND_LEVEL_AWARD")
	local hero = mHeroManager.GetHero()
	if hero then
		hero.mlevelAward = ByteArray.ReadInt(cs_ByteArray)
		UpdateActivity()
	end
end

function SEND_FISH_START()
	-- print("SEND_FISH_START")
	mFishTip.ShowTip()
end

function SEND_FISH_STOP()
	-- print("SEND_FISH_STOP")
	mFishTip.HideTip()
end

function ConnectFailure()
	mServerStartTime = 0
end

function SEND_LEVEL_AWARD_INFO(cs_ByteArray)
	-- local info = ByteArray.ReadInt(cs_ByteArray)
	local award = {}
	award[1] = {got=ByteArray.ReadBool(cs_ByteArray)}
	award[2] = {got=ByteArray.ReadBool(cs_ByteArray)}
	award[3] = {got=ByteArray.ReadBool(cs_ByteArray)}
	award[4] = {got=ByteArray.ReadBool(cs_ByteArray)}
	award[5] = {got=ByteArray.ReadBool(cs_ByteArray)}
	award[6] = {got=ByteArray.ReadBool(cs_ByteArray)}
	award[7] = {got=ByteArray.ReadBool(cs_ByteArray)}
	
	local activity = mActivityListById[ActivityType.LevelAward]
	if activity then
		activity.award = award
		
		UpdateLevelAward(true)
	end
end

function UpdateLevelAward(sort)
	local activity = mActivityListById[ActivityType.LevelAward]
	if not activity or not activity.award then
		return
	end
	local hero = mHeroManager.GetHero()

	activity.award[1].couldGet = hero.level >= 10 and not activity.award[1].got
	activity.award[2].couldGet = hero.level >= 20 and not activity.award[2].got
	activity.award[3].couldGet = hero.level >= 30 and not activity.award[3].got
	activity.award[4].couldGet = hero.level >= 35 and not activity.award[4].got
	activity.award[5].couldGet = hero.level >= 40 and not activity.award[5].got
	activity.award[6].couldGet = hero.level >= 45 and not activity.award[6].got
	activity.award[7].couldGet = hero.level >= 50 and not activity.award[7].got
	
	if activity.award[1].got and activity.award[2].got and activity.award[3].got and
		activity.award[4].got and activity.award[5].got and activity.award[6].got and
		activity.award[7].got  then
		for k,v in pairs(mActivityList) do
			if v.id == ActivityType.LevelAward then
				table.remove(mActivityList, k)
				break
			end
		end
		mActivityListById[ActivityType.LevelAward] = nil
	else
		local state = false
		for k,v in pairs(activity.award) do
			state = state or v.couldGet
		end
		activity.state = state
	end
	
	if hero.levelAward == 0 then
		activity.state = true
	end
	
	if sort then
		table.sort(mActivityList, SortFunc)
	end
	
	UpdateNewCount()
end

function RequestDrink()
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_REQUEST_DRINK)
	mNetManager.SendData(cs_ByteArray)
end

function RequestBuyLevelAward()
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.REQUEST_BUY_LEVEL_AWARD)
	ByteArray.WriteInt(cs_ByteArray,1)
	mNetManager.SendData(cs_ByteArray)
end


function RequestLevelAward(type)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_REQUEST_GET_LEVEL_AWARD)
	ByteArray.WriteInt(cs_ByteArray,type)
	mNetManager.SendData(cs_ByteArray)
end

function RequestFish()
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FISH)
	ByteArray.WriteByte(cs_ByteArray,Packat_Fish.CLIENT_REQUEST_FISH_START)
	mNetManager.SendData(cs_ByteArray)
end

function RequestUseDice()
	-- print("RequestUseDice")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.AWARD)
	ByteArray.WriteByte(cs_ByteArray,Packat_Award.CLIENT_REQUEST_USE_DICE)
	mNetManager.SendData(cs_ByteArray)
end

function RequestStopDice()
	-- print("RequestStopDice")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.AWARD)
	ByteArray.WriteByte(cs_ByteArray,Packat_Award.CLIENT_DICE_STOP)
	mNetManager.SendData(cs_ByteArray)
end

function SEND_DICE_ITEM_INFO(cs_ByteArray) -- 请求使用骰子
	-- print("SEND_DICE_ITEM_INFO")
	local activity = mActivityListById[ActivityType.Gamble]
	if not activity then
		-- print("not activity")
		return
	end
	local count = ByteArray.ReadInt(cs_ByteArray)
	local goteList = {}
	for i=1,count do
		local index = ByteArray.ReadShort(cs_ByteArray)
		-- print(index)
		goteList[(index-1)%18+1] = true
	end
	if count >= 1 then
		activity.count = count + 1
	else
		activity.count = count
	end
	activity.goteList = goteList
end