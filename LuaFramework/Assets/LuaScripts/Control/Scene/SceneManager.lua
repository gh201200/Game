local os,print,Screen,require,EventType,PackatHead,Packat_Player,AudioData,SceneType,Packat_Harbor,AppearEvent = 
os,print,Screen,require,EventType,PackatHead,Packat_Player,AudioData,SceneType,Packat_Harbor,AppearEvent
local Packat_Battle,GameObject,Vector3,CFG_harbor,CsSetPosition,GetTransform,ByteArray = 
Packat_Battle,GameObject,Vector3,CFG_harbor,CsSetPosition,GetTransform,ByteArray
local ResetMetatableTable,Packat_Enemy = ResetMetatableTable,Packat_Enemy
local mMap = require "LuaScript.View.Scene.Map"
-- local mSea = require "LuaScript.View.Scene.Sea"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSeagullManager = require "LuaScript.Control.Scene.SeagullManager"
local mFishManager = require "LuaScript.Control.Scene.FishManager"
local mAudioManager = require "LuaScript.Control.System.AudioManager"
local mSendManager = require "LuaScript.Control.Scene.SendManager"
local mHeroManager = nil
local mCharManager = nil
local mCharacter = nil
local mCameraManager = nil
local mPanelManager =  nil
local mMainPanel =    nil
local mEventManager =  nil
local mNetManager =    nil
local mBulletManager = require "LuaScript.Control.Scene.BulletManager"
local mPathManager = nil
local mLoginPanel = nil
local mCreateHeroPanel = nil
local mWaveManager = nil
local mBattleManager = nil
local mSpindriftManager = nil
local mBombEffectManager = nil
local mCloudManager = nil
local mCopyMapPanel = nil
local mPassPanel = nil
local mConnectAlert = nil
local mBattleFieldManager = nil
local m3DTextManager = nil
local mOngoingTask = nil
local table = table

module("LuaScript.Control.Scene.SceneManager")

local mMouseEventState = true
-- local mCsScene = nil
function Init()
	-- mSendManager = require "LuaScript.Control.Scene.SendManager"
	mBattleFieldManager = require "LuaScript.Control.Data.BattleFieldManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mCharacter = require "LuaScript.Mode.Object.Character"
	mCameraManager = require "LuaScript.Control.CameraManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mEventManager = require "LuaScript.Control.EventManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mPathManager = require "LuaScript.Control.Scene.PathManager"
	mWaveManager = require "LuaScript.Control.Scene.WaveManager"
	mBattleManager = require "LuaScript.Control.Data.BattleFieldManager"
	mSpindriftManager = require "LuaScript.Control.Scene.SpindriftManager"
	mBombEffectManager = require "LuaScript.Control.Scene.BombEffectManager"
	mCloudManager = require "LuaScript.Control.Scene.CloudManager"
	mLoginPanel = require "LuaScript.View.Panel.Login.LoginPanel"
	mLoadPanelPanel = require "LuaScript.View.Panel.LoadPanel"
	mCopyMapPanel = require "LuaScript.View.Panel.CopyMap.CopyMapPanel"
	mPassPanel = require "LuaScript.View.Panel.Pass.PassPanel"
	mConnectAlert = require "LuaScript.View.Alert.ConnectAlert"
	m3DTextManager = require "LuaScript.Control.Scene.3DTextManager"
	mOngoingTask = require "LuaScript.View.Panel.Main.OngoingTask"
	mCameraManager.Init()
	mCharManager.Init()
	
	-- mCsScene = GameObject.Find("Scene")
	
	-- mHeroManager.InitHero()
	-- print("mPanelManager.Show(mMainPanel)")
	-- mPanelManager.Show(mMainPanel)
	
	-- IntoNormalScene()
	
	mNetManager.AddListen(PackatHead.HARBOR, Packat_Harbor.SEND_ENTER_HARBOR, SEND_ENTER_HARBOR)
	mNetManager.AddListen(PackatHead.ENEMY, Packat_Enemy.SEND_BOSS_INFO, SEND_BOSS_INFO)
end

function ClearAll()
	mBulletManager.ClearAll()
	mSeagullManager.ClearAll()
	mFishManager.ClearAll()
	mHarborManager.ClearAll()
	mWaveManager.ClearAll()
	mSpindriftManager.ClearAll()
	mBombEffectManager.ClearAll()
	mCloudManager.ClearAll()
	
	mMap.ClearAll()
	-- mSea.ClearAll()
	mSendManager.ClearAll()
	m3DTextManager.ClearAll()
	
	if mCharManager then
		mCharManager.ClearAll()
	end
	mBattleFieldManager.ClearAll()
	
	ResetMetatableTable()
end

function IntoBattleScene()
	mHeroManager.SetTarget(nil)
	
	AppearEvent(nil, EventType.ClearAsset, 1)
	AppearEvent(nil, EventType.IntoBattleScene)
	mPathManager.Init()
	local hero = mHeroManager.GetHero()
	hero.SceneType = SceneType.Battle
	hero.BattleTime = os.oldClock
	-- mSea.Show()
	mMap.Show()
	
	local viewX,viewY = mCameraManager.GetView()
	mMap.UpdatePosition(hero.map, viewX, viewY)
	
	PlayerAudio()
	
	mPanelManager.AutoClose()
	
	mPanelManager.Show(mMainPanel)
end

