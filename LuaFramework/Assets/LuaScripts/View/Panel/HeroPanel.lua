local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty = ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty
local AssetType,CFG_role,CFG_Exp,CFG_shipTeamSlot,CFG_harbor,AppearEvent,EventType,ActionType,os = 
AssetType,CFG_role,CFG_Exp,CFG_shipTeamSlot,CFG_harbor,AppearEvent,EventType,ActionType,os
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mPanelManager = nil
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"
local mShipTeamManager = nil
local mShipTeamViewPanel = nil
local mShipTeamCreatePanel = nil
local mSailorViewPanel = nil
local mSystemTip = nil
local mActionManager = nil
local mHarborViewPanel = nil
local mPowerUpPanel = nil
local mMainPanel = nil

module("LuaScript.View.Panel.HeroPanel") -- 人物详情面板
panelType = ConstValue.AlertPanel
local mMouseEventState = nil
local mScrollPositionY = 0
mPage = 1

function Hide()
	mSceneManager.SetMouseEvent(mMouseEventState)
	mPage = 1
end

function Display()
	mScrollPositionY = 0
	mMouseEventState = mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false)
end

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mShipTeamManager = require "LuaScript.Control.Data.ShipTeamManager"
	mShipTeamViewPanel = require "LuaScript.View.Panel.ShipTeam.ShipTeamViewPanel"
	mShipTeamCreatePanel = require "LuaScript.View.Panel.ShipTeam.ShipTeamCreatePanel"
	mSailorViewPanel = require "LuaScript.View.Panel.Sailor.SailorViewPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mActionManager = require "LuaScript.Control.ActionManager"
	mHarborViewPanel = require "LuaScript.View.Panel.Harbor.HarborViewPanel"
	mPowerUpPanel = require "LuaScript.View.Panel.PowerUp.PowerUpPanel"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	IsInit = true
end

