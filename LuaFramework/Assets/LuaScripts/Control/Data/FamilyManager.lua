local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Family,Packat_Goods,ConstValue,CFG_family = 
print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Family,Packat_Goods,ConstValue,CFG_family
local PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent = 
PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent
local CFG_role,CharacterType,GetLength = CFG_role,CharacterType,GetLength
local Color = Color
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mAssetManager = nil
local mEventManager = nil
local mNetManager = nil
local mHeroManager = nil
local mSystemTip = nil
local mAlert = nil
local mHeroTip = nil

module("LuaScript.Control.Data.FamilyManager")

local mFamilyList = nil
local mMemberList = nil
local mMemberListById = nil
local mApplyerList = nil
local mFamilyInfo = nil

local mGoods = nil
local mGoodsCount = nil

local mLogVersion = 0
local mLogs = ""

mLastUpdateTime1 = -10000
mLastUpdateTime2 = -10000

local mNewCount = 0
function GetNewCount()
	local hero = mHeroManager.GetHero()
	if hero and hero.post and hero.post < 2 then
		return 0
	end
	-- if mApplyerList then
		return math.min(mNewCount, 99)
	-- else
		-- return 0
	-- end
end

function Reset()
	mFamilyList = nil
	mMemberList = nil
	mMemberListById = nil
	mApplyerList = nil
	mFamilyInfo = nil

	mGoods = nil
	mGoodsCount = nil

	mLogVersion = 0
	mLogs = ""

	mLastUpdateTime1 = -10000
	mLastUpdateTime2 = -10000
end


function ClearNewCount()
	mNewCount = 0
end

function GetLogs()
	return mLogs
end

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mAlert = require "LuaScript.View.Alert.Alert"
	mHeroTip = require "LuaScript.View.Tip.HeroTip"
	
	mEventManager.AddEventListen(nil, EventType.FamilyDel, FamilyDel)
	mEventManager.AddEventListen(nil, EventType.ConnectFailure, ConnectFailure)
	
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_HOME_INFO, SEND_HOME_INFO)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_SIMPLE_HOME_LIST, SEND_SIMPLE_HOME_LIST)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_HOME_REQUEST_POSTED, SEND_HOME_REQUEST_POSTED)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_HOME_ADD_MEMBER, SEND_HOME_ADD_MEMBER)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_HOME_DEL_MEMBER, SEND_HOME_DEL_MEMBER)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_MEMBER_LIST, SEND_MEMBER_LIST)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_JOIN_LIST, SEND_JOIN_LIST)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_CREATE_SUCCESSFUL, SEND_CREATE_SUCCESSFUL)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_NEW_REQUEST, SEND_NEW_REQUEST)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_REFUSE_REQUEST, SEND_REFUSE_REQUEST)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_HOME_MEMBER_ONLINE, SEND_HOME_MEMBER_ONLINE)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_HOME_MEMBER_DUTY_CHG, SEND_HOME_MEMBER_DUTY_CHG)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_HOME_MONEY_CHG, SEND_HOME_MONEY_CHG)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_CONTRIBUTE_CHG, SEND_CONTRIBUTE_CHG)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_HOME_CHG_NOTICE, SEND_HOME_CHG_NOTICE)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_HOME_CHG_MASTER, SEND_HOME_CHG_MASTER)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_HOME_LEVEL_CHG, SEND_HOME_LEVEL_CHG)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_HOME_ITEM_LIST, SEND_HOME_ITEM_LIST)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_HOME_ITEM_COUNT, SEND_HOME_ITEM_COUNT)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_HOME_LOG, SEND_HOME_LOG)
end

function ConnectFailure()
end

function FamilyDel()
	mFamilyList = nil
	mMemberList = nil
	mMemberListById = nil
	mApplyerList = nil
	mFamilyInfo = nil
end

function GetOnlineStr(member)
	if member.onlineStr then
		return member.onlineStr
	end
	member.onlineStr = mCommonlyFunc.GetOnlineTime(member.online)
	return member.onlineStr
end

function GetFamilyInfo()
	return mFamilyInfo
end

function GetFamilyList()
	return mFamilyList
end

function GetApplyerList()
	return mApplyerList
end

function GetMemberList()
	return mMemberList
end

function GetNotice()
	if mFamilyInfo then
		return mFamilyInfo.notice
	end
	return nil
end

function GetGoods()
	return mGoods,mGoodsCount
