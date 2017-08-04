local _G,Screen,Language,GUI,ByteArray,print,Texture2D,ConstValue,Vector2,GUIStyleButton,GUIStyleTextField,pairs,math = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,ConstValue,Vector2,GUIStyleButton,GUIStyleTextField,pairs,math
local PackatHead,Packat_Account,Packat_Player,require,string,EventType,Encoding,RunLuaScript,tonumber,Packat_UC = 
PackatHead,Packat_Account,Packat_Player,require,string,EventType,Encoding,RunLuaScript,tonumber,Packat_UC
local ServerListUrl,GUIUtility,Version,ReplaceString,UploadError,NewestVersionUrl,YJPlatformType = 
ServerListUrl,GUIUtility,Version,ReplaceString,UploadError,NewestVersionUrl,YJPlatformType
local GUIStyleLabel,Color,platform,Loader,PlatformType,VersionNum,Application,VersionCode = 
GUIStyleLabel,Color,platform,Loader,PlatformType,VersionNum,Application,VersionCode
local NewestVersion,io,ErrorLog,debug,tostring,error,AppearEvent,LjPlatformType,IPhonePlayer,IosTestScript = 
NewestVersion,io,ErrorLog,debug,tostring,error,AppearEvent,LjPlatformType,IPhonePlayer,IosTestScript
local mAssetManager = require "LuaScript.Control.AssetManager"
local mNetManager = require "LuaScript.Control.System.NetManager"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mSceneManager = require "LuaScript.Control.Scene.SceneManager"
local mCreateHeroPanel = require "LuaScript.View.Panel.Login.CreateHeroPanel"
local mAccountManager = require "LuaScript.Control.Data.AccountManager"
local mHeroManager = nil
local mCharManager = nil
local mBattleManager = nil
local mSetManager = nil
local mAlertPanel = require "LuaScript.View.Alert.Alert"
local mEventManager = nil
local mSDK = nil
local mTimer = nil
local mConnectAlert = nil
local mAlert = nil
local mSystemTip = nil
local mCommonlyFunc = nil
local mPromptAlert = nil

module("LuaScript.View.Panel.Login.LoginPanel")

local mScrollPositionY = 0
local mUserName = nil
local mPassWord = nil
local mOldPassWord = ""
local mNewPassWord = ""
local mServerIndex = nil
local mServerName = nil
local mServerIp = nil
local mServerPort = nil
local mServerId = nil
local mPage = 1
local mConnectCount = 0
local mCheckCount = 0
local mConnecting = false

local serverListError = nil
local serverList = nil
local timer = nil

local mNewUserName = ""
local mNewPassWord = ""
local mTelephonyNumber = "123"

-- local VersionNum = 0

