local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray = print,Instantiate,EventType,Space,math,os,Vector3,ByteArray
local PackatHead,Packat_Player,tostring,Destroy,require,type,tonumber,BoxCollider,SceneType,Packat_Enemy,CFG_ship = 
PackatHead,Packat_Player,tostring,Destroy,require,type,tonumber,BoxCollider,SceneType,Packat_Enemy,CFG_ship
local Screen,pairs,table,ConstValue,CharacterType,GameObject,Packat_Family,AppearEvent,LogbookType,Packat_Merchant = 
Screen,pairs,table,ConstValue,CharacterType,GameObject,Packat_Family,AppearEvent,LogbookType,Packat_Merchant
local AudioData,Packat_Harbor,_G,GetTransform,CsRotate,CFG_EnemyPosition,CsSetPosition,CFG_Enemy,CsSetName,CsGetName = 
AudioData,Packat_Harbor,_G,GetTransform,CsRotate,CFG_EnemyPosition,CsSetPosition,CFG_Enemy,CsSetName,CsGetName
local GetComponentInChildren,GetComponent,Animation,CsAnimationPlay,GetLength,Color,CsSetParent,AssetType,CsSetMaterial = 
GetComponentInChildren,GetComponent,Animation,CsAnimationPlay,GetLength,Color,CsSetParent,AssetType,CsSetMaterial
local GetRenderer,Renderer,CsFindType,CsSetHpBar = GetRenderer,Renderer,CsFindType,CsSetHpBar
local _print,Packat_Ship,AnimationType,Packat_Title,HpBar = _print,Packat_Ship,AnimationType,Packat_Title,HpBar
local UploadError,debug,string,CsSetActive = UploadError,debug,string,CsSetActive

local mNetManager = require "LuaScript.Control.System.NetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mAssetManager = nil
local mEventManager = nil
local mCharacter = nil
local mHeroManager = nil
local mCharViewPanel = nil
local mSelectViewPanel = nil
local mPanelManager = nil
local mMoveManager = nil
local mBombEffectManager = nil
local mSceneManager = nil
local mBulletManager = nil
local mShipResManager = nil
local mAudioManager = nil
local mLogbookManager = nil
local mCameraManager = nil
local mSystemTip = nil
local mSetManager = nil
local mWaveManager = nil
local m3DTextManager = nil
local mBattleManager = nil
local mSkillManager = nil
local mHarborManager = nil
local mGoodsManager = nil

module("LuaScript.Control.Scene.CharManager")

local mCharList = {}
local mShipList = {}
local mCsShipList = {}
local mShipCount = 0
-- local mCsShipColliderList = {}
-- local mCsScene = nil
local notShowHideTip = true


function GeCsShipList()
	return mCsShipList
end

function GetCharList()
	return mCharList
end

function GetShipList()
	return mShipList
end
-- function GetCsShipColliderList()
	-- return mCsShipColliderList
-- end

function GetChar(id)
	local char = mCharList[id]
	return char
end

function GetShip(id)
	return mShipList[id]
end

function GetCsShip(id)
	-- print(id)
	-- print(mCsShipList)
	return mCsShipList[id]
end

function IsNearEnemy(eid)
	for k,char in pairs(mCharList) do
		if char.eid == eid then
			return true
		end
	end
end

function GetNearEnemy(eid, x, y)
	local hero = mHeroManager.GetHero()
	x = x or hero.x
	y = y or hero.y
	
	local dis = 1000000
	local enemy = nil
	for k,char in pairs(mCharList) do
		-- print(char.eid == eid)
		if char.eid == eid then
			local tDis = math.abs(char.x - x) + math.abs(char.y - y)
			if char.battleId then
				tDis = tDis + 1000
			end
			
			if tDis < dis then
				dis = tDis
				enemy = char
			end
		end
	end
	return enemy
end


function GetEnemyList(eid, enemyList)
	local hero = mHeroManager.GetHero()
	local enemyList = enemyList or {}
	for k,char in pairs(mCharList) do
		-- print(char.eid == eid)
		if char.eid == eid then
			table.insert(enemyList, char)
		end
	end
	return enemyList
end

