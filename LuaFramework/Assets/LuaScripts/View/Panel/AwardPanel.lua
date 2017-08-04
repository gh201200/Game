module("LuaScript.View.Panel.AwardPanel", package.seeall)

local mHarborManager	=		nil
local mItemViewPanel	=		nil
local mHarborViewPanel	=		nil

local bgImage			=		nil				-- 背景图片
local titleImage		=		nil				-- 标题背景
local itemBg			=		nil				-- 条目背景
local cellBg			=		nil				-- 物品背景
local moneyIcon			=		nil				-- 银两图标
local shipTeamIcon		=		nil				-- 商队图标

local state 			= 		nil

local shipAward			=		0				-- 商队总收益
local harborList		=		{}				-- 可领取收益的港口

local mScrollPositionY	=		0

local itemWidth			=		664
local itemHeight		=		146
local itemSpace			=		10
local totalHeight		=		0

local titleFont = { 
	alignment=TextAnchor.MiddleCenter,
	fontSize=40,
	richText=true,
	font = "font/art",
	normal={
		textColor=Color.Init(253 / 255, 232 / 255, 162 / 255)
	}
}

local itemFont = { 
	alignment=TextAnchor.MiddleCenter,
	fontSize=30,
	richText=true,
	font = "font/art",
	normal={
		textColor=Color.White
	}
}

local itemFont2 = { 
	alignment=TextAnchor.MiddleCenter,
	fontSize=25,
	richText=true,
	font = "font/art",
	normal={
		textColor=Color.White
	}
}

-- 关闭按钮
local closeButtonStyle = {
	normal = {
		background = "Texture/Gui/DailyPanel/30"
	}
}

panelType = ConstValue.AlertPanel

-- function SetData(arg)
	-- if type(arg) == "table" then
		-- for i = 1, table.size(arg) do
			-- harborList[i] = {
				-- itemType = "harbor",
				-- value = v
			-- }
		-- end
	-- end
-- end

function Init()
	mHarborManager 		= 		require "LuaScript.Control.Scene.HarborManager"
	mItemViewPanel 		= 		require "LuaScript.View.Panel.Item.ItemViewPanel"
	mHarborViewPanel 	= 		require "LuaScript.View.Panel.Harbor.HarborViewPanel"
	shipAward			=		999999
	
	for _, v in pairs(mHarborManager.GetSelfHarborList()) do
		if v.income then
			table.insert(harborList, {
				itemType = "harbor",
				value = v
			})
		end
	end
	
	for _, v in pairs(harborList) do
		if v.itemType == "harbor" then
			mHarborManager.RequestGetIncome(v.value.id)
		end
	end
end

function Display()
	-- state			=		mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false)
	print("award panel show")
end

function Hide()
	mSceneManager.SetMouseEvent(true)
	print("award panel hide")
end

local function DrawItem(x, y, item)
	--GUI.BeginGroup(x, y, itemWidth, itemHeight)
	
	GUI.DrawTexture(x, y, itemWidth, itemHeight, itemBg)
	
	local title 	=		 	""
	local icon		=			nil
	local money		=			0
	
	if item.itemType == "shipTeam" then
		title 		= 		 	"<color=orange>商队</color>"
		icon		=			shipTeamIcon
		money		=			shipAward
	elseif item.itemType == "harbor" then
		local config = CFG_harbor[item.value.id]
		title 		=		 	"<color=orange>" .. config.name .. "</color>"
		icon		=			mAssetManager.GetAsset("Texture/Icon/Harbor/" .. config.resId)
		money 		= 			(item.value.shopLevel * item.value.shopLevel * 50 + 1000) * 24
		local cfg_award = CFG_harborItemCount[config.type .. "_" .. item.value.level]
		if cfg_award then
			--GUI.BeginGroup(400, 40, 261, 97)
			GUI.DrawTexture(x+400+8, y+40+10, 237, 73, cellBg)
			config = CFG_item[cfg_award.itemId]
			local image = mAssetManager.GetAsset("Texture/Icon/Item/".. config.icon, AssetType.Icon)
			if GUI.TextureButton(x+400+8, y+40+7, 80, 80, image) then
				mItemViewPanel.SetData(config.id)
				mPanelManager.Show(mItemViewPanel)
			end
			GUI.Label(x+400+88, y+40+14, 155, 31, "<color=#8f5e26>" .. config.name .. "</color>", itemFont2)
			GUI.Label(x+400+88, y+40+45, 155, 35, "<color=#65e489>数量x" .. cfg_award.count .. "</color>", itemFont2)
			--GUI.EndGroup()
		end
	end
	
	GUI.Label(x+184, y+5, 297, 40, title, itemFont, Color.Black)
	
	if GUI.TextureButton(x+24,y+9,128,128,icon) and item.itemType == "harbor" then
		local config = CFG_harbor[item.value.id]
		mHarborViewPanel.SetData(config.id,config.level,config.shopLevel)
		mPanelManager.Show(mHarborViewPanel)
	end
	
	--GUI.BeginGroup(146, 40, 261, 97)
	
	GUI.DrawTexture(x+146+8, y+40+10, 237, 73, cellBg)
	
	local cfg_item = CFG_item[14]
	local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
	if GUI.TextureButton(x+146+8, y+40+7, 80, 80, image) then
		mItemViewPanel.SetData(cfg_item.id)
		mPanelManager.Show(mItemViewPanel)
	end
	
	GUI.Label(x+146+88, y+40+14, 155, 31, "<color=#8f5e26>" .. cfg_item.name .. "</color>", itemFont2)
	GUI.Label(x+146+88, y+40+45, 155, 35, "<color=#65e489>数量x" .. money .. "</color>", itemFont2)
	
	--GUI.EndGroup()
	
	--GUI.EndGroup()
end

function OnGUI()
	if mSceneManager.GetMouseEventState() == true then
		mSceneManager.SetMouseEvent(false)
	end
	bgImage				=		mAssetManager.GetAsset("Texture/Gui/Bg/bg2_2", AssetType.Pic)
	titleImage			=		mAssetManager.GetAsset("Texture/Gui/Bg/bg40_2")
	itemBg				= 		mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	cellBg				= 		mAssetManager.GetAsset("Texture/Gui/ChargePanel/25")
	moneyIcon			=		mAssetManager.GetAsset("Texture/Icon/Item/14")
	shipTeamIcon		=		mAssetManager.GetAsset("Texture/Icon/Harbor/1")
	
	GUI.DrawTexture(170, 71, 796, 496, bgImage)
	GUI.DrawTexture(420, 37, 297, 74, titleImage)
	GUI.Label(420, 37, 297, 74, "收益", titleFont, Color.Black)
	
	if GUI.Button(888, 72, 77, 63, "", closeButtonStyle) then
		mPanelManager.Hide(OnGUI)
	end
	
	if mShipTeamManager.GetMoneyAward then
		shipAward = mShipTeamManager.GetMoneyAward() or 0
	else
		shipAward = 0
	end
	
	if shipAward ~= 0 then
		harborList[0] = {
			itemType = "shipTeam",
			icon = shipTeamIcon,
			amount = shipAward
		}
	end
	
	local size = table.size(harborList)
	totalHeight = size * itemHeight + (size - 1) * itemSpace
	_, mScrollPositionY = GUI.BeginScrollView(235, 117, 664, 391, 0, mScrollPositionY, 0, 0, 664, totalHeight)
	local posx = 0
	local posy = 0
	local index = 0
	for _, v in pairs(harborList) do
		posy = index * itemHeight + index * itemSpace
		DrawItem(posx, posy, v)
		index = index + 1
	end
	GUI.EndScrollView()
end