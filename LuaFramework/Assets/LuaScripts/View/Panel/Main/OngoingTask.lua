local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,GUIStyleLabel,tostring,type,UnityEventType,Event,tonumber = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,GUIStyleLabel,tostring,type,UnityEventType,Event,tonumber
local SceneType,CFG_item,GUIStyleButton,ConstValue,os,Vector3,_G,table,GUIUtility,Vector2,CFG_role,CFG_map = 
SceneType,CFG_item,GUIStyleButton,ConstValue,os,Vector3,_G,table,GUIUtility,Vector2,CFG_role,CFG_map
local AssetType,AppearEvent,EventType,CFG_Exp,ActionType,CsWorldToScreenPoint,CsCurrentEventEqualsType = 
AssetType,AppearEvent,EventType,CFG_Exp,ActionType,CsWorldToScreenPoint,CsCurrentEventEqualsType
local CFG_harbor,string,AssetPath,platform,IPhonePlayer,IosTestScript,ActivityType,ActivityName = 
CFG_harbor,string,AssetPath,platform,IPhonePlayer,IosTestScript,ActivityType,ActivityName
local mAssetManager = nil
local mSystemTip = nil
local mGUIStyleManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mAlert = nil
local mHeroManager = nil
local mSetManager = nil
local mHarborManager = nil
local mSailorPanel = nil
local mTreasureManager = nil
local mHeroPanel = nil
local mLoginAwardPanel = nil
local mActivityManager = nil
local mActivityPanel = nil
local ActivityIconPath = ActivityIconPath
local serverTime  = nil
local mActivityList = nil
local mLoginInfo = nil
local timeTable = nil
local mhero = nil
local mHarborSignupPanel = nil

local OngoingTaskGUIopen = false
local OngoingTaskSwitch = true
	
local skewY = 0

module("LuaScript.View.Panel.Main.OngoingTask",package.seeall) -- 持续中的活动提示

local mSeekTreasure = nil -- 藏宝图寻宝界面

local See1,See2,See3,See4,See5,See6,See7 = true,true,true,true,true,true,true

function Init()
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mAlert = require "LuaScript.View.Alert.Alert"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
	mTreasureManager = require "LuaScript.Control.Scene.TreasureManager"
	mHeroPanel = require "LuaScript.View.Panel.HeroPanel"
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	mLoginAwardPanel = require "LuaScript.View.Panel.Activity.LoginAward.LoginAwardPanel"
	mActivityPanel = require "LuaScript.View.Panel.Activity.ActivityPanel"
	mSeekTreasure = require "LuaScript.View.Panel.SeekTreasure.SeekTreasurePanel"
	mHarborSignupPanel = require "LuaScript.View.Panel.Activity.HarborBattle.HarborSignupPanel"
	mActivityList = mActivityManager.GetActivityList()
	mLoginInfo = mHeroManager.GetLoginAward()
	serverTime = mActivityManager.GetServerTime()
	
	IsInit = true
end

function Display()
	serverTime = mActivityManager.GetServerTime()
	mActivityList = mActivityManager.GetActivityList()
	mLoginInfo = mHeroManager.GetLoginAward()
end

function OpenSwitch(switch)
    OngoingTaskSwitch = switch
end

