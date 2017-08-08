local mActionManager = nil
local mItemBagPanel = nil
local mTaskPanel = nil
local mTreasureTip = nil
local mVIPprivilege = nil
local mFirstRechange = nil
local mHeroPanel = nil

module("LuaScript.View.Panel.Main.RoleInfo",package.seeall) -- 主界面左上角玩家信息

-- local mSelectMode = false

function Init()
	mItemBagPanel = require "LuaScript.View.Panel.Item.ItemBagPanel"
	mTaskPanel = require "LuaScript.View.Panel.Task.TaskPanel"
	mChatPanel = require "LuaScript.View.Panel.Chat.ChatPanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	mFamilyPanel = require "LuaScript.View.Panel.Family.FamilyPanel"
	mFamilyListPanel = require "LuaScript.View.Panel.Family.FamilyListPanel"
	mFriendPanel = require "LuaScript.View.Panel.Friend.FriendPanel"
	mHeroPanel = require "LuaScript.View.Panel.HeroPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mFleetPanel = require "LuaScript.View.Panel.Fleet.FleetPanel"
	mTreasureTip = require "LuaScript.View.Tip.TreasureTip"
	mVIPprivilege = require "LuaScript.View.Panel.VIPprivilege.VIPprivilege"
	mFirstRechange = require "LuaScript.View.Panel.FirstRechange.FirstRechange"
end


function OnGUI()
	-- print(22222)
	local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg14_1)
	GUI.DrawTexture(0, 14, 512, 128, image)
	
	-- local image = mAssetManager.GetAsset("Texture/Character/RoleHeader/1")
	local mHero = mHeroManager.GetHero()
	local image = mAssetManager.GetAsset(string.format(AssetPath.Gui_Character_HeroHeader,mHero.resId))
	GUI.DrawTexture(10, -5, 128, 128, image)
	
	local power = tostring(mHero.power)
	local length = #power -- 战斗力
	DrawPowerNum(string.sub(power,1,1), length-1)
	DrawPowerNum(string.sub(power,2,2), length-2)
	DrawPowerNum(string.sub(power,3,3), length-3)
	DrawPowerNum(string.sub(power,4,4), length-4)
	DrawPowerNum(string.sub(power,5,5), length-5)
	DrawPowerNum(string.sub(power,6,6), length-6)
	
	-- GUI.Label(93,10,115,0,mHero.power,GUIStyleLabel.Center_26_Power_Yellow)
	
	GUI.Label(155-15,53+2,91,0,mCommonlyFunc.GetShortNumber(mHero.money),GUIStyleLabel.Right_18_White)
	GUI.Label(155-15,85+2,91,0,mCommonlyFunc.GetShortNumber(mHero.gold),GUIStyleLabel.Right_18_White)
	GUI.Label(20,19,24,0,mHero.level,GUIStyleLabel.Center_20_Yellow4)
	-- GUI.Label(62,91,91,0,mCommonlyFunc.GetShortNumber(mHero.gold),GUIStyleLabel.Center_18_White, Color.Black)
	-- if mHero.harborId then
		-- local cfg_harbor = CFG_harbor[mHero.harborId]
		-- GUI.Label(62,91+44-5,91,0,cfg_harbor.name,GUIStyleLabel.Center_18_White, Color.Black)
	-- else
		-- if mHero.updatePositionTime ~= os.oldTime then
			-- mHero.updatePositionTime = os.oldTime
			-- mHero.positionStr = string.format("%d,%d",mHero.x,mHero.y)
		-- end
		-- GUI.Label(62,91+44-5,91,0, mHero.positionStr, GUIStyleLabel.Center_18_White, Color.Black)
	-- end
	-- 战斗/和平模式  新手阶段不显示
	
	if GUI.Button(106+8,112,128,32,nil,GUIStyleButton.RechargeBtn) then
		mCommonlyFunc.Recharge(true)
	end
	
	if GUI.Button(4,112,128,32,nil,GUIStyleButton.Btn_B) then
		-- mCommonlyFunc.Recharge(true)
		mPanelManager.Show(mVIPprivilege)
	end
	
	
	if mHero.level < 28 or mHero.mode == 0 then
		if GUI.Button(-11,63,64,64,nil,GUIStyleButton.Mode1) then
			-- mHeroManager.RequestSelectMode(2)
			mSystemTip.ShowTip("新手期不能更换战斗模式")
		end
	elseif mHero.mode == 2 then
		if GUI.Button(-11,63,64,64,nil,GUIStyleButton.Mode1) then
			mAlert.Show("切换<color=red>征战</color>模式将锁定1小时，期间会被其他玩家攻击，是否切换？",function ()
				mHeroManager.RequestSelectMode(1);
			end)
		end
	else
		if GUI.Button(-11,63,64,64,nil,GUIStyleButton.Mode2) then
			mHeroManager.RequestSelectMode(2)
		end
	end
	
	if GUI.Button(0,0,125,110,nil,GUIStyleButton.Transparent) then
		mPanelManager.Show(mHeroPanel)
	end
	

	local image = mAssetManager.GetAsset(ConstValue.vipGuiImagePath[mHero.vipLevel])
	GUI.DrawTexture(38, 112, 64, 32, image)
	
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Text/v"..mHero.vipLevel)
	-- GUI.DrawTexture(38, 112, 64, 32, image)
	
	
	
	-- 首冲元宝按钮
	if mHero.firstRecharge == 0 and mHeroManager.GetFirstRecharge() then
		-- GUI.FrameAnimation(-63,95+20,256,256,"firstRechange") -- 帧动画
		-- GUI.FrameAnimation(-63,95+30,256,256,"top_tip",9,0.1)
		if GUI.Button(231,94,64,64,nil,GUIStyleButton.FirstChargeBtn) then
			mPanelManager.Show(mFirstRechange)
		end
		-- local image = mAssetManager.GetAsset("Texture/Gui/Button/firstCharge")
		-- GUI.DrawTexture(-4,159+20,128,128,image)
	end
	
	-- mTreasureTip.OnGUI()
end

function DrawPowerNum(key, index)
	if key == "" then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Text/"..key)
	GUI.DrawTexture(207-index*18, 13, 32, 32, image)
end