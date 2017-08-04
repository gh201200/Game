local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table
local SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property = SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property
local AssetType = AssetType
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
local mEquipManager = require "LuaScript.Control.Data.EquipManager"
local mCommonlyFunc = nil
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mSailorViewPanel = nil
local mGuideManager = nil

module("LuaScript.View.Panel.Sailor.SailorSelectPanel")

local mScrollPositionY = 0
local mSailorList = nil
local mSelectFunc = nil

function SetData(selectFunc, sailorList)
	mSelectFunc = selectFunc -- 这一方法内含打开船员面板语句
	mSailorList = sailorList or mSailorManager.GetRestSailors()
end

function Display()
	mScrollPositionY = 0
	mSceneManager.SetMouseEvent(false)
end

function Init()
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipDestroyPanel = require "LuaScript.View.Panel.Equip.EquipDestroyPanel"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	-- mEquipManager = require "LuaScript.Control.Data.EquipManager"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mSailorViewPanel = require "LuaScript.View.Panel.Sailor.SailorViewPanel"
	mGuideManager = require "LuaScript.Control.Data.GuideManager"
	
	IsInit = true
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
	
	GUI.Label(525.5,48,84.2,30,"选择船员", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	
	local spacing = 156
	local count = #mSailorList
	_,mScrollPositionY = GUI.BeginScrollView(154, 136.4, 900, 460.5, 0, mScrollPositionY, 0, 0, 850, spacing * count)
		for k,sailor in pairs(mSailorList) do
			local y = (k-1)*spacing
			local showY = y - mScrollPositionY / GUI.modulus
			if showY > -spacing  and showY < spacing*3 then
				DrawSailor(sailor, y)
			end
		end
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
		if count < 1 then
			GUI.DrawTexture(0,spacing*0,830,144,image)
		end
		if count < 2 then
			GUI.DrawTexture(0,spacing*1,830,144,image)
		end
		if count < 3 then
			GUI.DrawTexture(0,spacing*2,830,144,image)
		end
	GUI.EndScrollView()
	
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		-- mPanelManager.Show(mPerPanelFunc)
		mSelectFunc(nil)
		mPanelManager.Hide(OnGUI)
	end
end

function DrawSailor(sailor, y)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,830,144,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..sailor.quality)
	GUI.DrawTexture(34.45, y+17,128,128,image)
	
	local image = mAssetManager.GetAsset("Texture/Character/Header/"..sailor.resId, AssetType.Icon)
	if GUI.TextureButton(39.45, y+22, 100, 100, image) then
		mSailorViewPanel.SetData(sailor)
		mPanelManager.Show(mSailorViewPanel)
	end
	
	if	sailor.quality == 3 then
	textureFiled = "item_purple"
	GUI.FrameAnimation(35-18, y-8,150, 150,textureFiled,8,0.1)
	end
	if	sailor.quality == 4 then
	textureFiled = "item_orange"
	GUI.FrameAnimation(35-20, y-3,150, 150,textureFiled,8,0.1)
	end
	
	
	GUI.Label(170, y+25, 74.2, 30, sailor.name, GUIStyleLabel.Left_35_Redbean_Art)
	
	local color = ConstValue.QualityColorStr[sailor.quality]
	local infoStr = mCommonlyFunc.BeginColor(color)
	infoStr = infoStr .. ConstValue.Quality[sailor.quality]
	infoStr = infoStr .. mCommonlyFunc.EndColor()
	GUI.Label(237, y+81, 64.2, 25, infoStr, GUIStyleLabel.Left_30_White_Art, Color.Black)
	GUI.Label(170, y+90, 64.2, 25, "品质：", GUIStyleLabel.Left_20_Black)
	
	
	local infoStr = Language[28].. sailor.power
	GUI.Label(430, y+35, 129.2, 25, infoStr, GUIStyleLabel.Left_20_Black)
	local infoStr = "贸易: ".. sailor.business
	GUI.Label(430, y+90, 129.2, 25, infoStr, GUIStyleLabel.Left_20_Black)
	
	if GUI.Button(640, y+37, 111, 60,nil, GUIStyleButton.SelectBtn) then
		mSelectFunc(sailor)
		mPanelManager.Hide(OnGUI)
		
		-- mGuideManager.SetStopGuide(true)
	end

end