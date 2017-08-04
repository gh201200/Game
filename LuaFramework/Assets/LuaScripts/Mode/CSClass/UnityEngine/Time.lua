
Time = {}
local CSTime = CsFindType("UnityEngine.Time")
-- print(CSScreen:GetProperty("width"))

Time.GetFrameCount = function()
	return UnityEngine.Time.frameCount
end