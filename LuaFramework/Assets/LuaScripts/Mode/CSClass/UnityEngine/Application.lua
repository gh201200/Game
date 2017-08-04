Application = {}

import("UnityEngine.Application")
Application.Quit = function()
	UnityEngine.Application.Quit()
end

Application.SetTargetFrameRate = function(value)
	UnityEngine.Application.targetFrameRate = value
end

Application.OpenUrl = function(url)
	UnityEngine.Application.OpenURL(url)
end