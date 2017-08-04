local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Ship,ConstValue,CharacterType = 
print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Ship,ConstValue,CharacterType
local PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent = 
PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent
local GameObject,CFG_ship,CFG_role,CFG_harbor,AudioData,Packat_Enemymerchant,CsSetPosition,CFG_UniqueSailor,GetTransform = 
GameObject,CFG_ship,CFG_role,CFG_harbor,AudioData,Packat_Enemymerchant,CsSetPosition,CFG_UniqueSailor,GetTransform
local CsRotate,CFG_map,CsSetName,GetComponentInChildren,CFG_EnemyPosition,CsSetParent,Color,CFG_item,string, luanet = 
CsRotate,CFG_map,CsSetName,GetComponentInChildren,CFG_EnemyPosition,CsSetParent,Color,CFG_item,string, luanet
local _G,Packat_Award,platform,Animation = _G,Packat_Award,platform,Animation
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mPathFindManager = nil
local mAudioManager = nil
local mCharacter = nil
local mAssetManager = nil
local mEventManager = nil
local mSceneManager = nil
local mLoginPanel = nil
local mCreateHeroPanel = nil
local mSelectHeroPanel = nil
local mLoadPanelPanel = nil
local mPanelManager = nil
local mNetManager = nil
local mMoveManager = nil 
local mCharManager = nil
local mHeroTip = nil
local mEquipManager = nil
local mHarborIntoPanel = nil
-- local mCsSceneTransform = nil
local mShipResManager = nil
local mSailorManager = nil
local mShipManager = nil
local mCameraManager = nil
local mLevelUpTip = nil
local mPowerChangeTip = nil
local mHarborManager = nil
local mTaskManager = nil
local mSendManager = nil
local mSystemTip = nil
local mConnectAlert = nil
local mAddItemTip = nil
local mCloudManager = nil
-- local mMap = nil
local mAlert = nil
local mSetManager = nil
local mLabManager = nil
local mTargetManager = nil
local mBattleManager = nil
-- local mSea = nil
local m3DTextManager = nil
local mItemManager = nil
local mTreasureManager = nil
local mActivityManager = nil
local mShopPanel = nil
local mShipEquipManager = nil
local mFamilyManager = nil
local mPowerUpTip = nil
local mModePanel = nil
local mSDK = nil
local mSceneTip = nil
local mMainPanel = nil
local mActionManager = nil
local mStarFateManager = nil
local mGoodsManager = nil
local mAnimationManager = nil

local JsonObj = nil

--角色相关信息管理
module("LuaScript.Control.Scene.HeroManager")

local mRmbToGold = 10
local mDefaultDiscount = 1
local mAwardLevelPrice = 1000
local mFirstRecharge = true --是否有首充活动
local mSailorLevelUpMoney = 1 --船员升级银两消耗倍率

local mMonthCard = {} --月卡

local mHero = nil

-- local mFinalTarget = nil

-- local mTarget.type = nil
local mTarget = nil
local mFinalTarget = nil
local mLoginAward = nil
local mLockPower = nil

function GetLoginAward()
	return mLoginAward
end

function GetmRmbToGold()
	return mRmbToGold
end

function GetDefaultDiscount()
	return mDefaultDiscount
end

function GetAwardLevelPrice()
	return mAwardLevelPrice
end

function GetFirstRecharge()
	return mFirstRecharge
end

function GetSailorLevelUpMoney()
	return mSailorLevelUpMoney
end

-- 月卡
-- mMonthCard.monthCardEndTime1  大于 servertime  则已购买
-- mMonthCard.monthCardGet1 	0未领取奖励 1已领取
-- mMonthCard.monthCardEndTime2  -1时已购买
-- mMonthCard.monthCardGet2 
function GetMonthCard()
	return mMonthCard
end

-- local mOfferX = 0
-- local mOfferY = 0
function GetTarget()
	return mTarget,mFinalTarget
end

function IsMoving()
	return mFinalTarget or (mHero and mHero.ships and mHero.ships[1] and mHero.ships[1].move)
end

function GetHero()
	return mHero
end

function Reset()
	mHero = nil
end


