local os,require,print,PackatHead,Packat_Player,ByteArray = 
os,require,print,PackatHead,Packat_Player,ByteArray
local mTimer = nil
local mCommonlyFunc = nil
local mNetManager = nil
local mAlert = nil
local mHeroManager = nil
local mActivityManager = nil

module("LuaScript.Control.System.TimeCheckManager")
-- local mLastCheckTime = nil

function Init()
	mAlert = require "LuaScript.View.Alert.Alert"
	mTimer = require "LuaScript.Common.Timer"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_CLIENT_SPEED_UP_WARNDING, SEND_CLIENT_SPEED_UP_WARNDING)
	
	-- mLastCheckTime = os.time()
	mTimer.SetInterval(Check, 60)
end

function Check()
	-- if os.oldTime - mLastCheckTime < 5 then
		-- mNetManager.Close()
		-- mAlert.Show("游戏速度异常,请重新登录游戏,错误值:10000",mCommonlyFunc.QuitGame)
		-- return
	-- end
	
	local hero = mHeroManager.GetHero()
	if hero and hero.realSpeed and hero.speed * 9 ~= hero.realSpeed  then
		mNetManager.Close()
		mAlert.Show("游戏速度异常,请重新登录游戏,错误值:10001",mCommonlyFunc.QuitGame)
		return
	end
	
	-- mLastCheckTime = os.oldTime
end

function SEND_CLIENT_SPEED_UP_WARNDING()
	mNetManager.Close()
	mAlert.Show("游戏速度异常,请重新登录游戏,错误值:10003",mCommonlyFunc.QuitGame)
end

function WaitCheck()
	function func()
		local server = mActivityManager.GetServerTime()
		if not server then
			return
		end
		local cs_ByteArray = ByteArray.Init()
		ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
		ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_SEND_SERVER_TIME)
		ByteArray.WriteInt(cs_ByteArray,server)
		mNetManager.SendData(cs_ByteArray)
	end
	
	mTimer.SetTimeout(func, 10)
end