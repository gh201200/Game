local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel
local DrawItemCell = DrawItemCell --绘制单个物品
local mAssetManager = nil
local mGUIStyleManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mPromptAlert = nil
local mCommonlyFunc = nil
module("LuaScript.View.Panel.FirstRechange.FirstRechange")
panelType = ConstValue.AlertPanel --面板属性为弹出框，屏蔽其他UI的响应
local mRechargePanel = require "LuaScript.View.Panel.Recharge.RechargePanel" --充值页面
local mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel" --物品详细信息
local mSystemTip = nil
local mHeroManager = nil
--首冲奖励列表
local mAwardList = {
	[1] = {type=0, id=45, count=1},
	[2] = {type=0, id=14, count=200000},
	[3] = {type=0, id=18, count=10},
	[4] = {type=0, id=48, count=10},
}

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mPromptAlert = require "LuaScript.View.Alert.PromptAlert"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	IsInit = true
end

function Display()
	mMouseEventState = mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false)
end
 

function OnGUI()
	local mHero = mHeroManager.GetHero()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/firstRechange")
	GUI.DrawPackerTexture(image)

	
	if GUI.Button(501, 335, 168, 64,nil,GUIStyleButton.RechangeEntry) then
		if mHero.firstRecharge > 0 then
		   mSystemTip.ShowTip("您的首冲机会已使用，本次充值不能再次获得首冲奖励")
		end
		--直接前往充值界面
		mPanelManager.Show(mRechargePanel)
		mPanelManager.Hide(OnGUI)
	end
	
	GUI.Label(460, 200, 270, 40, "充值任意金额送<color=#ff5321>亨利王子</color>", GUIStyleLabel.Center_25_White, Color.Black)
	
	if GUI.Button(810, 110, 64, 64, nil, GUIStyleButton.CloseBtn_4) then
		--关闭按钮
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(mMouseEventState)
	end
	
	for k,v in pairs(mAwardList) do
		if DrawItemCell(v, v.type, 425 + (k-1)*90, 252 , 66, 66) then
			-- 鼠标点击显示相关属性
			-- mItemViewPanel.SetData(v.id)
			-- mPanelManager.Show(mItemViewPanel)
		end
	end
	
	GUI.FrameAnimation(200,255,256,256,'starPoint')
	
end