import "System"
import "UnityEngine"

local Main = { }

require "common.common"
require "common.globaldefine"
local mCheckUpdate = require "common.checkupdate"
local Stopwatch = require "common.stopwatch"
local mGameInfo = require "common.gameinfo".new(Main)

local sw = Stopwatch.new()
sw:Start()

function Main.Start()
	print(mGameInfo.canvas)
	print(sw:Stop())
end

