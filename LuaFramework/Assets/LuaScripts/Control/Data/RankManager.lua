local _G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,require,Directory,os,EventType,Application,platform = 
_G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,require,Directory,os,EventType,Application,platform
local Packat_Rank,PackatHead,ByteArray = Packat_Rank,PackatHead,ByteArray
local mActivityManager = nil
local mSetManager = nil
local mEventManager = nil
local mSDK = nil
local mAlert = nil
local mCommonlyFunc = nil
local mNetManager = nil
local mLoginPanel = nil
local mPromptAlert = nil
module("LuaScript.Control.Data.RankManager")

local mRankList = {[0]={},[1]={},[2]={}}
local mSelfRank = {}
local mRequestList = {}
local mRefreshHour = nil

function CleanData()
	mRankList = {[0]={},[1]={},[2]={}}
	mRequestList = {}
end

function GetList(type)
	local serverTime = mActivityManager.GetServerTime()
	if refreshHour ~= os.date("%H",serverTime) then
		CleanData()
		refreshHour = os.date("%H",serverTime)
	end
	return mRankList[type]
end

function GetSelfData(type)
	return mSelfRank[type]
end

function Init()
	mEventManager = require "LuaScript.Control.EventManager"
	mSDK = require "LuaScript.Mode.Object.SDK"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	
	mNetManager.AddListen(PackatHead.RANK, Packat_Rank.SEND_RANK_LIST, SEND_RANK_LIST)
end

function RequestRankData(type, page)
	local key = type * 100 + page
	if mRequestList[key] then
		return
	end
	-- print("RequestRankData")
	mRequestList[key] = true
	
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.RANK)
	ByteArray.WriteByte(cs_ByteArray,Packat_Rank.CLIENT_REQUEST_RANK_PAGE)
	ByteArray.WriteByte(cs_ByteArray,type)
	ByteArray.WriteByte(cs_ByteArray,page)
	mNetManager.SendData(cs_ByteArray)
end

function SEND_RANK_LIST(cs_ByteArray)
	-- print("SEND_RANK_LIST")
	local type = ByteArray.ReadByte(cs_ByteArray)
	local page = ByteArray.ReadByte(cs_ByteArray)
	local selfRank = ByteArray.ReadInt(cs_ByteArray)
	local selfValue = ByteArray.ReadInt(cs_ByteArray)
	local refreshHour = ByteArray.ReadByte(cs_ByteArray)
	local count = ByteArray.ReadInt(cs_ByteArray)
	if mRefreshHour and mRefreshHour ~= refreshHour then
		CleanData()
		local key = type * 100 + page
		mRequestList[key] = true
	end
	mRefreshHour = refreshHour
	
	mSelfRank[type] = {rank=selfRank, value=selfValue}
	
	for i=1,count do
		local name = ByteArray.ReadUTF(cs_ByteArray, 40)
		local rank = ByteArray.ReadInt(cs_ByteArray)
		local value = ByteArray.ReadInt(cs_ByteArray)
		local exValue = ByteArray.ReadInt(cs_ByteArray)
		
		mRankList[type][rank] = {name=name,rank=rank,value=value,exValue=exValue,level=99}
	end
end
