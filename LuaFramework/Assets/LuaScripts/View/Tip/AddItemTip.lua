local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,CFG_action,AppearEvent,EventType,ActionType,CFG_Equip,AssetType,CFG_item = 
Color,os,ConstValue,pairs,math,CFG_action,AppearEvent,EventType,ActionType,CFG_Equip,AssetType,CFG_item
local CFG_shipEquip,CFG_star,DrawItemCell = CFG_shipEquip,CFG_star,DrawItemCell
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mMainPanel = require "LuaScript.View.Panel.Main.Main"
local mActionManager = require "LuaScript.Control.ActionManager"

module("LuaScript.View.Tip.AddItemTip")
notAutoClose = true
notShowGuide = true
panelType = ConstValue.TipPanel


local mAwardList = {}
local mShowAwardList = {}
local mLastAddTime = -10000

local mStopShowItemList = nil

function Init()
	-- mMainPanel = require "LuaScript.View.Panel.Main.Main"
	-- mActionManager = require "LuaScript.Control.ActionManager"
	IsInit = true
end

function StopAddShow(type, id, count)
	mStopShowItemList = mStopShowItemList or {}
	table.insert(mStopShowItemList, {type=type, id=id, count=count})
end

function NeedStopAddShow(type, id, count)
	if type == 0 and id == 27 then
		return true
	end
	if mStopShowItemList then
		for k,value in pairs(mStopShowItemList) do
			if value.type == type and value.id == id and value.count == count then
				table.remove(mStopShowItemList, k)
				return true
			end
		end
	end
end

function ShowTip(type, id, count, fromX, fromY, enforce)
	if not enforce and NeedStopAddShow(type, id, count) then
		return
	end
	
	local actiontType = nil
	if type == 0 then
		actiontType = ActionType.Item
	elseif type == 1 then
		actiontType = ActionType.Item
	elseif type == 2 then
		actiontType = ActionType.Fleet
	elseif type == 4 then
		actiontType = ActionType.StarFate
	end
	
	if not mActionManager.GetActionOpen(actiontType) then
		return
	end
	
	local toX,toY = mMainPanel.GetButtonPosition(actiontType)
	
	if not toX or not toY then
		return
	end
	
	fromX = fromX or (toX - 202)
	fromY = fromY or 400
	local mAward = {
		id=id,
		count=count,
		type=type,
		fromX=fromX, fromY=fromY, 
		toX=toX-fromX, toY=toY-fromY, 
		lastTime=ConstValue.AddItemTipLastTime}
	table.insert(mAwardList, mAward)
	mPanelManager.Show(OnGUI)
end

function OnGUI()
	if mShowAwardList[1] and mShowAwardList[1].lastTime <= 0 then
		table.remove(mShowAwardList, 1)
	end
	
	if os.oldClock - mLastAddTime >= 0.2 and mAwardList[1] then
		table.insert(mShowAwardList, mAwardList[1])
		table.remove(mAwardList, 1)
		mLastAddTime = os.oldClock
	end
	
	for k, award in pairs(mShowAwardList) do
		award.lastTime = award.lastTime - os.deltaTime
		local x = award.fromX + award.toX * (1 - award.lastTime)
		local y = award.fromY + award.toY * (1 - math.sin(award.lastTime * math.pi * 0.5))
		-- print(x, y)
		
		DrawItemCell(award, award.type, x, y, 80, 80, false)
		-- if award.type == 0 then
			-- local cfg_item = CFG_item[award.id]
			-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon, AssetType.Icon)
			-- GUI.DrawTexture(x,y,80,80,image,0,0,1,1,6,6,6,6)
			
			-- if award.count > 1 then
				-- GUI.Label(x+75, y+50, 0, 30, award.count, GUIStyleLabel.Right_25_White, Color.Black)
			-- end
		-- elseif award.type == 1 then
			-- local cfg_equip = CFG_Equip[award.id]
			-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_"..cfg_equip.quality)
			-- GUI.DrawTexture(x,y,80,80,image)
			-- local image = mAssetManager.GetAsset("Texture/Icon/Equip/"..cfg_equip.icon, AssetType.Icon)
			-- GUI.DrawTexture(x+5,y+5,70,70,image)
		-- elseif award.type == 2 then
			-- local cfg_equip = CFG_shipEquip[award.id]
			-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_"..cfg_equip.quality)
			-- GUI.DrawTexture(x,y,80,80,image)
			-- local image = mAssetManager.GetAsset("Texture/Icon/ShipEquip/"..cfg_equip.icon, AssetType.Icon)
			-- GUI.DrawTexture(x+5,y+5,70,70,image)
		-- elseif award.type == 4 then
			-- local cfg_star = CFG_star[award.id]
			-- local image = mAssetManager.GetAsset("Texture/Icon/Star/"..cfg_star.resId, AssetType.Icon)
			-- GUI.DrawTexture(x-15,y-15,100,100,image)
		-- end
	end
	
	if not mShowAwardList[1] and not mAwardList[1] then
		mPanelManager.Hide(OnGUI)
	end
end
