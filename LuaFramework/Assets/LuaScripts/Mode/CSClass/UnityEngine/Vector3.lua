Vector3 = {}

Vector3.Init = function(x, y, z)
	-- local cs_Args = NewObjectArr(x,y,z)
	-- local cs_ConvertFuncs = NewObjectArr("System.Convert", "ToSingle", 
								-- "System.Convert", "ToSingle",
								-- "System.Convert", "ToSingle")
	-- local cs_Vector3 = cs_Base:InitClass("UnityEngine.Vector3", cs_Args, cs_ConvertFuncs)
	return UnityEngine.Vector3.New()
end

Vector3.GetType = function()
	-- local CSVector3 = CsFindType("UnityEngine.Vector3")
	return UnityEngine.Vector3.GetClassType()
end

Vector3.up = Vector3.Init(0, 1, 0)
Vector3.down = Vector3.Init(0, -1, 0)
Vector3.example  = Vector3.Init(6, 4, 0)