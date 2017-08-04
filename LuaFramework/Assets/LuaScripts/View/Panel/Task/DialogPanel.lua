local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_copyMap,CFG_item,AppearEvent,CsCurrentEventEqualsType,SceneType = 
ConstValue,CFG_EquipSuit,CFG_copyMap,CFG_item,AppearEvent,CsCurrentEventEqualsType,SceneType
local AssetType,os,EventType,SplitString,CFG_task,CFG_npc,CFG_taskDialog,_G,CFG_role,Event,UnityEventType = 
AssetType,os,EventType,SplitString,CFG_task,CFG_npc,CFG_taskDialog,_G,CFG_role,Event,UnityEventType

local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mTaskManager = require "LuaScript.Control.Data.TaskManager"
local mPromptAlert = require "LuaScript.Control.Data.TaskManager"

local mPackageViewPanel = nil
local mSceneManager = nil
local mHeroManager = nil
local mAlert = nil
local mPanelManager = nil
local mMainPanel = nil
local mGuidePanel = nil
local mEventManager = nil


module("LuaScript.View.Panel.Task.DialogPanel")
panelType = ConstValue.GuidePanel
notShowGuide = true
notAutoClose = true
local mTaskId = nil
local mDialog = nil
local mDialogList = nil

function SetData(taskId)
	if visible then
		return
	end
	-- print(111)
	mDialogList = mTaskManager.GetDialogList(taskId)
	mTaskId = taskId
	mDialogNo = 1
	
	CheckTask()
end

function Display()
	-- mMainPanel.HideToolbar()
end

function Hide()
	-- mMainPanel.ShowToolbar()
	
	AppearEvent(nil,EventType.UseTurntable)
	AppearEvent(nil,EventType.OnCloseDialogPanel)
end

function CheckTask()
	if not mDialogList[mDialogNo] then
		if not mTaskManager.RequestAddTask(mTaskId) then
			-- print("hide!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			mPanelManager.Hide(OnGUI)
		end
		return true
	end
	-- print("not hide!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
end

function Init()
	-- print(44444444444444444444)
	mAlert = require "LuaScript.View.Alert.Alert"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mGuidePanel = require "LuaScript.View.Panel.Task.GuidePanel"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mPromptAlert = require "LuaScript.View.Alert.PromptAlert"
	mPackageViewPanel = require "LuaScript.View.Panel.Item.PackageViewPanel"
	
	IsInit = true
	
	mEventManager.AddEventListen(nil, EventType.OnAddTask, OnAddTask)
end

function OnAddTask(_,_,id)
	-- print(2222)
	-- print(mTaskId , id)
	if mTaskId == id then
		mPanelManager.Hide(OnGUI)
	end
end

function PerGUI()
	local hero = mHeroManager.GetHero()
	if hero.SceneType == SceneType.Battle then
		return
	end
	if mAlert.visible or mPromptAlert.visible or mPackageViewPanel.visible then
		return
	end
	if GUI.TextureButton(0,0,1136,640,nil) then
		mDialogNo = mDialogNo + 1
		
		if CheckTask() then
			mDialogNo = mDialogNo - 1
		end
	end
end

function OnGUI()
	if not IsInit then
		return
	end
	local hero = mHeroManager.GetHero()
	if hero.SceneType == SceneType.Battle then
		return
	end
	if mAlert.visible or mPromptAlert.visible or mPackageViewPanel.visible then
		return
	end
	if not mDialogList[mDialogNo] then
		return
	end
	
	local hero = mHeroManager.GetHero()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/dialogBg")
	GUI.DrawTexture(0,379,1136,261,image)
	
	local dialog = mDialogList[mDialogNo]
	local cfg_taskDialog = CFG_taskDialog[dialog]
	local name = nil
	local resId = nil
	local cfg_npc = CFG_npc[cfg_taskDialog.cid]
	if cfg_npc then
		resId = cfg_npc.resId
		name = cfg_npc.name
	else
		local cfg_role = CFG_role[hero.role]
		resId = cfg_role.resId
		name = hero.name
	end
	local image = mAssetManager.GetAsset("Texture/Character/NpcPic/"..resId)
	if image then
		local x = 0
		local y = 640 - 512
		local source_x = 0
		local source_width = 1
		if cfg_taskDialog.location == 0 then
			x = 1135 - 512
			source_x = 1
			source_width = -1
		end
		GUI.DrawTexture(x,y,512,512,image,source_x,0,source_width,1,0,0,0,0)
	end
	
	if cfg_taskDialog.location == 0 then
		GUI.Label(210, 390, 163, 40, name,GUIStyleLabel.Left_45_ChannelColor_Art)
		GUI.Label(130, 455, 609, 160, cfg_taskDialog.content,GUIStyleLabel.Left_40_White_WordWrap)
		GUI.Label(534, 595, 609, 160, "(点击继续)",GUIStyleLabel.Left_30_Green2)
	else
		GUI.Label(480, 390, 163, 40, name,GUIStyleLabel.Left_45_ChannelColor_Art)
		GUI.Label(400, 455, 609, 160, cfg_taskDialog.content,GUIStyleLabel.Left_40_White_WordWrap)
		GUI.Label(888, 595, 609, 160, "(点击继续)",GUIStyleLabel.Left_30_Green2)
	end
end