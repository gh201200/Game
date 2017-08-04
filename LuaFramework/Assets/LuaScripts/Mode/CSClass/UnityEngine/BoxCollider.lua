BoxCollider = {}
local CSBoxCollider = CsFindType("UnityEngine.BoxCollider")
BoxCollider.GetType = function()
	return UnityEngine.BoxCollider.GetClassType()
end