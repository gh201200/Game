local _G,Screen,Language,GUI,ByteArray,print,Texture2D,Vector2,pairs,CFG_buildDesc,string = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,Vector2,pairs,CFG_buildDesc,string
local PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor,CFG_lib = 
PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor,CFG_lib
local SceneType,ConstValue,EventType,CFG_family = SceneType,ConstValue,EventType,CFG_family
local mAssetManager = nil
local mNetManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mFamilyManager = nil
local mGUIStyleManager = nil
local mMainPanel = nil
local mTavernPanel = nil
local mShopPanel = nil
local mShipyardPanel = nil
local mSystemTip = nil
local mHeroManager = nil
local mCommonlyFunc = nil
local mFamilyMemberPanel = nil
local mFamilyGoodsPanel = nil
local mFamilyRecordPanel = nil
local mFamilyApplyerPanel = nil
local mFamilyNoticePanel = nil
local mEventManager = nil
local mFamilyDonatePanel = nil
local mAlert = nil
local mItemSelectPanel = nil
local mItemManager = nil
local mItemCountSelectPanel = nil
local mFamilyListPanel = nil

module("LuaScript.View.Panel.Family.FamilyPanel")
local mPage = 1
local mNotice = nil
FullWindowPanel = true
function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mTavernPanel = require "LuaScript.View.Panel.Harbor.TavernPanel"
	mShopPanel = require "LuaScript.View.Panel.Harbor.ShopPanel"
	mShipyardPanel = require "LuaScript.View.Panel.Harbor.ShipyardPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mFamilyMemberPanel = require "LuaScript.View.Panel.Family.FamilyMemberPanel"
	mFamilyGoodsPanel = require "LuaScript.View.Panel.Family.FamilyGoodsPanel"
	mFamilyRecordPanel = require "LuaScript.View.Panel.Family.FamilyRecordPanel"
	mFamilyApplyerPanel = require "LuaScript.View.Panel.Family.FamilyApplyerPanel"
	mFamilyNoticePanel = require "LuaScript.View.Panel.Family.FamilyNoticePanel"
	mEventManager = require "LuaScript.Control.EventManager"
	mFamilyDonatePanel = require "LuaScript.View.Panel.Family.FamilyDonatePanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	mItemSelectPanel = require "LuaScript.View.Panel.Item.ItemSelectPanel"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mItemCountSelectPanel = require "LuaScript.View.Panel.Item.ItemCountSelectPanel"
	mFamilyListPanel = require "LuaScript.View.Panel.Family.FamilyListPanel"
	
	mEventManager.AddEventListen(nil, EventType.FamilyDel, FamilyDel)
	-- mEventManager.AddEventListen(nil, EventType.FamilyNotice, FamilyNotice)
	mFamilyMemberPanel.Init()
	mFamilyGoodsPanel.Init()
	-- mFamilyRecordPanel.Init()
	mFamilyApplyerPanel.Init()
	IsInit = true
end

function Display()
	mFamilyManager.RequestFamilyGoods()
	mFamilyManager.RequestFamilyMember()
	mFamilyManager.RequestFamilyApplyer()
	mNotice = mFamilyManager.GetNotice()
	
	mFamilyManager.ClearNewCount()
	-- mFamilyApplyerPanel.Display()
end

function Hide()
	mFamilyManager.StopFamilyGoods()
	mPage = 1
end

function SetPage(page)
	mPage = page
end

