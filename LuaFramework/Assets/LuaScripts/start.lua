--startInti
require "LuaScript.Mode.NetPackat.PassMap"
require "LuaScript.Mode.NetPackat.Packat"

require "LuaScript.Mode.CSClass.UnityEngine.Color"
require "LuaScript.Mode.CSClass.UnityEngine.TextAnchor"
require "LuaScript.Mode.CSClass.UnityEngine.FontStyle"
require "LuaScript.Mode.CSClass.UnityEngine.TextClipping"

require "LuaScript.Mode.Const.Language"
require "LuaScript.Mode.Const.MapTexture"
require "LuaScript.Mode.Const.GameObjectTag"
require "LuaScript.Mode.Const.CharacterType"
require "LuaScript.Mode.Const.CharacterState"
require "LuaScript.Mode.Const.AudioData"
require "LuaScript.Mode.Const.EventType"
require "LuaScript.Mode.Const.AssetPath"
require "LuaScript.Mode.Const.SettingType"
require "LuaScript.Mode.Const.SceneType"
require "LuaScript.Mode.Const.ConstValue"
require "LuaScript.Mode.Const.GUIStyleList"
require "LuaScript.Mode.Const.SailorType"
require "LuaScript.Mode.Const.LogbookType"
require "LuaScript.Mode.Const.AssetType"
require "LuaScript.Mode.Const.ActionType"
require "LuaScript.Mode.Const.PanelIndex"
require "LuaScript.Mode.Const.AttackType"
require "LuaScript.Mode.Const.ActivityType"
require "LuaScript.Mode.Const.GiftType"
require "LuaScript.Mode.Const.AnimationType"
require "LuaScript.Mode.Const.PlatformType"
require "LuaScript.Mode.Const.PanelOperateType"
require "LuaScript.Mode.Const.SkillType"
require "LuaScript.Mode.Const.LjPlatformType"
require "LuaScript.Mode.Const.ServerNum"
require "LuaScript.Mode.Const.ItemType"

bt = false -- 是否读取变态服数据表
local YJManager = luanet.import_type("YJManager")
if YJManager and YJManager.GetMetaData("config_bt") == "yes" then
	bt = true
end
if bt then
	require "LuaScript.Mode.BT_CFG.InitCFG"
else
	require "LuaScript.Mode.CFG.InitCFG"
end

require "LuaScript.Mode.CSClass.System.FileMode"
require "LuaScript.Mode.CSClass.System.Convert"
require "LuaScript.Mode.CSClass.System.PathFindManager"
require "LuaScript.Mode.CSClass.UnityEngine.Rect"
require "LuaScript.Mode.CSClass.System.File"
require "LuaScript.Mode.CSClass.System.FileInfo"
require "LuaScript.Mode.CSClass.System.Directory"
-- require "LuaScript.Mode.CSClass.System.Encoding"
require "LuaScript.Mode.CSClass.UnityEngine.Resources"
require "LuaScript.Mode.CSClass.UnityEngine.AssetBundle"
require "LuaScript.Mode.CSClass.UnityEngine.GUI"
require "LuaScript.Mode.CSClass.System.Socket"
require "LuaScript.Mode.CSClass.System.ByteArray"
require "LuaScript.Mode.CSClass.UnityEngine.Screen"
-- require "LuaScript.Mode.CSClass.UnityEngine.Vector2"
-- require "LuaScript.Mode.CSClass.UnityEngine.Vector3"
-- require "LuaScript.Mode.CSClass.UnityEngine.Texture2D"
require "LuaScript.Mode.CSClass.UnityEngine.GameObject"
require "LuaScript.Mode.CSClass.UnityEngine.MeshFilter"
require "LuaScript.Mode.CSClass.UnityEngine.Material"
require "LuaScript.Mode.CSClass.UnityEngine.Transform"
require "LuaScript.Mode.CSClass.UnityEngine.Animation"
require "LuaScript.Mode.CSClass.UnityEngine.Renderer"
require "LuaScript.Mode.CSClass.UnityEngine.GUIStyle"
require "LuaScript.Mode.CSClass.UnityEngine.Camera"
require "LuaScript.Mode.CSClass.UnityEngine.Space"
require "LuaScript.Mode.CSClass.UnityEngine.Object"
require "LuaScript.Mode.CSClass.UnityEngine.Input"
require "LuaScript.Mode.CSClass.UnityEngine.GUIContent"
require "LuaScript.Mode.CSClass.UnityEngine.TextEditor"
require "LuaScript.Mode.CSClass.UnityEngine.BoxCollider"
require "LuaScript.Mode.CSClass.UnityEngine.AudioSource"
require "LuaScript.Mode.CSClass.UnityEngine.Physics"
require "LuaScript.Mode.CSClass.UnityEngine.RaycastHit"
require "LuaScript.Mode.CSClass.UnityEngine.AudioListener"
-- require "LuaScript.Mode.CSClass.System.Int32"
-- require "LuaScript.Mode.CSClass.System.double"
-- require "LuaScript.Mode.CSClass.System.Dns"
require "LuaScript.Mode.CSClass.UnityEngine.KeyCode"
require "LuaScript.Mode.CSClass.UnityEngine.Event"
require "LuaScript.Mode.CSClass.UnityEngine.UnityEventType"
require "LuaScript.Mode.CSClass.UnityEngine.MouseButton"
require "LuaScript.Mode.CSClass.UnityEngine.SleepTimeout"
require "LuaScript.Mode.CSClass.UnityEngine.Application"
require "LuaScript.Mode.CSClass.UnityEngine.GUIUtility"
require "LuaScript.Mode.CSClass.UnityEngine.Time"
require "LuaScript.Mode.CSClass.UnityEngine.ParticleEmitter"
require "LuaScript.Mode.CSClass.UnityEngine.WWWForm"
require "LuaScript.Mode.CSClass.UnityEngine.WWW"

