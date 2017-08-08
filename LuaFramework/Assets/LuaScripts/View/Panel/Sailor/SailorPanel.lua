local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,Vector2,GUIStyleButton,GUIStyleLabel,ByteArray = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,Vector2,GUIStyleButton,GUIStyleLabel,ByteArray
local PackatHead,Packat_Sailor,SceneType,CFG_Equip,ConstValue,SailorType,os,CFG_copyMap,CFG_copyMapLevel =
PackatHead,Packat_Sailor,SceneType,CFG_Equip,ConstValue,SailorType,os,CFG_copyMap,CFG_copyMapLevel
local AssetType,AppearEvent,EventType = AssetType,AppearEvent,EventType
local DrawItemCell,ItemType = DrawItemCell,ItemType
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mHeroManager = nil
local mSailorManager = nil
local mAssetManager = nil
local mAlert = nil
local mPanelManager = nil
local mSceneManager = nil
local mMainPanel = nil
local mEquipSelectPanel = nil
local mEquipManager = nil
local mEquipViewPanel = nil
local mEventManager = nil
local mNetManager = nil
local mSystemTip = nil
local mSailorViewPanel = nil
local mSailorSelectPanel = nil
local mCopyMapManager = nil
local mCopyMapPanel = nil
local mItemManager = nil
module("LuaScript.View.Panel.Sailor.SailorPanel")
FullWindowPanel = true
local mScrollPositionX = 0
local mScrollPositionY = 0
local mSelectIndex = 1
local mPage = 1
local SelectAniStartTime = nil
local mDutyIndex = nil

local mBetterEquipList = {}
local mHaveBetterEquip = false

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mSailorManager = require "LuaScript.Control.Data.SailorManager"
	mEquipManager = require "LuaScript.Control.Data.EquipManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mSailorViewPanel = require "LuaScript.View.Panel.Sailor.SailorViewPanel"
	mSailorSelectPanel = require "LuaScript.View.Panel.Sailor.SailorSelectPanel"
	mCopyMapManager = require "LuaScript.Control.Data.CopyMapManager"
	mCopyMapPanel = require "LuaScript.View.Panel.CopyMap.CopyMapPanel"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	
	mEventManager.AddEventListen(nil,EventType.OnSailorDuty,OnSailorDuty)
	mEventManager.AddEventListen(nil,EventType.EquipSailorChange,UpdateAutoEquip)
	SelectAniStartTime = 99999
	mDutyIndex = 99999
	IsInit = true
end

function Display()
	local mFightSailors = mSailorManager.GetFightSailors()
	-- AppearEvent(nil, EventType.OnSelectSailor, false)
	mPage = 1
	UpdateAutoEquip()
end

function Hide()
	mScrollPositionX = 0
	mDutyIndex = 99999
	mSelectIndex = 1
end

function OnSailorDuty(_,_,index) -- 船员上阵
	mSelectIndex = index
	UpdateAutoEquip()
end

function GetSelect()
	return mScrollPositionX,mSelectIndex
end

function SetSelect(x, index)
	mScrollPositionX = x 
	mSelectIndex = index
	UpdateAutoEquip()
end

function SetSelectAni(index)
	SelectAniStartTime = os.clock()
	mDutyIndex = index
end

-- function GetSelect()
	-- return mSelectIndex
-- end

function GetPage()
	return mPage
end

