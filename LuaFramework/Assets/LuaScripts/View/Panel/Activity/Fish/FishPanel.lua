local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton,CFG_map = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton,CFG_map
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty = ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty
local AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,string = 
AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,string
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil
-- 
local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mPanelManager = nil
local mHarborManager = nil
local mHarborSignupPanel = nil
local mRechargePanel = nil
local mSystemTip = nil
local mActivityPanel = nil
local mAlert = nil
local CFG_fishArea = CFG_fishArea
module("LuaScript.View.Panel.Activity.Fish.FishPanel")
local mStr = "活动时间：<color=lime>全天  可捕获%d条</color>\n<color=red>鱼群觅食</color>：<color=lime>周一三五  20:30~21:00  </color> <color=red>可无限捕获 </color>\n参与活动地点：所有渔场\n活动奖励：食用即可获得大量奖励。"
local mStr2 = nil
function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	-- 
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mHarborSignupPanel = require "LuaScript.View.Panel.Activity.HarborBattle.HarborSignupPanel"
	mRechargePanel = require "LuaScript.View.Panel.Recharge.RechargePanel"
	mActivityPanel = require "LuaScript.View.Panel.Activity.ActivityPanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	IsInit = true
end

function Display()
	local mHero = mHeroManager.GetHero()
	mStr2 = string.format(mStr, 90-mHero.fish)
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/fish")
	GUI.DrawTexture(80,100,1024,512,image)
	
	GUI.Label(310,318,650,30,mStr2, GUIStyleLabel.Left_25_White_WordWrap, Color.Black)
	
	if GUI.Button(613, 368, 128, 32, nil, GUIStyleButton.MoveBtn_3) then
		local cfg_fishArea = CFG_fishArea[GetNearFishArea()]
		mHeroManager.Goto(cfg_fishArea.mapId, (cfg_fishArea.starX+cfg_fishArea.endX)/2, (cfg_fishArea.starY+cfg_fishArea.endY)/2)
		mActivityPanel.Close()
		mSystemTip.ShowTip("前往"..cfg_fishArea.name)
	end
	if GUI.Button(741, 368, 128, 32, nil, GUIStyleButton.FlyBtn_2) then
		local cfg_fishArea = CFG_fishArea[GetNearFishArea()]
		mHeroManager.RequestFly(cfg_fishArea.mapId, (cfg_fishArea.starX+cfg_fishArea.endX)/2, (cfg_fishArea.starY+cfg_fishArea.endY)/2, 0)
		mActivityPanel.Close()
	end
end


function GetNearFishArea()
	local minDis = 9999999
	local hero = mHeroManager.GetHero()
	local mapWidth = CFG_map[0].width
	local fishAreaId = nil
	local x = hero.x
	local y = hero.y
	if hero.map ~= 0 then
		x = 7544
		y = 9231
	end
	
	for k,cfg_fishArea in pairs(CFG_fishArea) do
		local dis = mCommonlyFunc.LoopDis(cfg_fishArea.starX,x,mapWidth)+math.abs(y-cfg_fishArea.starY)
		if dis < minDis then
			minDis = dis
			fishAreaId = cfg_fishArea.id
		end
	end
	return fishAreaId
end