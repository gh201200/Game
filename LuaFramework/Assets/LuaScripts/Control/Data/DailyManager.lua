local _G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,require,Directory,os,EventType,Application,platform,AppearEvent,Packat_DAILY,PackatHead = 
_G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,require,Directory,os,EventType,Application,platform,AppearEvent,Packat_DAILY,PackatHead
local ByteArray = ByteArray
local mSetManager = nil
local mEventManager = nil
local mSDK = nil
local mAlert = nil
local mCommonlyFunc = nil
local mNetManager = nil
local mLoginPanel = nil
local mPromptAlert = nil
local mActionManager = require "LuaScript.Control.ActionManager"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mChatManager = require "LuaScript.Control.Data.ChatManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mHotFixPanel = require "LuaScript.View.Panel.HotFixPanel"
local mBorderPanel = require "LuaScript.View.Panel.BorderPanel"
local mTaskManager = require "LuaScript.Control.Data.TaskManager"
local mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
local mBulletManager = require "LuaScript.Control.Scene.BulletManager"
local mBattleFieldManager = require "LuaScript.Control.Data.BattleFieldManager"
module("LuaScript.Control.Data.DailyManager")

local mDailyList = nil
local mDailyAwardList = nil


function Init()
	mSetManager = require "LuaScript.Control.System.SetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mSDK = require "LuaScript.Mode.Object.SDK"
	mAlert = require "LuaScript.View.Alert.Alert"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mLoginPanel = require "LuaScript.View.Panel.Login.LoginPanel"
	mPromptAlert = require "LuaScript.View.Alert.PromptAlert"
	
	mNetManager.AddListen(PackatHead.DAILY, Packat_DAILY.SEND_ALL_DAILY, SEND_ALL_DAILY)
	mNetManager.AddListen(PackatHead.DAILY, Packat_DAILY.SEND_ALL_DAILY_AWARD, SEND_ALL_DAILY_AWARD)

end


function SEND_ALL_DAILY(cs_ByteArray)
	-- print("SEND_ALL_DAILY")
	mDailyList = {}
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count do
		local dailyId = ByteArray.ReadInt(cs_ByteArray)
		local dailyCount = ByteArray.ReadInt(cs_ByteArray)
		mDailyList[dailyId] = dailyCount
	end
	-- print(mDailyList)
end

function SEND_ALL_DAILY_AWARD(cs_ByteArray)
	-- print("SEND_ALL_DAILY_AWARD")
	mDailyAwardList = {}
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count do
		local dailyAwardId = ByteArray.ReadInt(cs_ByteArray)
		mDailyAwardList[dailyAwardId] = true
	end
	-- print(mDailyAwardList)
end

function RequestGetAward(awardId)
	-- print("RequestGetAward")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.DAILY)
	ByteArray.WriteByte(cs_ByteArray,Packat_DAILY.CLIENT_REQUEST_GET_AWARD)
	ByteArray.WriteInt(cs_ByteArray,awardId)
	mNetManager.SendData(cs_ByteArray)
	
end

function GetDailyList()
	return mDailyList
end

function GetDailyAwardList()
	return mDailyAwardList
end