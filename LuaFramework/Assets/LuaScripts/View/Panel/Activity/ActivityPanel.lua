local _G,Screen,Language,GUI,ByteArray,print,Texture2D,Vector2,pairs,CFG_buildDesc,string = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,Vector2,pairs,CFG_buildDesc,string
local PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor,CFG_lib = 
PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor,CFG_lib
local SceneType,ConstValue,EventType,ActivityType,ActivityButton,ActivityName,Input,KeyCode = 
SceneType,ConstValue,EventType,ActivityType,ActivityButton,ActivityName,Input,KeyCode
local mAssetManager = nil
local mNetManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mFamilyManager = nil
local mGUIStyleManager = nil
local mMainPanel = nil
local mTavernPanel = nil
local mShopPanel = nil
local mShipyardPanel = nil
local mSystemTip = nil
local mHeroManager = nil
local mCommonlyFunc = nil
local mFamilyMemberPanel = nil
local mFamilyRecordPanel = nil
local mFamilyApplyerPanel = nil
local mFamilyNoticePanel = nil
local mEventManager = nil
local mHarborBattlePanel = nil
local mActivityManager = nil
local mEnemyTreasurePanel = nil
local mEmenyAttackPanel = nil
local mCollectTreasureMapPanel = nil
local mGiftListPanel = nil
local mRMBShopPanel = nil
local mDeadGamePanel = nil
local mCostAwardPanel = nil
local mFishPanel = nil
local mGoodsPanel = nil
local mGamblePanel = nil
local mMonthCardPanel = nil

module("LuaScript.View.Panel.Activity.ActivityPanel")
local mActivity = nil
local mActivityList = nil
local mScrollPositionX = 0

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mTavernPanel = require "LuaScript.View.Panel.Harbor.TavernPanel"
	mShopPanel = require "LuaScript.View.Panel.Harbor.ShopPanel"
	mShipyardPanel = require "LuaScript.View.Panel.Harbor.ShipyardPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	mDeadGamePanel = require "LuaScript.View.Panel.Activity.DeadGame.DeadGamePanel"
	mGamblePanel = require "LuaScript.View.Panel.Activity.Gamble.GamblePanel"

	mFamilyNoticePanel = require "LuaScript.View.Panel.Family.FamilyNoticePanel"
	mEventManager = require "LuaScript.Control.EventManager"
	
	mHarborBattlePanel = require "LuaScript.View.Panel.Activity.HarborBattle.HarborBattlePanel"
	mRechangeAwardPanel = require "LuaScript.View.Panel.Activity.RechangeAward.RechangeAwardPanel"
	mLevelAwardPanel = require "LuaScript.View.Panel.Activity.LevelAward.LevelAwardPanel"
	mFirstRechangePanel = require "LuaScript.View.Panel.FirstRechange.FirstRechange"
	mGoodDrinkingPanel = require "LuaScript.View.Panel.Activity.GoodDrinking.GoodDrinkingPanel"
	mEnemyTreasurePanel = require "LuaScript.View.Panel.Activity.EnemyTreasure.EnemyTreasurePanel"
	mEmenyAttackPanel = require "LuaScript.View.Panel.Activity.EmenyAttack.EmenyAttackPanel"
	mCollectTreasureMapPanel = require "LuaScript.View.Panel.Activity.CollectTreasureMap.CollectTreasureMapPanel"
	mGiftListPanel = require "LuaScript.View.Panel.Activity.GiftList.GiftListPanel"
	mRMBShopPanel = require "LuaScript.View.Panel.Activity.RMBShop.RMBShopPanel"
	mCostAwardPanel = require "LuaScript.View.Panel.Activity.CostAward.CostAwardPanel"
	mFishPanel = require "LuaScript.View.Panel.Activity.Fish.FishPanel"
	mGoodsPanel = require "LuaScript.View.Panel.Activity.Goods.GoodsPanel"
	mMonthCardPanel = require "LuaScript.View.Panel.Activity.MonthCard.MonthCardPanel"
	
	mHarborBattlePanel.Init()
	mRechangeAwardPanel.Init()
	mLevelAwardPanel.Init()
	mFirstRechangePanel.Init()
	mGoodDrinkingPanel.Init()
	mEnemyTreasurePanel.Init()
	mEmenyAttackPanel.Init()
	mCollectTreasureMapPanel.Init()
	mGiftListPanel.Init()
	mRMBShopPanel.Init()
	mDeadGamePanel.Init()
	mCostAwardPanel.Init()
	mFishPanel.Init()
	mGoodsPanel.Init()
	mGamblePanel.Init()
	mMonthCardPanel.Init()
	
	IsInit = true
end

function SetData(activity)
	mActivity = activity -- 目前选中的活动面板
end

