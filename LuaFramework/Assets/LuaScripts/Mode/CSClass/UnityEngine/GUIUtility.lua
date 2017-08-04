GUIUtility = {}
local CSInput = CsFindType("UnityEngine.GUIUtility")
GUIUtility.RotateAroundPivot = function(angle, pivotPoint)
	-- local now = os.clock()
	
	-- if GUIUtility.xxx and not GUIUtility.xxx2 then
		-- local str = "RotateAroundPivot error !!!\n"
		-- str = str .. tostring(GUIUtility.xxxTable[1]) .. "\n"
		-- str = str .. tostring(GUIUtility.xxxTable[2]) .. "\n"
		-- str = str .. debug.traceback() .. "\n"
		-- UploadError(str)
		-- GUIUtility.xxx2 = true
	-- end
	-- GUIUtility.xxxTable = {angle, pivotPoint}
	
	-- GUIUtility.xxx = true
	-- GUI.CSRotateAroundPivot(angle, pivotPoint)
	-- GUIUtility.xxx = false
	
	UnityEngine.GUIUtility.RotateAroundPivot(angle, pivotPoint)
	-- StaticFuncCostList = StaticFuncCostList or {}
	-- StaticFuncCostList["RotateAroundPivot"] = StaticFuncCostList["RotateAroundPivot"] or 0
	-- StaticFuncCostList["RotateAroundPivot"] = StaticFuncCostList["RotateAroundPivot"] + os.clock() - now
end

GUIUtility.ScaleAroundPivot  = function(scale, pivotPoint)
	return RunStaticFunc("UnityEngine.GUIUtility", "ScaleAroundPivot", scale, pivotPoint)
end