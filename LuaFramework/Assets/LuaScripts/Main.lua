import "UnityEngine"

require "common.common"
require "common.globaldefine"

mStopwatch = require "common.stopwatch"
UIBase = require "UI.Common.UIBase"
mEventManager = require "Common.EventManager"
mPlayerData = require "common.playerdata"
mUIManager = require "ui.uimanager"

local mCheckUpdate = require "common.checkupdate"
local mLoadingPanel = require "ui.common.loadingpanel"

-- System.IO.Directory.Delete(Application.persistentDataPath, true)
-- local info = mPlayerData:Load()
-- print(info)

-- mCheckUpdate:Check()

mUIManager:Open("LoginPanel")