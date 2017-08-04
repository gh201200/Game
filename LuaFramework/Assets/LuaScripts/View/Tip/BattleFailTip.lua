local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,CFG_action,AppearEvent,EventType,GUIStyleButton,GUIUtility,Vector2,Event = 
Color,os,ConstValue,pairs,math,CFG_action,AppearEvent,EventType,GUIStyleButton,GUIUtility,Vector2,Event
local UnityEventType,CsCurrentEventEqualsType = UnityEventType,CsCurrentEventEqualsType
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mBattleFieldManager = nil

module("LuaScript.View.Tip.BattleFailTip")

notAutoClose = true
notShowGuide = true
panelType = ConstValue.TipPanel
-- pivotPoint = Vector2.Init(GUI.HorizontalRestX(256+322),GUI.VerticalRestY(284-36))

function Init()
	mBattleFieldManager = require "LuaScript.Control.Data.BattleFieldManager"
	IsInit = true
end

function ShowTip()
	mTime = os.oldClock
	mPanelManager.Show(OnGUI)
end

function OnGUI()
	local overTime = os.oldClock - mTime
	
	local alpha = math.min(1.5-overTime, 0.5)
	-- Color.example.r = 0.1
	-- Color.example.g = 0.1
	-- Color.example.b = 0.1
	-- Color.example.a = alpha
	
	-- GUIUtility.RotateAroundPivot(overTime*20, pivotPoint)
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/zzz3")
	-- GUI.DrawTexture(322,-36,512,512,image,0,0,1,1,0,0,0,0,Color.example)
	-- GUIUtility.RotateAroundPivot(-overTime*20, pivotPoint)
	
	local color = Color.Init(alpha,alpha,alpha,alpha)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/battleFail")
	GUI.DrawTexture(353,76,429,280,image,0,0,1,1,0,0,0,0,color)
	
	local scale = math.sin(math.min(overTime,0.25)*4*math.pi) * 20
	local offset = math.max(overTime-1,0) * 80

	local image = mAssetManager.GetAsset("Texture/Gui/Text/battleFail")
	GUI.DrawTexture(423-scale,148-scale*2+offset,316+2*scale,153+2*scale,image,0,0,1,1,0,0,0,0,color)
	
	if overTime > 2 and GUI.EventRepaint then
		mBattleFieldManager.RequestLeave()
		mPanelManager.Hide(OnGUI)
	end
end
