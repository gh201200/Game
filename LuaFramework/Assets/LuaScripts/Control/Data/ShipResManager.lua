local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Goods,Packat_Ship,Language = 
print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Goods,Packat_Ship,Language
local PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent = 
PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent
local CFG_ship,CFG_harbor,ConstValue,GameObject,AssetType = CFG_ship,CFG_harbor,ConstValue,GameObject,AssetType
local Destroy,CsSetPosition,GetTransform,CsRotate,CsSetActive,CsSetScale,FindChild,ErrorLog,string,CsSetParent = 
Destroy,CsSetPosition,GetTransform,CsRotate,CsSetActive,CsSetScale,FindChild,ErrorLog,string,CsSetParent
local mAssetManager = nil
local mEventManager = nil
local mNetManager = nil
local mSystemTip = nil
local mSkillManager = nil
module("LuaScript.Control.Data.ShipResManager")

-- mShipRess = {}
local mCsShipList = nil
function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mSkillManager = require "LuaScript.Control.Scene.SkillManager"
	
	-- mEventManager.AddEventListen(nil, EventType.ClearAsset, ClearAsset)
	mCsShipList = GameObject.Find("ShipList")
end

-- function ClearAsset(target, eventType, level)
	-- if level > 1 then
		-- for resId,ships in pairs(mShipRess) do
			-- for k,ship in  pairs(ships) do
				-- Destroy(ship)
			-- end
		-- end
		-- mShipRess = {}
	-- end
-- end

function GetShip(id, scale)
	-- print("GetShip", scale)
	local cfg_ship = CFG_ship[id]
	if not cfg_ship then
		ErrorLog("GetShip Error "..tostring(id))
	end
	local resId = cfg_ship.resId
	local scale = scale or cfg_ship.scale
	-- print("GetShip",scale)
	-- if mShipRess[resId] and mShipRess[resId][1] then
		-- local csShip = mShipRess[resId][1]
		-- table.remove(mShipRess[resId], 1)
		-- CsSetActive(csShip,true)
		-- CsSetScale(GetTransform(csShip), scale, scale, scale)
		-- return csShip
	-- end
	-- print("Instantiate")
	local path = string.format(ConstValue.ResShipPath, resId)
	local csAsset = mAssetManager.GetAsset(path, AssetType.Ship)
	local csShip = Instantiate(csAsset)
	CsSetParent(GetTransform(csShip), GetTransform(mCsShipList))
	CsSetScale(GetTransform(csShip), scale, scale, scale)
	
	if cfg_ship.effect ~= 0 then
		mSkillManager.AddEffect(cfg_ship.effect,nil,csShip)
	end
	
	return csShip
end

function DestroyShip(ship, csShip)
	-- print("DestroyShip!!!!!!!")
	Destroy(csShip)
end