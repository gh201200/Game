local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Goods,Packat_Ship,Language = 
print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Goods,Packat_Ship,Language
local PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent = 
PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent
local CFG_ship,CFG_harbor,LogbookType,Color,string,CFG_starSkill,CFG_star,Packat_StarFate,CFG_starSkillProperty = 
CFG_ship,CFG_harbor,LogbookType,Color,string,CFG_starSkill,CFG_star,Packat_StarFate,CFG_starSkillProperty
local CFG_starGrade = CFG_starGrade
local mNetManager = nil
local mCommonlyFunc = nil
local mSystemTip = nil
local mHeroManager = nil
local mHeroManger = nil
local mShipManager = nil
local mSailorManager = nil
module("LuaScript.Control.Data.StarFateManager")

local mStarFateList = nil
local mStarFateListByIndex = nil
local mStarFateListByRest = nil
-- local mStarFateListByUnuse = nil
local mStarFateListByTemp = nil
local mStarSkillList = nil
local mActionSkillList = nil
local mSelectSkillList = {{},{},{}}
local mStarGetLevel = 0
-- local couldActionSkills = nil
-- local couldActionSkillsById = nil
-- local mStarPoint = 0
local mScopeCount = 0
local mAlert = 0
local mRagePoint = 0
local mStarFateGeting = false
local mNeedUpdate = true

local CFG_starByTypeQuality = nil

function GetStarList()
	return mStarFateList
end


function GetSkillList()
	return mStarSkillList
end

function GetSkillListByIndext(index)
	return mStarSkillList[index]
end

function GetRestStarList()
	return mStarFateListByRest
end

function GetStarByIndex(index)
	return mStarFateListByIndex[index]
end

-- function GetUnuseStarList()
	-- return mStarFateListByUnuse
-- end

-- function GetCouldActionSkills()
	-- return couldActionSkills, couldActionSkillsById
-- end

function GetDutyStarList()
	return mStarFateListByDuty
end

function GetTempStarList()
	return mStarFateListByTemp
end

function GetStarLevel()
	return mStarGetLevel
end

function GetStarPoint()
	local hero = mHeroManager.GetHero()
	return hero.starPoint
end

function GetRagePoint()
	return mRagePoint
end

function GetStarFateFull()
	return mStarFateListByRest[21]
end

function GetCFGStar(type, quality)
	return CFG_starByTypeQuality[type+quality*1000]
end

function GetLastScopeCount()
	if not mLastScopeCount then
		local hero = mHeroManager.GetHero()
		local maxCount = 10 + math.floor(hero.level/2) + math.floor(hero.vipLevel/3)
		mLastScopeCount = maxCount-mScopeCount
	end
	return mLastScopeCount
end

function GetActionSkillList()
	if not mActionSkillList then
		if not mStarSkillList then
			return
		end
		for k,skill in pairs(mStarSkillList) do
			local cfg_starSkill = CFG_starSkill[skill.id]
			if cfg_starSkill and cfg_starSkill.active == 1 then
				skill.index = k
				mActionSkillList = mActionSkillList or {}
				table.insert(mActionSkillList, skill)
			end
		end
	end
	return mActionSkillList
end

local mPower = nil
function GetTotalPower()
	if mPower then
		return mPower
	end
	mPower = 0
	if mStarFateListByDuty then
		for k, star in pairs(mStarFateListByDuty[1]) do
			mPower = mPower + mCommonlyFunc.GetStarPower(star)
		end
		-- print(mStarFateListByDuty[2])
		for k, star in pairs(mStarFateListByDuty[2]) do
			mPower = mPower + mCommonlyFunc.GetStarPower(star)
		end
		for k, star in pairs(mStarFateListByDuty[3]) do
			mPower = mPower + mCommonlyFunc.GetStarPower(star)
		end
		for k, skill in pairs(mStarSkillList) do
			if skill.id then
				local cfg_starSkillProperty = CFG_starSkillProperty[skill.id.."_"..skill.quality]
				mPower = mPower + cfg_starSkillProperty.power
			end
		end
	end
	return mPower
end