function Display()
	mActivityList = mActivityManager.GetActivityList()
	mActivity = mActivity or mActivityList[1].id
	
	if mActivity == ActivityType.LevelAward then
		mLevelAwardPanel.Display()
	elseif mActivity == ActivityType.RechangeAward then
		mRechangeAwardPanel.Display()
	elseif mActivity == ActivityType.CostAward then
		mCostAwardPanel.Display()
	elseif mActivity == ActivityType.GiftList then
		mGiftListPanel.Display()
	elseif mActivity == ActivityType.GOODS then
		mGoodsPanel.Display()
	elseif mActivity == ActivityType.Fish then
		mFishPanel.Display()
	end
end

function Hide()
	mActivity = nil
	mSceneManager.SetMouseEvent(true)
	mScrollPositionX = 0
end

function OnGUI()
	if not IsInit then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg26_1")
	GUI.DrawTexture(80,100,977,528,image)
	
	if mActivity ~= ActivityType.FirstRechange then 
		local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
		GUI.DrawTexture(23.75,37.5,53,58,image)
		local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
		GUI.DrawTexture(83.5,37.5,1016.75-50,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
		GUI.Label(525.5,48,84.2,30,ActivityName[mActivity], GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	end
	
	local spacing = 165
	local count = #mActivityList
	--按钮绘制
	mScrollPositionX,_ = GUI.BeginScrollView(125,462,875,200, mScrollPositionX, 0, 0, 0,count*spacing+47, 160, 1)
		for index=1,count,1 do
			local activity = mActivityList[index]
			local x = spacing * (index - 1) + 30
			if mActivity == activity.id then
				GUI.Button(x,0,142,157,nil, ActivityButton[activity.id][2]) -- 选中的带的边框
			else
				if GUI.Button(x,0,142,157,nil, ActivityButton[activity.id][1]) then
					mActivity = activity.id
					
					if activity.id == ActivityType.LevelAward then -- 等级礼包
						mLevelAwardPanel.Display()
					elseif activity.id == ActivityType.RechangeAward then  -- 首冲奖励直接发放
						mRechangeAwardPanel.Display()
					elseif activity.id == ActivityType.CostAward then -- 消费一定额度奖励直接发放
						mCostAwardPanel.Display()
					elseif activity.id == ActivityType.GiftList then -- 可领取礼包列表
						mGiftListPanel.Display()
					elseif mActivity == ActivityType.GOODS then -- 流行货品
						mGoodsPanel.Display()
					elseif mActivity == ActivityType.Fish then -- 捕鱼活动
						mFishPanel.Display()
					elseif mActivity == ActivityType.MonthCard then -- 月卡和终身卡
						mMonthCardPanel.Display()
					end
				end
			end
			if activity.state then -- 活动状态叹号提示
				local image = mAssetManager.GetAsset("Texture/Gui/Bg/sigh")
				GUI.DrawTexture(x+95,15,35,35,image)
			end
			
		end
	GUI.EndScrollView()
	
	-- local activity = mActivityList[mPage]
	
	 -- 绘制对应面板内容
	if mActivity == ActivityType.FirstRechange then
		mFirstRechangePanel.OnGUI() -- 首冲礼包，不放活动中，在新首冲面板
	elseif mActivity == ActivityType.LevelAward then
		mLevelAwardPanel.OnGUI() -- 等级奖励
	elseif mActivity == ActivityType.RechangeAward then
		mRechangeAwardPanel.OnGUI() -- 充值好礼
	elseif mActivity == ActivityType.GoodDrinking then
		mGoodDrinkingPanel.OnGUI() -- 美酒佳酿
	elseif mActivity == ActivityType.HarborBattle then
		mHarborBattlePanel.OnGUI() -- 港口争霸
	elseif mActivity == ActivityType.EnemyTreasure then
		mEnemyTreasurePanel.OnGUI() -- 擒王夺宝
	elseif mActivity == ActivityType.EmenyAttack then
		mEmenyAttackPanel.OnGUI() -- 冥界来袭
	elseif mActivity == ActivityType.CollectTreasureMap then
		mCollectTreasureMapPanel.OnGUI() -- 寻图探宝
	elseif mActivity == ActivityType.GiftList then
		mGiftListPanel.OnGUI() -- 礼包列表
	elseif mActivity == ActivityType.RMBShop then
		mRMBShopPanel.OnGUI() -- 元宝商城，奇珍异宝
	elseif mActivity == ActivityType.DeadGame then
		mDeadGamePanel.OnGUI() -- 死亡游戏
	elseif mActivity == ActivityType.CostAward then
		mCostAwardPanel.OnGUI() -- 活动期间消费一定额度送好礼
	elseif mActivity == ActivityType.Fish then
		mFishPanel.OnGUI() -- 捕鱼达人
	elseif mActivity == ActivityType.GOODS then
		mGoodsPanel.OnGUI() -- 货物运输，风靡全球
	elseif mActivity == ActivityType.Gamble then
		mGamblePanel.OnGUI() -- 秘境寻宝
	elseif mActivity == ActivityType.MonthCard then
		mMonthCardPanel.OnGUI() -- 月卡	
	end
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		Close()
	end
end

function Close()
	mPanelManager.Show(mMainPanel)
	mPanelManager.Hide(OnGUI)
	mSceneManager.SetMouseEvent(true)
end