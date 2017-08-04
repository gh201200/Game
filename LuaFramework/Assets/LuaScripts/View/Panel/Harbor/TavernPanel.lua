local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,PackatHead,Packat_Account,ByteArray,table,ConstValue = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,PackatHead,Packat_Account,ByteArray,table,ConstValue
local GUIStyleLabel,Packat_Sailor,CFG_buildDesc,GUIStyleButton,AppearEvent,EventType,os,platform,IPhonePlayer = 
GUIStyleLabel,Packat_Sailor,CFG_buildDesc,GUIStyleButton,AppearEvent,EventType,os,platform,IPhonePlayer
local AssetType,CFG_randomTask,CFG_item,CFG_UniqueSailor,string,IosTestScript,ReplaceString = 
AssetType,CFG_randomTask,CFG_item,CFG_UniqueSailor,string,IosTestScript,ReplaceString
local DrawItemCell,ItemType,CFG_sailorInvite = DrawItemCell,ItemType,CFG_sailorInvite
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mHarborManager = nil
local mSailorPanel = nil
local mPanelManager = nil
local mSailorManager = nil
local mSceneManager = nil
local mHeroManager = nil
local mNetManager = nil
local mAlert = nil
local mSystemTip = nil
local mSetManager = nil
local mSelectAlert = nil
local mItemViewPanel = nil
local mTaskManager = nil
local mActionManager = nil
local mEquipSelectPanel = nil
local mDialogPanel = nil
local mVipManager = nil
local mSailorViewPanel = nil
local mItemManager = nil

local mMainPanel = nil
module("LuaScript.View.Panel.Harbor.TavernPanel") --酒馆招募页面
FullWindowPanel = true
local mRefreshing = false
local mCostTip = nil
local mScrollPositionY = 0
-- freeRefreshCount = 1
mPage = 1
function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mSailorManager = require "LuaScript.Control.Data.SailorManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mTaskManager = require "LuaScript.Control.Data.TaskManager"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	mEventManager = require "LuaScript.Control.EventManager"
	mActionManager = require "LuaScript.Control.ActionManager"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mDialogPanel = require "LuaScript.View.Panel.Task.DialogPanel"
	mVipManager = require "LuaScript.Control.Data.VipManager"
	mSailorViewPanel = require "LuaScript.View.Panel.Sailor.SailorViewPanel"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	
	mEventManager.AddEventListen(nil, EventType.Refreshed, Refreshed)
	mEventManager.AddEventListen(nil, EventType.ConnectFailure, Refreshed)
	IsInit = true
	
	-- InitSailor()
end

function Refreshed()
	mRefreshing = false
end

function Display()
	mCostTip = mSetManager.GetCostTip()
end

function Hide()
	mPage = 1
end

