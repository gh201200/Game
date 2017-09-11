require "common.common"
require "common.globaldefine"

Json = require "Common.Json"
Stopwatch = require "common.stopwatch"
UIBase = require "UI.Common.UIBase"
EventManager = require "Common.EventManager"
UIManager = require "ui.uimanager"
CheckUpdate = require "common.checkupdate"
GameManager = require "common.gamemanager"

local PlayerData = require "common.playerdata"

Data = PlayerData:Load()
print("PlayerData", Data)

EventManager:Add(EventType.OnPanelOpen, function(panelName)
	if panelName == "LoginPanel" then
		CheckUpdate:Check()
	end
end)

UIManager:Open("LoginPanel")
--UIManager:Open("TestPanel")
