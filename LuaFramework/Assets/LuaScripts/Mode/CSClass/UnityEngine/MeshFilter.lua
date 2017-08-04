
MeshFilter = {}
local CSMeshFilter = CsFindType("UnityEngine.MeshFilter")
MeshFilter.GetType = function()
	return UnityEngine.MeshFilter.GetClassType()
end