function Init()
	mEventManager = require "LuaScript.Control.EventManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mAlert = require "LuaScript.View.Alert.Alert"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mShipManager = require "LuaScript.Control.Data.ShipManager"
	mSailorManager = require "LuaScript.Control.Data.SailorManager"
	mHeroManger = require "LuaScript.Control.Scene.HeroManager"
	
	mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_ADD_SKILL_ORB, SEND_ADD_SKILL_ORB)
	mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_DEL_SKILL_ORB, SEND_DEL_SKILL_ORB)
	mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_ALL_SKILL_ORB, SEND_ALL_SKILL_ORB)
	mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_ORB_SLOT, SEND_ORB_SLOT)
	mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_BATTLE_SKILL_TABLE, SEND_BATTLE_SKILL_TABLE)
	mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_SCOPE_LEVEL, SEND_SCOPE_LEVEL)
	mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_GET_ALL_TEMP_SUC, SEND_GET_ALL_TEMP_SUC)
	mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_DES_ALL_TEMP_SUC, SEND_DES_ALL_TEMP_SUC)
	mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_ORB_TEMP_STATE, SEND_ORB_TEMP_STATE)
	-- mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_SKILL_ORB_POINT, SEND_SKILL_ORB_POINT)
	mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_SKILL_ORB_LEVELEXP, SEND_SKILL_ORB_LEVELEXP)
	mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_SCOPE_COUNT, SEND_SCOPE_COUNT)
	mNetManager.AddListen(PackatHead.STARFATE, Packat_StarFate.SEND_RAGE_POINT, SEND_RAGE_POINT)
	
	mEventManager.AddEventListen(nil, EventType.UseBattleSkill, UseBattleSkill)
	mEventManager.AddEventListen(nil, EventType.RefreshStarFate, RefreshStarFate)
	mEventManager.AddEventListen(nil, EventType.ConnectFailure, ConnectFailure)
	
	InitStarCfg()
end

function ConnectFailure()
	mNeedUpdate = true
	mStarFateGeting = false
end

function InitStarCfg()
	-- CFG_starSkillByKey = {}
	CFG_starByTypeQuality = {}
	for k,v in pairs(CFG_starSkill) do
		-- key = string.gsub(key,"0","")
		if v.quality1 == 1 then
			local key = string.format("%d_%d_%d_%d_%d_%d_%d",v.star1,v.star2,v.star3,v.star4,v.star5,v.star6,v.star7)
			v.key1 = string.gsub(key,"_0*","%%d*")
			v.desc1 = InitDesc(v.id, 1)
		end
		if v.quality2 == 1 then
			local key = string.format("%d_%d_%d_%d_%d_%d_%d",v.star1*10,v.star2*10,v.star3*10,v.star4*10,v.star5*10,v.star6*10,v.star7*10)
			v.key2 = string.gsub(key,"_0*","%%d*")
			v.desc2 = InitDesc(v.id, 2)
		end
		if v.quality3 == 1 then
			local key = string.format("%d_%d_%d_%d_%d_%d_%d",v.star1*100,v.star2*100,v.star3*100,v.star4*100,v.star5*100,v.star6*100,v.star7*100)
			v.key3 = string.gsub(key,"_0*","%%d*")
			v.desc3 = InitDesc(v.id, 3)
		end
		if v.quality4 == 1 then
			local key = string.format("%d_%d_%d_%d_%d_%d_%d",v.star1*1000,v.star2*1000,v.star3*1000,v.star4*1000,v.star5*1000,v.star6*1000,v.star7*1000)
			v.key4 = string.gsub(key,"_0*","%%d*")
			v.desc4 = InitDesc(v.id, 4)
		end
	end
	for k,v in pairs(CFG_star) do
		CFG_starByTypeQuality[v.quality*1000+v.type] = v.id
	end
end

