local _G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,require,Directory,os,EventType,Application,platform = 
_G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,require,Directory,os,EventType,Application,platform
local Packat_Rank,PackatHead,ByteArray,Packat_CopyMap = Packat_Rank,PackatHead,ByteArray,Packat_CopyMap
local mActivityManager = nil
local mSetManager = nil
local mEventManager = nil
local mSDK = nil
local mAlert = nil
local mCommonlyFunc = nil
local mNetManager = nil
local mLoginPanel = nil
local mPromptAlert = nil
local mBattleStarPanel = nil
local mPanelManager = nil

module("LuaScript.Control.Data.PassManager")
local mData = nil

function Init()
	mEventManager = require "LuaScript.Control.EventManager"
	mSDK = require "LuaScript.Mode.Object.SDK"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	mBattleStarPanel = require "LuaScript.View.Panel.Battle.BattleStarPanel"
	mPanelManager = require "LuaScript.Control.PanelManager"
	
	mNetManager.AddListen(PackatHead.COPYMAP, Packat_CopyMap.SEND_TOWER_INFO, SEND_TOWER_INFO)
	mNetManager.AddListen(PackatHead.COPYMAP, Packat_CopyMap.SEND_TOWER_PASS_RLT, SEND_TOWER_PASS_RLT)
	mNetManager.AddListen(PackatHead.COPYMAP, Packat_CopyMap.SEND_TOWER_CHOOSE_BUFF, SEND_TOWER_CHOOSE_BUFF)
end

function GetData()
	return mData
end

function RequestBattle(id, type)
	-- print("RequestBattle")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.COPYMAP)
	ByteArray.WriteByte(cs_ByteArray,Packat_CopyMap.CLIENT_REQUEST_ENTER_TOWER)
	ByteArray.WriteInt(cs_ByteArray,id)
	ByteArray.WriteByte(cs_ByteArray,type)
	mNetManager.SendData(cs_ByteArray)
end

function RequestFastBattle(id, type)
	-- print("RequestFastBattle")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.COPYMAP)
	ByteArray.WriteByte(cs_ByteArray,Packat_CopyMap.CLIENT_FAST_FINISH_TOWER)
	ByteArray.WriteInt(cs_ByteArray,id)
	ByteArray.WriteByte(cs_ByteArray,type)
	mNetManager.SendData(cs_ByteArray)
end

function RequestSelectBuff(id, type)
	-- print("RequestSelectBuff")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.COPYMAP)
	ByteArray.WriteByte(cs_ByteArray,Packat_CopyMap.CLIENT_CHOOSE_TOWER_BUFF)
	ByteArray.WriteInt(cs_ByteArray,id)
	mNetManager.SendData(cs_ByteArray)
end

function SEND_TOWER_INFO(cs_ByteArray)
	-- print("SEND_TOWER_INFO")
	mData = {}
	mData.type = 0
	mData.curTower = ByteArray.ReadInt(cs_ByteArray)
	mData.curStar1 = ByteArray.ReadByte(cs_ByteArray)
	mData.curStar2 = ByteArray.ReadByte(cs_ByteArray)
	mData.curStar3 = ByteArray.ReadByte(cs_ByteArray)
	mData.coolTime = ByteArray.ReadInt(cs_ByteArray)
	mData.totalStar = ByteArray.ReadInt(cs_ByteArray)
	mData.leftStar = ByteArray.ReadInt(cs_ByteArray)
	
	mData.totalAtt = ByteArray.ReadInt(cs_ByteArray)
	mData.totalDef = ByteArray.ReadInt(cs_ByteArray)
	mData.totalHp = ByteArray.ReadInt(cs_ByteArray)
	
	mData.buffId1 = ByteArray.ReadInt(cs_ByteArray)
	mData.buffId2 = ByteArray.ReadInt(cs_ByteArray)
	mData.buffId3 = ByteArray.ReadInt(cs_ByteArray)
	
	mData.updateTime = os.oldTime
	
	if mData.coolTime > 0 then
		mData.coolTime = mData.coolTime + 1
	end
	
	if mData.buffId1 ~= 0 then
		mData.type = 1
	end
	-- print(mData)
end

function SEND_TOWER_PASS_RLT(cs_ByteArray)
	-- print("SEND_TOWER_PASS_RLT")
	local star = ByteArray.ReadByte(cs_ByteArray)
	local type = ByteArray.ReadByte(cs_ByteArray)
	
	mBattleStarPanel.SetData(star, type)
	mPanelManager.Show(mBattleStarPanel)
end

function SEND_TOWER_CHOOSE_BUFF(cs_ByteArray)
	-- print("SEND_TOWER_CHOOSE_BUFF")
	mData.type = 1
	mData.buffId1 = ByteArray.ReadInt(cs_ByteArray)
	mData.buffId2 = ByteArray.ReadInt(cs_ByteArray)
	mData.buffId3 = ByteArray.ReadInt(cs_ByteArray)
	-- print(mData)
end

