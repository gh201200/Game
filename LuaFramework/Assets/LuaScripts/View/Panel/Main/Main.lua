local mMenuArea = require "LuaScript.View.Panel.Main.Menu"
local mTaskArea = require "LuaScript.View.Panel.Main.Task"
local mRoleInfoArea = require "LuaScript.View.Panel.Main.RoleInfo"
local mHarborBuildArea = require "LuaScript.View.Panel.Main.HarborBuild"
local mMapArea = require "LuaScript.View.Panel.Main.BattleMap"
local mSkillArea = require "LuaScript.View.Panel.Main.BattleSkill"
local mExpLineArea = require "LuaScript.View.Panel.Main.ExpLine"
local mProtectArea = require "LuaScript.View.Panel.Main.Protect"
local mDialogPanel = require "LuaScript.View.Panel.Task.DialogPanel"
local mBattleMenu = require "LuaScript.View.Panel.Main.BattleMenu"
local mBattleDPS = require "LuaScript.View.Panel.Main.BattleDPS"
local mJoystick = require "LuaScript.View.Panel.Main.Joystick"
local mFishTip = require "LuaScript.View.Tip.FishTip"
local mRollBossAward = require "LuaScript.View.Panel.Main.RollBossAward"
local mOngoingTask =  require "LuaScript.View.Panel.Main.OngoingTask"
local mBossAward =  require "LuaScript.View.Panel.Main.BossAward"
local mItemUse = require "LuaScript.View.Panel.Main.ItemUse"
local mBattleListTip = require "LuaScript.View.Tip.BattleListTip" -- 附近战斗列表
local mPanelManager = require "LuaScript.Control.PanelManager"
local mAwardPanel = require "LuaScript.View.Panel.AwardPanel"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mShipTeamManager	=	require "LuaScript.Control.Data.ShipTeamManager"
module("LuaScript.View.Panel.Main.Main",package.seeall)
notAutoClose = true

function Init()
	mMenuArea.Init() -- 菜单
	mTaskArea.Init() -- 任务提示
	mRoleInfoArea.Init() -- 左上角色信息
	mHarborBuildArea.Init() -- 海港
	mMapArea.Init() -- 小地图
	mSkillArea.Init() -- 技能
	mProtectArea.Init() -- 战斗模式切换
	mExpLineArea.Init() -- 经验条
	mBattleMenu.Init() -- 战场菜单
	mBattleDPS.Init() -- 战场DPS列表
	mJoystick.Init() -- 摇杆
	mRollBossAward.Init() -- BOSS奖励摇骰子
	mBossAward.Init() -- boss奖励
	mItemUse.Init()--物品使用
	
	mOngoingTask.Init() -- 正在进行中活动的提示
	
	local shipAward = nil
	if mShipTeamManager.GetMoneyAward then
		shipAward = mShipTeamManager.GetMoneyAward() or 0
	else
		shipAward = 0
	end
	local income = false
	for _, v in pairs(mHarborManager.GetSelfHarborList()) do
		if v.income then
			income = true
			break
		end
	end
	if income or shipAward ~= 0 then
		mPanelManager.Show(mAwardPanel)
	end
	
end

function OnShow()
	
end

function OnGUI()
	local mHero = mHeroManager.GetHero()
	if mHero.SceneType == SceneType.Harbor then
		mHarborBuildArea.OnGUI()
		mRoleInfoArea.OnGUI()
		mOngoingTask.OnGUI()
		if not mDialogPanel.visible and not mRollBossAward.visible then
			mMenuArea.OnGUI()
			mTaskArea.OnGUI()
			mExpLineArea.OnGUI()
		elseif not mDialogPanel.visible then
			mTaskArea.OnGUI()
		end
		mItemUse.OnGUI()
		mBossAward.OnGUI()
		mRollBossAward.OnGUI()
	elseif mHero.SceneType == SceneType.Battle then
		mMapArea.OnGUI()
		mSkillArea.OnGUI()
		mBattleMenu.OnGUI()
		mBattleDPS.OnGUI()
		mJoystick.OnGUI()
	else
		mRoleInfoArea.OnGUI()
		mProtectArea.OnGUI()
		mBattleDPS.OnGUI()
		if not mDialogPanel.visible and not mRollBossAward.visible then
			mMenuArea.OnGUI()
			mTaskArea.OnGUI()
			mExpLineArea.OnGUI()
			mJoystick.OnGUI()
			mBattleListTip.OnGUI()
		elseif not mDialogPanel.visible then
			mTaskArea.OnGUI()
			mJoystick.OnGUI()
		end
		mFishTip.OnGUI()
		mItemUse.OnGUI()
		mBossAward.OnGUI()
		mRollBossAward.OnGUI()
		mOngoingTask.OnGUI()
	end
end

function Update()
	if not visible then
		return
	end
	mJoystick.Update()
end

function AutoPanel(panel)
	mHarborBuildArea.AutoPanel(panel)
end

function ResetMaxOffsetY()
	mHarborBuildArea.ResetMaxOffsetY()
end

function GetButtonPosition(actiontType)
	return mMenuArea.GetButtonPosition(actiontType)
end

function GetShowMode()
	return mMenuArea.GetShowMode()
end
