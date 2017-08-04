local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty = ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty
local AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,ActivityType,os,CFG_item,DrawItemCell,ItemType = 
AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,ActivityType,os,CFG_item,DrawItemCell,ItemType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil
-- 
local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mPanelManager = nil
local mHarborManager = nil
local mHarborSignupPanel = nil
local mRechargePanel = nil
local mAlert = nil
local mPackageViewPanel = nil
local mActivityManager = nil

module("LuaScript.View.Panel.Activity.CostAward.CostAwardPanel") -- 消费好礼
local mStr = nil
local mPage = 1
function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	-- 
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mHarborSignupPanel = require "LuaScript.View.Panel.Activity.HarborBattle.HarborSignupPanel"
	mRechargePanel = require "LuaScript.View.Panel.Recharge.RechargePanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	mPackageViewPanel = require "LuaScript.View.Panel.Item.PackageViewPanel"
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	IsInit = true
end

function Display()
	local activity = mActivityManager.GetActivity(ActivityType.CostAward)
	if activity.data[1].startTime > 1388505600--[[GMT，01/01/14]] then
		local mStarTimeTabel = os.date("*t", activity.data[1].startTime)
		local mEndTimeTabel = os.date("*t", activity.data[1].endTime)
		mStr = "活动时间:<color=lime>"..mStarTimeTabel.month.."月"..mStarTimeTabel.day..
				"日</color>到<color=lime>"..mEndTimeTabel.month.."月"..mEndTimeTabel.day.."日</color>"
	else -- 时间不正常时，从服务器获取时间
		local mStartTime = mActivityManager.GetServerStartTime()
		local mStarTimeTabel = os.date("*t", mStartTime+activity.data[1].startTime)
		local mEndTimeTabel = os.date("*t", mStartTime+activity.data[1].endTime)
		mStr = "活动时间:<color=lime>"..mStarTimeTabel.month.."月"..mStarTimeTabel.day..
				"日</color>到<color=lime>"..mEndTimeTabel.month.."月"..mEndTimeTabel.day.."日</color>"
	end
end

function OnGUI()
-- print(1111)
	if not IsInit then
		return
	end
	
	local hero = mHeroManager.GetHero()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/costAward")
	GUI.DrawTexture(80,100,1024,512,image)
	
	GUI.Label(240,178,84,30,mStr, GUIStyleLabel.Left_20_White, Color.Black)
	GUI.Label(855,178,94,30,"目前累计消费:"..hero.totalCost, GUIStyleLabel.Right_20_White, Color.Black)

	local activity = mActivityManager.GetActivity(ActivityType.CostAward)
	if activity then
		DrawAward(197+7,258+30,activity.data[1].itemId,activity.data[1].gold,activity.award1,1)
		DrawAward(415+5,258+30,activity.data[2].itemId,activity.data[2].gold,activity.award2,2)
		DrawAward(638-4,258+30,activity.data[3].itemId,activity.data[3].gold,activity.award3,3)
		DrawAward(853-4,258+30,activity.data[4].itemId,activity.data[4].gold,activity.award4,4)
	end
end

function DrawAward(x, y, packageId, gold, got, index)
	local cfg_item = CFG_item[packageId]
	
	if index == 1 then
		GUI.Label(x,y-50,86,30,"白银大礼", GUIStyleLabel.Center_35_Brown_Art)
	elseif index == 2 then
		GUI.Label(x,y-50,86,30,"黄金大礼", GUIStyleLabel.Center_35_Brown_Art)
	elseif index == 3 then
		GUI.Label(x,y-50,86,30,"钻石大礼", GUIStyleLabel.Center_35_Brown_Art)
	elseif index == 4 then
		GUI.Label(x,y-50,86,30,"至尊大礼", GUIStyleLabel.Center_35_Brown_Art)
	end
	-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
	if DrawItemCell(cfg_item, ItemType.Item, x, y,86,85,true,false,false) then
		mPackageViewPanel.SetData(packageId)
		mPanelManager.Show(mPackageViewPanel)
	end
	
	if got then -- 领取
		local image = mAssetManager.GetAsset("Texture/Gui/Text/get")
		GUI.DrawTexture(x-5, y+45, 100, 45,image)
	end
	
	GUI.Label(x+85,y+105,0,30, gold, GUIStyleLabel.Left_25_White, Color.Black)
end