end

function GetMemberCountInfo(family)
	if family.memberCountInfo then
		return family.memberCountInfo
	end
	local maxCount = CFG_family[family.level].member
	if family.memberCount then
		family.memberCountInfo = family.memberCount .. "/" .. maxCount
	elseif mMemberList then
		family.memberCountInfo = #mMemberList .. "/" .. maxCount
	else
		family.memberCountInfo = "??/" .. maxCount
	end
	return family.memberCountInfo
end

function RequestCreate(name)
	-- print("RequestCreate")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_REQUEST_CREATE_HOME)
	ByteArray.WriteUTF(cs_ByteArray,name, 40)
	mNetManager.SendData(cs_ByteArray)
end

function RequestFamilyList()
	if os.oldClock - mLastUpdateTime1 < ConstValue.UpdateFamilyTime then
		return
	end
	mLastUpdateTime1 = os.oldClock
	-- print("RequestFamilyList")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_REQUEST_HOME_LIST)
	mNetManager.SendData(cs_ByteArray)
end


function RequestJoin(fid)
	-- print("RequestJoin")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_REQUEST_JOIN_HOME)
	ByteArray.WriteInt(cs_ByteArray,fid)
	mNetManager.SendData(cs_ByteArray)
end

function RequestAccept(cid)
	-- print("RequestAccept")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_REQUEST_ACCEPT_MEMBER)
	ByteArray.WriteInt(cs_ByteArray,cid)
	mNetManager.SendData(cs_ByteArray)
end

function RequestRefuse(cid)
	-- print("RequestRefuse")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_REQUEST_REFUSE_REQUEST)
	ByteArray.WriteInt(cs_ByteArray,cid)
	mNetManager.SendData(cs_ByteArray)
end

function RequestKick(cid)
	-- print("RequestKick")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_REQUEST_KICK_MEMBER)
	ByteArray.WriteInt(cs_ByteArray,cid)
	mNetManager.SendData(cs_ByteArray)
end

function RequestFamilyMember()
	if os.oldClock - mLastUpdateTime2 < ConstValue.UpdateFamilyTime then
		return
	end
	mLastUpdateTime2 = os.oldClock
	-- print("RequestFamilyMember")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_REQUEST_HOME_MEMBER_LIST)
	mNetManager.SendData(cs_ByteArray)
end

function RequestFamilyApplyer()
	-- print(1)
	local hero = mHeroManager.GetHero()
	if not hero.post or hero.post <= 1 then
		return
	end
	-- print(2)
	if mApplyerList then
		return
	end
	-- print("RequestFamilyApplyer")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_REQUEST_HOME_JOIN_LIST)
	mNetManager.SendData(cs_ByteArray)
end

function RequestLeave()
	-- print("RequestLeave")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_REQUEST_LEAVE_HOME)
	mNetManager.SendData(cs_ByteArray)
end

function RequestUp()
	-- print("RequestUp")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_REQUEST_LEVELUP_HOME)
	mNetManager.SendData(cs_ByteArray)
end

function RequestGiveMoney(money)
	-- print("RequestUp")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_REQUEST_GIVE_HOME_MONEY)
	ByteArray.WriteInt(cs_ByteArray,money)
	mNetManager.SendData(cs_ByteArray)
end

function RequestGiveItem(index, count)
	-- print("RequestUp")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_REQUEST_GIVE_HOME_ITEM)
	ByteArray.WriteInt(cs_ByteArray,index)
	ByteArray.WriteInt(cs_ByteArray,count)
	mNetManager.SendData(cs_ByteArray)
end

function RequestChangeNotice(msg)
	-- print("RequestChangeNotice")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_REQUEST_CHG_NOTICE)
	ByteArray.WriteUTF(cs_ByteArray,msg, 150)
	mNetManager.SendData(cs_ByteArray)
end

function RequestSetPost(id, post)
	-- print("RequestSetPost")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_REQUEST_SET_HOME_DUTY)
	ByteArray.WriteInt(cs_ByteArray,id)
	ByteArray.WriteByte(cs_ByteArray,post)
	mNetManager.SendData(cs_ByteArray)
end

function RequestFamilyGoods()
	-- print("RequestFamilyGoods")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_REQUEST_HOME_ITEM_LIST)
	mNetManager.SendData(cs_ByteArray)
end

