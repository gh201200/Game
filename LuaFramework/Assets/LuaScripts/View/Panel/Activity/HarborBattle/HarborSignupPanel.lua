local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os
local CFG_ship,CFG_buildDesc,CFG_harbor,PackatHead,Packat_Harbor,GUIStyleButton,ConstValue,Packat_Ship,error,EventType = 
CFG_ship,CFG_buildDesc,CFG_harbor,PackatHead,Packat_Harbor,GUIStyleButton,ConstValue,Packat_Ship,error,EventType
local AssetType,AppearEvent,string,SceneType,CFG_UniqueSailor = AssetType,AppearEvent,string,SceneType,CFG_UniqueSailor
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mNetManager = nil
local mHeroManager = nil
local mShipManager = nil
local mCharManager = nil
local mCommonlyFunc = nil
local mViewShipPanel = nil
local mGoodsManager = nil
local mLabManager = nil
local mAlert = nil
local mSelectAlert = nil
local mSystemTip = nil
local mSetManager = nil
local mActivityPanel = nil
local mHarborSignupMoneyPanel = nil
local mHarborViewPanel = nil

module("LuaScript.View.Panel.Activity.HarborBattle.HarborSignupPanel") -- 港口争霸竞标界面
panelType = ConstValue.AlertPanel

local mSignupInfo = nil
local mScrollPositionY = 0
local mPage = 1
local mHarborList = nil
local mShowSelfHarbor = true

-- IsInit = false
function Init()

	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mGoodsManager = require "LuaScript.Control.Data.GoodsManager"
	mLabManager = require "LuaScript.Control.Data.LabManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mShipManager = require "LuaScript.Control.Data.ShipManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mViewShipPanel = require "LuaScript.View.Panel.Harbor.ShipViewPanel"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mEventManager = require "LuaScript.Control.EventManager"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mHarborSignupMoneyPanel = require "LuaScript.View.Panel.Activity.HarborBattle.HarborSignupMoneyPanel"
	mActivityPanel = require "LuaScript.View.Panel.Activity.ActivityPanel"
	mHarborViewPanel = require "LuaScript.View.Panel.Harbor.HarborViewPanel"
	
	mNetManager.AddListen(PackatHead.HARBOR, Packat_Harbor.SEND_ALL_SIGNUP_INFO, SEND_ALL_SIGNUP_INFO)
	mNetManager.AddListen(PackatHead.HARBOR, Packat_Harbor.SEND_SIGNUP_INFO, SEND_SIGNUP_INFO)
	mNetManager.AddListen(PackatHead.HARBOR, Packat_Harbor.SEND_HARBORWAR_SIGN_RLT, SEND_HARBORWAR_SIGN_RLT)
	
	IsInit = true
end


function SEND_ALL_SIGNUP_INFO(cs_ByteArray)
	print("SEND_ALL_SIGNUP_INFO")
	mSignupInfo = {}
	mSignupInfo.state = ByteArray.ReadByte(cs_ByteArray)
	mSignupInfo.harbors = {}
	mSignupInfo.harborsById = {}
	
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count do
		local harbor = {}
		harbor.harborId = ByteArray.ReadInt(cs_ByteArray)
		-- harbor.type = ByteArray.ReadByte(cs_ByteArray)
		-- harbor.name = ByteArray.ReadUTF(cs_ByteArray, 40)
		harbor.money = ByteArray.ReadInt(cs_ByteArray)
		harbor.money2 = ByteArray.ReadInt(cs_ByteArray)
		-- harbor.id = ByteArray.ReadInt(cs_ByteArray)
		harbor.masterType = ByteArray.ReadByte(cs_ByteArray)
		harbor.masterName = ByteArray.ReadUTF(cs_ByteArray, 40)
		harbor.shopLevel = ByteArray.ReadByte(cs_ByteArray)
		harbor.level = ByteArray.ReadByte(cs_ByteArray)
		harbor.count = ByteArray.ReadInt(cs_ByteArray)
		
		if harbor.masterName == "" then
			-- local cfg_harbor = CFG_harbor[harbor.harborId]
			-- local cfg_sailor = CFG_UniqueSailor[cfg_harbor.masterId]
			harbor.masterName = mHarborManager.GetHarborMasterName(harbor.harborId)
			harbor.masterType = 2
		end
		
		local masterName = mCommonlyFunc.BeginColor(Color.Brown2Str) .. harbor.masterName
		masterName = masterName .. mCommonlyFunc.BeginColor(Color.DeepBlueStr)
		masterName = masterName .. ConstValue.SignuperType[harbor.masterType]
		masterName = masterName .. mCommonlyFunc.EndColor()
		masterName = masterName .. mCommonlyFunc.EndColor()
		harbor.masterName = masterName

		table.insert(mSignupInfo.harbors, harbor)
		mSignupInfo.harborsById[harbor.harborId] = harbor
	end
	
	Refresh()
