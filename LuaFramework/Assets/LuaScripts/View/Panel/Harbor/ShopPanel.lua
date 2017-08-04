
local _G,Screen,Language,GUI,ByteArray,print,Texture2D,CFG_harbor,CFG_product,pairs,CFG_ship,os = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,CFG_harbor,CFG_product,pairs,CFG_ship,os
local PackatHead,Packat_Account,Packat_Player,require,CFG_buildDesc,PackatHead,Packat_Harbor = 
PackatHead,Packat_Account,Packat_Player,require,CFG_buildDesc,PackatHead,Packat_Harbor
local ConstValue,GUIStyleButton,math,table = ConstValue,GUIStyleButton,math,table
local GUIStyleLabel,Color,Input,KeyCode = GUIStyleLabel,Color,Input,KeyCode
local AssetType = AssetType
local mHeroManager = nil
local mHarborManager = nil
local mPanelManager = nil
local mCharManager = nil
local mMainPanel = nil
local mShopBuyPanel = nil
local mAssetManager = nil
local mGoodsManager = nil
local mCommonlyFunc = nil
local mNetManager = nil
local mShipManager = nil
local mSystemTip = nil
local mVerifyAlert = nil
local mSailorPanel = nil
local mAlert = nil

module("LuaScript.View.Panel.Harbor.ShopPanel") -- 购买物资的交易界面

-- local mSelectProductId = nil
local mSelectShipId = 1
local mLastHarborId = -1
local mGoodsList = nil

local mScrollPositionX = 0

FullWindowPanel = true

function Display()
	local hero = mHeroManager.GetHero()
	if mLastHarborId ~= hero.harborId then
		mGoodsManager.RequesGoodPrice()
	end
	mLastHarborId = hero.harborId
	
	mGoodsList = {}
	local cfg_harbor = CFG_harbor[hero.harborId]
	for i=1,5 do
		if cfg_harbor["product"..i] > 0 then
			table.insert(mGoodsList,cfg_harbor["product"..i])
		end
	end
	table.sort(mGoodsList, sortFunc)
end

function CleanPrice()
	mLastHarborId = -1
end

function sortFunc(a,b)
	local product1 = CFG_product[a]
	local product2 = CFG_product[b]
	if product1.totalTrade < product2.totalTrade then
		return true
	elseif product1.totalTrade > product2.totalTrade then
		return false
	end
	
	return product1.price < product2.price
end

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mShopBuyPanel = require "LuaScript.View.Panel.Harbor.ShopBuyPanel"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mGoodsManager = require "LuaScript.Control.Data.GoodsManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mShipManager = require "LuaScript.Control.Data.ShipManager"
	mVerifyAlert = require "LuaScript.View.Alert.VerifyAlert"
	mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	-- print(mAssetManager)
	IsInit = true
end

function Hide()
	mSelectShipId = 1
end

