
Rect = {}
Rect.Init = function(x, y, width, height)
	-- local cs_Args = NewObjectArr(x,y,width,height)
	-- local cs_ConvertFuncs = NewObjectArr("System.Convert", "ToSingle", 
								-- "System.Convert", "ToSingle",
								-- "System.Convert", "ToSingle",
								-- "System.Convert", "ToSingle")
	-- local cs_Rect = cs_Base:InitClass("UnityEngine.Rect", cs_Args, cs_ConvertFuncs)
	return UnityEngine.Rect.New(x, y, width, height)
end


Rect.example = Rect.Init(1, 2, 3, 4)
