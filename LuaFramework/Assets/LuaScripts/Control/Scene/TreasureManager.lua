local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray = print,Instantiate,EventType,Space,math,os,Vector3,ByteArray
local PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue = PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue
local GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,CsSetPosition,AssetType,CsSet3DText = 
GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,CsSetPosition,AssetType,CsSet3DText
local Rect,Color,GetTransform,CsSetActive,GetRenderer,CsSetMaterial,CsSetParent,CsFindType,GetComponentInChildren = 
Rect,Color,GetTransform,CsSetActive,GetRenderer,CsSetMaterial,CsSetParent,CsFindType,GetComponentInChildren
local CsSet3DTextDepth,CsAnimationPlay,Packat_Item,string,Animation,Destroy,AnimationType = 
CsSet3DTextDepth,CsAnimationPlay,Packat_Item,string,Animation,Destroy,AnimationType
local mEventManager = require "LuaScript.Control.EventManager"
local mNetManager = require "LuaScript.Control.System.NetManager"
local mAssetManager = require "LuaScript.Control.AssetManager"
module("LuaScript.Control.Scene.TreasureManager") --Treasure藏宝图数据管理
local mTreasure = nil
local mCsTreasure = nil
local mHeroManager = nil
local mTimer = nil
local mItemManager = nil
local mTreasureTip = nil
local mSystemTip = nil

function Init()
	mTimer = require "LuaScript.Common.Timer"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mTreasureTip = require "LuaScript.View.Tip.TreasureTip"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mNetManager.AddListen(PackatHead.ITEM, Packat_Item.SEND_TREASURE_MAP_RLT, SEND_TREASURE_MAP_RLT)
	
	mEventManager.AddEventListen(nil, EventType.OnLoadComplete, Update)
end

function getTreasure()
	return mTreasure
end

function SEND_TREASURE_MAP_RLT(cs_ByteArray)
	local type = ByteArray.ReadByte(cs_ByteArray)
	local x = ByteArray.ReadInt(cs_ByteArray)
	local y = ByteArray.ReadInt(cs_ByteArray)
	
	if type == 0 then
		if mCsTreasure then
			Destroy(mCsTreasure)
			mEventManager.RemoveAllEveListen(mCsTreasure)
		end
		
		mTreasure = nil
		mCsTreasure = nil
		
		-- mTreasureTip.HideTip()
	else
		-- print(mTreasure)
		mTreasure = {type=type,x=x,y=y}
		Update()
		
		-- mSystemTip.ShowTip("征服之海("..x.." "..y..")出现神秘宝藏", Color.LimeStr)
		-- mTreasureTip.ShowTip(x,y)
	end
end

function Update()
	local hero = mHeroManager.GetHero()
	if hero.map ~= 0 then -- 当玩家不在征服之海的时候，销毁宝箱
		if mCsTreasure then
			Destroy(mCsTreasure)
			mEventManager.RemoveAllEveListen(mCsTreasure)
			mCsTreasure = nil
		end
		return
	end
	
	if not mTreasure then
		return
	end
	
	if mCsTreasure then
		return
	end
	 -- 
	local csAsset = mAssetManager.GetAsset(string.format(ConstValue.ResTreasurePath,mTreasure.type), AssetType.Forever)
	mCsTreasure = Instantiate(csAsset)
	CsSetPosition(GetTransform(mCsTreasure), mTreasure.x, 0, mTreasure.y)
	
	mEventManager.AddEventListen(mCsTreasure, EventType.OnAnimationOver, OnAnimationOver)
	mEventManager.AddEventListen(mCsTreasure, EventType.OnMouseDown, OnMouseDown)
end

function OnMouseDown(csTreasure)
	local hero = mHeroManager.GetHero()
	
	mHeroManager.SetTarget(ConstValue.TreasureType, true)
	mHeroManager.Goto(hero.map, mTreasure.x, mTreasure.y)
end

function OpenTreasure()
	local animation = GetComponentInChildren(mCsTreasure, Animation.GetType())
	CsAnimationPlay(animation, AnimationType.Open)
	mTimer.SetTimeout(OnAnimationOver, 2)
	
	mEventManager.RemoveEventListen(mCsTreasure, EventType.OnMouseDown, OnMouseDown)
end


function OnAnimationOver(csTreasure)
	-- Destroy(mCsTreasure)
	
	mItemManager.OpenTreasure()
end