end

function SEND_HARBORWAR_SIGN_RLT(cs_ByteArray)
	print("SEND_HARBORWAR_SIGN_RLT")
	mSignupInfo = {}
	mSignupInfo.state = 2
	mSignupInfo.harbors = {}
	mSignupInfo.harborsById = {}
	
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count do
		local harbor = {}
		harbor.harborId = ByteArray.ReadInt(cs_ByteArray)
		harbor.type = ByteArray.ReadByte(cs_ByteArray)
		harbor.name = ByteArray.ReadUTF(cs_ByteArray, 40)
		harbor.money = ByteArray.ReadInt(cs_ByteArray)
		harbor.id = ByteArray.ReadInt(cs_ByteArray)
		harbor.masterType = ByteArray.ReadByte(cs_ByteArray)
		harbor.masterName = ByteArray.ReadUTF(cs_ByteArray, 40)
		harbor.shopLevel = ByteArray.ReadByte(cs_ByteArray)
		harbor.level = ByteArray.ReadByte(cs_ByteArray)
		
		if harbor.masterName == "" then
			-- local cfg_harbor = CFG_harbor[harbor.harborId]
			-- local cfg_sailor = CFG_UniqueSailor[cfg_harbor.masterId]
			harbor.masterName = mHarborManager.GetHarborMasterName(harbor.harborId)
			harbor.masterType = 2
		end
		
		local masterName = mCommonlyFunc.BeginColor(Color.Brown2Str) .. harbor.masterName
		masterName = masterName .. mCommonlyFunc.BeginColor(Color.DeepBlueStr)
		masterName = masterName .. ConstValue.SignuperType[harbor.masterType]
		masterName = masterName .. mCommonlyFunc.EndColor()
		masterName = masterName .. mCommonlyFunc.EndColor()
		harbor.masterName = masterName
		
		local name = mCommonlyFunc.BeginColor(Color.Brown2Str) .. harbor.name
		name = name .. mCommonlyFunc.BeginColor(Color.DeepBlueStr)
		name = name .. ConstValue.SignuperType[harbor.type]
		name = name .. mCommonlyFunc.EndColor()
		name = name .. mCommonlyFunc.EndColor()
		harbor.name = name
		
		table.insert(mSignupInfo.harbors, harbor)
		mSignupInfo.harborsById[harbor.harborId] = harbor
	end
	
	Refresh()
end

function SEND_SIGNUP_INFO(cs_ByteArray)
	-- print("SEND_SIGNUP_INFO")
	local harborId = ByteArray.ReadInt(cs_ByteArray)
	-- local type = ByteArray.ReadByte(cs_ByteArray)
	local money = ByteArray.ReadInt(cs_ByteArray)
	local money2 = ByteArray.ReadInt(cs_ByteArray)
	local masterType = ByteArray.ReadByte(cs_ByteArray)
	local masterName = ByteArray.ReadUTF(cs_ByteArray, 40)
	local shopLevel = ByteArray.ReadByte(cs_ByteArray)
	local level = ByteArray.ReadByte(cs_ByteArray)
	local count = ByteArray.ReadInt(cs_ByteArray)
	
	local harbor = mSignupInfo.harborsById[harborId]
	harbor.harborId = harborId
	-- harbor.type = type
	harbor.money = money
	harbor.money2 = money2
	harbor.shopLevel = shopLevel
	harbor.level = level
	harbor.count = count
end

function Display()
	mHarborManager.RequestSignupInfo()
end

function Hide()
	mHarborManager.RequestCloseSignup()
	mScrollPositionY = 0
	mPage = 1
end

function Refresh()
	if not mSignupInfo then
		return
	end
	
	local minLevel = 0
	local maxLevel = 0
	if mPage == 1 then
		minLevel = 0
		maxLevel = 11
	elseif mPage == 2 then
		minLevel = 10
		maxLevel = 21
	elseif mPage == 3 then
		minLevel = 20
		maxLevel = 36
	end
	mHarborList = {}
	for k,harbor in pairs(mSignupInfo.harbors) do
		if harbor.level > minLevel and harbor.level < maxLevel then 
			table.insert(mHarborList, harbor)
		end
	end
	
	-- for k ,item in pairs (mHarborList) do 
	    -- print(item)
	-- end
	
	if	mSignupInfo.state==1 then
	   table.sort(mHarborList,sortHarborList1)-- 排序竞拍阶段
	elseif mSignupInfo.state~=1  then
	   table.sort(mHarborList,sortHarborList2)-- 排序争霸阶段
	end
