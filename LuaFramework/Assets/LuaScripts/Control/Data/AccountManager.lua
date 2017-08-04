local _G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,require,Directory,os,EventType,Application,platform,AppearEvent = 
_G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,require,Directory,os,EventType,Application,platform,AppearEvent

local mSetManager = nil
local mEventManager = nil
local mSDK = nil
local mAlert = nil
local mCommonlyFunc = nil
local mNetManager = nil
local mLoginPanel = nil
local mPromptAlert = nil
local mActionManager = require "LuaScript.Control.ActionManager"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mChatManager = require "LuaScript.Control.Data.ChatManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mHotFixPanel = require "LuaScript.View.Panel.HotFixPanel"
local mBorderPanel = require "LuaScript.View.Panel.BorderPanel"
local mTaskManager = require "LuaScript.Control.Data.TaskManager"
local mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
local mBulletManager = require "LuaScript.Control.Scene.BulletManager"
local mBattleFieldManager = require "LuaScript.Control.Data.BattleFieldManager"
module("LuaScript.Control.Data.AccountManager")
local mUserName,mPassWorld,mServerIndex,mServerName,mServerIp,mServerPort,mServerId = "","",nil,nil,nil,nil,nil
local mNotifyUrl = nil

local mSid = nil
local mGetTime = nil


function Init()
	mSetManager = require "LuaScript.Control.System.SetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mSDK = require "LuaScript.Mode.Object.SDK"
	mAlert = require "LuaScript.View.Alert.Alert"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mLoginPanel = require "LuaScript.View.Panel.Login.LoginPanel"
	mPromptAlert = require "LuaScript.View.Alert.PromptAlert"
	
	mEventManager.AddEventListen(nil, EventType.SDKLogin, SDKLogin)
	mEventManager.AddEventListen(nil, EventType.SDKLoginOut, SDKLoginOut)
	mEventManager.AddEventListen(nil, EventType.SDKChangeUser, SDKChangeUser)
	mEventManager.AddEventListen(nil, EventType.SDKExitGame, SDKExitGame)
	
	ReadAccountToLocal()
end

function SDKLogin()
	-- print("SDKLogin!!!!!!!!!!!!!")
	mSid = mSDK.GetSid()
	mGetTime = os.oldTime
	
	AppearEvent(nil,EventType.SDKLoginOver)
	-- return mSid
end

function SDKLoginOut()
	AppearEvent(nil,EventType.ConnectFailure)
	
	mSid = nil
	
	if mLoginPanel.visible then
		if not GetSid() and platform ~= "91" and platform ~= "91IOS" and platform ~= "lj" then
			mSDK.Login()
		end
	else
		ReturnToLogin()
	end
	
	if platform == "lj" then
		mSDK.Login()
	end
end

function SDKChangeUser()
	AppearEvent(nil,EventType.ConnectFailure)
	
	mSid = nil
	if mLoginPanel.visible then
		if not GetSid() then
			mSDK.Login()
		else
			mSDK.ShowFloatButton(0,500,true)
		end
	else
		ReturnToLogin()
	end
end

function ReturnToLogin()
	mNetManager.ClearPingTimer()
	mNetManager.Destroy(true)
	mPanelManager.Reset()
	mHeroManager.Reset()
	mActionManager.Reset()
	mChatManager.Reset()
	mHarborManager.Reset()
	mTaskManager.Reset()
	mFamilyManager.Reset()
	mBattleFieldManager.Reset()
	mBulletManager.ClearAll()

	mPanelManager.Show(mLoginPanel)
	mPanelManager.Show(mHotFixPanel)
	mPanelManager.Show(mBorderPanel)
end

function SDKExitGame()
	if platform == "91" or platform == "91IOS" or platform == "oppo" then
		Application.Quit()
	else
		mCommonlyFunc.QuitGame()
	end
end

function GetSid()
	if not mSid then
		mGetTime = os.oldTime
	end
	mSid = mSid or mSDK.GetSid()
	if not mSid or mSid == "" then
		return
	end
	if os.oldTime - mGetTime > 50 * 60 then
		return
	end
	return mSid
end

function SetNotifyUrl(notifyUrl)
	mNotifyUrl = notifyUrl
end


function GetNotifyUrl()
	return mNotifyUrl
end

function GetServerId()
	return mServerId
end

function GetServerIndex()
	return mServerIndex
end

function SaveAccountToLocal(userName, passWorld,serverIndex,serverName,serverIp,serverPort,serverId)
	Directory.CreateDirectory(ConstValue.DataPath)
	local f = io.open(ConstValue.DataPath.."Data", "w")
	if f then
		f:write(tostring(userName).. "\n")
		f:write(tostring(passWorld) .. "\n")
		f:write(tostring(serverIndex) .. "\n")
		f:write(tostring(serverName) .. "\n")
		f:write(tostring(serverIp) .. "\n")
		f:write(tostring(serverPort) .. "\n")
		f:write(tostring(mNotifyUrl) .. "\n")
		f:write(tostring(serverId) .. "\n")
		f:close()
	end
	mUserName,mPassWorld,mServerIndex,mServerName,mServerIp,mServerPort,mServerId = 
			userName, passWorld,serverIndex,serverName,serverIp,serverPort,serverId
	if mUserName ~= userName and mUserName ~= "" then
		mSetManager.ReadSettingData()
	end
end

function ReadAccountToLocal()
	local f = io.open(ConstValue.DataPath.."Data", "r")
	if f then
		mUserName = f:read("*line")
		mPassWorld = f:read("*line")
		mServerIndex = tonumber(f:read("*line"))
		mServerName = f:read("*line")
		mServerIp = f:read("*line")
		mServerPort = tonumber(f:read("*line"))
		mNotifyUrl = f:read("*line")
		mServerId = tonumber(f:read("*line"))
		f:close()
	end
end

function GetAccount()
	return mUserName,mPassWorld,mServerIndex,mServerName,mServerIp,mServerPort,mServerId
end

function GetServerName()
	return mServerName
end