local mActionManager = nil
local mPanelManager = nil
local mItemBagPanel = nil
local mTaskPanel = nil
local mTreasureTip = nil

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
end


function OnGUI()
	-- print(22222)
	local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg14_1)
	GUI.DrawTexture(0, 0, 256, 256, image)

	local mHero = mHeroManager.GetHero()
	
	local power = tostring(mHero.power)
	DrawPowerNum(string.sub(power,1,1), 1)
	DrawPowerNum(string.sub(power,2,2), 2)
	DrawPowerNum(string.sub(power,3,3), 3)
	DrawPowerNum(string.sub(power,4,4), 4)
	DrawPowerNum(string.sub(power,5,5), 5)
	DrawPowerNum(string.sub(power,6,6), 6)
	
	
	-- GUI.Label(93,10,115,0,mHero.power,GUIStyleLabel.Center_26_Power_Yellow)
	
	GUI.Label(62,55,91,0,mCommonlyFunc.GetShortNumber(mHero.money),GUIStyleLabel.Center_18_White, Color.Black)
	GUI.Label(62,91,91,0,mCommonlyFunc.GetShortNumber(mHero.gold),GUIStyleLabel.Center_18_White, Color.Black)
	-- GUI.Label(62,91,91,0,mCommonlyFunc.GetShortNumber(mHero.gold),GUIStyleLabel.Center_18_White, Color.Black)
	if mHero.harborId then
		local cfg_harbor = CFG_harbor[mHero.harborId]
		GUI.Label(62,91+44-5,91,0,cfg_harbor.name,GUIStyleLabel.Center_18_White, Color.Black)
	else
		if mHero.updatePositionTime ~= os.oldTime then
			mHero.updatePositionTime = os.oldTime
			mHero.positionStr = string.format("%d,%d",mHero.x,mHero.y)
		end
		GUI.Label(62,91+44-5,91,0, mHero.positionStr, GUIStyleLabel.Center_18_White, Color.Black)
	end
	
	if GUI.Button(127,69,64,64,nil,GUIStyleButton.RechargeBtn) then
		mCommonlyFunc.Recharge(true)
	end
	
	if GUI.Button(230,10,61,32,nil,GUIStyleButton.Btn23) then
		mCommonlyFunc.Recharge(true)
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Text/v"..mHero.vipLevel)
	GUI.DrawTexture(227, 8, 64, 32, image)
	-- mTreasureTip.OnGUI()
	
	--战斗/和平模式  新手阶段不显示
	-- if mHero.level < 28 or mHero.mode == 0 then
		-- return
	-- end
	
	-- if mHero.mode == 2 then
		-- if GUI.Button(29,160,64,64,nil,GUIStyleButton.Mode1) then
			-- mAlert.Show("切换<color=red>征战</color>模式将锁定1小时，期间会被其他玩家攻击，是否切换？",function ()
				-- mHeroManager.RequestSelectMode(1);
			-- end)
		-- end
	-- else
		-- if GUI.Button(29,160,64,64,nil,GUIStyleButton.Mode2) then
			-- mHeroManager.RequestSelectMode(2)
		-- end
	-- end
end

function DrawPowerNum(key, index)
	if key == "" then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Text/"..key)
	GUI.DrawTexture(75+index*18, 8, 32, 32, image)
end