function Init()
	-- print("ccccccc!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	mAssetManager = require "LuaScript.Control.AssetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mCharacter = require "LuaScript.Mode.Object.Character"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharViewPanel = require "LuaScript.View.Panel.View.CharViewPanel"
	mSelectViewPanel = require "LuaScript.View.Panel.View.SelectViewPanel"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mMoveManager = require "LuaScript.Control.Scene.MoveManager"
	mBombEffectManager = require "LuaScript.Control.Scene.BombEffectManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mBulletManager = require "LuaScript.Control.Scene.BulletManager"
	mShipResManager = require "LuaScript.Control.Data.ShipResManager"
	mLogbookManager = require "LuaScript.Control.Data.LogbookManager"
	mAudioManager = require "LuaScript.Control.System.AudioManager"
	mCameraManager = require "LuaScript.Control.CameraManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mWaveManager = require "LuaScript.Control.Scene.WaveManager"
	m3DTextManager = require "LuaScript.Control.Scene.3DTextManager"
	mBattleManager = require "LuaScript.Control.Data.BattleFieldManager"
	mSkillManager = require "LuaScript.Control.Scene.SkillManager"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mGoodsManager = require "LuaScript.Control.Data.GoodsManager"
	
	-- mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SYNCPLAYER, IntoView)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.CLIENT_MOVE_TO, StarMove)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SYNCBATTLEPLAYER, IntoBattleView)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SYNC_FAKE_PLAYER, SYNC_FAKE_PLAYER)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.CLIENT_STOP, CLIENT_STOP)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.DISAPPEAR, DISAPPEAR)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_PLAYER_SYNC_OUT_OF_VIEW, SEND_PLAYER_SYNC_OUT_OF_VIEW)
	-- mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SERVER_FORCE_SET_CLIENT_POS, SERVER_FORCE_SET_CLIENT_POS)
	
	mNetManager.AddListen(PackatHead.ENEMY, Packat_Enemy.SYNCENEMY, EnemyIntoView)
	mNetManager.AddListen(PackatHead.ENEMY, Packat_Enemy.SYNC_FAKE_ENEMY, SYNC_FAKE_ENEMY)
	mNetManager.AddListen(PackatHead.ENEMY, Packat_Enemy.ENEMY_MOVE_TO, EnemyStarMove)
	mNetManager.AddListen(PackatHead.ENEMY, Packat_Enemy.ENEMY_DISAPPEAR, EnemyDISAPPEAR)
	mNetManager.AddListen(PackatHead.ENEMY, Packat_Enemy.SEND_ENEMY_STOP, EnemyCLIENT_STOP)
	mNetManager.AddListen(PackatHead.ENEMY, Packat_Enemy.SEND_ENEMY_SYNC_OUT_OF_VIEW, SEND_ENEMY_SYNC_OUT_OF_VIEW)
	
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_HOME_TITLE, SEND_HOME_TITLE)
	mNetManager.AddListen(PackatHead.FAMILY, Packat_Family.SEND_DEL_HOME_TITLE, SEND_DEL_HOME_TITLE)
	
	mNetManager.AddListen(PackatHead.MERCHANT, Packat_Merchant.SYNC_MERCHANT, ShipTeamIntoView)
	mNetManager.AddListen(PackatHead.MERCHANT, Packat_Merchant.SYNC_FAKE_MERCHANT, SYNC_FAKE_MERCHANT)
	mNetManager.AddListen(PackatHead.MERCHANT, Packat_Merchant.SEND_MERCHANT_SYNC_OUT_OF_VIEW, SEND_ENEMY_SYNC_OUT_OF_VIEW)
	
	mNetManager.AddListen(PackatHead.HARBOR, Packat_Harbor.SYNC_BATTLE_HARBOR, SYNC_BATTLE_HARBOR)
	
	mNetManager.AddListen(PackatHead.SHIP, Packat_Ship.SEND_SHIP_DESTROY, SEND_SHIP_DESTROY)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_PROTECT_STATE, SEND_PROTECT_STATE)
	
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_CHG_SPEED, SEND_CHG_SPEED)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_PLAYER_MODE_CHG, SEND_PLAYER_MODE_CHG)
	
	mNetManager.AddListen(PackatHead.TITLE, Packat_Title.SEND_SET_TITLE, SEND_SET_TITLE)
	
	IsInit = true
end

