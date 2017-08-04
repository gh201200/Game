local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs = Color,os,ConstValue,pairs
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
module("LuaScript.View.Tip.SystemTip")
notShowGuide = true
notAutoClose = true
panelType = ConstValue.TipPanel

local mShowList = {}
local mTipList = {}
function ShowTip(str, color, fontSize, outlineColor)
	color = color or Color.RedStr
	str = mCommonlyFunc.BeginColor(color) .. str .. mCommonlyFunc.EndColor()

	if fontSize then
		str = mCommonlyFunc.BeginSize(fontSize) .. str .. mCommonlyFunc.EndSize()
	end
	outlineColor = outlineColor or Color.Black
	tip = {str=str,outlineColor=outlineColor,lastTime=ConstValue.SystemTipLastTime,y=160}
	table.insert(mTipList, tip)
	mPanelManager.Show(OnGUI)
end

function OnGUI()
	-- local destroyList = nil
	for i = 1,3,1 do
		local tip = mShowList[i]
		if not tip then
			break
		end
		tip.y = tip.y - os.deltaTime*35
		if tip.y < i*35 then
			tip.y = i*35
		end
		
		GUI.Label(0,30+tip.y,1136,300,tip.str,GUIStyleLabel.Center_35_White_Art,tip.outlineColor)
		tip.lastTime = tip.lastTime - os.deltaTime
	end
	
	if mShowList[1] and mShowList[1].lastTime < 0 then
		table.remove(mShowList, 1)
	end
	
	
	local count = #mShowList
	if count < 3 and mTipList[1] and (not mShowList[count] or mShowList[count].lastTime < 4) then
		table.insert(mShowList, mTipList[1])
		table.remove(mTipList, 1)
	end
	if not mShowList[1] then
		mPanelManager.Hide(OnGUI)
	end
	-- mPanelManager.Show(OnGUI)
end