end
-- level	      8         等级
-- count	      0         竞标人数
-- harborId	179   179       港口ID
-- masterType     0         0个人 1联盟 2 NPC
-- shopLevel      8			主城收益等级，根据等级获得不同每日收益
-- money2	      0         本联盟最高出价
-- masterName  	  亨利王子>(NPC)  所属人
-- money	      0         个人最高出价
function sortHarborList1(a, b) -- 默认排序竞拍阶段
    local hero = mHeroManager.GetHero()
	if	a.money == b.money then
		return a.level > b.level
	end
	return math.max(a.money,a.money2) > math.max(b.money,b.money2)
end

-- level		6						港口等级
-- masterName	<>ACE<>(联盟)</color>   所有人名
-- id			10001					所属人ID
-- money		10						最终定价
-- shopLevel	6						购买等级
-- masterType	1						所属类型
-- type			0						
-- name			<米兰达·露丝<(个人)     归属人名称
-- harborId		57

function sortHarborList2(a, b) -- 默认排序争霸阶段
    local hero = mHeroManager.GetHero()
	if	a.money == 0 and b.money == 0 then
		return a.level > b.level
	end
	return  a.money > b.money 
end
--自选排序类

local SortfLevelReverse,SortLonely = false
local SortmasterType0,SortmasterType1,SortmasterType2 = false
local SelectSort = {
	[1] = {SortType='sortMasterType2List', state=false, name='优先显示NPC港口'},
	[2] = {SortType=0, state=false, name='优先显示NPC港口'},
	[3] = {SortType=0, state=false, name='优先显示NPC港口'},
	[4] = {SortType=0, state=false, name='优先显示NPC港口'},
}

function SelectHarborSort(HarborList)
    if SelectSort[1].state then
	   table.sort(HarborList,sortMasterType2List)
	else -- 恢复默认排序
	    if	mSignupInfo.state==1 then
			table.sort(HarborList,sortHarborList1)-- 排序竞拍阶段
		elseif mSignupInfo.state~=1  then
			table.sort(HarborList,sortHarborList2)-- 排序争霸阶段
		end
	end
	return mHarborList
end

function sortMasterType2List(a, b) 
    local hero = mHeroManager.GetHero()
	if a.masterType == b.masterType then
		return a.level > b.level
	end
	return a.masterType > b.masterType 
end

