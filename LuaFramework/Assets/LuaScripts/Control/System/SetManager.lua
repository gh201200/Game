local Camera,AudioSource,AudioListener,Resources,SettingType,tonumber,require,AudioData,io,pairs,tostring,ConstValue = 
Camera,AudioSource,AudioListener,Resources,SettingType,tonumber,require,AudioData,io,pairs,tostring,ConstValue
local print,Color,Directory = print,Color,Directory
local mAudioManager = nil
local mSceneManager = nil
local mCommonlyFunc = nil
local mSystemTip = nil
local mEquipManager = nil
local mAccountManager = nil
local mHeroManager = nil
local mCharManager = nil
local mUpdateNoticePanel = nil
local mPanelManager = nil
local mSettingPanel = nil
local mTaskManager = nil
module("LuaScript.Control.System.SetManager")
local settingList = {}

function Init()
	mAudioManager = require "LuaScript.Control.System.AudioManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mEquipManager = require "LuaScript.Control.Data.EquipManager"
	mAccountManager = require "LuaScript.Control.Data.AccountManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mUpdateNoticePanel = require "LuaScript.View.Panel.Chat.UpdateNoticePanel"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSettingPanel = require "LuaScript.View.Panel.SettingPanel"
	mTaskManager = require "LuaScript.Control.Data.TaskManager"
	
	ReadSettingData()
end

function GetList()
	return settingList
end


function DefaultSetting()
	settingList[SettingType.AudioOpen] = 1
	settingList[SettingType.Guide] = 1
	settingList[SettingType.CostTip] = 1
	settingList[SettingType.ChatTip] = 1
	settingList[SettingType.DestroyEquip1] = 0
	settingList[SettingType.DestroyEquip2] = 0
	settingList[SettingType.DestroyEquip3] = 0
	settingList[SettingType.DestroyEquip4] = 0
	settingList[SettingType.HideChar] = 0
	settingList[SettingType.HideChar1] = 0
	settingList[SettingType.DestroyEquip0] = 0
	settingList[SettingType.BattleModeShow] = 1
	settingList[SettingType.BattleMode] = 1
	settingList[SettingType.ProtectState] = 1
	settingList[SettingType.TreasurePosition] = 1
	settingList[SettingType.Notice] = 0
	settingList[SettingType.TaskTip] = 1
end

function ReadSettingData()
	DefaultSetting()
	
	local f = io.open(ConstValue.DataPath.."set", "r")
	if f then
		settingList[SettingType.AudioOpen] = tonumber(f:read("*line")) or 1
		f:close()
	end
	
	local hero = mHeroManager.GetHero()
	if hero then
		local cid = hero.id
		local serverIndex = mAccountManager.GetServerIndex()
		local fileName = serverIndex .. "_" .. cid
		local f = io.open(ConstValue.DataPath..fileName, "r")
		if f then
			local key = 1
			local value = f:read("*line")
			while value do
				settingList[key] = tonumber(value)
				key = key + 1
				value = f:read("*line")
				if key == SettingType.AudioOpen then
					key = key + 1
				end
			end
			f:close()
		end
	end
end

function SaveSettingData()
	Directory.CreateDirectory(ConstValue.DataPath)
	local hero = mHeroManager.GetHero()
	if hero then
		local cid = hero.id
		local serverIndex = mAccountManager.GetServerIndex()
		local fileName = serverIndex .. "_" .. cid
		local f = io.open(ConstValue.DataPath..fileName, "w")
		if f then
			for key=1,#settingList do
				if key == SettingType.AudioOpen then
					
				else
					f:write(tostring(settingList[key]) .. "\n")
				end
			end
			f:close()
		end
	end
	
	local f = io.open(ConstValue.DataPath.."set", "w")
	if f then
		f:write(settingList[SettingType.AudioOpen] or 1)
		f:close()
	end
end


function GetValue(key)
	if key == SettingType.BattleMode then
		local hero = mHeroManager.GetHero()
		return hero.mode
	else
		return settingList[key]
	end		
end

function SetValue(key, value)
	if key == SettingType.Notice then
		mPanelManager.Show(mUpdateNoticePanel)
		mPanelManager.Hide(mSettingPanel)
		
		local version = mUpdateNoticePanel.GetVersion()
		if version then
			settingList[key] = version
		end
		SaveSettingData()
		return
	end
	if value then
		settingList[key] = 1
	else
		settingList[key] = 0
	end
	
	-- 屏蔽只能开一项
	if value then
		if key == SettingType.HideChar then
			settingList[SettingType.HideChar1] = 0
			settingList[SettingType.HideChar2] = 0
		elseif key == SettingType.HideChar1 then
			settingList[SettingType.HideChar] = 0
			settingList[SettingType.HideChar2] = 0
		elseif key == SettingType.HideChar2 then
			settingList[SettingType.HideChar1] = 0
			settingList[SettingType.HideChar] = 0
		end
	end
	
	SaveSettingData()
	if key == SettingType.AudioOpen then
		RefreshAudio()
	end
	
	if key == SettingType.DestroyEquip1 or key == SettingType.DestroyEquip2 or
		key == SettingType.DestroyEquip3 or key == SettingType.DestroyEquip4 or 
		key == SettingType.DestroyEquip0 then
		mEquipManager.DestroyAllEquip()
	end
	
	if key == SettingType.HideChar or key == SettingType.HideChar1 or key == SettingType.HideChar2 then
		if not value then
			mCharManager.ShowChars()
		else
			mCharManager.HideChars()
		end
	end
	if key == SettingType.TaskTip then
		mTaskManager.ShowTaskTip()
	end
