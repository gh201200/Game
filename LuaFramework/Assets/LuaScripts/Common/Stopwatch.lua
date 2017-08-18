local Stopwatch = class("Stopwatch")

function Stopwatch:ctor()
	print("Stopwatch ctor")
	self.sw = Diagnostics.Stopwatch()
end

function Stopwatch:Start()
	self.sw:Reset()
	self.sw:Start()
end

function Stopwatch:Stop()
	self.sw:Stop()
	return self.sw.ElapsedMilliseconds .. "ms"
end

return Stopwatch:new()
