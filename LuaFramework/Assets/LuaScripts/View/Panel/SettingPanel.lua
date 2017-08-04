local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table
local SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property = SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property
local CFG_item,SettingTypeName,SettingType,NewestVersion,platform,VersionCode,VersionName,Application,_G,IPhonePlayer = 
CFG_item,SettingTypeName,SettingType,NewestVersion,platform,VersionCode,VersionName,Application,_G,IPhonePlayer
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mMainPanel = require "LuaScript.View.Panel.Main.Main"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mEquipUpPanel = nil
local mEquipDestroyPanel = nil
local mEquipViewPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mCommonlyFunc = nil
local mSailorManager = nil
local mItemManager = nil
local mSetManager = nil
local mSystemTip = nil
local mAlert = nil
local mUpdateNoticePanel = nil
local mSDK = nil

module("LuaScript.View.Panel.SettingPanel")

mScrollPositionY = 0

-- local mItemList = {{id=1,count=999},{id=2,count=55},{id=3,count=1}}
local mIndexList = {16,2,3,18,12,5,6,7,8,9,10,11}

function Init()
	mSetManager = require "LuaScript.Control.System.SetManager"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mSailorManager = require "LuaScript.Control.Data.SailorManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipDestroyPanel = require "LuaScript.View.Panel.Equip.EquipDestroyPanel"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	-- mEquipManager = require "LuaScript.Control.Data.EquipManager"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mAlert = require "LuaScript.View.Alert.Alert"
	mUpdateNoticePanel = require "LuaScript.View.Panel.Chat.UpdateNoticePanel"
	mSDK = require "LuaScript.Mode.Object.SDK"
	IsInit = true
end

function Hide()
	mScrollPositionY = 0
end

function OnGUI()
	if not IsInit then
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(83.5,37.5,1016.75-50,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	GUI.Label(525.5,48,84.2,30,"设置", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	local spacing = 96
	-- local mList = mSetManager.GetList()
	local count = #mIndexList+1
	_,mScrollPositionY = GUI.BeginScrollView(156, 133, 900, spacing*5, 0, mScrollPositionY, 0, 0, 850, spacing * count)
		-- DrawVersion()
		-- DrawUserCenter()
		DrawDesc()
		for index,k in pairs(mIndexList) do
			local v = mSetManager.GetValue(k)
			local y = index*spacing
			local showY = y - mScrollPositionY / GUI.modulus
			if showY > -spacing  and showY < spacing*5 then
				DrawItem(k, v, y)
			end
		end
		if mUpdateNoticePanel.GetNewCount() > 0 then
			local image = mAssetManager.GetAsset("Texture/Gui/Text/new")
			GUI.DrawTexture(200,111,101,52,image)
		end
	GUI.EndScrollView()
	
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
		mScrollPositionY = 0
	end
end

function DrawVersion()
	if platform == "ky" or platform == "pp" or (platform == "main" and IPhonePlayer) then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,0,826,86,image)
	
	if _G.IsNewestVersion or not _G.NewestVersionUrl then
		GUI.Label(47.9, 28.5, 74.2, 30, "当前版本(V".._G.VersionName..")", GUIStyleLabel.Left_35_Brown_Art)
		local oldEnabled = GUI.GetEnabled()
		GUI.SetEnabled(false)
		GUI.Button(670, 20, 111, 60, "更新", GUIStyleButton.ShortOrangeArtBtn)
		GUI.SetEnabled(true)
	else
		GUI.Label(47.9, 28.5, 74.2, 30, "当前版本".._G.VersionName..",最新版本".._G.NewestVersionName, GUIStyleLabel.Left_35_Brown_Art)
		if GUI.Button(670, 20, 111, 60, "更新", GUIStyleButton.ShortOrangeArtBtn) then
			function okFunc()
				Application.OpenUrl(_G.NewestVersionUrl)
			end
			mAlert.Show("最新版本运行更加稳定,文件大小100M,是否下载?", okFunc)
		end
	end
end

function DrawUserCenter()
	if platform ~= "ky" and platform ~= "pp" then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,0,826,86,image)
	
	GUI.Label(47.9, 28.5, 74.2, 30, "用户中心", GUIStyleLabel.Left_35_Brown_Art)
	if GUI.Button(670, 20, 111, 60, "查看", GUIStyleButton.ShortOrangeArtBtn) then
		mSDK.ShowUserCenter()
	end
end

function DrawDesc()
	-- if platform == "main" and IPhonePlayer then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
		GUI.DrawTexture(0,0,826,86,image)
		GUI.Label(47.9, 11, 74.2, 30, "在游戏中遇到问题,欢迎向游戏官方投诉", GUIStyleLabel.Left_35_Brown)
		if mSDK.GetChannelName() ~= "185sy" then
			GUI.Label(47.9, 48, 74.2, 30, "官方QQ群:390261959", GUIStyleLabel.Left_25_Brown_Art)
		end
	-- end
end

function DrawItem(key, value, y)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,826,86,image)
	
	GUI.Label(47.9, y+28.5, 74.2, 30, SettingTypeName[key][1], GUIStyleLabel.Left_35_Brown_Art)
	if value == 1 then
		if GUI.Button(670, y+20, 111, 60, SettingTypeName[key][2], GUIStyleButton.ShortOrangeArtBtn) then
			if key == SettingType.BattleMode then
				mHeroManager.RequestSelectMode(2)
			else
				mSetManager.SetValue(key, false)
			end
		end
	else
		if GUI.Button(670, y+20, 111, 60, SettingTypeName[key][3], GUIStyleButton.ShortOrangeArtBtn) then
			function OkFunc()
				mSetManager.SetValue(key, true)
			end
			if key == SettingType.DestroyEquip1 or key == SettingType.DestroyEquip2 or
				key == SettingType.DestroyEquip3 or key == SettingType.DestroyEquip4 or
				key == SettingType.DestroyEquip0 then
				mAlert.Show("开启改项功能后，将自动分解所有的该品质装备（未穿戴并未强化），是否确认开启？", OkFunc)
			elseif key == SettingType.BattleMode then
				local hero = mHeroManager.GetHero()
				if hero.level < 28 then
					mSystemTip.ShowTip("新手期无法更换战斗模式", Color.LimeStr)
					return
				end
				mAlert.Show("切换<color=red>征战</color>模式将锁定1小时，期间会被其他玩家攻击，是否切换？",function ()
						mHeroManager.RequestSelectMode(1)
					end)			
			else
				OkFunc()
			end
		end
	end
end


