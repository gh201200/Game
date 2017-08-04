
GUIStyle = {}
GUIStyle.Init = function()
	-- local cs_GUIStyle = nil
	-- for i=1,3 do
		-- cs_GUIStyle = CsCreateGUIStyle()
		-- if not CsIsNull(cs_GUIStyle) then
			-- break
		-- end
	-- end
	return UnityEngine.GUIStyle.New()
end