mLoader = require "LuaScript.Mode.Object.Loader"
mSDK = require "LuaScript.Mode.Object.SDK"

GUI.Init()
-- Screen.SetResolution(1186, 640, false)

require "LuaScript.View.Panel.Item.ItemCell"

Alert = require "LuaScript.View.Alert.Alert"
PromptAlert = require "LuaScript.View.Alert.PromptAlert"
SelectAlert = require "LuaScript.View.Alert.SelectAlert"
mHotFixPanel = require "LuaScript.View.Panel.HotFixPanel"
mLoginPanel = require "LuaScript.View.Panel.Login.LoginPanel"
mSystemTip = require "LuaScript.View.Tip.SystemTip"
mHeroTip = require "LuaScript.View.Tip.HeroTip"
-- mSceneTip = require "LuaScript.View.Tip.SceneTip"
mSmallMap = require "LuaScript.View.Panel.Map.MapPanel"
mShopPanel = require "LuaScript.View.Panel.Harbor.ShopPanel"
mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
-- 
mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
mTavernPanel = require "LuaScript.View.Panel.Harbor.TavernPanel"
mShipyardPanel = require "LuaScript.View.Panel.Harbor.ShipyardPanel"
mLogbookPanel = require "LuaScript.View.Panel.LogbookPanel"
mMainBuildPanel = require "LuaScript.View.Panel.Harbor.MainBuildPanel"
mBattleViewPanel = require "LuaScript.View.Panel.View.BattleViewPanel"
mFamilyCreatePanel = require "LuaScript.View.Panel.Family.FamilyCreatePanel"
mFamilyListPanel = require "LuaScript.View.Panel.Family.FamilyListPanel"
mFamilyPanel = require "LuaScript.View.Panel.Family.FamilyPanel"
mFriendPanel = require "LuaScript.View.Panel.Friend.FriendPanel"
mMainPanel = require "LuaScript.View.Panel.Main.Main"
mChatPanel = require "LuaScript.View.Panel.Chat.ChatPanel"
mFriendChatPanel = require "LuaScript.View.Panel.Friend.FriendChatPanel"
mLoadPanel = require "LuaScript.View.Panel.LoadPanel"
mDialogPanel = require "LuaScript.View.Panel.Task.DialogPanel"
mBattleAwardPanel = require "LuaScript.View.Panel.Battle.BattleAwardPanel"
mAddItemTip = require "LuaScript.View.Tip.AddItemTip"
mBorderPanel = require "LuaScript.View.Panel.BorderPanel"
mNoticePanel = require "LuaScript.View.Panel.Chat.NoticePanel"
mUpdateNoticePanel = require "LuaScript.View.Panel.Chat.UpdateNoticePanel"
mRechargePanel = require "LuaScript.View.Panel.Recharge.RechargePanel"
mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
mShipEquipViewPanel = require "LuaScript.View.Panel.Equip.ShipEquipViewPanel"
mSailorViewPanel = require "LuaScript.View.Panel.Sailor.SailorViewPanel"
mPackageViewPanel = require "LuaScript.View.Panel.Item.PackageViewPanel"
mMainPanel = require "LuaScript.View.Panel.Main.Main"
mAwardViewPanel = require "LuaScript.View.Panel.BossList.AwardViewPanel"

