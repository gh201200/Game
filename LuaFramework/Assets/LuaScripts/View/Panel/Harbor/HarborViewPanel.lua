local GUI,RunLuaScript,Language,_G,os,print,Application,KeyCode,Input,Event,UnityEventType,Vector2,SceneType,require,EventType = 
GUI,RunLuaScript,Language,_G,os,print,Application,KeyCode,Input,Event,UnityEventType,Vector2,SceneType,require,EventType
local pairs,ConstValue,Directory,GUIStyleButton,GUIStyleTextField,Color,GUIStyleLabel,string,CFG_item = 
pairs,ConstValue,Directory,GUIStyleButton,GUIStyleTextField,Color,GUIStyleLabel,string,CFG_item
local CFG_productType,CFG_product,CFG_harbor,CharacterType,CFG_harborItemCount = 
CFG_productType,CFG_product,CFG_harbor,CharacterType,CFG_harborItemCount
local AssetType = AssetType
local DrawItemCell,ItemType = DrawItemCell,ItemType
local mPanelManager = require "LuaScript.Control.PanelManager"
local mAlertManager = require "LuaScript.View.Alert.Alert"
local mTimer = require "LuaScript.Common.Timer"
local mChatManager = require "LuaScript.Control.Data.ChatManager"
local mEventManager = nil
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHeroManager = nil
local mMainPanel = nil
local mSceneManager = nil
local mSystemTip = nil
local mItemManager = nil
local mHarborManager = nil
local mAlert = nil
local mItemViewPanel = nil
module("LuaScript.View.Panel.Harbor.HarborViewPanel") -- 点击港口小图标后出现的详细信息  
panelType = ConstValue.AlertPanel
local mHarborId = nil
local mHarborLevel = nil
local mShopLevel = nil
local switch = false
local mMouseEventState = nil
function Init()
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mAlert = require "LuaScript.View.Alert.Alert"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	IsInit = true
end

function Hide()
	mSceneManager.SetMouseEvent(mMouseEventState) -- 关闭响应海面
	switch = false
end

function Display()
	mMouseEventState = mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false)
	switch = true
end

function SetData(harborId,harborLevel,shopLevel)
	mHarborId = harborId
	mHarborLevel = harborLevel
	mShopLevel = shopLevel
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg2_2")
	GUI.DrawTexture(188,75,795,497,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Text/harborInfo")
	GUI.DrawTexture(514,108,133,37,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(271,156,636.05,122.85,image,0,0,1,1,20,20,20,20)
	
	
	local cfg_harbor = CFG_harbor[mHarborId]
	local CFG_productType = CFG_productType[cfg_harbor.love]
	local level = mHarborLevel or mHarborManager.GetHarborLevel(mHarborId)
	local shopLevel = mShopLevel or mHarborManager.GetShopLevel(mHarborId)
	local masterName = mHarborManager.GetHarborMasterName(mHarborId)
	local power = mCommonlyFunc.GetHarborPower(level)
	
	GUI.Label(310,165,124,50, "名称: ",GUIStyleLabel.Left_25_Brown_Art)
	GUI.Label(680,165,124,50, "等级: ",GUIStyleLabel.Left_25_Brown_Art)
	GUI.Label(310,200,124,50, "领主: ",GUIStyleLabel.Left_25_Brown_Art)
	GUI.Label(680,200,124,50, "喜好: ",GUIStyleLabel.Left_25_Brown_Art)
	GUI.Label(310,235,124,50, "战力: ",GUIStyleLabel.Left_25_Brown_Art)
	
	GUI.Label(310+65,165,124,50, cfg_harbor.name, GUIStyleLabel.Left_25_Black) 
	GUI.Label(680+65,165,124,50, level.."级", GUIStyleLabel.Left_25_Black) 
	GUI.Label(310+65,200,124,50, masterName, GUIStyleLabel.Left_25_Black) 
	GUI.Label(680+65,200,124,50, CFG_productType.type, GUIStyleLabel.Left_25_Black) 
	GUI.Label(310+65,235,124,50, power, GUIStyleLabel.Left_25_Black)
	
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg34_1")
	GUI.DrawTexture(242,350,672,134,image)
	GUI.Label(277,307,124,50, "每日产出:", GUIStyleLabel.Left_30_Brown_Art) 
	GUI.Label(410,314,124,50, "(联盟占领港口的产量为个人的5倍)", GUIStyleLabel.Left_20_Brown) 
	
	local cfg_award = CFG_harborItemCount[cfg_harbor.type .. "_" .. level]
	local money = (shopLevel*shopLevel*50 + 1000) * 24
	
	DrawAward(14, money, 370, 366)
	if cfg_award then
		DrawAward(cfg_award.itemId, cfg_award.count, 643, 366)
	end
	
	if GUI.Button(898,68,77,63, nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end


function DrawAward(id, count, x, y)
	local image = mAssetManager.GetAsset("Texture/GUI/Bg/bg4_1")
	GUI.DrawTexture(x+15,y+6,240,88,image)
	
	local cfg_item = CFG_item[id]   --占领港口的产出
	-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
	if DrawItemCell(cfg_item, ItemType.Item, x, y,100,100) then
		-- mItemViewPanel.SetData(cfg_item.id)
		-- mPanelManager.Show(mItemViewPanel)
	end

	GUI.Label(100+x, 54+y, 154, 29, "数量×"..mCommonlyFunc.GetShortNumber(count), GUIStyleLabel.Center_25_DeepBlue_Art)
	GUI.Label(100+x, 14+y, 154, 30, cfg_item.name, GUIStyleLabel.Center_30_Brown_Art)
end