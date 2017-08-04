
Resources = {}

Resources.Load = function(path)
	-- local now = os.clock()
	local asset = CsLoad(path)
	-- StaticFuncCostList["Load"] = StaticFuncCostList["Load"] or 0
	-- StaticFuncCostList["Load"] = StaticFuncCostList["Load"] + os.clock() - now
	return asset
end

Resources.UnloadUnusedAssets = function()
	return RunStaticFunc("UnityEngine.Resources", "UnloadUnusedAssets")
end

Resources.UnloadAsset = function(asset)
	CsUnloadAsset(asset)
	-- return RunStaticFunc("UnityEngine.Resources", "UnloadAsset", asset)
end