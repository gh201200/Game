module("LuaScript.View.Panel.Main.Joystick", package.seeall)
local Vector3 = nil
local Input = nil

local mPanelManager = nil
local mAssetManager = nil
local mHarborInfoPanel = nil
local joystickSwitch = true
local bgImage = nil
local pointImage = nil

local moveFlag = false

local xpos, ypos = nil, nil

local pos, targetPos, mouseX, mouseY = nil, nil, nil, nil

local dis, dir = nil, nil

local centerPoint = nil
local bgSize = {}
local pointSize = {}

local minDis, maxDis = 0, 0

local dispatchInterval = 0.5
local oldTime = nil

local nearHarbor = nil
local enterFlag = false
enterDis = 120

local nearSend = nil
local enterSendFlag = false
enterSendDis = 100

notAutoClose = true

--local golist = {}	--test

local pointButtonStyle = {
	normal = {
		background = "Texture/Gui/Bg/joystick_point"
	}
}

function Display()
	--mSceneManager.SetMouseEvent(false)
end

function Hide()
	--mSceneManager.SetMouseEvent(false)
end

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mHarborInfoPanel = require "LuaScript.View.Panel.Harbor.HarborIntoPanel"
	
	Vector3 = UnityEngine.Vector3
	Input = UnityEngine.Input
	GameObject = UnityEngine.GameObject
	
	bgImage = mAssetManager.GetAsset("Texture/Gui/Bg/joystick_bg")
	pointImage = mAssetManager.GetAsset("Texture/Gui/Bg/joystick_point")
	
	
	-- 背景尺寸位置
	bgSize.x, bgSize.y, bgSize.width, bgSize.height = GUI.RestSize(40, 430, 195, 195)
	-- 原点尺寸位置
	pointSize.x, pointSize.y, pointSize.width, pointSize.height = GUI.RestSize(73.5, 465.5, 128, 128)
	-- 复位用的
	xpos, ypos = pointSize.x, pointSize.y
	-- 原点
	local x,y = GUI.RestSize(137.5, 529.5, 0 ,0)
	centerPoint = Vector3(x,y)
	-- 最小最大移动距离
	_, _, minDis, maxDis = GUI.RestSize(0,0,128 / 2, 195 / 2)
	
	mEventManager.AddEventListen(nil, EventType.ChangeDir, MoveShip)
	-- local s = mAssetManager.GetAsset("S", AssetType.Forever)
	-- go1 = GameObject.Instantiate(s)
	-- go1.name = "go1"
	-- go1.transform.position = Vector3.zero
	-- go1.transform.localScale = Vector3(30, 30, 30)
	-- table.insert(golist, go1)
	
	-- go2 = GameObject.Instantiate(go1)
	-- go2.name = "go2"
	-- go2.transform.localScale = Vector3(30, 30, 30)
	-- table.insert(golist, go2)
	
	-- go3 = GameObject.Instantiate(go1)
	-- go3.name = "go3"
	-- go3.transform.localScale = Vector3(30, 30, 30)
	-- table.insert(golist, go3)
	
	-- go4 = GameObject.Instantiate(go1)
	-- go4.name = "go4"
	-- go4.transform.localScale = Vector3(30, 30, 30)
	-- table.insert(golist, go4)
	
	-- go5 = GameObject.Instantiate(go1)
	-- go5.name = "go5"
	-- go5.transform.localScale = Vector3(30, 30, 30)
	-- table.insert(golist, go5)
	
	-- go6 = GameObject.Instantiate(go1)
	-- go6.name = "go6"
	-- go6.transform.localScale = Vector3(30, 30, 30)
	-- table.insert(golist, go6)
	
	-- go7 = GameObject.Instantiate(go1)
	-- go7.name = "go7"
	-- go7.transform.localScale = Vector3(30, 30, 30)
	-- table.insert(golist, go7)
	
	-- go8 = GameObject.Instantiate(go1)
	-- go8.name = "go8"
	-- go8.transform.localScale = Vector3(30, 30, 30)
	-- table.insert(golist, go8)
	
	-- print("joystick init")
end

-- function Display()
	-- OnUpdateEvent.Add("LuaScript.View.Joystick.Update", Update)
	-- mEventManager.AddEventListen(nil, EventType.ChangeDir, MoveShip)
	-- print("joystick display")
-- end

-- function Hide()
	-- OnUpdateEvent.Remove("LuaScript.View.Joystick.Update")
	-- mEventManager.RemoveEventListen(nil, EventType.ChangeDir, MoveShip)
	-- print("joystick hide")
-- end

-- function Show()
	-- mPanelManager.Show(OnGUI)
	--print("joystick show")
-- end

