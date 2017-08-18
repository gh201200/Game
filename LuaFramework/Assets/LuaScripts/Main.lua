import "System"
import "UnityEngine"

require "common.common"
require "common.globaldefine"
local Stopwatch = require "common.stopwatch"

-- Stopwatch:Start()

-- AssetLoader.Instance:Load("prefabs/Canvas.prefab", AssetType.Prefab, function(obj)
	-- local go = GameObject.Instantiate(obj)
	-- print(go.name, Stopwatch:Stop())
-- end)

Stopwatch:Start()

local str = "hiding from the rain and snow , trying to forget but i ..."
print(string.split(str))

print(Stopwatch:Stop())