end

function RefreshAudio()
	if GetAudio() then
		mAudioManager.StartAudio()
		mSceneManager.PlayerAudio()
	else
		mAudioManager.StopAudio()
	end
end

function SetAudio(open)
	local value = 0
	if open then
		value = 1
	end
	settingList[SettingType.AudioOpen] = value
	
	SaveSettingData()
	RefreshAudio()
end

function GetAudio()
	return settingList[SettingType.AudioOpen] == 1
end

function SetCostTip(value)
	if value then
		settingList[SettingType.CostTip] = 1
	else
		settingList[SettingType.CostTip] = 0
		local info = "元宝消费提示可以在"
		info = info .. mCommonlyFunc.BeginColor(Color.CyanStr)
		info = info .. "菜单•设置"
		info = info .. mCommonlyFunc.EndColor()
		info = info .. "处重新开启"
		mSystemTip.ShowTip(info, Color.LimeStr)
	end
	SaveSettingData()
end

function GetChatTip()
	return not settingList[SettingType.ChatTip] or settingList[SettingType.ChatTip] == 1
end

function GetCostTip()
	return true
end

function SetGuide(value)
	if value then
		settingList[SettingType.Guide] = 1
	else
		settingList[SettingType.Guide] = 0
		mTaskManager.ShowTaskTip()
	end
	SaveSettingData()
end

function GetGuide()
	return not settingList[SettingType.Guide] or settingList[SettingType.Guide] == 1
end

function GetBattleMode()
	return settingList[SettingType.BattleMode] == 1
end

function SetBattleMode(value)
	if value then
		settingList[SettingType.BattleMode] = 1
	else
		settingList[SettingType.BattleMode] = 0
		
		local info = "战斗模式显示可以在"
		info = info .. mCommonlyFunc.BeginColor(Color.CyanStr)
		info = info .. "菜单•设置"
		info = info .. mCommonlyFunc.EndColor()
		info = info .. "处重新开启"
		mSystemTip.ShowTip(info, Color.LimeStr)
	end
	SaveSettingData()
end

function GetProtectState()
	return settingList[SettingType.ProtectState] == 1
end

function SetProtectState(value)
	if value then
		settingList[SettingType.ProtectState] = 1
	else
		settingList[SettingType.ProtectState] = 0
		
		local info = "保护时间显示可以在"
		info = info .. mCommonlyFunc.BeginColor(Color.CyanStr)
		info = info .. "菜单•设置"
		info = info .. mCommonlyFunc.EndColor()
		info = info .. "处重新开启"
		mSystemTip.ShowTip(info, Color.LimeStr)
	end
	SaveSettingData()
end

function GetTreasurePosition()
	return settingList[SettingType.TreasurePosition] == 1
end

function SetTreasurePosition(value)
	if value then
		settingList[SettingType.TreasurePosition] = 1
	else
		settingList[SettingType.TreasurePosition] = 0
		
		local info = "宝图坐标显示可以在"
		info = info .. mCommonlyFunc.BeginColor(Color.CyanStr)
		info = info .. "菜单•设置"
		info = info .. mCommonlyFunc.EndColor()
		info = info .. "处重新开启"
		mSystemTip.ShowTip(info, Color.LimeStr)
	end
	SaveSettingData()
end

function GetDestroyEquip0()
	return settingList[SettingType.DestroyEquip0] == 1
end
function GetDestroyEquip1()
	return settingList[SettingType.DestroyEquip1] == 1
end
function GetDestroyEquip2()
	return settingList[SettingType.DestroyEquip2] == 1
end
function GetDestroyEquip3()
	return settingList[SettingType.DestroyEquip3] == 1
end
function GetDestroyEquip4()
	return settingList[SettingType.DestroyEquip4] == 1
end

function GetHideChar()
	return settingList[SettingType.HideChar] == 1
end
function GetHideChar1()
	return settingList[SettingType.HideChar1] == 1
end
function GetHideChar2()
	return settingList[SettingType.HideChar2] == 1
end
function GetNotice()
	return settingList[SettingType.Notice]
end

function GetTaskTip()
	return settingList[SettingType.TaskTip] == 1
end