function Init()
	mAnimationManager = require "LuaScript.Control.Data.AnimationManager"
	mActionManager = require "LuaScript.Control.ActionManager"
	mEquipManager = require "LuaScript.Control.Data.EquipManager"
	mLabManager = require "LuaScript.Control.Data.LabManager"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mSendManager = require "LuaScript.Control.Scene.SendManager"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mPathFindManager = require "LuaScript.Control.Scene.PathManager"
	mCharacter = require "LuaScript.Mode.Object.Character"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mLoginPanel = require "LuaScript.View.Panel.Login.LoginPanel"
	mLoadPanelPanel = require "LuaScript.View.Panel.LoadPanel"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mMoveManager = require "LuaScript.Control.Scene.MoveManager"
	mCreateHeroPanel = require "LuaScript.View.Panel.Login.CreateHeroPanel"
	mHeroTip = require "LuaScript.View.Tip.HeroTip"
	mHarborIntoPanel = require "LuaScript.View.Panel.Harbor.HarborIntoPanel"
	mShipResManager = require "LuaScript.Control.Data.ShipResManager"
	mSailorManager = require "LuaScript.Control.Data.SailorManager"
	mShipManager = require "LuaScript.Control.Data.ShipManager"
	mCameraManager = require "LuaScript.Control.CameraManager"
	mTaskManager = require "LuaScript.Control.Data.TaskManager"
	mLevelUpTip = require "LuaScript.View.Tip.LevelUpTip"
	mPowerChangeTip = require "LuaScript.View.Tip.PowerChangeTip"
	mAudioManager = require "LuaScript.Control.System.AudioManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mConnectAlert = require "LuaScript.View.Alert.ConnectAlert"
	mAddItemTip = require "LuaScript.View.Tip.AddItemTip"
	mCloudManager = require "LuaScript.Control.Scene.CloudManager"
	-- mMap = require "LuaScript.Control.Scene.CloudManager"
	mAlert = require "LuaScript.View.Alert.Alert"
	mTargetManager = require "LuaScript.Control.Scene.TargetManager"
	mBattleManager = require "LuaScript.Control.Data.BattleFieldManager"
	-- mSea = require "LuaScript.View.Scene.Sea"
	m3DTextManager = require "LuaScript.Control.Scene.3DTextManager"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mTreasureManager = require "LuaScript.Control.Scene.TreasureManager"
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	mShopPanel = require "LuaScript.View.Panel.Harbor.ShopPanel"
	mShipEquipManager = require "LuaScript.Control.Data.ShipEquipManager"
	mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	mPowerUpTip = require "LuaScript.View.Panel.PowerUp.PowerUpTip"
	mModePanel = require "LuaScript.View.Panel.Mode.ModePanel"
	mSDK = require "LuaScript.Mode.Object.SDK"
	mSceneTip = require "LuaScript.View.Tip.SceneTip"
	mStarFateManager = require "LuaScript.Control.Data.StarFateManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mGoodsManager = require "LuaScript.Control.Data.GoodsManager"
	
	JsonObj = luanet.import_type("JsonObj")
	
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_PLAYER_INFO, Player_info)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.JOIN_MAP, Join_Map)

	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_MONEY, SEND_MONEY)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_GOLD, SEND_GOLD)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_LEVEL, SEND_LEVEL)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_EXP, SEND_EXP)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_PLAYER_CHG_JOB, SEND_PLAYER_CHG_JOB)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_PLAYER_VIGOR, SEND_PLAYER_VIGOR)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_PLAYER_VIGOR_BUY_COUNT, SEND_PLAYER_VIGOR_BUY_COUNT)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_GIVE_GOLD_TIME, SEND_GIVE_GOLD_TIME)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_VIP_LEVEL, SEND_VIP_LEVEL)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_FIRST_EMPLOY_ORANGE, SEND_FIRST_EMPLOY_ORANGE)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_PROTECT_TIME, SEND_PROTECT_TIME)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_PLAYER_DEAD, SEND_PLAYER_DEAD)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_MONEY_POT_USE_COUNT, SEND_MONEY_POT_USE_COUNT)
	mNetManager.AddListen(PackatHead.AWARD, Packat_Award.SEND_LOGIN_AWARD_INFO, SEND_LOGIN_AWARD_INFO)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_SKILL_ORB_POINT, SEND_SKILL_ORB_POINT)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_CHG_POWER, SEND_CHG_POWER)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_FISH_INFO, SEND_FISH_INFO)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_GAME_INFO, SEND_GAME_INFO)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_MONTH_CARD, SEND_MONTH_CARD)
	
	mEventManager.AddEventListen(nil, EventType.OnMapComplete, MapComplete)
	mEventManager.AddEventListen(nil, EventType.OnLoadComplete, OnLoadComplete)
	-- mEventManager.AddEventListen(nil, EventType.IntoHarbor, OnLoadComplete)
	mEventManager.AddEventListen(nil, EventType.UpdateHeroPower, UpdatePower)
	-- mCsSceneTransform = GameObject.Find("Scene").transform
end

function LockPower(value)
	mLockPower = value
end

function UnLockPower(value)
	if mLockPower == value then
		mLockPower = nil
	end
end

function OnLoadComplete()
	-- print(1)
	-- print("OnLoadComplete")
	-- print(mTarget)
	if not mTarget then
		if mHero.SceneType == SceneType.Normal then
			mMoveManager.ReFollow(mHero.ships[1])
		end
		
		-- if mHero.mode == 0 and mHero.level >= 28 then
			-- mPanelManager.Show(mModePanel)
		-- end
		return
	end
	-- print(mTarget)
	if mTarget.type == ConstValue.HarborType then
		if mHero.SceneType == SceneType.Harbor then
			if mShipManager.CheckDutyShip() then
				mHarborManager.RequestLeaveHarbor()
			end
		else
			local cfg_harbor = CFG_harbor[mTarget.value]
			Goto(cfg_harbor.mapId, cfg_harbor.x, cfg_harbor.y)
		end
	elseif mTarget.type == ConstValue.IntoHarborType then
		if mHero.SceneType == SceneType.Harbor then
			if mShipManager.CheckDutyShip() then
				mHarborManager.RequestLeaveHarbor()
			end
		else
			local cfg_harbor = CFG_harbor[mTarget.value]
			Goto(cfg_harbor.mapId, cfg_harbor.x, cfg_harbor.y)
		end
	elseif mTarget.type == ConstValue.PositionType then
		if mHero.SceneType == SceneType.Harbor then
			if mShipManager.CheckDutyShip() then
				mHarborManager.RequestLeaveHarbor()
			end
		else
			Goto(mTarget.value.map, mTarget.value.x, mTarget.value.y)
		end
	elseif mTarget.type == ConstValue.AttackNearType then
		if mHero.SceneType == SceneType.Harbor then
			if mShipManager.CheckDutyShip() then
				mHarborManager.RequestLeaveHarbor()
			end
		else
			local cfg_EnemyPosition = CFG_EnemyPosition[mTarget.value]
			Goto(cfg_EnemyPosition.MapID, cfg_EnemyPosition.X, cfg_EnemyPosition.Y)
		end
	elseif mTarget.type == ConstValue.PanelType then
		-- if mHero.SceneType == SceneType.Harbor then
			-- mPanelManager.Show(mTarget.value)
			-- if mTarget.value.FullWindowPanel then
				-- mPanelManager.Hide(mMainPanel)
			-- end
		-- end
		local cfg_harbor = CFG_harbor[mTarget.value.harborId]
		Goto(cfg_harbor.mapId, cfg_harbor.x, cfg_harbor.y)
	end
