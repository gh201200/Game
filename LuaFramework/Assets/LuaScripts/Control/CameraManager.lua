local Camera,Screen,math,print,RaycastHit,Physics,Vector3,Application,GameObject,require,os,SceneType,CsSetPosition,CsScreenPointToRay = 
Camera,Screen,math,print,RaycastHit,Physics,Vector3,Application,GameObject,require,os,SceneType,CsSetPosition,CsScreenPointToRay
local Animation,GetComponent,CsAnimationPlay,AnimationType,GUI,UnityEngine
 = Animation,GetComponent,CsAnimationPlay,AnimationType,GUI,UnityEngine
local mHeroManager = nil
local mCharManager = nil

module("LuaScript.Control.CameraManager")

local mViewX = 0
local mViewY = 0

local mOfferX = 0
local mOfferY = 0
local csCameraTransform = nil

function Init()	
	if IsInit then
		return
	end
	
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	
	Camera.mainCamera.orthographic = true
	
	local modulus = 1
	if GUI.offsetY ~= 0 then
		modulus = GUI.offsetY * 2 / (Screen.height - GUI.offsetY * 2) + 1
	end
	
	local arr = UnityEngine.Camera.allCameras
	for i=0,arr.Length-1 do
		arr[i].orthographicSize = 270 * modulus
	end
	-- Camera.mainCamera.orthographicSize = 270 * modulus
	
	csCameraTransform = GameObject.Find("Camera").transform
	CsSetPosition(csCameraTransform,0,800,-800)
	
	IsInit = true
end

function Shock()
	local animation = GetComponent(Camera.mainCamera.gameObject,Animation.GetType())
	CsAnimationPlay(animation, AnimationType.Shock)
end

function ScreenPointToWorld(x, y)
	if x < 0 or x > Screen.width or 
		y < 0 or y > Screen.height then
		return
	end
	csRay = CsScreenPointToRay(Camera.mainCamera,x,y)
	-- cshit = RaycastHit.example
	return Physics.Raycast(csRay)
end

function SetView(x, y)
	mViewX, mViewY = GetViewByPos(x,y)
	Update(true)
end

function GetView()
	return mViewX, mViewY
end


function GetViewByPos(x,y)
	local hero = mHeroManager.GetHero()
	if hero.SceneType == SceneType.Battle then
		if x < 500 then
			x = 500
		elseif x > 1200 - 157 then
			x = 1200 - 157
		end
		
		if y < 450 then
			y = 450
		elseif y > 700 then
			y = 700
		end
	end
	return x,y
end

function SetOffer(x, y)
	-- print(x, y)
	mOfferX = x
	mOfferY = y
end

function GetOffer()
	-- print(x, y)
	return mOfferX,mOfferY
end

function Update(enforce)
	local hero = mHeroManager.GetHero()
	if not hero.ships or not hero.ships[1] then
		return
	end
	
	if enforce or mOfferX ~= 0 or mOfferY ~= 0 then
		length = math.sqrt(mOfferX*mOfferX + mOfferY*mOfferY)
		if length < os.deltaTime * 200 then
			mOfferX = 0
			mOfferY = 0
		elseif length > 0 then
			mOfferX = mOfferX - mOfferX * os.deltaTime * 200 / length
			mOfferY = mOfferY - mOfferY * os.deltaTime * 200 / length
		end
		
		local mScreneX = mViewX - mOfferX
		local mScreneY = mViewY - mOfferY - 800
		CsSetPosition(csCameraTransform,mScreneX,800,mScreneY)
	end
end