local _G,Screen,Language,GUI,ByteArray,print,Texture2D,Input,math,Event,UnityEventType,MouseButton,CFG_map,AppearEvent = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,Input,math,Event,UnityEventType,MouseButton,CFG_map,AppearEvent
local PackatHead,Packat_Account,Packat_Player,require,KeyCode = PackatHead,Packat_Account,Packat_Player,require,KeyCode
local GUIStyleLabel,Color,SceneType,GUIStyleButton,EventType,CFG_send,AssetType,CFG_boss,CFG_EnemyPosition,CFG_Enemy = 
GUIStyleLabel,Color,SceneType,GUIStyleButton,EventType,CFG_send,AssetType,CFG_boss,CFG_EnemyPosition,CFG_Enemy
local CFG_harbor,pairs,table,ConstValue,MapTexture,_G,CsIsNull,CsGetTouchInfo,VersionCode,WindowsEditor,WindowsPlayer,IPhonePlayer = 
CFG_harbor,pairs,table,ConstValue,MapTexture,_G,CsIsNull,CsGetTouchInfo,VersionCode,WindowsEditor,WindowsPlayer,IPhonePlayer
local CFG_fishArea = CFG_fishArea
local mAssetManager = nil
local mNetManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mCreateHeroPanel = nil
local mAccountManager = nil
local mMainPanel = nil
-- local mMoveSelectPanel = nil
local mSystemTip = nil
local mShipManager = nil
local mHarborManager = nil
local mSendManager = nil
local mPathManager = require "LuaScript.Control.Scene.PathManager"
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
module("LuaScript.View.Panel.Map.MapPanel")

local mCenterX = nil
local mCenterY = nil

local oldDrawIndex = -1

local mMapId = 0
local mHarborList = nil
local mSendList = nil

local mShowMoveSelect = false
local mMoveSelectX = 0
local mMoveSelectY = 0
local mToHarborId = nil
local mToMapId = 0
local mToX = 0
local mToY = 0

function Init()
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mShipManager = require "LuaScript.Control.Data.ShipManager"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mCreateHeroPanel = require "LuaScript.View.Panel.Login.CreateHeroPanel"
	mAccountManager = require "LuaScript.Control.Data.AccountManager"
	-- mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	-- mMoveSelectPanel = require "LuaScript.View.Panel.Map.MoveSelectPanel"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mSendManager = require "LuaScript.Control.Scene.SendManager"
	
	IsInit = true
end

function Display()
	local hero = mHeroManager.GetHero()
	mMapId = hero.map
	mCenterX = hero.x
	mCenterY = hero.y
	oldDrawIndex = -1
	mShowMoveSelect = false
	RevisePosition()
	
end

function SetCenter(x, y)
	mCenterX = x
	mCenterY = y
	RevisePosition()
end

function GetMoveSelectVisible()
	return mShowMoveSelect
end

