local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_copyMap,CFG_item = ConstValue,CFG_EquipSuit,CFG_copyMap,CFG_item
local AssetType,os,CFG_shipEquip,CFG_Enemy,SceneType,DrawItemCell = 
AssetType,os,CFG_shipEquip,CFG_Enemy,SceneType,DrawItemCell
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
local mBattleStarPanel = nil
local mShipEquipViewPanel = nil

module("LuaScript.View.Panel.Battle.BattleAwardPanel") -- boss奖励面板
panelType = ConstValue.AlertPanel

local mAward = nil
local mStartTime = 0
local mMouseEventState = nil

function SetData(award)
	mAward = award
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
	mBattleStarPanel = require "LuaScript.View.Panel.Battle.BattleStarPanel"
	mShipEquipViewPanel = require "LuaScript.View.Panel.Equip.ShipEquipViewPanel"
	IsInit = true
end

function Hide()
	if not mAward.eid then
		mBattleFieldManager.RequestLeave()
		mSceneManager.SetMouseEvent(mMouseEventState)
	end
	mSceneManager.SetMouseEvent(true)
end

function Display()
	mStartTime = os.oldClock
	mMouseEventState = mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false)
end

function IsVisible()
	return visible and not mBattleSuccessTip.visible and not mBattleStarPanel.visible
end

function OnGUI()
	if not IsInit then
		return
	end
	
	if mBattleSuccessTip.visible then
		return
	end
	if mBattleStarPanel.visible then
		return
	end
	
	local hero = mHeroManager.GetHero()
	if not mAward.eid and hero.SceneType == SceneType.Battle then
		mOverTime = 32 - os.oldClock + mStartTime
		if mOverTime <= 0 then
			mPanelManager.Hide(OnGUI)
			return
		end
	end
	
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/alertBg")
	GUI.DrawTexture(285,146,560,341,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Text/battleWin")
	GUI.DrawTexture(498, 173, 133, 40, image)
	
	
	-- GUI.Label(268, 222, 240.45, 30, cfg_copyMap.desc, GUIStyleLabel.Left_25_Black_WordWrap)
	-- GUI.Label(336, 218, 191.7, 30, "获得奖励:", GUIStyleLabel.Left_25_Black)
	
	GUI.Label(388, 250, 191.7, 30, "银两:"..mAward.money, GUIStyleLabel.Left_25_Black)
	GUI.Label(568, 250, 191.7, 30, "经验:"..mAward.exp, GUIStyleLabel.Left_25_Black)
	if mAward.eid then
		local cfg_Enemy = CFG_Enemy[mAward.eid]
		GUI.Label(606, 409, 184, 30, "BOSS:"..cfg_Enemy.name.."奖励", GUIStyleLabel.Right_25_Yellow, Color.Black)
	elseif hero.SceneType == SceneType.Battle then
		GUI.Label(606, 409, 184, 30, math.floor(mOverTime).."秒后自动退出战场", GUIStyleLabel.Right_25_Yellow, Color.Black)
	end
	
	local spacing = 90
	-- for k,award in pairs(mAward.items) do
		-- local x = spacing * (k - 1) + 360
		-- DrawAward(award, x, 286)
	-- end
	
	-- if (#(mAward.items)) > 4 then
	    mScrollPositionX,_ = GUI.BeginScrollView(360-10,286-10,420,100, mScrollPositionX,0, -15, -10,(#(mAward.items)) * spacing ,0) 	
		for k,award in pairs(mAward.items) do
		local x = spacing * (k - 1)
		DrawAward(award, x, 0)
		end
		GUI.EndScrollView()
	-- end
	if GUI.Button(768, 126, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end

function DrawAward(award, x, y)
	if not award then
		return 
	end
	
	DrawItemCell(award,award.type,x,y, 70, 70)
end

