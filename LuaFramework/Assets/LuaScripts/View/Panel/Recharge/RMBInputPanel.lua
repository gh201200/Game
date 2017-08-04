local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty = ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty
local AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,CFG_family,platform,IPhonePlayer,LjPlatformType = 
AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,CFG_family,platform,IPhonePlayer,LjPlatformType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mCharManager = nil
local mPanelManager = nil
local mHarborManager = nil
local mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
local mRechargePanel = nil
local mSDK = nil

module("LuaScript.View.Panel.Recharge.RMBInputPanel")
panelType = ConstValue.AlertPanel
local mMoney = 198
local showType = 1
function Init()
	-- print(111)
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	-- mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mRechargePanel = require "LuaScript.View.Panel.Recharge.RechargePanel"
	mSDK = require "LuaScript.Mode.Object.SDK"
	
	if platform == "main" and IPhonePlayer then
		showType = 2
	end
	
	if platform == "lj" then
		local channel = mSDK.GetChannel()
		if LjPlatformType[channel] and (LjPlatformType[channel].AccountHead == "YDMM" or 
			LjPlatformType[channel].AccountHead == "WO") then
			showType = 2
		end
	end
	
	IsInit = true
end

function Hide()
	mMoney = 198
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/alertBg")
	GUI.DrawTexture(284,144,560,341,image)
	
	
	if showType == 1 then
		local newMoneyStr = GUI.TextArea(384,287,356,78, mMoney, GUIStyleTextField.Left_30_White)
		mMoney = math.floor(tonumber(newMoneyStr) or mMoney)
		mMoney = math.min(math.max(1, mMoney), 9999)
		if platform == "ky" then
			mMoney = math.min(mMoney, 2000)
		end
		
		local image = mAssetManager.GetAsset("Texture/Gui/Text/inputMoney")
		GUI.DrawTexture(464,174,168,38,image)
		
		local str = "1人民币=10元宝"
		GUI.Label(475+175,234,82.7,30,str, GUIStyleLabel.Right_20_DeepBlue)
		GUI.Label(366,234,82.7,30,"充值额度:", GUIStyleLabel.Center_30_Brown_Art)
		GUI.Label(630,305,82.7,30,"人民币", GUIStyleLabel.Left_30_White)
	else
		local str = "1人民币=10元宝"
		GUI.Label(475+175,234,82.7,30,str, GUIStyleLabel.Right_20_DeepBlue)
		GUI.Label(474,179,168,38,"选择充值额度", GUIStyleLabel.Center_30_Brown_Art)
		local mRMBList = mCommonlyFunc.GetRMBList()
		if mMoney == 6 then
			GUI.Button(368,256,100,55,"￥"..mRMBList[1],GUIStyleButton.SelectMoneyBtn_2)
		else
			if GUI.Button(368,256,100,55,"￥"..mRMBList[1],GUIStyleButton.SelectMoneyBtn_1) then
				mMoney = mRMBList[1]
			end
		end
		
		
		if mMoney == mRMBList[2] then
			GUI.Button(368+150,256,100,55,"￥"..mRMBList[2],GUIStyleButton.SelectMoneyBtn_2)
		else
			if GUI.Button(368+150,256,100,55,"￥"..mRMBList[2],GUIStyleButton.SelectMoneyBtn_1) then
				mMoney = mRMBList[2]
			end
		end
		
		
		if mMoney == mRMBList[3] then
			GUI.Button(368+300,256,100,55,"￥"..mRMBList[3],GUIStyleButton.SelectMoneyBtn_2)
		else
			if GUI.Button(368+300,256,100,55,"￥"..mRMBList[3],GUIStyleButton.SelectMoneyBtn_1) then
				mMoney = mRMBList[3]
			end
		end
		
		if mMoney == mRMBList[4] then
			GUI.Button(368,256+55,100,55,"￥"..mRMBList[4],GUIStyleButton.SelectMoneyBtn_2)
		else
			if GUI.Button(368,256+55,100,55,"￥"..mRMBList[4],GUIStyleButton.SelectMoneyBtn_1) then
				mMoney = mRMBList[4]
			end
		end
		
		if mMoney == mRMBList[5] then
			GUI.Button(368+150,256+55,100,55,"￥"..mRMBList[5],GUIStyleButton.SelectMoneyBtn_2)
		else
			if GUI.Button(368+150,256+55,100,55,"￥"..mRMBList[5],GUIStyleButton.SelectMoneyBtn_1) then
				mMoney = mRMBList[5]
			end
		end
		
		if mMoney == mRMBList[6] then
			GUI.Button(368+300,256+55,100,55,"￥"..mRMBList[6],GUIStyleButton.SelectMoneyBtn_2)
		else
			if GUI.Button(368+300,256+55,100,55,"￥"..mRMBList[6],GUIStyleButton.SelectMoneyBtn_1) then
				mMoney = mRMBList[6]
			end
		end
	end
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/money")
	-- GUI.DrawTexture(680,308,41,28,image)
	
	if GUI.Button(372,366,166,77, "确定", GUIStyleButton.BlueBtn) then
		mPanelManager.Hide(OnGUI)
		mRechargePanel.Pay(mMoney)
	end
	if GUI.Button(586,366,166,77, "取消", GUIStyleButton.BlueBtn) then
		mPanelManager.Hide(OnGUI)
	end
	if GUI.Button(769,128,77,63, nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end