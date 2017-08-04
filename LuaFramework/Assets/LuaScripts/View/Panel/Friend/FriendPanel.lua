local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os
local CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleButton,GUIStyleTextField,string,AssetPath = 
CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleButton,GUIStyleTextField,string,AssetPath
local AssetType,GetFirstKey,CharacterType = AssetType,GetFirstKey,CharacterType
local error,EventType = error,EventType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mSceneManager = nil
local mHeroManager = nil
local mCommonlyFunc = nil
local mFriendChatPanel = nil
local mMainPanel = nil
local mCharViewPanel = nil
local mFriendFindPanel = nil
local mRelationManager = require "LuaScript.Control.Data.RelationManager"
local mAlert = nil
local mSystemTip = nil
local mEventManager = nil

module("LuaScript.View.Panel.Friend.FriendPanel")

local mScrollPositionY = 0
local mPage = 1
local mNewCount = 0
local mNewMsgList = {}
local mMouseEventState = nil

function Init()
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mFriendChatPanel = require "LuaScript.View.Panel.Friend.FriendChatPanel"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mCharViewPanel = require "LuaScript.View.Panel.View.CharViewPanel"
	-- mRelationManager = require "LuaScript.Control.Data.RelationManager"
	mFriendFindPanel = require "LuaScript.View.Panel.Friend.FriendFindPanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mEventManager = require "LuaScript.Control.EventManager"
	IsInit = true
	
	mEventManager.AddEventListen(nil, EventType.ConnectFailure, ConnectFailure)
end

function ConnectFailure()
	mNewCount = 0
	mNewMsgList = {}
end

function GetNewCount()
	return math.min(mNewCount, 99)
end

-- function SetNewCount(value)
	-- mNewCount = value
-- end

function AddEvent(mType, id, name)
	-- print(mType, id, name)
	local hero = mHeroManager.GetHero()
	if hero and hero.id == id then
		return
	end
	if mType == 0 then
		for k,v in pairs(mNewMsgList) do
			if v.id == id then
				return
			end
		end
		mNewCount = mNewCount + 1
		table.insert(mNewMsgList, 1, {type=0,id=id,name=name})
	elseif mType == 1 then
		mNewCount = mNewCount + 1
		-- print(mNewMsgList[id])
		mNewMsgList[id] = mNewMsgList[id] or {type=1,count=0}
		mNewMsgList[id].count = mNewMsgList[id].count + 1
	end
end

function RemoveNewMsg(id)
	if mNewMsgList[id] then
		mNewCount = mNewCount - mNewMsgList[id].count
		mNewMsgList[id] = nil
	end
end

function Show()
	local k = GetFirstKey(mNewMsgList)
	local v = mNewMsgList[k]
	if not k then
		mPanelManager.Hide(mMainPanel)
		mPanelManager.Show(OnGUI)
		return
	end
	if v.type == 0 then
		function OkFunc()
			mRelationManager.RequestAgree(v.id, 1)
		end
		function ChannelFunc()
			mRelationManager.RequestAgree(v.id, 0)
		end
		mAlert.Show("\""..v.name.."\"请求加你为好友", OkFunc, ChannelFunc, "同意", "拒绝")
		table.remove(mNewMsgList,k)
		
		mNewCount = mNewCount - 1
		return
	else
		mNewCount = mNewCount - v.count
		mNewMsgList[k] = nil
		
		local friend = mRelationManager.GetRelationById(k)
		if not friend then
			local str = "FriendChatPanel Error  id = " .. k .. ",type = " .. v.type .. ",count =" .. v.count
			str = str .. ",mNewCount =" .. mNewCount
			local enemys = mRelationManager.GetEnemys()
			str = str .. "\nenemys info\n"
			for k,v in pairs(enemys) do
				str = str .. v.id .. ","
			end
			local strangers = mRelationManager.GetStrangers()
			str = str .. "\nstrangers info\n"
			for k,v in pairs(strangers) do
				str = str .. v.id .. ","
			end
			local frinds = mRelationManager.GetFrinds()
			str = str .. "\nfrinds info\n"
			for k,v in pairs(frinds) do
				str = str .. v.id .. ","
			end
			error(str)
		end
		
		mFriendChatPanel.SetData(friend)
		mPanelManager.Show(mFriendChatPanel)
		return
	end

