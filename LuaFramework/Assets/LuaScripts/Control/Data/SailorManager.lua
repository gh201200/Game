local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Goods,LogbookType,SailorType = 
print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Goods,LogbookType,SailorType
local PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent = 
PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent
local CFG_UniqueSailor = CFG_UniqueSailor
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mAssetManager = nil
local mEventManager = nil
local mNetManager = nil
local mHeroManager = nil
local mEquipManager = nil
local mLabManager = nil
local mLogbookManager = nil
local mPanelManager = nil
local mSailorViewPanel = nil
local mAnimationManager = nil
local mItemManager = nil
local mAddItemTip = nil
local mSailorSkillManager = nil

module("LuaScript.Control.Data.SailorManager")

mSailorsById = nil
mSailorsByIndex = nil
local mSailors = nil
local mFightSailorList = nil
local mRestSailorList = nil
local mFreeEmployInfo = nil
local mExcEmployInfo = nil
local mCfgSailorListByQuality = nil

function GetSailors()
	return mSailors
end

function GetSailorById(id)
	return mSailorsById[id]
end

function GetSailorByIndex(id)
	return mSailorsByIndex[id]
end

function GetSailorByDuty(duty)
	return mFightSailorList[duty]
end

function GetCfgSailorsByQuality(quality)
	return mCfgSailorListByQuality[quality]
end

function GetFightSailors()
	return mFightSailorList
end

function GetRestSailors()
	return mRestSailorList
end

function GetBusinessSailors()
	local sailorList = {}
	for k,v in pairs(mRestSailorList) do
		table.insert(sailorList, v)
	end
	
	table.sort(sailorList, SortFunc2)
	
	return sailorList
end

function GetFreeEmployInfo()
	return mFreeEmployInfo
end

function GetExcEmployInfo()
	return mExcEmployInfo
end

function SailorDuty(index)
	for k,sailor in pairs(mFightSailorList) do
		if sailor.index == index then
			return true
		end
	end
end

function CfgSailorSortFunc(a,b)
	if a.power ~= b.power then
		return a.power > b.power
	end
	return a.id > b.id
end

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mEquipManager = require "LuaScript.Control.Data.EquipManager"
	mLabManager = require "LuaScript.Control.Data.LabManager"
	mLogbookManager = require "LuaScript.Control.Data.LogbookManager"
	mSailorViewPanel = require "LuaScript.View.Panel.Sailor.SailorViewPanel"
	mAnimationManager = require "LuaScript.Control.Data.AnimationManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mAddItemTip = require "LuaScript.View.Tip.AddItemTip"
	mSailorSkillManager = require "LuaScript.Control.Data.SailorSkillManager"
	
	mNetManager.AddListen(PackatHead.SAILOR, Packat_Sailor.SEND_ALL_SAILORS, SEND_ALL_SAILORS)
	mNetManager.AddListen(PackatHead.SAILOR, Packat_Sailor.SEND_ALL_MERCHANT_SAILORS, SEND_ALL_MERCHANT_SAILORS)
	mNetManager.AddListen(PackatHead.SAILOR, Packat_Sailor.SEND_ADD_SAILOR, SEND_ADD_SAILOR)
	mNetManager.AddListen(PackatHead.SAILOR, Packat_Sailor.SEND_DEL_SAILOR, SEND_DEL_SAILOR)
	mNetManager.AddListen(PackatHead.SAILOR, Packat_Sailor.SEND_SAILOR_CHG_DUTY, SEND_SAILOR_CHG_DUTY)
	mNetManager.AddListen(PackatHead.SAILOR, Packat_Sailor.SEND_FREE_EMPLOY_INFO, SEND_FREE_EMPLOY_INFO)
	mNetManager.AddListen(PackatHead.SAILOR, Packat_Sailor.SEND_ALREADY_HAVE_SAILOR, SEND_ALREADY_HAVE_SAILOR)
	mNetManager.AddListen(PackatHead.SAILOR, Packat_Sailor.SEND_SAILOR_STAR_INFO, SEND_SAILOR_STAR_INFO)
	mNetManager.AddListen(PackatHead.SAILOR, Packat_Sailor.SEND_SAILOR_EXLEVEL_INFO, SEND_SAILOR_EXLEVEL_INFO)
	mNetManager.AddListen(PackatHead.SAILOR, Packat_Sailor.SEND_EXCHANGE_SAILOR, SEND_EXCHANGE_SAILOR)
	
	
	mCfgSailorListByQuality = {{},{},{},{}}
	for k,v in pairs(CFG_UniqueSailor) do
		if v.resId ~= -1 and v.show == 1 then
			table.insert(mCfgSailorListByQuality[v.quality], v)
		end
	end
	table.sort(mCfgSailorListByQuality[1],CfgSailorSortFunc)
	table.sort(mCfgSailorListByQuality[2],CfgSailorSortFunc)
	table.sort(mCfgSailorListByQuality[3],CfgSailorSortFunc)
	table.sort(mCfgSailorListByQuality[4],CfgSailorSortFunc)
