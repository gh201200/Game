local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,CFG_action,AppearEvent,EventType,GUIStyleButton,ActionType = 
Color,os,ConstValue,pairs,math,CFG_action,AppearEvent,EventType,GUIStyleButton,ActionType
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mActionManager = require "LuaScript.Control.ActionManager"
local mTimer = require "LuaScript.Common.Timer"
module("LuaScript.View.Tip.ActionOpenTip")
notAutoClose = true
notShowGuide = true
panelType = ConstValue.GuidePanel
local mTime = 0
local mAction = 0
function Init()
	IsInit = true
end

function ShowTip(id)
	-- if mActionManager.GetActionOpen(id) then
		-- return
	-- end
	local cfg_action = CFG_action[id]
	if cfg_action.show == 0 then
		-- mActionManager.OpenAction(id)
		AppearEvent(nil,EventType.OnRefreshGuide)
	else
		mAction = id
		mTime = 0
		mPanelManager.Show(OnGUI)
	end
	
	if cfg_action.menuBtn ~= -1 then
		AppearEvent(nil,EventType.ShowAllBtn, cfg_action.menuBtn)
	end
end

function PerGUI()
	if not IsInit then
		return
	end
	GUI.Button(0,0,1136,640,nil,GUIStyleButton.Transparent)
end

function OnGUI()
	local cfg_action = CFG_action[mAction]
	mTime = mTime + os.deltaTime
	
	local alpha = math.min(math.max(4-mTime, 0), 0.3)
	local color = Color.Init(alpha,alpha,alpha,alpha)
	local image = mAssetManager.GetAsset("Texture/Gui/black")
	GUI.DrawTexture(0,0,1136,640,image,0,0,1,1,0,0,0,0,color)
	
	if mTime <= 3 then
		local image = mAssetManager.GetAsset(cfg_action.icon)
		GUI.DrawTexture(550,170,cfg_action.width,cfg_action.height,image)
		GUI.Label(550+cfg_action.width/2,170+cfg_action.height,0,20,"新功能开启",GUIStyleLabel.LevelUp_30, Color.Black)
	elseif mTime <= 4 then
		local disX = cfg_action.x - 550
		local disY = cfg_action.y - 170
		local image = mAssetManager.GetAsset(cfg_action.icon)
		local x = 550 + disX * (mTime-3)
		local y = 170 + disY * (mTime-3)
		GUI.DrawTexture(x,y,cfg_action.width,cfg_action.height,image)
	else
		-- if mActionManager.GetActionOpen(mAction) then
			-- return
		-- end
		-- mActionManager.OpenAction(mAction)
		-- if mAction == ActionType.Equip or mAction == ActionType.Item or 
			-- mAction == ActionType.Family or mAction == ActionType.Friend  then
			AppearEvent(nil,EventType.OnNewAction, mAction)
			print(1)
			function func()
				AppearEvent(nil,EventType.OnRefreshGuide)
			end
			mTimer.SetTimeout(func, 0.75)
			mPanelManager.Hide(OnGUI)
		-- else
			-- mPanelManager.Hide(OnGUI)
			-- AppearEvent(nil,EventType.OnRefreshGuide)
		-- end
	end
end