function OnGUI()
	if not IsInit or mHarborViewPanel.visible then
		return
	end
	local hero = mHeroManager.GetHero()
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/tabBg")
	GUI.DrawTexture(256,31,390,66,image)
	
	if mPage == 1 then
		GUI.Button(276,49,111,53, "人物", GUIStyleButton.SelectBtn_6)
	elseif GUI.Button(276,49,111,53, "人物", GUIStyleButton.SelectBtn_5) then
		mPage = 1
		mScrollPositionY = 0
		AppearEvent(nil,EventType.OnRefreshGuide)
	end
	
	if mPage == 2  then
		GUI.Button(393,49,111,53, "主城", GUIStyleButton.SelectBtn_6)
	elseif GUI.Button(393,49,111,53, "主城", GUIStyleButton.SelectBtn_5) then
		mPage = 2
		mScrollPositionY = 0
		AppearEvent(nil,EventType.OnRefreshGuide)
	end
	
	if mPage == 3  then
		GUI.Button(509,49,111,53, "商队", GUIStyleButton.SelectBtn_6)
	elseif GUI.Button(509,49,111,53, "商队", GUIStyleButton.SelectBtn_5) then
		if not mActionManager.GetActionOpen(ActionType.ShipTeam) then
			mSystemTip.ShowTip("该功能未解锁")
			return
		end
		mShipTeamManager.RequestShipTeamDetail()
		mPage = 3
		mScrollPositionY = 0
		AppearEvent(nil,EventType.CheckAllTask)
		AppearEvent(nil,EventType.OnRefreshGuide)
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg2_2")
	GUI.DrawTexture(167,82,795,497,image)
	
	if mPage == 1 then
		local cfg_role = CFG_role[hero.role]
		local image = mAssetManager.GetAsset("Texture/Character/HalfPic/" .. cfg_role.resId, AssetType.Pic)
		GUI.DrawTexture(259, 146, 285, 344, image)
		local image = mAssetManager.GetAsset("Texture/Gui/bg/herobg")
		GUI.DrawTexture(240, 132, 334, 397, image)
		local image = mAssetManager.GetAsset("Texture/Gui/bg/herobg")
		GUI.DrawTexture(240, 132, 334, 397, image)
		local image = mAssetManager.GetAsset("Texture/Gui/bg/herobg")
		GUI.DrawTexture(240, 132, 334, 397, image)
		local image = mAssetManager.GetAsset("Texture/Gui/bg/herobg")
		GUI.DrawTexture(240, 132, 334, 397, image)
		local image = mAssetManager.GetAsset("Texture/Gui/bg/herobg")
		GUI.DrawTexture(240, 132, 334, 397, image)
		local image = mAssetManager.GetAsset("Texture/Gui/bg/herobg")
		GUI.DrawTexture(240, 132, 334, 397, image)
		local image = mAssetManager.GetAsset("Texture/Gui/bg/herobg")
		GUI.DrawTexture(240, 132, 334, 397, image)
		local image = mAssetManager.GetAsset("Texture/Gui/bg/herobg")
		GUI.DrawTexture(240, 132, 334, 397, image)
		local image = mAssetManager.GetAsset("Texture/Gui/bg/herobg")
		GUI.DrawTexture(240, 132, 334, 397, image)
		local image = mAssetManager.GetAsset("Texture/Gui/bg/herobg")
		GUI.DrawTexture(240, 132, 334, 397, image)
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
		GUI.DrawTexture(605,128,246,59,image)
		GUI.Label(583, 140, 292, 30,  hero.name, GUIStyleLabel.Center_45_Brown_Art, Color.Black)
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
		GUI.DrawTexture(593,197,290,306,image,0,0,1,1,20,20,20,20)
		
		local cfg_Exp = CFG_Exp[hero.level]
		GUI.Label(605, 210, 292, 30, "编号: " .. hero.id, GUIStyleLabel.Left_30_Black)
		GUI.Label(605, 250, 292, 30, "航速: " .. hero.speed, GUIStyleLabel.Left_30_Black)
		GUI.Label(605, 290, 292, 30, "贸易: " .. hero.business, GUIStyleLabel.Left_30_Black)
		GUI.Label(605, 330, 292, 30, "等级: " .. hero.level, GUIStyleLabel.Left_30_Black)
		GUI.Label(605, 370, 292, 30, "经验: " .. hero.exp, GUIStyleLabel.Left_30_Black)
		GUI.Label(605, 410, 292, 30, "升级: " .. cfg_Exp.exp, GUIStyleLabel.Left_30_Black)
		GUI.Label(605, 450, 292, 30, "战斗力: " .. hero.power, GUIStyleLabel.Left_30_Black)
	
		if GUI.Button(875-95, 76+346, 128, 64,nil, GUIStyleButton.PowerUp) then
			mPanelManager.Hide(OnGUI)
			mPanelManager.Hide(mMainPanel)
			
			mPanelManager.Show(mPowerUpPanel)
		end
	elseif mPage == 2 then
		local mHarborList = mHarborManager.GetSelfHarborList()
		local count = #mHarborList
		local spacing = 130
		_,mScrollPositionY = GUI.BeginScrollView(231, 128, 900, 400, 0, mScrollPositionY, 0, 0, 850, spacing * count + 8)
			local index = 1
			for k,harbor in pairs(mHarborList) do
				local y = (index-1)*spacing + 8
				local showY = y - mScrollPositionY / GUI.modulus
				if showY > -spacing  and showY < spacing*3 then
					DrawHarbor(0, y, harbor)
				end
				
				index = index + 1
			end
			
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
			if count < 2 then
				GUI.DrawTexture(0,spacing*1 + 8,664,123,image)
			end
			if count < 3 then
				GUI.DrawTexture(0,spacing*2 + 8,664,123,image)
			end
		GUI.EndScrollView()
	elseif mPage == 3 then
		local spacing = 130
		local shipTeam = mShipTeamManager.GetShipTeam()
		for k=1,3,1 do
			local y = (k-1)*spacing + 134
			DrawShipTeam(shipTeam[k], k, 231, y)
		end
	end
	
	if GUI.Button(875, 76, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end

end

function DrawHarbor(x, y, harbor)
	local cfg_harbor = CFG_harbor[harbor.id]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,664,123,image)
	
	-- local key = math.min(math.ceil(harbor.level/ 10), 3)
	local image = mAssetManager.GetAsset("Texture/Icon/Harbor/"..cfg_harbor.resId)
	if GUI.TextureButton(15,y-8,128,128,image) then
		mHarborViewPanel.SetData(harbor.id,harbor.level,harbor.shopLevel)
		mPanelManager.Show(mHarborViewPanel)
	end
	
	GUI.Label(139, y+22, 74, 30, "名称:", GUIStyleLabel.Left_30_DeepBlue_Art)
	GUI.Label(139, y+74, 74, 30, "等级:", GUIStyleLabel.Left_30_DeepBlue_Art)
	GUI.Label(339, y+74, 74, 30, "所属:", GUIStyleLabel.Left_30_DeepBlue_Art)
	GUI.Label(218, y+22, 52, 30, cfg_harbor.name, GUIStyleLabel.Left_30_Redbean)
	GUI.Label(218, y+74, 64, 30, harbor.level, GUIStyleLabel.Left_30_Redbean)
	if harbor.type == 0 then
		GUI.Label(418, y+74, 64, 30, "个人", GUIStyleLabel.Left_30_Redbean)
	else
		GUI.Label(418, y+74, 64, 30, "联盟", GUIStyleLabel.Left_30_Redbean)
	end
	
	if harbor.income then
		-- GUI.Label(520, y+24, 129, 30, "收益可领取", GUIStyleLabel.Center_30_Lime_Art, Color.Black)
		-- GUI.FrameAnimation(430,y-30,300,180,'SailorPropertiesChange',9) -- 可领取  
		if GUI.Button(531, y+42, 112, 34, nil, GUIStyleButton.GetBtn_3) then
			mHarborManager.RequestGetIncome(harbor.id)
		end
	else
		if GUI.Button(531, y+18, 128, 32, nil, GUIStyleButton.MoveBtn_3) then
			mHeroManager.IntoHarbor(harbor.id)
			mPanelManager.Hide(OnGUI)
		end
		if GUI.Button(531, y+74, 128, 32, nil, GUIStyleButton.FlyBtn_2) then
			mHeroManager.RequestFlyToHarbor(cfg_harbor.id)
			mPanelManager.Hide(OnGUI)
		end
	end
