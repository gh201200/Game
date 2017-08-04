local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,CFG_action,AppearEvent,EventType,GUIStyleButton,GameObject,debug,CFG_harbor,GetTransform = 
Color,os,ConstValue,pairs,math,CFG_action,AppearEvent,EventType,GUIStyleButton,GameObject,debug,CFG_harbor,GetTransform
local CsSetParent = CsSetParent
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mTimer = require "LuaScript.Common.Timer"
local mCameraManager = nil
local mDialogPanel = nil
local mEventManager = nil
local mBulletManager = nil
local mCharManager = nil
local mHeroManager = nil
local mSceneManager = nil
local mTransparentPanel = nil
local mHarborManager = nil

module("LuaScript.View.Animation.AttackHarbor2")
panelType = ConstValue.GuidePanel
notAutoClose = true
local mOverFunc = nil

function Start(overFunc)
	mOverFunc = overFunc
	mCameraManager = require "LuaScript.Control.CameraManager"
	mDialogPanel = require "LuaScript.View.Panel.Task.DialogPanel"
	mEventManager = require "LuaScript.Control.EventManager"
	mBulletManager = require "LuaScript.Control.Scene.BulletManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mTransparentPanel = require "LuaScript.View.Animation.TransparentPanel"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mSceneManager.SetMouseEvent(false)
	
	Step1()
end

function Step1()
	local cfg_harbor = CFG_harbor[212]
	local toX = cfg_harbor.x
	local toY = cfg_harbor.y
	local time = 1
	local viewX,viewY = mCameraManager.GetView()
	local moveX = toX - viewX
	local moveY = toY - viewY
	local startTime = os.oldClock
	
	
	-- local hero = mHeroManager.GetHero()
	-- local mCsScene = GameObject.Find("Scene")
	-- local csShip = mCharManager.GetCsShip(hero.ships[1].id)
	-- CsSetParent(GetTransform(csShip), GetTransform(mCsScene))
	
	mPanelManager.Show(mTransparentPanel)
	
	
	local timer = mTimer.SetInterval(nil, 0.01)
	function MoveCamera()
		local overTime = os.oldClock - startTime
		local change = math.sin(overTime * math.pi * 0.5)
		local x = viewX + moveX * change
		local y = viewY + moveY * change
		local oldViewX,oldViewY = mCameraManager.GetView()
		mCameraManager.SetView(x, y)

		-- local waveX = (x-oldViewX)/os.deltaTime
		-- local waveY = (y-oldViewY)/os.deltaTime
		-- mSceneManager.SetWaveDir(waveX, waveY)
		mSceneManager.Update(true)
		if overTime >= time then
			Step2()
			mTimer.RemoveTimer(timer)
			-- mSceneManager.SetWaveDir(0, 0)
		end
	end
	timer.func = MoveCamera
	
	
	-- local data = {}
	-- data.type = CharacterType.Enemy
	-- data.id = -1
	
	-- local eid = 1
	-- local cfg_Enemy = CFG_Enemy[eid]
	-- data.name = cfg_Enemy.name
	-- data.resId = cfg_Enemy.resId
	-- data.level = cfg_Enemy.level
	-- data.power = 99999
	-- data.eid = eid
	-- data.ships = {}
	
	-- local bid = 1
	-- local nShipHp = 100
	-- local nShipMaxHp = 100
	-- local nindex = 1
	-- local nShipId = mCommonlyFunc.GetUid(data.id,CharacterType.Enemy,nindex)
	-- local wShipX = 3182
	-- local wShipY = 815
	
	-- local ship = {}
	-- ship.bid = bid
	-- ship.index = nindex
	-- ship.cid = data.id
	-- ship.id = nShipId
	-- ship.hp = nShipHp
	-- ship.maxHp = nShipMaxHp
	-- ship.x = wShipX
	-- ship.y = wShipY
	-- ship.dead = nShipHp==0
	
	-- data.ships[nindex] = ship
	-- data.x = data.ships[nindex].x
	-- data.y = data.ships[nindex].y
	-- data.speed = 0
	-- mCharManager.InitChar(data)
end

function Step2()
	mDialogPanel.SetData(6001)
	mPanelManager.Hide(mTransparentPanel)
	mPanelManager.Show(mDialogPanel)
	
	function overFunc()
		-- print("overFunc")
		Step3()
		mEventManager.RemoveEventListen(nil,EventType.OnCloseDialogPanel,overFunc)
		mPanelManager.Show(mTransparentPanel)
	end
	
	mEventManager.AddEventListen(nil,EventType.OnCloseDialogPanel,overFunc)
end

