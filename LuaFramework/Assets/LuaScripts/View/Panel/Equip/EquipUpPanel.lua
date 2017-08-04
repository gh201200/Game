local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_item,CFG_EquipUp,CFG_gem,EventType,Event,UnityEventType,platform,IPhonePlayer  = 
ConstValue,CFG_EquipSuit,CFG_item,CFG_EquipUp,CFG_gem,EventType,Event,UnityEventType,platform,IPhonePlayer
local AssetType,AppearEvent,IosTestScript = AssetType,AppearEvent,IosTestScript
local DrawItemCell,ItemType = DrawItemCell,ItemType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mSystemTip = nil
local mItemManager = nil
local mPanelManager = nil
local mEventManager = nil
local mSetManager = nil
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"
local mAlert = require "LuaScript.View.Alert.Alert"
local mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
local mVipManager = nil
local mLabManager = nil
local mEquipMagicPanel = nil

module("LuaScript.View.Panel.Equip.EquipUpPanel")
panelType = ConstValue.AlertPanel

local mEquip = nil
local mCount = 0
local mMaxCount = 0
local mCostTip = nil
local mViewMaxLevel = nil
mSelectGemId = 3

function SetData(equip)
	mEquip = equip
end

function Init()
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mVipManager = require "LuaScript.Control.Data.VipManager"
	mLabManager = require "LuaScript.Control.Data.LabManager"
	mEquipMagicPanel = require "LuaScript.View.Panel.Equip.EquipMagicPanel"
	IsInit = true
	
	mEventManager = require "LuaScript.Control.EventManager"
	mEventManager.AddEventListen(nil, EventType.RefreshEquipUp, RefreshEquipUp)
end

function Hide()
	mEquip = nil
	mSelectGemId = 3
	mCount = 0
	mMaxCount = 0
end

function Display()
	if mSelectGemId ~= 0 then
		RefreshEquipUp()
	end
	mCostTip = mSetManager.GetCostTip()
end