function OnGUI()
	if not IsInit then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(519.2,36.8,526.8,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	if mPage == 1 then
		GUI.Button(88.35,38.3,134,58, "作战室", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(88.35,38.3,134,58, "作战室", GUIStyleButton.PagBtn_1) then
		mPage = 1
		AppearEvent(nil,EventType.OnRefreshGuide)
	end
	
	if mPage == 2  then
		GUI.Button(232.95,38.3,134,58, "休息室", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(232.95,38.3,134,58, "休息室", GUIStyleButton.PagBtn_1) then
		mPage = 2
		AppearEvent(nil,EventType.OnRefreshGuide)
	end
	
	if mPage == 3  then
		GUI.Button(377,38.3,134,58, "船员榜", GUIStyleButton.PagBtn_2)
	elseif GUI.Button(377,38.3,134,58, "船员榜", GUIStyleButton.PagBtn_1) then
		mPage = 3
		AppearEvent(nil,EventType.OnRefreshGuide)
	end
	
	local hero = mHeroManager.GetHero()
	if mPage == 1 then
		local spacing = 93
		-- if GUI.Button(151, 134, 40, 59,nil, GUIStyleButton.LeftBtn) then
			-- mScrollPositionX = mScrollPositionX - spacing * 6
		-- end
		-- if GUI.Button(951, 134, 40, 59,nil, GUIStyleButton.RightBtn) then
			-- mScrollPositionX = mScrollPositionX + spacing * 6
		-- end

		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
		GUI.DrawTexture(185-24,124,776+48,82,image, 0, 0, 1, 1, 15, 15, 15, 15)
		
		local mFightSailors = mSailorManager.GetFightSailors()
		if not mSailorManager.GetSailorByDuty(mSelectIndex) then
			mSelectIndex = 1
			UpdateAutoEquip()
		end
		local sailorFightCount = mCommonlyFunc.GetSailorFightCount(hero.level)
		local fightCount = math.min(sailorFightCount+1, 11)
		local count = 11
		-- if count < 7 then
			-- count = 7
		-- end
		
		mScrollPositionX,_ = GUI.BeginScrollView(189-24,98,763+48,145, mScrollPositionX, 0, 0, 0,count*spacing+10, 0)
			for index=1,count,1 do
				local x = spacing * (index - 1)
				local y = 0
				
				DrawSailor(x, y, index, sailorFightCount, mFightSailors[index])
				
				if mDutyIndex == index then -- 新上阵船员绘制动画
					GUI.FrameAnimation_Once(x-53, y-40,256 * 0.85, 256 * 0.85,'SailorAttend',SelectAniStartTime,8,0.1,3)	
				end
			end
		GUI.EndScrollView()

		local selectSailor = mSailorManager.GetSailorByDuty(mSelectIndex)
		local image = mAssetManager.GetAsset("Texture/GUI/Bg/sailorBg_6")
		GUI.DrawTexture(236, 212, 344,416, image)
		local image = mAssetManager.GetAsset("Texture/Character/Pic/"..selectSailor.resId, AssetType.Pic)
		GUI.DrawTexture(266, 232, 286, 360, image)
		
		-- if selectSailor.duty ~= 1 and GUI.Button(475,236,82,60,nil,GUIStyleButton.ChangeSailorBtn) then
			-- SaiorDuty(selectSailor.duty)
		-- end
		
		local equips = mEquipManager.GetEquipsBySid(selectSailor.id)
		for index=1,6 do  -- 装备栏
			local equip = nil
			if equips then
				equip = equips[index]
			end
			-- print(index)
			local x = math.floor((index-1)/3)*420 + 160
			local y = (index-1)%3*135 + 226
			DrawEquip(x, y, equip, index, selectSailor)
		end
		
		
		
		if mHaveBetterEquip and GUI.Button(394,535,156,29,nil, GUIStyleButton.AutoSelect) then
			-- mSailorViewPanel.SetData(selectSailor)
			-- mPanelManager.Show(mSailorViewPanel)
			
			for k,equip in pairs(mBetterEquipList) do
				mEquipManager.RequestWearEquip(equip.index, selectSailor.id)
			end
		end
		
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
		GUI.DrawTexture(685,212,298,398,image, 0, 0, 1, 1, 15, 15, 15, 15)
		
		GUI.Label(768, 231, 144.2, 25, selectSailor.name , GUIStyleLabel.Center_30_Redbean)
		local color = ConstValue.QualityColorStr[selectSailor.quality]
		local infoStr = mCommonlyFunc.BeginColor(color)
		infoStr = infoStr .. ConstValue.Quality[selectSailor.quality]
		infoStr = infoStr .. mCommonlyFunc.EndColor()
		GUI.Label(766, 283-10, 64.2, 25, infoStr, GUIStyleLabel.Left_30_White_Art, Color.Black)
		GUI.Label(706, 290-10, 64.2, 25, "品质：", GUIStyleLabel.Left_20_Black)
		

		-- local infoStr = mCommonlyFunc.GetSailorStarInfo(selectSailor.exLevel)
		-- GUI.Label(766, 320-10, 64.2, 25, infoStr, GUIStyleLabel.Left_30_White_Art, Color.Black)
		GUI.Label(706, 327-10, 64.2, 25, "等级: ", GUIStyleLabel.Left_20_Black)
		GUI.Label(766, 327-10, 64.2, 25, selectSailor.exLevel.."级", GUIStyleLabel.Left_20_Black)
		
		GUI.Label(866, 327-10, 64.2, 25, "星级: ", GUIStyleLabel.Left_20_Black)
		GUI.Label(866+60, 327-10, 64.2, 25, selectSailor.star.."星", GUIStyleLabel.Left_20_Black)
		
		GUI.Label(706, 364-10, 64.2, 25, "属性：", GUIStyleLabel.Left_20_Black) -- 船员属性
		local infoStr = Language[33]..selectSailor.attack
		GUI.Label(722, 398-10, 129.2, 25, infoStr, GUIStyleLabel.Left_20_Black)
		local infoStr = Language[34]..selectSailor.defense
		GUI.Label(866, 398-10, 129.2, 25, infoStr, GUIStyleLabel.Left_20_Black)
		local infoStr = Language[35]..selectSailor.hp
		GUI.Label(722, 430-10, 129.2, 25, infoStr, GUIStyleLabel.Left_20_Black)
		local infoStr = Language[36]..selectSailor.business
		GUI.Label(866, 430-10, 129.2, 25, infoStr, GUIStyleLabel.Left_20_Black)
		
		GUI.Label(706, 465-10, 129, 25, "技能: ", GUIStyleLabel.Left_20_Black)
		GUI.Label(722, 490-10, 250, 25, selectSailor.skillDesc1, GUIStyleLabel.Left_20_White) -- 船员面板技能左竖列
		GUI.Label(866, 490-10, 250, 25, selectSailor.skillDesc2, GUIStyleLabel.Left_20_White) -- 船员面板技能右竖列
		
		local infoStr = Language[28].. selectSailor.power
		GUI.Label(417, 568, 124.2, 25, infoStr, GUIStyleLabel.Right_20_White, Color.Black)
		
		
		if GUI.Button(719,552,111,60,"查看", GUIStyleButton.ShortOrangeBtn) then
			mSailorViewPanel.SetData(selectSailor)
			mPanelManager.Show(mSailorViewPanel)
		end
		
		if selectSailor.type == SailorType.Hero then -- 船员的主角按钮不同
			if GUI.Button(847,552,111,60,"升阶", GUIStyleButton.ShortOrangeBtn) then
				if selectSailor.quality == 4 then
					mSystemTip.ShowTip("品质已最高")
				else
					local itemId = ConstValue.QualityUpItem[selectSailor.quality]
					local item = mItemManager.GetItemById(itemId)
					if item then
						mItemManager.UseItem(item)
					else
						local copyMapId = mCopyMapManager.GetMaxCopyMapIdByAward(0, itemId)
						local copyMap = CFG_copyMap[copyMapId]
						local copyMapLevel = CFG_copyMapLevel[copyMap.level]
						
						if hero.SceneType ~= SceneType.Harbor then
							mAlert.Show("通关"..copyMapLevel.name.."副本获得潜力丹,在港口内才能挑战副本",
								function()
									mPanelManager.Show(mCopyMapPanel)
									mPanelManager.Hide(OnGUI)
								end ,
								function()
									mHeroManager.GotoHarbor()
									mPanelManager.Show(mMainPanel)
									mPanelManager.Hide(OnGUI)
									mSceneManager.SetMouseEvent(true)
								end ,"打副本","回港口")
						else
							mAlert.Show("通关"..copyMapLevel.name.."副本获得潜力丹,挑战副本?",
								function()
									mPanelManager.Show(mCopyMapPanel)
									mPanelManager.Hide(OnGUI)
								end,nil,"前往")
						end
					end
				end
			end
		else
			if GUI.Button(847,552,111,60,"更换", GUIStyleButton.ShortOrangeBtn) then
				local duty = selectSailor.duty
				local x,id = GetSelect()
				function SelectFunc(sailor)
					if sailor then
						mSailorManager.RequestSetDuty(sailor.id, duty)
						SetSelectAni(id)
					end
					SetSelect(x, id)
					mPanelManager.Show(OnGUI)
				end
				
				mSailorSelectPanel.SetData(SelectFunc)  -- 传值
				mPanelManager.Show(mSailorSelectPanel)  -- 打开选择界面
				mPanelManager.Hide(OnGUI) -- 关闭
			end
		end
		
		if GUI.Button(225,220,720,400,nil, GUIStyleButton.Transparent) then -- 透明按钮，点任意信息会查看详细信息，放在最后，GUI先绘制的按钮在上方
			mSailorViewPanel.SetData(selectSailor)
			mPanelManager.Show(mSailorViewPanel)
		end
	elseif mPage == 2 then -- 休息室
		local mSailorList = mSailorManager.GetRestSailors()
		local count = #mSailorList
		local spacing = 156
		_,mScrollPositionY = GUI.BeginScrollView(154, 136.4, 900, 460.5, 0, mScrollPositionY, 0, 0, 850, spacing * count)
			for k,sailor in pairs(mSailorList) do
				local y = (k-1)*spacing
				local showY = y - mScrollPositionY / GUI.modulus
				if showY > -spacing  and showY < spacing*3 then
					DrawResSailor(sailor, y)
				end
			end
			
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
			if count < 1 then
				GUI.DrawTexture(0,spacing*0,830,144,image)
			end
			if count < 2 then
				GUI.DrawTexture(0,spacing*1,830,144,image)
			end
			if count < 3 then
				GUI.DrawTexture(0,spacing*2,830,144,image)
			end
		GUI.EndScrollView()
	else  -- 船员榜
		local spacing = 160
		_,mScrollPositionY = GUI.BeginScrollView(131,122,950,480, 0, mScrollPositionY, 0, 0,900,(__index or 0)/6*spacing)
			__index = 0
			local list = mSailorManager.GetCfgSailorsByQuality(4)
			for i=1,(math.ceil(#list/6)+1)*6 do
				DrawCfgSailor(list[i], __index, 4)
				__index = __index + 1
			end
			local list = mSailorManager.GetCfgSailorsByQuality(3)
			for i=1,(math.ceil(#list/6)+1)*6 do
				DrawCfgSailor(list[i], __index, 3)
				__index = __index + 1
			end
			local list = mSailorManager.GetCfgSailorsByQuality(2)
			for i=1,(math.ceil(#list/6)+1)*6 do
				DrawCfgSailor(list[i], __index, 2)
				__index = __index + 1
			end
			local list = mSailorManager.GetCfgSailorsByQuality(1)
			for i=1,(math.ceil(#list/6)+1)*6 do
				DrawCfgSailor(list[i], __index, 1)
				__index = __index + 1
			end
		GUI.EndScrollView()
	end
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
	end
end



function DrawCfgSailor(sailor, index, quality) -- 绘制船员榜列表的格子
	local x = (index % 6) * 146 + 20
	local y = math.floor(index / 6) * 160 + 10
	
	local showY = y - mScrollPositionY / GUI.modulus
	if showY < -160 or showY > 480 then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..quality)
	GUI.DrawTexture(x, y, 128, 128, image) -- 品质
	if sailor then
		local image = mAssetManager.GetAsset("Texture/Character/Header/"..sailor.resId, AssetType.Pic)
		if GUI.TextureButton(x+5, y+5,100,100,image) then
			local mSailor = {}
			mSailor.index = sailor.id
			mSailor.star = 0
			mSailor.exLevel = 0
			mSailor.name = sailor.name
			mSailor.quality = sailor.quality
			mSailor.resId = sailor.resId
			mSailor.notExit = true
			
			mSailorManager.UpdateProperty(mSailor, false, 1)
			
			mSailorViewPanel.SetData(mSailor)
			mPanelManager.Show(mSailorViewPanel)
		end
		GUI.Label(x+6, y+116, 100, 100, sailor.name, GUIStyleLabel.Center_19_White, Color.Black)
		
		-- if	quality == 3 then
		-- textureFiled = "item_purple"
		-- GUI.FrameAnimation(x-18, y-22,150, 150,textureFiled,8,0.1)
		-- end
		if	quality == 4 then
		textureFiled = "item_orange"
		GUI.FrameAnimation(x-20, y-20,150, 150,textureFiled,8,0.1)
	end
		if mSailorManager.GetSailorByIndex(sailor.id) then
			local image = mAssetManager.GetAsset("Texture/Gui/Text/get_4")
			GUI.DrawTexture(x-20, y-10, 128, 64, image)
		end
	else
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg45_1")
		GUI.DrawTexture(x+5, y+5, 100, 100, image)
	end
end

function DrawSailor(x, y, index, sailorFightCount, sailor) -- 绘制船员头像框
	-- local char = nil
	if index <= sailorFightCount then
		if sailor then
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_"..sailor.quality)
			GUI.DrawTexture(x+14, y+26, 80, 80, image)
			local image = mAssetManager.GetAsset("Texture/Character/Header/"..sailor.resId, AssetType.Pic)
			if GUI.TextureButton(x+19, y+31,70,70,image) then
				mSelectIndex = sailor.duty
				UpdateAutoEquip()
				AppearEvent(nil,EventType.OnRefreshGuide)
			end

			if mSelectIndex == sailor.duty then -- 选定的英雄会画出蓝色框
				local image = mAssetManager.GetAsset("Texture/Gui/Bg/select3")
				GUI.DrawTexture(x+4,y+16,100,100,image)
			end
		else -- 绘制未上阵的空位
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_0")
			if GUI.TextureButton(x+14, y+26, 80, 80, image) then
				SaiorDuty(index) -- 上阵
			end
			GUI.Label(x+14, y+26, 80, 80, "船员\n上阵", GUIStyleLabel.MCenter_25_White_Art)
		end
		
	else -- 绘制未开启的栏位，加锁
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_0")
		if GUI.TextureButton(x+14,y+26,80,80,image) then
			local level = mCommonlyFunc.GetSailorFightLevel(index)
			mSystemTip.ShowTip(level.."级时开启该阵位", Color.LimeStr)
		end
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg18_1")
		GUI.DrawTexture(x+18.5,y+35,71,68,image)
	end
end

function SaiorDuty(index)  -- 空位置上阵船员
	if #mSailorManager.GetBusinessSailors() == 0 then
		mSystemTip.ShowTip("没有空闲船员", Color.RedStr)
		return
	end

	local x,id = GetSelect()
	function SelectFunc(sailor)
		if sailor then -- 选择的话
			mSailorManager.RequestSetDuty(sailor.id, index)
			-- print("!!!")
			SetSelectAni(index)
		end
		SetSelect(x, id)
		mPanelManager.Show(OnGUI)
	end
		
	mSailorSelectPanel.SetData(SelectFunc)
	mPanelManager.Show(mSailorSelectPanel)
	mPanelManager.Hide(OnGUI)
end

function DrawEquip(x, y, equip, index, selectSailor)
	if equip then
		local cfg_Equip = CFG_Equip[equip.id]
		-- local image = mAssetManager.GetAsset("Texture/Icon/Equip/"..cfg_Equip.icon, AssetType.Icon)
		-- GUI.DrawTexture(x+7, y+5, 70, 70, image)
		-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_"..cfg_Equip.quality)
		-- if GUI.TextureButton(x,y,80,80,image) then
			-- mEquipViewPanel.SetData(selectSailor, equip, OnGUI)
			-- mPanelManager.Show(mEquipViewPanel)
		-- end
		-- local image = mAssetManager.GetAsset("Texture/Icon/Equip/"..cfg_Equip.icon, AssetType.Icon)
		-- GUI.DrawTexture(x+5,y+5,70, 70, image)
		if DrawItemCell(cfg_Equip, ItemType.Equip, x,y,80,80,true,false,false) then
			mEquipViewPanel.SetData(selectSailor, equip, OnGUI)
			mPanelManager.Show(mEquipViewPanel)
		end
		GUI.Label(x, y+85, 84, 30, cfg_Equip.name, GUIStyleLabel.Center_20_White, Color.Black)
	else
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_0")
		if GUI.TextureButton(x,y,80,80,image) then
			local list = mEquipManager.GetEquipsByType(index)
			if #list == 0 then
				mSystemTip.ShowTip("没有该类装备", Color.RedStr)
				return
			end
			
			local x = mScrollPositionX
			local sailorId = selectSailor.id
			function SelectFunc(equip)
				if equip then
					mEquipManager.RequestWearEquip(equip.index, sailorId)
				end
				mScrollPositionX = x
				mSelectIndex = selectSailor.duty
				mPanelManager.Show(OnGUI)
			end
			
			mEquipSelectPanel.SetData(selectSailor, index, SelectFunc)
			mPanelManager.Show(mEquipSelectPanel)
			mPanelManager.Hide(OnGUI)
		end
		
		GUI.Label(x,y+25, 80, 30, ConstValue.EquipType[index], GUIStyleLabel.Center_30_White_Art, Color.Black)
		GUI.Label(x, y+85, 84, 30, Language[99], GUIStyleLabel.Center_20_White, Color.Black)
	end
end

function DrawResSailor(sailor, y)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,830,144,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..sailor.quality)
	GUI.DrawTexture(34.45, y+17,128,128,image)
	
	local image = mAssetManager.GetAsset("Texture/Character/Header/"..sailor.resId, AssetType.Icon)
	-- GUI.DrawTexture(39.45, y+22, 100, 100, image)
	if GUI.TextureButton(39.45, y+22, 100, 100, image) then
		mSailorViewPanel.SetData(sailor)
		mPanelManager.Show(mSailorViewPanel)
	end
	
	GUI.Label(170, y+14, 74.2, 30, sailor.name, GUIStyleLabel.Left_35_Redbean_Art)
	
	-- if	sailor.quality == 3 then
	-- textureFiled = "item_purple"
	-- GUI.FrameAnimation(35-18, y-8,150, 150,textureFiled,8,0.1)
	-- end
	if	sailor.quality == 4 then
	textureFiled = "item_orange"
	GUI.FrameAnimation(35-20, y-3,150, 150,textureFiled,8,0.1)
	end
	
	local color = ConstValue.QualityColorStr[sailor.quality]
	local infoStr = mCommonlyFunc.BeginColor(color)
	infoStr = infoStr .. ConstValue.Quality[sailor.quality]
	infoStr = infoStr .. mCommonlyFunc.EndColor()
	GUI.Label(230, y+58, 64.2, 25, infoStr, GUIStyleLabel.Left_30_White_Art, Color.Black)
	GUI.Label(170, y+65, 64.2, 25, "品质:", GUIStyleLabel.Left_20_Black)
	
	local infoStr = Language[28].. sailor.power
	GUI.Label(170, y+103, 129.2, 25, infoStr, GUIStyleLabel.Left_20_Black)

	if GUI.Button(660, y+36, 130, 64,"查看", GUIStyleButton.ShortOrangeArtBtn) then
		mSailorViewPanel.SetData(sailor)
		mPanelManager.Show(mSailorViewPanel)
	end
	-- if GUI.Button(490, y+36, 130, 64,"炼魂", GUIStyleButton.ShortOrangeArtBtn) then
		-- function okFunc()
			-- mSailorManager.RequestFire(sailor.id) -- 解雇角色
		-- end
		
		-- local color = ConstValue.QualityColorStr[sailor.quality]
		-- local logStr = "是否确定将"
		-- logStr = logStr .. mCommonlyFunc.BeginColor(color)
		-- logStr = logStr .. sailor.name
		-- logStr = logStr .. mCommonlyFunc.EndColor()
		-- logStr = logStr .. "变成魂魄?"
		-- mAlert.Show(logStr, okFunc)
	-- end
end

function UpdateAutoEquip()
	local selectSailor = mSailorManager.GetSailorByDuty(mSelectIndex)
	if not selectSailor then
		return
	end
	mBetterEquipList[1] = mEquipManager.GetBetterEquip(selectSailor.id, 1)
	mBetterEquipList[2] = mEquipManager.GetBetterEquip(selectSailor.id, 2)
	mBetterEquipList[3] = mEquipManager.GetBetterEquip(selectSailor.id, 3)
	mBetterEquipList[4] = mEquipManager.GetBetterEquip(selectSailor.id, 4)
	mBetterEquipList[5] = mEquipManager.GetBetterEquip(selectSailor.id, 5)
	mBetterEquipList[6] = mEquipManager.GetBetterEquip(selectSailor.id, 6)
	
	mHaveBetterEquip = mBetterEquipList[1] or mBetterEquipList[2] or mBetterEquipList[3] or mBetterEquipList[4] or mBetterEquipList[5] or mBetterEquipList[6]
end

function GetSlotPosition(type)
	local x = math.floor((type-1)/3)*420 + 160
	local y = (type-1)%3*135 + 226
	return x, y 
end

-- function requestSetDuty(id, set)
	-- local cs_ByteArray = ByteArray.Init()
	-- ByteArray.WriteByte(cs_ByteArray,PackatHead.SAILOR)
	-- ByteArray.WriteByte(cs_ByteArray,Packat_Sailor.CLIENT_REQUEST_SET_SAILOR_DUTY)
	-- ByteArray.WriteInt(cs_ByteArray,id)
	-- ByteArray.WriteByte(cs_ByteArray,set)
	-- mNetManager.SendData(cs_ByteArray)
-- end