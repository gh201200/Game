local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_item,CFG_EquipUp,CFG_gem,EventType,Event,UnityEventType = 
ConstValue,CFG_EquipSuit,CFG_item,CFG_EquipUp,CFG_gem,EventType,Event,UnityEventType
local AssetType,AppearEvent,CFG_soul,CFG_sailorGrade = AssetType,AppearEvent,CFG_soul,CFG_sailorGrade
local DrawItemCell,ItemType = DrawItemCell,ItemType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mSystemTip = nil
local mItemManager = require "LuaScript.Control.Data.ItemManager"
local mPanelManager = nil
local mEventManager = nil
local mSetManager = nil
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"
local mAlert = require "LuaScript.View.Alert.Alert"
local mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
module("LuaScript.View.Panel.Sailor.SailorUpPanel") -- 已经弃用
panelType = ConstValue.AlertPanel

local mSailor = nil
local mItemList = nil
local mUpStar = 0
local mUpExp = 0
local mUpMaxExp = 0

local mCouldUpStar = 0

local mOldProperty = {}
local mNewProperty = {}


function SetData(sailor)
	mSailor = sailor
	-- mChangeSailor = {
	mUpStar = sailor.star
	mUpExp = sailor.exp
	mItemList = {
		[28] = {count=0,maxCount=mItemManager.GetItemCountById(28),index=1},
		[29] = {count=0,maxCount=mItemManager.GetItemCountById(29),index=2},
		[30] = {count=0,maxCount=mItemManager.GetItemCountById(30),index=3},
		[31] = {count=0,maxCount=mItemManager.GetItemCountById(31),index=4}
	}
	RefreshSailorUp()
end

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	
	mEventManager.AddEventListen(nil, EventType.RefreshSailorUp, RefreshSailorUp)
	
	IsInit = true
end

function OnGUI()
	if not IsInit or not visible then
		return
	end
	
	if mSailor.star >= ConstValue.SailorMaxStar then
		mPanelManager.Hide(OnGUI)
		mSystemTip.ShowTip("已提升至最高等级")
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg23_1")
	GUI.DrawTexture(138,72,848,524,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg23_2")
	GUI.DrawTexture(260,306,617,215,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..mSailor.quality)
	GUI.DrawTexture(229,129,128,128,image)
	local image = mAssetManager.GetAsset("Texture/Character/Header/"..mSailor.resId, AssetType.Icon)
	GUI.DrawTexture(234,134,100,100,image)
	
	
	if mCouldUpStar >= ConstValue.SailorMaxStar then
		local key = mSailor.quality .. "_9"
		local cfg_sailorGrade = CFG_sailorGrade[key]
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/rechargeBg_4")
		GUI.DrawTexture(365,132,369,32,image)
		GUI.Label(528, 138, 32, 30, cfg_sailorGrade.exp.."/"..cfg_sailorGrade.exp, GUIStyleLabel.Center_25_Redbean)
	else
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/rechargeBg_4")
		local mProgress = mUpExp/mUpMaxExp
		GUI.DrawTexture(365,132,369*mProgress,32,image,0,0,mProgress,1)
		GUI.Label(528, 138, 32, 30, mUpExp.."/"..mUpMaxExp, GUIStyleLabel.Center_25_Redbean)
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/rechargeBg_3")
	GUI.DrawTexture(360,123,378,61,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
	GUI.DrawTexture(200,250,175,42,image)
	GUI.Label(200, 255, 175, 30, mSailor.name, GUIStyleLabel.Center_25_Redbean)
	
	if GUI.Button(736, 118, 166, 77, nil, GUIStyleButton.BlueBtn) then
		mSailorManager.RequestUp(mSailor.id, mItemList[28].count, mItemList[29].count, mItemList[30].count, mItemList[31].count)
		mItemList[28].maxCount = mItemList[28].maxCount - mItemList[28].count
		mItemList[29].maxCount = mItemList[29].maxCount - mItemList[29].count
		mItemList[30].maxCount = mItemList[30].maxCount - mItemList[30].count
		mItemList[31].maxCount = mItemList[31].maxCount - mItemList[31].count
		mItemList[28].count = 0
		mItemList[29].count = 0
		mItemList[30].count = 0
		mItemList[31].count = 0
	end
	
	if GUI.Button(840, 181, 49, 120, nil, GUIStyleButton.AutoSelect_1) then
		NextLevel()
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Text/sailorUp")
	GUI.DrawTexture(781,130,76,40,image)
	
	DrawItem(393+120*0, 193, 28)
	DrawItem(393+120*1, 193, 29)
	DrawItem(393+120*2, 193, 30)
	DrawItem(393+120*3, 193, 31)
	
	GUI.Label(318, 316, 84.2, 30, mCommonlyFunc.GetSailorStarInfo(mOldProperty.star), GUIStyleLabel.Left_30_White_Art,Color.Black)
	GUI.Label(318, 355, 84.2, 30, "攻击："..mOldProperty.attack, GUIStyleLabel.Left_20_Black)
	GUI.Label(318, 385, 84.2, 30, "防御："..mOldProperty.defense, GUIStyleLabel.Left_20_Black)
	GUI.Label(318, 415, 84.2, 30, "血量："..mOldProperty.hp, GUIStyleLabel.Left_20_Black)
	GUI.Label(318, 445, 84.2, 30, "贸易："..mOldProperty.business, GUIStyleLabel.Left_20_Black)
	GUI.Label(318, 475, 84.2, 30, "战斗力："..mOldProperty.power, GUIStyleLabel.Left_20_Black)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/dir_3")
	GUI.DrawTexture(508,376,109,72,image)
	
	GUI.Label(668, 316, 84.2, 30, mCommonlyFunc.GetSailorStarInfo(mNewProperty.star), GUIStyleLabel.Left_30_White_Art,Color.Black)
	GUI.Label(668, 355, 84.2, 30, "攻击："..mNewProperty.attack, GUIStyleLabel.Left_20_Black)
	GUI.Label(668, 385, 84.2, 30, "防御："..mNewProperty.defense, GUIStyleLabel.Left_20_Black)
	GUI.Label(668, 415, 84.2, 30, "血量："..mNewProperty.hp, GUIStyleLabel.Left_20_Black)
	GUI.Label(668, 445, 84.2, 30, "贸易："..mNewProperty.business, GUIStyleLabel.Left_20_Black)
	GUI.Label(668, 475, 84.2, 30, "战斗力："..mNewProperty.power, GUIStyleLabel.Left_20_Black)
	
	if GUI.Button(908, 58, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end

function NextLevel()
	if mCouldUpStar >= ConstValue.SailorMaxStar then
		mSystemTip.ShowTip("已提升至最高等级")
		return
	end
	
	local needExp = mUpMaxExp - mUpExp
	for i=1,4 do
		local cfg_soul = CFG_soul[i]
		local item = mItemList[cfg_soul.itemId]
		local count = math.min(math.ceil(needExp/cfg_soul.point), item.maxCount-item.count)
		item.count = item.count + count
		needExp = needExp - cfg_soul.point * count
		if needExp <= 0 then
			break
		end
	end
	RefreshSailorUp()
end

function RefreshSailorUp()
	-- print("RefreshSailorUp")
	mCouldUpStar = mSailor.star
	mUpStar = mSailor.star
	mUpExp = mSailor.exp
	mUpMaxExp = 100
	for k,item in pairs(mItemList) do
		if item.count > 0 then
			local cfg_soul = CFG_soul[item.index]
			mUpExp = mUpExp + cfg_soul.point * item.count
		end
	end
	
	for i = mSailor.star,ConstValue.SailorMaxStar-1 do
		local key = mSailor.quality .. "_" .. i
		local cfg_sailorGrade = CFG_sailorGrade[key]
		mUpMaxExp = cfg_sailorGrade.exp
		if cfg_sailorGrade.exp > mUpExp then
			break
		end
		mUpExp = mUpExp - cfg_sailorGrade.exp
		mCouldUpStar = cfg_sailorGrade.grade + 1
	end
	-- print(mUpExp)
	mUpStar = math.max(mCouldUpStar, mSailor.star+1)
	
	mOldProperty = {
		star = mSailor.star,
		power = mSailor.power,
		attack = mSailor.attack,
		defense = mSailor.defense,
		hp = mSailor.hp,
		business = mSailor.business,
	}
	
	local nextStar = math.min(10,mUpStar)
	mSailorManager.UpdateProperty(mSailor, false, nil, nextStar)
	mNewProperty = {
		star = nextStar,
		power = mSailor.power,
		attack = mSailor.attack,
		defense = mSailor.defense,
		hp = mSailor.hp,
		business = mSailor.business,
	}
	mSailorManager.UpdateProperty(mSailor)
	
	
	mItemList[28].maxCount=mItemManager.GetItemCountById(28)
	mItemList[29].maxCount=mItemManager.GetItemCountById(29)
	mItemList[30].maxCount=mItemManager.GetItemCountById(30)
	mItemList[31].maxCount=mItemManager.GetItemCountById(31)
end

function DrawItem(x, y, id)
	local cfg_item = CFG_item[id]
	local item = mItemList[id]
	-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
	if DrawItemCell(cfg_item, ItemType.Item, x, y,80,80) then
		if mCouldUpStar >= ConstValue.SailorMaxStar then
			mSystemTip.ShowTip("已提升至最高等级")
			return
		end
		if item.maxCount > item.count then
			item.count = item.count + 1
			RefreshSailorUp()
		else
			mSystemTip.ShowTip("精华数量不足")
		end
	end

	GUI.Label(x+35, y+50, 41, 29, item.maxCount-item.count, GUIStyleLabel.Right_25_White, Color.Black)
	GUI.Label(x, y+82, 80, 30, cfg_item.name, GUIStyleLabel.Center_20_Black)
end

-- function GetProbability(start)
	-- local levelModulus = 1 + (mSailor.level + star - 1) * 0.1
	-- local cfg_sailor = CFG_UniqueSailor[mSailor.index]
	-- local attack = cfg_sailor.attack * levelModulus
	-- local defense = cfg_sailor.defense * levelModulus
	-- local hp = cfg_sailor.hp	 * levelModulus
	-- local business = cfg_sailor.business * levelModulus
	-- local 
	-- return attack,defense,hp,business,
-- end