local RunStaticFunc,Camera,platform,print,SKD_name,require,tostring,ConstValue,os,math,LjPlatformType, YJPlatformType,IPhonePlayer, luanet = 
RunStaticFunc,Camera,platform,print,SKD_name,require,tostring,ConstValue,os,math,LjPlatformType, YJPlatformType,IPhonePlayer, luanet
local Android,ServerNum = Android,ServerNum
local mHeroManager = nil
local mAccountManager = nil
local mLoginPanel = nil
module("LuaScript.Mode.Object.SDK")

-- logo图标名称
logoName = "logo"

function Init()
	if not platform then
		return
	end
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mAccountManager = require "LuaScript.Control.Data.AccountManager"
	mLoginPanel = require "LuaScript.View.Panel.Login.LoginPanel"
	
	if platform == "main" then
		logoName = "logo2"
	end
	
	if platform == "main" and not IPhonePlayer then
		return
	end
	
	
	if platform == "uc" then
		Camera.mainCamera.gameObject:AddComponent("UCCallbackMessage")
	elseif platform == "yj" then
		luanet.load_assembly("UnityEngine")
		local GameObject = luanet.import_type("UnityEngine.GameObject")
		local go = GameObject("YJCallback")
		go:AddComponent("YJCallback")
		logoName = RunStaticFunc(SKD_name, "GetMetaData", "logoname")
		logoName = logoName or "logo"
		-- Camera.mainCamera.gameObject:AddComponent("YJCallback")
	else
		Camera.mainCamera.gameObject:AddComponent("CallbackMessage")
	end
	ShowFloatButton(0,500,true)
end

function InitSDK(debugMode,loglevel,cpId,gameId,serverId,serverName,enablePayHistory,enableLogout)
	if not platform then
		return
	end
	if platform == "main" then
		return
	end
	if platform == "uc" then
		return RunStaticFunc(SKD_name, "initSDK", debugMode,loglevel,cpId,gameId,serverId,serverName,
			enablePayHistory,enableLogout)
	elseif platform == "91" or platform == "91IOS"  then
		return RunStaticFunc(SKD_name, "initSDK")
	elseif platform == "mi" then
		return RunStaticFunc(SKD_name, "initSDK")
	end
end

-- function SetOrientation(orientation)
	-- if not platform then
		-- return
	-- end
	-- return RunStaticFunc(SKD_name, "setOrientation", orientation)
-- end

function Login(enableGameAccount)
	if platform == "main" then
		return
	end
	if platform == "uc" then
		return RunStaticFunc(SKD_name, "login", enableGameAccount, "征服之海")
	elseif platform == "yj" then
		print("易接登录---lua")
		return RunStaticFunc(SKD_name, "Login")
	else
		return RunStaticFunc(SKD_name, "login")
	end
end

function ShowUserCenter()
	RunStaticFunc(SKD_name, "showUserCenter")
end

function IsLoging()
	if not platform then
		return false
	end
	if platform ~= "yj" and platform ~= "91IOS" and platform ~= "pp" and platform ~= "ky" then
		return false
	end
	return RunStaticFunc(SKD_name, "IsLoging")
end

function GetSid()
	if not platform then
		return
	end
	if platform == "main" then
		return
	end
	return RunStaticFunc(SKD_name, "getLoginUin")
end

function GetLoginUin()
	if not platform then
		return
	end
	return RunStaticFunc(SKD_name, "getLoginUin")
end

function GetChannel()
	if not platform then
		return
	end
	return RunStaticFunc(SKD_name, "getChannel")
end

function GetAppId()
	if not platform then
		return
	end
	return RunStaticFunc(SKD_name, "GetAppId")
end

function GetChannelUid()
	if not platform then
		return
	end
	return RunStaticFunc(SKD_name, "getChannelUid")
end

-- 获取易接下的渠道名称
function GetChannelName()
	if platform == "main" then
		return
	end
	return YJPlatformType[GetChannel()]
end

local mManifestData = {}
function GetManifestData(key)
	if mManifestData[key] then
		return mManifestData[key].value
	end
	mManifestData[key] = {key=key, value=RunStaticFunc(SKD_name, "getManifestData", key)}
	
	return mManifestData[key].value
end
-- function CreateFloatButton()
	-- if not platform then
		-- return
	-- end
	-- return RunStaticFunc(SKD_name, "createFloatButton")
-- end

function ShowFloatButton(x, y, visible)
	if not platform then
		return
	end
	if platform == "main" then
		return
	end
	if platform == "uc" then
		return RunStaticFunc(SKD_name, "showFloatButton", x, y, visible)
	elseif platform == "91" or platform == "91IOS"  or platform == "oppo" then
		if visible then
			return RunStaticFunc(SKD_name, "showFloatButton")
		else
			return RunStaticFunc(SKD_name, "hideFloatButton")
		end
	end
end

