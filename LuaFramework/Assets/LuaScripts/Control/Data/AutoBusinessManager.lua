local io,table,math,tonumber,pairs,EventType,require,print = io,table,math,tonumber,pairs,EventType,require,print
local CFG_product,CFG_harbor = CFG_product,CFG_harbor
local mSystem = nil
local mHeroManger = nil
local mGoodsManager = nil
local mHarborManager = nil
local mEventManager = nil
local mAutoBusinessTip = nil
local mPanelManager = nil
local mShopPanel = nil
local mTimer = nil
local mPathList = {{{harborId=211,goodsId=246,nextHarborId=212},{harborId=212,goodsId=247,nextHarborId=211}}}
local mNowIndex = nil
local mPathId = nil
local mOutTimer = nil


module("LuaScript.Control.Data.AutoBusinessManager")

function init()
	mSystem = require "LuaScript.View.Tip.SystemTip"
	mGoodsManager = require "LuaScript.Control.Data.GoodsManager"
	mHeroManger = require "LuaScript.Control.Scene.HeroManager"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mAutoBusinessTip = require "LuaScript.View.Tip.AutoBusinessTip"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mTimer = require "LuaScript.Common.Timer"
	mShopPanel = require "LuaScript.View.Panel.Harbor.ShopPanel"
	
	mEventManager.AddEventListen(nil, EventType.IntoHarbor, intoHarbor)
	mEventManager.AddEventListen(nil, EventType.SellAllGoods, sellAllGoods)
end


function LoadPath()
	mPathList = {}
	local file = io.open("AutoBusiness", "r")
	if file then
		local l = file:read("*line")
		local index = 1
		while l do
			mPathList[index] = mPathList[index] or {}
			if l ~= "end" then
				local value = tonumber(l)
				local point = {}
				point.harborId=math.floor(value/1000000)
				point.goodsId=math.floor(value/1000)%10000
				point.nextHarborId=value%10000
				table.insert(mPathList[index], point)
			else
				index = index + 1
				mPathList[index] = {}
			end
			l = file:read("*line")
		end
		f:close()
	end
end

function SavePath()
	local file = io.open("AutoBusiness", "w")
	if file then
		for _,path in pairs(mPathList) do
			for _,point in pairs(path) do
				file:write(point.harborId*1000000 .. point.goodsId* 1000 .. point.nextHarborId)
			end
			file:write("end")
		end
		file:close()
	end
end

function intoHarbor()
	if not mPathId then
		return
	end
	
	-- print(hero)
	mOutTimer = mTimer.SetTimeout(intoShopPanel, 2)
	mAutoBusinessTip.SetData("正在进入交易所...")
end

function intoShopPanel()
	mPanelManager.Show(mShopPanel)
	mOutTimer = mTimer.SetTimeout(sellAllGoodsTF, 2)
	mAutoBusinessTip.SetData("正在出售特产...")
end

function sellAllGoodsTF()
	local hero = mHeroManger.GetHero()
	local nextPoint = getNextPoint()
	
	local cfg_product = CFG_product[nextPoint.goodsId]
	mAutoBusinessTip.SetData("正在购买特产["..cfg_product.name.."]...")
	if hero.harborId == nextPoint.harborId then
		mGoodsManager.RequestSellAllGoods()
	end
end

function sellAllGoods()
	if not mPathId then
		return
	end
	
	mOutTimer = mTimer.SetTimeout(bugAllGoodsTF, 2)
end

function bugAllGoodsTF()
	local nextPoint = getNextPoint()
	local count = mGoodsManager.GetMaxBuyCount(nextPoint.goodsId)
	mGoodsManager.RequestBuyGoods(nextPoint.goodsId, count)
	
	mNowIndex = mNowIndex + 1
	
	gotoNextHarbor()
end

function StarAutoBusiness(index)
	if mNowIndex then
		StopAutoBusiness()
	end
	mPathId = index
	if not mPathList[mPathId] then
		return
	end
	if not CheckBusiness() then
		mPathId = nil
		return mSystem.ShowTip("贸易值不够，无法购买此航线上的所有特产")
	end
	
	mAutoBusinessTip.ShowTip()
	
	local mGoodsId = mGoodsManager.GetMainId()
	-- print(mGoodsId)
	mNowIndex = getStarIndex(mGoodsId)
	
	local point = getNextPoint()
	local hero = mHeroManger.GetHero()
	if point.harborId == hero.harborId then
		intoHarbor()
	else
		gotoNextHarbor()
	end
end

function gotoNextHarbor()
	local harborId = getNextPoint().harborId
	local cfg_harbor = CFG_harbor[harborId]
	mAutoBusinessTip.SetData("正在前往["..cfg_harbor.name.."]港口...")
	mHeroManger.IntoHarbor(getNextPoint().harborId)
end

function getNextPoint()
	if mNowIndex > #mPathList[mPathId] then
		mNowIndex = 1
	end
	return mPathList[mPathId][mNowIndex]
end

function StopAutoBusiness()
	if not mNowIndex then
		return
	end
	mHeroManger.StopMove()
	mNowIndex = nil
	mPathId = nil
	mAutoBusinessTip.HideTip()
	mTimer.RemoveTimer(mOutTimer)
end

function getStarIndex(mGoodsId)
	local dis = 99999999999
	local indexID = 0
	for k,v in pairs(mPathList[mPathId]) do
		-- local cfg_harbor = CFG_Harbor[v.harborId]
		-- local harborDir = mHarborManager.GetDir(v.harborId)
		local harborDir =  mHarborManager.GetHeroDis(v.harborId)
		if mGoodsId == v.goodsId then
			return k+1
		elseif harborDir < dis then
			indexID = k
			dis = harborDir
		end
	end
	return indexID
end

function CheckBusiness()
	local hero = mHeroManger.GetHero()
	-- print(mPathList[mPathId])
	for k,v in pairs(mPathList[mPathId]) do
		local cfg_product = CFG_product[v.goodsId]
		if cfg_product.totalTrade > hero.business then
			return false
		end
	end
	return true
end