end

function SEND_ALL_SAILORS(cs_ByteArray)
	-- print("SEND_ALL_SAILORS")
	local count = ByteArray.ReadInt(cs_ByteArray)
	mSailors = {}
	mSailorsById = {}
	mSailorsByIndex = {}
	mRestSailorList = {}
	mFightSailorList = {}
	
	local globalProperty =  nil
	for i=1,count,1 do
		local sailor = {}
		sailor.id = ByteArray.ReadInt(cs_ByteArray)
		sailor.index = ByteArray.ReadShort(cs_ByteArray)
		sailor.duty = ByteArray.ReadByte(cs_ByteArray)
		sailor.type = ByteArray.ReadByte(cs_ByteArray)
		sailor.star = ByteArray.ReadInt(cs_ByteArray)
		sailor.exLevel = ByteArray.ReadInt(cs_ByteArray)
		sailor.exExp = ByteArray.ReadInt(cs_ByteArray)
		
		local cfg_sailor = CFG_UniqueSailor[sailor.index]
		sailor.name = cfg_sailor.name
		sailor.quality = cfg_sailor.quality
		sailor.resId = cfg_sailor.resId
		
		if sailor.type == SailorType.Hero then
			local hero = mHeroManager.GetHero()
			sailor.name = hero.name
		end
		
		table.insert(mSailors, sailor)
		mSailorsById[sailor.id] = sailor
		mSailorsByIndex[sailor.index] = sailor
		
		if sailor.duty ~= 0 then
			mFightSailorList[sailor.duty] = sailor
		else
			table.insert(mRestSailorList, sailor)
		end
		
		globalProperty = globalProperty or GetGlobalProperty()
		
		UpdateProperty(sailor, false, nil, nil, globalProperty)
	end
	
	local hero = mHeroManager.GetHero()
	mFightSailorList[1].quality = hero.quality
	
	table.sort(mRestSailorList, SortFunc)
	-- AppearEvent(nil, EventType.OnRefreshSailor)
end


function SEND_ALL_MERCHANT_SAILORS(cs_ByteArray)
	-- print("SEND_ALL_MERCHANT_SAILORS")
	-- mShipTeamSailorList = {}
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count,1 do
		local sailor = {}
		sailor.id = ByteArray.ReadInt(cs_ByteArray)
		sailor.index = ByteArray.ReadShort(cs_ByteArray)
		sailor.duty = ByteArray.ReadByte(cs_ByteArray)
		sailor.type = ByteArray.ReadByte(cs_ByteArray)
		sailor.star = ByteArray.ReadInt(cs_ByteArray)
		sailor.exLevel = ByteArray.ReadInt(cs_ByteArray)
		sailor.exExp = ByteArray.ReadInt(cs_ByteArray)
		
		UpdateProperty(sailor)
		
		local cfg_sailor = CFG_UniqueSailor[sailor.index]
		sailor.name = cfg_sailor.name
		sailor.quality = cfg_sailor.quality
		sailor.resId = cfg_sailor.resId
		
		mSailorsById[sailor.id] = sailor
		mSailorsByIndex[sailor.index] = sailor
		
	end
