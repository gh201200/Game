local Camera,Screen,math,print,RaycastHit,Physics,Vector3,Application,GameObject,require,os,SceneType,ActionType,AppearEvent,EventType = 
Camera,Screen,math,print,RaycastHit,Physics,Vector3,Application,GameObject,require,os,SceneType,ActionType,AppearEvent,EventType
local CFG_action,pairs = CFG_action,pairs
local mTaskManager = require "LuaScript.Control.Data.TaskManager"
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mActionOpenTip = nil
module("LuaScript.Control.ActionManager")
local allOpen = false
local CFG_ActionByTaskId = {}
local CFG_ActionByLevel = {}

function Init()
	mActionOpenTip = require "LuaScript.View.Tip.ActionOpenTip"
	for k,v in pairs(CFG_action) do
		if v.taskId ~= 0 then
			CFG_ActionByTaskId[v.taskId] = v
		end
		if v.level ~= 0 then
			CFG_ActionByLevel[v.level] = v
		end
	end
end

function Reset()
	allOpen = false
end

function GetActionOpen(id)
	if allOpen then
		return true
	end
	local action = CFG_action[id]
	if action.defaultOpen == 1 then
		return true
	end
	local hero = mHeroManager.GetHero()
	if not hero then
		return
	end
	if action.level > hero.level then
		return false
	end
	
	if action.taskId ~= 0 and not mTaskManager.IsFinished(action.taskId) and not mTaskManager.IsGeted(action.taskId) then
		return false
	end
	return true
end

function GetTask(id)
	local cfg_action = CFG_ActionByTaskId[id]
	if cfg_action then
		mActionOpenTip.ShowTip(cfg_action.id)
		return true
	end
end

function LevelUp(level)
	local cfg_action = CFG_ActionByLevel[level]
	if cfg_action then
		mActionOpenTip.ShowTip(cfg_action.id)
	end
end


function OpenAction(id)
	-- mOpenActionList[id] = true
end

function OpenAllAction()
	-- mOpenActionList[1] = true
	-- mOpenActionList[2] = true
	-- mOpenActionList[3] = true
	-- mOpenActionList[4] = true
	-- mOpenActionList[5] = true
	-- mOpenActionList[6] = true
	-- mOpenActionList[7] = true
	-- mOpenActionList[8] = true
	-- mOpenActionList[9] = true
	-- mOpenActionList[10] = true
	-- mOpenActionList[11] = true
	-- mOpenActionList[12] = true
	-- mOpenActionList[13] = true
	-- mOpenActionList[14] = true
	-- mOpenActionList[15] = true
	-- mOpenActionList[16] = true
	-- mOpenActionList[17] = true
	-- mOpenActionList[18] = true
	-- mOpenActionList[19] = true
	-- mOpenActionList[20] = true
	allOpen = true
	
	AppearEvent(nil, EventType.RefreshMainBtn)
end