end

function MapComplete()
	if mHero and mHero.SceneType == SceneType.Normal then
		mSceneManager.Update(true)
	end
end

function GetGoldLastTime()
	-- print(mHero.getGoldLastTime , mHero.getGoldUpdateTime , os.oldTime)
	if mHero.getGoldLastTime then
		return mHero.getGoldLastTime + mHero.getGoldUpdateTime - os.oldClock
	else
		return nil
	end
end

function InitHero()
	-- print(11111111)
	local mCharList = mCharManager.GetCharList()
	local mShipList = mCharManager.GetShipList()
	local mCsShipList = mCharManager.GeCsShipList()
	-- local mCsShipColliderList = mCharManager.GetCsShipColliderList()
	mCommonlyFunc.ReviseCharPosition(mHero)
	
	mHero.IsInit = true
	mHero.ships[1].mainShip = true
	for _,ship in pairs(mHero.ships) do
		local cs_ship = mShipResManager.GetShip(ship.bid)
		CsSetName(cs_ship, ship.id)
		
		local transform = GetTransform(cs_ship)
		CsRotate(transform,0,ship.angles,0)
		
		local csShipCollider = GetComponentInChildren(cs_ship,BoxCollider.GetType())
		csShipCollider.enabled = false
		mEventManager.AddEventListen(cs_ship,EventType.OnSink,OnSink)
		mEventManager.AddEventListen(cs_ship,EventType.OnHurt,OnHurt)
		
		mShipList[ship.id] = ship
		mCsShipList[ship.id] = cs_ship
		
		mMoveManager.UpdatePosition(ship)
		
		if mHero.SceneType == SceneType.Battle then
			GetComponentInChildren(cs_ship, Animation.GetType())
		end
	end
	
	mHero.ships[1].lastShip = mHero.ships[2]
	if mHero.ships[2] then
		mHero.ships[2].lastShip = mHero.ships[3]
		mHero.ships[2].perShip = mHero.ships[1]
	end
	if mHero.ships[3] then
		mHero.ships[3].perShip = mHero.ships[2]
	end
	
	mCommonlyFunc.UpdateTitle(mHero)
end

function Update()
	if not mHero.ships then
		return
	end
	local mainShip = mHero.ships[1]
	if mainShip and mainShip.move then
		mMoveManager.Move(mHero, mainShip)
		
		local cfg_map = CFG_map[mHero.map]
		if mHero.x < 0 then
			requestUploadPosition(mainShip)
			
			mSceneManager.ChangeAllX(cfg_map.width)
		elseif mHero.x >= cfg_map.width then
			requestUploadPosition(mainShip)
			
			mSceneManager.ChangeAllX(-cfg_map.width)
		end
		
		mCameraManager.SetView(mHero.x, mHero.y)
		
		-- mSea.SetPosition(mHero.x, mHero.y)
		-- mMoveManager.UpdatePosition(mainShip)
	end
	
	for k,ship in pairs(mHero.ships) do
		ship.LastUploadTime = ship.LastUploadTime or os.oldClock
		if ship.move and os.oldClock - ship.LastUploadTime > ConstValue.UploadTime then
			ship.LastUploadTime = os.oldClock
			requestUploadPosition(ship)
		end
	end
	
	if mTarget and (mTarget.type == ConstValue.PlayerType or mTarget.type == ConstValue.AttackPlayerType) then
		CheckAttackShip(mTarget.value.ship, false)
	end
	
	-- mHero.lastShowTime = mHero.lastShowTime or os.oldClock
	-- if mHero.lastShowTime < os.oldClock - 5 and (mHero.map == 0  or mHero.map == 2)and mHero.ships[1] then
		-- mHero.lastShowTime = os.oldClock
		-- mSceneTip.ShowTip(mHero.ships[1].x,0,mHero.ships[1].y-40, "食物-1", Color.YellowStr)
	-- end
end

function Sink(shipId)
	local ship = mCharManager.GetShip(shipId)
	if ship.mainShip then
		if mHero.ships[2] then
			local nextShip = mHero.ships[2]
			local newX,newY = mCameraManager.GetViewByPos(nextShip.x,nextShip.y)
			local oldX,oldY = mCameraManager.GetView()
			local changeX = newX - oldX
			local changeY = newY - oldY
			mCameraManager.SetOffer(changeX, changeY)
			mCameraManager.SetView(newX, newY)
			mHero.x = nextShip.x
			mHero.y = nextShip.y
			
			mSceneManager.Update(true)
			
			blank = nil
			nextShip.mainShip = true
			requestMoveStop(nextShip)
		end
		-- mSceneManager.SetWaveDir(0, 0)
	end
	
	mCharManager.Sink(shipId)
end

function OnSink(cs_ship)
	mCharManager.OnSink(cs_ship)
end

function OnHurt(cs_ship)
	mCharManager.OnHurt(cs_ship)
end

function Goto(toMap, x, y)
	if not mHero then
		return
	end
	if mHero.SceneType == SceneType.Harbor then
		mHarborManager.RequestLeaveHarbor()
		if not mTarget then
			SetTarget(ConstValue.PositionType, {map=toMap,x=x,y=y})
		end
		return
	elseif toMap ~= mHero.map then
		local send = mSendManager.GetNearSend()
		if not send then
			mSystemTip.ShowTip("无法移至目标点")
			return
		end
		mTarget = {type = ConstValue.SendType, value = send.id}
		x = send.x
		y = send.y
	end
	
	local path = mPathFindManager.FindPath(mHero.x, mHero.y, x, y)
	if path then
		local ship = mHero.ships[1]
		mMoveManager.StarMove(ship ,path)
		mHero.moved = true
		
		AppearEvent(nil,EventType.OnRefreshGuide)
	end
end

