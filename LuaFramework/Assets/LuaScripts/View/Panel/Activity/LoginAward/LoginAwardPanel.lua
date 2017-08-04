local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty = ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty
local AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,ActivityType,CFG_loginContinuAward,CFG_loginAward = 
AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,ActivityType,CFG_loginContinuAward,CFG_loginAward
local CFG_shipEquip,CFG_item,table,PackatHead,Packat_Award,EventType,SceneType,DrawItemCell = 
CFG_shipEquip,CFG_item,table,PackatHead,Packat_Award,EventType,SceneType,DrawItemCell
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mPanelManager = nil
local mHarborManager = nil
local mHarborSignupPanel = nil
local mRechargePanel = nil
local mAlert = nil
local mEquipViewPanel = nil
local mShipEquipViewPanel = nil
local mNetManager = nil
local mActivityPanel = require "LuaScript.Control.Data.ActivityManager"
local mItemViewPanel = nil
local mMainPanel = nil
local mSystemTip = nil


module("LuaScript.View.Panel.Activity.LoginAward.LoginAwardPanel")
local mScrollPositionY = 0
local mLoginInfo = nil
local mAward = nil

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mHarborSignupPanel = require "LuaScript.View.Panel.Activity.HarborBattle.HarborSignupPanel"
	mRechargePanel = require "LuaScript.View.Panel.Recharge.RechargePanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	mShipEquipViewPanel = require "LuaScript.View.Panel.Equip.ShipEquipViewPanel"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	
	mEventManager.AddEventListen(nil, EventType.RefreshLoginAward, Refresh)
	
	IsInit = true
end

function Display()
	mSceneManager.SetMouseEvent(false)
	mLoginInfo = mHeroManager.GetLoginAward()
	
	local mCount = mLoginInfo.loginContinueCount
	if mLoginInfo.geted then
		mCount = mCount - 1
	end
	
	mScrollPositionY = mCount*145 - 70
	Refresh()
end

function Refresh() -- 刷新奖励列表
	local mCount = mLoginInfo.loginCount
	if not mLoginInfo.geted then
		mCount = mCount + 1
	end
	mAward = {CFG_loginAward[mCount],CFG_loginAward[mCount+1],CFG_loginAward[mCount+2],CFG_loginAward[mCount+3]}
	
	for i=mCount+4,#CFG_loginAward do
		local loginAward = CFG_loginAward[i]
		if loginAward.quality == 1 and not mAward[5] then
			mAward[5] = loginAward
		end
		if loginAward.quality == 2 and not mAward[6] then
			mAward[6] = loginAward
		end
		if mAward[5] and mAward[6] then
			break
		end
	end
	if not mAward[5] or not mAward[6] then
		mSystemTip.ShowTip("奖励项不够多,需要再添加")
		return
	end
	table.sort(mAward, sortFunc)
end

