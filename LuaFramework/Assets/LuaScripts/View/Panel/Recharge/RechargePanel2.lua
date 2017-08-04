local _G,Screen,Language,GUI,ByteArray,print,Texture2D,Input,math,Event,UnityEventType,MouseButton,tostring,pairs = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,Input,math,Event,UnityEventType,MouseButton,tostring,pairs
local PackatHead,Packat_Account,Packat_Player,require,KeyCode = PackatHead,Packat_Account,Packat_Player,require,KeyCode
local GUIStyleLabel,Color,SceneType,mHarborPanel,GUIStyleButton = GUIStyleLabel,Color,SceneType,mHarborPanel,GUIStyleButton
local ConstValue,CFG_recharge,CFG_vip,platform,IsDebug,CsPrint,Application,error,SplitString,IPhonePlayer,Android = 
ConstValue,CFG_recharge,CFG_vip,platform,IsDebug,CsPrint,Application,error,SplitString,IPhonePlayer,Android
local tonumber,EventType,io,string,table,LjPlatformType,CFG_vip2,IosTestScript = 
tonumber,EventType,io,string,table,LjPlatformType,CFG_vip2,IosTestScript
local mAssetManager = nil
local mNetManager = nil
local mPanelManager = require "LuaScript.Control.PanelManager"
local mSceneManager = nil
local mCreateHeroPanel = nil
local mAccountManager = nil
local mScenePanel = nil
local mHeroManager = nil
local mPackageViewPanel = nil
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mSDK = nil
local mRMBInputPanel = require "LuaScript.View.Panel.Recharge.RMBInputPanel"
local mPackageKeyPanel = require "LuaScript.View.Panel.Item.PackageKeyPanel"
local mConnectAlert = nil
local mTimer = nil
local mAlert = nil
local mSystemTip = nil
module("LuaScript.View.Panel.Recharge.RechargePanel2")
panelType = ConstValue.AlertPanel
local showVip = nil
local mBillList = nil
local mActivityManager = nil

function Hide()
	mSceneManager.SetMouseEvent(mMouseEventState)
	showVip = nil
end

function Display()
	mMouseEventState = mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false)
end

function Init()
	mAlert = require "LuaScript.View.Alert.Alert"
	mEventManager = require "LuaScript.Control.EventManager"
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mCreateHeroPanel = require "LuaScript.View.Panel.Login.CreateHeroPanel"
	mAccountManager = require "LuaScript.Control.Data.AccountManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mScenePanel = require "LuaScript.View.Panel.ScenePanel"
	mSDK = require "LuaScript.Mode.Object.SDK"
	mPackageViewPanel = require "LuaScript.View.Panel.Item.PackageViewPanel"
	mConnectAlert = require "LuaScript.View.Alert.ConnectAlert"
	mTimer = require "LuaScript.Common.Timer"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	
	mEventManager.AddEventListen(nil, EventType.OnLogin, OnLogin)
	mEventManager.AddEventListen(nil, EventType.SDKPay, SDKPay)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_IOS_BILL_END, SEND_IOS_BILL_END)
	
	--ios test script
	if IosTestScript then
		CFG_vip = CFG_vip2
	end
	
	if platform == "main" and IPhonePlayer then
		ReadBillFromFile()
		mTimer.SetInterval(intervalFunc, 30)
	end
	
	IsInit = true
end

function OnLogin()
	-- print("OnLogin")
	if not mBillList then
		return
	end
	
	for k,bill in pairs(mBillList) do
		bill.checkTime = nil
		bill.checkCount = 1
	end
	intervalFunc()
end

function intervalFunc()
	local hero = mHeroManager.GetHero()
	if not hero then
		return
	end
	if not mBillList then
		return
	end
	if not mNetManager.IsConnected() then
		return
	end
	
	local needSave = false
	paySeverId = mAccountManager.GetServerId()
	for k,bill in pairs(mBillList) do
		if bill.payCharId == hero.id and bill.paySeverId == paySeverId then
			local serverTime = mActivityManager.GetServerTime()
			local spacingTime = 60
			if bill.checkCount < 6 then
				spacingTime = 30
			elseif bill.checkCount < 11 then
				spacingTime = 300
			elseif bill.checkCount < 16 then
				spacingTime = 1800
			end
			
			if not bill.checkTime or bill.checkTime + spacingTime < serverTime then
				needSave = true
				bill.checkTime = serverTime
				bill.checkCount = bill.checkCount + 1
				RequesAddBill(bill.billStr,bill.checkStr)
			end
		end
	end
	
	if needSave then
		SaveBillToFile()
	end