Alert.Init()
PromptAlert.Init()
SelectAlert.Init()
mFriendChatPanel.Init()
mDialogPanel.Init()
mUpdateNoticePanel.Init()
mRechargePanel.Init()


-- mSea = require "LuaScript.View.Scene.Sea"
mMap = require "LuaScript.View.Scene.Map"


-- mSea.Init()
mMap.Init()

mNetManager = require "LuaScript.Control.System.NetManager"
mEventManager = require "LuaScript.Control.EventManager"
mPanelManager = require "LuaScript.Control.PanelManager"
mHarborManager = require "LuaScript.Control.Scene.HarborManager"
mHeroManager = require "LuaScript.Control.Scene.HeroManager"
mSetManager = require "LuaScript.Control.System.SetManager"
mAudioManager = require "LuaScript.Control.System.AudioManager"
mCameraManager = require "LuaScript.Control.CameraManager"
mBulletManager = require "LuaScript.Control.Scene.BulletManager"
mBombEffectManager = require "LuaScript.Control.Scene.BombEffectManager"
mBattleFieldManager = require "LuaScript.Control.Data.BattleFieldManager"
mCharManager = require "LuaScript.Control.Scene.CharManager"
mMoveManager = require "LuaScript.Control.Scene.MoveManager"
mPathManager = require "LuaScript.Control.Scene.PathManager"
mSeagullManager = require "LuaScript.Control.Scene.SeagullManager"
mFishManager = require "LuaScript.Control.Scene.FishManager"
mChatManager = require "LuaScript.Control.Data.ChatManager"
mGoodsManager = require "LuaScript.Control.Data.GoodsManager"
mSendManager = require "LuaScript.Control.Scene.SendManager"
mWaveManager = require "LuaScript.Control.Scene.WaveManager"
mSpindriftManager = require "LuaScript.Control.Scene.SpindriftManager"
mShipManager = require "LuaScript.Control.Data.ShipManager"
mSailorManager = require "LuaScript.Control.Data.SailorManager"
mLabManager = require "LuaScript.Control.Data.LabManager"
mEquipManager = require "LuaScript.Control.Data.EquipManager"
mSceneManager = require "LuaScript.Control.Scene.SceneManager"
mItemManager = require "LuaScript.Control.Data.ItemManager"
mCloudManager = require "LuaScript.Control.Scene.CloudManager"
mRelationManager = require "LuaScript.Control.Data.RelationManager"
mShipResManager = require "LuaScript.Control.Data.ShipResManager"
mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
mLogbookManager = require "LuaScript.Control.Data.LogbookManager"
mCopyMapManager = require "LuaScript.Control.Data.CopyMapManager"
mAssetManager = require "LuaScript.Control.AssetManager"
mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
mGuideManager = require "LuaScript.Control.Data.GuideManager"
mTaskManager = require "LuaScript.Control.Data.TaskManager"
mAccountManager = require "LuaScript.Control.Data.AccountManager"
mShipTeamManager = require "LuaScript.Control.Data.ShipTeamManager"
mNpcShipTeamManager = require "LuaScript.Control.Data.NpcShipTeamManager"
mAnimationManager = require "LuaScript.Control.Data.AnimationManager"
mShipEquipManager = require "LuaScript.Control.Data.ShipEquipManager"
mTargetManager = require "LuaScript.Control.Scene.TargetManager"
m3DTextManager = require "LuaScript.Control.Scene.3DTextManager"
mTreasureManager = require "LuaScript.Control.Scene.TreasureManager"
mActivityManager = require "LuaScript.Control.Data.ActivityManager"
mVipManager = require "LuaScript.Control.Data.VipManager"
mGiftListManager = require "LuaScript.Control.Data.GiftListManager"
mSkillManager = require "LuaScript.Control.Scene.SkillManager"
mTimeCheckManager = require "LuaScript.Control.System.TimeCheckManager"
mRankManager = require "LuaScript.Control.Data.RankManager"
mPassManager = require "LuaScript.Control.Data.PassManager"
mStarFateManager = require "LuaScript.Control.Data.StarFateManager"
mAutoBusinessManager = require "LuaScript.Control.Data.AutoBusinessManager"
mBattleTargetManager = require "LuaScript.Control.Scene.BattleTargetManager"
mDailyManager = require "LuaScript.Control.Data.DailyManager"
mActionManager = require "LuaScript.Control.ActionManager"
require "LuaScript.TablePlus"