function RequestExchangeGoods(goodsId, count)
	-- print("RequestExchangeGoods")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_REQUEST_BUY_HOME_ITEM)
	ByteArray.WriteInt(cs_ByteArray,goodsId)
	ByteArray.WriteInt(cs_ByteArray,count)
	mNetManager.SendData(cs_ByteArray)
end

function RequestDeleteGoods(goodsId)
	-- print("RequestDeleteGoods")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_REQUEST_DEL_HOME_ITEM)
	ByteArray.WriteInt(cs_ByteArray,goodsId)
	mNetManager.SendData(cs_ByteArray)
end

function RequestLog()
	print("RequestLog")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_REQUEST_HOME_LOG)
	ByteArray.WriteInt(cs_ByteArray,mLogVersion)
	mNetManager.SendData(cs_ByteArray)
end

function StopFamilyGoods()
	-- print("StopFamilyGoods")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.FAMILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_Family.CLIENT_CLOSE_HOME_ITEM_LIST)
	mNetManager.SendData(cs_ByteArray)
end

function SEND_HOME_INFO(cs_ByteArray)
	-- print("SEND_HOME_INFO")
	mFamilyInfo = {}
	mFamilyInfo.id = ByteArray.ReadInt(cs_ByteArray)
	mFamilyInfo.name = ByteArray.ReadUTF(cs_ByteArray,40)
	mFamilyInfo.notice = ByteArray.ReadUTF(cs_ByteArray,150)
	mFamilyInfo.level = ByteArray.ReadByte(cs_ByteArray)
	mFamilyInfo.memberCount = ByteArray.ReadInt(cs_ByteArray)
	mFamilyInfo.money = ByteArray.ReadInt(cs_ByteArray)
	mFamilyInfo.leaderId = ByteArray.ReadInt(cs_ByteArray)
	mFamilyInfo.leaderName = ByteArray.ReadUTF(cs_ByteArray,40)
	
	local hero = mHeroManager.GetHero()
	hero.contribute = ByteArray.ReadInt(cs_ByteArray)
	hero.todayContribute = ByteArray.ReadInt(cs_ByteArray)
end

function SEND_SIMPLE_HOME_LIST(cs_ByteArray)
	mFamilyList = {}
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count,1 do
		local family = {}
		family.id = ByteArray.ReadInt(cs_ByteArray)
		family.name = ByteArray.ReadUTF(cs_ByteArray,40)
		family.leaderName = ByteArray.ReadUTF(cs_ByteArray,40)
		family.level = ByteArray.ReadByte(cs_ByteArray)
		family.memberCount = ByteArray.ReadByte(cs_ByteArray)
		family.isApplyed = ByteArray.ReadByte(cs_ByteArray)
		table.insert(mFamilyList, family)
	end
	table.sort(mFamilyList, sortFunc)
end

