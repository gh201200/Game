local mActionManager = nil
local mTaskManager = nil
local mTavernPanel = nil

module("LuaScript.View.Panel.Main.Task",package.seeall) -- 任务

function Init()
	mActionManager = require "LuaScript.Control.ActionManager"
	mTaskManager = require "LuaScript.Control.Data.TaskManager"
	mTavernPanel = require "LuaScript.View.Panel.Harbor.TavernPanel"
end


function OnGUI()
	drawMainTask(792, 184)
	if mActionManager.GetActionOpen(ActionType.RandomTask) then
		drawRandomTask(792, 266)
	end
end

function drawMainTask(x, y) -- 主线任务
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg53_3")
	GUI.DrawTexture(x+56, 21+y, 333, 72, image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg53_1")
	GUI.DrawTexture(285+x, y, 74, 116, image)
	
	GUI.Label(308+x, 33+y, 32, 30, "主\n线", GUIStyleLabel.Center_22_White_Art)
	
	local task = mTaskManager.GetMainTask()
	if not task then
		local nextTask = mTaskManager.GetNextMainTask()
		if not nextTask then
			GUI.Label(136+x, 27+y, 160, 60, "当前主线任务已经全部完成", GUIStyleLabel.MLeft_18_White_WordWrap)
		elseif nextTask.level > 1 then
			local str = nextTask.level .. "级可领取任务"
			GUI.Label(136+x, 27+y, 160, 60, str, GUIStyleLabel.MLeft_18_White_WordWrap)
		end
		return
	end
	
	local cfg_task = CFG_task[task.id]
	local mHero = mHeroManager.GetHero()
	GUI.Label(136+x, 27+y, 160, 60, task.desc, GUIStyleLabel.MLeft_18_White_WordWrap)
	if GUI.Button(98+x,20+y,245,72, nil, GUIStyleButton.Transparent) then
		task.autoMove = true
		mTaskManager.AutoMove(nil,nil,task)
	end
end

function drawRandomTask(x, y) -- 随机悬赏任务
	local task,taskInfo = mTaskManager.GetRandomTask()
	if not task and taskInfo.lastCount <= 0 then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg53_3")
	GUI.DrawTexture(x+56, 21+y, 277, 72, image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg53_2")
	GUI.DrawTexture(285+x, y, 74, 116, image)
	GUI.Label(307+x, 35+y, 32, 30, "悬\n赏", GUIStyleLabel.Center_22_White_Art)
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/black")
	-- GUI.DrawTexture(136+x, 27+y, 160, 60, image)
	
	if not task then
		GUI.Label(136+x, 27+y, 160, 60, "<color=#00ff00ff>点击前往<酒馆>领取悬赏任务</color>", GUIStyleLabel.MLeft_18_White_WordWrap)
		GUI.FrameAnimation(x + 5,y - 143,400,400,'RandomTaskEdge',8,0.1) -- 边框动画
		if GUI.Button(98+x,21+y,245,72, nil, GUIStyleButton.Transparent) then
			mTavernPanel.mPage = 2
			mHeroManager.GotoHarborPanel(mTavernPanel)
		end
	else
		local cfg_randomTask = CFG_randomTask[taskInfo.id]
		GUI.Label(136+x,27+y,160,60, task.desc , GUIStyleLabel.MLeft_18_White_WordWrap)
		
		if GUI.Button(98+x,21+y,245,72, nil, GUIStyleButton.Transparent) then
			task.autoMove = true
			mTaskManager.AutoMove(nil,nil,task)
		end
	end
end