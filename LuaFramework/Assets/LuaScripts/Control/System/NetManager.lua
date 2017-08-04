local Socket,ByteArray,EventType,print,PassMap,Language,ConstValue,AppearEvent,Application,CsSocketSendData,CsCrc
= Socket,ByteArray,EventType,print,PassMap,Language,ConstValue,AppearEvent,Application,CsSocketSendData,CsCrc
local CsSocketGetByteArr,require,_G,CsSocketConnected,UploadError,debug,tostring,os,Dns = 
CsSocketGetByteArr,require,_G,CsSocketConnected,UploadError,debug,tostring,os,Dns
local PackatHead,Packat_Account,Packat_Player,CsIsNull,cs_Base,table,pairs,Upload = 
PackatHead,Packat_Account,Packat_Player,CsIsNull,cs_Base,table,pairs,Upload
local mTimer = require "LuaScript.Common.Timer"
local mEventManager = require "LuaScript.Control.EventManager"
local mAlert = require "LuaScript.View.Alert.Alert"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mLoginPanel = nil
module("LuaScript.Control.System.NetManager")

mListenList = {}
mCS_Socket = nil
mReciveKey = false
-- mCurKey = 0

-- local mErrorDateCount = 0
local mConnectArg = nil

function Init()
	mLoginPanel = require "LuaScript.View.Panel.Login.LoginPanel"
	
	mReciveKey = false
	mCS_Socket = Socket.Init()
	mEventManager.AddEventListen(mCS_Socket, EventType.ConnectSuccess, ConnectSuccesHandler)
	mEventManager.AddEventListen(mCS_Socket, EventType.ConnectFailure, ConnectFailureHandler)
	mEventManager.AddEventListen(mCS_Socket, EventType.Disconnect, Disconnect)
	mEventManager.AddEventListen(mCS_Socket, EventType.ReciveData, ReciveHandler)
	
	AddListen(PackatHead.ACCOUNT, Packat_Account.SEND_SOCKET_KEY, SEND_SOCKET_KEY)
	AddListen(PackatHead.PLAYER, Packat_Player.CLIENT_ONLINE_PING, CLIENT_ONLINE_PING)
end


local mSendKey = 0
local mPingTimer = nil
_G.OnApplicationFocus = function()
	if mPingTimer then
		return
	end
	-- print("OnApplicationFocus")
	mSendKey = (mSendKey+1) % 100
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_ONLINE_PING)
	ByteArray.WriteByte(cs_ByteArray,mSendKey)
	SendData(cs_ByteArray)
	
	if IsConnected() then
		mPingTimer = mTimer.SetTimeout(PingOut, 15)
	end
end

function ClearPingTimer()
	mPingTimer = nil
end

function PingOut()
	-- print("PingOut")
	if not mPingTimer then
		return
	end
	mPingTimer = nil
	Disconnect()
end

function CLIENT_ONLINE_PING(cs_ByteArray)
	-- print("CLIENT_ONLINE_PING")
	local key = ByteArray.ReadByte(cs_ByteArray)
	if key == mSendKey then
		mPingTimer = nil
	end
end

function IsConnected()
	if CsSocketConnected then
		return mCS_Socket and CsSocketConnected(mCS_Socket)
	else
		return mCS_Socket and mCS_Socket.Connected
	end
end

function Connect(serverIp, serverPort, cs_ByteArray)
	if IsConnected() then
		SendData(cs_ByteArray)
		return
	end
	
	if mCS_Socket then
		Destroy()
	end
	Init()
	
	mReciveKey = false
	ByteArray.CreateByteArray()
	mConnectArg = cs_ByteArray
	mCS_Socket:Connect(serverIp, serverPort, ConstValue.ConnectTime)
end

function ConnectSuccesHandler()
	print("ConnectSuccesHandler")
	_G.connectTime = os.date("%x %X")
end

function SEND_SOCKET_KEY(cs_ByteArray)
	print("SEND_SOCKET_KEY")
	-- if mReciveKey then
		-- UploadError("SEND_SOCKET_KEY ERROR!!!")
	-- end
	
	mReciveKey = true
	local key = ByteArray.ReadShort(cs_ByteArray)
	mCS_Socket.key = key
	SendData(mConnectArg)
end