function IntoHarbor(id)
	if not mHero then
		return
	end
	if mHero.harborId == id then
		mSystemTip.ShowTip("已在该港口")
		return
	end
	SetTarget(ConstValue.IntoHarborType, id)
	
	if mHero.SceneType == SceneType.Harbor then
		if mShipManager.CheckDutyShip() then
			mHarborManager.RequestLeaveHarbor()
		end
	else
		local cfg_harbor = CFG_harbor[id]
		Goto(cfg_harbor.mapId, cfg_harbor.x, cfg_harbor.y)
	end
end

function GotoHarbor(id)
	if not mHero then
		return
	end
	
	if id == nil then
		id = mHarborManager.GetNearHarbor()
	end
	
	if mHero.harborId == id then
		mSystemTip.ShowTip("已在该港口")
		return
	end
	SetTarget(ConstValue.HarborType, id)
	
	if mHero.SceneType == SceneType.Harbor then
		if mShipManager.CheckDutyShip() then
			mHarborManager.RequestLeaveHarbor()
		end
	else
		local cfg_harbor = CFG_harbor[id]
		Goto(cfg_harbor.mapId, cfg_harbor.x, cfg_harbor.y)
	end
end

function GotoHarborPanel(panel, harborId, selfHarbor)
	-- print(panel, harborId, selfHarbor)
	if not mHero then
		return
	end
	
	if mHero.SceneType == SceneType.Harbor and (not harborId or harborId == mHero.harborId) and (not selfHarbor or mHarborManager.HarborIsMy(mHero.harborId)) then
		mCommonlyFunc.AutoOpenlPanel(panel)
		return
	end
	-- print(11111)
	
	local id = harborId or mHarborManager.GetNearHarbor(selfHarbor)
	SetTarget(ConstValue.PanelType, {panel=panel, harborId=id})
	if mHero.SceneType == SceneType.Harbor then
		if mShipManager.CheckDutyShip() then
			mHarborManager.RequestLeaveHarbor()
		end
		return
	end
	
	local cfg_harbor = CFG_harbor[id]
	Goto(cfg_harbor.mapId, cfg_harbor.x, cfg_harbor.y)
end

function GetModeName()
	if not mHero.ModeName then
		if mHero.level < 28 or mHero.mode == 0 then
			mHero.ModeName = "新手"
		elseif mHero.mode == 1 then
			mHero.ModeName = "和平"
		elseif mHero.mode == 2 then
			mHero.ModeName = "PK"
		end
	end
	return mHero.ModeName
end

function CheckAttackChar(char)
	if CheckAttackShip(char.ships[1],false) or CheckAttackShip(char.ships[2],false) 
		or CheckAttackShip(char.ships[3],false) then
		SetTarget()
	else
		MoveToNearShip(char)
	end
end

function CheckAttackShip(ship, autoChangeTarget)
	if not ship then
		return
	end
	if autoChangeTarget == nil then
		autoChangeTarget = true
	end
	local dis = math.abs(ship.x - mHero.x) + math.abs(ship.y - mHero.y)
	if dis < 50 then
		RequestAttackTarget()
		return true
	elseif autoChangeTarget then
		if not mTarget.value.ship then
			return
		end
		if mTarget.value.ship == ship then
			if mHero.ships[1].move then
				local move = mHero.ships[1].move
				local length = #move.path
				toX = move.path[length-1]
				toY = move.path[length]
				local dis = math.abs(ship.x - toX) + math.abs(ship.y - toY)
				if dis > 50 then
					Goto(mHero.map, ship.x, ship.y)
				end
			else
				Goto(mHero.map, ship.x, ship.y)
			end
		else
			local targetDis = math.abs(mTarget.value.ship.x - mHero.x) + math.abs(mTarget.value.ship.y - mHero.y)
			if targetDis - dis > 50 then
				mTarget.value.ship = ship
				Goto(mHero.map, ship.x, ship.y)
			end
		end
	end
end

function MoveToNearShip(char)
	local ship = nil
	local dis = 1000000
	
	for i=1,3,1 do
		local tship = char.ships[i]
		if not tship then
			break
		end
		local tDis = math.abs(tship.x - mHero.x) + math.abs(tship.y - mHero.y)
		if tDis < dis then
			ship = tship
			dis = tDis
		end
	end
	mTarget.value.ship = ship
	Goto(mHero.map, ship.x, ship.y)
	-- print(mHero.map, ship.x, ship.y)
end

function StarMove(ship, path)
	-- print("StarMove", ship.id)
	if ship.mainShip then
		mTargetManager.Hide()
	end
	if ship.dead then
		return
	end
	requestUploadPath(ship, 1)
	
	-- if ship.mainShip then
		-- AppearEvent(nil,EventType.OnRefreshGuide)
	-- end
end

function StopMove()
	-- print("StopMove")
	if not mHero.ships then
		return
	end
	local ship = mHero.ships[1]
	if ship and ship.move then
		requestMoveStop(ship)
		ship.move = nil
	end
	local ship = mHero.ships[2]
	if ship and ship.move then
		requestMoveStop(ship)
		ship.move = nil
	end
	local ship = mHero.ships[3]
	if ship and ship.move then
		requestMoveStop(ship)
		ship.move = nil
	end
	-- mSceneManager.SetWaveDir(0, 0)
	mFinalTarget = nil
	mTarget = nil
	mTargetManager.Hide()
end

function SetTarget(type, value)
	-- print("SetTarget",type, value)
	if not type or not value then
		mFinalTarget = nil
		mTarget = nil
	else
		mFinalTarget = {type = type, value = value}
		mTarget = mFinalTarget
	end
end

