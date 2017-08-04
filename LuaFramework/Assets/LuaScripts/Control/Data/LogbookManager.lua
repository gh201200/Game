local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Chat,ConstValue,Color = 
print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Chat,ConstValue,Color
local PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent = 
PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent
local CFG_harbor,CFG_ship,CFG_lab,CFG_buildDesc = CFG_harbor,CFG_ship,CFG_lab,CFG_buildDesc
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mNetManager = nil
local mHeroManager = nil
local mSystemTipPanel = nil
local mEventManager = nil
local mRelationManager = nil

module("LuaScript.Control.Data.LogbookManager")
local mLogList = {}

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
end

function GetLogList()
	return mLogList 
end

function AddLog(type, time, ...)
	-- local mlog = {}
	-- mlog.type = type
	-- mlog.time = time
	-- mlog.arg = {...}
	
	-- InitLogInfo(mlog)
	-- if mLogList[40] then
		-- table.remove(mLogList, 1)
	-- end
	-- table.insert(mLogList, mlog)
end


function InitLogInfo(mLog)
	-- print(mLog.arg)
	local logStr = mCommonlyFunc.BeginColor(Color.BlackStr)
	logStr = logStr .. os.date("%x %X", mLog.time)
	logStr = logStr .. mCommonlyFunc.Linefeed()
	logStr = logStr .. ConstValue.LogType[mLog.type]
	if mLog.type == 1 then
		logStr = logStr .. "舰队"
		logStr = logStr .. mLog.arg[1]
		logStr = logStr .. "贸易获得"
		logStr = logStr .. mCommonlyFunc.BeginColor(Color.CyanStr)
		logStr = logStr .. mLog.arg[2]
		logStr = logStr .. mCommonlyFunc.EndColor()
	elseif mLog.type == 2 then
		if mLog.arg[1] then
			logStr = logStr .. "你成功加入"
			logStr = logStr .. mCommonlyFunc.BeginColor(Color.CyanStr)
			logStr = logStr .. mLog.arg[2]
			logStr = logStr .. mCommonlyFunc.EndColor()
			logStr = logStr .. "联盟"
		else
			logStr = logStr .. "你已离开"
			logStr = logStr .. mCommonlyFunc.BeginColor(Color.CyanStr)
			logStr = logStr .. mLog.arg[2]
			logStr = logStr .. mCommonlyFunc.EndColor()
			logStr = logStr .. "联盟"
		end
	elseif mLog.type == 3 then
		if mLog.arg[1] then
			logStr = logStr .. "舰队"
			logStr = logStr .. mLog.arg[2] 
			logStr = logStr .. "战胜"
			logStr = logStr .. mCommonlyFunc.BeginColor(Color.RedStr)
			logStr = logStr .. mLog.arg[3] 
			logStr = logStr .. mCommonlyFunc.EndColor()
		else
			logStr = logStr .. "舰队"
			logStr = logStr .. mLog.arg[2]
			logStr = logStr .. "被"
			logStr = logStr .. mCommonlyFunc.BeginColor(Color.RedStr)
			logStr = logStr .. mLog.arg[3] 
			logStr = logStr .. mCommonlyFunc.EndColor()
			logStr = logStr .. "击败，损失"
			logStr = logStr .. mCommonlyFunc.BeginColor(Color.RedStr)
			logStr = logStr .. -mLog.arg[4] 
			logStr = logStr .. mCommonlyFunc.EndColor()
		end
	elseif mLog.type == 4 then
		local cfg_harbor = CFG_harbor[mLog.arg[1]]
		local cfg_ship = CFG_ship[mLog.arg[2]]
		-- logStr = logStr .. ""
		logStr = logStr .. cfg_harbor.name
		logStr = logStr .. "港口处的"
		logStr = logStr .. mCommonlyFunc.BeginColor(Color.CyanStr)
		logStr = logStr .. cfg_ship.name
		logStr = logStr .. mCommonlyFunc.EndColor()
		logStr = logStr .. "建造完毕"
	elseif mLog.type == 5 then
		local cfg_harbor = CFG_harbor[mLog.arg[1]]
		local cfg_lab = CFG_lab[mLog.arg[2].."_1"]
		-- logStr = logStr .. ""
		logStr = logStr .. cfg_harbor.name
		logStr = logStr .. "港口处的"
		logStr = logStr .. mCommonlyFunc.BeginColor(Color.CyanStr)
		logStr = logStr .. cfg_lab.name
		logStr = logStr .. mCommonlyFunc.EndColor()
		logStr = logStr .. "研究至"
		logStr = logStr .. mLog.arg[3]
		logStr = logStr .. "级"
	elseif mLog.type == 6 then
		local cfg_harbor = CFG_harbor[mLog.arg[1]]
		local cfg_buildDesc = CFG_buildDesc[mLog.arg[2]]
		-- logStr = logStr .. ""
		logStr = logStr .. cfg_harbor.name
		logStr = logStr .. "港口处的"
		logStr = logStr .. mCommonlyFunc.BeginColor(Color.CyanStr)
		logStr = logStr .. cfg_buildDesc.name
		logStr = logStr .. mCommonlyFunc.EndColor()
		logStr = logStr .. "升级至"
		logStr = logStr .. mLog.arg[3]
		logStr = logStr .. "级"
	elseif mLog.type == 7 then
		local cfg_harbor = CFG_harbor[mLog.arg[1]]
		logStr = logStr .. "港口"
		logStr = logStr .. cfg_harbor.name
		logStr = logStr .. "收获"
		logStr = logStr .. mCommonlyFunc.BeginColor(Color.CyanStr)
		logStr = logStr .. mLog.arg[2]
		logStr = logStr .. mCommonlyFunc.EndColor()
	elseif mLog.type == 8 then
		local color = ConstValue.QualityColorStr[mLog.arg[1]]
		logStr = logStr .. "成功招募到"
		logStr = logStr .. mCommonlyFunc.BeginColor(color)
		logStr = logStr .. ConstValue.Quality[mLog.arg[1]]
		logStr = logStr .. mCommonlyFunc.EndColor()
		logStr = logStr .. "品质的船员\""
		logStr = logStr .. mLog.arg[2]
		logStr = logStr .. "\""
	end
	logStr = logStr ..mCommonlyFunc.EndColor()
	mLog.info = logStr
	-- print(logStr)
	return logStr
end