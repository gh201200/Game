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
	print("check update complete!")
end)