function OverMove(ship)
	-- print("OverMove")
	requestMoveStop(ship)
	
	if not ship.mainShip then
		return
	end
	mTargetManager.Hide()
	
	mTaskManager.CheckAllTask()
	-- mSceneManager.SetWaveDir(0, 0)
	-- print(mTarget)
	if mTarget then
		if mTarget.type == ConstValue.HarborType then
			mHarborIntoPanel.SetData(mTarget.value)
			mPanelManager.Show(mHarborIntoPanel)
		elseif mTarget.type == ConstValue.IntoHarborType then
			mHarborManager.RequestIntoHarbor(mTarget.value)
		elseif mTarget.type == ConstValue.PlayerType then
			RequestAttackTarget()
		elseif mTarget.type == ConstValue.AttackPlayerType then
			RequestAttackTarget()
		elseif mTarget.type == ConstValue.SendType then
			RequestSend()
		elseif mTarget.type == ConstValue.AttackNearType then
			local enemy = mCharManager.GetNearEnemy(mTarget.value)
			if enemy then
				SetTarget(ConstValue.AttackPlayerType, {char=enemy})
				CheckAttackChar(enemy)
			end
		elseif mTarget.type == ConstValue.TreasureType then
			mTreasureManager.OpenTreasure()
		elseif mTarget.type == ConstValue.BattleField then
			-- print(mTarget.value)
			mBattleManager.RequestJoin(mTarget.value.battleFieldId, mTarget.value.teamId)
		elseif mTarget.type == ConstValue.PanelType then
			mHarborManager.RequestIntoHarbor(mHarborManager.GetNearHarbor())
			mMainPanel.AutoPanel(mTarget.value.panel)
		end
	end
	
	if mTarget == mFinalTarget then
		mFinalTarget = nil
		mTarget = nil
	else
		mTarget = mFinalTarget
	end
	
	AppearEvent(nil,EventType.OnRefreshGuide)
end

function NodeOver(ship)
	requestUploadPath(ship, 0)
end

function InitTitle()
	mHero.csTitle = m3DTextManager.GetHeroTitle(mHero.titleName, mHero.level, mHero.resId)
end

function UpdatePower()
	-- print("UpdatePower!!!!!!!!!!!!!!!")
	if not mHero then
		return
	end
	local equipPower = mEquipManager.GetTotalPower()
	local sailorPower = mSailorManager.GetTotalPower()
	local shipPower = mShipManager.GetTotalPower()
	local shipEquipPower = mShipEquipManager.GetTotalPower()
	local labPower = mLabManager.GetTotalPower()
	local starPower = mStarFateManager.GetTotalPower()
	
	-- local power = equipPower + sailorPower + shipPower + labPower + shipEquipPower + starPower
	-- print(power, mHero.power )
	-- if power ~= mHero.power and mHero.power ~= 0 then
		-- mPowerChangeTip.ShowTip(mHero.power, power)
	-- end
	-- mHero.power = power
	
	mHero.business = mSailorManager.GetTotleBusiness()
end

function RequestAttackTarget()
	-- print("RequestAttackTarget")
	local char = mCharManager.GetChar(mTarget.value.char.id)
	if not char then
		-- print("111111!!!!!!11111")
		mTarget = nil
		mFinalTarget = nil
		-- mSystemTip.ShowTip("攻击目标已不在附近")
		return
	end
	if mTarget.value.attackTime and os.oldClock - mTarget.value.attackTime < 0.5 then
		return
	end
	mTarget.value.attackTime = os.oldClock
	if mTarget.value.char.type == CharacterType.NpcShipTeam then
		local cs_ByteArray = ByteArray.Init()
		ByteArray.WriteByte(cs_ByteArray,PackatHead.ENEMYMERCHANT)
		ByteArray.WriteByte(cs_ByteArray,Packat_Enemymerchant.CLIENT_REQUEST_ATTACK_ENEMY_MERCHANT)
		ByteArray.WriteInt(cs_ByteArray,mTarget.value.char.id)
		mNetManager.SendData(cs_ByteArray)
	else
		RequestAttack(mTarget.value.char.type, mTarget.value.char.id)
	end
end

function RequestAttack(type, id)
	local char = mCharManager.GetChar(id)
	local battleId,team = mBattleManager.GetBattleFieldId(type, id)
	if battleId then
		mBattleManager.RequestAttack(battleId, team)
	else
		local cs_ByteArray = ByteArray.Init()
		ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
		ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_REQUEST_START_BATTLE)
		ByteArray.WriteInt(cs_ByteArray,id)
		ByteArray.WriteByte(cs_ByteArray,type)
		mNetManager.SendData(cs_ByteArray)
	end
end

function RequestSelectMode(type)
	-- print("RequestSelectMode", type)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_REQUEST_CHOOSE_MODE)
	ByteArray.WriteByte(cs_ByteArray,type)
	mNetManager.SendData(cs_ByteArray)
end

function Heartbeat()
	local overTime = os.oldTime - (mLastHeartbeatTime or 0)
	if overTime >= 30 then
		mLastHeartbeatTime = os.oldTime
		
		local cs_ByteArray = ByteArray.Init()
		ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
		ByteArray.WriteByte(cs_ByteArray,Packat_Player.SPEED_UP_CHECK)
		ByteArray.WriteInt(cs_ByteArray,os.oldTime)
		mNetManager.SendData(cs_ByteArray)
	end
end

function RequestSend(sendId)
	print("send" , sendId or mTarget.value)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_REQUEST_ENTER_PORTAL)
	ByteArray.WriteInt(cs_ByteArray,sendId or mTarget.value)
	mNetManager.SendData(cs_ByteArray)
end

function requestUploadPosition(ship)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_SET_POS)
	ByteArray.WriteInt(cs_ByteArray,ship.index)
	ByteArray.WriteShort(cs_ByteArray,math.floor(ship.x))
	ByteArray.WriteShort(cs_ByteArray,ship.y)
	ByteArray.WriteShort(cs_ByteArray,GetBlank(ship))
	mNetManager.SendData(cs_ByteArray)
end