end

function Hide()
	mPage = 1
	mScrollPositionY = 0
	
	mSceneManager.SetMouseEvent(mMouseEventState)
end

function Display()
	mRelationManager.RequestFriendInfo()
	mRelationManager.RequestStrangerInfo()
	
	mMouseEventState = mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false)
end

function OnGUI()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(519.2,37.5,392.85,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	if mPage == 1 then
		GUI.Button(88.35,38.3,134,58, Language[154], GUIStyleButton.PagBtn_2)
	elseif GUI.Button(88.35,38.3,134,58, Language[154], GUIStyleButton.PagBtn_1) then
		mPage = 1
		mScrollPositionY = 0
	end
	
	if mPage == 2  then
		GUI.Button(232.95,38.3,134,58, Language[155], GUIStyleButton.PagBtn_2)
	elseif GUI.Button(232.95,38.3,134,58, Language[155], GUIStyleButton.PagBtn_1) then
		mPage = 2
		mScrollPositionY = 0
	end
	
	if mPage == 3  then
		GUI.Button(377.25,38.3,134,58, Language[156], GUIStyleButton.PagBtn_2)
	elseif GUI.Button(377.25,38.3,134,58, Language[156], GUIStyleButton.PagBtn_1) then
		mPage = 3
		mScrollPositionY = 0
	end
	

	if GUI.Button(918,38.3,134,58, Language[157], GUIStyleButton.PagBtn_1) then
		mPanelManager.Show(mFriendFindPanel)
	end
	
	local spacing = 102
	if mPage == 1 then
		GUI.Label(228,140,82.7,30,"名字", GUIStyleLabel.Left_35_Black)
		GUI.Label(508,140,111.45,30,"等级", GUIStyleLabel.Left_35_Black)
		GUI.Label(763,140,74.2,30,"操作", GUIStyleLabel.Left_35_Black)
		local mFriendList = mRelationManager.GetFrinds()
		local count = #mFriendList
		_,mScrollPositionY = GUI.BeginScrollView(154, 185.8, 900, 421.95, 0, mScrollPositionY, 0, 0, 850, spacing * count)
			for k,friend in pairs(mFriendList) do
				local y = (k-1)*spacing
				local showY = y - mScrollPositionY / GUI.modulus
				if showY > -spacing  and showY < spacing*4 then
					DrawFriend(0, y, k, friend)
				end
			end
				
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
			if count < 1 then
				GUI.DrawTexture(0,spacing*0,830,90,image)
			end
			if count < 2 then
				GUI.DrawTexture(0,spacing*1,830,90,image)
			end
			if count < 3 then
				GUI.DrawTexture(0,spacing*2,830,90,image)
			end
			if count < 4 then
				GUI.DrawTexture(0,spacing*3,830,90,image)
			end
		GUI.EndScrollView()
	elseif mPage == 2 then
		GUI.Label(228,140,82.7,30,"名字", GUIStyleLabel.Left_35_Black)
		GUI.Label(508,140,111.45,30,"等级", GUIStyleLabel.Left_35_Black)
		GUI.Label(763,140,74.2,30,"操作", GUIStyleLabel.Left_35_Black)
		local mStrangerList = mRelationManager.GetStrangers()
		local count = #mStrangerList
		_,mScrollPositionY = GUI.BeginScrollView(154, 185.8, 900, 421.95, 0, mScrollPositionY, 0, 0, 850, spacing * count)
			for k,friend in pairs(mStrangerList) do
				local y = (k-1)*spacing
				local showY = y - mScrollPositionY / GUI.modulus
				if showY > -spacing  and showY < spacing*4 then
					DrawStranger(0, y, k, friend)
				end
			end
				
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
			if count < 1 then
				GUI.DrawTexture(0,spacing*0,830,90,image)
			end
			if count < 2 then
				GUI.DrawTexture(0,spacing*1,830,90,image)
			end
			if count < 3 then
				GUI.DrawTexture(0,spacing*2,830,90,image)
			end
			if count < 4 then
				GUI.DrawTexture(0,spacing*3,830,90,image)
			end
		GUI.EndScrollView()
	elseif mPage == 3 then
		GUI.Label(228,140,82.7,30,"名字", GUIStyleLabel.Left_35_Black)
		GUI.Label(508,140,111.45,30,"等级", GUIStyleLabel.Left_35_Black)
		GUI.Label(763,140,74.2,30,"操作", GUIStyleLabel.Left_35_Black)
		local mEnemyList = mRelationManager.GetEnemys()
		local count = #mEnemyList
		_,mScrollPositionY = GUI.BeginScrollView(154, 185.8, 900, 421.95, 0, mScrollPositionY, 0, 0, 850, spacing * count)
			for k,friend in pairs(mEnemyList) do
				local y = (k-1)*spacing
				local showY = y - mScrollPositionY / GUI.modulus
				if showY > -spacing  and showY < spacing*4 then
					DrawEnemy(0, y, k, friend)
				end
			end
				
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
			if count < 1 then
				GUI.DrawTexture(0,spacing*0,830,90,image)
			end
			if count < 2 then
				GUI.DrawTexture(0,spacing*1,830,90,image)
			end
			if count < 3 then
				GUI.DrawTexture(0,spacing*2,830,90,image)
			end
			if count < 4 then
				GUI.DrawTexture(0,spacing*3,830,90,image)
			end
		GUI.EndScrollView()
	end
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
	end
end

function DrawFriend(x, y, index, friend)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,830,90,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_"..friend.quality)
	GUI.DrawTexture(12,y+5,80,80,image)
	local image = mAssetManager.GetAsset("Texture/Character/Header/"..friend.resId, AssetType.Pic)
	if GUI.TextureButton(17, y+9, 70, 70, image) then
		local char = {id=friend.id, name=friend.name, level=friend.level, type=CharacterType.Player,
			quality=friend.quality,resId=friend.resId,power=friend.power}
		mCharViewPanel.SetData(char)
		mPanelManager.Show(mCharViewPanel)
	end
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg10_1")
	-- GUI.DrawTexture(12,y+8.05,84,84,image)
	
	local level = friend.level or Language[162]
	local style1 = GUIStyleLabel.Left_30_Redbean
	local style2 = GUIStyleLabel.Center_30_Black
	if not friend.onLine then
		style1 = GUIStyleLabel.Left_30_Gray
		style2 = GUIStyleLabel.Center_30_Gray
	end
	GUI.Label(100, y+31.55, 244.2, 30, friend.name, style1)
	GUI.Label(372, y+31.55, 34.2, 30, level, style2)
	
	local msg = mNewMsgList[friend.id]
	if GUI.Button(583, y + 23, 61, 55, nil, GUIStyleButton.FriendChatBtn) then
		mFriendChatPanel.SetData(friend)
		mPanelManager.Show(mFriendChatPanel)
		
		if msg then
			mNewCount = mNewCount - msg.count
			mNewMsgList[friend.id] = nil
		end
	end
	
	if msg then
		local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg25_1)
		GUI.DrawTexture(583+32,y+22, 25, 25, image)
		GUI.Label(583+32,y+25, 25, 25, math.min(msg.count,9),GUIStyleLabel.Center_22_White)
	end
	
	if GUI.Button(653, y + 23, 61, 55, nil, GUIStyleButton.FriendDelBtn) then
		function okFunc()
			mRelationManager.RequestDelFriend(friend.id)
		end
		mAlert.Show("确定删除该好友?", okFunc)
	end
