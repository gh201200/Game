local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_item,CFG_shipEquip = ConstValue,CFG_EquipSuit,CFG_item,CFG_shipEquip
local AssetType,CFG_package,table,CFG_UniqueSailor,DrawItemCell = AssetType,CFG_package,table,CFG_UniqueSailor,DrawItemCell
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipDestroyPanel = nil
local mEquipSelectPanel = nil
local CFG_bossAward,CFG_Enemy = CFG_bossAward,CFG_Enemy -- boss奖励
local CFG_box = CFG_box -- 宝箱、食人鱼奖励内容
local CFG_treasureAward = CFG_treasureAward -- 藏宝图奖励内容
local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mPanelManager = nil
local mEquipViewPanel = nil
local mItemViewPanel = nil
local mShipEquipViewPanel = nil
local mSailorViewPanel = nil
local IsDebug,CsPrint = IsDebug,CsPrint
local mItemManager = require "LuaScript.Control.Data.ItemManager"
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"

module("LuaScript.View.Panel.BossList.AwardViewPanel") -- 奖励内容预览面板
panelType = ConstValue.AlertPanel
notAutoClose = true

local mCouldUse = false
local mAwardList = nil
local mScrollPositionY = 0
local TargetId = nil
--0是怪物，1是宝箱、食人鱼，2是藏宝图
local mAwardType = 0 --奖励类型，根据传进的类型，读取不同类型的奖励库

function SetData(AwardType,ItemId)
	mAwardType = AwardType
	TargetId = ItemId
	mAwardList = ParseAward(AwardType,ItemId)
	table.sort(mAwardList,AwardSort)
	mScrollPositionY = 0
end

function AwardSort(a,b)
	return  a.raffle < b.raffle
end

function SetmCouldUse(couldUse)
    if	not couldUse then
	    couldUse = false
	end
	mCouldUse = couldUse
end

function ParseAward(AwardType,ItemId)

    local mAwardLists = {}
    if	AwardType == 0 then -- boss奖励库
		for k,cfg_item in pairs(CFG_bossAward) do
			if cfg_item.enemyId == ItemId then			
				table.insert(mAwardLists, {id=cfg_item.awardId,type=cfg_item.type,count=cfg_item.count,quality = mquality,raffle=cfg_item.probability})
			end
		end
	elseif AwardType == 1 then -- 宝箱。食人鱼奖励库
	    local userBoxId = CFG_item[ItemId].boxId
		for k,cfg_item in pairs(CFG_box) do
			if cfg_item.itemId == userBoxId then
				table.insert(mAwardLists, {id=cfg_item.awardId,type=cfg_item.type,count=cfg_item.count,quality = mquality,raffle=cfg_item.probability})
			end
		end
	elseif AwardType == 2 then -- 藏宝图奖励库
		local userTreasure = CFG_item[ItemId].quality
		for k,cfg_item in pairs(CFG_treasureAward) do
			if cfg_item.quality == userTreasure then
				table.insert(mAwardLists, {id=cfg_item.awardId,type=cfg_item.type,count=cfg_item.count,quality = mquality,raffle=cfg_item.probability})
			end
		end
	end
	return mAwardLists
end

function GetQuality(ItemType,Id)
   if ItemType == 0 then -- 物品
		quality = CFG_item[Id].quality
   elseif ItemType == 1 then -- 装备
		quality = CFG_Equip[Id].quality
		-- print(quality)
   elseif ItemType == 2 then -- 船装
		quality = CFG_shipEquip[Id].quality
   elseif ItemType == 5 then -- 船员
		quality = CFG_UniqueSailor[Id].quality
   end	
   return quality
end

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipDestroyPanel = require "LuaScript.View.Panel.Equip.EquipDestroyPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	mShipEquipViewPanel = require "LuaScript.View.Panel.Equip.ShipEquipViewPanel"
	mSailorViewPanel = require "LuaScript.View.Panel.Sailor.SailorViewPanel"
	-- mCouldUse = false
	IsInit = true
end

function Hide() 
    mCouldUse = false
end

