local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table
local SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property,EventType,CFG_task,CFG_item = 
SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property,EventType,CFG_task,CFG_item
local AssetType,CFG_randomTask,CFG_shipEquip,CFG_GlobalQuest = 
AssetType,CFG_randomTask,CFG_shipEquip,CFG_GlobalQuest
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mMainPanel = require "LuaScript.View.Panel.Main.Main"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mTaskManager = require "LuaScript.Control.Data.TaskManager"
local mEquipUpPanel = nil
local mEquipDestroyPanel = nil
local mEquipViewPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mEquipManager = require "LuaScript.Control.Data.EquipManager"
local mCommonlyFunc = nil
local mSailorManager = nil
local mEventManager = nil
local mShipEquipViewPanel = nil
local mItemViewPanel = nil
local mItemCountSelectPanel = nil
local mItemManager = nil
local mShipEquipSelectPanel = nil
local mShipEquipManager = nil
local mSystemTip = nil
local mShipManager = nil
local mShipSelectPanel = nil

module("LuaScript.View.Panel.Task.TaskPanel")

local mPage = 1

local mLevelUpWay = "悬赏任务：每天可接取10次，完成获得海量经验\n"..
					"副本：挑战成功后获得大量经验和装备\n"..
					"活动：参与可获得物品、银两与经验\n"..
					"杀野怪：击杀后可获得物品、银两与经验<size=50></size>\n"

function Init()
	mSailorManager = require "LuaScript.Control.Data.SailorManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipDestroyPanel = require "LuaScript.View.Panel.Equip.EquipDestroyPanel"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	-- mEquipManager = require "LuaScript.Control.Data.EquipManager"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mShipEquipViewPanel = require "LuaScript.View.Panel.Equip.ShipEquipViewPanel"
	mEventManager = require "LuaScript.Control.EventManager"
	mItemCountSelectPanel = require "LuaScript.View.Panel.Item.ItemCountSelectPanel"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mShipEquipSelectPanel = require "LuaScript.View.Panel.Equip.ShipEquipSelectPanel"
	mShipEquipManager = require "LuaScript.Control.Data.ShipEquipManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mShipManager = require "LuaScript.Control.Data.ShipManager"
	mShipSelectPanel = require "LuaScript.View.Panel.Harbor.ShipSelectPanel"
	-- mEventManager.AddEventListen(nil, EventType.RefreshEquip, RefreshEquip)
	
	IsInit = true
end

function Display()
	-- RefreshEquip()
end

function Hide()
	mPage = 1
end

