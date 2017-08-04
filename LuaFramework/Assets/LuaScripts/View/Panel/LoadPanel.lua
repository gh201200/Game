local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,CFG_sign,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,CFG_sign,os
local ConstValue,EventType,AppearEvent,GUIStyleButton,CsSetCextColor,GUIUtility = 
ConstValue,EventType,AppearEvent,GUIStyleButton,CsSetCextColor,GUIUtility
local mAssetManager = require "LuaScript.Control.AssetManager"
local mPanelManager = nil
local mMainPanel = nil
local mSceneManager = nil
local mCommonlyFunc = nil
local mHeroManager = nil
local mGUIStyleManager = nil

module("LuaScript.View.Panel.LoadPanel")
panelType = ConstValue.LoadPanel
notAutoClose = true
local mSignIndex = 1
local mStartTime = nil
local pivotPoint1 = nil
local pivotPoint2 = nil
local pivotPoint3 = nil
local mAngle = 0
function Init()
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	
	pivotPoint1 = Vector2.New(GUI.HorizontalRestX(152+76/2),GUI.VerticalRestY(464+77/2))
	pivotPoint2 = Vector2.New(GUI.HorizontalRestX(124+46/2),GUI.VerticalRestY(534+46/2))
	pivotPoint3 = Vector2.New(GUI.HorizontalRestX(912+52/2),GUI.VerticalRestY(528+52/2))
	
	IsInit = true
end

function Display()
	AppearEvent(nil, EventType.OnLoadStart)
end

function Hide()
	mSceneManager.SetMouseEvent(true)
end

function PerGUI()
	GUI.Button(0,0,1500,800,nil,GUIStyleButton.Transparent)
end

