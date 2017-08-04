local GameObject,MeshFilter,Screen,MapTexture,File,Vector3,Vector2,cs_Base,Texture2D,print,os,Instantiate = 
	GameObject,MeshFilter,Screen,MapTexture,File,Vector3,Vector2,cs_Base,Texture2D,print,os,Instantiate
local math,Renderer,EventType,Camera,Input,require,Destroy,debug,CsSetPosition,GetTransform,CsSetActive = 
math,Renderer,EventType,Camera,Input,require,Destroy,debug,CsSetPosition,GetTransform,CsSetActive
local CsSetWaveSpeed,CsFindType,GetComponent = CsSetWaveSpeed,CsFindType,GetComponent
local mAssetManager = require "LuaScript.Control.AssetManager"
local mEventManager = require "LuaScript.Control.EventManager"
local mHeroManager = nil
local mCameraManager = nil
local mCharManager = nil
module("LuaScript.Control.Scene.TargetManager")
local mCsTarget = nil

function Init()
	mCsTarget = GameObject.Find("target")
	CsSetActive(mCsTarget,false)
end

function Show(x, y)
	CsSetActive(mCsTarget,true)
	CsSetPosition(GetTransform(mCsTarget),x, 30, y)
end

function Hide()
	CsSetActive(mCsTarget,false)
end	