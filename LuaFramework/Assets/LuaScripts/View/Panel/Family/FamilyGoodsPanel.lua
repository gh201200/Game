local _G,Screen,Language,GUI,ByteArray,print,Texture2D,Vector2,pairs,CFG_buildDesc,os,ConstValue = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,Vector2,pairs,CFG_buildDesc,os,ConstValue
local AssetType,math,CFG_Equip,CFG_item = AssetType,math,CFG_Equip,CFG_item
local PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor,CFG_lab = 
PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor,CFG_lab
local DrawItemCell,ItemType = DrawItemCell,ItemType
local mAssetManager = nil
local mNetManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mGUIStyleManager = nil
local mFamilyManager = nil
local mMainPanel = nil
local mTavernPanel = nil
local mShopPanel = nil
local mShipyardPanel = nil
local mSystemTip = nil
local mHeroManager = nil
local mCommonlyFunc = nil
local mFamilyOperatePanel = nil
local mItemViewPanel = nil
local mFamilyExchangePanel = nil
local mAlert = nil
module("LuaScript.View.Panel.Family.FamilyGoodsPanel")
local mScrollPositionY = 0

-- local mGoodsList = {
	-- {index=1,id=1,type=0,count=99},
	-- {index=2,id=2,type=0,count=99},
	-- {index=3,id=3,type=0,count=99},
	-- {index=4,id=10101,type=1,count=99},
	-- {index=5,id=10102,type=1,count=99},
-- }


function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mTavernPanel = require "LuaScript.View.Panel.Harbor.TavernPanel"
	mShopPanel = require "LuaScript.View.Panel.Harbor.ShopPanel"
	mShipyardPanel = require "LuaScript.View.Panel.Harbor.ShipyardPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mFamilyOperatePanel = require "LuaScript.View.Panel.Family.FamilyOperatePanel"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	mFamilyExchangePanel = require "LuaScript.View.Panel.Family.FamilyExchangePanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end

	local spacing = 230
	local mGoodsList,count = mFamilyManager.GetGoods()
	if mGoodsList then
		local count = math.ceil(count/2)
		local k = 1
		_,mScrollPositionY = GUI.BeginScrollView(476, 150, 650, 2*spacing, 0,mScrollPositionY, 0, 0, 500, count*spacing)
			for _,goods in pairs(mGoodsList) do
				local x = (k-1)%2*260
				local y = (math.ceil(k/2)-1)*spacing
				local showY = y - mScrollPositionY / GUI.modulus
				if showY > -spacing and showY < 2*spacing then
					DrawGoods(x, y, goods)
				end
				k = k + 1
			end
			
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg23_2")
			if k < 3 then
				GUI.DrawTexture(260,0,215,217,image)
			end
			if k < 4 then
				GUI.DrawTexture(0,230,215,217,image)
			end
			if k < 5 then
				GUI.DrawTexture(260,230,215,217,image)
			end
		GUI.EndScrollView()
	end
end

function DrawGoods(x, y, goods)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg23_2")
	GUI.DrawTexture(x,y,215,217,image)

	local cfg_item = CFG_item[goods.id]
	local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
	if DrawItemCell(cfg_item, ItemType.Item, x+41,y+17,128,128) then
		-- mItemViewPanel.SetData(cfg_item.id)
		-- mPanelManager.Show(mItemViewPanel)
	end

	if goods.count > 1 then
		GUI.Label(x+114, y+110, 49, 29, goods.count, GUIStyleLabel.Right_30_White, Color.Black)
	elseif goods.count < 0 then
		GUI.Label(x+114, y+110, 49, 29, "无限", GUIStyleLabel.Right_30_White, Color.Black)
	end

	
	if GUI.Button(x+26, y+156, 73, 38, nil, GUIStyleButton.Exchange) then
		local count = GetMaxExchangeCount(goods)
		-- if count <= 0 then
			-- mSystemTip.ShowTip("贡献不足,无法兑换")
			-- return
		-- end
		mFamilyExchangePanel.SetData(goods.id, count)
		mPanelManager.Show(mFamilyExchangePanel)
	end
	
	if GUI.Button(x+112, y+156, 73, 38, nil, GUIStyleButton.Delect) then
		local hero = mHeroManager.GetHero()
		if hero.post < 2 then
			mSystemTip.ShowTip("只有盟主与副盟主才可进行该操作")
			return
		end
		if goods.id == 14 then
			mSystemTip.ShowTip("该物品不能删除")
			return
		end
		function OkFunc()
			mFamilyManager.RequestDeleteGoods(goods.id)
		end
		mAlert.Show("是否确定删除该物品？", OkFunc)
	end
end

function GetMaxExchangeCount(goods)
	local hero = mHeroManager.GetHero()
	local cfg_item = CFG_item[goods.id]
	local count = math.floor(hero.contribute/cfg_item.contribute)
	if goods.id == 14 then
		local familyInfo = mFamilyManager.GetFamilyInfo()
		return math.min(math.floor(count/10000)*10000, familyInfo.money*10000)
	else
		return math.min(goods.count, count)
	end
end