end

function DrawStranger(x, y, index, friend)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,830,90,image)
	
	if friend.quality then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_"..friend.quality)
		GUI.DrawTexture(12,y+5,80,80,image)
	else
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_0")
		GUI.DrawTexture(12,y+5,80,80,image)
	end
	
	if friend.resId then
		local image = mAssetManager.GetAsset("Texture/Character/Header/"..friend.resId, AssetType.Pic)
		if GUI.TextureButton(17, y+9, 70, 70, image) then
			local char = {id=friend.id, name=friend.name, level=friend.level, type=CharacterType.Player,
				quality=friend.quality,resId=friend.resId,power=friend.power}
			mCharViewPanel.SetData(char)
			mPanelManager.Show(mCharViewPanel)
		end
	else
		GUI.Label(17, y+9, 70, 70, "离线\n状态", GUIStyleLabel.Center_30_Gray)
	end
	
	local level = friend.level or Language[162]
	local style1 = GUIStyleLabel.Left_30_Redbean
	local style2 = GUIStyleLabel.Center_30_Black
	if not friend.onLine then
		style1 = GUIStyleLabel.Left_30_Gray
		style2 = GUIStyleLabel.Center_30_Gray
	end
	GUI.Label(100, y+31.55, 244.2, 30, friend.name, style1)
	GUI.Label(372, y+31.55, 34.2, 30, level, style2)
	
	if GUI.Button(553, y + 23, 61, 55, nil, GUIStyleButton.FriendAddBtn) then
		mRelationManager.RequestFriendById(friend.id)
	end
	local msg = mNewMsgList[friend.id]
	if GUI.Button(618, y + 23, 61, 55, nil, GUIStyleButton.FriendChatBtn) then
		mFriendChatPanel.SetData(friend)
		mPanelManager.Show(mFriendChatPanel)
		
		if msg then
			mNewCount = mNewCount - msg.count
			mNewMsgList[friend.id] = nil
		end
	end
	if msg then
		local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg25_1)
		GUI.DrawTexture(618+32,y+22, 25, 25, image)
		GUI.Label(618+32,y+25, 25, 25, math.min(msg.count,9),GUIStyleLabel.Center_22_White)
	end
	
	if GUI.Button(683, y + 23, 61, 55, nil, GUIStyleButton.FriendDelBtn) then
		mRelationManager.RequestDelStranger(friend.id)
	end