function InitDesc(id, quality)
	local cfg_starSkill = CFG_starSkill[id]	
	local starSkillProperty = CFG_starSkillProperty[id .."_".. quality]
	local s1 = ""
	if starSkillProperty.hurtType1 == 1 then
		s1 = mCommonlyFunc.BeginColor(Color.RedStr)..starSkillProperty.value1..mCommonlyFunc.EndColor()
	elseif starSkillProperty.hurtType1 == 2 then
		s1 = mCommonlyFunc.BeginColor(Color.OrangeStr)..starSkillProperty.value1..mCommonlyFunc.EndColor()
	elseif starSkillProperty.hurtType1 == 3 then
		s1 = mCommonlyFunc.BeginColor(Color.RedStr)..starSkillProperty.value1.."%"..mCommonlyFunc.EndColor()
	elseif starSkillProperty.hurtType1 == 4 then
		s1 = mCommonlyFunc.BeginColor(Color.OrangeStr)..starSkillProperty.value1.."%"..mCommonlyFunc.EndColor()
	end
	local s2 = ""
	if starSkillProperty.hurtType2 == 1 then
		s2 = mCommonlyFunc.BeginColor(Color.RedStr)..starSkillProperty.value2..mCommonlyFunc.EndColor()
	elseif starSkillProperty.hurtType2 == 2 then
		s2 = mCommonlyFunc.BeginColor(Color.OrangeStr)..starSkillProperty.value2..mCommonlyFunc.EndColor()
	elseif starSkillProperty.hurtType2 == 3 then
		s2 = mCommonlyFunc.BeginColor(Color.RedStr)..starSkillProperty.value2.."%"..mCommonlyFunc.EndColor()
	elseif starSkillProperty.hurtType2 == 4 then
		s2 = mCommonlyFunc.BeginColor(Color.OrangeStr)..starSkillProperty.value2.."%"..mCommonlyFunc.EndColor()
	end
	return string.format(cfg_starSkill.desc, s1, s2)
end


function sortFunc(a,b)
	if a.bid < b.bid then
		return true
	elseif a.bid == b.bid and a.level > b.level then
		return true
	end
end

-- function sortFunc2(a, b)
	-- local cfg_a = CFG_star[v.bid]
	-- local cfg_b = CFG_star[v.bid]
	-- if cfg_a.type == cfg_b.type then
		-- return false
	-- end
	
	-- if cfg_a.type < cfg_b.type then
		-- return true
	-- else
		-- return false
	-- end
-- end

-- function sortFunc3(a, b)
	-- return a.level > b.level
-- end

function sortFunc4(a, b)
	local cfg_a = CFG_star[a.bid]
	local cfg_b = CFG_star[b.bid]
	if cfg_a.type < cfg_b.type then
		return true
	elseif a.bid > b.bid then
		return false
	end
	
	if cfg_a.quality < cfg_b.quality then
		return true
	elseif cfg_a.quality > cfg_b.quality then
		return false
	end
end

function RefreshStarFate()
	mLastScopeCount = nil
end

function UseBattleSkill(_,_,skillId)
	if not mActionSkillList then
		return
	end
	local cfg_starSkill = CFG_starSkill[skillId]
	for k,v in pairs(mActionSkillList) do
		if v.id == skillId then
			v.cd = cfg_starSkill.countdown + os.oldClock
			break
		end
	end
end

function SEND_ALL_SKILL_ORB(cs_ByteArray)
	-- print("SEND_ALL_SKILL_ORB")
	mStarFateList = {}
	mStarFateListByIndex = {}
	mStarFateListByRest = {}
	mStarFateListByDuty = {{},{},{}}
	mStarFateListByTemp = {}
	
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count,1 do
		local star = {}
		star.index = ByteArray.ReadInt(cs_ByteArray)
		star.bid = ByteArray.ReadInt(cs_ByteArray)
		star.level = ByteArray.ReadInt(cs_ByteArray)
		star.duty = ByteArray.ReadInt(cs_ByteArray)
		star.temp = ByteArray.ReadBool(cs_ByteArray)
		
		mStarFateListByIndex[star.index] = star
		table.insert(mStarFateList, star)
		
		if star.temp then
			table.insert(mStarFateListByTemp, star)
		else
			if star.duty > 0 then
				table.insert(mStarFateListByDuty[star.duty], star)
			else
				table.insert(mStarFateListByRest, star)
			end
		end
	end
	
	table.sort(mStarFateListByRest, sortFunc)
	
	-- CheckSkill(mStarFateListByDuty[1])
	-- CheckSkill(mStarFateListByDuty[2])
	-- CheckSkill(mStarFateListByDuty[3])
end

