GUIContent = {}
GUIContent.Init = function(str)
	-- local cs_Args = NewObjectArr(str)
	-- local cs_GUIContent = cs_Base:InitClass("UnityEngine.GUIContent", cs_Args)
	return UnityEngine.GUIContent.New(str)
end

GUIContent.example = GUIContent.Init("11")