function OnGUI()
	if not IsInit or not visible then
		return
	end
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg46_1")
	-- GUI.DrawTexture(276,36,217,51,image)
	-- if GUI.Button(291, 51, 86, 41,"强化", GUIStyleButton.ShortOrangeBtn_4) then
		
	-- end
	-- if GUI.Button(382, 51, 86, 41,"附魔", GUIStyleButton.ShortOrangeBtn_3) then
		-- local hero = mHeroManager.GetHero()
		-- if hero.level < 30 then
			-- mSystemTip.ShowTip("30级开放附魔功能")
			-- return
		-- end
		-- mEquipMagicPanel.SetData(mEquip)
		-- mPanelManager.Show(mEquipMagicPanel)
		-- mPanelManager.Hide(OnGUI)
	-- end
	
	
	
	local cfg_Equip = CFG_Equip[mEquip.id]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg31_1")
	GUI.DrawTexture(238,81,671,478,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..cfg_Equip.quality)
	GUI.DrawTexture(342,191,128,128, image)
	local image = mAssetManager.GetAsset("Texture/Icon/Equip/"..cfg_Equip.icon, AssetType.Icon)
	GUI.DrawTexture(347,196,100, 100, image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(530,142,295,160,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
	GUI.DrawTexture(276,128,246,59,image)
	
	local cfg_Equip = CFG_Equip[mEquip.id]
	GUI.Label(326, 131, 139, 30, cfg_Equip.name, GUIStyleLabel.Center_45_Brown_Art, Color.Black)
	
	GUI.Label(625-40, 158, 104.2, 30, "当前", GUIStyleLabel.Left_25_DeepBlue_Art)
	GUI.Label(740-40, 158, 104.2, 30, "下级", GUIStyleLabel.Left_25_DeepBlue_Art)
	-- GUI.Label(818-50, 158, 104.2, 30, "最高", GUIStyleLabel.Left_25_DeepBlue_Art)
	
	
	local infostr = Language[45] .. mEquip.star
	GUI.Label(545, 190, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	local property = mCommonlyFunc.GetEquipProperty(mEquip)
	local infostr = CFG_property[cfg_Equip.propertyId].type .. ": " .. property
	GUI.Label(545, 231, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	local infostr = "战力: " .. mCommonlyFunc.GetEquipPower(mEquip)
	GUI.Label(545, 275, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg12_1")
	GUI.DrawTexture(660,195,38,16,image)
	GUI.DrawTexture(660,235,38,16,image)
	GUI.DrawTexture(660,278,38,16,image)
	
	local hero = mHeroManager.GetHero()
	local maxLevel = hero.level
	-- GUI.Label(825-85, 190, 104, 30, maxLevel, GUIStyleLabel.Center_20_Cyan, Color.Black)
	-- local property = mCommonlyFunc.GetEquipProperty(mEquip, maxLevel)
	-- GUI.Label(825-85, 231, 104, 30, property, GUIStyleLabel.Center_20_Cyan, Color.Black)
	-- local infostr = mCommonlyFunc.GetEquipPower(mEquip, maxLevel)
	-- GUI.Label(825-85, 275, 104, 30, infostr, GUIStyleLabel.Center_20_Cyan, Color.Black)
	
	local nextLevel = mEquip.star + 1
	GUI.Label(761-90, 190, 104.2, 30, nextLevel, GUIStyleLabel.Center_20_Black)
	local property = mCommonlyFunc.GetEquipProperty(mEquip, nextLevel)
	GUI.Label(761-90, 231, 104.2, 30, property, GUIStyleLabel.Center_20_Black)
	local infostr = mCommonlyFunc.GetEquipPower(mEquip, nextLevel)
	GUI.Label(761-90, 275, 104.2, 30, infostr, GUIStyleLabel.Center_20_Black)
	
	
	-- if mSelectGemId == 0 then
		-- GUI.Label(341.4, 305, 104.2, 30, "选择强化石:", GUIStyleLabel.Left_30_Brown_Art)
		
		-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
		-- GUI.DrawTexture(340,335,491,111,image,0,0,1,1,20,20,20,20)
		
		-- local cfg_item = CFG_item[1]
		-- if DrawItemCell(cfg_item, ItemType.Item, 375,345,70,70,true,false,false) then
			-- mSelectGemId = 1
			-- mMaxCount = GetMaxCount()
			-- mCount = mMaxCount
			
			-- AppearEvent(nil, EventType.OnRefreshGuide)
		-- end
		-- GUI.Label(366.5, 416, 84.2, 30, cfg_item.name, GUIStyleLabel.Center_20_Black)
		
		-- local cfg_item = CFG_item[2]
		-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
		-- if DrawItemCell(cfg_item, ItemType.Item, 548,345,70,70,true,false,false) then
			-- mSelectGemId =2
			-- mMaxCount = GetMaxCount()
			-- mCount = mMaxCount
		-- end
		-- GUI.Label(539.9, 416, 84.2, 30, cfg_item.name, GUIStyleLabel.Center_20_Black)
		
		-- local cfg_item = CFG_item[3]
		-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
		-- if DrawItemCell(cfg_item, ItemType.Item, 707.05,345,70,70,true,false,false) then
			-- mSelectGemId = 3
			-- mMaxCount = GetMaxCount()
			-- mCount = mMaxCount
		-- end
		-- GUI.Label(698.9, 416, 84.2, 30, cfg_item.name, GUIStyleLabel.Center_20_Black)
		
		-- GUI.Label(360, 465, 44.2, 30, "装备强化等级越高分解可获得强化石越多", GUIStyleLabel.Left_25_Lime, Color.Black)
	-- else
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
		GUI.DrawTexture(340,335,491,111,image,0,0,1,1,20,20,20,20)
		
		local cfg_item = CFG_item[mSelectGemId]
		-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
		-- GUI.DrawTexture(375,345,70,70,image,0,0,1,1,6,6,6,6)
		DrawItemCell(cfg_item, ItemType.Item, 375,345,70,70,false)
		GUI.Label(366.5, 416, 84.2, 30, cfg_item.name, GUIStyleLabel.Center_20_Black)
		GUI.Label(395, 386, 44.2, 30, math.floor(mCount), GUIStyleLabel.Right_25_White, Color.Black)
		
		local gemCount = mItemManager.GetItemCountById(mSelectGemId)
		--ios test script
		if IosTestScript then
			mMaxCount = math.min(gemCount, mMaxCount)
		end
		
		
		if mEquip.star >= maxLevel then
			GUI.Label(530, 347, 59.2, 30, "强化等级已达上限\n请先提升人物等级", GUIStyleLabel.Left_30_Brown_Art)
		else
			mCount = GUI.HorizontalSlider(638, 383, 175, 27, mCount, 0, mMaxCount, GUIStyleButton.HorizontalScrollBg,GUIStyleButton.HorizontalThumb)
			
			GUI.Label(535, 348, 134.2, 30,"成功几率："..GetProbability().."%", GUIStyleLabel.Left_20_Black)
			GUI.Label(535, 382.5, 134.2, 30,"调整数量：", GUIStyleLabel.Left_20_Black)
			GUI.Label(535, 417, 134.2, 30,"拥有数量："..gemCount, GUIStyleLabel.Left_20_Black)
		end
		
		if GUI.Button(650, 444, 111, 60, nil, GUIStyleButton.CancelBtn) then
			-- mSelectGemId = 0
			mPanelManager.Hide(OnGUI)
		end
		
		if GUI.Button(390, 444, 111, 60, nil, GUIStyleButton.EquipUpBtn) then
			if mEquip.star >= maxLevel then
				mSystemTip.ShowTip("强化等级已达上限")
				return
			end
			if GetProbability() == 0 then
				mSystemTip.ShowTip("当前成功几率过低,请调整数量")
				return
			end
			local cost = (math.floor(mCount) - gemCount) * cfg_item.price
			if gemCount >= math.floor(mCount) or not mCostTip then
				if not mCommonlyFunc.HaveGold(cost) then
					return
				end
				mEquipManager.RequestUp(mEquip.index, mSelectGemId, math.floor(mCount), mEquip.star)
			else
				function okFunc(showTip)
					if not mCommonlyFunc.HaveGold(cost) then
						return
					end
					mEquipManager.RequestUp(mEquip.index, mSelectGemId, math.floor(mCount), mEquip.star)
					mCostTip = not showTip
				end
				local cfg_gem = CFG_gem[mSelectGemId]
				local cfg_item = CFG_item[mSelectGemId]
				mSelectAlert.Show("是否花费"..cost.."元宝补足"..cfg_item.name.."？", okFunc)
			end
		end
	-- end
	
	if GUI.Button(834, 62, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end

function SetSelectGem(id)
	mSelectGemId = id
end

function RefreshEquipUp()
	if not visible then
		return
	end
	local cfg_Equip = CFG_Equip[mEquip.id]
	if not mEquip then
		return
	end
	
	if mSelectGemId == 0 then
		return
	end
	mMaxCount = GetMaxCount()
	mCount = mMaxCount
end

function GetMaxCount()
	local cfg_Equip = CFG_Equip[mEquip.id]
	if not mEquip then
		return 100
	end
	
	local cfg_Equip = CFG_Equip[mEquip.id]
	local probability = mVipManager.EquipUpProbability() + mLabManager.EquipUpProbability()
	local cfg_EquipUp = CFG_EquipUp[mEquip.star+1]
	local cfg_gem = CFG_gem[mSelectGemId]
	local count = math.ceil(cfg_EquipUp.needPoint / (cfg_gem.point * (1+probability/100)))
	
	--ios test script
	if IosTestScript then
		local gemCount = mItemManager.GetItemCountById(mSelectGemId)
		count = math.min(gemCount, count)
	end
	return count
end

function GetProbability()
	local cfg_Equip = CFG_Equip[mEquip.id]
	local probabilityPer = mVipManager.EquipUpProbability() + mLabManager.EquipUpProbability()
	local cfg_EquipUp = CFG_EquipUp[mEquip.star+1]
	local cfg_gem = CFG_gem[mSelectGemId]
	local probability = math.floor(cfg_gem.point * math.floor(mCount) * 100 / cfg_EquipUp.needPoint*(1+probabilityPer/100))
	return math.min(probability, 100)
end