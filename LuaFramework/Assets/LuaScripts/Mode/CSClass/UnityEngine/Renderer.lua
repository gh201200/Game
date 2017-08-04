
Renderer = {}
local CSRenderer = CsFindType("UnityEngine.Renderer")
Renderer.GetType = function()
	return UnityEngine.Renderer.GetClassType()
end