function OnGUI()
	mStartTime = mStartTime or os.oldClock
	local useTime = os.oldClock - mStartTime
	if useTime > 2.5 then
		mPanelManager.Hide(OnGUI)
		-- mPanelManager.Show(mMainPanel)
		mStartTime = nil
		mSignIndex = mSignIndex + 1
		
		AppearEvent(nil, EventType.OnLoadComplete)
		AppearEvent(nil, EventType.CheckAllTask)
		-- mHeroManager.requestJoinMapCompete()
		return
	end
	
	mAngle = mAngle + 1
	
	if not CFG_sign[mSignIndex] then
		mSignIndex = 1
	end
	local sign = CFG_sign[mSignIndex]
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/loadbg")
	if useTime > 2 then
		local alpha = (2.5-useTime)
		local color = Color.Init(alpha,alpha,alpha,alpha)
		-- GUI.DrawTexture(0,0,1136,640,image,0,0,1,1,0,0,0,0,color)
		-- GUI.DrawTexture(0,0,1024,640,image,0,0,1,640/1024,color)
		-- GUI.DrawTexture(1000,0,256,256,image,0,700/1024,256/1024,256/1024,color)
		-- GUI.DrawTexture(1000,256,256,256,image,256/1024,700/1024,256/1024,256/1024,color)
		-- GUI.DrawTexture(1000,512,256,256,image,512/1024,700/1024,256/1024,256/1024,color)
		GUI.DrawPackerTexture(image,color)
		
		GUIUtility.RotateAroundPivot(mAngle, pivotPoint2)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/chilun2")
		GUI.DrawTexture(124, 534, 46, 46, image,0,0,1,1,0,0,0,0,color)
		GUIUtility.RotateAroundPivot(-mAngle, pivotPoint2)
		
		-- local colorAlpha = math.floor(99*alpha*2)
		if alpha < 0.1 then
			alpha = 0.1
		end
		-- print(Color.Init(1,1,1,alpha))
		local style = mGUIStyleManager.GetGUIStyle(GUIStyleLabel.Center_30_Change)
		CsSetCextColor(style.normal, Color.Init(1,1,1,alpha))
		local style = mGUIStyleManager.GetGUIStyle(GUIStyleLabel.Center_30_Change, nil, Color.Black)
		CsSetCextColor(style.normal, Color.Init(0,0,0,alpha))
		GUI.Label(0,470,1136,0,sign.str,GUIStyleLabel.Center_30_Change)
		
		
		-- GUI.BeginGroup(110, 500, 600, 50)
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg19_1")
			GUI.DrawTexture(128, 515, 861, 47, image, 0, 0, 1, 1, 73, 73, 0, 0, color)

			local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg19_2")
			GUI.DrawTexture(165, 520, 788, 32, image, 0, 0, 1, 1, 0, 0, 0, 0, color)
			
			local infoStr = Language[130]
			infoStr = infoStr .. "100%"
			GUI.Label(0,521,1136,30,infoStr,GUIStyleLabel.Center_25_White)
		-- GUI.EndGroup()
		
		GUIUtility.RotateAroundPivot(mAngle, pivotPoint1)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/chilun1")
		GUI.DrawTexture(152, 464, 76, 77, image,0,0,1,1,0,0,0,0,color)
		GUIUtility.RotateAroundPivot(-mAngle, pivotPoint1)
		
		GUIUtility.RotateAroundPivot(mAngle, pivotPoint3)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/chilun3")
		GUI.DrawTexture(912, 528, 52, 52, image,0,0,1,1,0,0,0,0,color)
		GUIUtility.RotateAroundPivot(-mAngle, pivotPoint3)
	else
		-- GUI.DrawTexture(0,0,1024,640,image,0,0,1,640/1024)
		-- GUI.DrawTexture(1000,0,256,256,image,0,700/1024,256/1024,256/1024)
		-- GUI.DrawTexture(1000,256,256,256,image,256/1024,700/1024,256/1024,256/1024)
		-- GUI.DrawTexture(1000,512,256,256,image,512/1024,700/1024,256/1024,256/1024)
		GUI.DrawPackerTexture(image)
		
		GUIUtility.RotateAroundPivot(mAngle, pivotPoint2)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/chilun2")
		GUI.DrawTexture(124, 534, 46, 46, image)
		GUIUtility.RotateAroundPivot(-mAngle, pivotPoint2)
		
		-- GUI.Label(0,450,1136,0,sign.str,GUIStyleLabel.Center_30_Redbean,Color.Black)
		local colorStr = "ffffffff"
		local info = mCommonlyFunc.BeginColor(colorStr)
		info = info .. sign.str
		info = info .. mCommonlyFunc.EndColor()
		GUI.Label(0,470,1136,0,info,GUIStyleLabel.Center_30_White)
		
		-- GUI.BeginGroup(110, 500, 930, 50)
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg19_1")
			GUI.DrawTexture(128, 515, 861, 47, image)
			local mProgress = useTime / 2
			if mProgress > 1 then
				mProgress = 1
			end
			-- local mProgressWidth = mProgress * (GUI.HorizontalRestWidth(930) - 132 )
			local mProgressWidth = mProgress * 788
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg19_2")
			-- GUI.DrawTexture(GUI.UnHorizontalRestX(66), 21, GUI.UnHorizontalWidth(mProgressWidth), 32, image, 0, 0, mProgress, 1)
			GUI.DrawTexture(165, 520, mProgressWidth, 32, image, 0, 0, mProgress, 1)
			
			local infoStr = Language[130]
			-- infoStr = infoStr .. mCommonlyFunc.BeginColor(Color.LimeStr)
			infoStr = infoStr .. math.floor(mProgress*100)
			infoStr = infoStr .. "%"
			-- infoStr = infoStr .. mCommonlyFunc.EndColor()
			GUI.Label(0,521,1136,30,infoStr,GUIStyleLabel.Center_25_White)
		-- GUI.EndGroup()
		
		
		GUIUtility.RotateAroundPivot(mAngle, pivotPoint1)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/chilun1")
		GUI.DrawTexture(152, 464, 76, 77, image)
		GUIUtility.RotateAroundPivot(-mAngle, pivotPoint1)
		
		GUIUtility.RotateAroundPivot(mAngle, pivotPoint3)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/chilun3")
		GUI.DrawTexture(912, 528, 52, 52, image)
		GUIUtility.RotateAroundPivot(-mAngle, pivotPoint3)
	end
end