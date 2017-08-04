local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table,CFG_map = 
PackatHead,Packat_Account,Packat_Player,require,table,CFG_map
local Color,os,ConstValue,pairs,math = Color,os,ConstValue,pairs,math
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCharManager = require "LuaScript.Control.Scene.CharManager"
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mCameraManager = require "LuaScript.Control.CameraManager"
module("LuaScript.View.Panel.Main.BattleMap")

function Init()
	
end

function OnGUI()
	local charList = mCharManager.GetCharList()
	local hero = mHeroManager.GetHero()
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/blackBg")
	GUI.DrawTexture(846,0,290,145,image)
	
	local cfg_map = CFG_map[1]
	local viewX,viewY = mCameraManager.GetView()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg55_1")
	GUI.DrawTexture(756+viewX/cfg_map.width*313,(cfg_map.height-viewY)/cfg_map.height*220-121,183,108,image)
	
	for k,char in pairs(charList) do
		local image = nil
		if hero.team ~= char.team then
			image = mAssetManager.GetAsset("Texture/Gui/Bg/boss")
		else
			image = mAssetManager.GetAsset("Texture/Gui/Bg/harbor2")
		end
		
		for _,ship in pairs(char.ships) do
			if ship.hp > 0 then
				GUI.DrawTexture(832+ship.x/cfg_map.width*313,(cfg_map.height-ship.y)/cfg_map.height*220-83,32,32,image)
			end
		end
	end
end