function OnGUI()
	if not IsInit then
		return
	end
	local hero = mHeroManager.GetHero()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	
	if mActionManager.GetActionOpen(10) then
		local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
		GUI.DrawTexture(519.2,36.8,526.8,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
		
		if mPage == 1 then
			GUI.Button(88.35,38.3,134,58, "招募", GUIStyleButton.PagBtn_2)
		elseif GUI.Button(88.35,38.3,134,58, "招募", GUIStyleButton.PagBtn_1) then
			mPage = 1
			AppearEvent(nil,EventType.OnRefreshGuide)
		end
		
		if mPage == 2  then
			GUI.Button(232.95,38.3,134,58, "悬赏", GUIStyleButton.PagBtn_2)
		elseif GUI.Button(232.95,38.3,134,58, "悬赏", GUIStyleButton.PagBtn_1) then
			mPage = 2
			AppearEvent(nil,EventType.OnRefreshGuide)
		end
		--屏蔽纳贤功能
		--[[if mPage == 3  then
			GUI.Button(377,38.3,134,58, "纳贤", GUIStyleButton.PagBtn_2)
		elseif GUI.Button(377,38.3,134,58, "纳贤", GUIStyleButton.PagBtn_1) then
			mPage = 3
			mSailorManager.RequestExchangeList()
		end--]]
		
		if mPage == 4  then
			GUI.Button(377,38.3,134,58, "船员榜", GUIStyleButton.PagBtn_2)
		elseif GUI.Button(377,38.3,134,58, "船员榜", GUIStyleButton.PagBtn_1) then
			mPage = 4
		end
	else -- 未开启后续功能的时候开启的标题栏
		local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
		GUI.DrawTexture(83.5,37.5,1016.75-50,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
		
		GUI.Label(525.5,48,84.2,30,"酒馆", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	end
	--以下处理面板中事件
	if mPage == 1 then -- 招募
		local freeEmployInfo = mSailorManager.GetFreeEmployInfo()
		-- 1
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/sailor_1")
		GUI.DrawTexture(144,125,297,499,image)
		
		--ios test script
		if not IosTestScript then
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/gold")
			GUI.DrawTexture(249,435,41,28,image)
		end
		
		local info = mCommonlyFunc.GetQualityStr(1) .. "  " .. mCommonlyFunc.GetQualityStr(2)
			 .. "  " .. mCommonlyFunc.GetQualityStr(3)
		GUI.Label(204,485,175,0,info,GUIStyleLabel.Center_25_White_Art, Color.Black)
		--ios test script
		if not IosTestScript then
			GUI.Label(295,434,194,0,CFG_sailorInvite[1].buyGold,GUIStyleLabel.Left_25_Yellowish, Color.Black)
		end
		GUI.Label(223,461,194,0,"可招募船员品质",GUIStyleLabel.Left_20_White, Color.Black)
		
		local cd = freeEmployInfo.freeTime1 - os.oldClock + freeEmployInfo.updateTime
		if freeEmployInfo.freeCount1 <= 0 then
			GUI.Label(227,570,127,0,"今日免费次数已用完",GUIStyleLabel.Center_25_Orange, Color.Black)
		elseif cd <= 0 then
			local info = "今日免费" .. freeEmployInfo.freeCount1 .. "次"
			GUI.Label(227,570,127,0,info,GUIStyleLabel.Center_25_Orange, Color.Black)
		else
			local info = mCommonlyFunc.GetFormatTime(cd).."后免费"
			GUI.Label(227,570,127,0,info,GUIStyleLabel.Center_25_Orange, Color.Black)
		end
		
		if GUI.Button(209,506,166,77,nil, GUIStyleButton.BlueBtn) then
			RefreshSailor(1)
		end
		local image = mAssetManager.GetAsset("Texture/Gui/Text/employ")
		GUI.DrawTexture(248,516,84,45,image)
		
		-- 2
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/sailor_2")
		GUI.DrawTexture(425,125,297,499,image)
		--ios test script
		if not IosTestScript then
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/gold")
			GUI.DrawTexture(522,435,41,28,image)
		end
		
		local info = mCommonlyFunc.GetQualityStr(2) .. "  " .. mCommonlyFunc.GetQualityStr(3)
			 .. "  " .. mCommonlyFunc.GetQualityStr(4)
		GUI.Label(480,485,175,0,info,GUIStyleLabel.Center_25_White_Art, Color.Black)
		--ios test script
		if not IosTestScript then
			GUI.Label(568,434,194,0,CFG_sailorInvite[2].buyGold,GUIStyleLabel.Left_25_Yellowish, Color.Black)
		end
		GUI.Label(499,461,194,0,"可招募船员品质",GUIStyleLabel.Left_20_White, Color.Black)
		local cd = freeEmployInfo.freeTime2 - os.oldClock + freeEmployInfo.updateTime
		if freeEmployInfo.freeCount2 > 0 or cd <= 0 then
			GUI.Label(509,570,127,0,"本次招募免费",GUIStyleLabel.Center_25_Orange, Color.Black)
		else
			local info = mCommonlyFunc.GetFormatTime(cd).."后免费"
			GUI.Label(509,570,127,0,info,GUIStyleLabel.Center_25_Orange, Color.Black)
		end
		
		if GUI.Button(490,506,166,77,nil, GUIStyleButton.BlueBtn) then
			RefreshSailor(2)
		end
		local image = mAssetManager.GetAsset("Texture/Gui/Text/employ")
		GUI.DrawTexture(532,516,84,45,image)
		
		-- 3
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/sailor_3")
		GUI.DrawTexture(708,125,297,499,image)
		--ios test script
		if not IosTestScript then
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/gold")
			GUI.DrawTexture(815,435,41,28,image)
			GUI.Label(860,434,194,0,CFG_sailorInvite[3].buyGold,GUIStyleLabel.Left_25_Yellowish, Color.Black)
		end
		
		--ios test script
		if not hero.firstRefreshSailor and not IosTestScript then
			GUI.Label(761,471,194,0,"首次刷新必得"..mCommonlyFunc.GetQualityStr(4),GUIStyleLabel.Left_25_White, Color.Black)
		else
			local info = mCommonlyFunc.GetQualityStr(3) .. "  " .. mCommonlyFunc.GetQualityStr(4)
			GUI.Label(774,485,175,0,info,GUIStyleLabel.Center_25_White_Art, Color.Black)
			GUI.Label(794,461,194,0,"可招募船员品质",GUIStyleLabel.Left_20_White, Color.Black)
		end
		
		local cd = freeEmployInfo.freeTime3 - os.oldClock + freeEmployInfo.updateTime
		if cd <= 0 then
			GUI.Label(794,570,127,0,"本次招募免费",GUIStyleLabel.Center_25_Orange, Color.Black)
		else
			local info = mCommonlyFunc.GetFormatTime(cd).."后免费"
			GUI.Label(794,570,127,0,info,GUIStyleLabel.Center_25_Orange, Color.Black)
		end
		
		if GUI.Button(778,506,166,77,nil, GUIStyleButton.BlueBtn) then
			RefreshSailor(3)
		end
		local image = mAssetManager.GetAsset("Texture/Gui/Text/employ")
		GUI.DrawTexture(820,516,84,45,image)
	elseif mPage == 2 then -- 悬赏
		local task,taskInfo = mTaskManager.GetRandomTask()
		local cfg_randomTask = CFG_randomTask[taskInfo.id]
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/taskBg")
		GUI.DrawTexture(72,115,989,512,image)
		
		GUI.Label(592,247,144,0,cfg_randomTask.name,GUIStyleLabel.Center_35_Redbean_Art)
		
		GUI.Label(391,283,194.15,0,"品质:",GUIStyleLabel.Left_25_Black)
		GUI.Label(391,320,194.15,0,"描述:",GUIStyleLabel.Left_25_Black)
		GUI.Label(391,413,194.15,0,"奖励:",GUIStyleLabel.Left_25_Black)
		
		local color = ConstValue.QualityColorStr[taskInfo.quality]
		local infoStr = mCommonlyFunc.BeginColor(color)
		infoStr = infoStr .. ConstValue.Quality[taskInfo.quality]
		infoStr = infoStr .. mCommonlyFunc.EndColor()
		GUI.Label(462, 281, 54, 25, infoStr, GUIStyleLabel.Left_30_White_Art, Color.Black)
		GUI.Label(459, 320, 490,0, ReplaceString(cfg_randomTask.targetDesc, "param" ,"0"),GUIStyleLabel.Left_25_White_WordWrap, Color.Black)
		
		local image = mAssetManager.GetAsset("Texture/Icon/Item/23")
		GUI.DrawTexture(467,414,80,80,image,0,0,1,1,6,6,6,6)
		local exp,money = mCommonlyFunc.GetRandomTaskAward(taskInfo.quality) 
		GUI.Label(457, 500, 100, 30, "经验", GUIStyleLabel.Center_25_Black)
		GUI.Label(442, 470, 100, 30, exp, GUIStyleLabel.Right_20_White, Color.Black)
		
		local image = mAssetManager.GetAsset("Texture/Icon/Item/14")
		GUI.DrawTexture(570,414,80,80,image,0,0,1,1,6,6,6,6)
		GUI.Label(560, 500, 100, 30, "银两", GUIStyleLabel.Center_25_Black)
		GUI.Label(545, 470, 100, 30, money, GUIStyleLabel.Right_20_White, Color.Black)
		
		
		
		mRandomTaskAward = mRandomTaskAward or {{id=28,count=3}, {id=3,count=4}, {id=8,count=3}, {id=27,count=1}}
		-- if taskInfo.quality == 4 then
			DrawAward(662, mRandomTaskAward[taskInfo.quality])
		-- end
		
		-- if taskInfo.quality == 3 then
			-- DrawAward(662, CFG_item[27])
		-- end
		
		-- if taskInfo.quality == 2 then
			-- DrawAward(662, CFG_item[27])
		-- end
		
		-- if taskInfo.quality == 1 then
			-- DrawAward(662, CFG_item[3])
		-- end
		
		if taskInfo.lastCount > 0 then
			GUI.Label(820, 500, 100, 30, "今日剩余"..taskInfo.lastCount.."次", GUIStyleLabel.Left_20_White, Color.Black)
		else
			GUI.Label(820, 500, 100, 30, "今日悬赏已完成", GUIStyleLabel.Left_20_Red, Color.Black)
		end
		
		if not task then
			local oldEnabled = GUI.GetEnabled()
			if taskInfo.lastCount <= 0 then
				GUI.SetEnabled(false)
			end
			if GUI.Button(433,540,113,52,nil, GUIStyleButton.GetBtn) then
				mTaskManager.RequestAddRandomTask()
			end
			
			local freeRefresh = mVipManager.GetFreeRefresh()
			if freeRefresh > 0 then
				GUI.Label(635, 585, 113, 52, "本次刷新免费", GUIStyleLabel.Center_20_Lime, Color.Black)
			end
			if GUI.Button(635,540,113,52,nil, GUIStyleButton.RefreshBtn) then
				if not (freeRefresh > 0) and not mCommonlyFunc.HaveGold(CFG_sailorInvite[1].buyGold) then
					return
				end
				if not (freeRefresh > 0) and mCostTip then
					--ios test script
					if IosTestScript then
						mSystemTip.ShowTip("今日免费刷新次数已用完")
						return
					end
					function okFun(showTip)
						mTaskManager.RequestRefreshRandomTask()
						mCostTip = not showTip
					end
					mSelectAlert.Show("是否花费20元宝刷新悬赏任务", okFun)
				else
					if taskInfo.quality >= 4 then
						mAlert.Show("当前为史诗悬赏任务,是否刷新?", mTaskManager.RequestRefreshRandomTask)
					else
						mTaskManager.RequestRefreshRandomTask()
					end
				end
			end
			if taskInfo.lastCount <= 0 then
				GUI.SetEnabled(oldEnabled)
			end
		else
			if GUI.Button(433,540,113,52,nil, GUIStyleButton.CompleteBtn) then
				if not mCommonlyFunc.HaveGold(CFG_sailorInvite[1].buyGold) then
					return
				end
				if mCostTip then
					function okFun(showTip)
						mTaskManager.RequestFastCompleteRandomTask()
						mCostTip = not showTip
					end
					mSelectAlert.Show("是否花费20元宝快速完成悬赏任务", okFun)
				else
					mTaskManager.RequestFastCompleteRandomTask()
				end
			end
			
			if cfg_randomTask.target[1] == 27 and GUI.Button(635,540,113,52,nil, GUIStyleButton.GiveBtn) then
				function selectFunc(equip)
					if equip then
						mTaskManager.RequipGiveEquip(equip.index)
					end
					mPanelManager.Show(OnGUI)
					mPage = 2
				end
				mEquipSelectPanel.SetData(nil, cfg_randomTask.target[2], selectFunc, false)
				mPanelManager.Show(mEquipSelectPanel)
				mPanelManager.Hide(OnGUI)
			elseif mTaskManager.CouldFly(task) and GUI.Button(635,540,113,52,nil, GUIStyleButton.MoveBtn_2) then
				mTaskManager.AutoMove(nil,nil,task)
			end
			
			if GUI.Button(822,540,113,52,nil, GUIStyleButton.GiveUpBtn) then
				mTaskManager.RequestGiveUp()
			end
		end
	elseif mPage == 3 then -- 推荐信纳贤
		-- local excEmployInfo = mSailorManager.GetExcEmployInfo()
		-- local count = mItemManager.GetItemCountById(245)
		-- GUI.Label(170, 131, 100, 30, string.format("举荐信:%d(招募到相同船员有几率获得)", count), GUIStyleLabel.Left_30_Redbean_Art)
		-- GUI.Label(800, 131, 100, 30, string.format("每日凌点刷新"), GUIStyleLabel.Left_30_Redbean_Art)
		-- if excEmployInfo then
			-- DrawExcSailor(excEmployInfo[1], 158, 171)
			-- DrawExcSailor(excEmployInfo[2], 158, 318)
			-- DrawExcSailor(excEmployInfo[3], 158, 468)
		-- end
	elseif mPage == 4 then
		local spacing = 160
		_,mScrollPositionY = GUI.BeginScrollView(131,122,950,480, 0, mScrollPositionY, 0, 0,900,(index or 0)/6*spacing)
			index = 0
			local list = mSailorManager.GetCfgSailorsByQuality(4)
			for i=1,(math.ceil(#list/6)+1)*6 do
				DrawSailor(list[i], index, 4)
				index = index + 1
			end
			local list = mSailorManager.GetCfgSailorsByQuality(3)
			for i=1,(math.ceil(#list/6)+1)*6 do
				DrawSailor(list[i], index, 3)
				index = index + 1
			end
			local list = mSailorManager.GetCfgSailorsByQuality(2)
			for i=1,(math.ceil(#list/6)+1)*6 do
				DrawSailor(list[i], index, 2)
				index = index + 1
			end
			local list = mSailorManager.GetCfgSailorsByQuality(1)
			for i=1,(math.ceil(#list/6)+1)*6 do
				DrawSailor(list[i], index, 1)
				index = index + 1
			end
		GUI.EndScrollView()
	end
	if GUI.Button(1109.5-50,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
	end
end


function DrawExcSailor(sailorId, x, y)
	local sailor = CFG_UniqueSailor[sailorId]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(x,y,826,134,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..sailor.quality)
	GUI.DrawTexture(x+22, y+10,128,128,image)
	
	local image = mAssetManager.GetAsset("Texture/Character/Header/"..sailor.resId, AssetType.Icon)
	if GUI.TextureButton(x+26, y+14, 100, 100, image) then
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
	
	GUI.Label(x+183, y+14, 74.2, 30, sailor.name, GUIStyleLabel.Left_35_Redbean_Art)
	GUI.Label(x+178, y+63, 371, 63, sailor.desc, GUIStyleLabel.Left_25_LightBrown_WordWrap)

	GUI.Label(x+614, y+20, 74.2, 30, "需要举荐信:"..sailor.excCount, GUIStyleLabel.Left_25_Black)
	
	local oldEnabled = GUI.GetEnabled()
	if mSailorManager.GetSailorByIndex(sailor.id) then
		local image = mAssetManager.GetAsset("Texture/Gui/Text/get_4")
		GUI.DrawTexture(x, y, 128, 64, image)
		GUI.SetEnabled(false)
	end
	if GUI.Button(x+618, y+57, 166, 77, "招募", GUIStyleButton.BlueBtn) then
		local count = mItemManager.GetItemCountById(245)
		if count < sailor.excCount then
			mSystemTip.ShowTip("举荐信不足")
			return
		else
			mSailorManager.RequestExchange(sailorId)
		end
	end
	if mSailorManager.GetSailorByIndex(sailor.id) then
		GUI.SetEnabled(oldEnabled)
	end
end

function DrawSailor(sailor, index, quality)
	local x = (index % 6) * 146 + 20
	local y = math.floor(index / 6) * 160 + 10
	
	local showY = y - mScrollPositionY / GUI.modulus
	if showY < -160 or showY > 480 then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..quality)
	GUI.DrawTexture(x, y, 128, 128, image)
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
		
		if	quality == 3 then
		textureFiled = "item_purple"
		GUI.FrameAnimation(x-19, y-22,150, 150,textureFiled,8,0.1)
		end
		if	quality == 4 then
		textureFiled = "item_orange"
		GUI.FrameAnimation(x-18, y-21,150, 150,textureFiled,8,0.1)
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

-- function InitSailor()
	-- if mSailorList then
		-- return
	-- end
	-- mSailorList = {{},{},{},{}}
	-- for k,v in pairs(CFG_UniqueSailor) do
		-- if v.resId ~= -1 and v.show == 1 then
			-- table.insert(mSailorList[v.quality], v)
		-- end
	-- end
	-- table.sort(mSailorList[1],SortFunc)
	-- table.sort(mSailorList[2],SortFunc)
	-- table.sort(mSailorList[3],SortFunc)
	-- table.sort(mSailorList[4],SortFunc)
-- end

function SortFunc(a,b)
	if a.power ~= b.power then
		return a.power > b.power
	end
	return a.id > b.id
end

function DrawAward(x, item)
	local cfg_item = CFG_item[item.id]
	-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
	-- if GUI.TextureButton(x+10,414,80,80,image,0,0,1,1,6,6,6,6) then
		-- mItemViewPanel.SetData(cfg_item.id)
		-- mPanelManager.Show(mItemViewPanel)
	-- end
	DrawItemCell(item, ItemType.Item, x + 10, 414,80,80)
	GUI.Label(x, 500, 100, 30, cfg_item.name, GUIStyleLabel.Center_25_Black)
end


function RefreshSailor(type) -- 抽取角色
	if mRefreshing then
		return
	end
	local freeEmployInfo = mSailorManager.GetFreeEmployInfo()
	
	function OkFunc(showTip)
		SureRefreshSailor(type)
		mCostTip = not showTip
	end
	
	if type == 1 then
		local cd = freeEmployInfo.freeTime1 - os.oldClock + freeEmployInfo.updateTime
		--ios test script
		if IosTestScript and cd > 0 then
			mSystemTip.ShowTip("船员招募处于冷却中")
			return
		end
		
		if freeEmployInfo.freeCount1 <= 0 or cd > 0 then
			if not mCommonlyFunc.HaveGold(CFG_sailorInvite[1].buyGold) then
				return
			end
		end
		if mCostTip and (freeEmployInfo.freeCount1 <= 0 or cd > 0) then
			mSelectAlert.Show("是否花费"..CFG_sailorInvite[1].buyGold.."元宝,招募船员", OkFunc)
		else
			SureRefreshSailor(type)
		end
	elseif type == 2 then
		local cd = freeEmployInfo.freeTime2 - os.oldClock + freeEmployInfo.updateTime
		--ios test script
		if IosTestScript and freeEmployInfo.freeCount2 == 0 and cd > 0 then
			mSystemTip.ShowTip("船员招募处于冷却中")
			return
		end
		
		if freeEmployInfo.freeCount2 == 0 and cd > 0 then
			if not mCommonlyFunc.HaveGold(CFG_sailorInvite[2].buyGold) then
				return
			end
		end
		
		if freeEmployInfo.freeCount2 == 0 and mCostTip and cd > 0 then
			mSelectAlert.Show("是否花费"..CFG_sailorInvite[2].buyGold.."元宝,招募船员", OkFunc)
		else
			SureRefreshSailor(type)
		end
	elseif type == 3 then
		local cd = freeEmployInfo.freeTime3 - os.oldClock + freeEmployInfo.updateTime
		--ios test script
		if IosTestScript and cd > 0 then
			mSystemTip.ShowTip("船员招募处于冷却中")
			return
		end
		
		if cd > 0 then
			if not mCommonlyFunc.HaveGold(CFG_sailorInvite[3].buyGold) then
				return
			end
		end
		
		if mCostTip and cd > 0 then
			mSelectAlert.Show("是否花费"..CFG_sailorInvite[3].buyGold.."元宝,招募船员", OkFunc)
		else
			SureRefreshSailor(type)
		end
	end
	-- end
	-- if HaveGoodSailor() and not forced then
		
		-- mAlert.Show("有高级船员未招募,确认刷新?",OkFunc)
		-- return
	-- end
	-- SureRefreshSailor(type)
end

function SureRefreshSailor(type)
	mRefreshing = true
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.SAILOR)
	ByteArray.WriteByte(cs_ByteArray,Packat_Sailor.CLIENT_REQUEST_EMPLOY_SAILOR)
	ByteArray.WriteByte(cs_ByteArray,type)
	mNetManager.SendData(cs_ByteArray)
	
	-- AppearEvent(nil, EventType.OnTavernRefresh, type)
end