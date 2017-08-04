local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Item,platform,IPhonePlayer = 
print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Item,platform,IPhonePlayer
local PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent = 
PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent
local CFG_ship,CFG_harbor,AudioData,GiftType,CFG_item,Color,VersionCode,IosTestScript = 
CFG_ship,CFG_harbor,AudioData,GiftType,CFG_item,Color,VersionCode,IosTestScript
local mAssetManager = nil
local mEventManager = nil
local mNetManager = nil
local mShipManager = nil
local mTaskManager = nil
local mHeroManager = nil
local mGuideManager = nil
local mAudioManager = nil
local mCommonlyFunc = nil
local mSystemTip = nil
local mActivityManager = nil
module("LuaScript.Control.Data.GiftListManager")

local mGiftList = nil
local mFreezeGiftList = nil

function GetGiftList()
	return mGiftList
end

function Refresh()
	-- print("Refresh")
	-- local activeList = {}
	-- local update = false
	if mFreezeGiftList then
		local serverTime = mActivityManager.GetServerTime()
		if not serverTime then
			return
		end
		local count = #mFreezeGiftList
		for i=count,1,-1 do
			local gift = mFreezeGiftList[i]
			if gift.starTime < serverTime then
				-- print(gift)
				table.insert(mGiftList, 1, gift)
				table.remove(mFreezeGiftList, i)
				-- update = true
			end
		end
		if count == 0 then
			mFreezeGiftList = nil
		end
	end
	
	-- if update then
		-- mActivityManager.UpdateActivity()
	-- end
end

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mShipManager = require "LuaScript.Control.Data.ShipManager"
	mTaskManager = require "LuaScript.Control.Data.TaskManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mGuideManager = require "LuaScript.Control.Data.GuideManager"
	mAudioManager = require "LuaScript.Control.System.AudioManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	
	mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_ALL_GIFTS, SEND_ALL_GIFTS)
	mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_ADD_GIFTS, SEND_ADD_GIFTS)
	mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_DEL_GIFTS, SEND_DEL_GIFTS)
	mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_GIFTS_CHG, SEND_GIFTS_CHG)
end

function SEND_ALL_GIFTS(cs_ByteArray)
	-- print("SEND_ALL_GIFTS!!!!!!!!!!!!!!!!!!!")
	--ios test script
	if IosTestScript then
		mGiftList = {}
	else
		mGiftList = {
			-- {itemId = 309,str="集齐<color=lime>9朵玫瑰</color>\n可兑换",type=-2,btnName="兑换",starTime=0},
			{itemId = 71,str="输入礼包序列号\n领取各类礼包",type=-1,btnName="兑换",starTime=0}}
	end
	mFreezeGiftList = {}
	
	-- local serverTime = mActivityManager.GetServerTime()
	-- print(serverTime)
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count,1 do
		local item = {}
		item.id = ByteArray.ReadInt(cs_ByteArray)
		item.itemId = ByteArray.ReadInt(cs_ByteArray)
		
		local endTime = ByteArray.ReadInt(cs_ByteArray)
		local type = ByteArray.ReadByte(cs_ByteArray)
		-- print(type)
		local starTime = ByteArray.ReadInt(cs_ByteArray)
		local str = (GiftType[type] or "未知")..mCommonlyFunc.GetGiftTime(endTime)
		item.str = str
		item.starTime = starTime
		item.type = type
		
		table.insert(mFreezeGiftList, item)
	end
end


function SEND_ADD_GIFTS(cs_ByteArray)
	-- print("SEND_ADD_GIFTS")
	if not mGiftList then
		return
	end
	
	local item = {}
	item.id = ByteArray.ReadInt(cs_ByteArray)
	item.itemId = ByteArray.ReadInt(cs_ByteArray)
	
	local endTime = ByteArray.ReadInt(cs_ByteArray)
	local type = ByteArray.ReadByte(cs_ByteArray)
	local starTime = ByteArray.ReadInt(cs_ByteArray)
	-- print(type)
	local str = (GiftType[type] or "未知")..mCommonlyFunc.GetGiftTime(endTime)
	item.str = str
	item.starTime = starTime
	item.type = type
	
	for k,v in pairs(mGiftList) do
		if v.id == item.id then
			table.remove(mGiftList, k)
			break
		end
	end
	
	table.insert(mGiftList, 1, item)
	
	local hero = mHeroManager.GetHero()
	if hero and hero.level >= 10 then
		local cfg_item = CFG_item[item.itemId]
		local info = "你有未领取的"
		info = info .. cfg_item.name
		info = info .. ",在"
		info = info .. mCommonlyFunc.BeginColor(Color.CyanStr)
		info = info .. "活动·礼包列表"
		info = info .. mCommonlyFunc.EndColor()
		info = info .. "处领取"
		mSystemTip.ShowTip(info, Color.LimeStr)
	end
	Refresh()
	
	mActivityManager.UpdateActivity()
end


function SEND_DEL_GIFTS(cs_ByteArray)
	-- print("SEND_DEL_GIFTS")
	local id = ByteArray.ReadInt(cs_ByteArray)
	for k,v in pairs(mGiftList) do
		if v.id == id then
			table.remove(mGiftList, k)
			break
		end
	end
	
	mActivityManager.UpdateActivity()
end

function SEND_GIFTS_CHG(cs_ByteArray)
	-- print("SEND_GIFTS_CHG")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local itemId = ByteArray.ReadInt(cs_ByteArray)
	for k,v in pairs(mGiftList) do
		if v.id == id then
			v.itemId = itemId
			break
		end
	end
end

function RequesGetGift(id)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.ITEM)
	ByteArray.WriteByte(cs_ByteArray,Packat_Item.CLIENT_REQUEST_GET_GIFTS)
	ByteArray.WriteInt(cs_ByteArray, id)
	mNetManager.SendData(cs_ByteArray)
end

function RequesExchange(id)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.ITEM)
	ByteArray.WriteByte(cs_ByteArray,Packat_Item.CLIENT_REQUEST_EXCHANGE_ITEM)
	ByteArray.WriteInt(cs_ByteArray, id)
	mNetManager.SendData(cs_ByteArray)
end