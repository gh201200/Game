module("LuaScript.Control.Scene.FishManager", package.seeall)

local GameObject = luanet.import_type("UnityEngine.GameObject")
local Transform = luanet.import_type("UnityEngine.Transform")
local Vector3 = luanet.import_type("UnityEngine.Vector3")
local Vector2 = luanet.import_type("UnityEngine.Vector2")
local FishAnimation = luanet.import_type("FishAnimation")
local Rect = luanet.import_type("UnityEngine.Rect")
local Debug = luanet.import_type("UnityEngine.Debug")
local Color = luanet.import_type("UnityEngine.Color")

local list = { }
local root = nil

local mActive = false
local oldPos = nil
local cur = nil

function Init()
	root = GameObject.Find("FishList").transform
	local count = root.childCount
	for i = 0, count -1 do
		local item = { }
		item.go = root:GetChild(i).gameObject
		item.cs = item.go:GetComponent("FishAnimation")
		item.go:SetActive(false)
		
		function item:Show(position)
			self.go:SetActive(true)
			self.cs:SetSpawnPosition(position)
		end
		
		function item:Hide()
			self.go:SetActive(false)
		end
		
		list[i] = item
	end
	mActive = false
end

function Hide()
	if not mActive then return end
	for _, v in pairs(list) do
		v:Hide()
	end
	mActive = false
	cur = nil
end

function Show(position)
	if mActive and oldPos == position then return end
	print(cur.name)
	cur = nil
	for _, v in pairs(list) do
		v:Show(position)
	end
	mActive = true
	oldPos = position
end

function ClearAll()
	Hide()
	print("hide fish")
end

function UpdatePosition(map, x, y)
	local config = CFG_fishArea
	local offset = 500
	for k, v in pairs(config) do
		--public Rect(float left, float top, float width, float height);
		local rect = Rect(v.starX, v.starY, v.endX - v.starX, v.endY - v.starY)
		ExpandRect(rect, offset)
		if v.mapId == map and rect:Contains(Vector2(x, y)) then
			cur = v
		end
	end
	if cur then
		local rect = Rect(cur.starX, cur.starY, cur.endX - cur.starX, cur.endY - cur.starY)
		ExpandRect(rect, offset)
		if rect:Contains(Vector2(x, y)) then
			local pos = Vector3(cur.starX + (cur.endX - cur.starX) / 2, -20, cur.starY + (cur.endY - cur.starY) / 2)
			Show(pos)
		else
			Hide()
		end
		-- FishAnimation.DrawLine(rect)
	else
		Hide()
	end
end

function ExpandRect(rect, offset)
	rect.xMin = rect.xMin - offset
	rect.xMax = rect.xMax + offset
	rect.yMin = rect.yMin - offset
	rect.yMax = rect.yMax + offset
end