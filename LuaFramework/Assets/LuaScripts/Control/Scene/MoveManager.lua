local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray = print,Instantiate,EventType,Space,math,os,Vector3,ByteArray
local PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Screen,ConstValue = 
PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Screen,ConstValue
local CFG_ship,CharacterType,_G,CsSetPosition,GetTransform,CsRotate,_print,VersionCode,CFG_fishArea = 
CFG_ship,CharacterType,_G,CsSetPosition,GetTransform,CsRotate,_print,VersionCode,CFG_fishArea
local mHeroManager = nil
local mCharManager = nil
local mSceneManager = nil
local mBombEffectManager = nil
local mWaveManager = nil
local mCameraManager = nil
local mNpcShipTeamManager = nil
local m3DTextManager = nil

module("LuaScript.Control.Scene.MoveManager")

function Init()
	mNpcShipTeamManager = require "LuaScript.Control.Data.NpcShipTeamManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mBombEffectManager = require "LuaScript.Control.Scene.BombEffectManager"
	mWaveManager = require "LuaScript.Control.Scene.WaveManager"
	mCameraManager = require "LuaScript.Control.CameraManager"
	m3DTextManager = require "LuaScript.Control.Scene.3DTextManager"
end

function Follow(ship, lastShip)
	if not ship then
		-- print(1111111111111)
		return false
	end
	
	local cfg_ship = CFG_ship[ship.bid]
	local cfg_lastship = CFG_ship[lastShip.bid]
	local spacing = (cfg_ship.scale*100 + cfg_lastship.scale*100) * 0.5
	
	local disX = lastShip.x - ship.x
	local disY = lastShip.y - ship.y
	local shipDis = math.sqrt(disX * disX + disY * disY)
	if shipDis > spacing + 1 then
		local mToPoint = {}
		if ship.move then
			local targetDisX = ship.x - ship.move.path[1]
			local targetDisY = ship.y - ship.move.path[2]
			local targetDis = math.sqrt(targetDisX*targetDisX + targetDisY*targetDisY)
			if targetDis > spacing then
				table.insert(mToPoint, ship.x)
				table.insert(mToPoint, ship.y)
				
				table.insert(mToPoint, ship.move.path[1] + targetDisX * spacing / targetDis)
				table.insert(mToPoint, ship.move.path[2] + targetDisY * spacing / targetDis)
			else
				local targetDisX = lastShip.x - ship.move.path[1]
				local targetDisY = lastShip.y - ship.move.path[2]
				local targetDis = math.sqrt(targetDisX*targetDisX + targetDisY*targetDisY)
				
				if targetDis > spacing then
					table.insert(mToPoint, ship.move.path[1] + targetDisX * spacing / targetDis)
					table.insert(mToPoint, ship.move.path[2] + targetDisY * spacing / targetDis)
				else
					-- print(22222222222)
					return false
				end
			end
		else
			local targetDisX = lastShip.x - ship.x
			local targetDisY = lastShip.y - ship.y
			local targetDis = math.sqrt(targetDisX*targetDisX + targetDisY*targetDisY)

			table.insert(mToPoint, ship.x + targetDisX * spacing / targetDis)
			table.insert(mToPoint, ship.y + targetDisY * spacing / targetDis)
		end
		
		StarMove(lastShip, mToPoint)
		-- UpdateDir(ship)
		return true
	else
		-- ReFollow(lastShip)
		-- print(3333333333)
		return false
	end
end

function ReFollow(ship)
	if ship.lastShip then
		ship.lastShip.move = nil
		Follow(ship.lastShip.perShip, ship.lastShip)
		
		ReFollow(ship.lastShip)
	end
end

function UpdateDir(ship)
	local moveX = ship.move.path[1] - ship.x
	local moveY = ship.move.path[2] - ship.y
	if moveX == 0 and moveY == 0 then
		return
	end
	local rotation = 0
	if moveX >= 0 and moveY >= 0 then
		rotation = math.atan(moveX/moveY) / math.pi * 180
	elseif moveX <= 0 and moveY >= 0 then
		rotation = math.atan(moveX/moveY) / math.pi * 180 + 360
	elseif moveX <= 0 and moveY <= 0 then
		rotation = math.atan(moveX/moveY) / math.pi * 180 + 180
	else
		rotation = math.atan(moveX/moveY) / math.pi * 180 + 180
	end
	ship.rotation = rotation
	
	UpdateWaveDir(ship)
end

function UpdateWaveDir(ship)
	-- if VersionCode > 5 then
		-- return
	-- end
	-- local hero = mHeroManager.GetHero()
	-- if hero.id ~= ship.cid or not ship.mainShip then
		-- return
	-- end
	-- if ship.move then
		-- local moveX = ship.move.path[1] - ship.x
		-- local moveY = ship.move.path[2] - ship.y
		-- local length = math.sqrt(moveX*moveX + moveY*moveY)
		-- if length ~= 0 then
			-- moveX = moveX * hero.speed / length
			-- moveY = moveY * hero.speed / length
		-- else
		-- end
	-- else
	-- end
end

function UpdateAngles(ship)
	if ship.dead then
		return
	end
	local cs_ship = mCharManager.GetCsShip(ship.id)
	if not cs_ship then
		ship.angles = ship.rotation
		ship.rotation = nil
		return
	end
	
	ship.angles = ship.angles or 0
	local difference = ship.rotation - ship.angles
	
	local absDifference = math.abs(difference)
	local change = 5
	if absDifference < 5 then
		change = difference
		ship.rotation = nil
	elseif difference >= 0 and absDifference < 180 then
		change = 5
	elseif difference >= 0 and absDifference >= 180 then
		change = -5
	elseif difference < 0 and absDifference < 180 then
		change = -5
	else
		change = 5
	end

	CsRotate(GetTransform(cs_ship),0,change,0)
	ship.angles = (ship.angles + change + 360) % 360
	-- print("!!!!!!!!!!!!"..ship.angles)
