local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table
local SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property = SceneType,CFG_Equip,ConstValue,GUIStyleButton,CFG_property
local CFG_item,CFG_star = CFG_item,CFG_star
local AssetType,ItemType,DrawItemCell = AssetType,ItemType,DrawItemCell
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mScenePanel = require "LuaScript.View.Panel.ScenePanel"
local mHarborPanel = require "LuaScript.View.Panel.Harbor.HarborPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mEquipUpPanel = nil
local mEquipDestroyPanel = nil
local mEquipViewPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mStarFateManager = require "LuaScript.Control.Data.StarFateManager"
local mCommonlyFunc = nil
local mSailorManager = nil
local mItemManager = nil
local mStarViewPanel = nil
local mItemViewPanel = nil

module("LuaScript.View.Panel.StarFate.StarSelectPanel")
local mScrollPositionY = 0

local mItemList = nil
local mSelectFunc = nil
local mCount = nil

function SetData(itemList, selectFunc)
	mItemList = itemList or mStarFateManager.GetRestStarList()
	mSelectFunc = selectFunc
	mCount = math.ceil(#mItemList/7)*7
end


function Init()
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mFriendChatPanel = require "LuaScript.View.Panel.Friend.FriendChatPanel"
	mHarborPanel = require "LuaScript.View.Panel.Harbor.HarborPanel"
	mScenePanel = require "LuaScript.View.Panel.ScenePanel"
	mCharViewPanel = require "LuaScript.View.Panel.View.CharViewPanel"
	-- mRelationManager = require "LuaScript.Control.Data.RelationManager"
	mFriendFindPanel = require "LuaScript.View.Panel.Friend.FriendFindPanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mStarSetPanel = require "LuaScript.View.Panel.StarFate.StarSetPanel"
	mStarGetPanel = require "LuaScript.View.Panel.StarFate.StarGetPanel" 
	mStarViewPanel = require "LuaScript.View.Panel.StarFate.StarViewPanel"
	IsInit = true
end

function Hide()
	mScrollPositionY = 0
end

function OnGUI()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg9_1")
	GUI.DrawTexture(0,0,1136,640,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(23.75,37.5,53,58,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Button/btn12_3")
	GUI.DrawTexture(83.5,37.5,1016.75-50,58,image, 0, 0, 1, 1, 15, 15, 0, 0)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg51_2")
	GUI.DrawTexture(79,115,980,512,image)
	
	GUI.Label(525.5,48,84.2,30,"星运列表", GUIStyleLabel.Center_40_Yellowish_Art, Color.Black)
	

	local spacing = 135
	_,mScrollPositionY = GUI.BeginScrollView(137, 194, 950, 405, 0, mScrollPositionY, 0, 0, 900, spacing * mCount/7)
		for i=1,mCount do
			local x = (i-1)%7 * 125 + 25
			local y = math.floor((i-1)/7) * spacing
			
			local showY = y - mScrollPositionY / GUI.modulus
			if showY > -spacing  and showY < spacing*3 then
				local star = mItemList[i]
				DrawStar(x, y, star, i)
			end
		end
	GUI.EndScrollView()
	
	GUI.Label(140,140,84.2,30,"请选择星运", GUIStyleLabel.Left_25_White)
	if GUI.Button(1060,37.5,53,58,nil, GUIStyleButton.CloseBtn_2) then
		mSelectFunc()
		mPanelManager.Hide(OnGUI)
	end
end

function DrawStar(x, y, star, index)
	if star then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/starSlot_1")
		if DrawItemCell(CFG_star[star.bid], ItemType.Star, x-8, y-8, 100, 100)  then
			mStarViewPanel.SetData(star)
			mPanelManager.Show(mStarViewPanel)
		end
		
		if GUI.Button(x - 20, y + 80, 61, 55, "选择", GUIStyleButton.Transparent_Art_25) then
			mSelectFunc(star)
			mPanelManager.Hide(OnGUI)
		end
		if GUI.Button(x + 40, y + 80, 61, 55, "查看", GUIStyleButton.Transparent_Art_25) then
			mStarViewPanel.SetData(star)
			mPanelManager.Show(mStarViewPanel)
		end
	-- else
		-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/starSlot_1")
		-- GUI.DrawTexture(x,y,83,84,image)
	end
end