function OnGUI()
	
	if not Init then
		return
	end

	if not serverTime then
		print('获取时间失败')
		return
	end

	timeTable = os.date("*t", serverTime)

    local mHero = mHeroManager.GetHero()

    if mHero.SceneType == SceneType.Harbor then -- 港口界面位置偏移
	   skewY = 125
	elseif mHero.protectState then -- 出现保护倒计时偏移
	   skewY = 80
	else
	   skewY = 0 
	end
	
    local OngoingList = 1
    local spacing = 80
	local ButtonSpacing = 80
	local maxWidth = 1100
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn16_1")
	if OngoingTaskSwitch then 
		image = mAssetManager.GetAsset("Texture/Gui/Button/btn16_1") 
	elseif not OngoingTaskSwitch then 
		image = mAssetManager.GetAsset("Texture/Gui/Button/btn17_1")
	end
	GUI.DrawTexture(1136 - 38,skewY+12,36,66,image)
	if GUI.Button(1136-36,skewY+10,38,70,nil,GUIStyleButton.Transparent) then
		OngoingTaskSwitch = not OngoingTaskSwitch
	end
	
	if not OngoingTaskSwitch then
		return
	end
	
	--活动
	local count = #mActivityList
	--鱼和风靡全球 前置
	for index=1,count,1 do
		local activity = mActivityList[index]
		if activity.state then
			if activity.id == ActivityType.GOODS then
				local image = mAssetManager.GetAsset(ActivityIconPath[activity.id])
				GUI.DrawTexture(maxWidth - (spacing * OngoingList ) - 35 , -18 + skewY,128,128,image)
				if GUI.Button(1136 - (ButtonSpacing * OngoingList ) - 35 , 15 + skewY, 76, 76, nil, GUIStyleButton.Transparent) then
					mActivityPanel.SetData(activity.id)
					mPanelManager.Show(mActivityPanel)
					mPanelManager.Hide(mMainPanel)
					mSceneManager.SetMouseEvent(false)
					Display()
				end 
				OngoingList = OngoingList + 1
			elseif activity.id == ActivityType.Fish then
				local image = mAssetManager.GetAsset(ActivityIconPath[activity.id])
				GUI.DrawTexture(maxWidth - (spacing * OngoingList ) - 35 , -18 + skewY,128,128,image)
				if GUI.Button(1136 - (ButtonSpacing * OngoingList ) - 35 , 15 + skewY, 76, 76, nil, GUIStyleButton.Transparent) then
					mActivityPanel.SetData(activity.id)
					mPanelManager.Show(mActivityPanel)
					mPanelManager.Hide(mMainPanel)
					mSceneManager.SetMouseEvent(false)
					Display()
				end 
				OngoingList = OngoingList + 1
			end
		end
	end
	
	
	for index=1,count,1 do
		local activity = mActivityList[index]
		    if (activity.state) and OngoingList < 8  then
				 if activity.id == ActivityType.GOODS then	
				 elseif activity.id == ActivityType.Fish then
				 elseif activity.id == ActivityType.LevelAward then
					if See7 then
						local image = mAssetManager.GetAsset(ActivityIconPath[activity.id])
						GUI.DrawTexture(maxWidth - (spacing * OngoingList ) - 35 , -18 + skewY,128,128,image)
						if GUI.Button(1136 - (ButtonSpacing * OngoingList ) - 35 , 15 + skewY, 76, 76, nil, GUIStyleButton.Transparent) then
							mActivityPanel.SetData(activity.id)
							mPanelManager.Show(mActivityPanel)
							mPanelManager.Hide(mMainPanel)
							mSceneManager.SetMouseEvent(false)
							See7 = false
							Display()
						end 
						OngoingList = OngoingList + 1
					end
				 elseif activity.id == ActivityType.HarborBattle then -- 港口争霸
					local image = mAssetManager.GetAsset(ActivityIconPath[9])
					if timeTable.hour >= 16 and timeTable.hour < 20	then
						 image = mAssetManager.GetAsset(ActivityIconPath[17])
					elseif timeTable.hour >= 20 and timeTable.hour < 21 then
						 See6 = true
					     image = mAssetManager.GetAsset(ActivityIconPath[9])
					end
					if See6 then
					GUI.DrawTexture(maxWidth - (spacing * OngoingList ) - 35, -18 + skewY,128,128,image)
					if GUI.Button(1136 - (ButtonSpacing * OngoingList ) - 35 , 15 + skewY, 76, 76, nil, GUIStyleButton.Transparent) then
						mActivityPanel.SetData(ActivityType.HarborBattle)
						mPanelManager.Show(mActivityPanel)
						mPanelManager.Hide(mMainPanel)
						mPanelManager.Show(mHarborSignupPanel)
						mSceneManager.SetMouseEvent(false)
						-- See6 = false -- 是否点击后隐藏
						Display()
					end
					OngoingList = OngoingList + 1
					end
				 elseif activity.id == ActivityType.MonthCard then
						local mMonthCard = mHeroManager.GetMonthCard()
						-- print(mMonthCard)
						-- print(serverTime)
						local et1 = mMonthCard.monthCardEndTime1  --大于 serverTime  则已购买
						local get1 = mMonthCard.monthCardGet1 	--0未领取奖励 1已领取
						local et2 = mMonthCard.monthCardEndTime2  -- 等于-1时已购买
						local get2 = mMonthCard.monthCardGet2     --0未领取奖励 1已领取
						if et1== nil or	et2== nil or get1== nil or get2 == nil then
							return -- 刚开始游戏短暂延迟未接收到数据会报错，这里做限制
						end
						if et1 > serverTime  or  et2 == -1 then -- 购买过领取后消失
							if	get1 == 0 and  et1 > serverTime then
								local image = mAssetManager.GetAsset(ActivityIconPath[activity.id])
								GUI.DrawTexture(maxWidth - (spacing * OngoingList ) - 35 , -18 + skewY,128,128,image)
								if GUI.Button(1136 - (ButtonSpacing * OngoingList ) - 35 , 15 + skewY, 76, 76,nil, GUIStyleButton.Transparent) then
									mActivityPanel.SetData(ActivityType.MonthCard)
									mPanelManager.Show(mActivityPanel)
									mPanelManager.Hide(mMainPanel)
									mSceneManager.SetMouseEvent(false)
									Display()
								end 
								OngoingList = OngoingList + 1
							elseif get2 == 0 and  et2 == -1  then
								local image = mAssetManager.GetAsset(ActivityIconPath[activity.id])
								GUI.DrawTexture(maxWidth - (spacing * OngoingList ) - 35 , -18 + skewY,128,128,image)
								if GUI.Button(1136 - (ButtonSpacing * OngoingList ) - 35 , 15 + skewY, 76, 76,nil, GUIStyleButton.Transparent) then
									mActivityPanel.SetData(ActivityType.MonthCard)
									mPanelManager.Show(mActivityPanel)
									mPanelManager.Hide(mMainPanel)
									mSceneManager.SetMouseEvent(false)
									Display()
								end 
								OngoingList = OngoingList + 1
							end
						elseif See1 then -- 没购买的时候点一次后消失
							if	et1 < serverTime or  et2 ~= -1 then
							local image = mAssetManager.GetAsset(ActivityIconPath[activity.id])
							GUI.DrawTexture(maxWidth - (spacing * OngoingList ) - 35 , -18 + skewY,128,128,image)
							if GUI.Button(1136 - (ButtonSpacing * OngoingList ) - 35 , 15 + skewY, 76, 76,nil, GUIStyleButton.Transparent) then
								mActivityPanel.SetData(ActivityType.MonthCard)
								mPanelManager.Show(mActivityPanel)
								mPanelManager.Hide(mMainPanel)
								mSceneManager.SetMouseEvent(false)
								See1 = false
								Display()
							end 
							OngoingList = OngoingList + 1
							end
						end						
				 elseif activity.id == ActivityType.RechangeAward then
				 		if	See2 then
						  local image = mAssetManager.GetAsset(ActivityIconPath[activity.id])
							GUI.DrawTexture(maxWidth - (spacing * OngoingList ) - 35 , -18 + skewY,128,128,image)
							if GUI.Button(1136 - (ButtonSpacing * OngoingList ) - 35 , 15 + skewY, 76, 76, nil, GUIStyleButton.Transparent) then
								mActivityPanel.SetData(activity.id)
								mPanelManager.Show(mActivityPanel)
								mPanelManager.Hide(mMainPanel)
								mSceneManager.SetMouseEvent(false)
								See2 = false
								Display()
							end 
							OngoingList = OngoingList + 1
						end	
				 elseif activity.id == ActivityType.CostAward then
						if	See3 then
						  local image = mAssetManager.GetAsset(ActivityIconPath[activity.id])
							GUI.DrawTexture(maxWidth - (spacing * OngoingList ) - 35 , -18 + skewY,128,128,image)
							if GUI.Button(1136 - (ButtonSpacing * OngoingList ) - 35 , 15 + skewY, 76, 76, nil, GUIStyleButton.Transparent) then
								mActivityPanel.SetData(activity.id)
								mPanelManager.Show(mActivityPanel)
								mPanelManager.Hide(mMainPanel)
								mSceneManager.SetMouseEvent(false)
								See3 = false
								Display()
							end 
							OngoingList = OngoingList + 1
						end	
				 elseif activity.id == ActivityType.Gamble then
						if	See4 then
						  local image = mAssetManager.GetAsset(ActivityIconPath[activity.id])
							GUI.DrawTexture(maxWidth - (spacing * OngoingList ) - 35 , -18 + skewY,128,128,image)
							if GUI.Button(1136 - (ButtonSpacing * OngoingList ) - 35 , 15 + skewY, 76, 76, nil, GUIStyleButton.Transparent) then
								mActivityPanel.SetData(activity.id)
								mPanelManager.Show(mActivityPanel)
								mPanelManager.Hide(mMainPanel)
								mSceneManager.SetMouseEvent(false)
								See4 = false
								Display()
							end 
							OngoingList = OngoingList + 1
						end	
				 elseif activity.id == ActivityType.RMBShop then
						 if See5 then
						  local image = mAssetManager.GetAsset(ActivityIconPath[activity.id])
							GUI.DrawTexture(maxWidth - (spacing * OngoingList ) - 35 , -18 + skewY,128,128,image)
							if GUI.Button(1136 - (ButtonSpacing * OngoingList ) - 35 , 15 + skewY, 76, 76, nil, GUIStyleButton.Transparent) then
								mActivityPanel.SetData(activity.id)
								mPanelManager.Show(mActivityPanel)
								mPanelManager.Hide(mMainPanel)
								mSceneManager.SetMouseEvent(false)
								See5 = false
								Display()
							end 
							OngoingList = OngoingList + 1
						 end
				 else
					local image = mAssetManager.GetAsset(ActivityIconPath[activity.id])
					GUI.DrawTexture(maxWidth - (spacing * OngoingList ) - 35 , -18 + skewY,128,128,image)
				    if GUI.Button(1136 - (ButtonSpacing * OngoingList ) - 35 , 15 + skewY, 76, 76, nil, GUIStyleButton.Transparent) then
					    mActivityPanel.SetData(activity.id)
						mPanelManager.Show(mActivityPanel)
						mPanelManager.Hide(mMainPanel)
						mSceneManager.SetMouseEvent(false)
						Display()
					end 
					OngoingList = OngoingList + 1
				 end
		    end
	end
	
	 --藏宝图提示
	local getTreasure = mTreasureManager.getTreasure()
						-- if true then
							-- return
						-- end
    if getTreasure then
	    local image = mAssetManager.GetAsset(ActivityIconPath[18])
		GUI.DrawTexture(maxWidth - (spacing * OngoingList ) - 35 , -18 + skewY,128,128,image)
	     if GUI.Button(1136 - (ButtonSpacing * OngoingList ) - 35 , 15 + skewY, 76, 76, nil, GUIStyleButton.Transparent) then
			mPanelManager.Show(mSeekTreasure)
			Display()
		end 
		OngoingList = OngoingList + 1
	end
	--签到
	mLoginInfo = mHeroManager.GetLoginAward()
	if not mLoginInfo.geted then
		local image = mAssetManager.GetAsset(ActivityIconPath[20])
		GUI.DrawTexture(maxWidth - (spacing * OngoingList ) - 35 , -18 + skewY,128,128,image)
		if GUI.Button(1136 - (ButtonSpacing * OngoingList ) - 35 , 15 + skewY, 76, 76, nil, GUIStyleButton.Transparent) then
			mPanelManager.Show(mLoginAwardPanel)
			mPanelManager.Hide(mMainPanel)
			Display()
		end 
		-- DrawRedPoint(1136 - (ButtonSpacing * OngoingList ) - 35 + 50, 15 + skewY, 1)
		OngoingList = OngoingList + 1
	end
end



function DrawRedPoint(x, y, count)
	if count <= 1 then
		return
	end
	x = x
	y = y
	local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg25_1)
	GUI.DrawTexture(x, y, 32, 32, image)
	GUI.Label(x, y+5, 32, 32, count, GUIStyleLabel.Center_22_White)
end