end

function SDKPay(_, _, info)
	-- print("SDKPay", info)
	local bill = SplitString(info, "|")
	-- print(bill)
	mPanelManager.Hide(mConnectAlert)
	if bill[1] == "success" then
		-- print(111)
		SaveBill(info)
		mSystemTip.ShowTip("充值成功,元宝将在2分钟内到账",Color.LimeStr)
	elseif bill[1] == "fail" then
		-- print(222)
		-- mAlert.Show("充值失败,请重新尝试。如问题还未解决,请联系客服,官方QQ群:299581325。")
		-- mSystemTip.ShowTip("充值成功,元宝将在2分钟内到账",Color.LimeStr)
	end
	-- print(333)
end

function SaveBill(info)
	-- print("SaveBill",info)
	local hero = mHeroManager.GetHero()
	mBillList = mBillList or {}
	local bill = SplitString(info, "|")
	bill.billStr = bill[2]
	bill.checkStr = bill[3]
	bill.checkCount = 1
	bill.paySeverId = paySeverId or  mAccountManager.GetServerId()
	bill.payCharId = payCharId or hero.id
	bill.starTime = mActivityManager.GetServerTime()
	bill.checkTime = bill.starTime
	
	if mBillList[bill.billStr] then
		error("bill exist???")
	else
		mBillList[bill.billStr] = bill
		SaveBillToFile(info)
	end
	
	
	RequesAddBill(bill.billStr,bill.checkStr)
end

function RequesAddBill(billStr, checkStr)
	print("RequesAddBill",billStr, checkStr)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.REQUEST_IOS_ADD_BILL)
	ByteArray.WriteUTF(cs_ByteArray,checkStr,5000)
	ByteArray.WriteUTF(cs_ByteArray,billStr,50)
	mNetManager.SendData(cs_ByteArray)
end

function SEND_IOS_BILL_END(cs_ByteArray)
	local billStr = ByteArray.ReadUTF(cs_ByteArray, 128)
	local state = ByteArray.ReadByte(cs_ByteArray)
	-- print("SEND_IOS_BILL_END",billStr,state)
	if not mBillList then
		return
	end
	mBillList[billStr] = nil
	SaveBillToFile()
	
	if state == 1 then
		error("error bill!")
	end
end

function SaveBillToFile(info)
	-- print("SaveBillToFile",info)
	local f = io.open(ConstValue.DataPath.."billData", "w")
	if not f then
		error("bill write bug???"..(info or ""))
	end
	for k,bill in pairs(mBillList) do
		-- print(bill)
		local str = string.format("%s|%s|%d|%d|%d",bill.billStr,bill.checkStr,bill.paySeverId,bill.payCharId,bill.starTime)
		f:write(str)
	end
	f:close()
end

function ReadBillFromFile()
	-- print("ReadBillFromFile")
	local f = io.open(ConstValue.DataPath.."billData", "r")
	if not f then
		return
	end
	
	local value = f:read("*line")
	while value do
		local bill = SplitString(value, "|")
		bill.billStr = bill[1]
		bill.checkStr = bill[2]
		bill.paySeverId = tonumber(bill[3])
		bill.payCharId = tonumber(bill[4])
		bill.starTime = tonumber(bill[5])
		bill.checkCount = 1
		
		mBillList = mBillList or {}
		mBillList[bill.billStr] = bill
		
		value = f:read("*line")
	end
	f:close()
end

function Pay(money)
	if platform == "main" and not IPhonePlayer and not Android then
		mSystemTip.ShowTip("PC版不开放充值功能")
		return
	end
	
	local hero = mHeroManager.GetHero()
	local mNotifyUrl = mAccountManager.GetNotifyUrl()
	if not ValidMoney(money) then
		mPanelManager.Show(mRMBInputPanel)
	else
		mSDK.Pay(false, money or 0, hero.id, hero.name, hero.level, tostring(hero.id), mNotifyUrl)
		if platform == "main" and IPhonePlayer then
			payCharId = hero.id
			paySeverId = mAccountManager.GetServerId()
			
			mPanelManager.Show(mConnectAlert)
		end
	end
end

function ValidMoney(money)
	if not money then
		return false
	end
	local mGoldUnitList = mCommonlyFunc.GetGoldUnitList()
	if platform == "main" and IPhonePlayer and not mGoldUnitList[money] then
		return false
	end
	
	if platform == "lj" then
		local channel = mSDK.GetChannel()
		if LjPlatformType[channel] and not mGoldUnitList[money] and (LjPlatformType[channel].AccountHead == "YDMM" or 
			LjPlatformType[channel].AccountHead == "WO") then
			return false
		end
	end
	return true