function OnGUI()
	local cfg_map = CFG_map[mMapId]
	local hero = mHeroManager.GetHero()
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg15_1")
	-- GUI.DrawTexture(0,0,1136,640,image)
	
	local drawRowIndex = math.floor(mCenterX / MapTexture.width * 2.1)
	local drawColIndex = math.floor(mCenterY / MapTexture.height * 2.1)
	if oldDrawIndex ~= drawRowIndex + drawColIndex * 10000 + mMapId * 1000000 then
		oldDrawIndex = drawRowIndex + drawColIndex * 10000 + mMapId * 1000000
		InitHarborList()
		InitSendList()
	end
	
			
	local buttonFunc = nil
	local drawTextureFunc = nil
	local labelFunc = nil
	local guiStyleLabel1 = nil
	local guiStyleLabel2 = nil
	if GUI.modulus <= 1 then
		buttonFunc = GUI.UnScaleButton
		drawTextureFunc = GUI.UnScaleDrawTexture
		labelFunc = GUI.UnScaleLabel
		guiStyleLabel1 = GUIStyleLabel.MCenter_20_Orange_Unscale
		guiStyleLabel2 = GUIStyleLabel.MCenter_25_SimpleYellow2_Unscale
		guiStyleLabel3 = GUIStyleLabel.MCenter_20_Lime_Unscale
	else
		buttonFunc = GUI.Button
		drawTextureFunc = GUI.DrawTexture
		labelFunc = GUI.Label
		guiStyleLabel1 = GUIStyleLabel.MCenter_20_Orange
		guiStyleLabel2 = GUIStyleLabel.MCenter_25_SimpleYellow2
		guiStyleLabel3 = GUIStyleLabel.MCenter_20_Lime
	end
		
	
	if mShowMoveSelect then
		if buttonFunc(mMoveSelectX,mMoveSelectY+6,74,83,nil, GUIStyleButton.Transparent) then
			local hero = mHeroManager.GetHero()
			if mToHarborId then
				mHeroManager.SetTarget(ConstValue.HarborType, mToHarborId)
			else
				mHeroManager.SetTarget(ConstValue.PositionType, {map=mToMapId,x=mToX,y=mToY})
			end
			function SetShipFunc()
				mPanelManager.Hide(OnGUI)
			end
			if hero.SceneType == SceneType.Harbor then
				if mShipManager.CheckDutyShip(SetShipFunc) then
					mHarborManager.RequestLeaveHarbor()
				end
			else
				mHeroManager.Goto(mToMapId, mToX, mToY)
				mPanelManager.Hide(OnGUI)
				mPanelManager.Show(mMainPanel)
				mSceneManager.SetMouseEvent(true)
			end
		end
		if buttonFunc(mMoveSelectX+74,mMoveSelectY,70,92,nil, GUIStyleButton.Transparent) then
			mHeroManager.RequestFly(mToMapId, mToX, mToY, mToHarborId or 0)
		end
	end
		
	GUI.BeginGroup(55,109,1024,512)
	-- if mMapId == 0 then
		if Input.GetTouchCount() > 0 and GUI.GetEnabled() then
			local toucheX,toucheY,deltaX,deltaY = 0,0,0,0
			if CsGetTouchInfo then
				toucheX,toucheY,deltaX,deltaY = CsGetTouchInfo(0)
			else
				local touche = Input.GetTouch(0)
				local position = touche.position
				local deltaPosition = touche.deltaPosition
				if not CsIsNull(deltaPosition) then
					toucheX,toucheY = position.x, position.y
					deltaX,deltaY = deltaPosition.x,deltaPosition.y
				end
			end
			if WindowsEditor or WindowsPlayer or IPhonePlayer then
				deltaX = deltaX * 0.4
				deltaY = deltaY * 0.4
			end
			toucheY = Screen.height - toucheY
			
			-- if toucheX > 55 and toucheX < 55 + 1024 and toucheY > 109 and toucheY < 512 + 109 then
				mCenterX = mCenterX - deltaX / cfg_map.scaleX
				mCenterY = mCenterY - deltaY / cfg_map.scaleY
			-- end
			
			-- mShowMoveSelect = false
		end
		
		RevisePosition()
		
		-- print(mCenterX,mCenterY)
		local mScaleCenterX = mCenterX * cfg_map.scaleX
		local mScaleCenterY = (cfg_map.height - mCenterY) * cfg_map.scaleY
		
		local showWidth = 512
		local showHeight = 256
		local widthCount = 3
		local heightCount = 3
		local horizontalCount = cfg_map.width / 512 * cfg_map.scaleX
		local startX = (math.floor(mScaleCenterX/showWidth-1)*showWidth + cfg_map.width*cfg_map.scaleX) % (cfg_map.width*cfg_map.scaleX)
		local startY = math.floor(mScaleCenterY/showHeight-1)*showHeight

		local startIndex = math.floor(startX / showWidth)  + math.floor(startY/showHeight) * horizontalCount
		for i=0,widthCount*heightCount-1,1 do
			local textureX = (startIndex % horizontalCount + i % widthCount) % horizontalCount
			local textureY = math.floor(startIndex / horizontalCount) + math.floor(i / widthCount)
			local drawX = textureX * showWidth - mScaleCenterX + 512 * math.min(GUI.modulus, 1)
			local drawY = textureY * showHeight - mScaleCenterY + 256 *  math.min(GUI.modulus, 1)
			
			if math.abs(drawX) > math.abs(drawX - 2048) then
				drawX = drawX - 2048
			elseif math.abs(drawX) > math.abs(drawX + 2048) then
				drawX = drawX + 2048
			end
			
			textureX = textureX % horizontalCount
			local image = mAssetManager.GetAsset("smallMap/".. mMapId .. "/" .. textureX+textureY*horizontalCount,nil,nil,true)
			if image then
				drawTextureFunc(drawX, drawY, 512, image.height, image)
			end
		end
	-- elseif mMapId == 2 then
		-- local image = mAssetManager.GetAsset("smallMap/2/0")
		-- GUI.DrawTexture(0,0,1024,512,image)
	-- end
	
	for k,id in pairs(mHarborList) do
		local cfg_harbor = CFG_harbor[id]
		local x,y = GetPosition(cfg_harbor.showX, cfg_harbor.showY)
		DrawHarbor(id, x, y)
	end
	
	for k,id in pairs(mSendList) do
		local cfg_send = CFG_send[id]
		local x,y = GetPosition(cfg_send.x, cfg_send.y)
		DrawSend(id, x, y)
	end
	
	for k,cfg_fishArea in pairs(CFG_fishArea) do
		local x,y = GetPosition((cfg_fishArea.starX+cfg_fishArea.endX)/2, (cfg_fishArea.starY+cfg_fishArea.endY)/2)
		-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/boss")
		-- drawTextureFunc(x-32,y-32,64,64,image)
		labelFunc(x,y,0,0,cfg_fishArea.name,guiStyleLabel3,Color.Black)
	end
	
	
	for k,cfg_boss in pairs(CFG_boss) do
		local cfg_EnemyPosition = CFG_EnemyPosition[cfg_boss.eid]
		-- print(cfg_EnemyPosition, cfg_boss.eid)
		-- local cfg_Enemy = CFG_Enemy[cfg_boss.eid]
		if cfg_EnemyPosition.MapID == mMapId then
			local x,y = GetPosition(cfg_EnemyPosition.X, cfg_EnemyPosition.Y)
			local image = mAssetManager.GetAsset("Texture/Gui/Bg/boss")
			drawTextureFunc(x-32,y-32,64,64,image)
			labelFunc(x,y-18,0,0,cfg_boss.name,guiStyleLabel1,Color.Black)
		end
	end
	
	if hero.map == mMapId then
		local x,y = GetPosition(hero.x, hero.y)
		
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/ship")
		drawTextureFunc(x-22,y-36,44,36,image)
	end
	
	GUI.EndGroup()
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg15_1")
	GUI.DrawTexture(0,0,1136,640,image)
	
	
	if mMapId == 0 then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg25_2")
		GUI.DrawTexture(122,92,62,46,image)
		
		if GUI.Button(40,46,385,52, nil, GUIStyleButton.MapBtn_2) then
		end
		if GUI.Button(696,46,340,52, nil, GUIStyleButton.MapBtn_3) then
			mMapId = 2
			local map = CFG_map[mMapId]
			mCenterX = map.width / 2
			mCenterY = map.height / 2
		end
	elseif mMapId == 2 then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg25_2")
		GUI.DrawTexture(885,92,62,46,image)
		
		if GUI.Button(40,46,385,52, nil, GUIStyleButton.MapBtn_1) then
			mMapId = 0
			local map = CFG_map[mMapId]
			mCenterX = map.width / 2
			mCenterY = map.height / 2
		end
		if GUI.Button(696,46,340,52, nil, GUIStyleButton.MapBtn_4) then
			
		end
	end
	
	if mShowMoveSelect then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg24_1",AssetType.Forever)
		drawTextureFunc(mMoveSelectX-40,mMoveSelectY-67,227,67,image)
		if mToHarborId then
			local cfg_harbor = CFG_harbor[mToHarborId]
			labelFunc(mMoveSelectX-40,mMoveSelectY-62,227,67,cfg_harbor.name,guiStyleLabel2)
		else
			labelFunc(mMoveSelectX-40,mMoveSelectY-62,227,67, mToX .. " " .. mToY,guiStyleLabel2)
		end
		
		
		buttonFunc(mMoveSelectX,mMoveSelectY+6,74,83,nil, GUIStyleButton.MoveBtn)
		buttonFunc(mMoveSelectX+74,mMoveSelectY,70,92,nil, GUIStyleButton.FlyBtn)
	end
	
	if GUI.Button(55,112,1024,512,nil,GUIStyleButton.Transparent) then
		local csVector3 = Input.GetMousePosition()
		local mouseX = csVector3.x
		local mouseY = Screen.height - csVector3.y

		if GUI.modulus > 1 then
			mMoveSelectX = GUI.UnHorizontalRestX(mouseX) - 74
			mMoveSelectY = GUI.UnVerticalRestY(mouseY) - 85
		else
			mMoveSelectX = mouseX - 74
			mMoveSelectY = mouseY - 85
		end
		mToHarborId = nil
		mToMapId = mMapId
		
		-- print(Screen.height)
		-- print(mouseY)
		-- print(GUI.offsetY)
		-- print((256*math.max(1,GUI.modulus) + 18*GUI.modulus))
		-- print(mCenterY)
		-- print((Screen.height-mouseY) - GUI.offsetY - (256*math.max(1,GUI.modulus) + 18*GUI.modulus))
		-- print(((Screen.height-mouseY) - GUI.offsetY - (256*math.max(1,GUI.modulus) + 18*GUI.modulus)) / cfg_map.scale)
		
		
		if GUI.modulus <= 1 then
			mToX = (mouseX - (512 + 55)*GUI.modulus - GUI.offsetX )/ cfg_map.scaleX + mCenterX
			mToX = (mToX + cfg_map.width)%cfg_map.width
		else
			mToX = (mouseX - (512 + 55)*GUI.modulus - GUI.offsetX ) / GUI.modulus / cfg_map.scaleX + mCenterX
			mToX = (mToX + cfg_map.width)%cfg_map.width
		end
		
		if GUI.modulus <= 1 then
			mToY = ((Screen.height-mouseY) - (256 + 18)*GUI.modulus - GUI.offsetY) / cfg_map.scaleY + mCenterY
		else
			mToY = ((Screen.height-mouseY) - (256 + 18)*GUI.modulus - GUI.offsetY) / GUI.modulus / cfg_map.scaleY + mCenterY
		end
		
		mToX = math.floor(mToX)
		mToY = math.floor(mToY)
		
		-- print(mToX, mToY)
		-- print(mToX, mToY, mToMapId)
		if mPathManager.CouldWalk(mToX, mToY, mToMapId) then
			mShowMoveSelect = true
		else
			mShowMoveSelect = false
		end
		
		-- if GUI.modulus <= 1 then
			-- mMoveSelectX = mMoveSelectX + GUI.offsetX
			-- mMoveSelectY = mMoveSelectY + GUI.offsetY
		-- end
		-- print(mPathManager.CouldWalk(mToX, mToY, mToMapId))
	end
	
	
	if GUI.Button(1045,33,74,70,nil, GUIStyleButton.CloseBtn_3) then
		mPanelManager.Show(mMainPanel)
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
	end
