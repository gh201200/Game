Event = {}
local CSEvent = CsFindType("UnityEngine.Event")
Event.GetCurrent = function()
	return UnityEngine.Event.current
end