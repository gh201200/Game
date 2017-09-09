local GameManager = class("Common.GameManager")

local this = nil

function GameManager:ctor()
	this = self
end

function GameManager:ReturnLoginPanel()
	EventManager:Clear()
	UIManager:Clear()
	AssetLoader.Instance:Clear()
	LuaManager.Instance:Clear()
	for k, v in pairs(package.loaded) do
		package.loaded[k] = nil
	end
	require "start"
end

return GameManager.new()
