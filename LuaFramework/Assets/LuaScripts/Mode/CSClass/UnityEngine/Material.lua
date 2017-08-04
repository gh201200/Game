
Material = {}
local CSMaterial = CsFindType("UnityEngine.Material")
Material.GetType = function()
	return UnityEngine.Material.GetClassType()
end