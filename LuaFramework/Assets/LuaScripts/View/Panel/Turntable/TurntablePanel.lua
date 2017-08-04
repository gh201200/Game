local _G,Screen,Language,GUI,ByteArray,print,Texture2D = _G,Screen,Language,GUI,ByteArray,print,Texture2D
local PackatHead,Packat_Account,GUIStyleButton,Color,CFG_role,math,GUIStyleLabel,ConstValue,string,tonumber = 
PackatHead,Packat_Account,GUIStyleButton,Color,CFG_role,math,GUIStyleLabel,ConstValue,string,tonumber
local AssetType,os,CFG_UniqueSailor,CFG_turntable = AssetType,os,CFG_UniqueSailor,CFG_turntable
local CFG_first_name,GUIStyleTextField,Vector2,pairs,table,CFG_Equip,CFG_item,AppearEvent,EventType = 
CFG_first_name,GUIStyleTextField,Vector2,pairs,table,CFG_Equip,CFG_item,AppearEvent,EventType
local CFG_last_name,require,debug,cs_Base,GUIUtility = CFG_last_name,require,debug,cs_Base,GUIUtility

local DrawItemCell,ItemType = DrawItemCell,ItemType
local mAddItemTip = require "LuaScript.View.Tip.AddItemTip"
local mAlertPanel = require "LuaScript.View.Alert.Alert"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mNetManager = require "LuaScript.Control.System.NetManager"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mSceneManager = require "LuaScript.Control.Scene.SceneManager"
local mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
local mItemViewPanel = nil
local mEquipViewPanel = nil
local mItemManager = nil

module("LuaScript.View.Panel.Turntable.TurntablePanel") -- 转盘抽奖页面
panelType = ConstValue.AlertPanel
notAutoClose = true

pivotPoint = Vector2.New(GUI.HorizontalRestX(466+117),GUI.VerticalRestY(64+251))

local mAwardListByItem = {}

local mAwardList = nil
local mAward = nil
local mAwardIndex = 1
local mState = 0
mAngle = 0
local speed = 0

function Init()
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	
	IsInit = true
end

function Hide()
	-- print("Hide!!!!!!")
	mAwardList = nil
	AppearEvent(nil,EventType.UseTurntable)
	AppearEvent(nil,EventType.ShowNextMainTask)
	mSceneManager.SetMouseEvent(mMouseEventState)
end

function Display()
	-- print("Display!!!!!!")
	mMouseEventState = mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false)
end

