local EventManager = class("Common.EventManager")

function EventManager:ctor(...)
	self.EventList = {}
	self.StopList = {}
	self.stopAll = false
end

function EventManager:Add(et, callback)
	if not self.EventList[et] then
		self.EventList[et] = {}
	end
	local canInsert = true
	for _, v in pairs(self.EventList[et]) do
		if v == callback then
			canInsert = false
			break
		end
	end
	if canInsert then
		table.insert(self.EventList[et], callback)
	end
end

function EventManager:Remove(et, callback)
	if not self.EventList[et] or table.size(self.EventList[et]) == 0 then return end
	if callback then
		for k, v in pairs(self.EventList[et]) do
			if v == callback then
				self.EventList[et][k] = nil
			end
		end
	else
		self.EventList[et] = {}
	end
end

function EventManager:Dispatch(et, ...)
	if self.stopAll or self.StopList[et] then return end
	if not self.EventList[et] then
		print("EventType: " .. et .. " has no listener!")
		return
	end
	for _, v in pairs(self.EventList[et]) do
		v(...)
	end
end

function EventManager:Stop(et)
	self.StopList[et] = true
end

function EventManager:Resume(et)
	self.StopList[et] = nil
end

function EventManager:Clear()
	self.EventList = {}
	self.StopList = {}
	self.stopAll = false
end

return EventManager.new()
