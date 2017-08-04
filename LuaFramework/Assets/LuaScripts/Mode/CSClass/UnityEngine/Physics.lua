Physics = {}
local CSPhysics = CsFindType("HHPhysics")
Physics.Raycast = function(csRay)
	if CsRaycast2 then
		local x,y,z = CsRaycast2(csRay)
		if x and y and z then
			return {x=x,y=y,z=z}
		end
	else
		return CsRaycast(csRay)
	end
end