-- mSceneManager = require "LuaScript.Control.Scene.SceneManager"
-- print(mPanelManager)
-- print(CsGetName)
mActionManager.Init()
mBattleTargetManager.Init()
mAccountManager.Init()
mGuideManager.Init()
mHeroManager.Init()
mHarborManager.Init()
-- mNetManager.Init()
mAudioManager.Init()
mSetManager.Init()
mCameraManager.Init()
mBulletManager.Init()
mBombEffectManager.Init()
mBattleFieldManager.Init()
mMoveManager.Init()
-- mPathManager.Init()
mSeagullManager.Init()
if VersionCode > 1 then
	mFishManager.Init()
end
mChatManager.Init()
mGoodsManager.Init()
mSendManager.Init()
mWaveManager.Init()
mSpindriftManager.Init()
mShipManager.Init()
mSailorManager.Init()
mLabManager.Init()
mEquipManager.Init()
mSceneManager.Init()
mItemManager.Init()
mCloudManager.Init()
mRelationManager.Init()
mShipResManager.Init()
mFamilyManager.Init()
mLogbookManager.Init()
mCopyMapManager.Init()
mAssetManager.Init()
mGUIStyleManager.Init()
mTaskManager.Init()
mShipTeamManager.Init()
mNpcShipTeamManager.Init()
mAnimationManager.Init()
mTargetManager.Init()
m3DTextManager.Init()
mShipEquipManager.Init()
mTreasureManager.Init()
mActivityManager.Init()
mVipManager.Init()
mGiftListManager.Init()
mSkillManager.Init()
mTimeCheckManager.Init()
mRankManager.Init()
mPassManager.Init()
mStarFateManager.Init()
mAutoBusinessManager.init()
mDailyManager.Init()

mSDK.Init()
mChatPanel.Init()
mFriendPanel.Init()


mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
mCommonlyFunc.Init()

mPanelManager.Show(mLoginPanel)
-- mPanelManager.Show(mChatPanel)
mPanelManager.Show(mHotFixPanel)
-- mPanelManager.Show(mSystemTip)
-- mPanelManager.Show(mHeroTip)
-- mPanelManager.Show(mAddItemTip)
mPanelManager.Show(mBorderPanel)
-- mPanelManager.Show(mNoticePanel)

_G.UpdateTime = 0
_G.UpdateSecondTime = {}
_G.UpdateSecondTime2 = {}

_G.OnUpdateEvent = {}
_G.OnUpdateEvent.EventList = {}
_G.OnUpdateEvent.Add = function(key, func)
	if _G.OnUpdateEvent.EventList[key] ~= nil then
		print("has the same key: " .. key .. "\n" .. debug.traceback())
		return
	end
	OnUpdateEvent.EventList[key] = func
end
_G.OnUpdateEvent.Remove = function(key)
	if not key then return end
	if OnUpdateEvent.EventList[key] == nil then
		print("not contains key: " .. key .. "\n" .. debug.traceback())
		return
	end
	OnUpdateEvent.EventList[key] = nil
end

