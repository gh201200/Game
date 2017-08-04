local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty = ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty
local AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,ActivityType,CFG_shipEquip,CFG_item,CFG_DiceBox,CFG_star = 
AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,ActivityType,CFG_shipEquip,CFG_item,CFG_DiceBox,CFG_star
local Packat_Award,PackatHead,EventType,DrawItemCell = Packat_Award,PackatHead,EventType,DrawItemCell
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
local mActivityManager = nil
local mAlert = nil
local mItemViewPanel = nil
local mShipEquipViewPanel = nil
local mNetManager = nil
local mItemManager = nil
local mSelectAlert = nil
local mEquipViewPanel = nil
local mEventManager = nil
local mSystemTip = nil
local mStarFateManager = nil
local mAddItemTip = nil

local mAwardIndex = 1

local mSelectIndex = 1
local mState = 1
local mSpeed = 0
local mCostTip = true
local mPlaying = false

local mPosition = {
		{146, 132},
		{256, 132},
		{366, 132},
		{476, 132},
		{586, 132},
		{696, 132},
		{806, 132},
		{916, 132},
		{916, 243},
		{916, 355},
		{806, 355},
		{696, 355},
		{586, 355},
		{476, 355},
		{366, 355},
		{256, 355},
		{146, 355},
		{146, 243},}


module("LuaScript.View.Panel.Activity.Gamble.GamblePanel")

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
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	mShipEquipViewPanel = require "LuaScript.View.Panel.Equip.ShipEquipViewPanel"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
	mEventManager = require "LuaScript.Control.EventManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mStarFateManager = require "LuaScript.Control.Data.StarFateManager"
	mAddItemTip = require "LuaScript.View.Tip.AddItemTip"
	
	mNetManager.AddListen(PackatHead.AWARD, Packat_Award.SEND_GET_DICE_ITEM, SEND_GET_DICE_ITEM)
	mEventManager.AddEventListen(nil, EventType.ConnectFailure, Refreshed)
	
	IsInit = true
end

function Refreshed()
	mPlaying = false
end

function Display()
	mCostTip = true
end

