local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray = print,Instantiate,EventType,Space,math,os,Vector3,ByteArray
local PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue = PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue
local GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,CsSetPosition,AssetType,CsSet3DText,GetComponent = 
GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,CsSetPosition,AssetType,CsSet3DText,GetComponent
local Rect,Color,GetTransform,CsSetActive,GetRenderer,CsSetMaterial,CsSetParent,CsFindType,GetComponentInChildren,UnityEngine = 
Rect,Color,GetTransform,CsSetActive,GetRenderer,CsSetMaterial,CsSetParent,CsFindType,GetComponentInChildren,UnityEngine
local CsSet3DTextDepth = CsSet3DTextDepth
local mCharacter = require "LuaScript.Mode.Object.Character"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mEventManager = require "LuaScript.Control.EventManager"
local mSceneManager = nil
local mMainPanel = nil
local mLoginPanel = nil
local mPanelManager = nil
local mNetManager = nil
local mAudioManager = nil
local mCharManager = nil
local mHeroManager = nil
local mCameraManager = nil
local m3DTextManager = nil
module("LuaScript.Control.Scene.BattleTargetManager")

local mList = {}
local mTargetTextList = {}
-- CsFindType("UnityEngine.Animator")
local mAnimatorType = UnityEngine.Animator.GetClassType()

function Init()
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mAudioManager = require "LuaScript.Control.System.AudioManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mLoginPanel = require "LuaScript.View.Panel.Login.LoginPanel"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mCameraManager = require "LuaScript.Control.CameraManager"
	m3DTextManager = require "LuaScript.Control.Scene.3DTextManager"
end


function ShowTarget(str, x, y, animatorName)
	local csTarget = table.remove(mList, 1)
	if csTarget then
		CsSetActive(csTarget,true)
	else
		local csAsset = mAssetManager.GetAsset(ConstValue.BattleTargetPath, AssetType.Ship)
		csTarget = Instantiate(csAsset)
	end
	mEventManager.AddEventListen(csTarget, EventType.OnAnimationOver, OnAnimationOver)
	
	local _3dTxt = m3DTextManager.Get3DText(str)
	m3DTextManager.SetPosition(_3dTxt, x, 60, y)
	
	CsSetPosition(GetTransform(csTarget), x, 1, y)
	
	local csAnimator =  GetComponentInChildren(csTarget, mAnimatorType)
	csAnimator:Play(animatorName)
	
	mTargetTextList[csTarget] = _3dTxt
end

function OnAnimationOver(csTarget)
	if mTargetTextList[csTarget] then
		m3DTextManager.Destroy(mTargetTextList[csTarget])
	end
	mEventManager.RemoveEventListen(csTarget, EventType.OnAnimationOver, OnAnimationOver)
	Destroy(csTarget)
end

function Destroy(csTarget)
	if not csTarget then
		return
	end
	table.insert(mList, csTarget)
	CsSetActive(csTarget,false)
end
