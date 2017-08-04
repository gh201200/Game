local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,CFG_action,AppearEvent,EventType,GUIStyleButton,GUIUtility,Vector2 = 
Color,os,ConstValue,pairs,math,CFG_action,AppearEvent,EventType,GUIStyleButton,GUIUtility,Vector2
local Event,UnityEventType,CsCurrentEventEqualsType = Event,UnityEventType,CsCurrentEventEqualsType
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mBattleAwardPanel = nil
local mBattleStarPanel = nil
local mBattleFieldManager = nil

module("LuaScript.View.Tip.BattleSuccessTip")

-- notAutoClose = true
-- notShowGuide = true
panelType = ConstValue.TipPanel
pivotPoint = Vector2.New(GUI.HorizontalRestX(256+322),GUI.VerticalRestY(284-36))

function Init()
	mBattleAwardPanel = require "LuaScript.View.Panel.Battle.BattleAwardPanel"
	mBattleStarPanel = require "LuaScript.View.Panel.Battle.BattleStarPanel"
	mBattleFieldManager = require "LuaScript.Control.Data.BattleFieldManager"
	IsInit = true
end

function ShowTip()
	mTime = os.oldClock
	mPanelManager.Show(OnGUI)
end

function OnGUI()
	local overTime = os.oldClock - mTime
	
	GUIUtility.RotateAroundPivot(overTime*20, pivotPoint)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/battleSuccessLight")
	GUI.DrawTexture(322,-36,512,512,image)
	GUIUtility.RotateAroundPivot(-overTime*20, pivotPoint)
	
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/battleSuccess")
	GUI.DrawTexture(353,76,429,280,image)
	
	local scale = math.sin(math.min(overTime,0.25)*4*math.pi) * 40
	
	local image = mAssetManager.GetAsset("Texture/Gui/Text/battleSuccess")
	GUI.DrawTexture(423-scale,148-scale*2,317+2*scale,177+2*scale,image)
	
	if overTime > 2 and GUI.EventRepaint then
		if not mBattleAwardPanel.visible and not mBattleStarPanel.visible then
			mBattleFieldManager.RequestLeave()
		end
		mPanelManager.Hide(OnGUI)
	end
end