function OnGUI()
	if not IsInit or mHarborViewPanel.visible then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/tabBg")
	GUI.DrawTexture(256,31-15,390,66,image)
	
	if mPage == 1 then
		GUI.Button(276,49-15,111,53, "低级", GUIStyleButton.SelectBtn_6)
	elseif GUI.Button(276,49-15,111,53, "低级", GUIStyleButton.SelectBtn_5) then
		mPage = 1
		mScrollPositionY = 0
		Refresh()
		mHarborList = SelectHarborSort(mHarborList)
	end
	
	if mPage == 2  then
		GUI.Button(393,49-15,111,53, "中级", GUIStyleButton.SelectBtn_6)
	elseif GUI.Button(393,49-15,111,53, "中级", GUIStyleButton.SelectBtn_5) then
		mPage = 2
		mScrollPositionY = 0
		Refresh()
		mHarborList = SelectHarborSort(mHarborList)
	end
	
	if mPage == 3  then
		GUI.Button(509,49-15,111,53, "高级", GUIStyleButton.SelectBtn_6)
	elseif GUI.Button(509,49-15,111,53, "高级", GUIStyleButton.SelectBtn_5) then
		mPage = 3
		mScrollPositionY = 0
		Refresh()
		mHarborList = SelectHarborSort(mHarborList)
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg23_1")
	GUI.DrawTexture(146,68,848,524,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg30_1")
	GUI.DrawTexture(187,98,757,443,image)
	
	if mHarborList then
		local spacing = 135
		local count = index or #mHarborList
		_,mScrollPositionY = GUI.BeginScrollView(204, 103, 760, 400, 0, mScrollPositionY, 0, 0, 723, spacing * count)
			index = 0
			for k,harbor in pairs(mHarborList) do
				if mShowSelfHarbor or not mHarborManager.HarborIsMy(harbor.harborId) then 
					local y = index*spacing
					local showY = y - mScrollPositionY / GUI.modulus
					if showY > -spacing  and showY < spacing*3 then
						DrawHarbor(y, harbor)
					end
					index = index + 1
				end
			end
			
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
			if count < 1 then
				GUI.DrawTexture(0,0,712,129,image)
			end
			if count < 2 then
				GUI.DrawTexture(0,spacing,712,129,image)
			end
			if count < 3 then
				GUI.DrawTexture(0,spacing*2,712,129,image)
			end
		GUI.EndScrollView()
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn19_1")
	GUI.DrawTexture(535,519,59,16,image)
	
	if mShowSelfHarbor then
		if GUI.Button(710, 506, 208, 33, nil, GUIStyleButton.HideSelfHarbor) then
			mShowSelfHarbor = false
		end
	else
		if GUI.Button(735, 506, 183, 33, nil, GUIStyleButton.ShowSelfHarbor) then
			mShowSelfHarbor = true
		end
	end
	
	--if GUI.Button(200, 508, 80, 40, SelectSort[1].name, GUIStyleButton.ShortOrangeArtBtn) then
	 --  SelectSort[1].state = not SelectSort[1].state
	  -- mHarborList = SelectHarborSort(mHarborList)
	--end
	
	if GUI.Button(913, 57, 77, 63, nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end

function DrawHarbor(y, harbor)
	local hero = mHeroManager.GetHero()
	local cfg_harbor = CFG_harbor[harbor.harborId]
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,712,129,image)
	
	-- local level = mHarborManager.GetHarborLevel(harbor.harborId)
	-- local key = math.min(math.ceil(harbor.level / 10), 3)
	
	--港口的图标和点击详细介绍
	local image = mAssetManager.GetAsset("Texture/Icon/Harbor/"..cfg_harbor.resId)
	if GUI.TextureButton(15,y-8,128,128,image) then
		mHarborViewPanel.SetData(harbor.harborId,harbor.level,harbor.shopLevel)
		mPanelManager.Show(mHarborViewPanel)
	end
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	-- GUI.DrawTexture(0,y,128,128,image)
	
	-- 港口的名称，括号中等级小写
	local str = cfg_harbor.name
	str = str .. mCommonlyFunc.BeginSize(20)
	str = str .. "(LV.".. harbor.level .. ")"
	str = str .. mCommonlyFunc.EndSize()
	if mHarborManager.HarborIsMy(harbor.harborId) then
		GUI.Label(138, y+12, 74, 30, str, GUIStyleLabel.Left_30_LightGreen_Art)
	else
		GUI.Label(138, y+12, 74, 30, str, GUIStyleLabel.Left_30_Redbean_Art)
	end
	-- for k ,item in pairs (mSignupInfo.state) do 
	    -- print(mSignupInfo.state)
	-- end
	
	if mSignupInfo.state == 1 then
		local couldSignup = true
		if harbor.money ~= 0 then
			GUI.Label(138, y+54, 200, 30, "竞标人数:", GUIStyleLabel.Left_25_DeepBlue_Art)
			GUI.Label(138, y+87, 200, 30, "本人出价:", GUIStyleLabel.Left_25_DeepBlue_Art)
			if harbor.money2 ~= 0 then
				GUI.Label(358, y+87, 200, 30, "本盟出价:", GUIStyleLabel.Left_25_DeepBlue_Art)
			end
			
			GUI.Label(255, y+54, 179, 30, harbor.count, GUIStyleLabel.Left_25_Brown2)
			GUI.Label(255, y+87, 64, 30,  string.format("%d万",harbor.money), GUIStyleLabel.Left_25_Brown2)
			if harbor.money2 ~= 0 and (not hero.familyId or hero.post < 2) then
				GUI.Label(475, y+87, 64, 30,  "?????", GUIStyleLabel.Left_25_Brown2)
			elseif harbor.money2 ~= 0 then
				GUI.Label(475, y+87, 64, 30,  string.format("%d万",harbor.money2), GUIStyleLabel.Left_25_Brown2)
			end
			
			couldSignup = false
		elseif harbor.money2 ~= 0 then
			GUI.Label(138, y+54, 200, 30, "竞标人数:", GUIStyleLabel.Left_25_DeepBlue_Art)
			GUI.Label(138, y+87, 200, 30, "本盟出价:", GUIStyleLabel.Left_25_DeepBlue_Art)
			
			GUI.Label(255, y+54, 179, 30, harbor.count, GUIStyleLabel.Left_25_Brown2)
			if not hero.familyId or hero.post < 2 then
				GUI.Label(255, y+87, 64, 30,  "?????", GUIStyleLabel.Left_25_Brown2)
			else
				GUI.Label(255, y+87, 64, 30,  string.format("%d万",harbor.money2), GUIStyleLabel.Left_25_Brown2)
				couldSignup = false
			end
		else
			GUI.Label(138, y+54, 200, 30, "竞标人数:", GUIStyleLabel.Left_25_DeepBlue_Art)
			GUI.Label(138, y+87, 200, 30, "当前领主:", GUIStyleLabel.Left_25_DeepBlue_Art)
			
			GUI.Label(255, y+54, 179, 30, harbor.count, GUIStyleLabel.Left_25_Brown2)
			GUI.Label(255, y+87, 64, 30, harbor.masterName, GUIStyleLabel.Left_25_White)
		end
		
		if couldSignup then
			local oldEnabled = GUI.GetEnabled()
			if mHarborManager.HarborIsMy(harbor.harborId) then
				GUI.SetEnabled(false)
			end
			
			if GUI.Button(578, y+37, 132, 63, "竞  标", GUIStyleButton.ShortOrangeArtBtn) then
				if not hero.familyId or hero.post < 2 then
					mHarborSignupMoneyPanel.SetData(0, harbor.harborId, 0)
					mPanelManager.Show(mHarborSignupMoneyPanel)
				else
					function OkFunc()
						mHarborSignupMoneyPanel.SetData(1, harbor.harborId, 0)
						mPanelManager.Show(mHarborSignupMoneyPanel)
					end
					function CancelFunc()
						mHarborSignupMoneyPanel.SetData(0, harbor.harborId, 0)
						mPanelManager.Show(mHarborSignupMoneyPanel)
					end
					mAlert.Show("以个人或联盟名义竞标？",OkFunc,CancelFunc,"联盟","个人")
				end
			end
			
			if mHarborManager.HarborIsMy(harbor.harborId) then
				GUI.SetEnabled(oldEnabled)
			end
		else
			if GUI.Button(578, y+7, 132, 63, "改  价", GUIStyleButton.ShortOrangeArtBtn) then
				if harbor.money ~= 0 then
					mHarborSignupMoneyPanel.SetData(0, harbor.harborId, harbor.money)
				else
					mHarborSignupMoneyPanel.SetData(1, harbor.harborId, harbor.money)
				end
				mPanelManager.Show(mHarborSignupMoneyPanel)
			end
			
			if GUI.Button(578, y+68, 132, 63, "取  消", GUIStyleButton.ShortOrangeArtBtn) then
				if harbor.money ~= 0 then
					mHarborManager.RequestCancelSignup(harbor.harborId, 0)
				else
					mHarborManager.RequestCancelSignup(harbor.harborId, 1)
				end
			end
		end
	else
		if harbor.money == 0 then
			GUI.Label(138, y+54, 200, 30, "领主:", GUIStyleLabel.Left_25_DeepBlue_Art)
			GUI.Label(138, y+87, 200, 30, "获标:", GUIStyleLabel.Left_25_DeepBlue_Art)
			GUI.Label(205, y+54, 179, 30, harbor.masterName, GUIStyleLabel.Left_25_White)
			GUI.Label(205, y+87, 64, 30,"无", GUIStyleLabel.Left_25_Brown2)
		else
			GUI.Label(138, y+54, 200, 30, "标价:", GUIStyleLabel.Left_25_DeepBlue_Art)
			GUI.Label(138, y+87, 200, 30, "获标:", GUIStyleLabel.Left_25_DeepBlue_Art)
			GUI.Label(205, y+54, 179, 30, string.format("%d万",harbor.money), GUIStyleLabel.Left_25_Brown2)
			GUI.Label(205, y+87, 64, 30, harbor.name, GUIStyleLabel.Left_25_White)
		end
	end
	
	if mSignupInfo.state ~= 1 and GUI.Button(578, y+12, 132, 53, "导航", GUIStyleButton.ShortOrangeArtBtn) then
		
		mHeroManager.SetTarget(ConstValue.PositionType, {map=cfg_harbor.mapId,x=cfg_harbor.x,y=cfg_harbor.y})
		if hero.SceneType == SceneType.Harbor then
			if mShipManager.CheckDutyShip() then
				mHarborManager.RequestLeaveHarbor()
			end
		else
			mHeroManager.Goto(cfg_harbor.mapId, cfg_harbor.x, cfg_harbor.y)
			mPanelManager.Hide(OnGUI)
			mActivityPanel.Close()
		end
	end
	
	if mSignupInfo.state ~= 1 and GUI.Button(578, y+73, 132, 53, "传送", GUIStyleButton.ShortOrangeArtBtn) then
		mHeroManager.RequestFly(cfg_harbor.mapId, cfg_harbor.x, cfg_harbor.y, 0)
	end
end