end

function RevisePosition()
	local cfg_map = CFG_map[mMapId]
	if cfg_map.loop == 1 then
		mCenterX = mCenterX % cfg_map.width
	else
		if mCenterX < 512 *  math.min(GUI.modulus, 1) / cfg_map.scaleX then
			mCenterX = 512 *  math.min(GUI.modulus, 1) / cfg_map.scaleX
		elseif mCenterX > cfg_map.width - 512 * math.min(GUI.modulus, 1) / cfg_map.scaleX then
			mCenterX = cfg_map.width - 512 * math.min(GUI.modulus, 1) / cfg_map.scaleX
		end
	end
	if mCenterY < (256 * math.min(GUI.modulus, 1) + cfg_map.offset) / cfg_map.scaleY then
		mCenterY = (256 * math.min(GUI.modulus, 1) + cfg_map.offset) / cfg_map.scaleY
	elseif mCenterY > cfg_map.height - 256 *  math.min(GUI.modulus, 1) / cfg_map.scaleY then
		mCenterY = cfg_map.height - 256 *  math.min(GUI.modulus, 1) / cfg_map.scaleY
	end
end

function InitHarborList()
	mHarborList = {}
	local cfg_map = CFG_map[mMapId]
	for k,harbor in pairs(CFG_harbor) do
		if harbor.mapId == mMapId and math.abs((mCenterX - harbor.showX + cfg_map.width + 512/cfg_map.scaleX) % cfg_map.width - 512/cfg_map.scaleX) < 512/cfg_map.scaleX
			and math.abs(mCenterY - harbor.showY) < 256/cfg_map.scaleY then	
			table.insert(mHarborList, harbor.id)
		end
	end