function Init()
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mBattleManger = require "LuaScript.Control.Data.BattleFieldManager"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mTimer = require "LuaScript.Common.Timer"
	mSDK = require "LuaScript.Mode.Object.SDK"
	mConnectAlert = require "LuaScript.View.Alert.ConnectAlert"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mPromptAlert = require "LuaScript.View.Alert.PromptAlert"
	
	mNetManager.AddListen(PackatHead.ACCOUNT, Packat_Account.ACCOUNT_REG_RESULT, Registered_Result)
	mNetManager.AddListen(PackatHead.ACCOUNT, Packat_Account.LOGIN_RESULT, Login_Result)
	mNetManager.AddListen(PackatHead.ACCOUNT, Packat_Account.PLAYER_INFO, Player_Info)
	mNetManager.AddListen(PackatHead.ACCOUNT, Packat_Account.ACCOUNT_ALREADY_LOGIN, ACCOUNT_ALREADY_LOGIN)
	
	-- mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.JOIN_MAP, Join_Map_Result)
	
	mEventManager.AddEventListen(nil, EventType.ReLogin, StartLogin)
	mEventManager.AddEventListen(nil, EventType.ConnectFailure, ConnectFailure)
	mEventManager.AddEventListen(nil, EventType.SDKLoginOver, SDKLoginOver)
	-- mEventManager.AddEventListen(nil, EventType.SDKInit, SDKInit)
	
	--下载服务器列表
	local loadCount = 0
	function complete(csLoader)
		local str = csLoader.text
		serverList = RunLuaScript(str)
		
		--ios test script
		if IosTestScript then
			serverList =  {{id=1,name="航海一区",state=2,ip="115.28.224.11",port=7001,serverId=5}}
		end
		
		if not serverList and loadCount >= 5 then
			local info = "serverList error!!!!!\n"..str.."\n"
			serverListError = "无法获取服务器列表,请检查网络是否正常"
			ErrorLog(info)
			return
		elseif not serverList then
			if not visible then
				return
			end
			Loader.Load(ServerListUrl, complete, true)
			loadCount = loadCount + 1
			return
		end
		
		if serverList[mServerIndex] then
			local server = serverList[mServerIndex]
			mServerIndex = server.id
			mServerName = server.name
			mServerIp = server.ip
			mServerPort = server.port
			mServerId = server.serverId
			mAccountManager.SetNotifyUrl(server.notifyUrl)
		else
			local server = serverList[#serverList]
			mServerIndex = server.id
			mServerName = server.name
			mServerIp = server.ip
			mServerPort = server.port
			mServerId = server.serverId
			mAccountManager.SetNotifyUrl(server.notifyUrl)
		end
	end
	if platform == "lj" then
		ServerListUrl = mSDK.GetManifestData("ServerListUrl") or ServerListUrl
		ServerListUrl = ReplaceString(ServerListUrl, "bytes","php")
		MaxConnectCount = mSDK.GetManifestData("MaxConnectCount")
		if MaxConnectCount and tonumber(MaxConnectCount) then
			ConstValue.MaxConnectCount = tonumber(MaxConnectCount)
		end
	end
	Loader.Load(ServerListUrl, complete, true)
	-- Loader.Load("http://m.baidu.com/static/index/l.gif", nil, true)
	
	IsInit = true
end

function Display()
	-- print(VersionCode)
	mUserName,mPassWord,mServerIndex,mServerName,mServerIp,mServerPort,mServerId = mAccountManager.GetAccount()
	
	if not platform or platform == "main" then
		if mUserName == "" or mUserName == nil then
			mPage = 2
		end
	end
	
	if VersionCode < 2 then
		function okFunc()
			mCommonlyFunc.QuitGame()
		end
		mPromptAlert.Show("游戏版本过低,登陆游戏平台重新下载,如有疑问请向客服反映。QQ358257842",okFunc)
		return
	end
	
	if serverList then
		if serverList[mServerIndex] then
			local server = serverList[mServerIndex]
			mServerIndex = server.id
			mServerName = server.name
			mServerIp = server.ip
			mServerPort = server.port
			mServerId = server.serverId
			mAccountManager.SetNotifyUrl(server.notifyUrl)
		else
			local server = serverList[#serverList]
			mServerIndex = server.id
			mServerName = server.name
			mServerIp = server.ip
			mServerPort = server.port
			mServerId = server.serverId
			mAccountManager.SetNotifyUrl(server.notifyUrl)
		end
	end
end

function OnGUI()
	if not IsInit then
		return
	end
	-- platform = "main"
	-- mPage = 5
	-- serverList = nil
	if platform then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg22_1")
		GUI.DrawPackerTexture(image)
		local audioOpen = mSetManager.GetAudio()
		if audioOpen then
			if GUI.Button(0, 0, 90, 61,nil, GUIStyleButton.AudioBtn_1) then
				mSetManager.SetAudio(not audioOpen)
			end
		else
			if GUI.Button(0, 0, 90, 61,nil, GUIStyleButton.AudioBtn_2) then
				mSetManager.SetAudio(not audioOpen)
			end
		end
		
		if mPage == 1 then
			local image = mAssetManager.GetAsset("Texture/Icon/" .. mSDK.logoName)
			GUI.DrawTexture(521,0,512,512,image)
			
			if GUI.Button(566,343,497,113, mServerName,GUIStyleButton.SelectServerBtn) then
				mPage = 3
			end
			if GUI.Button(640,460,219,140,nil,GUIStyleButton.EnterBtn) then
				-- if not mServerId then
					-- mSystemTip.ShowTip("正在获取服务器编号,请过会再试")
					-- return
				-- end
				CheckServerId()
				StartLogin()
				-- mAlertPanel.Show("《征服之海》已于2016/10/4 22:00关服,感谢大家对游戏的支持和喜爱.还希望再次征服全世界的,请进QQ群(299581325),如有机会再相聚")
				-- return
			end
			
			if platform == "main" then
				GUI.Label(911,30,162,35, "账号:"..mUserName, GUIStyleLabel.Right_30_White_Art)
				if GUI.Button(938,69,162,35, "更换账号", GUIStyleButton.Transparent_Art_30) then
					mPage = 2
					
					mNewUserName = mUserName
					mNewPassWord = ""
				end
				if GUI.Button(938,109,162,35, "修改密码", GUIStyleButton.Transparent_Art_30) then
					Application.OpenUrl("http://47.93.230.239/e/member/EditInfo/EditSafeInfo.php")
				end
			end
		elseif mPage == 2 then
			local image = mAssetManager.GetAsset("Texture/Icon/" .. mSDK.logoName)
			GUI.DrawTexture(521,0,512,512,image)
			GUI.Label(504,378,162,35, "账号:", GUIStyleLabel.Left_30_White_Art)
			GUI.Label(504,448,162,35, "密码:", GUIStyleLabel.Left_30_White_Art)
			
			mNewUserName = GUI.TextField(585,366,334,52, mNewUserName, GUIStyleTextField.Left_30_White_2)
			mNewPassWord = GUI.TextField(585,436,334,52, mNewPassWord, GUIStyleTextField.Left_30_White_2)
			
			
			if GUI.Button(900,378,162,35, "注册账号", GUIStyleButton.Transparent_Art_30) then
				-- Application.OpenUrl("http://47.93.230.239/e/member/register/index.php?tobind=0&groupid=1&button=下一步")
				mPage = 5
				mNewUserName = ""
				mNewPassWord = ""
				mTelephonyNumber = "123"
			end
			if GUI.Button(900,448,162,35, "找回密码", GUIStyleButton.Transparent_Art_30) then
				Application.OpenUrl("http://47.93.230.239/e/member/GetPassword/")
			end
			
			if GUI.Button(506,508,242,71, nil, GUIStyleButton.OkBtn) then
				if mNewUserName == "" or mNewPassWord == "" then
					mSystemTip.ShowTip("账号密码不能为空")
					return
				end
				mUserName = mNewUserName
				mPassWord = mNewPassWord
				mPage = 1
			end
			
			local oldEnabled = GUI.GetEnabled()
			if mUserName == "" then
				GUI.SetEnabled(false)
			end
			if GUI.Button(786,508,242,71, nil, GUIStyleButton.CancelBtn_2) then
				mPage = 1
			end
			if mUserName == "" then
				GUI.SetEnabled(oldEnabled)
			end
		elseif mPage == 3 then
			if serverList then
				local spacing = 117.3
				_,mScrollPositionY = GUI.BeginScrollView(504, 63, 524, 517, 0, mScrollPositionY, 0, 0, 468.6, math.ceil(#serverList/2)*spacing + 135)
					local server = serverList[mServerIndex]
					GUI.Label(46, 14, 144, 311, "最近登录", GUIStyleLabel.Center_35_LightGreen_Art, Color.Black)
					DrawServer(261, 0, server)
					local image = mAssetManager.GetAsset("Texture/Gui/Button/horizontalScrollBg")
					GUI.DrawTexture(5,97,480,3,image)
					
					local image = mAssetManager.GetAsset("Texture/Gui/Button/horizontalScrollBg")
					GUI.DrawTexture(5,97,480,3,image)
					
					local len = #serverList
					for i=len,1,-1 do
						server = serverList[i]
						local showY = (len-i)*spacing - mScrollPositionY / GUI.modulus
						
						DrawServer((len-i)%2*252.6, math.floor((len-i)/2)*spacing + 135, server)
					end
				GUI.EndScrollView()
			elseif serverListError then
				GUI.Label(700, 280, 144, 311, serverListError, GUIStyleLabel.Center_35_Red, Color.Black)
			else
				GUI.Label(700, 280, 144, 311, "正在获取服务器列表.....", GUIStyleLabel.Center_35_LightGreen_Art, Color.Black)
			end
		elseif mPage == 5 then
			-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/logo")
			-- GUI.DrawTexture(521,33,496,320,image)
			local image = mAssetManager.GetAsset("Texture/Icon/" .. mSDK.logoName)
			GUI.DrawTexture(521,0,512,512,image)
			
			-- GUI.Label(504+150,178-60,162,35, "账号注册", GUIStyleLabel.Left_40_Yellowish_Art)
			
			GUI.Label(504-50,378,162,35, "账号:", GUIStyleLabel.Left_30_White_Art)
			GUI.Label(504-50,448,162,35, "密码:", GUIStyleLabel.Left_30_White_Art)
			-- GUI.Label(504-50,418,162,35, "电话:", GUIStyleLabel.Left_30_White_Art)
			
			GUI.Label(504+426-50,378,162,35, "6~19位数字或字母", GUIStyleLabel.Left_25_White)
			GUI.Label(504+426-50,448,162,35, "6~19位数字或字母", GUIStyleLabel.Left_25_White)
			-- GUI.Label(504+426-50,418,162,35, "用于找回密码", GUIStyleLabel.Left_25_White)
			
			mNewUserName = GUI.TextField(585-50,366,334,52, mNewUserName, GUIStyleTextField.Left_30_White_2)
			mNewPassWord = GUI.TextField(585-50,436,334,52, mNewPassWord, GUIStyleTextField.Left_30_White_2)
			-- mTelephonyNumber = GUI.TextField(585-50,406,334,52, mTelephonyNumber, GUIStyleTextField.Left_30_White_2)
			
			if GUI.Button(506,508,242,71, nil, GUIStyleButton.OkBtn) then
				if mNewUserName == "" or mNewPassWord == "" then
					mSystemTip.ShowTip("账号密码不能为空")
					return
				end
				if string.len(mNewUserName) < 6 or string.len(mNewPassWord) < 6 then
					mAlertPanel.Show("账号与密码长度必须大于6位")
					return
				end
				
				if string.len(mNewUserName) > 20 or string.len(mNewPassWord) > 20 then
					mAlertPanel.Show("账号与密码长度不能大于20位")
					return
				end
				
				if string.find(mNewUserName,"*") or string.find(mNewPassWord,"*") then
					mAlertPanel.Show("账号、密码长度或格式错误,不能使用‘*’")
					return
				end
				if string.find(mNewUserName,"?") or string.find(mNewPassWord,"?") then
					mAlertPanel.Show("账号、密码长度或格式错误,不能使用‘？’")
					return
				end
				if string.find(mNewUserName,"|") or string.find(mNewPassWord,"|") then
					mAlertPanel.Show("账号、密码长度或格式错误,不能使用‘|’")
					return
				end
				if string.find(mNewUserName," ") or string.find(mNewPassWord," ") then
					mAlertPanel.Show("账号、密码长度或格式错误,不能使用空格")
					return
				end
				-- mUserName = mNewUserName
				-- mPassWord = mNewPassWord
				
				mPanelManager.Show(mConnectAlert)
				
				function complete(csLoader)
					mPanelManager.Hide(mConnectAlert)
					local str = string.char(csLoader.bytes[csLoader.bytes.Length-1]  )
					-- str = "11111"
					-- print(str,#str)
					if str == "0" then
						mSystemTip.ShowTip("账号注册成功")
						mUserName = mNewUserName
						mPassWord = mNewPassWord
						
						mPage = 1
					elseif str == "1" then
						if mSDK.GetChannelName() ~= "185sy" then
							mAlertPanel.Show("账号注册失败,请尝试更换账号名与密码,如还无法解决请联系QQ358257842")
						else
							mAlertPanel.Show("账号注册失败,请尝试更换账号名与密码。")
						end
					elseif str == "2" then
						mSystemTip.ShowTip("该账号已经被使用")
					elseif str == "3" then
						mSystemTip.ShowTip("账号、密码长度或格式错误")
					else
						error(str)
					end
				end
				local str = string.format("http://47.93.230.239/e/member/register.php?UserName=%s&PassWord=%s&TelephonyNumber=%s",
								mNewUserName, mNewPassWord, mTelephonyNumber)
				Loader.Load(str, complete, true)
				-- mPage = 1
			end
			
			-- local oldEnabled = GUI.GetEnabled()
			-- if mUserName == "" then
				-- GUI.SetEnabled(false)
			-- end
			if GUI.Button(786,508,242,71, nil, GUIStyleButton.CancelBtn_2) then
				mPage = 1
			end
			-- if mUserName == "" then
				-- GUI.SetEnabled(oldEnabled)
			-- end
		end
	else
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg22_1")
		GUI.DrawPackerTexture(image)
		-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg2_1")
		-- GUI.DrawTexture(218.85,69.95,746,498,image)
		
		local audioOpen = mSetManager.GetAudio()
		if audioOpen then
			if GUI.Button(1040, 0, 90, 61,nil, GUIStyleButton.AudioBtn_1) then
				mSetManager.SetAudio(not audioOpen)
			end
		else
			if GUI.Button(1040, 0, 90, 61,nil, GUIStyleButton.AudioBtn_2) then
				mSetManager.SetAudio(not audioOpen)
			end
		end
		
		
		if mPage == 1 then
			if GUI.Button(424.8,169.85,356,78, mUserName,GUIStyleButton.TextBtn_Left) then
				mPage = 2
			end
			
			if GUI.Button(424.8,288,356,78, mServerName,GUIStyleButton.TextBtn_Left) then
				mPage = 3
			end
			
			if GUI.Button(491.35,418.45,223,78,"进入游戏",GUIStyleButton.OrangeBtn) then
				-- if not mServerId then
					-- mSystemTip.ShowTip("正在获取服务器编号,请过会再试")
					-- return
				-- end
				CheckServerId()
				StartLogin()
				-- mAlertPanel.Show("《征服之海》已于2016/10/4 22:00关服,感谢大家对游戏的支持和喜爱.还希望再次征服全世界的,请进QQ群(299581325),如有机会再相聚")
				return
			end
			
			local image = mAssetManager.GetAsset("Texture/Gui/Text/account")
			GUI.DrawTexture(455,187,70,35,image)
			local image = mAssetManager.GetAsset("Texture/Gui/Text/server")
			GUI.DrawTexture(455,304.5,70,35,image)
		elseif mPage == 2 then
			local image = mAssetManager.GetAsset("Texture/Gui/Text/account")
			GUI.DrawTexture(362,187.9,70,35,image)
			mUserName = GUI.TextField(424.8,169.85,356,78, mUserName, GUIStyleTextField.Left_20_White)
			
			local image = mAssetManager.GetAsset("Texture/Gui/Text/password")
			GUI.DrawTexture(362,306,70,35,image)
			mPassWord = GUI.PasswordField(424.8,288,356,78, mPassWord, GUIStyleTextField.Left_20_White)
			if GUI.Button(789,301,51,49,nil,GUIStyleButton.ChangeBtn) then
				mPage = 4
			end
			
			if GUI.Button(399.7,421.5,166,77,"确定",GUIStyleButton.BlueBtn) then
				mPage = 1
			end
			if GUI.Button(611.5,421.5,166,77,"注册",GUIStyleButton.BlueBtn) then
				mPage = 5
			end
		elseif mPage == 3 and serverList then
			local spacing = 117.3
			_,mScrollPositionY = GUI.BeginScrollView(348, 142.5, 500, 311, 0, mScrollPositionY, 0, 0, 468.6, math.ceil(#serverList/2)*spacing)
				for index,server in pairs(serverList) do
					local showY = (index-1)*spacing - mScrollPositionY / GUI.modulus
					if GUI.Button((index-1)%2*252.6,math.floor((index-1)/2)*spacing,216,87,server.name,GUIStyleButton.ServerBtn) then
						mServerIndex = server.id
						mServerName = server.name
						mServerIp = server.ip
						mServerPort = server.port
						mServerId = server.serverId
						mAccountManager.SetNotifyUrl(server.notifyUrl)
						
						mPage = 1
					end
				end
			GUI.EndScrollView()
		elseif mPage == 4 then
			local image = mAssetManager.GetAsset("Texture/Gui/Text/account")
			GUI.DrawTexture(362,154.9,70,35,image)
			mUserName = GUI.TextField(424.8,136.85,356,78, mUserName, GUIStyleTextField.Left_20_White)
			
			local image = mAssetManager.GetAsset("Texture/Gui/Text/oldpassworld")
			GUI.DrawTexture(330.5,244.5,101,35,image)
			mOldPassWord = GUI.TextField(424.8,229,356,78, mOldPassWord, GUIStyleTextField.Left_20_White)
			
			local image = mAssetManager.GetAsset("Texture/Gui/Text/newpassword")
			GUI.DrawTexture(330.5,337,101,35,image)
			mNewPassWord = GUI.TextField(424.8,321.95,356,78, mNewPassWord, GUIStyleTextField.Left_20_White)
			
			if GUI.Button(399.7,421.5,166,77,"修改",GUIStyleButton.BlueBtn) then
				ChangePassWord(mUserName, mOldPassWord, mNewPassWord)
				mOldPassWord = ""
				mNewPassWord = ""
				mPage = 1
			end
			if GUI.Button(611.5,421.5,166,77,"取消",GUIStyleButton.BlueBtn) then
				mPage = 1
			end
		elseif mPage == 5 then
			local image = mAssetManager.GetAsset("Texture/Gui/Text/account")
			GUI.DrawTexture(362,187.9,70,35,image)
			mUserName = GUI.TextField(424.8,169.85,356,78, mUserName, GUIStyleTextField.Left_20_White)
			
			local image = mAssetManager.GetAsset("Texture/Gui/Text/password")
			GUI.DrawTexture(362,306,70,35,image)
			mPassWord = GUI.TextField(424.8,288,356,78, mPassWord, GUIStyleTextField.Left_20_White)
			
			if GUI.Button(399.7,421.5,166,77,"创建",GUIStyleButton.BlueBtn) then
				Registered(mUserName, mPassWord)
			end
			if GUI.Button(611.5,421.5,166,77,"取消",GUIStyleButton.BlueBtn) then
				mPage = 2
			end
		end
	end
	
	if platform == "lj" and mSDK.GetManifestData("Harsh") == "1" then
		return
	end
	if platform == "91" or platform == "91IOS" then
		return
	end
	GUI.Label(0,608,70,35,"Version:"..Version, GUIStyleLabel.Left_25_White,Color.Black)
end

function SDKLoginOver()
	if platform == "lj" and ConstValue.MaxConnectCount == 1 then
		if not mConnectAlert.visible then
			StartLogin()
		end
	end
end

function ConnectFailure()
	mPanelManager.Hide(mConnectAlert)
	StopLogin()
end

function CheckServerId()
	mCheckCount = 0
	if not mServerId then
		function check()
			if mCheckCount > 5 then
				mAlert.Show("服务器编号获取失败,请过会再试")
				mPanelManager.Hide(mConnectAlert)
				return
			end
			if mServerId then
				StartLogin()
			else
				mTimer.SetTimeout(check, 2)
			end
			mCheckCount = mCheckCount + 1
		end
		check()
	end
end

function StartLogin()
	mPanelManager.Show(mConnectAlert)
	-- if not mServerId then
		-- return
	-- end
	print("StartLogin")
	
	mConnectCount = 0
	timer = mTimer.SetInterval(Login, 2)
	
	Login()
end

function StopLogin()
	print("StopLogin")
	
	-- if mConnectCount == 10 then
		-- UploadError(tostring(mConnectCount) .. "StopLogin !!! \n" .. debug.traceback())
	-- end
	
	mConnecting = false
	
	if timer then
		mTimer.RemoveTimer(timer)
		timer = nil
	end
end

function Login()
	-- print("Login1")
	if not mServerIp then
		return
	end
	if mConnectCount >= ConstValue.MaxConnectCount then
		if platform == "lj" and  ConstValue.MaxConnectCount == 1 then
		else
			mSystemTip.ShowTip("无法登陆服务器")
		end
		ConnectFailure()
		return
	end
	if mSDK.IsLoging() then
		return
	end
	-- print("Login2")
	if mConnecting then
		return
	end
	mConnectCount = mConnectCount + 1
	-- print("Login3")
	if platform == "uc" then
		UCLogin()
	elseif platform == "91" or platform == "91IOS" then
		ND91Login()
	elseif platform == "mi" then
		MILogin()
	elseif platform == "dk" then
		DKLogin()
	elseif platform == "hw" then
		HWLogin()
	elseif platform == "lenovo" then
		LNLogin()
	elseif platform == "oppo" then
		OPLogin()
	elseif platform == "main" then
		MNLogin()
	elseif platform == "qxz" then
		QXZLogin()
	elseif platform == "pp" then
		PPLogin()
	elseif platform == "ky" then
		KYLogin()
	elseif platform == "lj" then
		LJLogin()
	elseif platform == "vivo" then
		VILogin()
	elseif platform == "yj" then
		YJLogin()
	else
		PCLogin()
	end
end

function YJLogin()
	local sid = mAccountManager.GetSid()
	if not sid then
		mSDK.Login()
	else
		local uin = mSDK.GetLoginUin()
		local appid = mSDK.GetAppId()
		local sdkId = mSDK.GetChannel()
		
		local str = uin .. "|" .. sid .. "|" .. appid .. "|" ..sdkId .."|"..YJPlatformType[sdkId]
		
		print("send login:\n", "uin", uin, "sess", sid, "appid", appid, "sdkId", sdkId)
		
		local cs_ByteArray = ByteArray.Init()
		ByteArray.WriteByte(cs_ByteArray,PackatHead.PLATUC)
		ByteArray.WriteByte(cs_ByteArray,Packat_UC.UC_LOGIN)
		ByteArray.WriteInt(cs_ByteArray,VersionNum)
		ByteArray.WriteInt(cs_ByteArray,mServerId)
		ByteArray.WriteByte(cs_ByteArray,PlatformType[platform])
		ByteArray.WriteUTF(cs_ByteArray,str, 512)
		mNetManager.Connect(mServerIp,mServerPort,cs_ByteArray)
		if #str > 510 then
			error("too long")
		end
		mConnecting = true
	end
end

function LJLogin()
	local sid = mAccountManager.GetSid()
	if not sid then
		mSDK.Login()
	else
		local uin = mSDK.GetLoginUin()
		local channel = mSDK.GetChannel()
		
		local str = uin.."|"..sid.."|p911|"..channel
		if LjPlatformType[channel] then
			if LjPlatformType[channel].Old then--老平台数据移植
				str = str.."|"..PlatformType[LjPlatformType[channel].Platform].."|"..mSDK.GetChannelUid()
			else--棱镜新加平台
				str = str.."|0|0|"..LjPlatformType[channel].AccountHead
			end
		end
		
		local cs_ByteArray = ByteArray.Init()
		ByteArray.WriteByte(cs_ByteArray,PackatHead.PLATUC)
		ByteArray.WriteByte(cs_ByteArray,Packat_UC.UC_LOGIN)
		ByteArray.WriteInt(cs_ByteArray,VersionNum)
		ByteArray.WriteInt(cs_ByteArray,mServerId)
		ByteArray.WriteByte(cs_ByteArray,PlatformType[platform])
		ByteArray.WriteUTF(cs_ByteArray,str, 512)
		mNetManager.Connect(mServerIp,mServerPort,cs_ByteArray)
		if #str > 510 then
			error("too long")
		end
		mConnecting = true
	end
end


function VILogin()
	local uin = mSDK.GetLoginUin()
	if not uin then
		mSDK.Login()
	else
		local cs_ByteArray = ByteArray.Init()
		ByteArray.WriteByte(cs_ByteArray,PackatHead.PLATUC)
		ByteArray.WriteByte(cs_ByteArray,Packat_UC.UC_LOGIN)
		ByteArray.WriteInt(cs_ByteArray,VersionNum)
		ByteArray.WriteInt(cs_ByteArray,mServerId)
		ByteArray.WriteByte(cs_ByteArray,PlatformType[platform])
		ByteArray.WriteUTF(cs_ByteArray,uin, 512)
		mNetManager.Connect(mServerIp,mServerPort,cs_ByteArray)
		
		mConnecting = true
	end
end

function KYLogin()
	local sid = mAccountManager.GetSid()
	if not sid then
		mSDK.Login()
	else
		local cs_ByteArray = ByteArray.Init()
		ByteArray.WriteByte(cs_ByteArray,PackatHead.PLATUC)
		ByteArray.WriteByte(cs_ByteArray,Packat_UC.UC_LOGIN)
		ByteArray.WriteInt(cs_ByteArray,VersionNum)
		ByteArray.WriteInt(cs_ByteArray,mServerId)
		ByteArray.WriteByte(cs_ByteArray,PlatformType[platform])
		ByteArray.WriteUTF(cs_ByteArray,sid, 512)
		mNetManager.Connect(mServerIp,mServerPort,cs_ByteArray)
		
		mConnecting = true
	end
end

function PPLogin()
	local sid = mSDK.GetSid()
	if not sid then
		mSDK.Login()
	else
		local cs_ByteArray = ByteArray.Init()
		ByteArray.WriteByte(cs_ByteArray,PackatHead.PLATUC)
		ByteArray.WriteByte(cs_ByteArray,Packat_UC.UC_LOGIN)
		ByteArray.WriteInt(cs_ByteArray,VersionNum)
		ByteArray.WriteInt(cs_ByteArray,mServerId)
		ByteArray.WriteByte(cs_ByteArray,PlatformType[platform])
		ByteArray.WriteUTF(cs_ByteArray,sid, 512)
		mNetManager.Connect(mServerIp,mServerPort,cs_ByteArray)
		
		mConnecting = true
	end
end

function QXZLogin()
	local sid = mAccountManager.GetSid()
	if not sid then
		mSDK.Login()
	else
		local cs_ByteArray = ByteArray.Init()
		ByteArray.WriteByte(cs_ByteArray,PackatHead.PLATUC)
		ByteArray.WriteByte(cs_ByteArray,Packat_UC.UC_LOGIN)
		ByteArray.WriteInt(cs_ByteArray,VersionNum)
		ByteArray.WriteInt(cs_ByteArray,mServerId)
		ByteArray.WriteByte(cs_ByteArray,PlatformType[platform])
		ByteArray.WriteUTF(cs_ByteArray,sid, 512)
		mNetManager.Connect(mServerIp,mServerPort,cs_ByteArray)
		
		mConnecting = true
	end
end

function MNLogin()
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLATUC)
	ByteArray.WriteByte(cs_ByteArray,Packat_Account.UC_LOGIN)
	ByteArray.WriteInt(cs_ByteArray,VersionNum)
	ByteArray.WriteInt(cs_ByteArray,mServerId)
	ByteArray.WriteByte(cs_ByteArray,PlatformType[platform])
	ByteArray.WriteUTF(cs_ByteArray,mUserName.."|"..mPassWord, 512)
	mNetManager.Connect(mServerIp,mServerPort,cs_ByteArray)
	
	mConnecting = true
	
	-- local cs_ByteArray = ByteArray.Init()
	-- ByteArray.WriteByte(cs_ByteArray,PackatHead.ACCOUNT)
	-- ByteArray.WriteByte(cs_ByteArray,Packat_Account.REQUEST_LOGIN)
	-- ByteArray.WriteInt(cs_ByteArray,VersionNum)
	-- ByteArray.WriteInt(cs_ByteArray,mServerId)
	-- ByteArray.WriteUTF(cs_ByteArray,mUserName)
	-- ByteArray.WriteUTF(cs_ByteArray,mPassWord)
	-- mNetManager.Connect(mServerIp,mServerPort,cs_ByteArray)
	
	-- mConnecting = true
end

function PCLogin()
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.ACCOUNT)
	ByteArray.WriteByte(cs_ByteArray,Packat_Account.REQUEST_LOGIN)
	ByteArray.WriteInt(cs_ByteArray,VersionNum)
	ByteArray.WriteInt(cs_ByteArray,mServerId)
	ByteArray.WriteUTF(cs_ByteArray,mUserName)
	ByteArray.WriteUTF(cs_ByteArray,mPassWord)
	mNetManager.Connect(mServerIp,mServerPort,cs_ByteArray)
	
	mConnecting = true
end

function UCLogin()
	local sid = mAccountManager.GetSid()
	if not sid then
		mSDK.Login(true)
	else
		local cs_ByteArray = ByteArray.Init()
		ByteArray.WriteByte(cs_ByteArray,PackatHead.PLATUC)
		ByteArray.WriteByte(cs_ByteArray,Packat_UC.UC_LOGIN)
		ByteArray.WriteInt(cs_ByteArray,VersionNum)
		ByteArray.WriteInt(cs_ByteArray,mServerId)
		ByteArray.WriteByte(cs_ByteArray,PlatformType[platform])
		ByteArray.WriteUTF(cs_ByteArray,sid, 512)
		mNetManager.Connect(mServerIp,mServerPort,cs_ByteArray)
		
		mConnecting = true
	end
end

function ND91Login()
	local sid = mAccountManager.GetSid()
	local uin = mSDK.GetLoginUin()
	if not sid or not uin then
		mSDK.Login()
	else
		local cs_ByteArray = ByteArray.Init()
		ByteArray.WriteByte(cs_ByteArray,PackatHead.PLATUC)
		ByteArray.WriteByte(cs_ByteArray,Packat_UC.UC_LOGIN)
		ByteArray.WriteInt(cs_ByteArray,VersionNum)
		ByteArray.WriteInt(cs_ByteArray,mServerId)
		ByteArray.WriteByte(cs_ByteArray,PlatformType[platform])
		ByteArray.WriteUTF(cs_ByteArray,uin.."|"..sid, 512)
		mNetManager.Connect(mServerIp,mServerPort,cs_ByteArray)
		
		mConnecting = true
	end
end

function MILogin()
	local sid = mAccountManager.GetSid()
	if not sid then
		mSDK.Login()
	else
		local uin = mSDK.GetLoginUin()
		local cs_ByteArray = ByteArray.Init()
		ByteArray.WriteByte(cs_ByteArray,PackatHead.PLATUC)
		ByteArray.WriteByte(cs_ByteArray,Packat_UC.UC_LOGIN)
		ByteArray.WriteInt(cs_ByteArray,VersionNum)
		ByteArray.WriteInt(cs_ByteArray,mServerId)
		ByteArray.WriteByte(cs_ByteArray,PlatformType[platform])
		ByteArray.WriteUTF(cs_ByteArray,uin.."|"..sid, 512)
		mNetManager.Connect(mServerIp,mServerPort,cs_ByteArray)
		
		mConnecting = true
	end
end

function DKLogin()
	local sid = mAccountManager.GetSid()
	local uin = mSDK.GetLoginUin()
	if not sid or not uin then
		mSDK.Login()
	else
		-- local uin = mSDK.GetLoginUin()
		local cs_ByteArray = ByteArray.Init()
		ByteArray.WriteByte(cs_ByteArray,PackatHead.PLATUC)
		ByteArray.WriteByte(cs_ByteArray,Packat_UC.UC_LOGIN)
		ByteArray.WriteInt(cs_ByteArray,VersionNum)
		ByteArray.WriteInt(cs_ByteArray,mServerId)
		ByteArray.WriteByte(cs_ByteArray,PlatformType[platform])
		ByteArray.WriteUTF(cs_ByteArray,uin.."|"..sid, 512)
		mNetManager.Connect(mServerIp,mServerPort,cs_ByteArray)
		
		mConnecting = true
	end
end

function HWLogin()
	local sid = mAccountManager.GetSid()
	if not sid then
		mSDK.Login()
	else
		-- local uin = mSDK.GetLoginUin()
		local cs_ByteArray = ByteArray.Init()
		ByteArray.WriteByte(cs_ByteArray,PackatHead.PLATUC)
		ByteArray.WriteByte(cs_ByteArray,Packat_UC.UC_LOGIN)
		ByteArray.WriteInt(cs_ByteArray,VersionNum)
		ByteArray.WriteInt(cs_ByteArray,mServerId)
		ByteArray.WriteByte(cs_ByteArray,PlatformType[platform])
		ByteArray.WriteUTF(cs_ByteArray,sid, 512)
		mNetManager.Connect(mServerIp,mServerPort,cs_ByteArray)
		
		mConnecting = true
	end
end

function LNLogin()
	local sid = mAccountManager.GetSid()
	if not sid then
		mSDK.Login()
	else
		-- local uin = mSDK.GetLoginUin()
		local cs_ByteArray = ByteArray.Init()
		ByteArray.WriteByte(cs_ByteArray,PackatHead.PLATUC)
		ByteArray.WriteByte(cs_ByteArray,Packat_UC.UC_LOGIN)
		ByteArray.WriteInt(cs_ByteArray,VersionNum)
		ByteArray.WriteInt(cs_ByteArray,mServerId)
		ByteArray.WriteByte(cs_ByteArray,PlatformType[platform])
		ByteArray.WriteUTF(cs_ByteArray,sid, 512)
		mNetManager.Connect(mServerIp,mServerPort,cs_ByteArray)
		
		mConnecting = true
	end
end

function OPLogin()
	local sid = mAccountManager.GetSid()
	-- local uid = mAccountManager.GetSid()
	if not sid then
		mSDK.Login()
	else
		sid = ReplaceString(sid,"oauth_token=","")
		sid = ReplaceString(sid,"&oauth_token_secret=","|")
		local cs_ByteArray = ByteArray.Init()
		ByteArray.WriteByte(cs_ByteArray,PackatHead.PLATUC)
		ByteArray.WriteByte(cs_ByteArray,Packat_UC.UC_LOGIN)
		ByteArray.WriteInt(cs_ByteArray,VersionNum)
		ByteArray.WriteInt(cs_ByteArray,mServerId)
		ByteArray.WriteByte(cs_ByteArray,PlatformType[platform])
		ByteArray.WriteUTF(cs_ByteArray, sid, 512)
		mNetManager.Connect(mServerIp,mServerPort,cs_ByteArray)
		
		mConnecting = true
	end
end


-- function func()
	-- local cs_ByteArray = ByteArray.Init()
	-- ByteArray.WriteByte(cs_ByteArray,PackatHead.ACCOUNT)
	-- ByteArray.WriteByte(cs_ByteArray,Packat_Account.REQUEST_LOGIN)
	-- ByteArray.WriteInt(cs_ByteArray,mServerId)
	-- ByteArray.WriteInt(cs_ByteArray,VersionNum)
	-- ByteArray.WriteUTF(cs_ByteArray,mUserName)
	-- ByteArray.WriteUTF(cs_ByteArray,mPassWord)
	-- mNetManager.SendData(cs_ByteArray)
-- end

function GetServerId()
	return mServerId
end

function GetServerName()
	return mServerName
end

function Registered(userName, passWord)
	if string.len(userName) < 5 or string.len(passWord) < 5 then
		mAlertPanel.Show("账号与密码长度必须大于4位")
		return
	end
	
	if string.len(userName) > 10 or string.len(passWord) > 10 then
		mAlertPanel.Show("账号与密码长度不能大于10位")
		return
	end
	
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.ACCOUNT)
	ByteArray.WriteByte(cs_ByteArray,Packat_Account.REQUEST_REG_ACCOUNT)
	ByteArray.WriteInt(cs_ByteArray,VersionNum)
	ByteArray.WriteInt(cs_ByteArray,mServerId)
	ByteArray.WriteUTF(cs_ByteArray,userName)
	ByteArray.WriteUTF(cs_ByteArray,passWord)
	-- mNetManager.SendData(cs_ByteArray)
	
	mNetManager.Connect(mServerIp,mServerPort,cs_ByteArray)
end

function ChangePassWord(mUserName, mOldPassWord, mNewPassWord)
	if string.len(mNewPassWord) < 5 then
		mAlertPanel.Show("账号与密码长度必须大于4位")
		return
	end
	print("ChangePassWord")
end

function RequestJoinMap()
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.ACCOUNT)
	ByteArray.WriteByte(cs_ByteArray,Packat_Account.REQUEST_JOIN)
	-- ByteArray.WriteInt(cs_ByteArray,11)
	mNetManager.SendData(cs_ByteArray)
end

function Registered_Result(cs_ByteArray)
	local sucess = ByteArray.ReadInt(cs_ByteArray)
	print("Registered_Result", sucess)
	if sucess == 0 then
		mAccountManager.SaveAccountToLocal(mUserName, mPassWord,mServerIndex,mServerName,mServerIp,mServerPort,mServerId)
		mPanelManager.Hide(OnGUI)
		mPanelManager.Show(mCreateHeroPanel)
	elseif sucess == 2 then
		mAlertPanel.Show("账号名或密码太长")
		-- print("accout err!")
	else
		mAlertPanel.Show("账号名已经被使用")
		-- print("accout err!")
	end
end

function DrawServer(x, y, server)
	if not server then
		return
	end
	if GUI.Button(x,y,232,87,server.name,GUIStyleButton.ServerBtn) then
		mServerIndex = server.id
		mServerName = server.name
		mServerIp = server.ip
		mServerPort = server.port
		mServerId = server.serverId
		mAccountManager.SetNotifyUrl(server.notifyUrl)
		
		mPage = 1
	end
	if server.state == 1 then
		local image = mAssetManager.GetAsset("Texture/Gui/Text/newServer")
		GUI.DrawTexture(x+165,y+18,49,43,image)
	-- else
		-- local image = mAssetManager.GetAsset("Texture/Gui/Text/hotServer")
		-- GUI.DrawTexture(x+165,y+18,49,43,image)	
	end
end

function Login_Result(cs_ByteArray)
	local result = ByteArray.ReadInt(cs_ByteArray)
	print("Login_Result", result)
	if result == 0 then
		mAccountManager.SaveAccountToLocal(mUserName, mPassWord,mServerIndex,mServerName,mServerIp,mServerPort,mServerId)
	elseif result == 1 then
		mPanelManager.Hide(mConnectAlert)
		mAlertPanel.Show("账号或密码错误")
		mNetManager.Close()
		-- print("accout err!")
	elseif result == 2 then 
		mPanelManager.Hide(mConnectAlert)
		mAlertPanel.Show("当前游戏版本已过期,请重启登陆", mCommonlyFunc.QuitGame, nil,"退出","取消")
		mNetManager.Close()
	elseif result == 3 then 
		mPanelManager.Hide(mConnectAlert)
		-- mAlertPanel.Show("游戏将于2014-3-19 11:00准时开启, 敬请期待！")
		mNetManager.Close()
	elseif result == 4 then 
		mPanelManager.Hide(mConnectAlert)
		mAlertPanel.Show("服务器已爆满,请稍后再登！")
		mNetManager.Close()
	elseif result == 5 then 
		mPanelManager.Hide(mConnectAlert)
		mAlertPanel.Show("游戏版本过低,请重新到专区下载。http://a.9game.cn/zfzh/")
		mNetManager.Close()
	elseif result == 6 then 
		mPanelManager.Hide(mConnectAlert)
		mAlertPanel.Show("平台服务器未响应,请重启登陆", mCommonlyFunc.QuitGame, nil,"退出","取消")
		mNetManager.Close()
	end
	StopLogin()
end

function Player_Info(cs_ByteArray)
	local byRlt = ByteArray.ReadByte(cs_ByteArray)
	print("Player_Info" .. byRlt)
	-- if platform == "91" then
		-- if byRlt == 0 then
			-- mPromptAlert.Show("游戏版本过低,请到百度移动游戏平台下载最新版本")
		-- else
			-- local id = ByteArray.ReadInt(cs_ByteArray)
			-- local name = ByteArray.ReadUTF(cs_ByteArray, 40)
			-- local level = ByteArray.ReadInt(cs_ByteArray)
			-- mChangeAccountAlert.Show(id,name,level)
		-- end
		-- return
	-- end
	
	if byRlt == 0 then
		mPanelManager.Hide(mConnectAlert)
		mPanelManager.Hide(OnGUI)
		mPanelManager.Show(mCreateHeroPanel)
	else
		RequestJoinMap()
	end
	
	AppearEvent(nil, EventType.OnLogin)
	-- mHeroManager.ReadHeroData(cs_ByteArray)
end

function ACCOUNT_ALREADY_LOGIN()
	-- print("ACCOUNT_ALREADY_LOGIN!!!!!!!!!!!!!!!!")
	-- mConnecting = false
	
	mNetManager.Destroy(true)
	timer = mTimer.SetInterval(Login, 1)
end

-- function Join_Map_Result(cs_ByteArray)
	-- mHeroManager.ReadMapData(cs_ByteArray)
	-- mPanelManager.Hide(OnGUI)
	-- mPanelManager.InitPanel(mSceneManager)
-- end