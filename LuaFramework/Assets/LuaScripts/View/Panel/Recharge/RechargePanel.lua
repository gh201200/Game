module("LuaScript.View.Panel.Recharge.RechargePanel", package.seeall)

local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mAssetManager = nil
local mMainPanel = nil
local mHeroManager = nil
local mLoginPanel = nil

local mHero = nil

local bg = nil
-- local titleImage = nil
local vipBg = nil
local progressFg, progressBg = nil, nil
local itemBg = nil
local fc_bg = nil
local goldImages = {}
local FC = {}
local curNum, totalNum, progress = 70, 200, 0
local mScrollPositionX = 0
local VIPprivilege = nil
local packageViewStyle = {	
	normal={background = "Texture/Gui/ChargePanel/2"}
}
			
local itemWidth, itemHeight, space, totalWidth = 207, 307, 0, 0
local startX, startY = 0, 0

-- 购买按钮
local buyButtonStyle = {
	normal = {
		background = "Texture/Gui/Button/btn3_1"
	},
	active = {
		background = "Texture/Gui/Button/btn3_2"
	},
	padding = {
		bottom = 5
	},
	font = "font/art",
	fontSize = 25,
	richText = true,
	alignment = TextAnchor.MiddleCenter,
}

			
panelType = ConstValue.AlertPanel

convertNum = 10		--RMB兑换元宝比例

local Alipay = nil

if platform == "main" then
	Alipay = luanet.import_type("Alipay")
end

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mLoginPanel = require "LuaScript.View.Panel.Login.LoginPanel"
	bg = mAssetManager.GetAsset("Texture/Gui/ChargePanel/beijing")
	-- titleImage = mAssetManager.GetAsset("Texture/Gui/ChargePanel/1")
	vipBg = mAssetManager.GetAsset("Texture/Gui/ChargePanel/19")
	progressFg = mAssetManager.GetAsset("Texture/Gui/ChargePanel/17")
	progressBg = mAssetManager.GetAsset("Texture/Gui/ChargePanel/18")
	itemBg = mAssetManager.GetAsset("Texture/Gui/ChargePanel/20")
	fc_bg = mAssetManager.GetAsset("Texture/Gui/ChargePanel/22")
	for i = 1, #CFG_recharge do
		goldImages[i] = mAssetManager.GetAsset("Texture/Gui/ChargePanel/gold_" .. math.min(i, 8))
		if i >= 2 and i <= 6 then
			FC[i] = mAssetManager.GetAsset("Texture/Gui/ChargePanel/FC_" .. i)
		end
	end
	FC[1.5] = mAssetManager.GetAsset("Texture/Gui/ChargePanel/FC_1.5")
	VIPprivilege = require "LuaScript.View.Panel.VIPprivilege.VIPprivilege" --VIP特权浏览
	totalWidth = #CFG_recharge * itemWidth
end

function Display()
	mSceneManager.SetMouseEvent(false)
	-- mPanelManager.Hide(mMainPanel)
end

function Hide()
	mSceneManager.SetMouseEvent(true)
	-- mPanelManager.Show(mMainPanel) -- 会导致引导窗口消失
end

-- 滑动列表中的购买按钮点击后调用
-- index：1-8
local function OnItemClick(rmb, title)
	print("on item buy button click! rmb: " .. rmb)
	if platform == "yj" then
		mSDK.Pay_YJ(rmb * 100, title, 1, "")
	elseif platform == "main" then
		local hero = mHeroManager.GetHero()
		local serverId = tostring(mLoginPanel.GetServerId())
		Alipay.Pay(title, rmb, tostring(hero.id), serverId)
	end
end

local function FirstBuy(num, index)
	local str = string.reverse(num)
	local ss = string.sub(str, index, index)
	return ss
