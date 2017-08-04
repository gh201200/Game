local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty = ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty
local AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,CFG_productType,string = 
AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,CFG_productType,string
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mPanelManager = nil
local mHarborManager = nil
local mHarborSignupPanel = nil
local mRechargePanel = nil
local mAlert = nil
local mGoodsManager = nil

module("LuaScript.View.Panel.Activity.Goods.GoodsPanel")
local mStr = "今日畅销商品：<color=lime>%s</color>\t\t\t翻倍奖励舱数：前<color=lime>%d</color>舱\n活动奖励：活动期间贸易前50舱流行品可获得双倍奖励，其后贸易畅销商品也可获得贸易加成。"
local mStr2 = nil

function Init()
	mGoodsManager = require "LuaScript.Control.Data.GoodsManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mHarborSignupPanel = require "LuaScript.View.Panel.Activity.HarborBattle.HarborSignupPanel"
	mRechargePanel = require "LuaScript.View.Panel.Recharge.RechargePanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	
	IsInit = true
end

function Display()
	local type =  mGoodsManager.GetPopularType()
	local count =  mGoodsManager.GetPopularCount()
	mStr2 = string.format(mStr, CFG_productType[type].type, count)
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/goods")
	GUI.DrawTexture(80,100,1024,512,image)
	GUI.Label(316-110,318,650,30,mStr2, GUIStyleLabel.Left_25_White_WordWrap, Color.Black)
end