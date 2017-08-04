module("LuaScript.View.Panel.Daily.DailyPanel",package.seeall)

local mActivityPanel = nil
local mMainPanel = nil
local mPackageViewPanel = nil
local mRechargePanel = require "LuaScript.View.Panel.Recharge.RechargePanel" --充值页面
panelType = ConstValue.CommonPanel

local mScrollPositionX = 0

local itemSpace = 0
local itemWidth = 178
local itemHeight = 265
local originalX, originalY = 0, 17

local scrollViewWidth = 0

local bgImage = nil
local titleImage = nil
local progressBg = nil
local progressFg = nil
local boxIcon = nil
local circleBg = nil
local livenessText = nil
local joinNumImage = nil
local livenessAwardImage = nil
local fg_small, bg_small = nil, nil

local progressMaxWidth = nil
local curLiveness = 0
local maxLiveness = 210
local progress = 0

local items = {}

local dailyInfo, dailyAwardInfo = nil, nil

-- 关闭按钮
local closeButtonStyle = {
	normal = {
		background = "Texture/Gui/DailyPanel/30"
	}
}

-- 普通宝箱按钮
local boxButtonStyle_normal = {
	normal = {
		background = "Texture/Gui/DailyPanel/14"
	},
	active = {
		background = "Texture/Gui/DailyPanel/16"
	}
}

-- 灰色宝箱按钮
local boxButtonStyle_grey = {
	normal = {
		background = "Texture/Gui/DailyPanel/15"
	}
}

-- 前往按钮
local goButtonStyle = {
	normal = {
		background = "Texture/Gui/DailyPanel/6"
	}
}

-- 宝箱按钮
local boxButtonStyle = nil

-- 活跃度文字
local livenessTextStyle = {
	alignment=TextAnchor.MiddleCenter,
	fontSize = 20,
	richText = true,
	wordWrap = true,
	normal = {
		textColor = Color.Init(79 / 255, 51 / 255, 17 / 255)
	}
}
-- 当前活跃度文字
local curLivenessTextStyle = {
	alignment=TextAnchor.MiddleLeft,
	font = "font/art",
	fontSize = 25,
	richText = true,
	wordWrap = true,
	normal = {
		textColor = Color.Init(0, 1, 0)
	}
}

-- 参与次数文字
local joinNumTextStyle = {
	alignment=TextAnchor.MiddleCenter,
	fontSize = 13,
	richText = true,
	wordWrap = true,
	font = "font/art",
	normal = {
		textColor = Color.White
	}
}

function Init()
	mActivityPanel = require "LuaScript.View.Panel.Activity.ActivityPanel"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mPackageViewPanel = require "LuaScript.View.Panel.Item.PackageViewPanel"

	for k, v in pairs(CFG_daily) do
		items[k] = v
		-- 图标
		v.image = mAssetManager.GetAsset(v.icon)
	end
	
	progressMaxWidth = 886
	
	local size = table.size(items)
	if size > 0 then
		scrollViewWidth = size * itemWidth + (size - 1) * itemSpace
	end
	
	-- 控制宝箱按钮状态
	boxButtonStyle = boxButtonStyle_grey
	
	bgImage = mAssetManager.GetAsset("Texture/Gui/DailyPanel/beijing")
	titleImage = mAssetManager.GetAsset("Texture/Gui/DailyPanel/21")
	progressBg = mAssetManager.GetAsset("Texture/Gui/DailyPanel/19")
	progressFg = mAssetManager.GetAsset("Texture/Gui/DailyPanel/20")
	boxIcon = mAssetManager.GetAsset("Texture/Gui/DailyPanel/15")
	-- boxNormal = mAssetManager.GetAsset("Texture/Gui/DailyPanel/14")
	-- boxPress = mAssetManager.GetAsset("Texture/Gui/DailyPanel/16")
	livenessText = mAssetManager.GetAsset("Texture/Gui/DailyPanel/22")
	circleBg = mAssetManager.GetAsset("Texture/Gui/DailyPanel/18")
	--circleBg_green = mAssetManager.GetAsset("Texture/Gui/DailyPanel/17")
	joinNumImage = mAssetManager.GetAsset("Texture/Gui/DailyPanel/3")
	livenessAwardImage = mAssetManager.GetAsset("Texture/Gui/DailyPanel/2")
	fg_small = mAssetManager.GetAsset("Texture/Gui/DailyPanel/5")
	bg_small = mAssetManager.GetAsset("Texture/Gui/DailyPanel/4")
end

local function OnItemClick(id)
	--print("on item click id: " .. id)
	local OpenPanelInfo = nil
	if id == 1 then
		mActivityPanel.SetData(ActivityType.Fish)
		OpenPanelInfo = mActivityPanel
	elseif id == 2 then
		OpenPanelInfo = mRechargePanel
	elseif id == 3 then
		mActivityPanel.SetData(ActivityType.GoodDrinking)
		OpenPanelInfo = mActivityPanel
	elseif id == 4 then
		mActivityPanel.SetData(ActivityType.HarborBattle)
		OpenPanelInfo = mActivityPanel
	elseif id == 5 then
		mActivityPanel.SetData(ActivityType.EnemyTreasure)
		OpenPanelInfo = mActivityPanel
	elseif id == 6 then
		mActivityPanel.SetData(ActivityType.CollectTreasureMap)
		OpenPanelInfo = mActivityPanel
	elseif id == 7 then
		mActivityPanel.SetData(ActivityType.EmenyAttack)
		OpenPanelInfo = mActivityPanel
	elseif id == 8 then
		mActivityPanel.SetData(ActivityType.DeadGame)
		OpenPanelInfo = mActivityPanel
	end
	mPanelManager.Show(OpenPanelInfo)
	mPanelManager.Hide(OnGUI)
