local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Relation,Packat_Goods,Language,ConstValue = 
print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Relation,Packat_Goods,Language,ConstValue
local PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent = 
PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent
local CFG_role,Color,Packat_Quest,CFG_vipLevel = CFG_role,Color,Packat_Quest,CFG_vipLevel
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mAssetManager = nil
local mEventManager = nil
local mNetManager = nil
local mSystemTip = nil
local mAlert = nil
local mFamilyManager = nil
local mHeroManager = nil
local mFriendPanel = nil

module("LuaScript.Control.Data.VipManager")

local mFreeRefresh = nil

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mAlert = require "LuaScript.View.Alert.Alert"
	mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mFriendPanel = require "LuaScript.View.Panel.Friend.FriendPanel"
	
	mNetManager.AddListen(PackatHead.QUEST, Packat_Quest.SEND_FREE_REFRESH_RANDOM_QUEST_COUNT, SEND_FREE_REFRESH_RANDOM_QUEST_COUNT)
	
end

function SEND_FREE_REFRESH_RANDOM_QUEST_COUNT(cs_ByteArray)
--	print("SEND_FREE_REFRESH_RANDOM_QUEST_COUNT")
	mFreeRefresh = ByteArray.ReadByte(cs_ByteArray)--当前能否免费招募
--	print(mFreeRefresh)
end

function GetValue(level, property)
	local key = level.."_"..property
	local cfg_vipLevel = CFG_vipLevel[key]
	if cfg_vipLevel then
		return cfg_vipLevel.propertyValue
	end
	return 0
end

function GetFreeRefresh()
	local hero = mHeroManager.GetHero()
	return GetValue(hero.vipLevel, 6) - mFreeRefresh--免费刷新次数
end

function CopyMapCountBuy(count)
	count = count or 1
	local hero = mHeroManager.GetHero()
	if GetValue(hero.vipLevel, 2) >= hero.copyMapBuyCount + count then
		return true
	end
end

function LabUpSpeed() --科技升级速度
	local hero = mHeroManager.GetHero()
	-- if hero.vipLevel == 7 then
		-- return 2
	-- elseif hero.vipLevel == 8 then
		-- return 2
	-- elseif hero.vipLevel == 9 then
		-- return 2
	-- elseif hero.vipLevel == 10 then
		-- return 3
	-- elseif hero.vipLevel == 11 then
		-- return 4
	-- elseif hero.vipLevel == 12 then
		-- return 4
	-- elseif hero.vipLevel == 13 then
		-- return 4
	-- elseif hero.vipLevel == 14 then
		-- return 5
	-- elseif hero.vipLevel == 15 then
		-- return 5
	-- end
	return GetValue(hero.vipLevel, 7)
end

function ShipBuildCost() --船只制造费用
	local hero = mHeroManager.GetHero()
	-- if hero.vipLevel >= 9 then
		-- return 0.89
	-- end
	return 1-GetValue(hero.vipLevel, 8)/100
end

function ShipBuildSpeed() --船只建造速度
	local hero = mHeroManager.GetHero()
	-- if hero.vipLevel == 12 then
		-- return 2
	-- elseif hero.vipLevel == 13 then
		-- return 2
	-- elseif hero.vipLevel == 14 then
		-- return 2
	-- elseif hero.vipLevel == 15 then
		-- return 3
	-- end
	return GetValue(hero.vipLevel, 10)
end

function EquipUpProbability() --装备强化成功概率增加
	local hero = mHeroManager.GetHero()
	-- if hero.vipLevel == 15 then
		-- return 10
	-- end
	return GetValue(hero.vipLevel, 11)
end