function SEND_ORB_SLOT(cs_ByteArray)
	-- print("SEND_ORB_SLOT")
	if not mStarFateList then
		return
	end
	
	local index = ByteArray.ReadInt(cs_ByteArray)
	local duty = ByteArray.ReadInt(cs_ByteArray)
	
	local star = mStarFateListByIndex[index]
	if star.duty > 0 then
		local starList = mStarFateListByDuty[star.duty]
		-- print(index)
		mSelectSkillList[star.duty].skillList = nil
		mSelectSkillList[star.duty].IsInit = nil
		-- if mStarSkillList then
			-- mStarSkillList[star.duty].level = nil
		-- end
		-- print(starList)
		for k,v in pairs(starList) do
			if v == star then
				table.remove(starList, k)
				break
			end
		end
	end
	
	if duty > 0 then
		table.insert(mStarFateListByDuty[duty], star)
		mSelectSkillList[duty].skillList = nil
		mSelectSkillList[duty].IsInit = nil
		-- if mStarSkillList then
			-- mStarSkillList[duty].level = nil
		-- end
		for k,v in pairs(mStarFateListByRest) do
			if v.index == index then
				table.remove(mStarFateListByRest, k)
				break
			end
		end
	else
		table.insert(mStarFateListByRest, star)
	end
	star.duty = duty
	
	mPower = nil
	AppearEvent(nil, EventType.UpdateHeroPower)
	AppearEvent(nil, EventType.OnRefreshGuide)
	-- RefreshLevel()
end

function SEND_BATTLE_SKILL_TABLE(cs_ByteArray)
	-- print("SEND_BATTLE_SKILL_TABLE")
	-- local IsInit = false
	-- if not mStarSkillList then
		-- IsInit = true
	-- end
	mStarSkillList = {{},{},{}}
	local id = ByteArray.ReadInt(cs_ByteArray)
	local quality = ByteArray.ReadInt(cs_ByteArray)
	if id ~= 0 then
		mStarSkillList[1].id = id
		mStarSkillList[1].quality = quality
	end
	local id = ByteArray.ReadInt(cs_ByteArray)
	local quality = ByteArray.ReadInt(cs_ByteArray)
	if id ~= 0 then
		mStarSkillList[2].id = id
		mStarSkillList[2].quality = quality
	end
	local id = ByteArray.ReadInt(cs_ByteArray)
	local quality = ByteArray.ReadInt(cs_ByteArray)
	if id ~= 0 then
		mStarSkillList[3].id = id
		mStarSkillList[3].quality = quality
	end
	mActionSkillList = nil
	mPower = nil
	-- AppearEvent(nil, EventType.UpdateHeroPower)
	-- RefreshLevel()
	-- RefreshUnuseList()
	if mNeedUpdate then
		local hero = mHeroManager.GetHero()
		if not hero then
			return
		end
		mShipManager.UpdateAllProperty(false)
		mSailorManager.UpdateAllProperty(false)
	else
		AppearEvent(nil, EventType.UpdateHeroPower)
	end
	mNeedUpdate = false
	
	mHeroManager.UnLockPower(99)
end

-- function RefreshLevel()
	-- print("RefreshLevel")
	-- for k,skill in pairs(mStarSkillList) do
		-- if skill.id and not skill.level then
			-- InitStarSkillLevel(skill, mStarFateListByDuty[k])
		-- end
	-- end
-- end

