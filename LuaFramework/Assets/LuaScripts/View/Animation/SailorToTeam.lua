local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,CFG_action,AppearEvent,EventType,GUIStyleButton,GameObject,debug,CFG_harbor,GetTransform = 
Color,os,ConstValue,pairs,math,CFG_action,AppearEvent,EventType,GUIStyleButton,GameObject,debug,CFG_harbor,GetTransform
local Vector2,GUIUtility,CFG_item,CFG_UniqueSailor = Vector2,GUIUtility,CFG_item,CFG_UniqueSailor
local mPanelManager = nil
local mAssetManager = nil
local mAddItemTip = nil
local mTransparentPanel = nil
local mSailorViewPanel = nil

module("LuaScript.View.Animation.SailorToTeam") -- 船员抽取后到船员队伍中
panelType = ConstValue.GuidePanel
notAutoClose = true
local mOverFunc = nil
local mStartTime = 0
local centerX = 394+344/2
local centerY = 138+416/2

local mSailor = nil
local mSailorIndex = 0
local mState = 0 
function Start(overFunc, sailor, index)
	-- local mAssetManager = 
	mTransparentPanel = require "LuaScript.View.Animation.TransparentPanel"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mAddItemTip = require "LuaScript.View.Tip.AddItemTip"
	mSailorViewPanel = require "LuaScript.View.Panel.Sailor.SailorViewPanel"
	-- print(overFunc, id, index)
	mSailor = sailor
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
			local sailorBg = ConstValue.SailorBg[frame]
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/sailorBg_"..frame)
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
		if overTime < 0.5 then
			
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/sailorBg_6")
			
			
			local fromX = 1136/2-344/2
			local fromY = 320-416/2
			local toX = 236
			local toY = 98
			local offSetX = (toX - fromX) * overTime * 2
			local offSetY = (toY - fromY) * overTime * 2
			
			GUI.DrawTexture(fromX + offSetX,fromY+offSetY,344,416,image)
			
			local cfg_sailor = CFG_UniqueSailor[mSailorIndex]
			local image2 = mAssetManager.GetAsset("Texture/Character/Pic/"..cfg_sailor.resId)
			if image2 then
				GUI.DrawTexture(1136/2-286/2 + offSetX,320-360/2+offSetY,286,360,image2)
			end
		else
			mPanelManager.Hide(mTransparentPanel)
			mPanelManager.Hide(OnGUI)
			mSailorViewPanel.SetData(mSailor)
			mPanelManager.Show(mSailorViewPanel)
			
			AppearEvent(nil,EventType.ShowNextMainTask)
		end
	end
end