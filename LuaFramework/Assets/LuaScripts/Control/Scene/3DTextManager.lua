local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray = print,Instantiate,EventType,Space,math,os,Vector3,ByteArray
local PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue = PackatHead,Packat_Player,BoxCollider,SceneType,table,ConstValue
local GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,CsSetPosition,AssetType,CsSet3DText = 
GameObject,GameObjectTag,pairs,AudioData,require,Camera,Screen,CsSetPosition,AssetType,CsSet3DText
local Rect,Color,GetTransform,CsSetActive,GetRenderer,CsSetMaterial,CsSetParent,CsFindType,GetComponentInChildren,UILabel = 
Rect,Color,GetTransform,CsSetActive,GetRenderer,CsSetMaterial,CsSetParent,CsFindType,GetComponentInChildren,UILabel
local CsSet3DTextDepth,UISprite = CsSet3DTextDepth,UISprite
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
module("LuaScript.Control.Scene.3DTextManager")

local m3DTextList = nil
-- local m3DTextType = CsFindType("_3DText")
CsFindType("UILabel")
local m3DTextType = UILabel.GetClassType()

local mHeroTitle = nil
local mLevelTitle = nil
local mNameTitle = nil
local mHearderIcon = nil


local mZIndexCount = nil
local m3DTextZList = nil
-- local mDestroyList = nil

function Init()
	m3DTextList = {}
	mZIndexCount = {[0]=0}
	m3DTextZList = {}
	local cs3DTextList = GameObject.FindGameObjectsWithTag(GameObjectTag.Text)
	for i=0,cs3DTextList.Length-1,1 do
		local cs3DText = cs3DTextList[i]
		CsSetActive(cs3DText,false)
		table.insert(m3DTextList, cs3DText)
		m3DTextZList[cs3DText] = 0
		
		mEventManager.AddEventListen(cs3DText, EventType.OnAnimationOver, Destroy)
	end
	
	mHeroTitle = GameObject.Find("HeroTitle")
	mLevelTitle = GameObject.Find("HeroLevelTitle")
	mNameTitle = GameObject.Find("HeroNameTitle")
	mHearderIcon = GameObject.Find("HeroHearderIcon")
	
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mAudioManager = require "LuaScript.Control.System.AudioManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mLoginPanel = require "LuaScript.View.Panel.Login.LoginPanel"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mCameraManager = require "LuaScript.Control.CameraManager"
end

function ClearAll()
	for k,v in pairs(m3DTextList) do
		m3DTextZList[v] = 0
	end
	mZIndexCount = {[0]=0}
end


function GetHeroTitle(str, level,resId)
	-- print(str, level, resId)
	CsSetActive(mHeroTitle,true)
	SetText(mNameTitle, str)
	SetText(mLevelTitle, "Lv."..level)
	
	GetComponentInChildren(mHearderIcon,UISprite.GetClassType()).spriteName=resId
	return mHeroTitle
end

function SetHeroTitle(str, level)
	CsSetActive(mHeroTitle,true)
	SetText(mNameTitle, str)
	SetText(mLevelTitle, "Lv."..level)
	return mHeroTitle
end

function Get3DText(str)
	-- print(1111)
	local cs_3DText = nil
	local length = #m3DTextList
	if length > 0 then
		cs_3DText = m3DTextList[length]
		m3DTextList[length] = nil
		-- print(1)
		CsSetActive(cs_3DText,true)
		-- print(2)
		if str then
			SetText(cs_3DText, str)
		end
	end
	return cs_3DText
end

function SetPosition(cs3DText, x, y, z, offset)
	CsSetPosition(GetTransform(cs3DText), x, y, z)
	if cs3DText == mHeroTitle then
		-- CsSet3DTextDepth(GetComponentInChildren(cs3DText,m3DTextType), 100)
		return
	end
	
	
	z = math.floor(z)
	local oldZ = m3DTextZList[cs3DText]
	mZIndexCount[oldZ] = mZIndexCount[oldZ] - 1
	mZIndexCount[z] = (mZIndexCount[z] or 0) + 1
	local detp = -z*60 + mZIndexCount[z]
	CsSet3DTextDepth(GetComponentInChildren(cs3DText,m3DTextType), detp + (offset or 0))
end

function SetText(cs3DText, str)
	-- print(cs3DText, str)
	CsSet3DText(GetComponentInChildren(cs3DText,m3DTextType), str)
end

function Destroy(cs3DText)
	if cs3DText == mHeroTitle then
		CsSetActive(cs3DText,false)
		return
	end
	if not cs3DText then
		return
	end
	-- mDestroyList = mDestroyList or {}
	table.insert(m3DTextList, cs3DText)
	CsSetActive(cs3DText,false)
	
	local oldZ = m3DTextZList[cs3DText]
	mZIndexCount[oldZ] = mZIndexCount[oldZ] - 1
end
