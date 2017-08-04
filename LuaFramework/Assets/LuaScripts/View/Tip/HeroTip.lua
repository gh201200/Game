local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math = Color,os,ConstValue,pairs,math
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
module("LuaScript.View.Tip.HeroTip")
notShowGuide = true
notAutoClose = true
panelType = ConstValue.TipPanel

local mTipList = {}
local mShowList = {}
local mLastAddTime = 0
-- local mStartY = 500
function ShowTip(str, color, fontSize, outlineColor)
	if color then
		str = mCommonlyFunc.BeginColor(color) .. str .. mCommonlyFunc.EndColor()
	end
	if fontSize then
		str = mCommonlyFunc.BeginSize(fontSize) .. str .. mCommonlyFunc.EndSize()
	end
	outlineColor = outlineColor or Color.Black

	tip = {str=str,outlineColor=outlineColor,lastTime=ConstValue.HeroTipLastTime,y=500}
	table.insert(mTipList, tip)
	
	mPanelManager.Show(OnGUI)
end

function OnGUI()
	if os.oldClock - mLastAddTime >= 0.25 and mTipList[1] then
		table.insert(mShowList, mTipList[1])
		table.remove(mTipList,1)
		mLastAddTime = os.oldClock
	end
	
	-- local destroyList = nil
	for k,tip in pairs(mShowList) do
		tip.y = tip.y - os.deltaTime*50
		
		GUI.Label(830,tip.y,1136,300,tip.str,GUIStyleLabel.Left_25_White,tip.outlineColor)
		tip.lastTime = tip.lastTime - os.deltaTime
		
		-- if tip.lastTime < 0 then
			-- destroyList = destroyList or {}
			-- destroyList[k] = 1
		-- end
	end
	
	if mShowList[1] and mShowList[1].lastTime < 0 then
		table.remove(mShowList, 1)
	end
	
	if not mShowList[1] then
		mPanelManager.Hide(OnGUI)
	end
	-- if destroyList then
		-- for k,v in pairs(destroyList) do
			-- table.remove(mShowList, k)
		-- end
	-- end
	
end
