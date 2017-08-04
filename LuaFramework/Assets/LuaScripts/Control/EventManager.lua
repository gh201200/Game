local _G,pairs,ErrorLog,xpcall,print,error,table,os = _G,pairs,ErrorLog,xpcall,print,error,table,os

module("LuaScript.Control.EventManager")
mEventListenList = {}
local mEvent = nil
local mStopEventList = {}
local mOperateList = {}

function SetEventListenValue(eventType, value)
	mStopEventList[eventType] = not value
	-- print(eventType, mStopEventList[eventType])
end

function AddEventListen(target, eventType, handlerFunc, param)
	if handlerFunc == nil then
		error("handlerFunc is nil")
	end
	
	target = target or _G
	param = param or true
	table.insert(mOperateList ,{target=target, eventType=eventType,handlerFunc=handlerFunc,param=param, 
		type="Add"})
	
	-- mEventListenList[target] =  mEventListenList[target] or {} 
	-- if not mEventListenList[target][eventType]  then
		-- mEventListenList[target][eventType] = {}
	-- end
	-- mEventListenList[target][eventType][handlerFunc] = param or true
	
	-- table.insert(mOperatePanelList ,{panelType=panelType, panel=panel, Operate="insert"})
end

function RemoveEventListen(target, eventType, handlerFunc)
	target = target or _G
	
	table.insert(mOperateList ,{target=target, eventType=eventType,handlerFunc=handlerFunc, 
		type="Remove"})
	
	-- if not mEventListenList[target] then
		-- return
	-- end
	-- if not mEventListenList[target][eventType]  then
		-- return
	-- end
	-- mEventListenList[target][eventType][handlerFunc] = nil
end

function RemoveAllEveListen(target)
	target = target or _G
	-- mEventListenList[target] = nil
	
	table.insert(mOperateList ,{target=target, type="RemoveAll"})
end

function OperateAddAnRomve()
	if not mOperateList[1] then
		return
	end
	for k,operate in pairs(mOperateList) do
		if operate.type == "Add" then
			mEventListenList[operate.target] =  mEventListenList[operate.target] or {} 
			if not mEventListenList[operate.target][operate.eventType]  then
				mEventListenList[operate.target][operate.eventType] = {}
			end
			mEventListenList[operate.target][operate.eventType][operate.handlerFunc] = operate.param
		elseif operate.type == "Remove" then
			if mEventListenList[operate.target] and mEventListenList[operate.target][operate.eventType] then
				mEventListenList[operate.target][operate.eventType][operate.handlerFunc] = nil
			end
			-- if not mEventListenList[target][eventType]  then
				-- return
			-- end
			-- mEventListenList[target][eventType][handlerFunc] = nil
		elseif operate.type == "RemoveAll" then
			mEventListenList[operate.target] = nil
		end
	end
	mOperateList = {}
end

_G.EventSecondTime = {}
_G.AppearEvent = function(target, eventType, param)
	-- print("AppearEvent", eventType)
	-- print(target, eventType, param)
	local now = 0
	if _G.IsDebug then
		now = os._clock()
	end
	
	
	OperateAddAnRomve()
	
	target = target or _G

	if mStopEventList[eventType] then
		return
	end
	if not mEventListenList[target] then
		-- print("r1")
		return
	end
	if not mEventListenList[target][eventType]  then
		-- print("r2")
		return
	end
	for k,v in pairs(mEventListenList[target][eventType]) do
		if param == nil then
			param = v
		end
		mEvent = {func=k, target=target, eventType=eventType, param=param}
		xpcall(RunHandler, ErrorLog)
		-- k(target, eventType, param)
	end
	
	if _G.IsDebug then
		local t = os.time()
		_G.EventSecondTime[t] = _G.EventSecondTime[t] or 0
		_G.EventSecondTime[t] = _G.EventSecondTime[t] + os._clock() - now
	end
end

function RunHandler()
	-- print(mEvent.func, mEvent.target, mEvent.eventType, mEvent.param)
	mEvent.func(mEvent.target, mEvent.eventType, mEvent.param)
end