function Step3()
	local mTimerList = {}
	-- local enemyList = mCharManager.GetEnemyList(15)
	-- local enemyList = mCharManager.GetEnemyList(17, enemyList)
	local enemyList = mCharManager.GetEnemyList(293, enemyList)
	local enemyList = mCharManager.GetEnemyList(294, enemyList)
	-- print(enemyList)
	for k,enemy in pairs(enemyList) do
		-- print(enemy)
		function func()
			local fromShip = enemy.ships[1]
			local fromCsShip = mCharManager.GetCsShip(fromShip.id)
			
			local cfg_harbor = CFG_harbor[212]
			local toShip = {id=212, hp=999, x=cfg_harbor.showX, y=cfg_harbor.showY,bid=69}
			local startTime = os.oldClock
			
			local timer = mTimer.SetInterval(nil, math.random()*0.5+1.8)
			local AttackFunc = function()
				-- print(222)
				local toCsShip = mHarborManager.GetActiveCsHarbor(212)
				-- print(mHarborManager.mActiveCsHarborById)
				-- print(toCsShip)
				if toCsShip and toCsShip.activeSelf and fromCsShip.activeSelf then
					mBulletManager.InitBullet(4, 0, 1, 200+math.random(50), 500, fromCsShip, toCsShip, fromShip, toShip)
				end
				-- if os.oldClock - startTime > 2 then
					-- mTimer.RemoveTimer(timer)
				-- end
			end
			local env = {timer=timer,fromCsShip=fromCsShip,fromShip=fromShip,mHarborManager=mHarborManager,
				mBulletManager=mBulletManager,mTimer=mTimer,startTime=startTime,toShip=toShip,os=os}
			debug.setfenv(AttackFunc, env)
			timer.func = AttackFunc
			AttackFunc()
			table.insert(mTimerList, timer)
		end
		
		mTimer.SetTimeout(func, 0.5 * k)
	end
	
	local startTime = os.oldClock
	local timer = mTimer.SetInterval(nil, 1.5)
	local AttackFunc = function()
		local cfg_harbor = CFG_harbor[212]
		local fromShip = {id=212, hp=999, x=cfg_harbor.showX, y=cfg_harbor.showY}
		local fromCsShip = mHarborManager.GetActiveCsHarbor(212)
	
		local enemy = mCharManager.GetNearEnemy(15, cfg_harbor.showX, cfg_harbor.showY)
		if enemy then
			local toShip = enemy.ships[1]
			local toCsShip = mCharManager.GetCsShip(toShip.id)
			
			if fromCsShip and toCsShip.activeSelf and fromCsShip.activeSelf then
				mBulletManager.InitBullet(5, 4, 1, 300+math.random(50), 500, fromCsShip, toCsShip, fromShip, toShip)
			end
		end
		-- if os.oldClock - startTime > 2 then
			-- mTimer.RemoveTimer(timer)
		-- end
	end
	local env = {timer=timer,mHarborManager=mHarborManager,CFG_harbor=CFG_harbor,
		mBulletManager=mBulletManager,mTimer=mTimer,startTime=startTime,os=os}
	debug.setfenv(AttackFunc, env)
	timer.func = AttackFunc
	AttackFunc()
	table.insert(mTimerList, timer)
	
	
	function stopFunc()
		mEventManager.RemoveEventListen(nil, EventType.IntoHarbor, stopFunc)
		mEventManager.RemoveEventListen(nil, EventType.IntoBattleScene, stopFunc)
		mEventManager.RemoveEventListen(nil, EventType.IntoNormalScene, stopFunc)
		
		for k,timer in pairs(mTimerList) do
			mTimer.RemoveTimer(timer)
		end
	end
	mEventManager.AddEventListen(nil, EventType.IntoHarbor, stopFunc)
	mEventManager.AddEventListen(nil, EventType.IntoBattleScene, stopFunc)
	mEventManager.AddEventListen(nil, EventType.IntoNormalScene, stopFunc)
	
	function LookOver()
		Step4()
	end
	mTimer.SetTimeout(LookOver, 2)
end

function Step4()
	local hero = mHeroManager.GetHero()
	local toX = hero.x
	local toY = hero.y
	local time = 1
	local viewX,viewY = mCameraManager.GetView()
	local moveX = toX - viewX
	local moveY = toY - viewY
	local startTime = os.oldClock
	
	local timer = mTimer.SetInterval(MoveCamera, 0.01)
	function MoveCamera()
		local overTime = os.oldClock - startTime
		local change = math.sin(overTime * math.pi * 0.5)
		local x = viewX + moveX * change
		local y = viewY + moveY * change
		local oldViewX,oldViewY = mCameraManager.GetView()
		mCameraManager.SetView(x, y)
		
		-- local waveX = (x-oldViewX)/os.deltaTime
		-- local waveY = (y-oldViewY)/os.deltaTime
		-- mSceneManager.SetWaveDir(waveX, waveY)
		mSceneManager.Update(true)
		if overTime >= time then
			mTimer.RemoveTimer(timer)
			-- mSceneManager.SetWaveDir(0, 0)
			
			-- local hero = mHeroManager.GetHero()
			-- local mCsScene = GameObject.Find("Scene")
			-- local csShip = mCharManager.GetCsShip(hero.ships[1].id)
			-- CsSetParent(GetTransform(csShip), nil)
			mPanelManager.Hide(mTransparentPanel)
			mSceneManager.SetMouseEvent(true)
			
			mOverFunc()
		end
	end
	timer.func = MoveCamera
end