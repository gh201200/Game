local _G,Screen,Language,GUI,ByteArray,print,Texture2D,Vector2,pairs,CFG_buildDesc,os = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,Vector2,pairs,CFG_buildDesc,os
local PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor = 
PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor
local AssetType = AssetType

local mAssetManager = nil
local mNetManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mGUIStyleManager = nil
local mMainPanel = nil
local mTavernPanel = nil
local mShopPanel = nil
local mShipyardPanel = nil
local mSystemTip = nil
local mHeroManager = nil
local mCommonlyFunc = nil
local mFamilyManager = nil
local mCharViewPanel = nil
module("LuaScript.View.Panel.Family.FamilyApplyerPanel")--联盟申请
local mScrollPositionY = 0

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mTavernPanel = require "LuaScript.View.Panel.Harbor.TavernPanel"
	mShopPanel = require "LuaScript.View.Panel.Harbor.ShopPanel"
	mShipyardPanel = require "LuaScript.View.Panel.Harbor.ShipyardPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mCharViewPanel = require "LuaScript.View.Panel.View.CharViewPanel"
	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end
	
	GUI.Label(528.65, 137.5, 150, 45, "名称", GUIStyleLabel.Left_35_Black)
	GUI.Label(691, 137.5, 100, 45, "战斗力", GUIStyleLabel.Left_35_Black)
	GUI.Label(911.65, 137.5, 200, 45, "操作", GUIStyleLabel.Left_35_Black)
	
	local spacing = 103
	local mApplyerList = mFamilyManager.GetApplyerList()
	if 	mApplyerList then
		local count = #mApplyerList
		_,mScrollPositionY = GUI.BeginScrollView(406, 184.45, 650, 4*spacing, 0, mScrollPositionY, 0, 0, 600, count*spacing)
			for k,member in pairs(mApplyerList) do
				local y = (k-1)*spacing
				local showY = y - mScrollPositionY / GUI.modulus
				if showY > -spacing  and showY < 4*spacing then
					DrawApplyer(y, member)
				end
			end
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
			if count < 1 then
				GUI.DrawTexture(0,spacing*0,593.75,91.2,image)
			end
			if count < 2 then
				GUI.DrawTexture(0,spacing*1,593.75,91.2,image)
			end
			if count < 3 then
				GUI.DrawTexture(0,spacing*2,593.75,91.2,image)
			end
			if count < 4 then
				GUI.DrawTexture(0,spacing*3,593.75,91.2,image)
			end
		GUI.EndScrollView()
	else
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
		GUI.DrawTexture(406,184.45+spacing*0,593.75,91.2,image)
		GUI.DrawTexture(406,184.45+spacing*1,593.75,91.2,image)
		GUI.DrawTexture(406,184.45+spacing*2,593.75,91.2,image)
		GUI.DrawTexture(406,184.45+spacing*3,593.75,91.2,image)
	end
end

function DrawApplyer(y, member)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,593.75,91.2,image)
	
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_"..member.quality)
	GUI.DrawTexture(19.45, y+2.8,80,80,image)
	
	-- local hero = mHeroManager.GetHero()
	local image = mAssetManager.GetAsset("Texture/Character/Header/"..member.resId, AssetType.Pic)
	if GUI.TextureButton(24.45, y+7.8, 70, 70, image) then
		mCharViewPanel.SetData(member)
		mPanelManager.Show(mCharViewPanel)
	end
	
	GUI.Label(105, 29.2+y, 204.2, 45, member.name, GUIStyleLabel.Left_25_Redbean)
	GUI.Label(315, 29.2+y, 60.2, 45, member.power, GUIStyleLabel.Center_25_Black)
	-- GUI.Label(476, 29.2+y, 129.2, 45, mCommonlyFunc.GetApplyTime(member.applyTime), GUIStyleLabel.Center_25_Black)
	
	if GUI.Button(479, 18.55+y, 53, 47,nil, GUIStyleButton.YesBtn) then
		mFamilyManager.RequestAccept(member.id)
	end
	
	if GUI.Button(537, 18.55+y, 53, 47,nil, GUIStyleButton.NoBtn) then
		mFamilyManager.RequestRefuse(member.id)
	end
end