function ConnectFailureHandler()
	print("ConnectFailureHandler")
	mAlert.Show(Language[153])
	AppearEvent(nil, EventType.ConnectFailure)
	
	Destroy(notUpload)
end

function Disconnect(_,_,errorInfo)
	print("ConnectFailureHandler",errorInfo)
	
	-- if errorInfo then
		-- local socketInfo = "errorInfo = " .. errorInfo .. "\n"
		-- socketInfo = socketInfo .. "now = " .. os.oldTime .. "\n"
		-- if mCS_Socket then
			-- socketInfo = socketInfo..mCS_Socket.mMsgLength.."\n"
			-- socketInfo = socketInfo..mCS_Socket.key.."\n"
			-- socketInfo = socketInfo..mCS_Socket.sendIndex.."\n"
			-- socketInfo = socketInfo..mCS_Socket.reciveindex.."\n"
		-- end
		
		-- socketInfo = "Disconnect!!!\n"..socketInfo.."\n"..debug.traceback()
		-- UploadError(socketInfo)
		-- print(socketInfo)
	-- end
	
	
	Destroy()
	AppearEvent(nil, EventType.ConnectFailure)
	function okFunc()
		AppearEvent(nil, EventType.ReLogin)
	end
	function cancelFunc()
		mCommonlyFunc.QuitGame()
	end
	mAlert.Show("与服务器断开连接,是否重连?", okFunc, cancelFunc,"重连","退出")
end

function Destroy(notUpload)
	-- print("Net Destroy")
	if mCS_Socket then
		mCS_Socket:Close()
		mEventManager.RemoveAllEveListen(mCS_Socket)
		
		Socket.Destroy(mCS_Socket)
		mCS_Socket = nil
	end
end

function Close()
	Destroy()
end

function AddListen(keyHead, keyBody, func)
	mListenList[keyHead * 1000000 + keyBody] = func
end

-- local mLastReciveList = {}
-- local keyUpload = 0 
function ReciveHandler(_,_,cs_ByteArray)
	local keyHead = ByteArray.ReadByte(cs_ByteArray)
	local keyBody = ByteArray.ReadByte(cs_ByteArray)

	local key = keyHead * 1000000 + keyBody
	if mListenList[key] then
		-- print(key)
		-- mLastReciveKey = key
		-- table.insert(mLastReciveList, {keyHead,keyBody,mCS_Socket.reciveindex,ByteArray.GetLength(cs_ByteArray)})
		-- if #mLastReciveList >= 10 then
			-- table.remove(mLastReciveList, 1)
		-- end
		mListenList[key](cs_ByteArray)
		-- print(key.."over")
	else
		print("NetManage warning: " .. key .. " is not Listened!")
		
		-- if keyUpload < 3 then
			-- keyUpload = keyUpload + 1
			
			-- local str = "NetManage warning: " .. key .. " is not Listened!\n"
			-- str = str.."sendIndex="..mCS_Socket.sendIndex.."\n"
			-- str = str.."reciveindex="..mCS_Socket.reciveindex.."\n"
			-- str = str.."length="..ByteArray.GetLength(cs_ByteArray).."\n"
			-- for k,v in pairs(mLastReciveList) do
				-- str = str..v[1].." "..v[2].."  "..v[3].."  ".. v[4].."\n"
			-- end
			-- UploadError(str)
			
			-- UploadReciveindex()
		-- end
	end
end

function UploadReciveindex()
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_SEND_PASSMAP_INDEX)
	ByteArray.WriteInt(cs_ByteArray,mCS_Socket.reciveindex)
	SendData(cs_ByteArray)
end

function SendData(cs_ByteArray)
	if not mCS_Socket then
		return
	end
	if not mReciveKey then
		return
	end
	local length = ByteArray.GetLength(cs_ByteArray)
	if length == 2 then
		ByteArray.WriteByte(cs_ByteArray,0)
		length = length + 1
	end
	
	-- if length > 1024 and not tooLengthUp then
		-- tooLengthUp = true
		-- Upload("tooLengthUp\n"..debug.traceback())
	-- end
	
	ByteArray.JoinShort(cs_ByteArray,length+4);
	ByteArray.JoinShort(cs_ByteArray,CsCrc(cs_ByteArray))

	CsSocketSendData(mCS_Socket,cs_ByteArray)
end

