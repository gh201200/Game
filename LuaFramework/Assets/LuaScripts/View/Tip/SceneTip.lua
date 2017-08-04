local _G,Screen,Language,GUI,ByteArray,print,Texture2D = _G,Screen,Language,GUI,ByteArray,print,Texture2D
local PackatHead,Packat_Account,Packat_Player,require,table,Camera,Vector3,SceneType,CsWorldToScreenPoint = 
PackatHead,Packat_Account,Packat_Player,require,table,Camera,Vector3,SceneType,CsWorldToScreenPoint
local Color,os,pairs,GUIStyleLabel,ConstValue,CsSet3DText,CsAnimationPlay,GetComponentInChildren,string = 
Color,os,pairs,GUIStyleLabel,ConstValue,CsSet3DText,CsAnimationPlay,GetComponentInChildren,string
local GetTransform,CsSetPosition,Animation,AnimationType = 
GetTransform,CsSetPosition,Animation,AnimationType
local mPanelManager = require "LuaScript.Control.PanelManager"
local mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mCharManager = require "LuaScript.Control.Scene.CharManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mCameraManager = require "LuaScript.Control.CameraManager"
local m3DTextManager = require "LuaScript.Control.Scene.3DTextManager"
module("LuaScript.View.Tip.SceneTip")
local mTipList = {}
notShowGuide = true
notAutoClose = true
-- panelType = ConstValue.TipPanel

function ShowTip(x, y, z, str, color, animationName)
	if color then
		-- print(mCommonlyFunc.BeginColor(color),str,mCommonlyFunc.EndColor())
		str = string.format("%s%s%s", mCommonlyFunc.NGUIBeginColor(color),str,mCommonlyFunc.NGUIEndColor())
	end
	-- if size then
		-- str = string.format("%s%s%s", mCommonlyFunc.NGUIBeginSize(size*2),str,mCommonlyFunc.NGUIEndSize())
	-- end
	
	local cs3DText = m3DTextManager.Get3DText(str)
	-- CsSet3DText(GetComponent(cs3DText,CsFindType("Titile")), str)
	if cs3DText then
		m3DTextManager.SetPosition(cs3DText, x, y+120, z, 5000)
		local animation = GetComponentInChildren(cs3DText, Animation.GetType())
		CsAnimationPlay(animation, animationName or AnimationType.Rise)
	end
	-- mTipList[#mTipList+1] = {position=position, str=str, 
		-- lastTime=ConstValue.SceneTipLastTime,changeFunc=changeFunc}
end

function OnGUI()
	-- local hero = mHeroManager.GetHero()
	-- if not hero or not hero.ships then
		-- return
	-- end
	-- if hero.SceneType == SceneType.Harbor then
		-- return
	-- end
	-- local viewX,viewY = mCameraManager.GetView()
	-- for k,tip in pairs(mTipList) do 
		
		-- local x,y = CsWorldToScreenPoint(Camera.mainCamera,tip.position.x,tip.position.y,tip.position.z)
		-- GUI.Label(x,Screen.height-y,0,25,tip.str,
			-- GUIStyleLabel.Center_30_White,Color.Black, nil, true)	
		-- tip.lastTime = tip.lastTime - os.deltaTime
		-- if tip.changeFunc then
			-- tip.changeFunc(tip)
		-- end
	-- end
	
	-- if mTipList[1] and mTipList[1].lastTime < 0 then
		-- table.remove(mTipList, 1)
	-- end
	
	-- mPanelManager.Show(OnGUI)
end
