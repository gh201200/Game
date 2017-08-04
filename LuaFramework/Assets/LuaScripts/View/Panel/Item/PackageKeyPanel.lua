local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_item = ConstValue,CFG_EquipSuit,CFG_item
local AssetType,CFG_package,table,GUIStyleTextField,string = 
AssetType,CFG_package,table,GUIStyleTextField,string
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipDestroyPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mPanelManager = nil
local mEquipViewPanel = nil
local mItemViewPanel = nil
local mItemManager = nil
local mSystemTip = nil
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"

module("LuaScript.View.Panel.Item.PackageKeyPanel") -- 礼包码兑换
panelType = ConstValue.AlertPanel
local mKey = ""

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
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	IsInit = true
end

function Hide()
	mKey = ""
end

function OnGUI()
	if not IsInit then
		return
	end

	local image = mAssetManager.GetAsset("Texture/Gui/Bg/alertBg")
	GUI.DrawTexture(296,154,560,341,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Text/key")
	GUI.DrawTexture(442,186,253,34,image)
	
	
	GUI.Label(368, 244, 254, 30, "请输入要兑换的礼包序列号", GUIStyleLabel.Left_25_Brown)

	local mNewKey = GUI.TextArea(396,282,356,78, mKey, GUIStyleTextField.Left_30_White)
	if string.len(mNewKey) <= 10 then
		mKey = mNewKey
	end
	

	if GUI.Button(384, 376, 166, 77,"确定", GUIStyleButton.BlueBtn) then
		mPanelManager.Hide(OnGUI)
		if string.len(mKey) <= 0 then
			
		else
			mItemManager.RequestUsePackageKey(mKey)
			-- mSystemTip.ShowTip("该序列号无效")
		end
	end
	if GUI.Button(598, 376, 166, 77,"取消", GUIStyleButton.BlueBtn) then
		mPanelManager.Hide(OnGUI)
	end
	
	if GUI.Button(791, 138, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end