function OnGUI()
	if not IsInit then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/gambleBg")
	GUI.DrawTexture(80,100,1024,512,image)
	
	local activity = mActivityManager.GetActivity(ActivityType.Gamble)
	if not activity then
		return
	end
	DrawAward(activity.awardList[1], mPosition[1][1],mPosition[1][2],activity.goteList[1])
	DrawAward(activity.awardList[2], mPosition[2][1],mPosition[2][2],activity.goteList[2])
	DrawAward(activity.awardList[3], mPosition[3][1],mPosition[3][2],activity.goteList[3])
	DrawAward(activity.awardList[4], mPosition[4][1],mPosition[4][2],activity.goteList[4])
	DrawAward(activity.awardList[5], mPosition[5][1],mPosition[5][2],activity.goteList[5])
	DrawAward(activity.awardList[6], mPosition[6][1],mPosition[6][2],activity.goteList[6])
	DrawAward(activity.awardList[7], mPosition[7][1],mPosition[7][2],activity.goteList[7])
	DrawAward(activity.awardList[8], mPosition[8][1],mPosition[8][2],activity.goteList[8])
	DrawAward(activity.awardList[9],mPosition[9][1],mPosition[9][2],activity.goteList[9])
	DrawAward(activity.awardList[10],mPosition[10][1],mPosition[10][2],activity.goteList[10])
	DrawAward(activity.awardList[11],mPosition[11][1],mPosition[11][2],activity.goteList[11])
	DrawAward(activity.awardList[12],mPosition[12][1],mPosition[12][2],activity.goteList[12])
	DrawAward(activity.awardList[13],mPosition[13][1],mPosition[13][2],activity.goteList[13])
	DrawAward(activity.awardList[14],mPosition[14][1],mPosition[14][2],activity.goteList[14])
	DrawAward(activity.awardList[15],mPosition[15][1],mPosition[15][2],activity.goteList[15])
	DrawAward(activity.awardList[16],mPosition[16][1],mPosition[16][2],activity.goteList[16])
	DrawAward(activity.awardList[17], mPosition[17][1],mPosition[17][2],activity.goteList[17])
	DrawAward(activity.awardList[18],mPosition[18][1],mPosition[18][2],activity.goteList[18])
	
	local hero = mHeroManager.GetHero()
	local itemCount = mItemManager.GetItemCountById(134)
	
	local oldEnabled = GUI.GetEnabled()
	if mState ~= 1 or activity.count == 19 then
		GUI.SetEnabled(false)
	end
	if GUI.Button(556,218,149,128,nil,GUIStyleButton.StartButton) then
		if mPlaying then
			return
		end
		if mStarFateManager.GetStarFateFull() and StarCouldGet() then
			mSystemTip.ShowTip("星魂背包已满,请先整理.否则将无法获取星运!")
			return
		end
		
		if itemCount < activity.count then
			if mCostTip then
				local count = activity.count - itemCount
				function okFun(showTip)
					if not mCommonlyFunc.HaveGold(count*50) then
						return
					end
					mCostTip = not showTip
					mActivityManager.RequestUseDice()
					mPlaying = true
				end
				mSelectAlert.Show("本次探索还需"..count.."个色子,是否花费"..(count*50).."元宝购买?", okFun)
				return
			else
				local count = activity.count - itemCount
				if not mCommonlyFunc.HaveGold(count*50) then
					return
				end
				mActivityManager.RequestUseDice()
				mPlaying = true
			end
		else
			mActivityManager.RequestUseDice()
			mPlaying = true
		end
		
	end
	if mState ~= 1 or activity.count == 19 then
		GUI.SetEnabled(oldEnabled)
	end
	
	if mState == 1 then
	elseif mState == 2 then
		mSelectIndex = mSelectIndex + mSpeed
		if mSelectIndex > 54 and 1+math.floor((mSelectIndex-1)%18) == mAwardIndex then
			mState = 3
		end
	elseif mState == 3 then
		mSpeed = math.max(mSpeed - 0.3/40, 0.05)
		mSelectIndex = mSelectIndex + mSpeed
		if mSpeed <= 0.1 and 1+math.floor((mSelectIndex-1)%18) == mAwardIndex then
			mState = 1
			mSpeed = 0
			
			mActivityManager.RequestStopDice()
			local activity = mActivityManager.GetActivity(ActivityType.Gamble)
			activity.goteList[mAwardIndex] = true
			if activity.count == 0 then
				activity.count = 2
			else
				activity.count = activity.count + 1
			end
			
			if activity.awardList[mAwardIndex].type == 4 then
				mAddItemTip.ShowTip(4, activity.awardList[mAwardIndex].id, 1)
			end
		end
	end
	
	local position = mPosition[math.floor((mSelectIndex-1)%18)+1]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/select3")
	GUI.DrawTexture(position[1]-10,position[2]-10,100,100,image)
	
	GUI.Label(268+65, 300, 80, 30, "本次探索需要", GUIStyleLabel.Right_25_White, Color.Black)
	GUI.Label(480, 300, 80, 30, activity.count, GUIStyleLabel.Left_30_White, Color.Black)
	
	
	GUI.Label(308, 241, 80, 30, itemCount, GUIStyleLabel.Left_30_White, Color.Black)
	GUI.Label(426, 241, 80, 30, hero.gold, GUIStyleLabel.Left_30_White, Color.Black)
end

function StarCouldGet()
	local activity = mActivityManager.GetActivity(ActivityType.Gamble)
	for k,v in pairs(activity.awardList) do
		if v.type == 4 and not activity.goteList[k] then
			return true
		end
	end
	return false
end

function DrawAward(award, x, y, goted)
	if not award then
		return 
	end
	if DrawItemCell(award, award.type, x, y, 80 ,80) then

	end
	
	if goted then
		local image = mAssetManager.GetAsset("Texture/GUI/Text/get")
		GUI.DrawTexture(x-10,y+30,100,45,image)
	end
end

function SEND_GET_DICE_ITEM(cs_ByteArray)
	-- print("SEND_GET_DICE_ITEM")
	mSpeed = 0.45
	mState = 2
	mSelectIndex = (mSelectIndex-1)%18 + 1
	mAwardIndex = (ByteArray.ReadShort(cs_ByteArray)-1)%18 + 1
	mPlaying = false
	-- print(mAwardIndex)
end