end

local function OnAwardClick(awardInfo)
	if curLiveness >= awardInfo.livenessValue and not dailyAwardInfo[awardInfo.id] then
		mDailyManager.RequestGetAward(awardInfo.id)
	else
		mPackageViewPanel.SetData(awardInfo.awardId, awardInfo.awardCount)
		mPanelManager.Show(mPackageViewPanel)
	end
end

local function DrawItems()
	for k, v in pairs(items) do
		local posx = (k - 1) * (itemWidth + itemSpace + originalX)--(itemSpace + itemWidth) + originalX
		GUI.BeginGroup(posx, originalY, 230, 320)
		-- 背景
		GUI.DrawTexture(0, 0, 178, 268, v.image)
		-- 参与次数
		GUI.DrawTexture(16.7, 144, 61.7, 19.7, joinNumImage)
		GUI.DrawTexture(78.4, 144, 75.2, 17, bg_small)
		v.curCount = dailyInfo[k] or 0
		v.joinProgress = v.curCount / v.count
		GUI.DrawTexture(78.4, 144, v.joinProgress * 75.2, 17, fg_small)
		GUI.Label(78.4, 143, 75.2, 19.7, v.curCount .. "/" .. v.count, joinNumTextStyle, Color.Black)
		--活跃
		GUI.DrawTexture(16.7, 169, 61.7, 19.7, livenessAwardImage)
		GUI.DrawTexture(78.4, 169, 75.2, 17, bg_small)
		v.curLiveness = v.curCount * v.livenessValue
		v.livenessProgress = v.curLiveness / (v.count * v.livenessValue)
		GUI.DrawTexture(78.4, 169, v.livenessProgress * 75.2, 17, fg_small)
		GUI.Label(78.4, 168, 75.2, 19.7, v.curLiveness .. "/" .. v.count * v.livenessValue, joinNumTextStyle, Color.Black)
		-- 前往按钮
		if GUI.Button(48.5, 194, 81, 44, "", goButtonStyle) then
			OnItemClick(v.livenessId)
		end
		GUI.EndGroup()
	end
end

local function DrawProgress()
	local temp = 0
	for k, v in pairs(dailyInfo) do
		temp = temp + items[k].livenessValue * v
	end
	curLiveness = temp

	progress = curLiveness / maxLiveness
	if progress > 1 then progress = 1 end
	-- 进度条区域
	GUI.BeginGroup(0, 100, 1136, 200)
	-- 进度条背景
	GUI.DrawTexture(100, 100, progressMaxWidth + 40, 21, progressBg)
	-- 进度条前景
	GUI.DrawTexture(100, 100, progressMaxWidth * progress, 21, progressFg, 0, 0, progress, 1)
	
	-- GUI.DrawTexture(165, 520, mProgressWidth, 32, image, 0, 0, mProgress, 1)
	
	-- 活跃值图片文字
	GUI.DrawTexture(125, 122, 64, 26, livenessText)
	-- 当前活跃值
	GUI.Label(450, 150, 210, 26, "当前活跃值: " .. curLiveness, curLivenessTextStyle, Color.Black)
	-- 奖励按钮和活跃值
	for k, v in pairs(CFG_dailyAward) do
		local posx = 208.5 + (k - 1) * 127 - 25
		local posy = 0
		-- 奖励背景
		GUI.DrawTexture(posx, posy, 87, 110, circleBg)
		-- 控制宝箱按钮状态
		if curLiveness >= v.livenessValue then
			boxButtonStyle = boxButtonStyle_normal
		else
			boxButtonStyle = boxButtonStyle_grey
		end
		
		
		if curLiveness >= v.livenessValue and not dailyAwardInfo[v.id] then
			GUI.FrameAnimation(posx-80,posy-80,256,256,"firstRechange") -- 帧动画
		end
		
		-- 奖励宝箱
		if GUI.Button(posx - 2, posy + 2.5, 91, 82, nil, boxButtonStyle) then
			OnAwardClick(v)
		end
		if dailyAwardInfo[v.id] then
			local image = mAssetManager.GetAsset("Texture/Gui/Text/get_3")
			GUI.DrawTexture(posx, posy, 100, 71, image)
		end
		
		-- 活跃度文字
		GUI.Label(posx, posy + 120, 87, 30, v.livenessValue, livenessTextStyle)
	end
	GUI.EndGroup()
end

function OnGUI()
	dailyInfo = mDailyManager.GetDailyList() or {}
	dailyAwardInfo = mDailyManager.GetDailyAwardList() or {}
	
	GUI.DrawPackerTexture(bgImage)
	GUI.DrawTexture(414, 11, 309, 82, titleImage)
	
	mScrollPositionX = GUI.BeginScrollView(83, 261, 969, 293, mScrollPositionX, 0, 0, 0, scrollViewWidth, 293)
	DrawItems()
	GUI.EndScrollView()
	
	DrawProgress()
	
	if GUI.Button(1020, 37, 82, 68, nil, closeButtonStyle) then
		mPanelManager.Hide(OnGUI)
		mPanelManager.Show(mMainPanel)
		mSceneManager.SetMouseEvent(true)
	end
end

function Display()
	mSceneManager.SetMouseEvent(false)
	mPanelManager.Hide(mMainPanel)
end