function OnGUI()
	if VersionCode > 1 then
		local image = mAssetManager.GetAsset("Texture/Gui/Button/joystick_switch_1")
		if joystickSwitch then 
			image = mAssetManager.GetAsset("Texture/Gui/Button/joystick_switch_1") 
		elseif not joystickSwitch then 
			image = mAssetManager.GetAsset("Texture/Gui/Button/joystick_switch_2")
		end
		GUI.DrawTexture(-10,586,64,64,image)
		if GUI.Button(0,590,50,50,nil,GUIStyleButton.Transparent) then
		   joystickSwitch = not joystickSwitch
		end
	end
	
	if not joystickSwitch then
	   return
	end
	
	GUI.UnScaleDrawTexture(bgSize.x, bgSize.y, bgSize.width, bgSize.height, bgImage)
	GUI.UnScaleButton(pointSize.x, pointSize.y, pointSize.width, pointSize.height, "", pointButtonStyle)
end

function Update()
	if not joystickSwitch then
	   return
	end
	
	local hero = mHeroManager.GetHero()
	if hero.SceneType == SceneType.Harbor then
		return
	end
	if not mPanelManager then return end
	if mPanelManager.mPanelList[ConstValue.AlertPanel][1] then
		moveFlag = false
		pointSize.x = xpos
		pointSize.y = ypos
		return
	end
	if Input.GetMouseButtonDown(0) then
		pos = Input.mousePosition
		mouseX = pos.x
		mouseY = Screen.height - pos.y
		dis = Vector3.Distance(centerPoint, Vector3.New(mouseX, mouseY, 0))
		if dis <= minDis then
			moveFlag = true
			mMap.DisableMove()
		elseif dis <= maxDis then
			moveFlag = false
			mMap.DisableMove()
		else
			moveFlag = false
		end
	elseif Input.GetMouseButtonUp(0) then
		if moveFlag then
			mMap.DisableMove()
		end
		moveFlag = false
		pointSize.x = xpos
		pointSize.y = ypos
	end
	if not moveFlag then return end
	
	pos = Input.mousePosition
	mouseX = pos.x
	mouseY = Screen.height - pos.y
	dis = Vector3.Distance(centerPoint, Vector3(mouseX, mouseY,0))
	dir = Vector3(mouseX - centerPoint.x, mouseY - centerPoint.y,0):Normalize()
	
	pointSize.x = mouseX - minDis
	pointSize.y = mouseY - minDis
	
	if dis > maxDis then
		targetPos = Vector3(centerPoint.x + dir.x * maxDis, centerPoint.y + dir.y * maxDis, 0)
		pointSize.x = targetPos.x - minDis
		pointSize.y = targetPos.y - minDis
	end
	dir.y = dir.y * -1
	if (oldTime == nil or os.clock() - oldTime > dispatchInterval) and dis > minDis / 2 then
		AppearEvent(nil, EventType.ChangeDir, dir)
		oldTime = os.clock()
	end
end