end

function DrawHarbor(id, x, y)
	local cfg_harbor = CFG_harbor[id]
	local hero = mHeroManager.GetHero()
	local buttonFunc = nil
	local drawTextureFunc = nil
	if GUI.modulus <= 1 then
		buttonFunc = GUI.UnScaleButton
		drawTextureFunc = GUI.UnScaleDrawTexture
	else
		buttonFunc = GUI.Button
		drawTextureFunc = GUI.DrawTexture
	end
	
	if buttonFunc(x-25,y-25,50,50, nil, GUIStyleButton.Transparent) then
		if hero.harborId == id then
			mSystemTip.ShowTip("已在该港口中")
			return
		end
		SelectHarbor(id)
	end
	
	if mHarborManager.HarborIsMy(id) then
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/harbor2")
		drawTextureFunc(x-32,y-32,64,64,image)
	else
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/harbor1")
		drawTextureFunc(x-32,y-32,64,64,image)
	end
	-- GUI.Label(x,y+18,0,0,cfg_harbor.name,GUIStyleLabel.Center_25_White_Art, Color.Black)
end

function SelectHarbor(harborId)
	local cfg_harbor = CFG_harbor[harborId]
	local x,y = GetPosition(cfg_harbor.showX, cfg_harbor.showY)
	
	mShowMoveSelect = true
	mMoveSelectX = x-40-20+55*math.min(GUI.modulus,1)
	mMoveSelectY = y-75+112*math.min(GUI.modulus,1)
	mToHarborId = harborId
	mToMapId = cfg_harbor.mapId
	mToX = cfg_harbor.x
	mToY = cfg_harbor.y
	AppearEvent(nil,EventType.OnRefreshGuide)
	
	if GUI.modulus <= 1 then
		mMoveSelectX = mMoveSelectX + GUI._offsetX
		mMoveSelectY = mMoveSelectY + GUI._offsetY
	end