function requestUploadPath(ship, override)
	-- print("requestUploadPath", ship.x)
	
	if ship.dead then
		return
	end
	if not ship.mainShip then
		return
	end
	
	local cfg_map = CFG_map[mHero.map]
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_MOVE_TO)
	ByteArray.WriteInt(cs_ByteArray,ship.index)
	ByteArray.WriteInt(cs_ByteArray,ship.cid)
	ByteArray.WriteShort(cs_ByteArray,math.clamp(ship.x,0,cfg_map.width-1))
	ByteArray.WriteShort(cs_ByteArray,ship.y)
	ByteArray.WriteShort(cs_ByteArray,ship.move.path[1])
	ByteArray.WriteShort(cs_ByteArray,ship.move.path[2])
	ByteArray.WriteByte(cs_ByteArray,override)
	ByteArray.WriteShort(cs_ByteArray,GetBlank(ship))
	ByteArray.WriteByte(cs_ByteArray,mHero.map)
	mNetManager.SendData(cs_ByteArray)
end

function GetBlank(ship)
	if not ship.mainShip then
		return 0
	end
	local value = 60000
	if blank  then
		value = math.min((os.oldClock-blank)*1000, 60000)
	end
	blank = os.oldClock
	return value
end

function requestMoveStop(ship)

	-- print("requestMoveStop",ship.id)
	-- print("requestMoveStop", ship.x)
	local cfg_map = CFG_map[mHero.map]
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_STOP)
	ByteArray.WriteInt(cs_ByteArray,ship.cid)
	ByteArray.WriteInt(cs_ByteArray,ship.index)
	ByteArray.WriteShort(cs_ByteArray,math.clamp(ship.x,0,cfg_map.width-1))
	ByteArray.WriteShort(cs_ByteArray,ship.y)
	ByteArray.WriteShort(cs_ByteArray,GetBlank(ship))
	mNetManager.SendData(cs_ByteArray)
end


function requestBuyMoney(exMoney)
	local cfg_map = CFG_map[mHero.map]
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_SEND_BUY_MONEY)
	ByteArray.WriteInt(cs_ByteArray,exMoney)
	mNetManager.SendData(cs_ByteArray)
end

function requestJoinMapCompete()
	-- print("requestJoinMapCompete")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_REPLY_JOIN_MAP)
	mNetManager.SendData(cs_ByteArray)
end

function RequestFly(mapId, x, y, harborId)
	function okFunc()
		StopMove()
		-- print("RequestFly",mapId, x, y, harborId)
		local cs_ByteArray = ByteArray.Init()
		ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
		ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_REQUEST_JUMP)
		ByteArray.WriteInt(cs_ByteArray,mapId)
		ByteArray.WriteInt(cs_ByteArray,x)
		ByteArray.WriteInt(cs_ByteArray,y)
		ByteArray.WriteInt(cs_ByteArray,harborId)
		mNetManager.SendData(cs_ByteArray)
	end
	if mItemManager.GetItemCountById(48) > 0 then
		okFunc()
		return
	end
	if not mCommonlyFunc.HaveGold(10) then
		return
	end
	mAlert.Show("是否花费10元宝进行传送?",okFunc)
end

-- monthCard 1为月卡  2为终生卡
function REQUEST_MONTH_AWARD(monthCard)
	print("REQUEST_MONTH_AWARD" ,monthCard)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.REQUEST_MONTH_AWARD)
	ByteArray.WriteInt(cs_ByteArray,monthCard)
	mNetManager.SendData(cs_ByteArray)
end

function RequestFlyToHarbor(harborId)
	if mHero.harborId == harborId then
		mSystemTip.ShowTip("已在该港口")
		return
	end
	
	local cfg_harbor = CFG_harbor[harborId]
	RequestFly(cfg_harbor.mapId, cfg_harbor.x, cfg_harbor.y, harborId)
end

function RequestGetGold()
	-- print("RequestGetGold")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_GET_TEST_GOLD)
	mNetManager.SendData(cs_ByteArray)
end

function Player_info(cs_ByteArray)
	-- print("Player_info")
	if mHero then
		m3DTextManager.Destroy(mHero.csTitle)
		mCharManager.DestroyTitleImage(mHero)
	end
	
	mHero = mCharacter.ReadHeroData(cs_ByteArray)
	-- mCommonlyFunc.UpdateTitle(mHero)
	
	local mCharList = mCharManager.GetCharList()
	mCharList[mHero.id] = mHero
	
	mSetManager.ReadSettingData()
	
	mFamilyManager.RequestFamilyApplyer()
	-- print("Player_info")
	
	
	mSDK.ExtendInfoSubmit("enterServer")
	
	mSDK.SetRoleData(tostring(mHero.id), tostring(mHero.name), tostring(mHero.level), tostring(mLoginPanel.GetServerId()), tostring(mLoginPanel.GetServerName()))
	
	if platform == "yj" then
		local s = JsonObj()
		s:put("roleId", tostring(mHero.id))
		s:put("roleName", tostring(mHero.name))
		s:put("roleLevel", tostring(mHero.level))
		s:put("zoneId", tostring(mLoginPanel.GetServerId()))
		s:put("zoneName", tostring(mLoginPanel.GetServerName()))
		s:put("balance", tostring(mHero.gold))
		if mHero.vipLevel > 0 then
			s:put("vip", tostring(mHero.vipLevel))
		else
			s:put("vip", "1")
		end
		s:put("partyName", mHero.familyName)
		s:put("roleCTime", "2222222222")
		s:put("roleLevelMTime", "2525252525")
		mSDK.SetData("enterServer", s:toString())
		if newHero then	--createrole
			mSDK.SetData("createrole", s:toString())
		end
	end
end