end

function OnGUI()
	local hero = mHeroManager.GetHero()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/rechargeBg")
	GUI.DrawTexture(172,78,795,497,image)
	
	local hero = mHeroManager.GetHero()
	if not showVip then
		showVip = hero.vipLevel
	end
	if showVip <= 0 then
		showVip = 1
	end
	if showVip > 15 then
		showVip = 15
	end
	
	GUI.Label(346,134,119,36,"您当前等级:",GUIStyleLabel.Left_25_Lime_Art,Color.Black)
	local image = mAssetManager.GetAsset("Texture/Gui/Text/vip"..hero.vipLevel)
	GUI.DrawTexture(498,132,128,36,image)
	
	local cfg_vip = CFG_vip[math.min(hero.vipLevel+1, 15)]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/rechargeBg_4")
	GUI.DrawTexture(285,166,341*hero.vipExp/cfg_vip.vipExp,24,image,0,0,1*hero.vipExp/cfg_vip.vipExp,1,0,0,0,0)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/rechargeBg_3")
	GUI.DrawTexture(278.4,162.95,355,37,image)
	GUI.Label(436,168,49.2,22,hero.vipExp.."/"..cfg_vip.vipExp,GUIStyleLabel.Center_20_Lime,Color.Black)
	
	
	local image = mAssetManager.GetAsset("Texture/Gui/Text/vip"..showVip)
	GUI.DrawTexture(272,232,128,36,image)
	GUI.Label(365,236,191.2,22,"需累计充值"..CFG_vip[showVip].gold.."元宝",GUIStyleLabel.Left_25_White,Color.Black)
	
	local height = GUI.GetTextHeight(CFG_vip[showVip].desc, 380, GUIStyleLabel.Left_20_White)
	_,mScrollPositionY = GUI.BeginScrollView(260,270, 591, 200, 0, mScrollPositionY, 0, 0, 400, height)
		GUI.Label(0,0,370,height,CFG_vip[showVip].desc,GUIStyleLabel.Left_20_White_WordWrap)
		
		--ios test script
		if IosTestScript then
		
		else
			if GUI.Button(269,0,92,27,"[点击查看]",GUIStyleButton.Transparent_20) then
				mPackageViewPanel.SetData(55+showVip)
				mPanelManager.Show(mPackageViewPanel)
			end
			if GUI.Button(209,23,92,27,"[点击查看]",GUIStyleButton.Transparent_20) then
				mPackageViewPanel.SetData(101+showVip)
				mPanelManager.Show(mPackageViewPanel)
			end
		end
	GUI.EndScrollView()
	
	
	
	
	if showVip == 1 then
		GUI.Button(346,486,49,29,nil,GUIStyleButton.LeftBtn_2)
	else
		if GUI.Button(346,486,49,29,nil,GUIStyleButton.LeftBtn_1) then
			showVip = showVip - 1
		end
	end
	if showVip == 15 then
		GUI.Button(506,486,49,29,nil,GUIStyleButton.RightBtn_2)
	else
		if GUI.Button(506,486,49,29,nil,GUIStyleButton.RightBtn_1) then
			showVip = showVip + 1
		end
	end
	GUI.Label(423,485,56.2,22,showVip.."/15",GUIStyleLabel.Left_25_Black)
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Text/rechargeGold")
	-- GUI.DrawTexture(746,138,119,36,image)
	
	-- local info = "已有元宝:"
	-- info = info .. mCommonlyFunc.BeginColor(Color.YellowStr)
	-- info = info .. hero.gold
	-- info = info .. mCommonlyFunc.EndColor()
	-- GUI.Label(732.95,164.05,119,36,info,GUIStyleLabel.Center_25_White)
	GUI.Label(706,139,119,36,"充值元宝",GUIStyleLabel.Left_45_Yellow_Art, Color.Black)
	GUI.Label(697,220,218,36,"元宝充值比例为1:10,即充值1元人民币可获得10元宝.充值可提升VIP等级,获得更多的特权.",GUIStyleLabel.Left_30_LightYellow_Art, Color.Black)
	
	-- CsPrint(hero.firstRecharge.."" , IsDebug.."")
	if (hero.firstRecharge > 0 or _G.IsDebug) and GUI.Button(688, 431, 223, 78,"点击充值", GUIStyleButton.OrangeBtn) then
		Pay()
	end
	
	
	if GUI.Button(882, 75, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end

function ResetCenter()
	local hero = mHeroManager.GetHero()
	mCenterX = hero.x
	mCenterY = 16384 - hero.y
end