function Pay(allowContinuousPay, amount, roleId, roleName, grade, customInfo, notifyUrl)
	if not platform then
		return
	end
	if platform == "uc" then
		local serverName = mAccountManager.GetServerName()
		local serverId = mAccountManager.GetServerId()
		return RunStaticFunc(SKD_name, "pay", allowContinuousPay, amount, 2742, roleId, serverName.."|"..roleName, grade, customInfo..","..ServerNum[serverId], notifyUrl)
	elseif platform == "91" or platform == "91IOS"  then
		return RunStaticFunc(SKD_name, "pay", amount*10, roleId..","..notifyUrl)
	elseif platform == "mi" then
		local hero = mHeroManager.GetHero()
		local serverName = mAccountManager.GetServerName()
		return RunStaticFunc(SKD_name, "pay", amount, hero.gold, hero.vipLevel, hero.level, hero.name, hero.id, serverName, roleId..","..notifyUrl)
	elseif platform == "dk" then
		local hero = mHeroManager.GetHero()
		-- local serverName = mAccountManager.GetServerName()
		return RunStaticFunc(SKD_name, "pay", amount, roleId..","..notifyUrl)
	elseif platform == "hw" then
		return RunStaticFunc(SKD_name, "pay", amount, roleId..","..notifyUrl..","..(os.time()%10000)..math.random(1000))
	elseif platform == "lenovo" then
		return RunStaticFunc(SKD_name, "pay", amount*100, roleId..","..notifyUrl)
	elseif platform == "oppo" then
		return RunStaticFunc(SKD_name, "pay", amount, roleId..","..notifyUrl)
	elseif platform == "pp" then
		local serverId = mAccountManager.GetServerId()
		return RunStaticFunc(SKD_name, "pay", amount, (amount*10).."元宝", roleId..","..notifyUrl, serverId)
	elseif platform == "qxz" then
		return RunStaticFunc(SKD_name, "pay", amount*100, roleId..","..notifyUrl)
	elseif platform == "ky" then
		return RunStaticFunc(SKD_name, "pay", amount, roleId.."_"..notifyUrl)
	elseif platform == "lj" then
		local channel = GetChannel()
		local AccountHead = LjPlatformType[channel].AccountHead
		local str = roleId..","..notifyUrl..","..AccountHead
		-- if AccountHead == "YDMM" or AccountHead == "WO" then
			-- str = str .. "," .. amount
		-- end
		return RunStaticFunc(SKD_name, "pay", amount*100, "元宝", amount*10, str)
	elseif platform == "main" then
		if IPhonePlayer then
			return RunStaticFunc(SKD_name, "pay", amount*10)
		elseif Android then
			return RunStaticFunc(SKD_name, "pay", amount, roleId.."-"..notifyUrl.."-"..(os.time()%10000)..math.random(1000))
		end
	elseif platform == "vivo" then
		return RunStaticFunc(SKD_name, "pay", amount, roleId..","..notifyUrl)
	end
end

-- price: 			游戏道具单位价格，单位-分
-- itemName: 		商品名称
-- count:			购买数量
-- callbackInfo:	由游戏开发者定义传入的字符串，会与支付结果一同发送给游戏服务器，游戏服务器可通过该字段判断交易的详细内容（金额角色等）
-- monthlyCard:		月卡， 0：不够买月卡 1：月卡 2：终身卡
function Pay_YJ(price, itemName, count, callbackInfo, monthlyCard)
	if platform == "yj" then
		local hero = mHeroManager.GetHero()
		print("channelid", GetChannel())
		local channelName = GetChannelName()
		monthlyCard = monthlyCard or 0
		local str = hero.id .. "," .. mLoginPanel.GetServerId() .. "," .. channelName .. "," .. monthlyCard
		print("callbackInfo", str)
		RunStaticFunc(SKD_name, "Pay", price, itemName, count, str)
	end
end

function SetRoleData(roleId, roleName, roleLevel, serverId, serverName)
	if platform == "yj" then
		RunStaticFunc(SKD_name, "SetRoleData", roleId, roleName, roleLevel, serverId, serverName)
	end
end

function SetData(key, value)
	if platform == "yj" then
		RunStaticFunc(SKD_name, "SetData", key, value)
	end
end

-- function Logout()
	-- return RunStaticFunc(SKD_name, "logout")
-- end

-- function EnterUserCenter()
	-- if not platform then
		-- return
	-- end
	-- return RunStaticFunc(SKD_name, "enterUserCenter")
-- end

function ExitSDK()
	if not platform then
		return
	end
	if platform == "main" then
		return
	end
	if platform == "pp" then
		return
	end
	return RunStaticFunc(SKD_name, "exitSDK")
end

function ExitGame()
	if not platform then
		return
	end
	if platform == "main" then
		return
	end
	return RunStaticFunc(SKD_name, "exitGame")
end

function ExtendInfoSubmit(upType)
	if platform == "oppo" then
		local serverName = mAccountManager.GetServerName()
		local hero = mHeroManager.GetHero()
		return RunStaticFunc(SKD_name, "extendInfoSubmit",serverName,hero.name,tostring(hero.level))
	elseif platform == "lj" then
		local serverId = mAccountManager.GetServerId()
		local serverName = mAccountManager.GetServerName()
		local hero = mHeroManager.GetHero()
		return RunStaticFunc(SKD_name, "setExtData", upType,tostring(hero.id),tostring(hero.name),hero.level,serverId,serverName,hero.gold,hero.vipLevel,hero.familyName or "无帮派")
	end
end