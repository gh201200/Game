local mMainPanel = nil
local mItemBagPanel = nil
local mTaskPanel = nil
local mChatPanel = nil
local mAlert = nil
local mFamilyPanel = nil
local mFamilyListPanel = nil
local mFriendPanel = nil
local mHeroPanel = nil
local mSystemTip = nil
local mFleetPanel = nil
local mActivityManager = nil
local mEventManager = nil
local mActionManager = nil
local mPanelManager = nil
local mTaskManager = nil
local mMapPanel = nil
local mRankPanel = nil
local mActivityPanel = nil
local mLoginAwardPanel = nil
local mPassPanel = nil
local mSettingPanel = nil
local mGMChatPanel = nil
local mBattleManager = nil
local mMap = nil
local mBattleDPS = nil
local CommandTime = nil


module("LuaScript.View.Panel.Main.BattleMenu",package.seeall)

function Init()
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mItemBagPanel = require "LuaScript.View.Panel.Item.ItemBagPanel"
	mTaskPanel = require "LuaScript.View.Panel.Task.TaskPanel"
	mChatPanel = require "LuaScript.View.Panel.Chat.ChatPanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	mFamilyPanel = require "LuaScript.View.Panel.Family.FamilyPanel"
	mFamilyListPanel = require "LuaScript.View.Panel.Family.FamilyListPanel"
	mFriendPanel = require "LuaScript.View.Panel.Friend.FriendPanel"
	mHeroPanel = require "LuaScript.View.Panel.HeroPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mFleetPanel = require "LuaScript.View.Panel.Fleet.FleetPanel"
	mMapPanel = require "LuaScript.View.Panel.Map.MapPanel"
	mRankPanel = require "LuaScript.View.Panel.Rank.RankPanel"
	mActivityPanel = require "LuaScript.View.Panel.Activity.ActivityPanel"
	mLoginAwardPanel = require "LuaScript.View.Panel.Activity.LoginAward.LoginAwardPanel"
	mPassPanel = require "LuaScript.View.Panel.Pass.PassPanel"
	mSettingPanel = require "LuaScript.View.Panel.SettingPanel"
	mGMChatPanel = require "LuaScript.View.Panel.Chat.GMChatPanel"
	mMap = require "LuaScript.View.Scene.Map"
	mBattleDPS = require "LuaScript.View.Panel.Main.BattleDPS"
	
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	mActionManager = require "LuaScript.Control.ActionManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mTaskManager = require "LuaScript.Control.Data.TaskManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mBattleManager = require "LuaScript.Control.Data.BattleFieldManager"
    CommandTime = -5 
end


function OnGUI()
	local mHero = mHeroManager.GetHero()
	local x = 726
	--"好友",
	if mActionManager.GetActionOpen(ActionType.Friend) then
		if GUI.Button(x,-10,128,128,nil,GUIStyleButton.FriendBtn) then
			mFriendPanel.Show()
		end
		DrawRedPoint(746,-15, mFriendPanel.GetNewCount()) -- 红点
		x = x - 128
	end
	
	--聊天
	if mActionManager.GetActionOpen(ActionType.Chat) then
		if GUI.Button(x,-10,128,120,nil,GUIStyleButton.ChatBtn) then
			mPanelManager.Show(mChatPanel)
		end
		DrawRedPoint(x+30,-16, mChatPanel.GetNewCount()) -- 红点
	end
	--GM 指令
	-- if _G.IsDebug and GUI.Button(1022+15,322,100,50,"GM指令",GUIStyleButton.ShortOrangeBtn) then
		-- mPanelManager.Show(mGMChatPanel)
	-- end
	
	--指挥
	-- if mActionManager.GetActionOpen(ActionType.Chat) then
		-- if GUI.Button(780,561,65,65,"指挥",GUIStyleButton.CommandBtn) then
			-- mMap.SetCommand(1)
			-- mBattleFieldManager.RequestCommand(1, mHero.x, mHero.y, mHero.team, mHero.name)
			-- mSystemTip.ShowTip("选择目标点")
		-- end
		-- DrawRedPoint(646,-10, mChatPanel.GetNewCount())
	-- end

    if GUI.Button(780,561,65,65,"指挥",GUIStyleButton.CommandBtn) then
	    local battleTime = os.oldClock - mHero.BattleTime
		if battleTime - CommandTime > 5  then
			mBattleFieldManager.RequestCommand(1, mHero.x, mHero.y, mHero.team, mHero.name)
			CommandTime = battleTime
		else
			mSystemTip.ShowTip("指令冷却中")
		end
	end
	
	local x = 7
	local hurtList = mBattleFieldManager.GetHurtList()
	if hurtList and not mBattleDPS.mShowAll then
		x = 196
	elseif hurtList then
		x = 290
	end
	if GUI.Button(x,-7,128,64,nil,GUIStyleButton.Run) then
		local battleTime = os.oldClock - mHero.BattleTime
		if battleTime > 60 then
			mAlert.Show("是否离开战场?",mBattleManager.RunAway)
		else
			mSystemTip.ShowTip(math.ceil(60-battleTime).."秒后才可逃跑")
		end
	end
	
	local mSuperSkillTime = mBattleFieldManager.GetSuperSkillTime()
	if mSuperSkillTime then
		local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_SuperSkill)
		GUI.DrawTexture(450-85, 0, 256, 128, image)
		
		GUI.Label(152-85,60,700,25,mCommonlyFunc.GetShortFormatTime(mSuperSkillTime),GUIStyleLabel.Center_30_Green,Color.Black)
	end
end


function DrawRedPoint(x, y, count)
	if count <= 0 then
		return
	end
	x = x + 50
	y = y + 35
	local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg25_1)
	GUI.DrawTexture(x, y, 32, 32, image)
	GUI.Label(x, y+5, 32, 32, count, GUIStyleLabel.Center_22_White)
end