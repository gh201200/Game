Vector2 = {}

Vector2.Init = function(x, y)
	-- local cs_Args = NewObjectArr(x,y)
	-- local cs_ConvertFuncs = NewObjectArr("System.Convert", "ToSingle", 
								-- "System.Convert", "ToSingle")
	-- local cs_Vector3 = cs_Base:InitClass("UnityEngine.Vector2", cs_Args, cs_ConvertFuncs)
	return UnityEngine.Vector2.New(x,y)
end

Vector2.GetType = function()
	-- local CSVector2 = CsFindType("UnityEngine.Vector2")
	return UnityEngine.Vector2.GetClassType()
end

Vector2.example  = Vector2.Init(99, 5)