end

function SortFunc(a, b)
	if a.quality > b.quality then
		return true
	elseif a.quality == b.quality and a.power > b.power then
		return true
	end
	return false
end

function SortFunc2(a, b)
	if a.business > b.business then
		return true
	elseif a.business < b.business then
		return false
	end
	
	if a.quality > b.quality then
		return true
	elseif a.quality < b.quality then
		return false
	end
	
	if a.power > b.power then
		return true
	elseif a.power < b.power then
		return false
	end
	
	return a.id > b.id
end

function SEND_ADD_SAILOR(cs_ByteArray)
	-- print("SEND_ADD_SAILOR")
	if not mSailors then
		return
	end
	local sailor = {}
	sailor.id = ByteArray.ReadInt(cs_ByteArray)
	sailor.index = ByteArray.ReadShort(cs_ByteArray)
	sailor.duty = ByteArray.ReadByte(cs_ByteArray)
	sailor.type = ByteArray.ReadByte(cs_ByteArray)
	sailor.star = ByteArray.ReadInt(cs_ByteArray)
	sailor.exLevel = ByteArray.ReadInt(cs_ByteArray)
	sailor.exExp = ByteArray.ReadInt(cs_ByteArray)
	
	
	UpdateProperty(sailor)
	
	local cfg_sailor = CFG_UniqueSailor[sailor.index]
	sailor.name = cfg_sailor.name
	sailor.quality = cfg_sailor.quality
	sailor.resId = cfg_sailor.resId
	table.insert(mSailors, sailor)
	mSailorsById[sailor.id] = sailor
	mSailorsByIndex[sailor.index] = sailor
	table.insert(mRestSailorList, sailor)
	table.sort(mRestSailorList, SortFunc)
	
	mLogbookManager.AddLog(LogbookType.Sailor, os.oldTime, sailor.quality, sailor.name)
	
	AppearEvent(nil, EventType.OnRefreshGuide)
	
	-- mSailorViewPanel.SetData(sailor)
	-- mPanelManager.Show(mSailorViewPanel)
	
	AppearEvent(nil,EventType.Refreshed)
	UpdateAllProperty(false)
	mAnimationManager.Start(3, nil, sailor, sailor.index)
end

function SEND_DEL_SAILOR(cs_ByteArray)
	-- print("SEND_DEL_SAILOR")
	local id = ByteArray.ReadInt(cs_ByteArray)
	for k,v in pairs(mSailors) do
		if v.id == id then
			table.remove(mSailors, k)
			break
		end
	end
	
	local sailor = mSailorsById[id]
	if sailor and sailor.duty ~= 0 then
		mFightSailorList[sailor.duty] = nil
	end
	
	for k,v in pairs(mRestSailorList) do
		if v.id == id then
			table.remove(mRestSailorList, k)
			break
		end
	end
	mSailorsById[id] = nil
	if sailor then
		mSailorsByIndex[sailor.index] = nil
	end
	
	UpdateAllProperty(false)
end

function MoveToShipTeam(id)
	-- print("MoveToShipTeam",id)
	for k,v in pairs(mSailors) do
		if v.id == id then
			table.remove(mSailors, k)
			-- print("ok")
			break
		end
	end
	for k,v in pairs(mRestSailorList) do
		if v.id == id then
			table.remove(mRestSailorList, k)
			-- print("ok")
			break
		end
	end
	
	-- mEquipManager.SailorInShipTeam(id, true)
end

function MoveFromShipTeam(id)
	-- print("MoveFromShipTeam",id)
	local sailor = mSailorsById[id]
	table.insert(mSailors, sailor)
	table.insert(mRestSailorList, sailor)
	table.sort(mRestSailorList, SortFunc)
	
	-- mEquipManager.SailorInShipTeam(id, false)
end