end

function InitSendList()
	mSendList = {}
	for k,send in pairs(CFG_send) do
		if send.map == mMapId and mSendManager.EffectMap(send) then	
			table.insert(mSendList, send.id)
		end
	end
end

function DrawSend(id, x, y)
	local buttonFunc = nil
	if GUI.modulus <= 1 then
		buttonFunc = GUI.UnScaleButton
	else
		buttonFunc = GUI.Button
	end
	
	local cfg_send = CFG_send[id]
	if buttonFunc(x-30,y-21,60,42, nil, GUIStyleButton.SendButton) then
		mCenterX = cfg_send.toX
		mCenterY = cfg_send.toY
		mMapId = cfg_send.toMap
		oldDrawIndex = -1
		mShowMoveSelect = false
	end
end

function GetHarborPosition(harborId)
	local cfg_harbor = CFG_harbor[harborId]
	return GetPosition(cfg_harbor.showX, cfg_harbor.showY)
end

function GetPosition(x, y)
	local cfg_map = CFG_map[mMapId]
	local x = ((x - mCenterX+cfg_map.width)*cfg_map.scaleX + 512 *  math.min(GUI.modulus, 1))%(cfg_map.width*cfg_map.scaleX)
	local y = (mCenterY - y)*cfg_map.scaleY + 256 *  math.min(GUI.modulus, 1)
	return x,y
end

function ResetCenter()
	local hero = mHeroManager.GetHero()
	mCenterX = hero.x
	mCenterY = 15237 - hero.y
end