function InitChar(char)
	local hero = mHeroManager.GetHero()
	mCharList[char.id] = char
	mCommonlyFunc.UpdateTitle(char)
	mCommonlyFunc.ReviseCharPosition(char)
	
	char.ships[1].mainShip = true
	char.ships[1].lastShip = char.ships[2]
	if char.ships[2] then
		char.ships[2].lastShip = char.ships[3]
		char.ships[2].perShip = char.ships[1]
	end
	if char.ships[3] then
		char.ships[3].perShip = char.ships[2]
	end
	
	local newShip = 0
	for _,ship in pairs(char.ships) do
		local scale = nil
		if char.type == CharacterType.Enemy then
			local cfg_Enemy = CFG_Enemy[char.eid]
			if cfg_Enemy then
				scale = cfg_Enemy.scale
			end
		end
		
		mShipList[ship.id] = ship
		
		if mCommonlyFunc.HideChar(char, mShipCount) then
			if not mSetManager.GetHideChar() and not mSetManager.GetHideChar1() and
							not mSetManager.GetHideChar2() and notShowHideTip then
				local info = "当前场景玩家过多,已屏蔽部分玩家,可在"
				info = info .. mCommonlyFunc.BeginColor(Color.CyanStr)
				info = info .. "菜单·设置"
				info = info .. mCommonlyFunc.EndColor()
				info = info .. "处手动屏蔽玩家"
				mSystemTip.ShowTip(info, Color.LimeStr)
				notShowHideTip = false
			end
			char.hide = true
			mMoveManager.UpdatePosition(ship)
			-- print("too more char!!!!")
		else
			-- print(ship)
			local cs_ship = mShipResManager.GetShip(ship.bid, scale)
			CsSetName(cs_ship, ship.id)
			newShip = newShip + 1
			mCsShipList[ship.id] = cs_ship
			
			CsRotate(GetTransform(cs_ship),0,ship.angles,0)
			
			local csShipCollider = GetComponentInChildren(cs_ship,BoxCollider.GetType())
			mMoveManager.UpdatePosition(ship)
			local mHero = mHeroManager.GetHero()
			if mHero.SceneType ~= SceneType.Battle then
				mEventManager.AddEventListen(cs_ship, EventType.OnMouseDown, OnMouseDown)
				csShipCollider.enabled = true
			else
				mEventManager.AddEventListen(cs_ship, EventType.OnSink, OnSink)
				mEventManager.AddEventListen(cs_ship, EventType.OnHurt, OnHurt)
				csShipCollider.enabled = false
				GetComponentInChildren(cs_ship, Animation.GetType())
			end
			
			if ship.buffs then
				mSkillManager.RefreshEffect(ship)
			end
			
			
		end
	end
	mShipCount = mShipCount + newShip
end

function InitTitle(char)
	char.csTitle = m3DTextManager.Get3DText(char.titleName)
end

function InitHpBar(ship)
	if ship.hp <= 0 then
		return
	end
	local csAsset = nil
	local char = GetChar(ship.cid)
	local hero = mHeroManager.GetHero()
	if hero.team == char.team then
		csAsset = mAssetManager.GetAsset("GameObj/OwnHpBar", AssetType.Forever)
	else
		csAsset = mAssetManager.GetAsset("GameObj/EnemyHpBar", AssetType.Forever)
	end
	local csHpBar = Instantiate(csAsset)
	ship.csHpBar = csHpBar
	
	UpdateHpBar(ship)
end

function InitTitleImage(char)
	if not char.title or char.title == 0 then
		return
	end
	
	local csAsset = mAssetManager.GetAsset("GameObj/title/"..char.title, AssetType.Forever)
	char.csTitleImage = Instantiate(csAsset)
	-- print(char.csTitleImage)
end

function DestroyTitleImage(char)
	if char.csTitleImage then
		Destroy(char.csTitleImage)
		char.csTitleImage = nil
	end
end

local mHpBarType = HpBar.GetClassType()
function UpdateHpBar(ship)
	if ship.csHpBar then
		local scale = math.min(ship.hp/ship.maxHp, 1)
		CsSetHpBar(GetComponentInChildren(ship.csHpBar, mHpBarType), scale)
	end
end

function DestroyHpBar(ship)
	if ship.csHpBar then
		Destroy(ship.csHpBar)
		ship.csHpBar = nil
	end
end

function DestroyChar(mChar)
	-- if _G.IsDebug then
		-- print(mChar.id, "DestroyChar")
	-- end
	-- print(mChar.ships)
	-- print(mChar.ships)
	if mChar.ships then
		for _,ship in pairs(mChar.ships) do
			DestroyShip(ship.id)
		end
	end
	
	local hero = mHeroManager.GetHero()
	if hero ~= mChar then
		mCharList[mChar.id] = nil
	else
		hero.IsInit = false
	end
	
	if hero.SceneType ~= SceneType.Battle and mChar.battleId then
		mBattleManager.DestroyBattleIcon(mChar)
	end
	
	if mChar.csTitle then
		m3DTextManager.Destroy(mChar.csTitle)
		mChar.csTitle = nil
	end
	
	DestroyTitleImage(mChar)
end

function ShowChars()
	local list = {}
	local hero = mHeroManager.GetHero()
	for k,char in pairs(mCharList) do
		if char.hide then
			table.insert(list, char)
		end
		char.hide = nil
	end
	for k,char in pairs(list) do
		InitChar(char)
	end
end

function HideChars()
	local hero = mHeroManager.GetHero()
	if not hero or hero.SceneType ~= SceneType.Normal then
		return
	end
	local list = {}
	for k,char in pairs(mCharList) do
		if mCommonlyFunc.HideChar(char,0) then
			if not char.hide then
				for k,ship in pairs(char.ships) do
					local cs_ship = mCsShipList[ship.id]
					if cs_ship then
						mCsShipList[ship.id] = nil
						
						mEventManager.RemoveAllEveListen(cs_ship)
						mShipResManager.DestroyShip(ship, cs_ship)
						
						mShipCount = mShipCount - 1
					end
					
					mSkillManager.HideEffect(ship)
				end
				char.hide = true
			end
		else
			if char.hide then
				char.hide = false
				table.insert(list, char)
			end
		end
	end
	for k,char in pairs(list) do
		InitChar(char)
	end