function Join_Map(cs_ByteArray)
	-- print("Join_Map")
	mTargetManager.Hide()
	
	requestJoinMapCompete()
	
	mSceneManager.SetMouseEvent(false)
	
	mSceneManager.ClearAll()
	
	-- mHero.battleLog = {}
	
	if mHero.csTitle then
		m3DTextManager.Destroy(mHero.csTitle)
		mHero.csTitle = nil
	end
	
	mHero.moved = false
	
	mHero.map = ByteArray.ReadInt(cs_ByteArray)
	mHero.ships = mHero.ships or {}
	for i=1,3,1 do
		local nShipBaseIndex = ByteArray.ReadInt(cs_ByteArray)
		local index = ByteArray.ReadInt(cs_ByteArray)
		local nShipId = mCommonlyFunc.GetUid(mHero.id,CharacterType.Player,index)
		local wShipX = ByteArray.ReadShort(cs_ByteArray)
		local wShipY = ByteArray.ReadShort(cs_ByteArray)
		if index ~= 0 then
			mHero.ships[i] = mHero.ships[i] or {}
			mHero.ships[i].cid = mHero.id
			mHero.ships[i].id = nShipId
			mHero.ships[i].bid = nShipBaseIndex
			mHero.ships[i].index = index
			mHero.ships[i].x = wShipX
			mHero.ships[i].y = wShipY
			-- mHero.ships[i].x = mHero.ships[i].x+(i-1)*300
			-- mHero.ships[i].y = 500
			mHero.ships[i].hp = 200
			mHero.ships[i].maxHp = 200
			mHero.ships[i].move = nil
			mHero.ships[i].rotation = nil
			mHero.ships[i].angles = 0
			mHero.ships[i].buffs = nil
		else
			mHero.ships[i] = nil
		end
		-- print(index)
	end
	-- print(mHero.ships)
	mHero.harborId = nil
	mHero.x = mHero.ships[1].x
	mHero.y = mHero.ships[1].y
	
	mHero.sendId = ByteArray.ReadByte(cs_ByteArray)
	mHero.team = ByteArray.ReadByte(cs_ByteArray)
	
	-- print("battle".. mHero.map)
	if mHero.map == 1 or  mHero.map == 3 then
		-- mHero.map = 3
		mHero.SceneType = SceneType.Battle
		mCameraManager.SetView(mHero.x, mHero.y)
		mSceneManager.IntoBattleScene()
	else
		mHero.SceneType = SceneType.Normal
		mCameraManager.SetView(mHero.x, mHero.y)
		mSceneManager.IntoNormalScene()
	end
	
	mPanelManager.Hide(mLoginPanel)
	mPanelManager.Hide(mCreateHeroPanel)
	mPanelManager.Show(mLoadPanelPanel)
	mPanelManager.Hide(mConnectAlert)

	mSceneManager.Update(true)
	
	-- mSea.SetPosition(mHero.x, mHero.y)
	-- mPanelManager.InitPanel(mSceneManager)
end

function SEND_MONEY(cs_ByteArray)
	local money = ByteArray.ReadInt(cs_ByteArray)
	if not mHero then
		return
	end
	if mHero.money > money then
		mHeroTip.ShowTip("银两消耗"..mHero.money-money)
	elseif mHero.money < money then
		local add = money-mHero.money
		if not mAddItemTip.NeedStopAddShow(0,14,add) then
			mHeroTip.ShowTip("银两增加"..add)
		end
	end
	mHero.money = money
end

function SEND_GOLD(cs_ByteArray)
	local gold = ByteArray.ReadInt(cs_ByteArray)
	if not mHero then
		return
	end
	if mHero.gold > gold then
		mHeroTip.ShowTip("元宝消耗"..mHero.gold-gold, Color.RedStr)
	elseif mHero.gold < gold then
		local add = gold-mHero.gold
		if not mAddItemTip.NeedStopAddShow(0,13,add) then
			mHeroTip.ShowTip("元宝增加"..add)
		end
	end
	mHero.gold = gold
	-- mHero.gold = ByteArray.ReadInt(cs_ByteArray)
end

function SEND_SKILL_ORB_POINT(cs_ByteArray)
	-- print("SEND_SKILL_ORB_POINT")
	mHero.starPoint = ByteArray.ReadInt(cs_ByteArray)
end

function SEND_CHG_POWER(cs_ByteArray)
	if mLockPower or  not mHero then
		return
	end
	local power = ByteArray.ReadInt(cs_ByteArray)
	if power ~= mHero.power and mHero.power ~= 0 then
		mPowerChangeTip.ShowTip(mHero.power, power)
	end
	mHero.power = power
end

function SEND_FISH_INFO(cs_ByteArray)
	print("SEND_FISH_INFO")
	local fish = ByteArray.ReadInt(cs_ByteArray)
	if not mHero then
		return
	end
	mHero.fish = fish
end

function SEND_GAME_INFO(cs_ByteArray)
	print("SEND_GAME_INFO")
	mDefaultDiscount = ByteArray.ReadInt(cs_ByteArray) / 100
	mRmbToGold = ByteArray.ReadInt(cs_ByteArray)
	mAwardLevelPrice = ByteArray.ReadInt(cs_ByteArray)
	mFirstRecharge = ByteArray.ReadInt(cs_ByteArray) == 0
	mSailorLevelUpMoney = ByteArray.ReadInt(cs_ByteArray)
	if(mDefaultDiscount == 1) then return end
	for _, v in pairs(CFG_item) do
		v.price = math.ceil(v.price * mDefaultDiscount)
	end
end

function SEND_MONTH_CARD(cs_ByteArray)
	print("SEND_MONTH_CARD")
	mMonthCard.monthCardEndTime1 = ByteArray.ReadInt(cs_ByteArray)
	mMonthCard.monthCardGet1 = ByteArray.ReadInt(cs_ByteArray)
	mMonthCard.monthCardEndTime2 = ByteArray.ReadInt(cs_ByteArray)
	mMonthCard.monthCardGet2 = ByteArray.ReadInt(cs_ByteArray)
end

