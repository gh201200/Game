local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty = ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty
local AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,ActivityType,CFG_levelAward,table,CFG_item,ItemType = 
AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,ActivityType,CFG_levelAward,table,CFG_item,ItemType
local mSDK = mSDK
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local DrawItemCell = DrawItemCell
local mSceneManager = nil
local mHeroManager = nil
local mPanelManager = nil
local mAlert = nil
local mActivityManager = nil
local mActivityPanel = require "LuaScript.Control.Data.ActivityManager"

local ActivityButton,ActivityName = ActivityButton,ActivityName

module("LuaScript.View.Panel.Activity.MonthCard.MonthCardPanel")
local mActivity = nil
local serverTime = nil


function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mAlert = require "LuaScript.View.Alert.Alert"
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	
	IsInit = true
end

function Display()
	serverTime = mActivityManager.GetServerTime()
end

function OnGUI()
	if not IsInit then
		return
	end
	serverTime = mActivityManager.GetServerTime()
	if not serverTime then
		return
	end

    local image = mAssetManager.GetAsset("Texture/Gui/Bg/MonthCard_bg")
	GUI.DrawTexture(80,100,1024,512,image)
		
	local mMonthCard = mHeroManager.GetMonthCard()
	
	local et1 = mMonthCard.monthCardEndTime1  --大于 servertime  则已购买
	local get1 = mMonthCard.monthCardGet1 	--0未领取奖励 1已领取
	local et2 = mMonthCard.monthCardEndTime2  -- 等于-1时已购买
	local get2 = mMonthCard.monthCardGet2     --0未领取奖励 1已领取
	if et1== nil or	et2== nil or get1== nil or get2 == nil then
		return -- 刚开始游戏短暂延迟未接收到数据会报错，这里做限制
	end
    -- 月卡
	local cost = 30
	if mMonthCard.monthCardEndTime1 <  serverTime  then
		if GUI.Button(210, 360, 256, 64,nil, GUIStyleButton.ActivityBtn_card_buy) then
			mSDK.Pay_YJ(cost * 100, "月卡", 1, nil, 1)
		end
	elseif  mMonthCard.monthCardEndTime1 >  serverTime then
	
		if	mMonthCard.monthCardGet1 == 0 then
			if GUI.Button(210, 360, 256, 64,nil, GUIStyleButton.ActivityBtn_card_get) then
				mHeroManager.REQUEST_MONTH_AWARD(1) -- 领取月卡
			end
		elseif mMonthCard.monthCardGet1  == 1 then
		    
		local image = mAssetManager.GetAsset("Texture/Gui/Button/card_got1_1")
			GUI.DrawTexture(210, 360, 256, 64,image)
		end
	end
	-- 终生卡
	local cost = 168
	if mMonthCard.monthCardEndTime2 ~= -1  then
		if GUI.Button(663, 360, 256, 64,nil, GUIStyleButton.ActivityBtn_card_buy) then
			mSDK.Pay_YJ(cost * 100, "月卡", 1, nil, 2)
		end
	elseif  mMonthCard.monthCardEndTime2 == -1 then
	
		if	mMonthCard.monthCardGet2 == 0 then
			if GUI.Button(663, 360, 256, 64,nil, GUIStyleButton.ActivityBtn_card_get) then
				mHeroManager.REQUEST_MONTH_AWARD(2)-- 领取终身卡
			end
		elseif mMonthCard.monthCardGet2  == 1 then
		
			local image = mAssetManager.GetAsset("Texture/Gui/Button/card_got1_1")
			GUI.DrawTexture(663, 360, 256, 64,image)
		end
	end
	
end

