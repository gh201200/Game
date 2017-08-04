
Input = {}
local CSInput = CsFindType("UnityEngine.Input")
Input.GetMousePosition = function()
	return CsGetMousePosition()
end

Input.GetKeyDown = function(key)
	-- if VersionCode < 8 then
		-- return CsGetKeyDown(key) and
			-- CsCurrentEventEqualsType(UnityEventType.Layout) 
	-- else
		return CsGetKeyDown(key) and
			CsCurrentEventEqualsType(UnityEventType.KeyDown) 
	-- end
end

Input.GetKeyUp = function(key)
	return RunStaticFunc("UnityEngine.Input", "GetKeyUp", key) and
		CsCurrentEventEqualsType(UnityEventType.Layout) 
end

Input.GetMouseButton = function(key)
	return RunStaticFunc("UnityEngine.Input", "GetMouseButton", key) and
		CsCurrentEventEqualsType(UnityEventType.MouseDown) 
end

Input.GetMouseButtonDown = function(key)
	return RunStaticFunc("UnityEngine.Input", "GetMouseButtonDown", key) and
		CsCurrentEventEqualsType(UnityEventType.MouseDown) 
end

Input.GetMouseButtonUp = function(key)
	return RunStaticFunc("UnityEngine.Input", "GetMouseButtonUp", key) and
		CsCurrentEventEqualsType(UnityEventType.MouseUp) 
end

Input.GetTouchCount = function()
	-- return CSInput:GetProperty("touchCount"):GetValue(nil, nil)
	return CsGetTouchCount()
end

Input.GetTouchs = function()
	-- return CSInput:GetProperty("touches"):GetValue(nil, nil)
	return CsGetTouchs()
end

Input.GetTouch = function(index)
	-- return CSInput:GetProperty("touches"):GetValue(nil, nil)
	return CsGetTouch(index)
end