function sortFunc(a, b)
	return a.continu < b.continu
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg43_1")
	GUI.DrawTexture(54,114,1024,512,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(83.5,37.5,1016.75-50,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	GUI.Label(525.5,48,84.2,30,"每日签到", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	GUI.Label(919,141,58,30,mLoginInfo.loginCount, GUIStyleLabel.Center_30_Green, Color.Black)
	GUI.Label(919,340,58,30,mLoginInfo.loginContinueCount, GUIStyleLabel.Center_30_Green, Color.Black)
	
	-- 签到按钮 true为领取过，false为未领取
	local oldEnabled = GUI.GetEnabled()
	if mLoginInfo.geted then
		GUI.SetEnabled(false)
	end
	if GUI.Button(883, 195, 142, 109, nil, GUIStyleButton.LoginButton) then
		RequestGetAwar()
		Refresh()
	end
	if mLoginInfo.geted then
		GUI.SetEnabled(oldEnabled)
	end
	
	-- 连续签到奖励，固定位置
	DrawLoginAward(128+2,222,mAward[1])
	DrawLoginAward(259+2,222,mAward[2])
	DrawLoginAward(387+2,222,mAward[3])
	DrawLoginAward(513+2,222,mAward[4])
	DrawLoginAward(645+2,222,mAward[5])
	DrawLoginAward(770+2,222,mAward[6])
	
	if mLoginInfo.geted then
		local image = mAssetManager.GetAsset("Texture/Gui/Text/get")
		GUI.DrawTexture(120,263,100,45,image)
	end
	
	local spacing = 145
	_,mScrollPositionY = GUI.BeginScrollView(135, 396, 900, 211, 0, mScrollPositionY, 0, 0, 870, spacing*7)
		for i=1,7 do
			local y = (i-1)*spacing
			local showY = y - mScrollPositionY / GUI.modulus
			if showY > -spacing  and showY < spacing*2 then
				DrawContinuAward(0,y,i)
			end
		end
	GUI.EndScrollView()
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
	end
end

function RequestGetAwar()  -- 获取奖励
	-- print("RequestGetAwar")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.AWARD)
	ByteArray.WriteByte(cs_ByteArray,Packat_Award.CLIENT_REQUEST_GET_TODAY_AWARD)
	mNetManager.SendData(cs_ByteArray)
end

function DrawLoginAward(x,y,award)
	if not award then
		return
	end
	local mCount = mLoginInfo.loginCount
	if not mLoginInfo.geted then
		mCount = mCount + 1
	end
	DrawAward(x,y,award)
	if mCount == award.continu then
		GUI.Label(x,y-25,80,30,"本次奖励", GUIStyleLabel.Center_20_Redbean)
	elseif mCount+1 == award.continu then
		GUI.Label(x,y-25,80,30,"下次奖励", GUIStyleLabel.Center_20_Redbean)
	else
		GUI.Label(x,y-25,80,30,"签到"..award.continu.."次", GUIStyleLabel.Center_20_Redbean)
	end
end

function DrawContinuAward(x,y,continu)
	local index = 0
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg43_2")
	GUI.DrawTexture(x,y,866,140,image)
	GUI.Label(x+30, y+70, 41, 29, continu, GUIStyleLabel.Left_40_Green, Color.Black)
	for k,award in pairs(CFG_loginContinuAward) do
		if award.continu == continu then
			DrawAward(x+index*135+250,y+25,award)
			index = index + 1
		end
	end
	if continu <= mLoginInfo.loginContinueCount then
		local image = mAssetManager.GetAsset("Texture/Gui/Text/get_3")
		GUI.DrawTexture(x+680,y,188,134,image)
	end
end

function DrawAward(x,y,award)
	if not award then
		return
	end
	
	DrawItemCell(award, award.type,x,y,80,80)
	
	-- if award.type == 1 then
		-- local cfg_equip = CFG_Equip[award.id]
		-- local image = mAssetManager.GetAsset("Texture/GUI/Bg/equipSlot1_"..cfg_equip.quality)
		-- GUI.DrawTexture(x,y,80,80,image)
		-- local image = mAssetManager.GetAsset("Texture/Icon/Equip/"..cfg_equip.icon, AssetType.Icon)
		-- if GUI.TextureButton(x+5,y+5,70,70,image) then
			-- award.star = 0
			-- award.notExist=true
			
			-- mEquipViewPanel.SetData(nil, award)
			-- mPanelManager.Show(mEquipViewPanel)
		-- end
	-- elseif award.type == 2 then
		-- local cfg_equip = CFG_shipEquip[award.id]
		-- local image = mAssetManager.GetAsset("Texture/GUI/Bg/equipSlot1_"..cfg_equip.quality)
		-- GUI.DrawTexture(x,y,80,80,image)
		-- local image = mAssetManager.GetAsset("Texture/Icon/ShipEquip/"..cfg_equip.icon, AssetType.Icon)
		-- if GUI.TextureButton(x+5,y+5,70,70,image) then
			-- award.star = 0
			-- award.notExist=true
			
			-- mShipEquipViewPanel.SetData(nil, award)
			-- mPanelManager.Show(mShipEquipViewPanel)
		-- end
	-- else
		-- local cfg_item = CFG_item[award.id]
		-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
		-- if GUI.TextureButton(x, y,80,80,image) then
			-- mItemViewPanel.SetData(cfg_item.id)
			-- mPanelManager.Show(mItemViewPanel)
		-- end
	-- end
	-- if award.count > 1 then
		-- GUI.Label(x+35, y+50, 41, 29, mCommonlyFunc.GetShortNumber(award.count), GUIStyleLabel.Right_25_White, Color.Black)
	-- end
end