function SEND_LEVEL(cs_ByteArray)
	mHero.level = ByteArray.ReadShort(cs_ByteArray)
	mSailorManager.UpdateAllProperty()
	
	mLevelUpTip.ShowTip()
	
	if mHero.SceneType ~= SceneType.Battle then
		mAudioManager.PlayAudioOneShot(AudioData.levelUp)
	end
	mCommonlyFunc.UpdateTitle(mHero)
	
	mActionManager.LevelUp(mHero.level)
	
	mActivityManager.UpdateLevelAward(true)
	mItemManager.InitCFG()
	
	-- if mHero.mode == 0 and mHero.level >= 28 then
		-- mPanelManager.Show(mModePanel)
	-- end
	AppearEvent(nil,EventType.ShowNextMainTask)
	AppearEvent(nil,EventType.RefreshStarFate)
	
	mSDK.ExtendInfoSubmit("levelUp")
	
	
	if mHero.csTitle then
		m3DTextManager.SetHeroTitle(mHero.titleName, mHero.level)
	end
	
	if platform == "yj" then
		local s = JsonObj()
		s:put("roleId", mHero.id)
		s:put("roleName", mHero.name)
		s:put("roleLevel", mHero.level)
		s:put("zoneId", mLoginPanel.GetServerId())
		s:put("zoneName", mLoginPanel.GetServerName())
		s:put("balance", mHero.gold)
		if mHero.vipLevel > 0 then
			s:put("vip", mHero.vipLevel)
		else
			s:put("vip", 1)
		end
		s:put("partyName", mHero.familyName)
		s:put("roleCTime", 2222222222)
		s:put("roleLevelMTime", 2525252525)
		mSDK.SetData("levelup", s:toString())
	end
end

function SEND_EXP(cs_ByteArray)
	local exp = ByteArray.ReadInt(cs_ByteArray)
	-- mHeroTip.ShowTip(mHero.exp .. "  " .. exp)
	if mHero.exp > exp then
		-- mHeroTip.ShowTip("经验消耗"..mHero.exp-exp)
	elseif mHero.exp < exp then
		mHeroTip.ShowTip("经验增加"..exp-mHero.exp)
	end
	mHero.exp = exp
end

function SEND_PLAYER_CHG_JOB(cs_ByteArray)
	mHero.role = ByteArray.ReadByte(cs_ByteArray)
	-- print(mHero.role)
	local cfg_role = CFG_UniqueSailor[mHero.role]
	mHero.quality = cfg_role.quality
	mHero.resId = cfg_role.resId
	
	local sailor = mSailorManager.GetSailorByDuty(1)
	if sailor then
		sailor.quality = cfg_role.quality
		sailor.resId = cfg_role.resId
		sailor.index = mHero.role
		mSailorManager.UpdateProperty(sailor, true)
	end
	
	
	mAnimationManager.Start(3, nil, sailor, sailor.index)
end

function SEND_PLAYER_VIGOR(cs_ByteArray)
	if mHero then
		local count = ByteArray.ReadInt(cs_ByteArray)
		local change = count - mHero.copyMapCount
		mHero.copyMapCount = count
		
		if change > 0 then
			mHeroTip.ShowTip("体力增加"..change)
		end
	end
end

function SEND_PLAYER_VIGOR_BUY_COUNT(cs_ByteArray)
	if mHero then
		mHero.copyMapBuyCount = ByteArray.ReadInt(cs_ByteArray)
	end
end

function SEND_GIVE_GOLD_TIME(cs_ByteArray)
	mHero.getGoldLastTime = ByteArray.ReadInt(cs_ByteArray)
	mHero.getGoldUpdateTime = os.oldClock
end

function SEND_VIP_LEVEL(cs_ByteArray)
	if not mHero then
		return
	end
	local vipLevel = ByteArray.ReadByte(cs_ByteArray)
	mHero.vipExp = ByteArray.ReadInt(cs_ByteArray)
	
	mHero.vipLevel = vipLevel
	
	mShopPanel.CleanPrice()
	mGoodsManager.CleanGoodsPriceList()
	AppearEvent(nil,EventType.RefreshStarFate)
end

function SEND_FIRST_EMPLOY_ORANGE(cs_ByteArray)
	mHero.firstRefreshSailor = ByteArray.ReadBool(cs_ByteArray)
	-- print("SEND_FIRST_EMPLOY_ORANGE", mHero.firstRefreshSailor)
end

function SEND_PROTECT_TIME(cs_ByteArray)
	-- print("SEND_PROTECT_TIME")
	mHero.protectTime = ByteArray.ReadInt(cs_ByteArray)
	mHero.protectUpdateTime = os.oldClock
	if mHero.protectTime > 0 then
		mHero.protectState = true
	end
	mCommonlyFunc.UpdateTitle(mHero)
end

function SEND_PLAYER_DEAD(cs_ByteArray)
	-- print("SEND_PLAYER_DEAD")
	mPowerUpTip.ShowTip()
end

function SEND_MONEY_POT_USE_COUNT(cs_ByteArray)
	-- print("SEND_MONEY_POT_USE_COUNT")
	local moneyBoxUseCount = ByteArray.ReadByte(cs_ByteArray)
	
	local cfg_item = CFG_item[101]
	if not cfg_item.desc1 then
		cfg_item.desc1 = cfg_item.desc
	end
	local addMoney = math.max(200 - moneyBoxUseCount * 20, 60)
	cfg_item.desc = string.format(cfg_item.desc1, addMoney)
end

function SEND_LOGIN_AWARD_INFO(cs_ByteArray)
	mLoginAward = mLoginAward or {}
	mLoginAward.geted = ByteArray.ReadBool(cs_ByteArray)
	mLoginAward.loginCount = ByteArray.ReadInt(cs_ByteArray)
	mLoginAward.loginContinueCount = ByteArray.ReadInt(cs_ByteArray)
	
	AppearEvent(nil, EventType.RefreshLoginAward)
end

