import "UnityEngine"

require "common.common"
require "common.globaldefine"
local mStopwatch = require "common.stopwatch"
local mEventManager = require "Common.EventManager"
local mCheckUpdate = require "common.checkupdate"
local mPlayerData = require "common.playerdata"

-- System.IO.Directory.Delete(Application.persistentDataPath, true)
-- local info = mPlayerData:Load()
-- print(info)

mCheckUpdate:Check()