function CouldActionSkills(duty)
	local mStarFateListByUnuse = {}
	-- table.sort(mStarFateListByUnuse, sortFunc) 
	
	for _,v in pairs(mStarFateListByRest) do
		table.insert(mStarFateListByUnuse, v)
	end
	
	local count = EmptySoltCount()
	local list = ExStarList(1,duty)
	table.simpleConcat(mStarFateListByUnuse, list)
	
	-- print(duty)
	if duty ~= 1 then
		count = count + #list
	else
		count = count + #mStarFateListByDuty[duty]
		-- print(mStarFateListByDuty[duty])
		-- print(#mStarFateListByDuty[duty])
	end
	
	local list = ExStarList(2,duty)
	table.simpleConcat(mStarFateListByUnuse, list)
	if duty ~= 2 then
		count = count + #list
	else
		count = count + #mStarFateListByDuty[duty]
	end
	
	local list = ExStarList(3,duty)
	table.simpleConcat(mStarFateListByUnuse, list)
	if duty ~= 3 then
		count = count + #list
	else
		count = count + #mStarFateListByDuty[duty]
	end
	-- print(count)
	-- print(mStarFateListByUnuse)
	return CheckSkill(mStarFateListByUnuse, count)
end

function ExStarList(duty, index)
	if duty == index then
		return mStarFateListByDuty[duty]
	end
	local list = {}
	for _,v in pairs(mStarFateListByDuty[duty] ) do
		table.insert(list, v)
	end
	table.sort(list,sortFunc4)
	local skill = mStarSkillList[duty]
	-- print(skill.id)
	if not skill.id then
		return list
	end
	
	local cfgStarSkill = CFG_starSkill[mStarSkillList[duty].id]
	for i=1,7,1 do
		-- print("star>>>"..cfgStarSkill["star"..i])
		local starId = cfgStarSkill["star"..i]
		if starId== 0 then
			break
		end
		
		for k,star in pairs(list) do
			local cfgStar = CFG_star[star.bid]
			if cfgStar.quality >= skill.quality and cfgStar.type == starId then
				-- print("remove>>>"..k)
				table.remove(list, k)
				break
			end
		end
	end
	-- print(list)
	return list
end

function SEND_SCOPE_LEVEL(cs_ByteArray)
	-- print("SEND_SCOPE_LEVEL")
	mStarGetLevel = ByteArray.ReadByte(cs_ByteArray)
end

-- function SEND_SKILL_ORB_POINT(cs_ByteArray)
	-- print("SEND_SKILL_ORB_POINT")
	-- mStarPoint = ByteArray.ReadInt(cs_ByteArray)
-- end

function SEND_SCOPE_COUNT(cs_ByteArray)
	-- print("SEND_SCOPE_COUNT")
	mScopeCount = ByteArray.ReadInt(cs_ByteArray)
	mLastScopeCount = nil
end
function SEND_RAGE_POINT(cs_ByteArray)
	-- print("SEND_RAGE_POINT")
	mRagePoint = ByteArray.ReadInt(cs_ByteArray)
	
	local hero = mHeroManger.GetHero()
	if hero and hero.level < 2 then
		AppearEvent(nil,EventType.OnRefreshGuide)
	end
end

function SEND_SKILL_ORB_LEVELEXP(cs_ByteArray)
	-- print("SEND_SKILL_ORB_LEVELEXP")
	mPower = nil
	
	local index = ByteArray.ReadInt(cs_ByteArray)
	local level = ByteArray.ReadInt(cs_ByteArray)
	local star = mStarFateListByIndex[index]
	star.level = level
	-- print(star.duty)
	if star.duty > 0 then
		AppearEvent(nil, EventType.UpdateHeroPower)
		-- if mStarSkillList then
			-- mStarSkillList[star.duty].level = nil
		-- end
		-- RefreshLevel()
	end
end

function SEND_GET_ALL_TEMP_SUC(cs_ByteArray)
	-- print("SEND_GET_ALL_TEMP_SUC")
	for k,star in pairs(mStarFateListByTemp) do
		star.temp = false
		table.insert(mStarFateListByRest, star)
	end
	mStarFateListByTemp = {}
end

function SEND_DES_ALL_TEMP_SUC(cs_ByteArray)
	-- print("SEND_DES_ALL_TEMP_SUC")
	mStarFateListByTemp = {}
end

function SEND_ORB_TEMP_STATE(cs_ByteArray)
	-- print("SEND_ORB_TEMP_STATE")
	local index = ByteArray.ReadInt(cs_ByteArray)
	for k,star in pairs(mStarFateListByTemp) do
		if star.index == index then
			star.temp = false
			table.insert(mStarFateListByRest, star)
			table.remove(mStarFateListByTemp, k)
			break
		end
	end
	
	-- local temp = ByteArray.ReadBool(cs_ByteArray)
	-- if not temp then
	-- mStarFateListByTemp = {}
end

function SEND_ADD_SKILL_ORB(cs_ByteArray)
	-- print("SEND_ADD_SKILL_ORB")
	mStarFateGeting = false
	if not mStarFateList then
		return
	end
	
	local star = {}
	star.index = ByteArray.ReadInt(cs_ByteArray)
	star.bid = ByteArray.ReadInt(cs_ByteArray)
	star.level = ByteArray.ReadInt(cs_ByteArray)
	star.duty = ByteArray.ReadInt(cs_ByteArray)
	star.temp = ByteArray.ReadBool(cs_ByteArray)
	
	mStarFateListByIndex[star.index] = star
	table.insert(mStarFateList, star)
	
	if star.temp then
		table.insert(mStarFateListByTemp, star)
	else
		table.insert(mStarFateListByRest, star)
		table.sort(mStarFateListByRest, sortFunc)
	end
end

function SEND_DEL_SKILL_ORB(cs_ByteArray)
	-- print("SEND_DEL_SKILL_ORB")
	if not mStarFateList then
		return
	end
	local index = ByteArray.ReadInt(cs_ByteArray)
	local star = mStarFateListByIndex[index]
	mStarFateListByIndex[index] = nil
	
	if not star.temp then
		for k,v in pairs(mStarFateList) do
			if v.index == index then
				table.remove(mStarFateList, k)
				break
			end
		end
	else
		for k,v in pairs(mStarFateListByTemp) do
			if v.index == index then
				table.remove(mStarFateListByTemp, k)
				break
			end
		end
	end
	
	if star.duty == 0 then
		for k,v in pairs(mStarFateListByRest) do
			if v.index == index then
				table.remove(mStarFateListByRest, k)
				break
			end
		end
	end
end

function GetStarSkillList(index, starList)
	local selectSkillList = mSelectSkillList[index]
	if not selectSkillList.skillList then
		local skillList = CheckSkill(starList)
		selectSkillList.skillList = skillList
		if skillList[1] and not mStarSkillList[index].id then
			RequestSetSkill(index, skillList[1])
		end
	end
	return selectSkillList.skillList
	
end

function CheckSkill(starList, count)
	count = count or #starList
	local tempList = {}
	for k,v in pairs(starList) do
		local cfg_star = CFG_star[v.bid]
		table.insert(tempList, cfg_star.key)
	end
	table.sort(tempList)
	
	local key = ""
	local num = #tempList
	for i=1,num,1 do
		key = key .. tempList[i]
	end
	
	local skillList = {}
	local skillListById = {}
	for k,v in pairs(CFG_starSkill) do
		local find = false
		local countRight = (v["star"..(count+1)]==nil or v["star"..(count+1)]==0)
		if countRight and v.key4 then
			find = string.find(key, v.key4)
			if find then
				local skill = {id=v.id,quality=4}
				table.insert(skillList, skill)
				skillListById[v.id] = skill
			end
		end
		if countRight and not find and v.key3 then
			find = string.find(key, v.key3)
			if find then
				local skill = {id=v.id,quality=3}
				table.insert(skillList, skill)
				skillListById[v.id] = skill
			end
		end
		if countRight and not find and v.key2 then
			find = string.find(key, v.key2)
			if find then
				local skill = {id=v.id,quality=2}
				table.insert(skillList, skill)
				skillListById[v.id] = skill
			end
		end
		if countRight and not find and v.key1 then
			find = string.find(key, v.key1)
			if find then
				local skill = {id=v.id,quality=1}
				table.insert(skillList, skill)
				skillListById[v.id] = skill
			end
		end
	end
	-- for k,skill in pairs(skillList) do
		-- InitStarSkillLevel(skill, starList)
	-- end
	
	return skillList, skillListById
end

function SetStarBySkill(skillId,quality,duty)
	mHeroManager.LockPower(99)
	
	local starFateList = mStarFateListByDuty[duty]
	local cfgStarSkill = CFG_starSkill[skillId]
	
	local tmpList = {}
	for k,v in pairs(starFateList) do
		tmpList[k] = v
	end
	table.sort(tmpList, sortFunc4)
	
	local needList = {}
	for i=1,7,1 do
		local type = cfgStarSkill["star"..i]
		local find = false
		-- print(type)
		if type == 0 then
			break
		end
		
		for k,v in pairs(tmpList) do
			local cfgStar = CFG_star[v.bid]
			if cfgStar.quality >= quality and cfgStar.type == type then
				table.remove(tmpList, k)
				find = true
				break
			end
		end
		-- print(find)
		if not find then
			needList[type] = needList[type] or 0
			needList[type] = needList[type] + 1
		end
	end
	
	
	local exStarList = {}
	if duty ~= 1 then
		table.simpleConcat(exStarList, ExStarList(1))
	end
	if duty ~= 2 then
		table.simpleConcat(exStarList, ExStarList(2))
	end
	if duty ~= 3 then
		table.simpleConcat(exStarList, ExStarList(3))
	end
	table.sort(exStarList, sortFunc4)
	table.simpleConcat(exStarList, tmpList)
	-- print(exStarList)
	
	
	local undutyList = {}
	local useCount = 0
	local unuseCount = 0
	-- print(needList)
	for i=0,3,1 do
		local list = nil
		if i == 0 then
			list = mStarFateListByRest
		elseif i ~= duty then
			list = ExStarList(i)
		end
		-- print(list)
		if list then
			for k,v in pairs(list) do
				local cfgStar = CFG_star[v.bid]
				if cfgStar.quality >= quality and needList[cfgStar.type] and needList[cfgStar.type] > 0 then 
					-- print(1)
					if v.duty ~= 0 then
						RequestSetStar(v.index, 0)
						undutyList[v.index] = true
						unuseCount = unuseCount + 1
					end
					
					-- EmptyOneSolt(duty, exStarList, #undutyList-useCount)
					-- print(2)
					if IsFull(duty, unuseCount-useCount) then
						-- print(3)
						while true do
							local star = table.remove(exStarList, #exStarList)
							-- print(4)
							if not undutyList[star.index] then
								-- print(5)
								RequestSetStar(star.index, 0)
								undutyList[star.index] = true
								unuseCount = unuseCount + 1
								break
							end
						end
					end
					
					useCount = useCount + 1
					needList[cfgStar.type] = needList[cfgStar.type] - 1
					
					RequestSetStar(v.index, duty)
				end
			end
		end
	end
	
end


-- function EmptyOneSolt(duty, exStarList, exCount)
	-- if not IsFull(duty, exCount) then
		-- return
	-- end
	-- RequestSetStar(exStarList[#exStarList].index, 0)
	-- table.remove(exStarList, #exStarList)
-- end

function IsFull(duty, exCount)
	local starFateList = mStarFateListByDuty[duty]
	if #starFateList >= 7 then
		return true
	end
	
	return EmptySoltCount() + exCount <= 0
end

function EmptySoltCount()
	local hero = mHeroManager.GetHero()
	local mSoltCount = 4 + math.floor(hero.level/5) + math.floor(hero.vipLevel/5)
	return mSoltCount-#mStarFateListByDuty[1]-#mStarFateListByDuty[2]-#mStarFateListByDuty[3]
end

function RequestSetStar(index, duty)
	-- print(index, duty)
	if duty == 0 and mStarFateListByRest[21] then
		mSystemTip.ShowTip("星魂背包已满,请先整理")
		return
	end
	-- print("RequestSetStar",index, duty)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.STARFATE)
	ByteArray.WriteByte(cs_ByteArray,Packat_StarFate.CLIENT_REQUEST_SET_ORB_IN_SLOT)
	ByteArray.WriteInt(cs_ByteArray,index)
	ByteArray.WriteInt(cs_ByteArray,duty)
	mNetManager.SendData(cs_ByteArray)
end

function RequestSetSkill(index, skill)
	-- print(index, skill.id)
	-- print("RequestSetSkill",index)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.STARFATE)
	ByteArray.WriteByte(cs_ByteArray,Packat_StarFate.CLIENT_REQUEST_SET_BATTLE_SKILL)
	ByteArray.WriteInt(cs_ByteArray,index)
	ByteArray.WriteInt(cs_ByteArray,skill.id)
	ByteArray.WriteInt(cs_ByteArray,skill.quality)
	-- ByteArray.WriteInt(cs_ByteArray,skill.activeStarList[1] or 0)
	-- ByteArray.WriteInt(cs_ByteArray,skill.activeStarList[2] or 0)
	-- ByteArray.WriteInt(cs_ByteArray,skill.activeStarList[3] or 0)
	-- ByteArray.WriteInt(cs_ByteArray,skill.activeStarList[4] or 0)
	-- ByteArray.WriteInt(cs_ByteArray,skill.activeStarList[5] or 0)
	-- ByteArray.WriteInt(cs_ByteArray,skill.activeStarList[6] or 0)
	-- ByteArray.WriteInt(cs_ByteArray,skill.activeStarList[7] or 0)
	mNetManager.SendData(cs_ByteArray)
end

function RequestActivateStarFate()
	-- print("RequestActivateStarFate")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.STARFATE)
	ByteArray.WriteByte(cs_ByteArray,Packat_StarFate.CLIENT_REQUEST_RMB_SCOPELEVEL)
	mNetManager.SendData(cs_ByteArray)
end

function RequestLevelUp(index)
	local star = mStarFateListByIndex[index]
	if star.level >= 10 then
		mSystemTip.ShowTip("该星运已升至满级")
		return
	end
	
	local cfg_star = CFG_star[star.bid]
	local cfg_starGrade = CFG_starGrade[cfg_star.quality.."_"..(star.level+1)]
	if cfg_starGrade.exp > GetStarPoint() then
		mSystemTip.ShowTip("星魂数量不足,需要"..cfg_starGrade.exp.."星魂")
		return
	end
	
	-- print("RequestLevelUp")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.STARFATE)
	ByteArray.WriteByte(cs_ByteArray,Packat_StarFate.CLIENT_REQUEST_UPGRADE_ORB)
	ByteArray.WriteInt(cs_ByteArray,index)
	mNetManager.SendData(cs_ByteArray)
end

function RequestGetStar()
	if mStarFateGeting then
		return
	end
	if mStarFateListByTemp[14] then
		mSystemTip.ShowTip("占星背包已满,请先整理", Color.LimeStr)
		return
	end
	-- print("RequestGetStar")
	mStarFateGeting = true
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.STARFATE)
	ByteArray.WriteByte(cs_ByteArray,Packat_StarFate.CLIENT_REQUEST_HOROSCOPE)
	mNetManager.SendData(cs_ByteArray)
end

function RequestTakeStar(index)
	-- print("RequestTakeStar")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.STARFATE)
	ByteArray.WriteByte(cs_ByteArray,Packat_StarFate.CLIENT_REQUEST_GET_TEMP_ORB)
	ByteArray.WriteInt(cs_ByteArray,index)
	mNetManager.SendData(cs_ByteArray)
