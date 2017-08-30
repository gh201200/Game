import "System"
import "UnityEngine"

local Main = { }

require "common.common"
require "common.globaldefine"
local mCheckUpdate = require "common.checkupdate"
local mStopwatch = require "common.stopwatch"
local mEventManager = require "Common.EventManager"
-- local mGameInfo = require "common.gameinfo".new(Main)

-- function Main.Start()
	
-- end

mCheckUpdate:Check(function()
	print("check update complete!!!")
	AssetLoader.Instance:LoadAsync("mat_test.mat", AssetType.Material, function(obj)
		print(obj)
	end,nil)
end)