function IntoNormalScene()
	
	AppearEvent(nil, EventType.ClearAsset, 1)
	AppearEvent(nil, EventType.IntoNormalScene)
	mPathManager.Init()
	local hero = mHeroManager.GetHero()
	if hero.SceneType == SceneType.Battle then
		mHeroManager.SetTarget(nil)
	end
	hero.SceneType = SceneType.Normal
	
	-- mSea.Show()
	mMap.Show()
	
	local viewX,viewY = mCameraManager.GetView()
	mMap.UpdatePosition(hero.map, viewX, viewY)

	mPanelManager.Show(mMainPanel)
	PlayerAudio()
	
	mPanelManager.AutoClose()
end

function IntoHarbor()
	mHeroManager.SetTarget(nil)
	
	AppearEvent(nil, EventType.ClearAsset, 1)
	local hero = mHeroManager.GetHero()
	mPanelManager.Hide(mMainPanel)
	if not mCopyMapPanel.visible and not mPassPanel.visible then
		mPanelManager.Show(mMainPanel)
		mMainPanel.ResetMaxOffsetY()
	end
	
	if not hero.SceneType then
		mPanelManager.Show(mLoadPanelPanel)
	end
	
	ClearAll()
	hero.SceneType = SceneType.Harbor
	hero.ships = nil
	SetMouseEvent(false)
	PlayerAudio()
	
	mPanelManager.AutoClose()
	
	AppearEvent(nil, EventType.IntoHarbor)
	
	mOngoingTask.OpenSwitch(false)
end
--用于关闭海面点击事件
function SetMouseEvent(value)
	-- print("SetMouseEvent!!!!!!!!!!", value)
	mMouseEventState = value
	if mEventManager then
		mEventManager.SetEventListenValue(EventType.OnMouseDown, value)
		mEventManager.SetEventListenValue(EventType.OnMouseUp, value)
	end
	
	AppearEvent(nil, EventType.MouseEventState)
end

function GetMouseEventState()
	return mMouseEventState -- 默认为真
end

function Update(forced)
	-- print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
	local hero = mHeroManager.GetHero()
	-- if (not hero or not hero.ships or not hero.ships[1] or not hero.ships[1].move) and not forced then
	if (not hero or not hero.ships or not hero.ships[1]) and not forced then
		return
	end
	
	local viewX,viewY = mCameraManager.GetView()
	mMap.UpdatePosition(hero.map, viewX, viewY)
	if hero.SceneType == SceneType.Normal then
		mHarborManager.UpdatePosition(hero.map, viewX, viewY)
		mSeagullManager.UpdatePosition(hero.map, viewX, viewY)
		mFishManager.UpdatePosition(hero.map, viewX, viewY)
		mSendManager.UpdatePosition(hero.map, viewX, viewY)
	-- elseif hero.SceneType == SceneType.Battle then
		-- mSpindriftManager.UpdatePosition(hero.x, hero.y)
	end

end

function PlayerAudio()
	if not mHeroManager or not mHeroManager.GetHero() then
		mAudioManager.PlayAuidioLoop(AudioData.kaishi)
		return
	end
	
	local hero = mHeroManager.GetHero()
	if hero.SceneType == SceneType.Battle then
		mAudioManager.PlayAuidioLoop(AudioData.zhandou)
	elseif hero.SceneType == SceneType.Harbor then
		local cfg_harbor = CFG_harbor[hero.harborId]
		mAudioManager.PlayAuidioLoop(AudioData[cfg_harbor.audio])
	else
		mAudioManager.PlayAuidioLoop(AudioData.hangxing)
	end
end

function SetWaveDir(x, y)
	-- mSea.SetWaveDir(x, y)
end


function ChangeAllX(value)
	mCharManager.ChangeAllX(value)
	mBattleManager.ChangeAllX()
	-- mCloudManager.ChangeAllX(value)
	-- mWaveManager.ChangeAllX(value)
	mMap.ChangeAllX(value)
	-- mSea.ChangeAllX(value)
	
end

-- function SetWaveSpeed(speed)
	-- mSea.SetWaveSpeed(speed)
-- end


function SEND_ENTER_HARBOR(cs_ByteArray)
	-- print("???????????????????????")
	mHeroManager.requestJoinMapCompete()
	
	local harborId = ByteArray.ReadInt(cs_ByteArray)
	mHarborManager.RequestHarborInfo(harborId)
	
	local hero = mHeroManager.GetHero()
	if not hero.SceneType then
		SetMouseEvent(false)
		
		Init()
		
		mPanelManager.Hide(mLoginPanel)
		mPanelManager.Hide(mConnectAlert)
		mPanelManager.Hide(mCreateHeroPanel)
	end
	
	local cfg_harbor = CFG_harbor[harborId]
	hero.harborId = harborId
	hero.map = cfg_harbor.mapId
	hero.x = cfg_harbor.x
	hero.y = cfg_harbor.y
	IntoHarbor()
end

local BossListInfo = {}

function GetBossListInfo()
    return BossListInfo
end

function SEND_BOSS_INFO(cs_ByteArray)
	-- print("???????????????????????")
	local count = ByteArray.ReadInt(cs_ByteArray)
	BossListInfo = {}
	for i=1,count do
		local enemyId = ByteArray.ReadInt(cs_ByteArray)
		local bornTime = ByteArray.ReadInt(cs_ByteArray)
		-- print(enemyId .. "--" .. bornTime)
		table.insert(BossListInfo,{BossId = enemyId,BossTime = bornTime})
	end
end