end
local function DrawItems()
	local mRMBList = CFG_recharge
	for k, v in pairs(mRMBList) do
		local posx = startX + (k - 1) * itemWidth
		GUI.BeginGroup(posx, 0, itemWidth, itemHeight + 22)
		GUI.DrawTexture(0, 22, itemWidth, itemHeight, itemBg)
		local yuanbao = 0
		local index = FirstBuy(mHero.firstRecharge, k)
		if index == "0" or index == "" then
			yuanbao = v.rmb * v.firstCrit * convertNum
		else
			yuanbao = v.rmb * v.foreverCrit * convertNum
		end
		local title = yuanbao .. "元宝"
		local price = v.rmb
		GUI.Label(20.3, 42, 157.7, 35.8, title, GUIStyleLabel.Center_24_Custom_Art, Color.Black)
		GUI.DrawTexture(29, 85, 140, 140, goldImages[k])
		if (index == "0" or index == "") and v.firstCrit > 1 then
			GUI.DrawTexture(114.4, -3.8, 106.6, 117.8, fc_bg)
			GUI.DrawTexture(142.1, 20.9, 64, 64, FC[v.firstCrit])
		else
			if v.foreverCrit > 1 then
				GUI.DrawTexture(114.4, -3.8, 106.6, 117.8, fc_bg)
				GUI.DrawTexture(142.1, 20.9, 64, 64, FC[v.foreverCrit])
			end
		end
		if GUI.Button(43, 237, 113, 61, "<color=yellow>￥" .. price .. "</color>", buyButtonStyle, Color.Black) then
			OnItemClick(price, title)
		end
		GUI.EndGroup()
	end
end

function OnGUI()
	mHero = mHeroManager.GetHero()
	convertNum = mHeroManager.GetmRmbToGold()
	GUI.DrawPackerTexture(bg)
	if GUI.Button(1026, 30, 86, 86, "", GUIStyleButton.CloseBtn_4) then
		mPanelManager.Hide(OnGUI)
		-- mPanelManager.Show(mMainPanel)
	end
	
	-- GUI.DrawTexture(413.5, 20, 309, 83, titleImage)
	
	GUI.DrawTexture(123, 187, 117, 58, vipBg)
	GUI.Label(123, 195, 117, 42, "<color=red>vip" .. mHero.vipLevel .. "</color>", GUIStyleLabel.Center_24_Custom_Art, Color.Black)
	
	local cfg_vip = CFG_vip[math.min(mHero.vipLevel + 1, 15)]
	local nextVip = CFG_vip[mHero.vipLevel + 1]
	curNum = mHero.vipExp
	totalNum = cfg_vip.vipExp
	local left = cfg_vip.vipExp - mHero.vipExp
	if nextVip then
		GUI.Label(81, 126, 972, 67, "再冲<color=green>" .. left .. "元宝</color>即可升级到<color=red>VIP" .. mHero.vipLevel + 1 .. "</color>", GUIStyleLabel.Center_24_Custom_Art, Color.Black)
	else
		-- if left > 0 then
			-- GUI.Label(81, 126, 972, 67, "再冲<color=green>" .. left .. "元宝</color><color=red>即可升到满级</color>", GUIStyleLabel.Center_24_Custom_Art, Color.Black)
		-- else
			-- GUI.Label(81, 126, 972, 67, "<color=red>vip等级已满</color>", GUIStyleLabel.Center_24_Custom_Art, Color.Black)
		-- end
		GUI.Label(81, 126, 972, 67, "<color=green>vip等级已满</color>", GUIStyleLabel.Center_24_Custom_Art, Color.Black)
		totalNum = curNum
	end
	
	progress = curNum / totalNum
	if progress > 1 then
		progress = 1
	elseif progress < 0 then
		progress = 0
	end
	GUI.DrawTexture(251, 203, 577, 27, progressBg) -- 经验条背景
	GUI.DrawTexture(251, 203, progress * 577, 27, progressFg, 0, 0, progress, 1) -- 充值经验条
	GUI.Label(251, 203, 577, 27, "<color=yellow>" .. curNum .. "/" .. totalNum .. "</color>", GUIStyleLabel.Center_24_Custom_Art, Color.Black)
	if GUI.Button(831, 174, 201, 85, nil, GUIStyleButton.Transparent) then
		--print("on packageView Button Click")
		mPanelManager.Show(VIPprivilege)
	end
	
	mScrollPositionX = GUI.BeginScrollView(135, 241, 866, 336.5, mScrollPositionX, 0, 0, 0, totalWidth, 309)
	DrawItems()
	GUI.EndScrollView()
end