function OnGUI()	
	local hero = mHeroManager.GetHero()
	if not hero.harborId then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(83.5,37.5,1016.75-50,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	GUI.Label(525.5,48,84.2,30,Language[18], GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	
	
	GUI.Label(157.1,137,144.2,30,"港口特产", GUIStyleLabel.Left_35_Redbean_Art)
	local harborsList = mHarborManager.GetHarborInfoList()
	local harborInfo = harborsList[hero.harborId]
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(144.5,182.2,851.5,164.9,image,0,0,1,1,15,15,15,15)
	GUI.Label(160.5,308.8,79.2,30,"价格: ", GUIStyleLabel.Left_25_Black)
	
	local cfg_harbor = CFG_harbor[hero.harborId]
	local spacing = 145
	for k,v in pairs(mGoodsList) do
		DrawProduct(230+(k-1)*spacing, 188.8, v)
	end	
	
	local ships = mShipManager.GetShips()
	if ships[1] and ships[1].duty == 1 then
		if mSelectShipId == 1  then
			GUI.Button(195.5, 367.4, 88, 32, "一号船", GUIStyleButton.ShipBtn_2)
		elseif GUI.Button(195.5, 367.4, 88, 32, "一号船", GUIStyleButton.ShipBtn_1) then
			mSelectShipId = 1
		end
	end
	if ships[2] and ships[2].duty == 2 then
		if mSelectShipId == 2  then
			GUI.Button(293.5, 367.4, 88, 32, "二号船", GUIStyleButton.ShipBtn_2)
		elseif GUI.Button(293.5, 367.4, 88, 32, "二号船", GUIStyleButton.ShipBtn_1) then
			mSelectShipId = 2
		end
	end
	if ships[3] and ships[3].duty == 3 then
		if mSelectShipId == 3 then
			GUI.Button(391.5, 367.4, 88, 32, "三号船", GUIStyleButton.ShipBtn_2)
		elseif GUI.Button(391.5, 367.4, 88, 32, "三号船", GUIStyleButton.ShipBtn_1) then
			mSelectShipId = 3
		end
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(144.5,399.4,851.5,180.65,image,0,0,1,1,15,15,15,15)
	GUI.Label(160.5,511.2,79.2,30,Language[107], GUIStyleLabel.Left_25_Black)
	GUI.Label(160.5,543.9,79.2,30,Language[106], GUIStyleLabel.Left_25_Black)
	
	local goodsList = mGoodsManager.GetGoodsList()
	local ship = ships[mSelectShipId]
	local cfgShip = CFG_ship[ship.bid]
	
	local spacing = 145
	mScrollPositionX,_ = GUI.BeginScrollView(230, 408, 670, 200, mScrollPositionX, 0, 0, 0, spacing * ship.store - 50, 180)
		for i=1,ship.store do
			local good = goodsList[mSelectShipId][i]
			DrawGoods(i*spacing-spacing, 0, i, good)
		end
	GUI.EndScrollView()
	
	if GUI.Button(920.5,435.05,50,95,nil, GUIStyleButton.SellAllBtn) then
		if NeedShowVerify() then 
			mVerifyAlert.Show(mGoodsManager.RequestSellAllGoods)
		else
			mGoodsManager.RequestSellAllGoods()
		end
	end

	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
	end
end

local mCount = math.random(5)-1
local mLastTime = 0
function NeedShowVerify()
	local hero = mHeroManager.GetHero()
	if hero.level < 30 then
		return
	end
	
	local goodsList = mGoodsManager.GetGoodsList()
	if not goodsList[1] or not goodsList[1][1] or goodsList[1][1] == 0 then
		return
	end
	
	local product = CFG_product[goodsList[1][1]]
	if mGoodsManager.GetPopularType() == product.type then
		return
	end
	
	if mCount > 0 then
		mCount = mCount - 1
		return
	end
	if os.oldTime - mLastTime < 60 then
		return
	end
	
	local hit = math.random() > 0.6
	if hit then
		mLastTime = os.oldTime
		mCount = 10
	end
	return hit
end

function GetGoodsPosition(id)
	local hero = mHeroManager.GetHero()
	local cfg_harbor = CFG_harbor[hero.harborId]
	for i=1,5,1 do
		if mGoodsList[i] == id then
			return 236 + 145 * (i - 1)
		end
	end
	return 0
end

-- function GetEmptyStoreCount()
	-- local hero = mHeroManager.GetHero()
	-- local store = ShipEmptyStoreCount(1)
	-- store = store + ShipEmptyStoreCount(2)
	-- store = store + ShipEmptyStoreCount(3)
	-- return store
-- end

-- function GetMaxBuyCount(prouceId)
	-- local hero = mHeroManager.GetHero()
	-- local store = GetEmptyStoreCount()
	-- local product = CFG_product[prouceId]
	-- local count = math.floor(hero.money/product.price)
	-- return math.min(store, count)
-- end

-- function ShipEmptyStoreCount(index)
	-- local ships = mShipManager.GetShips()
	-- local ship = ships[index]
	-- if ship and ship.duty == index then
		-- local store = 0
		-- local goodsList = mGoodsManager.GetGoodsList()
		-- local goods = goodsList[index]
		-- local cfgShip = CFG_ship[ship.bid]
		-- for k=1,ship.store,1 do
			-- if not goods or not goods[k] or goods[k] == 0 then
				-- store = store + 1
			-- end
		-- end
		-- return store
	-- else
		-- return 0
	-- end
-- end

function DrawProduct(x, y, prouceId)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/productSlot")
	GUI.DrawTexture(x+7,y+35,80,80,image)
	
	local hero = mHeroManager.GetHero()
	local product = CFG_product[prouceId]
	if product.totalTrade <= hero.business then
		local image = mAssetManager.GetAsset("Texture/Icon/Product/"..product.icon, AssetType.Icon)
		GUI.DrawTexture(x+11,y+39,72,72,image)
		
		if mGoodsManager.GetPopularType() == product.type then
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg42_1")
			GUI.DrawTexture(x-4,y+24,128,128,image)
		end
	else
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg18_1")
		GUI.DrawTexture(x+11.5,y+41,71,68,image)
	end
	
	if GUI.TextureButton(x+15,y+43,64,64,nil) then
		if product.totalTrade > hero.business then
			-- mSystemTip.ShowTip(product.totalTrade.."点总贸易解锁该特产")
			-- mSystemTip.ShowTip("当前总贸易为" .. hero.business, Color.LimeStr)
			function okFunc()
				mPanelManager.Hide(OnGUI)
				mPanelManager.Show(mSailorPanel)
			end
			local str = "该特产需<color=red>"..product.totalTrade.."</color>点贸易值,当前总贸易为<color=red>"..hero.business.."</color>,上阵<color=lime>高贸易值船员</color>以解锁该特产,是否调整船员？"
			mAlert.Show(str, okFunc)
			return
		end
		if mGoodsManager.GetEmptyStoreCount() <= 0 then
			mSystemTip.ShowTip("船舱已满,请先卖出货物")
			return
		end
		
		local maxCount = mGoodsManager.GetMaxBuyCount(prouceId)
		mShopBuyPanel.SetData(prouceId,maxCount)
		mPanelManager.Show(mShopBuyPanel)
	end
	
	GUI.Label(x + 19, y, 54, 25, product.name, GUIStyleLabel.Center_25_Black)
	GUI.Label(x + 18, y + 120, 54.2, 25, product.price, GUIStyleLabel.Center_25_Black)
end

function DrawGoods(x, y, pos, prouceId)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/productSlot")
	GUI.DrawTexture(x+7,y+28,80,80,image)
	if prouceId == 0 then
		GUI.Label(x+19, y, 54, 45, "无货物", GUIStyleLabel.Center_25_Black)
		GUI.Label(x+18, y +107, 54.2, 45, "0", GUIStyleLabel.Center_25_Black)
		GUI.Label(x+18, y + 138, 54.2, 45, "0", GUIStyleLabel.Center_25_Black)
	else
		local goodsPriceList = mGoodsManager.GetGoodsPriceList()
		local price = goodsPriceList[prouceId]
		local product = CFG_product[prouceId]
		local image = mAssetManager.GetAsset("Texture/Icon/Product/"..product.icon, AssetType.Icon)
		if GUI.TextureButton(x+11,y+32,72,72,image) then
			-- print("sell")
			mGoodsManager.RequestSellGoods(mSelectShipId-1, pos-1)
		end
		if mGoodsManager.GetPopularType() == product.type then
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg42_1")
			GUI.DrawTexture(x-4,y+17,128,128,image)
		end
		
		local hero = mHeroManager.GetHero()
		local cfg_harbor = CFG_harbor[hero.harborId]
		if cfg_harbor.love ~= product.type then
			GUI.Label(x+19, y, 54, 45, product.name, GUIStyleLabel.Center_25_White, Color.Black)
		else
			local str = product.name
			str = str .. mCommonlyFunc.BeginColor(Color.LimeStr)
			str = str .. "(喜)"
			str = str .. mCommonlyFunc.EndColor()
			GUI.Label(x+19, y+5, 54, 45, str, GUIStyleLabel.Center_20_White, Color.Black)
		end
		GUI.Label(x+18, y +107, 54.2, 45, product.price, GUIStyleLabel.Center_25_Black)
		if not price then
			mGoodsManager.RequesGoodPrice()
		end
		if not price or product.price > price then
			GUI.Label(x+18, y + 138, 54.2, 45, price, GUIStyleLabel.Center_25_Red,Color.Black)
		else
			GUI.Label(x+18, y + 138, 54.2, 45, price, GUIStyleLabel.Center_25_Green,Color.Black)
		end
	end
end