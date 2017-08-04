
RaycastHit = {}
RaycastHit.Init = function()
	-- local cs_RaycastHit = cs_Base:InitClass("UnityEngine.RaycastHit")
	return UnityEngine.RaycastHit.New()
end

Rect.example = RaycastHit.Init()