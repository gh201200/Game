
Screen = {}
local CSScreen = CsFindType("UnityEngine.Screen")
-- print(UnityEngine.Screen.width"))
Screen.width = UnityEngine.Screen.width
Screen.height = UnityEngine.Screen.height
Screen.DefaultWidth = 1136
Screen.DefaultHeight = 640

Screen.SetResolution = function(width, height, fullscreen)
	-- print("Screen.SetResolution")
	Screen.width = width
	Screen.height = height
	return RunStaticFunc("UnityEngine.Screen", "SetResolution", width, height, fullscreen)
end

Screen.SetSleepTimeout  = function(sleepTimeout)
	-- local ScreenType = luanet.import_type("UnityEngine.Screen")
	UnityEngine.Screen.sleepTimeout = sleepTimeout
end


Screen.currentResolution = UnityEngine.Screen.currentResolution

-- Screen.SetResolution(200,600, false)