end

function DrawShipTeam(shipTeam, index, x, y)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(x,y,664,123,image)
	if shipTeam then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..shipTeam.sailor.quality)
		GUI.DrawTexture(x+17, y + 4, 128, 128, image)
		local image = mAssetManager.GetAsset("Texture/Character/Header/"..shipTeam.sailor.resId, AssetType.Pic)
		if GUI.TextureButton(x+22, y + 9, 100, 100, image) then
			mSailorViewPanel.SetData(shipTeam.sailor)
			mPanelManager.Show(mSailorViewPanel)
		end
		
		GUI.Label(x+139, y+6, 74, 30, "船长名称:", GUIStyleLabel.Left_30_DeepBlue_Art)
		GUI.Label(x+139, y+47, 74, 30, "本次收益:", GUIStyleLabel.Left_30_DeepBlue_Art)
		
		GUI.Label(x+275, y+6, 52, 30, shipTeam.sailor.name, GUIStyleLabel.Left_30_Redbean)
		
		if shipTeam.robed then
			GUI.Label(x+275, y+47, 64, 30, math.floor(shipTeam.income*0.5).."银两(已被抢)", GUIStyleLabel.Left_30_Redbean)
			
			GUI.Label(x+139, y+87, 74, 30, "劫掠玩家:", GUIStyleLabel.Left_30_DeepBlue_Art)
			GUI.Label(x+275, y+87, 64, 30, shipTeam.robedName, GUIStyleLabel.Left_30_Redbean)
		else
			GUI.Label(x+275, y+47, 64, 30, shipTeam.income.."银两", GUIStyleLabel.Left_30_Redbean)
			
			GUI.Label(x+139, y+87, 74, 30, "剩余时间:", GUIStyleLabel.Left_30_DeepBlue_Art)
			if shipTeam.lastTime then
				local mTime = shipTeam.lastTime + shipTeam.updateTime - os.oldClock
				if mTime <= 0 then
					mShipTeamManager.RequestShipTeamDetail()
				end
				GUI.Label(x+275, y+87, 64, 30, mCommonlyFunc.GetFormatTime(mTime), GUIStyleLabel.Left_30_Redbean)
			end
		end
		
		
		
		if GUI.Button(x+531, y+14, 111, 53, "查看", GUIStyleButton.ShortOrangeArtBtn) then
			mPanelManager.Hide(OnGUI)
			mShipTeamViewPanel.SetData(shipTeam)
			mPanelManager.Show(mShipTeamViewPanel)
		end
		if GUI.Button(x+531, y+70, 111, 53, "解散", GUIStyleButton.ShortOrangeArtBtn) then
			mShipTeamManager.RequestDelShipTeam(shipTeam.id)
			-- mPanelManager.Hide(OnGUI)
		end
	else
		local hero = mHeroManager.GetHero()
		local cfg_shipTeamSlot = CFG_shipTeamSlot[index]
		if cfg_shipTeamSlot.level <= hero.level then
			GUI.Label(x,y,664,123, "点击创建商队", GUIStyleLabel.MCenter_40_White_Art, Color.Black)
			if GUI.Button(x,y,664,123, nil, GUIStyleButton.Transparent_40_Art) then
				-- local cfg_harbor = cfg_harbor
				-- if not hero.harborId or hero.map ~= 0 then
					-- mSystemTip.ShowTip("在外海港口才能创建商队")
					-- return
				-- end
				mPanelManager.Hide(OnGUI)
				mShipTeamCreatePanel.RefreshData()
				mPanelManager.Show(mShipTeamCreatePanel)
			end
		else
			GUI.Label(x,y,664,123, cfg_shipTeamSlot.level.."级解锁", GUIStyleLabel.MCenter_40_Gray_Art)
		end
	end
end