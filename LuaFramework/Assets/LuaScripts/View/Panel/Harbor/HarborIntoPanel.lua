local GUI,RunLuaScript,Language,_G,os,print,Application,KeyCode,Input,Event,UnityEventType,Vector2,SceneType,require,EventType = 
GUI,RunLuaScript,Language,_G,os,print,Application,KeyCode,Input,Event,UnityEventType,Vector2,SceneType,require,EventType
local pairs,ConstValue,Directory,GUIStyleButton,GUIStyleTextField,Color,GUIStyleLabel,string,CFG_item = 
pairs,ConstValue,Directory,GUIStyleButton,GUIStyleTextField,Color,GUIStyleLabel,string,CFG_item
local CFG_productType,CFG_product,CFG_harbor,CharacterType,platform,IPhonePlayer,ActivityType = 
CFG_productType,CFG_product,CFG_harbor,CharacterType,platform,IPhonePlayer,ActivityType
local AssetType,IosTestScript = AssetType,IosTestScript
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
local mActivityManager = nil
local mActivityPanel = nil
module("LuaScript.View.Panel.Harbor.HarborIntoPanel") -- 港口详情界面,点击场景中的港口出现的信息窗
panelType = ConstValue.AlertPanel
mHarborId = nil
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
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	mActivityPanel = require "LuaScript.View.Panel.Activity.ActivityPanel"
	IsInit = true
end

function Hide()
	mSceneManager.SetMouseEvent(mMouseEventState)
end

function Display()
	mMouseEventState = mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false)
end

function SetData(harborId)
	mHarborId = harborId
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
	local level = mHarborManager.GetHarborLevel(mHarborId)
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
	
	
	GUI.Label(271,288,124,50, "特产:", GUIStyleLabel.Left_25_Brown_Art) 
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(271,326,636.05,122.85,image,0,0,1,1,20,20,20,20)
	
	DrawProduct(cfg_harbor.product1, 314, 338)
	DrawProduct(cfg_harbor.product2, 433, 338)
	DrawProduct(cfg_harbor.product3, 547, 338)
	DrawProduct(cfg_harbor.product4, 664, 338)
	DrawProduct(cfg_harbor.product5, 779, 338)
	
	if GUI.Button(358,453,166,77, "进入", GUIStyleButton.BlueBtn) then
		mHarborManager.RequestIntoHarbor(mHarborId)
		mPanelManager.Hide(OnGUI)
	end
	local hero = mHeroManager.GetHero()
	-- ios test script
	if IosTestScript and hero.map == 0 then
		if GUI.Button(638,453,166,77, "关闭", GUIStyleButton.BlueBtn) then
			mPanelManager.Hide(OnGUI)
		end
	else
		if GUI.Button(638,453,166,77, "争夺", GUIStyleButton.BlueBtn) then
			-- mSystemTip.ShowTip("测试版本不开放该功能")
			
			if cfg_harbor.mapId == 0 then
				function GotoActivityPanel()
					mMouseEventState = false
					mPanelManager.Hide(OnGUI)
					mPanelManager.Show(mActivityPanel)
					mActivityPanel.SetData(ActivityType.HarborBattle)
				end
				
				local activity = mActivityManager.GetActivity(ActivityType.HarborBattle)
				if not activity.state then
					mAlert.Show("港口战未开启,是否查看活动详情？", GotoActivityPanel)
					return
				end
				
				if activity.state1 then
					mAlert.Show("请先竞拍该港口争夺权，是否前往竞拍？", GotoActivityPanel)
					return
				end
			end
			
			mHeroManager.RequestAttack(CharacterType.Harbor, cfg_harbor.id)
			mPanelManager.Hide(OnGUI)
		end
	end
	
	if GUI.Button(898,68,77,63, nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end

function DrawProduct(productId, x, y)
	local product = CFG_product[productId]
	if not product then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/productSlot")
	GUI.DrawTexture(x,y,80,80,image)
	local image = mAssetManager.GetAsset("Texture/Icon/Product/"..product.icon, AssetType.Icon)
	GUI.DrawTexture(x+3,y+3,72,72,image)
	GUI.Label(x, y+82, 75, 28, product.name, GUIStyleLabel.Center_25_Black)
end