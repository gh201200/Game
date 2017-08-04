local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,CFG_action,AppearEvent,EventType,GUIStyleButton,GameObject,debug,CFG_harbor,GetTransform = 
Color,os,ConstValue,pairs,math,CFG_action,AppearEvent,EventType,GUIStyleButton,GameObject,debug,CFG_harbor,GetTransform
local Vector2,GUIUtility,CFG_item,CFG_UniqueSailor,ItemType,DrawItemCell = Vector2,GUIUtility,CFG_item,CFG_UniqueSailor,ItemType,DrawItemCell
local mPanelManager = nil
local mAssetManager = nil
local mAddItemTip = nil
local mTransparentPanel = nil
local mLoadPanel = nil

module("LuaScript.View.Animation.SailorToItem") -- 船员抽取后变成碎片到物品中
panelType = ConstValue.GuidePanel
notAutoClose = true
local mOverFunc = nil
local mStartTime = 0
local centerX = 394+344/2
local centerY = 138+416/2

local mItemId = 0
local mSailorIndex = 0
local mState = 0 
function Start(overFunc, id, index)
	-- local mAssetManager = 
	mTransparentPanel = require "LuaScript.View.Animation.TransparentPanel"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mAddItemTip = require "LuaScript.View.Tip.AddItemTip"
	-- print(overFunc, id, index)
	mItemId = id
	mSailorIndex = index
	mOverFunc = overFunc
	mStartTime = os.oldClock
	mState = 0
	
	mPanelManager.Show(OnGUI)
	-- mPanelManager.Show(mTransparentPanel)
end

function OnGUI()
	local overTime = (os.oldClock - mStartTime)
	
	if mState == 0 then
		if overTime < 0.8 then
			local color = Color.Init(overTime,overTime,overTime,overTime)
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/sailorBg_1")
			GUI.DrawTexture(1136/2-344/2,320-416/2,344,416,image
				,0,0,1,1,6,6,6,6,color)
		else
			mStartTime = os.oldClock
			mState = 1
		end
		GUI.FrameAnimation_Once(315,63,512,512,'SailorEmploy',mStartTime) -- 动画
	elseif mState == 1 then
		local frame = math.floor((overTime)*15) + 1	
		if frame < 7 then
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/sailorBg_"..frame)
			local sailorBg = ConstValue.SailorBg[frame]
			GUI.DrawTexture(1136/2-sailorBg[1]/2,320-sailorBg[2]/2,sailorBg[1],sailorBg[2],image)
			local scale = sailorBg[1] / 344
			if frame > 3 then
				local cfg_sailor = CFG_UniqueSailor[mSailorIndex]
				local image2 = mAssetManager.GetAsset("Texture/Character/Pic/"..cfg_sailor.resId)
				if image2 then
					GUI.DrawTexture(1136/2-286/2*scale,320-360/2,286*scale,360,image2)
				end
			end
		else
			mStartTime = os.oldClock
			mState = 2
		end
	elseif mState == 2 then
		if overTime < 1 then
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/sailorBg_6")
			GUI.DrawTexture(1136/2-344/2,320-416/2,344,416,image)
			
			local cfg_sailor = CFG_UniqueSailor[mSailorIndex]
			local image2 = mAssetManager.GetAsset("Texture/Character/Pic/"..cfg_sailor.resId)
			if image2 then
				GUI.DrawTexture(1136/2-286/2,320-360/2,286,360,image2)
			end
		else
			mStartTime = os.oldClock
			mState = 3
		end
	else
		overTime = overTime*2
		local xScale = 1 - (1 - 80/300) * math.min(overTime, 1)
		local yScale = 1 - (1 - 80/400) * math.min(overTime, 1)

		local color = math.sin(overTime*math.pi*0.5)*0.5
		local color = Color.Init(color,color,color,color)
		local x1 = centerX - xScale * (centerX - (394))
		local y1 = centerY - yScale * (centerY - (138))
		
		local cfg_item = CFG_item[mItemId]
		DrawItemCell(cfg_item, ItemType.Item, x1+10,y1,xScale*300,yScale*400)
		
		local color = math.cos(overTime*math.pi*0.5)*0.5
		local color = Color.Init(color,color,color,color)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/sailorBg_6")
		GUI.DrawTexture(x1,y1,xScale*344,yScale*416,image, 0, 0, 1, 1,
			0, 0, 0, 0, color)
		
		local x2 = centerX - xScale * (centerX - (394+35))
		local y2 = centerY - yScale * (centerY - (138+17))
		local cfg_sailor = CFG_UniqueSailor[mSailorIndex]
		local image = mAssetManager.GetAsset("Texture/Character/Pic/"..cfg_sailor.resId)
		if image then
			GUI.DrawTexture(x2,y2 ,xScale*286,yScale*360,image, 0, 0, 1, 1,
				0, 0, 0, 0, color)
		end
		
		
		-- local image = mAssetManager.GetAsset("Texture/Icon/Item/"..cfg_item.icon)
		-- GUI.DrawTexture(x1,y1,xScale*344,yScale*416,image,0,0,1,1,6,6,6,6,color)
		
		if overTime > 1 then
			mPanelManager.Hide(mTransparentPanel)
			mPanelManager.Hide(OnGUI)
			mAddItemTip.ShowTip(0, mItemId, 1, x1+10, y1)
		end
	end
end