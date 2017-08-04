local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty = ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty
local AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,ActivityType,CFG_levelAward,table,CFG_item,ItemType = 
AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,ActivityType,CFG_levelAward,table,CFG_item,ItemType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil
local DrawItemCell = DrawItemCell
local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mPanelManager = nil
local mHarborManager = nil
local mHarborSignupPanel = nil
local mRechargePanel = nil
local mAlert = nil
local mActivityManager = nil
local mActivityPanel = require "LuaScript.Control.Data.ActivityManager"
local ActivityButton,ActivityName = ActivityButton,ActivityName
local mScrollPositionX = 0

module("LuaScript.View.Panel.Activity.LevelAward.LevelAwardPanel")
local mActivity = nil
local table_levelAward = nil
local AwardGotNum = 0

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
	UpdateAwardTable()
	
	IsInit = true
end

function Display()
	mActivity = mActivityPanel.GetActivity(ActivityType.LevelAward) -- 获取玩家是否能领取奖励
	UpdateAwardTable()
	AwardGotNum = 0
	for	k , item in pairs (mActivity.award) do
	    if  item.got then
		    AwardGotNum = AwardGotNum + 1
		end 
	end
	if  AwardGotNum > (#mActivity.award - 3) then
		AwardGotNum = #mActivity.award - 3
	end 
	mScrollPositionX = (235 * AwardGotNum) - 235
end

function UpdateAwardTable()
	-- 从表获取奖励等级
	table_levelAward = {} 
	for k, item in pairs(CFG_levelAward) do
	   table.insert(table_levelAward,item.level)
	end
	table.sort(table_levelAward)
end

function OnGUI()
	if not IsInit then
		return
	end
    
	local mHero = mHeroManager.GetHero()
	local cost = mHeroManager.GetAwardLevelPrice()
	if mHero.mlevelAward == 0  then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/levelAward"..cost)
	    GUI.DrawTexture(80,100,1024,512,image)
		if GUI.Button(480, 310, 209, 70,nil, GUIStyleButton.Transparent) then
			function okFun()
				if not mCommonlyFunc.HaveGold(cost) then
					return
				end
			mActivityManager.RequestBuyLevelAward()
			end
		mAlert.Show("是否花费"..cost.."元宝购买成长基金", okFun)		
		end
		return
	end
	
	local spacing = 235
	local count = #table_levelAward
	-- for k ,item in pairs (mActivity.award) do 
		-- print(k)
	    -- print(item)
	-- end
	mScrollPositionX,_ = GUI.BeginScrollView(123,117,890,340, mScrollPositionX, 0, 0, 0,count*spacing, 340)
		for index=1,count,1 do
		    local Level = table_levelAward[index]
			local itemGold = getValue(CFG_levelAward[Level])
			local x = index * spacing - spacing
			DrawItem(x,0,Level,itemGold,index)
		end
	GUI.EndScrollView()
end

function getValue(cfg_levelAward) -- 获取不同等级奖励的金币数
	local value = cfg_levelAward.gold
	if value >= 10000 then
		return value / 10000 .."万"
	else
		return value
	end
end

function DrawItem(x,y,Level,itemGold,index)
    
	local hero = mHeroManager.GetHero()
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg37_1")
	GUI.DrawTexture(x,y,225,345,image)
	
	local cfg_item = CFG_item[13]
	
	--领取的等级
	local image = mAssetManager.GetAsset("Texture/Gui/Text/lv"..Level)
	GUI.DrawTexture(x+44,y+12,126,36,image)
	
	local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
	
	DrawItemCell(cfg_item, ItemType.Item, x+72, y+74,80,80)
	
	local str = nil
	str ="奖励"..itemGold.."元宝"
	GUI.Label(x+41,y+205,144,30, str, GUIStyleLabel.MCenter_21_White, Color.Black)
	
	
	 -- 领取按钮显示
	if mActivity.award[index].couldGet then
		if GUI.Button(x+50, y+230, 128, 128, nil, GUIStyleButton.GetGold) then
			mActivityPanel.RequestLevelAward(index)
		end
	else
		GUI.Button(x+50, y+230, 128, 128, nil, GUIStyleButton.GetGold_2)
	end
	
	-- 获取后标记
	if mActivity.award[index].got then
		local image = mAssetManager.GetAsset("Texture/Gui/Text/get")
		GUI.DrawTexture(x+66, y+270,100,45,image)
		AwardGotNum = AwardGotNum + 1
	end

end
