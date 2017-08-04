local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel
local AssetPath = AssetPath

local mAssetManager = nil
local mGUIStyleManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mTreasureManager = require "LuaScript.Control.Scene.TreasureManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mAlert = nil
local mHeroManager = nil
local mSetManager = nil

module("LuaScript.View.Panel.View.Guide.TreasurePanel") -- 藏宝图指引界面

local mInfo = "1、打开人物头像下的小地图,选择\"征服之海\"海域.\n2、点击地图海面即会出现一个坐标点,根据宝藏坐标移动地图(越往右X坐标越大,越往上Y坐标越大),找到一个相近的坐标点,选择导航或传送.\n3、到达坐标点后,对比当前位置与宝藏坐标,在附近寻找即可找到宝藏."
local mName = "藏宝图"
local mScrollView = 0
local mScrollPositionY = 0
panelType = ConstValue.AlertPanel

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mScrollView = GUI.GetTextHeight(mInfo, 427, GUIStyleLabel.Left_25_White_WordWrap) + 10
	mAlert = require "LuaScript.View.Alert.Alert"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mSetManager = require "LuaScript.Control.System.SetManager"
	
	IsInit = true
end

function OnGUI()
	local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_Bg31_1)
	GUI.DrawTexture(286,150,560,427,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(346,241,443,255,image,0,0,1,1,15,15,15,15)
	GUI.Label(500, 190, 144, 150, mName, GUIStyleLabel.Center_35_Brown_Art)
	
	_,mScrollPositionY = GUI.BeginScrollView(356,242,457,250, 0,mScrollPositionY, 0, 0,427, mScrollView)
		GUI.Label(0, 10, 427, mScrollView, mInfo, GUIStyleLabel.Left_25_Redbean_WordWrap)
	GUI.EndScrollView()
	
	if GUI.Button(773, 138, 77, 63, nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
	
	-- if _G.IsDebug and GUI.Button(680, 190, 77, 50, "传送", GUIStyleButton.ShortOrangeBtn) then
		-- function ok()
			-- mHeroManager.RequestFly(0,mTreasureManager.mTreasure.x,mTreasureManager.mTreasure.y,0)
		-- end
		-- mAlert.Show("要直接传送到宝藏所在位置吗？",ok)
	-- end
	
	-- if mSetManager.GetTreasurePosition() then -- 宝藏位置显示和隐藏
		-- if GUI.Button(645, 495, 128, 32, nil, GUIStyleButton.ShowBtn_4) then
			-- mSetManager.SetTreasurePosition(false)
		-- end
	-- else
		-- if GUI.Button(645, 495, 128, 32, nil, GUIStyleButton.ShowBtn_2) then
			-- mSetManager.SetTreasurePosition(true)
		-- end
	-- end
end