end

function DrawEnemy(x, y, index, friend)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,830,90,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_0")
	GUI.DrawTexture(12,y+5,80,80,image)
	local image = mAssetManager.GetAsset("Texture/Character/Header/"..friend.resId, AssetType.Pic)
	if GUI.TextureButton(17, y+9, 70, 70, image) then
		local char = {id=friend.id, name=friend.name, level=friend.level, type=CharacterType.Player,
			quality=friend.quality,resId=friend.resId,power=friend.power}
		mCharViewPanel.SetData(char)
		mPanelManager.Show(mCharViewPanel)
	end
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg10_1")
	-- GUI.DrawTexture(12,y+8.05,84,84,image)
	
	GUI.Label(100, y+31.55, 244.2, 30, friend.name, GUIStyleLabel.Left_30_Gray_Art)
	GUI.Label(372, y+31.55, 34.2, 30, Language[162], GUIStyleLabel.Center_30_Gray)
	
	if GUI.Button(583, y + 23, 61, 55, nil, GUIStyleButton.FriendFindBtn) then
		function OkFunc()
			if mCommonlyFunc.HaveGold(10) then
				mRelationManager.RequestEnemyInfo(friend.id)
			end
		end
		mAlert.Show("是否花费10元宝查探仇敌信息?", OkFunc)
		-- mSystemTip.ShowTip("测试版本不开放该功能")
	end
	if GUI.Button(653, y + 23, 61, 55, nil, GUIStyleButton.FriendDelBtn) then
		function okFunc()
			mRelationManager.RequestDelEnemy(friend.id)
		end
		mAlert.Show("确定删除该仇敌?", okFunc)
	end
end