function OnGUI()
	
	if not IsInit then
		return
	end

	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	local task = nil
	if mPage == 1 then
		task = mTaskManager.GetMainTask()
		DrawTask(task)
		GUI.Button(87.5,37.5,134,58, "主线", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(87.5,37.5,134,58, "主线", GUIStyleButton.PagBtn_1) then
		mPage = 1
	end

	if mPage == 2  then
		task = mTaskManager.GetRandomTask()
		DrawRandomTask(task)
		GUI.Button(226.55,37.5,134,58, "悬赏", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(226.55,37.5,134,58, "悬赏", GUIStyleButton.PagBtn_1) then
		mPage = 2
	end
	
	local mGlobalMission = mTaskManager.GetGlobalMission()
	if mGlobalMission then
		if mPage == 3  then
			DrawGloabTask()
			GUI.Button(365,37.5,134,58, "世界", GUIStyleButton.PagBtn_2)
		elseif GUI.Button(365,37.5,134,58, "世界", GUIStyleButton.PagBtn_1) then
			mPage = 3
			mTaskManager.RequipGlobalMission()
		end
		
		local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
		GUI.DrawTexture(364+139,37.5,682-139,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	else
		local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
		GUI.DrawTexture(364,37.5,682,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	end
	-- DrawTask(task)
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		ClosePanel()
	end
end

function ClosePanel()
	mPanelManager.Show(mMainPanel)
	mPanelManager.Hide(OnGUI)
	mSceneManager.SetMouseEvent(true)
	mPage = 1
end

function GetMovePosition(task)
	local width = GUI.GetTextSize(task.desc, GUIStyleLabel.Left_25_White)
	return 320+width,328
end

function DrawTask(task)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(152,150,842,431,image,0,0,1,1,20,20,20,20)
	if not task then
		local task = mTaskManager.GetNextMainTask()
		if task then
			local cfg_task = CFG_task[task.id]
			GUI.Label(440, 176, 284, 30, cfg_task.name, GUIStyleLabel.Center_40_Redbean_Art)
			GUI.Label(188, 241, 74, 30, "任务要求:", GUIStyleLabel.Left_25_Black)
			GUI.Label(188, 296, 74, 30, "升级途径:", GUIStyleLabel.Left_25_Black)
			
			
			local str = cfg_task.level .. "级可领取"
			GUI.Label(318, 241, 74, 30, str, GUIStyleLabel.Left_25_Brown)
			
			GUI.Label(243, 323, 74, 30, mLevelUpWay, GUIStyleLabel.Left_25_Brown)
		else
			GUI.Label(378, 341, 74, 30, "当前没有主线任务可以领取", GUIStyleLabel.Left_35_Brown_Art)
		end
	else
		local cfg_task = CFG_task[task.id]
		local exp,money = nil,nil
		if task.id > 10000 then
			cfg_task = CFG_randomTask[task.id]
			exp,money = mCommonlyFunc.GetRandomTaskAward(task.quality) 
		end
		GUI.Label(440, 176, 284, 30, cfg_task.name, GUIStyleLabel.Center_40_Redbean_Art)
		
		GUI.Label(189, 229, 74, 30, "任务描述:", GUIStyleLabel.Left_25_Black)
		GUI.Label(189, 333, 74, 30, "任务目标:", GUIStyleLabel.Left_25_Black)
		GUI.Label(189, 382, 74, 30, "任务奖励:", GUIStyleLabel.Left_25_Black)

		GUI.Label(310, 229, 650, 30, cfg_task.desc, GUIStyleLabel.Left_25_White_WordWrap, Color.Black)
		GUI.Label(310, 333, 74, 30, task.desc, GUIStyleLabel.Left_25_White, Color.Black)
		
		local index = 0
		local spacing = 150
		
		local cfg_taskEnd = cfg_task
		if cfg_task.endId ~= 0 and cfg_taskEnd.endId ~= nil then
			cfg_taskEnd =  CFG_task[cfg_task.endId]
		end
		
		local target = cfg_task.target
		if mTaskManager.CouldFly(task) then
			local width = GUI.GetTextSize(task.desc, GUIStyleLabel.Left_25_White)
			if GUI.Button(320+width,328,112,34, nil, GUIStyleButton.MoveBtn_3) then
				task.autoMove = true
				mTaskManager.AutoMove(nil,nil,task)
				ClosePanel()
			end
			
			if GUI.Button(460+width,328,112,34, nil, GUIStyleButton.FlyBtn_2) then
				task.autoMove = true
				mTaskManager.AutoFly(task)
			end
		end
		
		if cfg_taskEnd.exp ~= 0 then
			local image = mAssetManager.GetAsset("Texture/Icon/Item/23")
			GUI.DrawTexture(228,428,100,100,image,0,0,1,1,6,6,6,6)
			GUI.Label(228, 499, 93, 30, cfg_taskEnd.exp or exp, GUIStyleLabel.Right_25_White, Color.Black)
			GUI.Label(228, 534, 100, 30, "经验", GUIStyleLabel.Center_25_Black)
			index = index + 1
		end
		
		if cfg_taskEnd.money ~= 0 then
			local x = spacing * index + 228
			local image = mAssetManager.GetAsset("Texture/Icon/Item/14")
			GUI.DrawTexture(x,428,100,100,image,0,0,1,1,6,6,6,6)
			GUI.Label(x, 499, 93, 30, cfg_taskEnd.money or money, GUIStyleLabel.Right_25_White, Color.Black)
			GUI.Label(x, 534, 100, 30, "银两", GUIStyleLabel.Center_25_Black)
			index = index + 1
		end
		
		if cfg_taskEnd.gold ~= 0 and cfg_taskEnd.gold then
			local x = spacing * index + 228
			local image = mAssetManager.GetAsset("Texture/Icon/Item/13")
			GUI.DrawTexture(x,428,100,100,image,0,0,1,1,6,6,6,6)
			GUI.Label(x, 499, 93, 30, cfg_taskEnd.gold, GUIStyleLabel.Right_25_White, Color.Black)
			GUI.Label(x, 534, 100, 30, "元宝", GUIStyleLabel.Center_25_Black)
			index = index + 1
		end
		
		local awardList = mTaskManager.GetAward(cfg_task, task)
		if awardList then
			for k,award in pairs(awardList) do
				local x = spacing * index + 228
				DrawAward(x, 0, award)
				index = index + 1
			end
		end
	end
end


function DrawRandomTask(task)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(152,150,842,431,image,0,0,1,1,20,20,20,20)
	if not task then
		GUI.Label(268, 341, 74, 30, "每日可去酒馆·悬赏界面,领取10次任务", GUIStyleLabel.Left_35_Brown_Art)
		return
	end
	
	local cfg_task = CFG_randomTask[task.id]
	local exp,money = mCommonlyFunc.GetRandomTaskAward(task.quality) 

	GUI.Label(440, 176, 284, 30, cfg_task.name, GUIStyleLabel.Center_40_Redbean_Art)
	
	GUI.Label(189, 229, 74, 30, "任务描述:", GUIStyleLabel.Left_25_Black)
	GUI.Label(189, 333, 74, 30, "任务目标:", GUIStyleLabel.Left_25_Black)
	GUI.Label(189, 382, 74, 30, "任务奖励:", GUIStyleLabel.Left_25_Black)

	GUI.Label(310, 229, 650, 30, cfg_task.desc, GUIStyleLabel.Left_25_White_WordWrap, Color.Black)
	GUI.Label(310, 333, 74, 30, task.desc, GUIStyleLabel.Left_25_White, Color.Black)
	
	local index = 0
	local spacing = 150
	
	local cfg_taskEnd = cfg_task
	if cfg_task.endId ~= 0 and cfg_taskEnd.endId ~= nil then
		cfg_taskEnd =  CFG_task[cfg_task.endId]
	end
	
	local target = cfg_task.target
	if mTaskManager.CouldFly(task) then
		local width = GUI.GetTextSize(task.desc, GUIStyleLabel.Left_25_White)
		if GUI.Button(320+width,328,112,34, nil, GUIStyleButton.MoveBtn_3) then
			task.autoMove = true
			mTaskManager.AutoMove(nil,nil,task)
			ClosePanel()
		end
		
		if GUI.Button(460+width,328,112,34, nil, GUIStyleButton.FlyBtn_2) then
			task.autoMove = true
			mTaskManager.AutoFly(task)
		end
	end
	
	if cfg_taskEnd.exp ~= 0 then
		local image = mAssetManager.GetAsset("Texture/Icon/Item/23")
		GUI.DrawTexture(228,428,100,100,image,0,0,1,1,6,6,6,6)
		GUI.Label(228, 499, 93, 30, cfg_taskEnd.exp or exp, GUIStyleLabel.Right_25_White, Color.Black)
		GUI.Label(228, 534, 100, 30, "经验", GUIStyleLabel.Center_25_Black)
		index = index + 1
	end
	
	if cfg_taskEnd.money ~= 0 then
		local x = spacing * index + 228
		local image = mAssetManager.GetAsset("Texture/Icon/Item/14")
		GUI.DrawTexture(x,428,100,100,image,0,0,1,1,6,6,6,6)
		GUI.Label(x, 499, 93, 30, cfg_taskEnd.money or money, GUIStyleLabel.Right_25_White, Color.Black)
		GUI.Label(x, 534, 100, 30, "银两", GUIStyleLabel.Center_25_Black)
		index = index + 1
	end
	
	if cfg_taskEnd.gold ~= 0 and cfg_taskEnd.gold then
		local x = spacing * index + 228
		local image = mAssetManager.GetAsset("Texture/Icon/Item/13")
		GUI.DrawTexture(x,428,100,100,image,0,0,1,1,6,6,6,6)
		GUI.Label(x, 499, 93, 30, cfg_taskEnd.gold, GUIStyleLabel.Right_25_White, Color.Black)
		GUI.Label(x, 534, 100, 30, "元宝", GUIStyleLabel.Center_25_Black)
		index = index + 1
	end
	
	local awardList = mTaskManager.GetAward(cfg_task, task)
	if awardList then
		for k,award in pairs(awardList) do
			local x = spacing * index + 228
			DrawAward(x, 0, award)
			index = index + 1
		end
	end
end

function DrawGloabTask()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg50_1")
	GUI.DrawTexture(78,114,980,516,image)
	
	DrawGlobalList()
	
	local cfg_task = CFG_GlobalQuest[selectId]
	if not cfg_task then
		return
	end
	GUI.Label(609, 176, 144, 30, cfg_task.name, GUIStyleLabel.Center_40_Redbean_Art)
	
	GUI.Label(418, 241, 74, 30, "任务描述:", GUIStyleLabel.Left_25_Black)
	GUI.Label(418, 366, 74, 30, "任务目标:", GUIStyleLabel.Left_25_Black)
	GUI.Label(418, 404, 74, 30, "任务进度:", GUIStyleLabel.Left_25_Black)
	GUI.Label(418, 450, 74, 30, "任务奖励:", GUIStyleLabel.Left_25_Black)

	local mGlobalMission = mTaskManager.GetGlobalMission()
	GUI.Label(535, 241, 450, 30, cfg_task.desc, GUIStyleLabel.Left_25_White_WordWrap, Color.Black)
	GUI.Label(535, 366, 74, 30, cfg_task.targetDesc, GUIStyleLabel.Left_25_White, Color.Black)
	if mGlobalMission.list[selectId] then
		GUI.Label(535, 404, 74, 30, mGlobalMission.list[selectId].."/"..cfg_task.count, GUIStyleLabel.Left_25_White, Color.Black)
	else
		GUI.Label(535, 404, 74, 30, "0/"..cfg_task.count, GUIStyleLabel.Left_25_White, Color.Black)
	end
	
	
	
	DrawAward(543, 20, {awardId=cfg_task.awardId,type=cfg_task.awardType,count=cfg_task.awardCount})
	
	local oldEnabled = GUI.GetEnabled()
	if mGlobalMission.list[selectId] and mGlobalMission.list[selectId] >= cfg_task.count then
		GUI.SetEnabled(false)
	end
	
	if GUI.Button(817,445,166,77,"捐献",GUIStyleButton.BlueBtn) then
		if cfg_task.type == 0 then
			local count = mItemManager.GetItemCountById(cfg_task.itemId)
			if count < cfg_task.giveCount then
				mSystemTip.ShowTip("该物品数量不足,无法捐献")
				return
			end
			function selectFunc(item, count)
				if count and count > 0 then
					mTaskManager.RequipGlobalGiveItem(item.id, 0, count)
				end
			end
			
			if mGlobalMission.list[selectId] and mGlobalMission.list[selectId] + count >= cfg_task.count then
				count = cfg_task.count - mGlobalMission.list[selectId]
			end
			mItemCountSelectPanel.SetData({id=cfg_task.itemId,count=count}, selectFunc, cfg_task.giveCount)
			mPanelManager.Show(mItemCountSelectPanel)
		elseif cfg_task.type == 1 then
			local list = mEquipManager.GetEquipByQuality(cfg_task.itemId, false)
			if not list[1] then
				mSystemTip.ShowTip("该品质装备不足,无法捐献")
				return
			end
			function selectFunc(equip)
				if equip then
					mTaskManager.RequipGlobalGiveItem(equip.index, 1, 1)
				end
				mPanelManager.Show(OnGUI)
				mPage = 3
			end
			
			mEquipSelectPanel.SetData(nil, nil, selectFunc, nil, list)
			mPanelManager.Show(mEquipSelectPanel)
			mPanelManager.Hide(OnGUI)
		elseif cfg_task.type == 2 then
			local list = mShipEquipManager.GetEquipByQuality(cfg_task.itemId, false)
			if not list[1] then
				mSystemTip.ShowTip("该品质装备不足,无法捐献")
				return
			end
			function selectFunc(equip)
				if equip  then
					mTaskManager.RequipGlobalGiveItem(equip.index, 2, 1)
				end
				mPanelManager.Show(OnGUI)
				mPage = 3
			end
			
			mShipEquipSelectPanel.SetData(nil, nil,  selectFunc, list)
			mPanelManager.Show(mShipEquipSelectPanel)
			mPanelManager.Hide(OnGUI)
		elseif cfg_task.type == 3 then
			local list = mShipManager.GetRestShipById(cfg_task.itemId)
			if not list[1] then
				mSystemTip.ShowTip("该类船只不足,无法捐献")
				return
			end
			function selectFunc(ship)
				if ship  then
					mTaskManager.RequipGlobalGiveItem(ship.index, 3, 1)
				end
				mPanelManager.Show(OnGUI)
				mPage = 3
			end
			
			mShipSelectPanel.SetData(selectFunc, list)
			mPanelManager.Show(mShipSelectPanel)
			mPanelManager.Hide(OnGUI)
		end
	end
	if mGlobalMission.list[selectId] and mGlobalMission.list[selectId] >= cfg_task.count then
		GUI.SetEnabled(oldEnabled)
	end
end


function DrawGlobalList()
	local index = 0
	
	local mGlobalMission = mTaskManager.GetGlobalMission()
	for k,v in pairs(CFG_GlobalQuest) do
		if v.questID == mGlobalMission.id then
			if not CFG_GlobalQuest[selectId] or selectId == v.id then
				-- print(mGlobalMission.id)
				-- print(v)
				-- print(CFG_GlobalQuest[selectId])
				local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg50_2")
				GUI.DrawTexture(91,167+index*40,256,43,image)
				selectId = v.id
			end
			local str = v.name
			if mGlobalMission.list[k] and mGlobalMission.list[k] >= v.count then
				str = str .. mCommonlyFunc.BeginColor(Color.LimeStr)
				str = str .. "(已完成)"
				str = str .. mCommonlyFunc.EndColor()
			end
			if GUI.Button(91, 167+index*40, 256, 43, str, GUIStyleButton.SelectBtn_7) then
				selectId = v.id
			end
			index = index + 1
		end
	end
end

function DrawAward(x, y, award)
	if award.type == 1 then
		local cfg_equip = CFG_Equip[award.awardId]
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..cfg_equip.quality)
		GUI.DrawTexture(x,428+y,118,118,image,0,0,1,1,21,28,20,28)
		local image = mAssetManager.GetAsset("Texture/Icon/Equip/"..cfg_equip.icon, AssetType.Icon)
		if GUI.TextureButton(x+5,433+y,90,90,image) then
			local equip = {}
			equip.id = award.awardId
			equip.notExist = true
			-- equip.star = 0
			mEquipViewPanel.SetData(nil, equip)
			mPanelManager.Show(mEquipViewPanel)
		end
		if award.count > 1 then
			GUI.Label(x, 499+y, 93, 30, award.count, GUIStyleLabel.Right_25_White, Color.Black)
			GUI.Label(x, 534+y, 100, 30, cfg_equip.name, GUIStyleLabel.Center_25_Black)
		else
			GUI.Label(x, 534+y, 100, 30, cfg_equip.name, GUIStyleLabel.Center_25_Black)
		end
	elseif award.type == 0 then
		local cfg_item = CFG_item[award.awardId]
		local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
		if GUI.TextureButton(x,428+y,100,100,image,0,0,1,1,6,6,6,6) then
			mItemViewPanel.SetData(award.awardId)
			mPanelManager.Show(mItemViewPanel)
		end
		if award.count > 1 then
			GUI.Label(x, 499+y, 93, 30, award.count, GUIStyleLabel.Right_25_White, Color.Black)
			GUI.Label(x, 534+y, 100, 30, cfg_item.name, GUIStyleLabel.Center_25_Black)
		else
			GUI.Label(x, 534+y, 100, 30, cfg_item.name, GUIStyleLabel.Center_25_Black)
		end
	elseif award.type == 2 then
		local cfg_equip = CFG_shipEquip[award.awardId]
		local image = mAssetManager.GetAsset("Texture/GUI/Bg/equipSlot_"..cfg_equip.quality)
		GUI.DrawTexture(x,428+y,118,118,image)
		local image = mAssetManager.GetAsset("Texture/Icon/ShipEquip/"..cfg_equip.icon, AssetType.Icon)
		if GUI.TextureButton(x+7,435+y,90,90,image) then
			mShipEquipViewPanel.SetData(nil, {id=award.awardId,notExist = true,star = 0})
			mPanelManager.Show(mShipEquipViewPanel)
		end

		-- GUI.Label(116+x, 93, 154, 29, award.count, GUIStyleLabel.Right_25_White, Color.Black)
		GUI.Label(x, 534+y, 100, 30, cfg_equip.name, GUIStyleLabel.Center_25_Black)
	end
end