function MoveShip(_, _, dir)
	local hero = mHeroManager.GetHero()
	if not hero then return end
	local pos = {}
	pos.x = hero.x
	pos.y = hero.y
	local speed = 160
	local _targetPos = nil
	_targetPos = {x = pos.x + dir.x * 60, y = pos.y + dir.y * 60}
	local targetPos = {x = pos.x + dir.x * speed, y = pos.y + dir.y * speed}
	-- while not mPathManager.CouldWalk(targetPos.x, targetPos.y, hero.map) do
		-- speed = speed - 40
		-- targetPos = {x = pos.x + dir.x * speed, y = pos.y + dir.y * speed}
		-- if speed < 40 then break end
	-- end
	if mPathManager.CouldWalk(targetPos.x, targetPos.y, hero.map) then
		mHeroManager.Goto(hero.map, targetPos.x, targetPos.y)
	else
		local dis = 80
		local points = {}
		if not mPathManager.CouldWalk(targetPos.x, targetPos.y, hero.map) then
			-- [x*cosA-y*sinA  x*sinA+y*cosA]  
			local angle1 = 20 * math.pi / 180
			local angle2 = -angle1
			local angle3 = 60 * math.pi / 180
			local angle4 = -angle3
			local angle5 = 100 * math.pi / 180
			local angle6 = -angle5
			-- local angle7 = 105 * math.pi / 180
			-- local angle8 = -angle7
			local dir1 = Vector3(dir.x * math.cos(angle1) - dir.y * math.sin(angle1), dir.x * math.sin(angle1) + dir.y * math.cos(angle1), 0)
			local dir2 = Vector3(dir.x * math.cos(angle2) - dir.y * math.sin(angle2), dir.x * math.sin(angle2) + dir.y * math.cos(angle2), 0)
			local dir3 = Vector3(dir.x * math.cos(angle3) - dir.y * math.sin(angle3), dir.x * math.sin(angle3) + dir.y * math.cos(angle3), 0)
			local dir4 = Vector3(dir.x * math.cos(angle4) - dir.y * math.sin(angle4), dir.x * math.sin(angle4) + dir.y * math.cos(angle4), 0)
			local dir5 = Vector3(dir.x * math.cos(angle5) - dir.y * math.sin(angle5), dir.x * math.sin(angle5) + dir.y * math.cos(angle5), 0)
			local dir6 = Vector3(dir.x * math.cos(angle6) - dir.y * math.sin(angle6), dir.x * math.sin(angle6) + dir.y * math.cos(angle6), 0)
			-- local dir7 = Vector3(dir.x * math.cos(angle7) - dir.y * math.sin(angle7), dir.x * math.sin(angle7) + dir.y * math.cos(angle7))
			-- local dir8 = Vector3(dir.x * math.cos(angle8) - dir.y * math.sin(angle8), dir.x * math.sin(angle8) + dir.y * math.cos(angle8))
			points[1] = {x = _targetPos.x + dir1.x * dis, y = _targetPos.y + dir1.y * dis}
			points[2] = {x = _targetPos.x + dir2.x * dis, y = _targetPos.y + dir2.y * dis}
			points[3] = {x = _targetPos.x + dir3.x * dis, y = _targetPos.y + dir3.y * dis}
			points[4] = {x = _targetPos.x + dir4.x * dis, y = _targetPos.y + dir4.y * dis}
			points[5] = {x = _targetPos.x + dir5.x * dis, y = _targetPos.y + dir5.y * dis}
			points[6] = {x = _targetPos.x + dir6.x * dis, y = _targetPos.y + dir6.y * dis}
			-- points[7] = {x = _targetPos.x + dir7.x * dis, y = _targetPos.y + dir7.y * dis}
			-- points[8] = {x = _targetPos.x + dir8.x * dis, y = _targetPos.y + dir8.y * dis}
			-- for k, v in pairs(points) do
				-- local go = golist[k]
				-- go:SetActive(true)
				-- --print(go.name)
				-- CsSetPosition(GetTransform(go),v.x, 30, v.y)
			-- end
			local opens = { }
			for _, v in pairs(points) do
				if mPathManager.CouldWalk(v.x, v.y, hero.map) then
					table.insert(opens, v)
				end
			end
			local index = -1
			local angle = -2
			for k, v in pairs(opens) do
				local dir_ =  Vector3(v.x - pos.x, v.y - pos.y, 0):Normalize()
				local res = Vector3.Dot(dir, dir_)
				if res > angle then
					index = k
					angle = res
				end
			end
			if index ~= -1 then
				targetPos = opens[index]
			end
		end
		if mPathManager.CouldWalk(targetPos.x, targetPos.y, hero.map) then
			mHeroManager.Goto(hero.map, targetPos.x, targetPos.y)
		end
	end
	
	local id = mHarborManager.GetNearHarbor()
	if id then
		nearHarbor = CFG_harbor[id]
	end
	
	if nearHarbor then
		local dis = math.sqrt((nearHarbor.showX - targetPos.x) * (nearHarbor.showX - targetPos.x) + (nearHarbor.showY - targetPos.y) * (nearHarbor.showY - targetPos.y))
		if dis <= enterDis and not enterFlag then enterFlag = true return end
		if dis <= enterDis and enterFlag then
		-- if curDis and preDis and preDis - curDis > 30 and curDis <= 130 and (not preHarborOpenTime or os.time() - preHarborOpenTime >= 0) then
			mHarborInfoPanel.SetData(nearHarbor.id)
			mPanelManager.Show(mHarborInfoPanel)
			mHeroManager.StopMove()
			enterFlag = false
			--print(nearHarbor)
		end
	end
	
	nearSend = mSendManager.GetNearSend()
	if nearSend then
		local dis = math.sqrt((nearSend.x - targetPos.x) * (nearSend.x - targetPos.x) + (nearSend.y - targetPos.y) * (nearSend.y - targetPos.y))
		if dis <= enterSendDis and not enterSendFlag then enterSendFlag = true return end
		if dis <= enterSendDis and enterSendFlag then
			-- mHeroManager.StopMove()
			--moveFlag = false
			mHeroManager.RequestSend(nearSend.id)
			enterSendFlag = false
			--print("enter send ", dumpTab(nearSend))
		end
	end
	--mTargetManager.Show(targetPos.x, targetPos.y)
	--print("near send:", dumpTab(mSendManager.GetNearSend()))
end