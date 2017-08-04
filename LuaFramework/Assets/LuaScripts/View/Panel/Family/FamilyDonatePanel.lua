local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty = ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty
local AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,CFG_family,EventType = 
AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,CFG_family,EventType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mCharManager = nil
local mPanelManager = nil
local mHarborManager = nil
local mEventManager = nil
local mFamilyManager = require "LuaScript.Control.Data.FamilyManager"

module("LuaScript.View.Panel.Family.FamilyDonatePanel")--联盟捐献
panelType = ConstValue.AlertPanel
local mMoney = nil

function Init()
	-- print(111)
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	-- mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mEventManager = require "LuaScript.Control.EventManager"
	
	mEventManager.AddEventListen(nil, EventType.FamilyDel, FamilyDel)
	
	IsInit = true
end

function FamilyDel()
	mPanelManager.Hide(OnGUI)
end

function Display()
	local familyInfo = mFamilyManager.GetFamilyInfo()
	local cfg_family = CFG_family[familyInfo.level] -- 剩余可以捐钱获取的贡献值contribute
	local hero = mHeroManager.GetHero()
	mMoney = math.max((cfg_family.contribute-hero.todayContribute), 10)--默认显示今日可捐助最大值
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/alertBg")
	GUI.DrawTexture(284,144,560,341,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Text/inputMoney")
	GUI.DrawTexture(464,174,168,38,image)
	local newMoneyStr = GUI.TextArea(384,287,356,78, mMoney, GUIStyleTextField.Left_30_White)
	--限制输入的金额上限为21亿
	if tonumber(newMoneyStr) ~= nil and mMoney ~= nil then
        if tonumber(newMoneyStr) > 210000 or mMoney > 210000 then
			newMoneyStr,mMoney = 210000
		end
	end
	mMoney = tonumber(newMoneyStr) or mMoney
	local familyInfo = mFamilyManager.GetFamilyInfo()
	if not familyInfo then
		return
	end
	local cfg_family = CFG_family[familyInfo.level]
	local hero = mHeroManager.GetHero()
	local contribute = math.max(cfg_family.contribute-(hero.todayContribute or 0), 0)
	--面板固定显示的元素
	local str = "1万银两=1点贡献值\n今日还可获得"..contribute.."贡献值"
	GUI.Label(366,234,82.7,30,"捐献额度:", GUIStyleLabel.Center_30_Brown_Art)
	GUI.Label(475+175,234,82.7,30,str, GUIStyleLabel.Right_20_DeepBlue)
	GUI.Label(646,305,82.7,30,"万", GUIStyleLabel.Left_30_White)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/money")
	GUI.DrawTexture(680,308,41,28,image)
	
	if GUI.Button(372,366,166,77, "确定", GUIStyleButton.BlueBtn) then
		if not mCommonlyFunc.HaveMoney(mMoney*10000) then
			return
		end
		
		mFamilyManager.RequestGiveMoney(mMoney*10000)--
		mPanelManager.Hide(OnGUI)
	end
	if GUI.Button(586,366,166,77, "取消", GUIStyleButton.BlueBtn) then
		mPanelManager.Hide(OnGUI)
	end
	if GUI.Button(769,128,77,63, nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end