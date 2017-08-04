local _G,Screen,Language,GUI,ByteArray,print,Texture2D,Input,math,Event,UnityEventType,MouseButton = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,Input,math,Event,UnityEventType,MouseButton
local PackatHead,Packat_Account,Packat_Player,require,KeyCode,pairs,table,os,ConstValue = 
PackatHead,Packat_Account,Packat_Player,require,KeyCode,pairs,table,os,ConstValue
local GUIStyleLabel,Color,SceneType,GUIStyleButton = GUIStyleLabel,Color,SceneType,GUIStyleButton
local CFG_copyMapLevel,CFG_copyMap = CFG_copyMapLevel,CFG_copyMap
local AssetType,CFG_guide,error = AssetType,CFG_guide,error
local mAssetManager = nil
local mNetManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mCreateHeroPanel = nil
local mAccountManager = nil
local mMainPanel = nil
local mHeroManager = nil
local mCopyMapManager = nil
local mCopyMapViewPanel = nil
local mSetManager = nil
local mSystemTip = nil
local mAlert = nil
module("LuaScript.View.Panel.Task.GuidePanel")
panelType = ConstValue.GuidePanel
notShowGuide = true

local mGuideId = nil
local mFunc = nil

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mCreateHeroPanel = require "LuaScript.View.Panel.Login.CreateHeroPanel"
	mAccountManager = require "LuaScript.Control.Data.AccountManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mCopyMapViewPanel = require "LuaScript.View.Panel.CopyMap.CopyMapViewPanel"
	mCopyMapManager = require "LuaScript.Control.Data.CopyMapManager"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mAlert = require "LuaScript.View.Alert.Alert"
	
	IsInit = true
end


function SetData(guideId, func)
	mGuideId = guideId
	mFunc = func
	local cfg_guide = CFG_guide[mGuideId]
	-- print(mGuideId)
	-- print(cfg_guide)
	-- print(guideId,"!!!!!!!!!!!!!!!!!!")
end

function PerGUI()
	if not IsInit then
		return
	end
	local cfg_guide = CFG_guide[mGuideId]
	
	-- if GUI.Button(cfg_guide.cancelX,cfg_guide.cancelY,113,103,nil, GUIStyleButton.NotGuideBtn) then
		-- local hero = mHeroManager.GetHero()
		-- if hero.level < 5 and not _G.IsDebug then
			-- mSystemTip.ShowTip("5级之后才能取消新手引导")
			-- return
		-- end
		-- function okFunc()
			-- mPanelManager.Hide(OnGUI)
			-- mSetManager.SetGuide(false)
		-- end
		-- mPanelManager.Hide(OnGUI)
		-- mAlert.Show("是否关闭新手引导？", okFunc)
	-- end
	
	if cfg_guide.force == 1 then
		GUI.Button(0,0,1136,cfg_guide.y,nil,GUIStyleButton.Transparent)
		
		GUI.Button(0,cfg_guide.y,cfg_guide.x,cfg_guide.heigth,nil,GUIStyleButton.Transparent)
		GUI.Button(cfg_guide.x+cfg_guide.width,cfg_guide.y,1136,cfg_guide.heigth,nil,GUIStyleButton.Transparent)
		
		GUI.Button(0,cfg_guide.y+cfg_guide.heigth,1136,640,nil,GUIStyleButton.Transparent)
	end
	
	if mFunc then
		if GUI.Button(cfg_guide.x, cfg_guide.y, cfg_guide.width, cfg_guide.heigth, nil, GUIStyleButton.Transparent) then
			mFunc()
		end
	end
	
	-- GUI.Button(0,0,1136,y1,nil)
	
	-- GUI.Button(0,y1,x1,heigth1,nil)
	-- GUI.Button(x1+width1,y1,1136,heigth1,nil)
	
	-- GUI.Button(0,y1+heigth1,1136,y2-y1-heigth1 ,nil)
	
	-- GUI.Button(0,y2,x2,heigth2,nil)
	-- GUI.Button(width2+x2,y2,1136,heigth2,nil)
	
	-- GUI.Button(0,y2+heigth2,1136,640,nil)
end

function OnGUI()
	if not IsInit then
		return
	end
	
	local cfg_guide = CFG_guide[mGuideId]
	if cfg_guide.type == -1 then
		GUI.Label(575, 395, 0, 0, "自动寻路中...",GUIStyleLabel.Center_30_Yellow, Color.Black)
	else
		if cfg_guide.rect == 1 then
			local v =  math.abs(math.sin(os.oldClock*2)) * 0.3 + 0.5
			local color = Color.Init(v,v,v,v)
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/select2")
			GUI.DrawTexture(cfg_guide.x-10,cfg_guide.y-10,cfg_guide.width+20,cfg_guide.heigth+21,image,0,0,1,1,20,20,20,20,color)
		end
		-- print(cfg_guide.y-10)
		local dir = cfg_guide.dir
		if dir == 0 then
			if cfg_guide.y > 450 then
				dir = 1
			end
		elseif dir == 1 then
			if cfg_guide.y < 150 then
				dir = 0
			end
		elseif dir == 2 then
			if cfg_guide.x > 900 then
				dir = 3
			end
		elseif dir == 3 then
			if cfg_guide.x < 150 then
				dir = 2
			end
		end
		
		local offset =  math.abs(math.sin(os.oldClock*3)) * 20
		if dir == 0 then
			local x = cfg_guide.x + cfg_guide.width/2 - 32
			local y = cfg_guide.y + cfg_guide.heigth + offset
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/dir_2")
			GUI.DrawTexture(x,y,64,64,image)
			
			local x = x + 32
			local y = y + 64
			GUI.Label(x, y, 0, 0, cfg_guide.desc,GUIStyleLabel.Center_30_Yellow, Color.Black)
		elseif dir == 1 then
			local x = cfg_guide.x + cfg_guide.width/2 - 32
			local y = cfg_guide.y - 64 - offset
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/dir_2")
			GUI.DrawTexture(x,y,64,64,image,0,1,1,-1,0,0,0,0)
			
			local x = x + 32
			local y = y - 20
			GUI.Label(x, y, 0, 0, cfg_guide.desc,GUIStyleLabel.Center_30_Yellow, Color.Black)
		elseif dir == 2 then
			local x = cfg_guide.x + cfg_guide.width + offset
			local y = cfg_guide.y + cfg_guide.heigth/2 - 32
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/dir_1")
			GUI.DrawTexture(x,y,64,56,image,1,0,-1,1,0,0,0,0)
			
			local x = x + 64
			local y = cfg_guide.y + cfg_guide.heigth/2
			GUI.Label(x, y, 0, 0, cfg_guide.desc,GUIStyleLabel.MLeft_30_Yellow, Color.Black)
		elseif dir == 3 then
			local x = cfg_guide.x - 64 - offset
			local y = cfg_guide.y + cfg_guide.heigth/2 - 32
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/dir_1")
			GUI.DrawTexture(x,y,64,64,image)
			
			local x = x
			local y = cfg_guide.y + cfg_guide.heigth/2
			GUI.Label(x, y, 0, 0, cfg_guide.desc,GUIStyleLabel.MRight_30_Yellow, Color.Black)
		end		
	end
	
	-- GUI.Button(cfg_guide.cancelX,cfg_guide.cancelY,113,103,nil, GUIStyleButton.NotGuideBtn)
end