function OnGUI()
	if not IsInit then
		return
	end
	local familyInfo = mFamilyManager.GetFamilyInfo()
	if not familyInfo then
		return
	end
	
	local hero = mHeroManager.GetHero()
	if not hero.post or hero.post == 0 then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	
	
	local x = 664
	local width = 248
	if hero.post < 2 then
		x = x - 134
		width = width + 134
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(x,36.8,width,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	if mPage == 1 then
		GUI.Button(88.35,38.3,134,58, "成员", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(88.35,38.3,134,58, "成员", GUIStyleButton.PagBtn_1) then
		mPage = 1
	end
	
	if mPage == 2  then
		GUI.Button(232,38.3,134,58, "仓库", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(232,38.3,134,58, "仓库", GUIStyleButton.PagBtn_1) then
		mPage = 2
	end
	
	if mPage == 3  then
		GUI.Button(377,38.3,134,58, "日志", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(377,38.3,134,58, "日志", GUIStyleButton.PagBtn_1) then
		mPage = 3
		mFamilyManager.RequestLog()
		mFamilyRecordPanel.Display()
	end
	
	
	if hero.post >= 2 then
		if mPage == 4  then
			GUI.Button(522,38.3,134,58, "申请", GUIStyleButton.PagBtn_2)
		elseif GUI.Button(522,38.3,134,58, "申请", GUIStyleButton.PagBtn_1) then
			mPage = 4
		end
	end
	
	if GUI.Button(918,38.3,134,58, "联盟列表", GUIStyleButton.PagBtn_1) then
		mPanelManager.Show(mFamilyListPanel)
		mPanelManager.Hide(OnGUI)
	end
	
	-- GUI.BeginGroup(0, 70, 280, 700)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/family_1")
		GUI.DrawTexture(130.5,170.75,279,351,image,0,0,1,1,80,80,80,80)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
		GUI.DrawTexture(160.75,190.35,220,160,image,0,0,1,1,15,15,15,15)
		GUI.Label(200.05,133.95,124.2,0,"联盟公告", GUIStyleLabel.Center_30_Black)

		mNotice = mFamilyManager.GetNotice()
		if not mNotice or #mNotice == 0 then
			mNotice = Language[199]
		end
		GUI.Label(169,195,214.25,200,mNotice,GUIStyleLabel.Left_23_Brown_WordWrap)
		
		if hero.post >= 2 and GUI.Button(358,280,33,80,nil,GUIStyleButton.EditBtn) then
			mFamilyNoticePanel.SetData(mNotice)
			mPanelManager.Show(mFamilyNoticePanel)
		end
		
		
		local infoStr = mCommonlyFunc.BeginColor(Color.RedbeanStr)
		infoStr = infoStr .. "名称: "
		infoStr = infoStr .. mCommonlyFunc.EndColor()
		infoStr = infoStr .. mCommonlyFunc.BeginColor(Color.BlackStr)
		infoStr = infoStr .. familyInfo.name
		infoStr = infoStr ..  mCommonlyFunc.EndColor()
		GUI.Label(168,348,73.2,148.55,infoStr,GUIStyleLabel.Left_25_White)
		
		local infoStr = mCommonlyFunc.BeginColor(Color.RedbeanStr)
		infoStr = infoStr .. "等级: "
		infoStr = infoStr .. mCommonlyFunc.EndColor()
		infoStr = infoStr .. mCommonlyFunc.BeginColor(Color.BlackStr)
		infoStr = infoStr .. familyInfo.level
		infoStr = infoStr .. mCommonlyFunc.EndColor()
		GUI.Label(168,376,73.2,148.55,infoStr,GUIStyleLabel.Left_25_White)
		
		local infoStr = mCommonlyFunc.BeginColor(Color.RedbeanStr)
		infoStr = infoStr .. "人数: "
		infoStr = infoStr .. mCommonlyFunc.EndColor()
		infoStr = infoStr .. mCommonlyFunc.BeginColor(Color.BlackStr)
		infoStr = infoStr .. mFamilyManager.GetMemberCountInfo(familyInfo)
		infoStr = infoStr .. mCommonlyFunc.EndColor()
		GUI.Label(168,404,73.2,148.55,infoStr,GUIStyleLabel.Left_25_White)
		
		local infoStr = mCommonlyFunc.BeginColor(Color.RedbeanStr)
		infoStr = infoStr .. "资金: "
		infoStr = infoStr .. mCommonlyFunc.EndColor()
		infoStr = infoStr .. mCommonlyFunc.BeginColor(Color.BlackStr)
		infoStr = infoStr .. familyInfo.money .. "万"
		infoStr = infoStr .. mCommonlyFunc.EndColor()
		GUI.Label(168,431,73.2,148.55,infoStr,GUIStyleLabel.Left_25_White)
		
		if hero.contribute then
			local infoStr = mCommonlyFunc.BeginColor(Color.RedbeanStr)
			infoStr = infoStr .. "贡献: "
			infoStr = infoStr .. mCommonlyFunc.EndColor()
			infoStr = infoStr .. mCommonlyFunc.BeginColor(Color.BlackStr)
			infoStr = infoStr .. hero.contribute
			infoStr = infoStr .. mCommonlyFunc.EndColor()
			GUI.Label(168,458,73.2,148.55,infoStr,GUIStyleLabel.Left_25_White)
		end
		-- GUI.Label(10, 280, 100, 45, infoStr, GUIStyleLabel.Left_30_White, Color.Black)
		if GUI.Button(150,510,111,53,"捐钱", GUIStyleButton.ShortOrangeArtBtn) then
			RequestDonateMoney()
		end
		if GUI.Button(278,510,111,53,"捐物", GUIStyleButton.ShortOrangeArtBtn) then
			RequestDonateItem()
		end
		if GUI.Button(150,560,111,53,"升级", GUIStyleButton.ShortOrangeArtBtn) then
			RequestUp()
		end
		if GUI.Button(278,560,111,53,"退出", GUIStyleButton.ShortOrangeArtBtn) then
			RequestLeave()
		end
	-- GUI.EndGroup()
	
	if mPage == 1 then
		mFamilyMemberPanel.OnGUI()
	elseif mPage == 2 then
		mFamilyGoodsPanel.OnGUI()
	elseif mPage == 3 then
		mFamilyRecordPanel.OnGUI()
	elseif mPage == 4 then
		mFamilyApplyerPanel.OnGUI()
	end 
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
	end
end

function FamilyDel()
	mPanelManager.Show(mMainPanel)
	mPanelManager.Hide(OnGUI)
	mPanelManager.Hide(mItemSelectPanel)
	mSceneManager.SetMouseEvent(true)
end

-- function FamilyNotice()
	-- mNotice = mFamilyManager.GetNotice()
-- end

function RequestDonateMoney()
	mPanelManager.Show(mFamilyDonatePanel)
end

function RequestDonateItem()
	function selectFunc(item)
		-- print(item)
		mPanelManager.Show(OnGUI)
		RequestDonateItem2(item)
	end
	local mItems = mItemManager.GetCouldDonateItems()
	mItemSelectPanel.SetData(mItems, selectFunc)
	
	mPanelManager.Show(mItemSelectPanel)
	mPanelManager.Hide(OnGUI)
	
	mSystemTip.ShowTip("请选择需要捐献的物品", Color.LimeStr)
end


function RequestDonateItem2(item)
	if not item then
		return
	end
	function selectFunc(item, count)
		if item and count then
			mFamilyManager.RequestGiveItem(item.index, count)
		end
	end
	
	mItemCountSelectPanel.SetData(item, selectFunc)
	mPanelManager.Show(mItemCountSelectPanel)
end

function RequestExchange()
	print("RequestExchange")
	
end

function RequestUp()
	-- print("RequestUp")
	local hero = mHeroManager.GetHero()
	if hero.post < 2 then
		mSystemTip.ShowTip("只有盟主与副盟主才可进行该操作")
		return
	end
	
	local familyInfo = mFamilyManager.GetFamilyInfo()
	if familyInfo.level >= 20 then
		mSystemTip.ShowTip("联盟已达顶级")
		return
	end
	local cfg_family = CFG_family[familyInfo.level+1]
	if familyInfo.money < cfg_family.cost then
		mSystemTip.ShowTip("联盟资金不足,还需"..(cfg_family.cost-familyInfo.money).."万资金")
		return
	end
	mAlert.Show("升级联盟需要"..cfg_family.cost.."万资金,是否升级?", mFamilyManager.RequestUp)
	-- mFamilyManager.RequestUp()
end

function RequestLeave()
	-- print("RequestLeave")
	local hero = mHeroManager.GetHero()
	if hero.level >= 30 then
		mAlert.Show("退出联盟后贡献值将清零,12小时内不能加入联盟,是否确定退出?",mFamilyManager.RequestLeave)
	else
		mAlert.Show("退出联盟后贡献值将清零,是否确定退出?",mFamilyManager.RequestLeave)
	end
end

-- function RequestSaveNotice()
	-- mFamilyManager.RequestChangeNotice(mNotice)
-- end