end

function Move(mChar, ship)
	-- os.oldClock = os.clock()
	if ship.dead then
		return
	end
	local mHero = mHeroManager.GetHero()
	if mHero.SceneType ~= SceneType.Battle and mChar.battleId then
		return
	end
	
	local moveX = ship.move.path[1] - ship.x
	local moveY = ship.move.path[2] - ship.y
	local moveL = math.sqrt(moveX*moveX + moveY*moveY)
	local moveDis = os.deltaTime * mChar.speed
	if moveL <= moveDis then
		ship.x = ship.move.path[1]
		ship.y = ship.move.path[2]
		if ship.mainShip then
			mChar.x = ship.x
			mChar.y = ship.y
		end
		
		if not ship.move.path[3] then
			OverMove(ship)
		else
			NodeOver(ship)
		end
	else
		local deltaX = moveX * moveDis / moveL
		local deltaY = moveY * moveDis / moveL
		ship.x = ship.x + deltaX
		ship.y = ship.y + deltaY
		if ship.mainShip then
			mChar.x = ship.x
			mChar.y = ship.y
		end
	end
	
	
	
	TestWave(ship)
	-- os.oldClock = os.clock()
	
	UpdatePosition(ship)
	
	
	
	-- os.oldClock = os.clock()
	
	local target = mHeroManager.GetTarget()
	if target and (target.type == ConstValue.PlayerType or target.type == ConstValue.AttackPlayerType )
		and target.value.char == mChar then
		mHeroManager.CheckAttackShip(ship)
	end
	
	if ship.lastShip and not ship.lastShip.move then
		Follow(ship, ship.lastShip)
	end
	
end

function TestWave(ship)
	local cs_Ship = mCharManager.GetCsShip(ship.id)
	if not cs_Ship then
		return
	end
	
	if not ship.move then
		local spacingTime = 3
		local lastWaveTime = ship.lastWaveTime or 0
		if os.oldClock - lastWaveTime > spacingTime then
			ship.lastWaveTime = os.oldClock - math.random()
			mWaveManager.InitWave(ship, 1)
		end
	else
		local spacingTime = 0.14
		local lastWaveTime = ship.lastWaveTime or 0
		if os.oldClock - lastWaveTime > spacingTime then
			ship.lastWaveTime = os.oldClock
			mWaveManager.InitWave(ship, 0)
		end
	end
	
end

function UpdatePosition(ship)
	local hero = mHeroManager.GetHero()
	if ship.mainShip then
		local char = mCharManager.GetChar(ship.cid)
		if not char.csTitle then
			if ship.cid == hero.id then
				mHeroManager.InitTitle(char)
			else
				mCharManager.InitTitle(char)
			end
		end
		if char.csTitle then
			m3DTextManager.SetPosition(char.csTitle, ship.x, 95, ship.y)
		end
		
		if hero.SceneType ~= SceneType.Battle then
			if not char.csTitleImage then
				mCharManager.InitTitleImage(char)
			end
			if char.csTitleImage then
				CsSetPosition(GetTransform(char.csTitleImage), ship.x+30, 100, ship.y)
			end
		end
	end
	
	
	local cs_Ship = mCharManager.GetCsShip(ship.id)
	if not cs_Ship then
		return
	end
	CsSetPosition(GetTransform(cs_Ship), ship.x, 0, ship.y)
	
	if hero.SceneType == SceneType.Battle then
		if not ship.csHpBar then
			mCharManager.InitHpBar(ship)
		end
		CsSetPosition(GetTransform(ship.csHpBar), ship.x-43, 98, ship.y)
	end
	
	
	-- local t =os.time()
	-- _G.UpdateSecondTime[t] = _G.UpdateSecondTime[t] or 0
	-- _G.UpdateSecondTime[t] = _G.UpdateSecondTime[t] + os.clock() - os.oldClock
	-- _G.UpdateSecondTime[-t] = _G.UpdateSecondTime[-t] or 0
	-- _G.UpdateSecondTime[-t] = _G.UpdateSecondTime[-t] + 1
end

function StarMove(ship, path)
	-- if path[1] > 0 then
		-- _print(ship.id, path[1])
	-- end
	if not ship then
	  return
	end
	ship.move = {}
	ship.move.path = path
	
	UpdateDir(ship)
	ReFollow(ship)
	
	local hero = mHeroManager.GetHero()
	if ship.cid == hero.id then
		mHeroManager.StarMove(ship, path)
	end
end

function NodeOver(ship)
	local hero = mHeroManager.GetHero()
	table.remove(ship.move.path, 1)
	table.remove(ship.move.path, 1)
	UpdateDir(ship)
	
	if ship.cid == hero.id then
		mHeroManager.NodeOver(ship)
	end
end

function OverMove(ship)
	ship.move = nil
	local hero = mHeroManager.GetHero()
	if ship.cid == hero.id then
		mHeroManager.OverMove(ship)
	end
	if ship.perShip then
		Follow(ship.perShip, ship)
	end
	
	local char = mCharManager.GetChar(ship.cid)
	if ship.mainShip and char.type == CharacterType.NpcShipTeam then
		mNpcShipTeamManager.OverMove(char)
	end
end