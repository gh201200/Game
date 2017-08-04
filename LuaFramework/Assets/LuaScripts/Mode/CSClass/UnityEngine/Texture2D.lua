Texture2D = {}
Texture2D.Init = function(width, height)
	-- local cs_Args = NewObjectArr(width,height)
	-- local cs_ConvertFuncs = NewObjectArr("System.Convert", "ToInt32", 
								-- "System.Convert", "ToInt32")
	-- local cs_Texture2D = cs_Base:InitClass("UnityEngine.Texture2D", cs_Args, cs_ConvertFuncs)
	return UnityEngine.Texture2D.New(width, height)
end

Texture2D._lockList = {}
-- Texture2D.Draw = function(cs_Source, sourcePoint, cs_Dest)
	-- return RunStaticFunc("HHTexture", "Draw", cs_Source, sourcePoint, cs_Dest)

	-- local cs_SourceColors = Texture2D._lockList[cs_Source]
	-- local isLuck = true
	-- if not cs_SourceColors then
		-- isLuck = false
		-- cs_SourceColors = cs_Source:GetPixels32()
	-- end
	-- local cs_DestColors = cs_Dest:GetPixels32()
	
	-- local sourceWidth = cs_Source.width
	-- local sourceHeight = cs_Source.height
	-- local destWidth = cs_Dest.width
	-- local destHeight = cs_Dest.height
	
	-- sourcePoint.y = cs_Source.height - cs_Dest.height - sourcePoint.y
	-- local offIndex = sourcePoint.x + sourcePoint.y * sourceWidth
	-- local info = ""
	-- local destEndIndex = cs_DestColors.Length-1
	-- local info2 = ""
	-- for i=0,destEndIndex,1 do
		-- local dest_x = i%destWidth
		-- local dest_y = math.floor(i/destWidth)
		-- local source_x = dest_x + sourcePoint.x
		-- local source_y = dest_y + sourcePoint.y
		-- if  i > 10000 and #info2 < 200 then
			-- info2 = info2 .. source_x .. "\t" .. source_y .. "\t" .. sourceWidth .. "\t" .. sourceHeight .. "\n" 
		-- end
		-- if source_x < sourceWidth and source_y < sourceHeight 
			-- and source_x >= 0 and source_y >= 0 then
			-- local cs_Color = cs_DestColors:GetValue(i)
			-- local destIndex = offIndex + dest_x + dest_y * sourceWidth
			-- cs_SourceColors:SetValue(cs_Color, destIndex)
			-- if i > 10000 and #info < 200 then
				-- info = info .. dest_x .. " " .. dest_y .. " to " .. source_x .. " " .. source_y .. "\n"
				-- info = info .."index".. i .. " to " .. destIndex .. "\n"
			-- end
		-- end
	-- end
	-- if not isLuck then
		-- cs_Source:SetPixels32(cs_SourceColors)
		-- cs_Source:Apply()
	-- end
-- end

-- Texture2D.Lock = function(cs_Texture)
	-- return RunStaticFunc("HHTexture", "Luck", cs_Texture)
	-- Texture2D._lockList[cs_Texture] = cs_Texture:GetPixels32()
-- end

-- Texture2D.UnLock = function(cs_Texture)
	-- return RunStaticFunc("HHTexture", "UnLuck", cs_Texture)
	-- local cs_colors = Texture2D._lockList[cs_Texture]
	-- Texture2D._lockList[cs_Texture] = nil
	-- cs_Texture:SetPixels32(cs_colors)
	-- cs_Texture:Apply()
-- end