function Update()
	for _, v in pairs(OnUpdateEvent.EventList) do
		v()
	end
	-- SaveLog("Update ")
	-- print("Update")
	local _now2 = os._clock()
	
	local now = os.clock()
	local nowTime = os.time()
	os.oldClock = os.oldClock or os.clock()
	os.oldTime = os.oldTime or os.time()
	os.deltaTime = now - os.oldClock
	os.oldClock = now
	os.oldTime = nowTime
	
	local hero = mHeroManager.GetHero()
	if hero then
		if hero.SceneType ~= SceneType.Harbor then
			-- local _now = 0
			-- if _G.IsDebug then
				-- _now = os._clock()
			-- end
			
			
			-- local _now = os._clock()
			
			
			mMap.FixUpdate()
			
			mMainPanel.Update()

			-- time11 = os._clock() - _now
			-- local _now = os._clock()
			
			
			mHeroManager.Update()
			
			-- time22 = os._clock() - _now
			-- local _now = os._clock()
			
			
			
			mCameraManager.Update()
			-- time33 = os._clock() - _now
			-- local _now = os._clock()
			
			mSeagullManager.Update()
			-- time44 = os._clock() - _now
			-- local _now = os._clock()
			
			mCloudManager.Update()
			-- time55 = os._clock() - _now
			-- local _now = os._clock()
			mSceneManager.Update()
			-- time66 = os._clock() - _now
			-- local _now = os._clock()
			mCharManager.Update()
			-- time77 = os._clock() - _now
			-- local _now = os._clock()
			mNpcShipTeamManager.Update()
			-- time88 = os._clock() - _now
			-- local _now = os._clock()
			
			
			mMap.Update()
			
			-- time99 = os._clock() - _now
			
			
		end
		-- local _now = os._clock()
		mHeroManager.Heartbeat()
		-- time110 = os._clock() - _now
	end
	
	-- local _now = os._clock()
	Timer.Update()
	-- time111 = os._clock() - _now
	-- local _now = os._clock()
	Loader.Update()
	-- time112 = os._clock() - _now
	-- local _now = os._clock()
	Socket.Update()
	-- time113 = os._clock() - _now
	
	if _G.IsDebug then
		local t =os.time()
		_G.UpdateSecondTime[t] = _G.UpdateSecondTime[t] or 0
		_G.UpdateSecondTime[t] = _G.UpdateSecondTime[t] + os._clock() - _now2
		_G.UpdateSecondTime[-t] = _G.UpdateSecondTime[-t] or 0
		_G.UpdateSecondTime[-t] = _G.UpdateSecondTime[-t] + 1
		
		-- _G.UpdateSecondTime2[1] = (_G.UpdateSecondTime2[1] or 0) + (time11 or 0)
		-- _G.UpdateSecondTime2[2] = (_G.UpdateSecondTime2[2] or 0) + (time22 or 0)
		-- _G.UpdateSecondTime2[3] = (_G.UpdateSecondTime2[3] or 0) + (time33 or 0)
		-- _G.UpdateSecondTime2[4] = (_G.UpdateSecondTime2[4] or 0) + (time44 or 0)
		-- _G.UpdateSecondTime2[5] = (_G.UpdateSecondTime2[5] or 0) + (time55 or 0)
		-- _G.UpdateSecondTime2[6] = (_G.UpdateSecondTime2[6] or 0) + (time66 or 0)
		-- _G.UpdateSecondTime2[7] = (_G.UpdateSecondTime2[7] or 0) + (time77 or 0)
		-- _G.UpdateSecondTime2[8] = (_G.UpdateSecondTime2[8] or 0) + (time88 or 0)
		-- _G.UpdateSecondTime2[9] = (_G.UpdateSecondTime2[9] or 0) + (time99 or 0)
		-- _G.UpdateSecondTime2[10] = (_G.UpdateSecondTime2[10] or 0) + (time110 or 0)
		-- _G.UpdateSecondTime2[11] = (_G.UpdateSecondTime2[11] or 0) + (time111 or 0)
		-- _G.UpdateSecondTime2[12] = (_G.UpdateSecondTime2[12] or 0) + (time112 or 0)
		-- _G.UpdateSecondTime2[13] = (_G.UpdateSecondTime2[13] or 0) + (time113 or 0)
		
	end
end

function OnDestroy()
	if platform then
		mSDK.ExitSDK()
	end
	mNetManager.Destroy(true)
end

Application.SetTargetFrameRate(30)
Screen.SetSleepTimeout(SleepTimeout.NeverSleep)
string.len = function(str)
	if CsStringLength then
		return CsStringLength(str)
	else
		return cs_Base:StringLength(str)
	end
end

if mSetManager.GetAudio() then
	mAudioManager.StartAudio()
	mSceneManager.PlayerAudio()
else
	mAudioManager.StopAudio()
end
_G.startTime = os.date("%x %X")
-- GUI.Init()