function SetData(id)
	local cfg_turntable = CFG_turntable[id]
	mAddItemTip.StopAddShow(cfg_turntable.awardType,cfg_turntable.awardId,cfg_turntable.awardCount)
	
	mAwardList = {cfg_turntable}
	mAward = cfg_turntable
	mAwardIndex = 1
	mState = 0
	mAngle = 0
	
	local turntableId = cfg_turntable.type
	local allAwardList = GetTurntableAwardList(turntableId)
	for k,list in pairs(allAwardList) do
		if k ~= cfg_turntable.store then
			local random = math.random(#list)
			table.insert(mAwardList, list[random])
		end
	end
	
	local length = #mAwardList
	for i = 1,length do
		local dest = math.random(length)
		mAwardList[i],mAwardList[dest] = mAwardList[dest],mAwardList[i]
		if mAwardIndex == i then
			mAwardIndex = dest
		elseif mAwardIndex == dest then
			mAwardIndex = i
		end
	end
	-- print(mAwardList)
end

function GetTurntableAwardList(id)
	if not mAwardListByItem[id] then
		mAwardListByItem[id] = {}
		for k,turntable in pairs(CFG_turntable) do
			if turntable.type == id then
				mAwardListByItem[id][turntable.store] = mAwardListByItem[id][turntable.store] or {}
				table.insert(mAwardListByItem[id][turntable.store], turntable)
			end
		end
	end
	return mAwardListByItem[id]
end

function OnGUI()
	-- print(mAwardList)
	if not mAwardList then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/turntable_1")
	GUI.DrawTexture(250,0,670,640,image)
	
	for k,award in pairs(mAwardList) do
		DrawAward(k, award)
	end
	
	
	mAngle = mAngle + os.deltaTime * speed
	GUIUtility.RotateAroundPivot(mAngle, pivotPoint)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/turntable_2")
	GUI.DrawTexture(466,64,239,369,image)
	GUIUtility.RotateAroundPivot(-mAngle, pivotPoint)
	
	
	if mState == 0 then
		if GUI.Button(513,245,142,142,nil,GUIStyleButton.Start_2) then
			speed = 200
			mState = 2
		end
	-- elseif mState == 1 then
		-- if GUI.Button(513,245,142,142,nil,GUIStyleButton.Stop) then
			-- mState = 2
		-- end
	elseif mState == 2 then
		local _,_,angle = GetPosition(mAwardIndex)
		local stopAngle = (mAngle + 1000) % 360
		if angle > stopAngle and angle - stopAngle < 15 then
			mState = 3
		end
		-- GUI.Button(513,245,142,142,nil,GUIStyleButton.Stop)
	elseif mState == 3 then
		speed = math.max(speed - os.deltaTime * 20, 10)
		if speed <= 10 then
			-- print()
			local _,_,angle = GetPosition(mAwardIndex)
			if math.abs(mAngle % 360 - angle) < 3 then
				mState = 4
				speed = 0
				mAngle = angle
			end
		end
		-- GUI.SetEnabled(false)
		-- GUI.Button(513,245,142,142,nil,GUIStyleButton.Stop)
		-- GUI.SetEnabled(true)
	else
		if GUI.Button(513,245,142,142,nil,GUIStyleButton.Take) then
			local x,y = GetPosition(mAwardIndex)
			mAddItemTip.ShowTip(mAward.awardType,mAward.awardId,mAward.awardCount,x,y)
			mPanelManager.Hide(OnGUI)
			mItemManager.RequestStopTurntable()
		end
	end
	
	GUI.Button(0,0,1136,640,nil,GUIStyleButton.Transparent)
end

function GetPosition(k)
	if k == 1 then
		return 546,112,359
	elseif k == 2 then 
		return 680,175,52
	elseif k == 3 then 
		return 713,313,103
	elseif k == 4 then 
		return 608,430,155
	elseif k == 5 then
		return 471,425,208
	elseif k == 6 then
		return 376,304,260
	elseif k == 7 then
		return 420,170,310
	end
end

function DrawAward(k, award)
	local x,y = GetPosition(k)
	award.item = award.item or {id=award.awardId,count=award.awardCount}
	DrawItemCell(award.item, award.awardType, x, y,80,80)
	-- if award.awardType == 1 then
		-- local cfg_equip = CFG_Equip[award.awardId]
		-- local image = mAssetManager.GetAsset("Texture/GUI/Bg/equipSlot1_"..cfg_equip.quality)
		-- GUI.DrawTexture(x,y,80,80,image)
		-- local image = mAssetManager.GetAsset("Texture/Icon/Equip/"..cfg_equip.icon, AssetType.Icon)
		-- if GUI.TextureButton(x+5,y+5,70,70,image) then
			-- local equip = {id=award.awardId,notExist=true}
			-- mEquipViewPanel.SetData(nil, equip)
			-- mPanelManager.Show(mEquipViewPanel)
		-- end

		-- if award.awardCount > 1 then
			-- GUI.Label(x+35, y+50, 41, 29, award.awardCount, GUIStyleLabel.Right_25_White, Color.Black)
		-- end
		-- GUI.Label(x, y+82, 80, 30, cfg_equip.name, GUIStyleLabel.Center_20_Black)
	-- else
		-- local cfg_item = CFG_item[award.awardId]
		-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
		-- if DrawItemCell(cfg_item, ItemType.Item, x, y,80,80) then
			-- mItemViewPanel.SetData(cfg_item.id)
			-- mPanelManager.Show(mItemViewPanel)
		-- end

		-- if award.awardCount > 1 then
			-- GUI.Label(x+35, y+50, 41, 29, award.awardCount, GUIStyleLabel.Right_25_White, Color.Black)
		-- end
	-- end
end