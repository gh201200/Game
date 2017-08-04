
Transform = {}
local CSTransform = CsFindType("UnityEngine.Transform")
Transform.GetType = function()
	return UnityEngine.Transform.GetClassType()
end