end

function RequestTakeAllStar()
	-- print("RequestTakeAllStar")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.STARFATE)
	ByteArray.WriteByte(cs_ByteArray,Packat_StarFate.CLIENT_REQUEST_GET_ALL_TEMP)
	mNetManager.SendData(cs_ByteArray)
end

function BreakStar(index)
	local haveGoodStar = false
	if index then
		local star = mStarFateListByIndex[index]
		local cfg_star = CFG_star[star.bid]
		haveGoodStar = cfg_star.quality == 4
	else
		for k,star in pairs(mStarFateListByTemp) do
			local cfg_star = CFG_star[star.bid]
			if cfg_star.quality == 4 then
				haveGoodStar = true
				break
			end
		end
	end
	
	
	function func()
		if index then
			RequestBreakStar(index)
		else
			RequestBreakAllStar()
		end
	end
	
	if haveGoodStar then
		mAlert.Show("是否确定分解橙色星魂？",func)
	else
		func()
	end
end

function RequestBreakStar(index)
	-- print("RequestBreakStar")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.STARFATE)
	ByteArray.WriteByte(cs_ByteArray,Packat_StarFate.CLIENT_REQUEST_DESTROY_ORB)
	ByteArray.WriteInt(cs_ByteArray,index)
	mNetManager.SendData(cs_ByteArray)
end

function RequestBreakAllStar()
	-- print("RequestBreakAllStar")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.STARFATE)
	ByteArray.WriteByte(cs_ByteArray,Packat_StarFate.CLIENT_REQUEST_DES_ALL_TEMP)
	mNetManager.SendData(cs_ByteArray)
end