function SEND_SAILOR_CHG_DUTY(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	local duty = ByteArray.ReadByte(cs_ByteArray)
	
	local sourceId = nil
	local sailor = mFightSailorList[duty]
	if sailor then
		sourceId = sailor.id
		sailor.duty = 0
		table.insert(mRestSailorList, sailor)
	end
	
	for k,v in pairs(mRestSailorList) do
		if v.id == id then
			table.remove(mRestSailorList, k)
			break
		end
	end
	
	local sailor = mSailorsById[id]
	sailor.duty = duty
	mFightSailorList[duty] = sailor
	
	mEquipManager.EquipMove(sourceId, id)
	
	UpdateAllProperty(false)
	
	AppearEvent(nil, EventType.OnSailorDuty, duty)
	
	table.sort(mRestSailorList, SortFunc)
end

function SEND_FREE_EMPLOY_INFO(cs_ByteArray)
	mFreeEmployInfo = {}
	mFreeEmployInfo.freeCount1 = ByteArray.ReadInt(cs_ByteArray)
	mFreeEmployInfo.freeTime1 = ByteArray.ReadInt(cs_ByteArray)
	mFreeEmployInfo.freeCount2 = ByteArray.ReadInt(cs_ByteArray)
	mFreeEmployInfo.freeTime2 = ByteArray.ReadInt(cs_ByteArray)
	mFreeEmployInfo.freeCount3 = ByteArray.ReadInt(cs_ByteArray)
	mFreeEmployInfo.freeTime3 = ByteArray.ReadInt(cs_ByteArray)
	mFreeEmployInfo.updateTime = os.clock()
end

function SEND_ALREADY_HAVE_SAILOR(cs_ByteArray) -- 已有船员将变成碎片加入物品
	-- print("SEND_ALREADY_HAVE_SAILOR")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local index = ByteArray.ReadInt(cs_ByteArray)
	local count = ByteArray.ReadInt(cs_ByteArray)
	-- print(id, count)
	mAddItemTip.StopAddShow(0, id, count)
	mAnimationManager.Start(2, nil, id, index)
	
	AppearEvent(nil,EventType.Refreshed)
end

function SEND_SAILOR_STAR_INFO(cs_ByteArray)
	-- print("SEND_SAILOR_STAR_INFO")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local star = ByteArray.ReadInt(cs_ByteArray)
	-- print(star, exp)
	local sailor = GetSailorById(id)
	sailor.star = star

	UpdateProperty(sailor, true)
	AppearEvent(nil,EventType.RefreshSailorUp)
end


function SEND_SAILOR_EXLEVEL_INFO(cs_ByteArray)
	-- print("SEND_SAILOR_STAR_INFO")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local exLevel = ByteArray.ReadInt(cs_ByteArray)
	local exExp = ByteArray.ReadInt(cs_ByteArray)

	local sailor = GetSailorById(id)
	sailor.exLevel = exLevel
	sailor.exExp = exExp
	
	UpdateProperty(sailor, true)
	
	AppearEvent(nil,EventType.RefreshSailorUp)
end

function SEND_EXCHANGE_SAILOR(cs_ByteArray)
	-- print("SEND_EXCHANGE_SAILOR")
	mExcEmployInfo = {
		ByteArray.ReadInt(cs_ByteArray),
		ByteArray.ReadInt(cs_ByteArray),
		ByteArray.ReadInt(cs_ByteArray),
	}
end

function UpdateAllProperty(showPowerChange)
	if not mSailors then
		return
	end
	local globalProperty = GetGlobalProperty()
	for k,sailor in pairs(mSailorsById) do
		UpdateProperty(sailor, showPowerChange, nil, nil, globalProperty)
	end
	
	AppearEvent(nil, EventType.UpdateHeroPower)
end

function UpdateProperty(sailor, showPowerChange, level, exLevel, globalProperty)
	if not level then
		local hero = mHeroManager.GetHero()
		if not hero then
			return
		end
		level = hero.level
	end
	if not exLevel then
		exLevel = sailor.exLevel
	end
	globalProperty = globalProperty or GetGlobalProperty()
	local cfg_sailor = CFG_UniqueSailor[sailor.index]
	local levelModulus = 1 + (level + exLevel - 1) * 0.1
	sailor.attack = cfg_sailor.attack * levelModulus
	sailor.defense = cfg_sailor.defense * levelModulus
	sailor.hp = cfg_sailor.hp	 * levelModulus
	sailor.business = cfg_sailor.business * levelModulus
	
	local property = {[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[10]=0,[12]=0,[14]=0,[16]=0}
	if sailor.duty ~= 0 then
		local equipProperty = mEquipManager.GetEquipProperty(sailor)
		if equipProperty then
			sailor.attack = sailor.attack + (equipProperty[1] or 0)
			sailor.defense = sailor.defense + (equipProperty[3] or 0)
			sailor.hp = sailor.hp + (equipProperty[5] or 0)
			sailor.business = sailor.business + (equipProperty[7] or 0)
			
			property[2] = property[2] + (equipProperty[2] or 0)
			property[4] = property[4] + (equipProperty[4] or 0)
			property[6] = property[6] + (equipProperty[6] or 0)
			property[8] = property[8] + (equipProperty[8] or 0)
			
			property[10] = property[10] + (equipProperty[10] or 0)
			property[12] = property[12] + (equipProperty[12] or 0)
			property[14] = property[14] + (equipProperty[14] or 0)
			property[16] = property[16] + (equipProperty[16] or 0)
		end
		mEquipManager.GetSuitProperty(sailor, property)
		
		mSailorSkillManager.GetSkillProperty(sailor, property)
	
		sailor.attack = sailor.attack + property[1]
		sailor.defense = sailor.defense + property[3]
		sailor.hp = sailor.hp + property[5]
		sailor.business = sailor.business + property[7]
		
		sailor.attack = sailor.attack * (property[2] * 0.01 + 1)
		sailor.defense = sailor.defense * (property[4] * 0.01 + 1)
		sailor.hp = sailor.hp * (property[6] * 0.01 + globalProperty[64]*0.01 + 1)
		sailor.business = sailor.business * (property[8] * 0.01 + 1)
		
		sailor.hitPer = property[10]
		sailor.dodgePer = property[12]
		sailor.critPer = property[14]
		sailor.unCritPer = property[16]
		
		sailor.restAttack = 0
		sailor.restDefense = 0
		sailor.restHp = 0
		sailor.restBusiness = 0
	else
		mSailorSkillManager.GetSkillProperty(sailor, property)
		
		sailor.attack = sailor.attack + property[1]
		sailor.defense = sailor.defense + property[3]
		sailor.hp = sailor.hp + property[5]
		sailor.business = sailor.business + property[7]
		
		sailor.attack = sailor.attack * (property[2] * 0.01 + 1)
		sailor.defense = sailor.defense * (property[4] * 0.01 + 1)
		sailor.hp = sailor.hp * (property[6] * 0.01 + globalProperty[64]*0.01 + 1)
		sailor.business = sailor.business * (property[8] * 0.01 + 1)
		
		sailor.hitPer = 0
		sailor.dodgePer = 0
		sailor.critPer = 0
		sailor.unCritPer = 0
		
		sailor.restAttack = sailor.attack * ((property[2] or 0) * 0.01)
		sailor.restDefense = sailor.defense * ((property[4] or 0) * 0.01)
		sailor.restHp = sailor.hp * ((property[6] or 0) * 0.01)
		sailor.restBusiness = sailor.business * ((property[8] or 0) * 0.01)
		
		sailor.restBusiness = math.floor(sailor.restBusiness)
	end
	
	
	sailor.attack = math.floor(sailor.attack)
	sailor.defense = math.floor(sailor.defense)
	sailor.hp = math.floor(sailor.hp)
	sailor.business = math.floor(sailor.business)
	
	local power = mCommonlyFunc.GetSailorPower(sailor, level, exLevel)
	if sailor.duty ~= 0 then
		power = power + mEquipManager.GetPowerBySailor(sailor)
		power = power + mEquipManager.GetSuitPowerBySailor(sailor)
		power = power + mSailorSkillManager.GetSkillPower(sailor)
	end
	sailor.power = power
	
	if showPowerChange then
		AppearEvent(nil, EventType.UpdateHeroPower)
	end
end

local mPower = nil
function GetTotalPower()
	if mPower then
		return mPower
	end
	local mPower = 0
	for k, sailor in pairs(mFightSailorList) do
		mPower = mPower + mCommonlyFunc.GetSailorPower(sailor)
		mPower = mPower + mEquipManager.GetSuitPowerBySailor(sailor)
	end
	
	for k, sailor in pairs(mSailors) do
		mPower = mPower + mSailorSkillManager.GetSkillPower(sailor)
	end
	
	-- for k, sailor in pairs(mRestSailorList) do
		-- mPower = mPower + mCommonlyFunc.GetEquipPower(sailor)
	-- end
	return mPower
end

function GetGlobalProperty()
	-- print("GetGlobalProperty")
	local sailor = GetSailorByDuty(1)
	if not sailor then
		return {[64]=0}
	end
	local property = mSailorSkillManager.GetSkillProperty(sailor, {[64]=0})
	return property
end

function GetTotleBusiness()
	local totalBusiness = 0
	for k, sailor in pairs(mFightSailorList) do
		totalBusiness = totalBusiness + sailor.business
	end
	for k, sailor in pairs(mRestSailorList) do
		totalBusiness = totalBusiness + sailor.restBusiness
	end
	return math.floor(totalBusiness)
end

function RequestFire(id)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.SAILOR)
	ByteArray.WriteByte(cs_ByteArray,Packat_Sailor.CLIENT_REQUEST_FIRE_SAILOR)
	ByteArray.WriteInt(cs_ByteArray,id)
	mNetManager.SendData(cs_ByteArray)
end

function RequestSetDuty(id, post)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.SAILOR)
	ByteArray.WriteByte(cs_ByteArray,Packat_Sailor.CLIENT_REQUEST_SET_SAILOR_DUTY)
	ByteArray.WriteInt(cs_ByteArray,id)
	ByteArray.WriteByte(cs_ByteArray,post)
	mNetManager.SendData(cs_ByteArray)