end

function DestroyShip(shipId)
	-- print("DestroyShip" .. shipId)
	
	local ship = mShipList[shipId]
	if not ship then
		return
	end
	
	DestroyHpBar(ship)
	
	local mHero = mHeroManager.GetHero()
	if mHero and mHero.SceneType == SceneType.Battle then
		mBulletManager.ClearBySid(shipId)
	end
	
	local cs_ship = mCsShipList[shipId]
	if cs_ship then
		mEventManager.RemoveAllEveListen(cs_ship)
		mShipResManager.DestroyShip(ship, cs_ship)
		mCsShipList[shipId] = nil
		
		mShipCount = mShipCount - 1
	end
	mShipList[shipId] = nil
	
	-- mWaveManager.ClearBySid(shipId)
	-- mCsShipColliderList[ship.id] = nil
end

function Update()
	if not IsInit then
		return
	end
	-- print("update")
	
	-- os.oldClock = os.clock()
	local hero = mHeroManager.GetHero()
	for _,ship in pairs(mShipList) do
		if ship.rotation then
			mMoveManager.UpdateAngles(ship)
		end
		if ship.move and (hero.id ~= ship.cid or not ship.mainShip) then
			local char = mCharList[ship.cid]
			mMoveManager.Move(char, ship)
		elseif not ship.move then
			mMoveManager.TestWave(ship)
		end
	end
end

function ChangeAllX(value)
	-- _print("ChangeAllX")
	-- local viewX,viewY = mCameraManager.GetView()
	for k,char in pairs(mCharList) do
		char.x = char.x + value
		
		if char.csTitle then
			CsSetPosition(GetTransform(char.csTitle), char.x, 95, char.y)
		end
	end
	
	for k,ship in pairs(mShipList) do
		ship.x = ship.x + value
		
		if ship.move then
			local path = ship.move.path
			for i=1,#path,2 do
				path[i] = path[i] + value
			end
		end
		local csShip = mCsShipList[ship.id]
		if csShip then
			CsSetPosition(GetTransform(csShip), ship.x, 0, ship.y)
		end
	end
end

function OnMouseDown(cs_ship)
	local hero = mHeroManager.GetHero()
	if not hero then
		return
	end
	if hero.SceneType == SceneType.Battle then
		return
	end
	local id = tonumber(CsGetName(cs_ship))
	local ship = mShipList[id]

	if not ship then
		local csShip = mCsShipList[id]
		UploadError("OnMouseDown Error !\n"..CsGetName(cs_ship).."\n"..tostring(csShip))
	end
	
	local char = mCharList[ship.cid]
	if char.battleId then
		mSelectViewPanel.SetData(char)
		mPanelManager.Show(mSelectViewPanel)
		-- mSceneManager.SetMouseEvent(false)
	else
		mCharViewPanel.SetData(char)
		mPanelManager.Show(mCharViewPanel)
		-- mSceneManager.SetMouseEvent(false)
	end
end

function Sink(shipId)
	-- if _G.IsDebug then
		-- print("Sink"..shipId)
	-- end
	local ship = mShipList[shipId]
	if ship.dead then
		return
	end
	
	local hero = mHeroManager.GetHero()
	if hero.id == ship.cid and hero.SceneType ~= SceneType.Battle then
		local str = "Sink Error!\n" .. debug.traceback()
		UploadError(str)
	end
	
	ship.mainShip = false
	ship.move = nil
	ship.dead = true
	
	DestroyHpBar(ship)
	
	local cfg_ship = CFG_ship[ship.bid]
	if cfg_ship.type == 0 then
		local cs_ship = mCsShipList[shipId]
		local animation = GetComponentInChildren(cs_ship, Animation.GetType())
		CsAnimationPlay(animation, AnimationType.Sink)
		
		local char = mCharList[ship.cid]
		for k,v in pairs(char.ships) do
			if v == ship then
				table.remove(char.ships, k)
				break
			end
		end
		if char.ships[1] then
			char.ships[1].mainShip = true
			char.x = char.ships[1].x
			char.y = char.ships[1].y
			
			if char.csTitle then
				m3DTextManager.SetPosition(char.csTitle, char.x, 95, char.y)
			end
		else
			DestroyChar(char)
		end
		
		if ship.perShip then
			ship.perShip.lastShip = ship.lastShip
		end
		if ship.lastShip then
			ship.lastShip.perShip = ship.perShip
		end
		mMoveManager.ReFollow(ship)
	else
		local cs_ship = mCsShipList[shipId]
		-- local csMaterial = mAssetManager.GetAsset("GameObj/Materials/harbor_"..ship.bid,AssetType.Material)
		-- print(cs_ship, csMaterial, ship.bid)
		-- CsSetMaterial(GetComponentInChildren(cs_ship, Renderer.GetType()), csMaterial)
		CsSetActive(cs_ship, false)
	end
