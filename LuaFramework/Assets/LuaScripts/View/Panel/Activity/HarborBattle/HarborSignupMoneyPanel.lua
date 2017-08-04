local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty = ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty
local AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField = 
AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mPanelManager = nil
local mHarborManager = nil

module("LuaScript.View.Panel.Activity.HarborBattle.HarborSignupMoneyPanel") -- 输入竞标价格的界面
panelType = ConstValue.AlertPanel

local mType  = nil
local mHarborId = nil
local mMoney = nil
local mOldMoney = nil
-- local mMinMoney = nil

function Init()
	-- print(111)
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	IsInit = true
end

function SetData(type, harborId, money)
	mType = type
	mHarborId = harborId
	if money == 0 then
		mMoney = 10
	else
		mMoney = money
	end
	mOldMoney = money
	-- mMinMoney = money + 1
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/alertBg")
	GUI.DrawTexture(284,144,560,341,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Text/inputMoney")
	GUI.DrawTexture(464,174,168,38,image)
	
	local newMoneyStr = GUI.TextArea(384,272,356,78, mMoney, GUIStyleTextField.Left_30_White)
	mMoney = tonumber(newMoneyStr) or mMoney
	-- mMoney = math.max(mMinMoney, mMoney)
	
	GUI.Label(356,234,82.7,30,"竞标价:", GUIStyleLabel.Center_30_Brown_Art)
	GUI.Label(646,290,82.7,30,"万", GUIStyleLabel.Left_30_White)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/money")
	GUI.DrawTexture(680,293,41,28,image)
	
	if GUI.Button(372,366,166,77, "确定", GUIStyleButton.BlueBtn) then
		if mMoney < 1 then
			return
		end
		if mOldMoney == mMoney then
			-- print(1)
			mPanelManager.Hide(OnGUI)
			return
		end
		
		if mType == 0 then
			if not mCommonlyFunc.HaveMoney((mMoney-mOldMoney)*10000) then
				return
			end
		elseif mType == 1 then
			if not mCommonlyFunc.HaveFamilyMoney(mMoney-mOldMoney) then
				return
			end
		end
		-- print(2)
		if mOldMoney ~= 0 then
			mHarborManager.RequestCancelSignup(mHarborId, mType)
		end
		mHarborManager.RequestSignup(mType, mHarborId, mMoney)
		mPanelManager.Hide(OnGUI)
	end
	if GUI.Button(586,366,166,77, "取消", GUIStyleButton.BlueBtn) then
		mPanelManager.Hide(OnGUI)
	end
	if GUI.Button(769,128,77,63, nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end