function SEND_HOME_REQUEST_POSTED(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	
	for k,v in pairs(mFamilyList) do
		if v.id == id then
			v.isApplyed = 2
			break
		end
	end
end

function SEND_HOME_ADD_MEMBER(cs_ByteArray)
	local member = {}
	member.type = CharacterType.Player
	member.id = ByteArray.ReadInt(cs_ByteArray)
	member.name = ByteArray.ReadUTF(cs_ByteArray,40)
	member.level = ByteArray.ReadByte(cs_ByteArray)
	member.power = ByteArray.ReadInt(cs_ByteArray)
	member.contribute = 0
	member.post = 1
	member.online = 0
	member.role = ByteArray.ReadByte(cs_ByteArray)
	local cfg_role = CFG_role[member.role]
	member.quality = cfg_role.quality
	member.resId = cfg_role.resId
	
	if mApplyerList then
		for k,v in pairs(mApplyerList) do
			if v.id == member.id then
				table.remove(mApplyerList, k)
				break
			end
		end
	end
	
	if mMemberList then
		table.insert(mMemberList, member)
		mMemberListById[member.id] = member
		table.sort(mMemberList, sortFunc2)
	end
	
	if mFamilyInfo and mMemberList then
		mFamilyInfo.memberCount = #mMemberList
		mFamilyInfo.memberCountInfo = nil
	end
end

function SEND_HOME_DEL_MEMBER(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	local hero = mHeroManager.GetHero()
	
	if mMemberList then
		for k,v in pairs(mMemberList) do
			if v.id == id then
				table.remove(mMemberList, k)
				break
			end
		end
		mMemberListById[id] = nil
	end
	
	if mFamilyInfo and mMemberList then
		mFamilyInfo.memberCount = #mMemberList
		mFamilyInfo.memberCountInfo = nil
	end
end

function SEND_MEMBER_LIST(cs_ByteArray)
	local hero = mHeroManager.GetHero()
	mFamilyInfo.level = ByteArray.ReadByte(cs_ByteArray)
	mFamilyInfo.money = ByteArray.ReadInt(cs_ByteArray)
	mFamilyInfo.notice = ByteArray.ReadUTF(cs_ByteArray,150)

	mMemberList = {}
	mMemberListById = {}
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count,1 do
		local member = {}
		member.type = CharacterType.Player
		member.id = ByteArray.ReadInt(cs_ByteArray)
		member.name = ByteArray.ReadUTF(cs_ByteArray,40)
		member.level = ByteArray.ReadByte(cs_ByteArray)
		member.power = ByteArray.ReadInt(cs_ByteArray)
		member.contribute = ByteArray.ReadInt(cs_ByteArray)
		member.post= ByteArray.ReadByte(cs_ByteArray)
		member.online = ByteArray.ReadInt(cs_ByteArray)
		member.role = ByteArray.ReadByte(cs_ByteArray)
		local cfg_role = CFG_role[member.role]
		member.quality = cfg_role.quality
		member.resId = cfg_role.resId
		table.insert(mMemberList, member)
		mMemberListById[member.id] = member
	end
	
	mFamilyInfo.memberCount = #mMemberList
	mFamilyInfo.memberCountInfo = nil	
	
	table.sort(mMemberList, sortFunc2)
end

function SEND_JOIN_LIST(cs_ByteArray)
	mApplyerList = {}
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count,1 do
		local applyer = {}
		applyer.id = ByteArray.ReadInt(cs_ByteArray)
		applyer.type = CharacterType.Player
		applyer.name = ByteArray.ReadUTF(cs_ByteArray,40)
		applyer.level = ByteArray.ReadByte(cs_ByteArray)
		applyer.power = ByteArray.ReadInt(cs_ByteArray)
		applyer.role = ByteArray.ReadByte(cs_ByteArray)
		local cfg_role = CFG_role[applyer.role]
		applyer.quality = cfg_role.quality
		applyer.resId = cfg_role.resId
		table.insert(mApplyerList, 1, applyer)
	end
	mNewCount = count
end

function SEND_CREATE_SUCCESSFUL(cs_ByteArray)
	-- print("SEND_CREATE_SUCCESSFUL")
	mSystemTip.ShowTip("联盟创建成功", Color.LimeStr)
	AppearEvent(nil, EventType.FamilyCreate)
end

function SEND_NEW_REQUEST(cs_ByteArray)
	local applyer = {}
	applyer.id = ByteArray.ReadInt(cs_ByteArray)
	applyer.name = ByteArray.ReadUTF(cs_ByteArray,40)
	applyer.type = CharacterType.Player
	applyer.level = ByteArray.ReadByte(cs_ByteArray)
	applyer.power = ByteArray.ReadInt(cs_ByteArray)
	applyer.role = ByteArray.ReadByte(cs_ByteArray)
	
	local cfg_role = CFG_role[applyer.role]
	applyer.quality = cfg_role.quality
	applyer.resId = cfg_role.resId
	
	if mApplyerList then
		table.insert(mApplyerList, 1, applyer)
	end
	
	local info = "\"" .. applyer.name .. "\"申请加入本联盟，在"
	info = info .. mCommonlyFunc.BeginColor(Color.CyanStr)
	info = info .. "联盟•申请"
	info = info .. mCommonlyFunc.EndColor()
	info = info .. "处操作"
	mSystemTip.ShowTip(info, Color.LimeStr)
	
	mNewCount = mNewCount + 1
end

function SEND_REFUSE_REQUEST(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	if mApplyerList then
		for k,v in pairs(mApplyerList) do
			if v.id == id then
				table.remove(mApplyerList, k)
				return
			end
		end
	end
end

function SEND_HOME_MEMBER_DUTY_CHG(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	local post = ByteArray.ReadByte(cs_ByteArray)
	if mMemberListById and mMemberListById[id] then
		if post == 3 then
			for k,v in pairs(mMemberList) do
				if v.post == 3 then
					v.post = 1
					break
				end
			end
		end
		mMemberListById[id].post = post
	end
	-- local hero = mHeroManager.GetHero()
	-- if hero.id == id then
		-- hero.post =post
		-- mCommonlyFunc.UpdateTitle(hero)
	-- end
end

function SEND_HOME_MONEY_CHG(cs_ByteArray)
	mFamilyInfo.money = ByteArray.ReadInt(cs_ByteArray)
	-- if mGoods[14] then
		-- mGoods[14].count = mFamilyInfo.money*10000
	-- end
end

function SEND_HOME_CHG_NOTICE(cs_ByteArray)
	local notice = ByteArray.ReadUTF(cs_ByteArray,150)
	mFamilyInfo.notice = notice
	
	AppearEvent(nil, EventType.FamilyNotice)
end

function SEND_HOME_CHG_MASTER(cs_ByteArray)
	mFamilyInfo.leaderId = ByteArray.ReadInt(cs_ByteArray)
	mFamilyInfo.leaderName = ByteArray.ReadUTF(cs_ByteArray,40)
end

function SEND_HOME_LEVEL_CHG(cs_ByteArray)
	mFamilyInfo.level = ByteArray.ReadByte(cs_ByteArray)
	mFamilyInfo.memberCountInfo = nil
end

function SEND_HOME_ITEM_LIST(cs_ByteArray)
	-- print("SEND_HOME_ITEM_LIST")
	mGoods = {}
	mGoods[14] = {id=14,count=-1}
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count do
		local id = ByteArray.ReadInt(cs_ByteArray)
		local count = ByteArray.ReadInt(cs_ByteArray)
		mGoods[id] = {id=id,count=count}
	end
	mGoodsCount = count + 1
	-- print(mGoods)
end
function SEND_HOME_ITEM_COUNT(cs_ByteArray)
	-- print("SEND_HOME_ITEM_COUNT")
	if not mGoods then
		return
	end
	local id = ByteArray.ReadInt(cs_ByteArray)
	local count = ByteArray.ReadInt(cs_ByteArray)
	if count > 0 then
		if not mGoods[id] then
			mGoodsCount = mGoodsCount + 1
		end
		mGoods[id] = {id=id,count=count}
	else
		mGoods[id] = nil
		mGoodsCount = mGoodsCount - 1
	end
end

function SEND_CONTRIBUTE_CHG(cs_ByteArray)
	local contribute = ByteArray.ReadInt(cs_ByteArray)
	local todayContribute = ByteArray.ReadInt(cs_ByteArray)
	local hero = mHeroManager.GetHero()
	if hero and hero.contribute and hero.contribute > contribute then
		mHeroTip.ShowTip("联盟贡献消耗"..hero.contribute-contribute)
	elseif hero and hero.contribute and hero.contribute < contribute then
		mHeroTip.ShowTip("联盟贡献增加"..contribute-hero.contribute)
	end
	if hero then
		hero.contribute = contribute
		hero.todayContribute = todayContribute
	end
end

function SEND_HOME_MEMBER_ONLINE(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	
	if mMemberListById and mMemberListById[id] then
		mMemberListById[id].online = 0
		table.sort(mMemberList, sortFunc2)
	end
end

function SEND_HOME_LOG(cs_ByteArray)
	print("SEND_HOME_LOG")

	mLogs = ""
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count do
		mLogVersion = ByteArray.ReadInt(cs_ByteArray)
		local str = ByteArray.ReadUTF(cs_ByteArray)
		mLogs = mLogs .. os.date("%m-%d %X ", mLogVersion) .. str .. "\n"
	end
end

function sortFunc(a, b)
	if a.level == b.level then
		if a.memberCount > b.memberCount then
			return true
		end
	elseif a.level > b.level then
		return true
	end
	return false
end

function sortFunc2(a, b)
	if a.online == 0 and b.online ~= 0 then
		return true
	elseif a.online ~= 0 and b.online == 0 then
		return false
	elseif a.online ~= b.online then
		return a.online > b.online
	end
	
	if a.post > b.post then
		return true
	elseif a.post < b.post then
		return false
	end
	
	if a.level > b.level then
		return true
	elseif a.level < b.level then
		return false
	end
	
	if a.power > b.power then
		return true
	elseif a.power < b.power then
		return false
	end
	
	if a.contribute > b.contribute then
		return true
	elseif a.contribute < b.contribute then
		return false
	end
	
	return false
end