function OnGUI()

	if not IsInit then
		return
	end
	if not mAwardList[1] then
		mPanelManager.Hide(OnGUI)
		return
	end
	
	local cfg_item = nil
	if	mAwardType == 0 then -- boss奖励
		cfg_item = CFG_Enemy[TargetId]
	elseif mAwardType == 1 then -- 宝箱，食人鱼
		cfg_item = CFG_item[TargetId]
	elseif mAwardType == 2 then -- 藏宝图
		cfg_item = CFG_item[TargetId]
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg23_1")
	GUI.DrawTexture(146+16,68-16,848,524,image)
	-- local image = mAssetManager.GetAsset("Texture/Gui/Text/packageView")
	-- GUI.DrawTexture(428+16,120-16,118,34,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg28_2")
	GUI.DrawTexture(240+16,150-16,674,32,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg28_1")
	GUI.DrawTexture(240+16,469-16,674,32,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
	GUI.DrawTexture(460,114-16,220,45,image)
	
	GUI.Label(476, 120-16, 184, 30, cfg_item.name, GUIStyleLabel.Center_30_LightBlue_Art,Color.Black)
	
	local ScrollHight = 288
	local DownTipY = 446
	if mCouldUse then
	   ScrollHight = 260
	   DownTipY = 430-16
	end
	
	local spacingX = 315
	local spacingY = 115
	local count = #mAwardList
	_,mScrollPositionY = GUI.BeginScrollView(262, 186-32, 640, ScrollHight, 0, mScrollPositionY, 0-16, 0-16, 600, 50+spacingY * math.ceil(count/2)-10)
		for k,award in pairs(mAwardList) do
			local x = (k - 1) % 2 * spacingX
			local y = math.floor((k - 1) / 2) * spacingY
			DrawAward(award, x, y)
		end
	GUI.EndScrollView()
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn19_1")
	GUI.DrawTexture(540,DownTipY,59,16,image)
	
	
	if mCouldUse then
		if GUI.Button(446+16, 450-16, 223, 78,"使用", GUIStyleButton.OrangeBtn) then
			local item = mItemManager.GetItemById(TargetId)
			mItemManager.UseItem(item)
			mPanelManager.Hide(OnGUI)
			if cfg_item.name == '藏宝图' then
			   mPanelManager.Show(require "LuaScript.View.Panel.SeekTreasure.SeekTreasurePanel")
			end
		end
	else
		-- if GUI.Button(446+16, 450-16, 223, 78,"确定", GUIStyleButton.OrangeBtn) then
			-- mPanelManager.Hide(OnGUI)
		-- end
	end
	
	if GUI.Button(911+16, 58-16, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end


function DrawAward(award, x, y)
	if not award then
		return 
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(x+55,y+6,240,88,image)
	
	if DrawItemCell(award,award.type,x, y,100,100,true,false)  then
		
	end
	
	if award.type == 1 then -- 名字
		local cfg_equip = CFG_Equip[award.id]
		GUI.Label(116+x, 14+y, 154, 30, cfg_equip.name, GUIStyleLabel.Center_25_Brown_Art)
	elseif award.type == 2 then
		local cfg_equip = CFG_shipEquip[award.id]
		GUI.Label(116+x, 14+y, 154, 30, cfg_equip.name, GUIStyleLabel.Center_25_Brown_Art)
	elseif award.type == 0 then
		local cfg_item = CFG_item[award.id]
		GUI.Label(116+x, 14+y, 154, 30, cfg_item.name, GUIStyleLabel.Center_25_Brown_Art)
	elseif award.type == 5 then
		local cfg_sailor = CFG_UniqueSailor[award.id]
		GUI.Label(116+x, 14+y, 154, 30, cfg_sailor.name, GUIStyleLabel.Center_25_Brown_Art)
	end
	GUI.Label(116+x, 54+y, 154, 29, "数量×"..award.count, GUIStyleLabel.Center_25_DeepBlue_Art)
	
	if not IsDebug then
	   return
	end
	local content = "???"
	local raffle = (award.raffle/100)
	
	if raffle == 100 then
		content = "必得"
	elseif raffle > 76 and raffle < 100 then	
		content = "极高"
	elseif raffle > 60 and raffle <= 76 then	
		content = "较高"
	elseif raffle > 50 and raffle <= 60 then	
		content = "高"
	elseif raffle > 30 and raffle <= 50 then	
		content = "中"
	elseif raffle > 10 and raffle <= 30 then	
		content = "较低"
	elseif raffle > 0.08 and raffle <= 10 then	
		content = "低"
	elseif raffle > 0 and raffle <= 0.08 then	
		content = "极低"
	end
		
	if IsDebug then
		content = raffle .. "%"
	end
	GUI.Label(116+x, 80+y, 154, 29, "获得概率："..content, GUIStyleLabel.Center_25_DeepBlue_Art)
end
