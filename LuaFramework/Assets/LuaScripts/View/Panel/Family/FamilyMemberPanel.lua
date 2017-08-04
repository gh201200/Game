local _G,Screen,Language,GUI,ByteArray,print,Texture2D,Vector2,pairs,CFG_buildDesc,os,ConstValue = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,Vector2,pairs,CFG_buildDesc,os,ConstValue
local AssetType = AssetType
local PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor,CFG_lab = 
PackatHead,Packat_Account,GUIStyleButton,require,GUIStyleLabel,Color,Packat_Harbor,CFG_harbor,CFG_lab

local mAssetManager = nil
local mNetManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mGUIStyleManager = nil
local mFamilyManager = nil
local mMainPanel = nil
local mTavernPanel = nil
local mShopPanel = nil
local mShipyardPanel = nil
local mSystemTip = nil
local mHeroManager = nil
local mCommonlyFunc = nil
local mFamilyOperatePanel = nil
module("LuaScript.View.Panel.Family.FamilyMemberPanel") -- 联盟成员页面
local mScrollPositionY = 0

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mTavernPanel = require "LuaScript.View.Panel.Harbor.TavernPanel"
	mShopPanel = require "LuaScript.View.Panel.Harbor.ShopPanel"
	mShipyardPanel = require "LuaScript.View.Panel.Harbor.ShipyardPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mFamilyOperatePanel = require "LuaScript.View.Panel.Family.FamilyOperatePanel"
	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end
	-- local n = 0
	-- GUI.BeginGroup(260, 130, 1100, 600)
		GUI.Label(528.65, 137.5, 150, 45, "名称", GUIStyleLabel.Left_35_Black)
		GUI.Label(713.95, 137.5, 100, 45, "职位", GUIStyleLabel.Left_35_Black)
		GUI.Label(831.65, 137.5, 200, 45, "最后上线", GUIStyleLabel.Left_35_Black)
		
		local spacing = 103
		local mMemberList = mFamilyManager.GetMemberList()
		if mMemberList then
			local count = #mMemberList
			--列表
			_,mScrollPositionY = GUI.BeginScrollView(406, 184.45, 650, 4*spacing, 0,mScrollPositionY, 0, 0, 500, count*spacing)
				for k,member in pairs(mMemberList) do
					local y = (k-1)*spacing
					local showY = y - mScrollPositionY / GUI.modulus
					if showY > -spacing and showY < 4*spacing then
						-- n = n + 1
						DrawMember(y, member)
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
			GUI.DrawTexture(406,181+spacing*0,593.75,91.2,image)
			GUI.DrawTexture(406,181+spacing*1,593.75,91.2,image)
			GUI.DrawTexture(406,181+spacing*2,593.75,91.2,image)
			GUI.DrawTexture(406,181+spacing*3,593.75,91.2,image)
		end
	-- GUI.EndGroup()
end

function DrawMember(y, member)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,593.75,91.2,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot1_"..member.quality)
	GUI.DrawTexture(19.45, y+2.8,80,80,image) -- 成员主角品质背景
	
	local hero = mHeroManager.GetHero()
	local image = mAssetManager.GetAsset("Texture/Character/Header/"..member.resId, AssetType.Pic)
	if GUI.TextureButton(24.45, y+7.8, 70, 70, image) then -- 成员主角头像
		-- if member.id == hero.id then -- 限制对自己的操作
			-- mSystemTip.ShowTip("不能对自己进行操作")
			-- return
		-- end
		mFamilyOperatePanel.SetData(member)
		mPanelManager.Show(mFamilyOperatePanel)
	end
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg10_1")
	-- GUI.DrawTexture(5.1,y+5.9,85,85,image)

	GUI.Label(105, 29.2+y, 204.2, 45, member.name, GUIStyleLabel.Left_25_Redbean)
	GUI.Label(315, 29.2+y, 60.2, 45, ConstValue.PostName[member.post], GUIStyleLabel.Center_25_Black)
	GUI.Label(476, 29.2+y, 60.2, 45, mFamilyManager.GetOnlineStr(member), GUIStyleLabel.Center_25_Black)
end

function RequestUpLabLevel() -- 升级联盟
	print("RequestUpLabLevel")
end