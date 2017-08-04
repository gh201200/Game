Animation = {}
local CSAnimation = CsFindType("UnityEngine.Animation")
Animation.GetType = function()
	return UnityEngine.Animation.GetClassType()
end