end

function OnSink(cs_ship)
	local shipId = tonumber(CsGetName(cs_ship))
	-- if _G.IsDebug then
		-- print("OnSink", cs_ship, shipId)
	-- end
	DestroyShip(shipId)
end

function Hurt(shipId)
	local ship = mShipList[shipId]
	if ship.dead then
		return
	end
	local cs_ship = mCsShipList[shipId]
	local animation = GetComponentInChildren(cs_ship, Animation.GetType())
	CsAnimationPlay(animation, AnimationType.Hurt)
end

function OnHurt(cs_ship)
	-- print(cs_ship)
	local animation = GetComponentInChildren(cs_ship, Animation.GetType())
	CsAnimationPlay(animation, AnimationType.Rock)
end

function IntoBattleView(cs_ByteArray)
	-- print("IntoBattleView!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	local char = mCharacter.ReadBattleCharData(cs_ByteArray)
	local mHero = mHeroManager.GetHero()
	-- print(char.id)
	if not char then
		return
	end
	
	-- local intoSuccess = false
	
	if mHero.id == char.id then
		-- print(char.title)
		if mHero.battleId then
			mBattleManager.DestroyBattleIcon(mHero)
			mHero.battleId = nil
		end
		mHero.protectState = char.protectState
		mHero.title = char.title
		
		if mHero.IsInit then
			return
		end
		
		for k,v in pairs(mHero.ships) do
			v.hp = char.ships[k].hp
			v.maxHp = char.ships[k].maxHp
			v.angles = char.ships[k].angles
		end
		mHeroManager.InitHero()
		return
	end
	if not mCharList[char.id] then
		-- intoSuccess = true
		InitChar(char)
		
		if char.ships[1] and char.ships[1].move then
			mMoveManager.UpdateDir(char.ships[1])
		end
		if char.ships[2] and char.ships[2].move then
			mMoveManager.UpdateDir(char.ships[2])
		end
		if char.ships[3] and char.ships[3].move then
			mMoveManager.UpdateDir(char.ships[3])
		end
	else
		local mChar = mCharList[char.id]
		if mChar.battleId then
			mBattleManager.DestroyBattleIcon(char)
			mChar.battleId = nil
		end
		mChar.fake = nil
		mChar.protectState = char.protectState
		mChar.mode = char.mode
		
		mCommonlyFunc.UpdateTitle(mChar)
	end
	
	--战斗记录
	-- if mHero.SceneType == SceneType.Battle then
		-- table.insert(mHero.battleLog, string.format("%d,IntoBattleView %s",char.id, intoSuccess))
	-- end
end

function SYNC_FAKE_PLAYER(cs_ByteArray)
	-- print("SYNC_FAKE_PLAYER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	
	local mHero = mHeroManager.GetHero()
	if mHero.SceneType == SceneType.Battle then
		return
	end
	-- local intoSuccess = false
	local char = mCharacter.ReadBattleCharData(cs_ByteArray)
	if not char then
		return
	end
	char.fake = true

	if not mCharList[char.id] then
		InitChar(char)
		-- intoSuccess = true
		if char.ships[1] and char.ships[1].move then
			mMoveManager.UpdateDir(char.ships[1])
		end
		if char.ships[2] and char.ships[2].move then
			mMoveManager.UpdateDir(char.ships[2])
		end
		if char.ships[3] and char.ships[3].move then
			mMoveManager.UpdateDir(char.ships[3])
		end
	end
	
	--战斗记录
	-- if mHero.SceneType == SceneType.Battle then
		-- table.insert(mHero.battleLog, string.format("%d,IntoFakeBattleView %s",char.id, intoSuccess))
	-- end
end


function CLIENT_STOP(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	local nShipIndex = ByteArray.ReadInt(cs_ByteArray)
	local nStopX = ByteArray.ReadShort(cs_ByteArray)
	local nStopY = ByteArray.ReadShort(cs_ByteArray)
	
	local hero = mHeroManager.GetHero()
	if hero.id == id then
		return
	end
	
	local shipId = mCommonlyFunc.GetUid(id,CharacterType.Player,nShipIndex)
	-- print("CLIENT_STOP",shipId,nStopX,nStopY)
	local ship = mShipList[shipId]
	if ship then
		
		if ship.move then
			length = #ship.move.path
			if ship.move.path[length-1] == nStopX and ship.move.path[length] == nStopY then
				local length = #ship.move.path
			else
				ship.move = nil
			end
		end
	end
	
end

function DISAPPEAR(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	-- print("DISAPPEAR" .. id)
	-- local intoSuccess = false
	local hero = mHeroManager.GetHero()
	if id ~= hero.id and mCharList[id] then
		DestroyChar(mCharList[id])
		-- intoSuccess = true
	end
	
	
	-- if hero.SceneType == SceneType.Battle then
		-- table.insert(hero.battleLog, string.format("%d,Disappear %s",id,intoSuccess))
	-- end
end

function SEND_PLAYER_SYNC_OUT_OF_VIEW(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	-- print("DISAPPEAR" .. id)
	-- local intoSuccess = false
	local hero = mHeroManager.GetHero()
	local char = mCharList[id]
	if id ~= hero.id and char and not char.battleId then
		char.outView = true
		DestroyChar(mCharList[id])
		-- intoSuccess = true
	end
	
	-- if hero.SceneType == SceneType.Battle then
		-- table.insert(hero.battleLog, string.format("%d,OutBattleView %s",id,intoSuccess))
	-- end
end

function ClearAll()
	local destroyList = {}
	-- print(mCharList)
	for id,_ in pairs(mCharList) do
		destroyList[#destroyList+1] = id
	end
	for k,id in pairs(destroyList) do
		-- print(mCharList[id])
		DestroyChar(mCharList[id])
	end
	
	destroyList = {}
	for id,_ in pairs(mShipList) do
		destroyList[#destroyList+1] = id
	end
	for k,id in pairs(destroyList) do
		DestroyShip(id)
	end
	notShowHideTip = true
end

function StarMove(cs_ByteArray)
	-- print("StarMove")
	local shipIndex = ByteArray.ReadInt(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	local shipId = mCommonlyFunc.GetUid(id,CharacterType.Player,shipIndex)
	local ship = mShipList[shipId]
	local mHero = mHeroManager.GetHero()
	if mHero.id == id then
		return
	end
	if not ship or ship.dead or not ship.mainShip then
		return
	end
	local cur_X = ByteArray.ReadShort(cs_ByteArray)
	local cur_Y = ByteArray.ReadShort(cs_ByteArray)
	local path_X = ByteArray.ReadShort(cs_ByteArray)
	local path_Y = ByteArray.ReadShort(cs_ByteArray)
	local override = ByteArray.ReadBool(cs_ByteArray)
	ByteArray.ReadShort(cs_ByteArray)
	
	local map = ByteArray.ReadByte(cs_ByteArray)
	if mHero.map ~= map then
		return
	end
	if ship and (cur_X ~= path_X or cur_Y ~= path_Y) then
		local move = ship.move or {}
		local path = nil
		if override then
			path = {}
		else
			path = move.path or {}
		end
		-- print(ship.x, path_X)
		path_X = mCommonlyFunc.RevisePathX(ship.x, path_X)
		-- print(path_X)
		table.insert(path, path_X)
		table.insert(path, path_Y)

		mMoveManager.StarMove(ship, path)
	end
end


function EnemyIntoView(cs_ByteArray)
	-- print("EnemyIntoView!!!!!")
	local enemy = mCharacter.ReadEnemyData(cs_ByteArray)
	
	if not enemy then
		return
	end
	-- enemy.fake = nil
	if not mCharList[enemy.id] then
		InitChar(enemy)
		mEventManager.RemoveAllEveListen(enemy)
	else
		if mCharList[enemy.id].battleId then
			mBattleManager.DestroyBattleIcon(enemy)
			mCharList[enemy.id].battleId = nil
		end
		mCharList[enemy.id].fake = nil
	end
	if enemy.ships[1] and enemy.ships[1].move then
		mMoveManager.UpdateDir(enemy.ships[1])
	end
	
	AppearEvent(nil,EventType.OnRefreshGuide)
end

function SYNC_FAKE_ENEMY(cs_ByteArray)
	-- print("SYNC_FAKE_ENEMY!!!!!")
	
	local mHero = mHeroManager.GetHero()
	if mHero.SceneType == SceneType.Battle then
		return
	end
	
	local enemy = mCharacter.ReadEnemyData(cs_ByteArray)
	if not enemy then
		return
	end

	enemy.fake = true
	-- print(enemy.id)
	if not mCharList[enemy.id] then
		InitChar(enemy)
		mEventManager.RemoveAllEveListen(enemy)
	end
	if enemy.ships[1] and enemy.ships[1].move then
		mMoveManager.UpdateDir(enemy.ships[1])
	end
	
	AppearEvent(nil,EventType.OnRefreshGuide)
end


function EnemyStarMove(cs_ByteArray)
	-- print("EnemyStarMove!!!!!")
	local type = ByteArray.ReadByte(cs_ByteArray)
	local dwEnemyUin = ByteArray.ReadInt(cs_ByteArray)
	local nindex = 1
	
	-- print(dwEnemyUin, CharacterType.Enemy, nindex)
	local nShipId = mCommonlyFunc.GetUid(dwEnemyUin,type,nindex)
	
	local cur_X = ByteArray.ReadShort(cs_ByteArray)
	local cur_Y = ByteArray.ReadShort(cs_ByteArray)
	local path_X = ByteArray.ReadShort(cs_ByteArray)
	local path_Y = ByteArray.ReadShort(cs_ByteArray)
	
	local ship = mShipList[nShipId]
	if not ship or ship.dead then
		return
	end
	if ship and (cur_X ~= path_X or cur_Y ~= path_Y) then
		-- print("EnemyStarMove", nShipId)
		-- local isMove = ship.move
		-- ship.move = {}
		-- ship.move.path = {path_X, path_Y}
		
		-- mMoveManager.UpdateDir(ship)
		-- if not isMove then
		path_X = mCommonlyFunc.RevisePathX(ship.x, path_X)
		mMoveManager.StarMove(ship, {path_X, path_Y})
		-- end
	end
end

function EnemyDISAPPEAR(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	-- print("EnemyDISAPPEAR  " .. id)
	if mCharList[id] then
		DestroyChar(mCharList[id])
	end
end

function SEND_ENEMY_SYNC_OUT_OF_VIEW(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	-- print("EnemyDISAPPEAR  " .. id)
	if mCharList[id] and not mCharList[id].battleId then
		DestroyChar(mCharList[id])
	end
end

function SERVER_FORCE_SET_CLIENT_POS(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	local lastX = ByteArray.ReadShort(cs_ByteArray)
	local lastY = ByteArray.ReadShort(cs_ByteArray)
	local stop = ByteArray.ReadBool(cs_ByteArray)
	
	-- print("!!!!!!!!!!!!!!!!!!!!!!!!SERVER_FORCE_SET_CLIENT_POS  " .. id)
	local char = mCharList[id]
	if char then
		char.x = lastX
		char.y = lastY
		char.ships[1].x = lastX
		char.ships[1].y = lastY
		if stop then
			char.ships[1].move = nil
		end
		
		RequestForcePosSuc()
		
		mSceneManager.Update(true)
	end
end

function RequestForcePosSuc()
	print("RequestForcePosSuc")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_REPLY_FORCE_POS)
	mNetManager.SendData(cs_ByteArray)
end

function EnemyCLIENT_STOP(cs_ByteArray)
	-- print("EnemyCLIENT_STOP")
	local type = ByteArray.ReadByte(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	local index = 1
	local nStopX = ByteArray.ReadShort(cs_ByteArray)
	local nStopY = ByteArray.ReadShort(cs_ByteArray)
	
	local shipId = mCommonlyFunc.GetUid(id,type,index)
	local ship = mShipList[shipId]
	if ship then
		ship.move = nil
	end
	-- if ship and ship.x ~= nStopX and ship.y ~= nStopY then
		-- ship.move = {}
		-- ship.move.path = {nStopX, nStopY}
		-- mMoveManager.UpdateDir(ship)
	-- end
end

function SEND_HOME_TITLE(cs_ByteArray)
	-- print("SEND_HOME_TITLE")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local familyId = ByteArray.ReadInt(cs_ByteArray)
	local familyName = ByteArray.ReadUTF(cs_ByteArray,40)
	local post = ByteArray.ReadByte(cs_ByteArray)
	
	local char = GetChar(id)
	if char then
		char.familyId = familyId
		char.familyName = familyName
		char.post = post
		mCommonlyFunc.UpdateTitle(char)
	end
	local hero = mHeroManager.GetHero()
	if id == hero.id then
		AppearEvent(nil, EventType.FamilyJoin)
		
		mLogbookManager.AddLog(LogbookType.Family, os.oldTime, true, familyName)
	end
end

function SEND_DEL_HOME_TITLE(cs_ByteArray)
	-- print("SEND_DEL_HOME_TITLE")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local char = GetChar(id)
	
	local hero = mHeroManager.GetHero()
	if id == hero.id then
		AppearEvent(nil, EventType.FamilyDel)
		
		mLogbookManager.AddLog(LogbookType.Family, os.oldTime, false, char.familyName)
		mHarborManager.DelFamilyHarbor()
	end
	
	if char then
		char.familyId = nil
		char.familyName = nil
		char.post = nil
		mCommonlyFunc.UpdateTitle(char)
	end
end

function ShipTeamIntoView(cs_ByteArray)
	-- print("ShipTeamIntoView")
	local shipTeam = mCharacter.ReadShipTeamData(cs_ByteArray)
	-- print(shipTeam.ships)
	if not shipTeam then
		return
	end
	-- shipTeam.fake = nil
	if not mCharList[shipTeam.id] then
		-- print("InitChar", enemy.x, enemy.y)
		InitChar(shipTeam)
		-- mEventManager.RemoveAllEveListen(shipTeam)
	else
		if mCharList[shipTeam.id].battleId then
			mBattleManager.DestroyBattleIcon(shipTeam)
			mCharList[shipTeam.id].battleId = nil
		end
		mCharList[shipTeam.id].fake = nil
	end
	if shipTeam.ships[1] and shipTeam.ships[1].move then
		mMoveManager.UpdateDir(shipTeam.ships[1])
	end
end

function SYNC_FAKE_MERCHANT(cs_ByteArray)
	-- print("SYNC_FAKE_MERCHANT")
	
	local mHero = mHeroManager.GetHero()
	if mHero.SceneType == SceneType.Battle then
		return
	end
	
	local shipTeam = mCharacter.ReadShipTeamData(cs_ByteArray)
	if not shipTeam then
		return
	end
	shipTeam.fake = true
	if not mCharList[shipTeam.id] then
		InitChar(shipTeam)
	end
	if shipTeam.ships[1] and shipTeam.ships[1].move then
		mMoveManager.UpdateDir(shipTeam.ships[1])
	end
end

function SYNC_BATTLE_HARBOR(cs_ByteArray)
	print("SYNC_BATTLE_HARBOR")
	local harbor = mCharacter.ReadHarborData(cs_ByteArray)
	if not harbor then
		return
	end
	if not mCharList[harbor.id] then
		-- print("InitChar", enemy.x, enemy.y)
		InitChar(harbor)
		-- mEventManager.RemoveAllEveListen(shipTeam)
	end
	if harbor.ships[1] and harbor.ships[1].move then
		mMoveManager.UpdateDir(harbor.ships[1])
	end
end


function SEND_SHIP_DESTROY(cs_ByteArray)
	-- print("SEND_SHIP_DESTROY!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
	
	local hero = mHeroManager.GetHero()
	local count = ByteArray.ReadInt(cs_ByteArray)
	local cid = ByteArray.ReadInt(cs_ByteArray)
	-- print(count, cid)
	if hero.id == cid then
		return
	end
	local char = mCharList[cid]
	-- print(char)
	if not char then
		return
	end
	mBattleManager.DestroyBattleIcon(char)
	
	for j=1,count do
		local sid = ByteArray.ReadInt(cs_ByteArray)
		-- print(sid)
		for i=1,3 do
			local ship = char.ships[i]
			if ship and ship.index == sid then
				-- print(1111)
				table.remove(char.ships, i)
				
				if ship.perShip then
					ship.perShip.lastShip = ship.lastShip
				end
				if ship.lastShip then
					ship.lastShip.perShip = ship.perShip
				end
				mMoveManager.ReFollow(ship)
				-- print(2222)
				DestroyShip(ship.id)
				break
			end
		end
	end
	
	if char.ships[1] then
		char.ships[1].mainShip = true
		char.x = char.ships[1].x
		char.y = char.ships[1].y
		
		if char.csTitle then
			m3DTextManager.SetPosition(char.csTitle, char.x, 95, char.y)
		end
	end
end

function SEND_PROTECT_STATE(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	local state = ByteArray.ReadBool(cs_ByteArray)
	local char = GetChar(id)
	if char then
		char.protectState = state
		mCommonlyFunc.UpdateTitle(char)
	end
end

function SEND_CHG_SPEED(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	local speed = ByteArray.ReadShort(cs_ByteArray)
	local char = GetChar(id)
	if char then
		char.speed = speed
	end
	
	local hero = mHeroManager.GetHero()
	if hero.id == id then
		hero.realSpeed = speed * 9
	end
end

function SEND_PLAYER_MODE_CHG(cs_ByteArray)
	-- print("SEND_PLAYER_MODE_CHG")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local mode = ByteArray.ReadByte(cs_ByteArray)
	local char = GetChar(id)
	if char then
		char.mode = mode
		mCommonlyFunc.UpdateTitle(char)
	end
	
	local hero = mHeroManager.GetHero()
	if hero.id == id then
		mGoodsManager.CleanGoodsPriceList()
	end
end

function SEND_SET_TITLE(cs_ByteArray)
	-- print("SEND_SET_TITLE")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local title = ByteArray.ReadByte(cs_ByteArray)
	local char = GetChar(id)
	if char then
		DestroyTitleImage(char)
		char.title = title
		if char.title ~= 0 then
			InitTitleImage(char)
			if char.csTitleImage then
				CsSetPosition(GetTransform(char.csTitleImage), char.x+30, 100, char.y)
			end
		end
		
	end
end