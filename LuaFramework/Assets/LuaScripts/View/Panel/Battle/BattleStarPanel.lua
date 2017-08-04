local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_copyMap,CFG_item = ConstValue,CFG_EquipSuit,CFG_copyMap,CFG_item
local AssetType,os,CFG_shipEquip,CFG_Enemy,SceneType = 
AssetType,os,CFG_shipEquip,CFG_Enemy,SceneType
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
local mCopyMapManager = nil
local mCopyMapCleanPanel = nil
local mCopyMapPanel = nil
local mItemViewPanel = nil
local mAlert = nil
local mSelectAlert = nil
local mSetManager = nil
local mSystemTip = nil
local mShipManager = nil
local mBattleFieldManager = nil
local mEquipManager = nil
local mItemManager = nil
local mEquipViewPanel = nil
local mBattleSuccessTip = nil
local mShipEquipViewPanel = nil
local mBattleAwardPanel = nil

module("LuaScript.View.Panel.Battle.BattleStarPanel") -- 血战战斗界面
panelType = ConstValue.AlertPanel

local mStartTime = 0
local mStar = nil
local mType = nil


function SetData(star, type)
	mStar = star
	mType = type
end

function Init()
	mAlert = require "LuaScript.View.Alert.Alert"
	mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mShipManager = require "LuaScript.Control.Data.ShipManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipDestroyPanel = require "LuaScript.View.Panel.Equip.EquipDestroyPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mCopyMapManager = require "LuaScript.Control.Data.CopyMapManager"
	mCopyMapCleanPanel = require "LuaScript.View.Panel.CopyMap.CopyMapCleanPanel"
	mCopyMapPanel = require "LuaScript.View.Panel.CopyMap.CopyMapPanel"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mEquipManager = require "LuaScript.Control.Data.EquipManager"
	mBattleFieldManager = require "LuaScript.Control.Data.BattleFieldManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	mBattleSuccessTip = require "LuaScript.View.Tip.BattleSuccessTip"
	mShipEquipViewPanel = require "LuaScript.View.Panel.Equip.ShipEquipViewPanel"
	mBattleAwardPanel = require "LuaScript.View.Panel.Battle.BattleAwardPanel"
	IsInit = true
end

function Hide()
	if not mBattleAwardPanel.visible then
		mBattleFieldManager.RequestLeave()
	end
end

function Display()
	mStartTime = os.oldClock
	mSceneManager.SetMouseEvent(false)
end

function IsVisible()
	return visible and not mBattleSuccessTip.visible
end

function OnGUI()
	if not IsInit then
		return
	end
	
	if mBattleSuccessTip.visible then
		return
	end
	
	local hero = mHeroManager.GetHero()
	if hero.SceneType == SceneType.Battle then
		mOverTime = 25 - os.oldClock + mStartTime
		if mOverTime <= 0 then
			mPanelManager.Hide(OnGUI)
			return
		end
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/alertBg")
	GUI.DrawTexture(285,146,560,341,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Text/battleWin")
	GUI.DrawTexture(498, 173, 133, 40, image)
	
	GUI.Label(345, 242, 191.7, 30, "评价:", GUIStyleLabel.Left_30_DeepBlue_Art)
	GUI.Label(345, 285, 191.7, 30, "倍率:", GUIStyleLabel.Left_30_DeepBlue_Art)
	GUI.Label(345, 330, 191.7, 30, "最终星数:", GUIStyleLabel.Left_30_DeepBlue_Art)
	
	GUI.Label(425, 288, 191.7, 30, mCommonlyFunc.GetNumberToChn(mType).."倍", GUIStyleLabel.Left_25_Redbean)
	GUI.Label(485, 333, 191.7, 30, mStar.."×"..mType, GUIStyleLabel.Left_25_Redbean)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/star_3")
	GUI.DrawTexture(420, 230, 40*3, 40, image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/star_1")
	GUI.DrawTexture(535, 321, 40, 40, image)
	
	if GUI.Button(480, 372, 166, 77, "确定", GUIStyleButton.BlueBtn) then
		mPanelManager.Hide(OnGUI)
	end
	
	if GUI.Button(768, 126, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end

