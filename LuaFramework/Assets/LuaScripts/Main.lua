import "System"
import "UnityEngine"

require "common.common"
require "common.globaldefine"
local mCheckUpdate = require "common.checkupdate"
-- local Stopwatch = require "common.stopwatch"

-- Stopwatch:Start()

-- AssetLoader.Instance:Load("prefabs/Canvas.prefab", AssetType.Prefab, function(obj)
	-- local go = GameObject.Instantiate(obj)
	-- print(go.name, Stopwatch:Stop())
-- end)

-- print(Application.persistentDataPath)

mCheckUpdate:Check(function()
	print("update complete!")
end)