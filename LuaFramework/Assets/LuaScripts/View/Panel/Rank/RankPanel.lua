local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table
local SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property = SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property
local CFG_item = CFG_item
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
local mSailorManager = nil
local mItemManager = nil
local mRankManager = nil
local mItemViewPanel = nil

module("LuaScript.View.Panel.Rank.RankPanel")

local mScrollPositionY = 0
local mPage = 0

function Init()
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mSailorManager = require "LuaScript.Control.Data.SailorManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipDestroyPanel = require "LuaScript.View.Panel.Equip.EquipDestroyPanel"
	mEquipViewPanel = require "LuaScript.View.Panel.Equip.EquipViewPanel"
	-- mEquipManager = require "LuaScript.Control.Data.EquipManager"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mItemViewPanel = require "LuaScript.View.Panel.Item.ItemViewPanel"
	mRankManager = require "LuaScript.Control.Data.RankManager"
	
	IsInit = true
end

function Display()
	mPage = 0
	mScrollPositionY = 0
	mSceneManager.SetMouseEvent(false)
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
	GUI.DrawTexture(506,37.5,542,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	-- 战力
	if mPage == 0 then
		GUI.Button(87.5,38.3,134,58, "战力", GUIStyleButton.PagBtn_2)
		
		local image = mAssetManager.GetAsset("Texture/Gui/Text/selfRank")
		GUI.DrawTexture(192,546,180,55,image)
		local image = mAssetManager.GetAsset("Texture/Gui/Text/selfPower")
		GUI.DrawTexture(565,546,224,55,image)
		
		GUI.Label(222, 132, 84, 30, "排名", GUIStyleLabel.Left_35_Redbean_Art)
		GUI.Label(436, 132, 84, 30, "名字", GUIStyleLabel.Left_35_Redbean_Art)
		GUI.Label(658, 132, 84, 30, "等级", GUIStyleLabel.Left_35_Redbean_Art)
		GUI.Label(843, 132, 84, 30, "战力", GUIStyleLabel.Left_35_Redbean_Art)
	elseif GUI.Button(87.5,38.3,134,58, "战力", GUIStyleButton.PagBtn_1) then
		mPage = 0
		mScrollPositionY = 0
	end
	
	-- [92] = "财富",
	if mPage == 1  then
		GUI.Button(226.55,38.3,134,58, "财富", GUIStyleButton.PagBtn_2)
		local image = mAssetManager.GetAsset("Texture/Gui/Text/selfRank")
		GUI.DrawTexture(192,546,180,55,image)
		local image = mAssetManager.GetAsset("Texture/Gui/Text/selfMoney")
		GUI.DrawTexture(606,546,180,55,image)

		GUI.Label(222, 132, 84, 30, "排名", GUIStyleLabel.Left_35_Redbean_Art)
		GUI.Label(436, 132, 84, 30, "名字", GUIStyleLabel.Left_35_Redbean_Art)
		GUI.Label(658, 132, 84, 30, "等级", GUIStyleLabel.Left_35_Redbean_Art)
		GUI.Label(843, 132, 84, 30, "银两", GUIStyleLabel.Left_35_Redbean_Art)
	elseif GUI.Button(226.55,38.3,134,58, "财富", GUIStyleButton.PagBtn_1) then
		mPage = 1
		mScrollPositionY = 0
	end
	
	-- [93] = "势力",
	if mPage == 2  then
		GUI.Button(365.7,38.3,134,58, "势力", GUIStyleButton.PagBtn_2)
		local image = mAssetManager.GetAsset("Texture/Gui/Text/selfRank")
		GUI.DrawTexture(192,546,180,55,image)
		local image = mAssetManager.GetAsset("Texture/Gui/Text/selfHarbor")
		GUI.DrawTexture(565,546,224,55,image)

		GUI.Label(222, 132, 84, 30, "排名", GUIStyleLabel.Left_35_Redbean_Art)
		GUI.Label(436, 132, 84, 30, "名字", GUIStyleLabel.Left_35_Redbean_Art)
		GUI.Label(658, 132, 84, 30, "类型", GUIStyleLabel.Left_35_Redbean_Art)
		GUI.Label(843-15, 132, 84, 30, "港口数", GUIStyleLabel.Left_35_Redbean_Art)
	elseif GUI.Button(365.7,38.3,134,58, "势力", GUIStyleButton.PagBtn_1) then
		mPage = 2
		mScrollPositionY = 0
	end
	
	GUI.Label(815, 55, 274, 30, "排行榜数据整点刷新", GUIStyleLabel.Left_25_Yellowish)
	
	local list = mRankManager.GetSelfData(mPage)
	if list then
		if list.rank == 0 then
			GUI.Label(396, 559, 99, 30, "--", GUIStyleLabel.Left_35_Redbean_Art)
			GUI.Label(806, 559, 99, 30, "--", GUIStyleLabel.Left_35_Redbean_Art)
		else
			GUI.Label(396, 559, 99, 30, list.rank, GUIStyleLabel.Left_35_Redbean_Art)
			GUI.Label(806, 559, 99, 30, list.value, GUIStyleLabel.Left_35_Redbean_Art)
		end
	end
	
	local spacing = 75
	local list = mRankManager.GetList(mPage)
	_,mScrollPositionY = GUI.BeginScrollView(154, 171.4, 900, 365, 0,mScrollPositionY, 0, 0, 850, spacing * 50)
		for k=1,50 do
			item = list[k]
			local y = (k-1)*spacing
			local showY = y - mScrollPositionY / GUI.modulus
			if showY > -spacing  and showY < spacing*5 then
				DrawItem(item, y, k)
			end
		end
	GUI.EndScrollView()
	
	
	
	if GUI.Button(1060.5,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
		mScrollPositionY = 0
	end
end

function DrawItem(item, y, k)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg6_1")
	GUI.DrawTexture(0,y,831,65,image)
	if not item then
		mRankManager.RequestRankData(mPage, math.ceil(k/10))
		return
	end
	
	if k == 1 then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/th1")
		GUI.DrawTexture(80-7,y+3,60,54,image)
	elseif k == 2 then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/th2")
		GUI.DrawTexture(83-7,y+4,54,53,image)
	elseif k == 3 then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/th3")
		GUI.DrawTexture(89-7,y+8,42,47,image)
	else
		GUI.Label(64, y+12, 74.2, 30, k.."th", GUIStyleLabel.Center_35_Redbean)
	end
	
	if mPage == 0 then
		GUI.Label(280, y+12, 74.2, 30, item.name, GUIStyleLabel.Center_35_Redbean_Art)
		GUI.Label(513, y+12, 50.35, 100, item.exValue, GUIStyleLabel.Center_35_Redbean)
		GUI.Label(700, y+12, 50.35, 100, item.value, GUIStyleLabel.Center_35_Redbean)
	elseif mPage == 1 then
		GUI.Label(280, y+12, 74.2, 30, item.name, GUIStyleLabel.Center_35_Redbean_Art)
		GUI.Label(513, y+12, 50.35, 100, item.exValue, GUIStyleLabel.Center_35_Redbean)
		GUI.Label(700, y+12, 50.35, 100, item.value, GUIStyleLabel.Center_35_Redbean)
	else
		GUI.Label(280, y+12, 74.2, 30, item.name, GUIStyleLabel.Center_35_Redbean_Art)
		GUI.Label(513, y+12, 50.35, 100, ConstValue.HarborMasterType[item.exValue], GUIStyleLabel.Center_35_Redbean_Art)
		GUI.Label(700, y+12, 50.35, 100, item.value, GUIStyleLabel.Center_35_Redbean)
	end
end


