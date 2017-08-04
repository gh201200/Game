local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,tostring = Color,os,ConstValue,pairs,math,tostring
local mPanelManager = require "LuaScript.Control.PanelManager"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mDialogPanel = require "LuaScript.View.Panel.Task.DialogPanel"
-- local mHeroManager = nil
module("LuaScript.View.Tip.PowerChangeTip")
notShowGuide = true
notAutoClose = true
panelType = ConstValue.TipPanel
local mTime = 0
local mOldPower = 0
local mNewPower = 0
local offset = 0
function Init()
	-- mDialogPanel = require "LuaScript.View.Panel.Task.DialogPanel"
	
	IsInit = true
end

function ShowTip(oldPower, newPower)
	mTime = 0
	mOldPower = oldPower
	mNewPower = newPower
	mPanelManager.Show(OnGUI)
	if mDialogPanel.visible then
		offset = -85
	else
		offset = 0
	end
end

function OnGUI()
	mTime = mTime + os.deltaTime
	if mTime >= 5 then
		mPanelManager.Hide(OnGUI)
	end
	
	
	local change = mNewPower - mOldPower
	local image = mAssetManager.GetAsset("Texture/Gui/Text/power")
	GUI.DrawTexture(310,420+offset,281,39,image)
	GUI.Label(440,428+offset,1136,300,mNewPower,GUIStyleLabel.PowerChange_1, Color.Black)
	local length = #tostring(mNewPower) * 24
	if change > 0 then
		local y = 450 - math.sin(math.min(mTime*0.5,1.57)) * 40
		GUI.Label(430+length,y+offset,1136,300,"+"..change,GUIStyleLabel.PowerChange_2, Color.Black)
	else	
		local y = 410 + math.sin(math.min(mTime*0.5,1.57)) * 40
		GUI.Label(430+length,y+offset,1136,300,change,GUIStyleLabel.PowerChange_3, Color.Black)
	end
	
end
