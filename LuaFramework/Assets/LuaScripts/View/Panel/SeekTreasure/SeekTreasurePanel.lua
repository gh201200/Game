local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel
local AssetPath,AssetType = AssetPath,AssetType
local CFG_treasurePos = CFG_treasurePos
local mAssetManager = nil
local mGUIStyleManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mTreasureManager = nil
local mAlert = nil
local mHeroManager = nil
local mSetManager = nil
local mSystemTip = nil
local mMapPanel = nil
local mItemManager = nil
local mMainPanel = nil
local mItemBagPanel = nil
local table = table
local mPathManager = require "LuaScript.Control.Scene.PathManager" -- 路径管理
module("LuaScript.View.Panel.SeekTreasure.SeekTreasurePanel") -- 寻宝指引面板

local mInfo = "小提示：打开世界地图\n点击地图中海面,\n就会会出现一个坐标点,\n根据宝藏大致坐标移动地图寻宝\nPS：(从左往右X坐标增大,\n从下往上Y坐标增大)\n东南方向的零点在惠灵顿附近"

local getTreasure = nil
local mScrollPositionY = 0
local mScrollPositionX = 0
local mapX,mapY,mapW,mapH = 0
panelType = ConstValue.AlertPanel
local TreasureKey = nil

function Init()
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mAlert = require "LuaScript.View.Alert.Alert"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mTreasureManager = require "LuaScript.Control.Scene.TreasureManager"
	mMapPanel = require "LuaScript.View.Panel.Map.MapPanel"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mItemBagPanel = require "LuaScript.View.Panel.Item.ItemBagPanel"
	getTreasure = nil
	IsInit = true
end

function Display()
	mSceneManager.SetMouseEvent(false)
end

function GetTreasureKey()
    return TreasureKey
end

local num = 0  
function SetTreasurePos()
    local posList = {}
	for k ,item in pairs (CFG_treasurePos) do 
	    table.insert(posList,{x = item.x,y = item.y,type = 1})
	end
    getTreasure = posList[num]
	print(posList[num].x)
end

function OnGUI()

	if not Init then
		return
	end
	
	-- if GUI.Button(150, 350, 100, 60, '下一张', GUIStyleButton.ShortOrangeBtn) then
		-- num = num + 1
		-- SetTreasurePos()
		-- print(num)
	-- end -- 可以用于检查藏宝图表中是否有错误的图，需要将下方获取宝图代码块注掉
	
	local getTreasure = mTreasureManager.getTreasure()
	if not getTreasure	then
	   return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg_SeekTreasure")
	GUI.DrawTexture(250,10,634,625,image)
	GUI.Label(500, 160, 144, 150, mInfo, GUIStyleLabel.Center_35_Brown_Art)
	--获取藏宝图提示图片
	
	-- print(getTreasure)
	local mapX,mapY,mapW,mapH = 0
    if getTreasure then
		mapX = getTreasure.x
		mapY = getTreasure.y
		mapW = math.floor(((mapX/512)%1)*512)
		mapH = math.floor((((mapY/512)/1.414)%1)*512)
		mapX = math.floor(mapX/512)
		mapY = math.floor((mapY/512)/1.414)
		local mapPath = "map/0/"..mapX..'_'..mapY
        TreasureKey = mapPath
	mScrollPositionX,mScrollPositionY = GUI.BeginScrollView(314,38,512,512, mScrollPositionX,mScrollPositionY, 0, 0,512,512)
		--绘制示意图
		local image = mAssetManager.GetAsset(mapPath, AssetType.Map)
		GUI.DrawTexture(0,0,512,512,image)
		--绘制标记
	    local image = mAssetManager.GetAsset("Texture/Gui/Button/SeekTreasure_tip")
		if mapW > 450 then
		   mapW = 450
		end
		if (512-mapH)>460 then
		    mapH = 63
		end
	    GUI.DrawTexture(mapW, 512-mapH, 79, 67,image) 
	GUI.EndScrollView()
	GUI.Label(640, 568, 200, 30,"("..(mapX*512)..","..math.floor(mapY*512*1.414)..")附近",GUIStyleLabel.Center_25_Red)
	elseif not getTreasure	then
		TreasureKey = 1
	end
	
	
	if GUI.Button(816, 10, 64, 64, nil, GUIStyleButton.CloseBtn_4) then
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
	end
	
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/SeekTreasure_top")
	GUI.DrawTexture(465,0,206,71,image)
	if getTreasure then
	local cost = (getTreasure.type-1)*20 + 40 or 100
	if GUI.Button(300, 556, 113, 61,"元宝挖取", GUIStyleButton.ShortOrangeBtn) then
		if not getTreasure	then
			mSystemTip.ShowTip('使用藏宝图后点击')
			return
		end
		function ok()
			mItemManager.RequestGoldGetTreasure()
			mPanelManager.Hide(OnGUI)
			mSceneManager.SetMouseEvent(true)
		end
		mAlert.Show("需要消耗<color=red>"..cost.."</color>元宝直接获取到宝藏吗？",ok)
	end
	end
	-- mItemManager.RequestGoldGetTreasure() -- 获取宝藏并扣钱（40.60.80.100）

	if GUI.Button(505, 556, 113, 61,"查看地图", GUIStyleButton.ShortOrangeBtn) then
		mMapPanel.ResetCenter()
		mPanelManager.Show(mMapPanel)
		mPanelManager.Hide(mMainPanel)
		mPanelManager.Hide(mItemBagPanel)
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(false)
	end
	
end

-- function SelectPathPoint(gotoX,gotoY,mapID) --传送点是否可以行走的判断
    -- if mPathManager.CouldWalk(gotoX,gotoY,0) then
	   -- return gotoX,gotoY
	-- else
	  -- local dis = 50
	  -- local points = {}
	  -- for k = 1 ,6 do
		-- points[1] = {x = gotoX + dis * k, y = gotoY + dis* k}
		-- points[2] = {x = gotoX + dis * k, y = gotoY - dis* k}
		-- points[3] = {x = gotoX - dis * k, y = gotoY + dis* k}
		-- points[4] = {x = gotoX - dis * k, y = gotoY - dis* k}
		-- points[5] = {x = gotoX + dis * k, y = gotoY }
		-- points[6] = {x = gotoX - dis * k, y = gotoY }
		-- points[7] = {x = gotoX , y = gotoY + dis * k}
		-- points[8] = {x = gotoX , y = gotoY - dis * k}
		
		-- for k = 1 , 8 do
		    -- if mPathManager.CouldWalk(points[k].x, points[k].y, 0) then
			   -- return points[k].x,points[k].y
			-- end
		-- end
	  -- end
	-- end
-- end 