end

function RequestStarUp(id)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.SAILOR)
	ByteArray.WriteByte(cs_ByteArray,Packat_Sailor.CLIENT_REQUEST_STAR_UP_SAILOR)
	ByteArray.WriteInt(cs_ByteArray,id)
	mNetManager.SendData(cs_ByteArray)
end

function RequestExLevelUp(id, level)
	-- print(id)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.SAILOR)
	ByteArray.WriteByte(cs_ByteArray,Packat_Sailor.CLIENT_REQUEST_EXLEVEL_UP_SAILOR)
	ByteArray.WriteInt(cs_ByteArray,id)
	ByteArray.WriteInt(cs_ByteArray,level)
	mNetManager.SendData(cs_ByteArray)
end

function RequestExchange(id)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.SAILOR)
	ByteArray.WriteByte(cs_ByteArray,Packat_Sailor.CLIENT_REQUEST_EXCHANGE_SAILOR)
	ByteArray.WriteInt(cs_ByteArray,id)
	mNetManager.SendData(cs_ByteArray)
end

function RequestExchangeList()
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.SAILOR)
	ByteArray.WriteByte(cs_ByteArray,Packat_Sailor.CLIENT_REQUEST_EXCHANGELIST)
	mNetManager.SendData(cs_ByteArray)
end

-- function SEND_DEL_SAILOR(cs_ByteArray)
	-- local index = ByteArray.ReadInt(cs_ByteArray)
	-- for k,v in pairs(mSailors) do
		-- if v.index == index then
			-- table.remove(mSailors, k)
			-- mSailorsById[v.index] = nil
			-- break
		-- end
	-- end
-- end