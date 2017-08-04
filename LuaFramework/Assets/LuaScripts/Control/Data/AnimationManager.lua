local _G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,SplitString,CFG_task,require,table,PackatHead,Packat_Quest = 
_G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,SplitString,CFG_task,require,table,PackatHead,Packat_Quest
local ByteArray,EventType,AppearEvent,CFG_taskAward,ReplaceString,os,math,SceneType,CFG_harbor = 
ByteArray,EventType,AppearEvent,CFG_taskAward,ReplaceString,os,math,SceneType,CFG_harbor

local mHeroManager = nil
module("LuaScript.Control.Data.AnimationManager")

function Init()
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	
end

function Start(id, ...)
	if id == 1 then -- 港口战动画
		local hero = mHeroManager.GetHero()
		if hero.map ~= 2 or hero.SceneType ~= SceneType.Normal then
			({...})[1]()
			return
		end
		local animation = require "LuaScript.View.Animation.AttackHarbor"
		animation.Start(...)
		mHeroManager.StopMove()
	elseif id == 2 then -- 船员加入物品
		local animation = require "LuaScript.View.Animation.SailorToItem"
		animation.Start(...)
	elseif id == 3 then -- 船员加入队伍
		local animation = require "LuaScript.View.Animation.SailorToTeam"
		animation.Start(...)
	elseif id == 4 then -- 港口战动画2
		local hero = mHeroManager.GetHero()
		if hero.map ~= 2 or hero.SceneType ~= SceneType.Normal then
			({...})[1]()
			return
		end
		local animation = require "LuaScript.View.Animation.AttackHarbor2"
		animation.Start(...)
		mHeroManager.StopMove()
	end
end