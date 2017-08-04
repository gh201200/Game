local error,type,os,xpcall,ErrorLog,pairs,table,print = error,type,os,xpcall,ErrorLog,pairs,table,print
module("LuaScript.Common.Timer")

newTimerList = {}
removeTimerList = {}

timerList = {}
timer = nil

function SetTimeout(func, delayTime, arg)
	-- if type(func) ~= "function" then
		-- error("func is not function")
	-- end
	-- if type(delayTime) ~= "number" then
		-- error("delayTime is not number")
	-- end
	-- local arg = {...}
	local timer = {overTime = (os.oldClock or os.clock())+delayTime, func = func, arg = arg, dispose = true}
	newTimerList[timer] = 1
	return timer
end

function SetInterval(func, delayTime, arg)
	-- if type(func) ~= "function" then
		-- error("func is not function")
	-- end
	-- if type(delayTime) ~= "number" then
		-- error("delayTime is not number")
	-- end
	-- local arg = {...}
	local timer = {overTime = (os.oldClock or os.clock())+delayTime, func = func, arg = arg, dispose = false, delay = delayTime}
	newTimerList[timer] = 1
	return timer
end

function RemoveTimer(timer)
	-- print("?????")
	if not timer then
		return
	end
	removeTimerList[timer] = 1
end

function Update()
	local now = os.oldClock
	-- print(timerList)
	-- local c = 0
	for v,_ in pairs(timerList) do
		-- c = c + 1
		-- print(c)
		if not removeTimerList[v] and now > v.overTime then
			if v.dispose then
				removeTimerList[v] = 1
			else
				now = os.clock()
				v.overTime = now + v.delay
			end
			timer = v
			xpcall(RunTimer, ErrorLog)
			timer = nil
		end
	end
	
	for v,_ in pairs(newTimerList) do
		timerList[v] = 1
		newTimerList[v] = nil
	end
	
	for v,_ in pairs(removeTimerList) do
		timerList[v] = nil
		removeTimerList[v] = nil
	end
	-- removeTimerList = {}
end

function RunTimer()
	if timer.arg then
		timer.func(timer.arg)
	else
		timer.func()
	end
end









