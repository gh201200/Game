local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_item,CFG_EquipUp,CFG_gem,EventType,Event,UnityEventType,platform,IPhonePlayer = 
ConstValue,CFG_EquipSuit,CFG_item,CFG_EquipUp,CFG_gem,EventType,Event,UnityEventType,platform,IPhonePlayer
local AssetType,AppearEvent,CFG_magic,IosTestScript = AssetType,AppearEvent,CFG_magic,IosTestScript
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
module("LuaScript.View.Panel.Equip.EquipMagicPanel") -- 装备附魔界面，新版本去掉这一功能
panelType = ConstValue.AlertPanel

local mEquip = {id = 10101,index = 1}
local mCostTip = nil
local mInfoStr = "装备附魔需消耗附魔石,附魔后可随机获得一项属性."


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
	IsInit = true
	
	-- mEventManager = require "LuaScript.Control.EventManager"
	-- mEventManager.AddEventListen(nil, EventType.RefreshEquipUp, RefreshEquipUp)
end

function Hide()
	mEquip = nil
end

function Display()
	mCostTip = mSetManager.GetCostTip()
end

function OnGUI()
	if not IsInit or not visible then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg46_1")
	GUI.DrawTexture(276,36,217,51,image)
	if GUI.Button(291, 51, 86, 41,"强化", GUIStyleButton.ShortOrangeBtn_3) then
		mEquipUpPanel.SetData(mEquip)
		mPanelManager.Show(mEquipUpPanel)
		mPanelManager.Hide(OnGUI)
	end
	if GUI.Button(382, 51, 86, 41,"附魔", GUIStyleButton.ShortOrangeBtn_4) then
		
	end
	
	local cfg_Equip = CFG_Equip[mEquip.id]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg31_1")
	GUI.DrawTexture(238,81,671,478,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..cfg_Equip.quality)
	GUI.DrawTexture(342,191,128,128, image)
	local image = mAssetManager.GetAsset("Texture/Icon/Equip/"..cfg_Equip.icon, AssetType.Icon)
	GUI.DrawTexture(347,196,100, 100, image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(530,142,295,160,image)
	GUI.Label(552, 155, 274, 30, mInfoStr, GUIStyleLabel.Left_25_Black_Art_WordWrap)
	
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
	GUI.DrawTexture(276,128,246,59,image)
	local cfg_Equip = CFG_Equip[mEquip.id]
	GUI.Label(326, 131, 139, 30, cfg_Equip.name, GUIStyleLabel.Center_45_Brown_Art, Color.Black)
	
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(340,335,491,111,image,0,0,1,1,20,20,20,20)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/dir_3")
	GUI.DrawTexture(478,346,109,72,image)
	
	GUI.Label(341.4, 305, 104.2, 30, "附魔:", GUIStyleLabel.Left_30_Brown_Art)
	local cfg_magic = CFG_magic[mEquip.magic]
	if cfg_magic then
		GUI.Label(636, 355, 59.2, 30, Language[129], GUIStyleLabel.Left_20_Black)
		local infostr = mCommonlyFunc.GetQualityStr(cfg_magic.quality)
		GUI.Label(690, 345, 63, 30, infostr, GUIStyleLabel.Center_30_White_Art, Color.Black)
		
		local infostr = CFG_property[cfg_magic.type].type .. ": " .. cfg_magic.value .. CFG_property[cfg_magic.type].sign
		GUI.Label(636, 395, 104.2, 30, infostr, GUIStyleLabel.Left_20_Black)
	else
		GUI.Label(636, 367, 59.2, 30, "未附魔", GUIStyleLabel.Left_30_Brown_Art)
	end
	
	local cfg_item = CFG_item[146]
	-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
	-- GUI.DrawTexture(375,345,70,70,image,0,0,1,1,6,6,6,6)
	DrawItemCell(cfg_item, ItemType.Item,375,345,70,70)
	local count = mItemManager.GetItemCountById(146)
	GUI.Label(366.5, 416, 84.2, 30, cfg_item.name, GUIStyleLabel.Center_20_Black)
	GUI.Label(395, 386, 44.2, 30, count, GUIStyleLabel.Right_25_White, Color.Black)
	
	if GUI.Button(390, 444, 111, 60, nil, GUIStyleButton.CancelBtn) then
		mPanelManager.Hide(OnGUI)
	end
	
	if GUI.Button(650, 444, 111, 60, nil, GUIStyleButton.MagicBtn) then
		if count <= 0 and not mCostTip then
			if not mCommonlyFunc.HaveGold(cfg_item.price) then
				return
			end
			RequestMagic(mEquip)
		elseif count <= 0 then
			--ios test script
			if IosTestScript then
				mSystemTip.ShowTip(cfg_item.name.."不足,无法附魔")
				return
			end
			function okFunc(showTip)
				if not mCommonlyFunc.HaveGold(cfg_item.price) then
					return
				end
				RequestMagic(mEquip)
				mCostTip = not showTip
			end
			mSelectAlert.Show("是否花费"..cfg_item.price.."元宝购买"..cfg_item.name.."？", okFunc)
		else
			RequestMagic(mEquip)
		end
	end
	
	if GUI.Button(834, 62, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
		-- print("guanbi")
	end
end

function RequestMagic(mEquip)
	local cfg_magic = CFG_magic[mEquip.magic]
	if cfg_magic and cfg_magic.quality == 3 and CFG_Equip[mEquip.id].quality < 4 then
		function okFunc()
			mEquipManager.RequestMagic(mEquip.index)
		end
		mAlert.Show("当前附魔属性臻至完美,是否继续刷新?",okFunc)
	elseif cfg_magic and cfg_magic.quality == 4 then
		function okFunc()
			mEquipManager.RequestMagic(mEquip.index)
		end
		mAlert.Show("当前附魔属性达到史诗,是否继续刷新?",okFunc)
	else
		mEquipManager.RequestMagic(mEquip.index)
	end
end