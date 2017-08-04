local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table,CFG_map = 
PackatHead,Packat_Account,Packat_Player,require,table,CFG_map
local Color,os,ConstValue,pairs,math = Color,os,ConstValue,pairs,math
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCharManager = require "LuaScript.Control.Scene.CharManager"
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
module("LuaScript.View.Tip.BattleMapTip")

function OnGUI()
	local charList = mCharManager.GetCharList()
	local hero = mHeroManager.GetHero()
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/blackBg")
	GUI.DrawTexture(846,0,290,159,image)
	local cfg_map = CFG_map[1]
	for k,char in pairs(charList) do
		local image = nil
		if hero.team ~= char.team then
			image = mAssetManager.GetAsset("Texture/Gui/Bg/boss")
		else
			image = mAssetManager.GetAsset("Texture/Gui/Bg/harbor2")
		end
		
		for _,ship in pairs(char.ships) do
			if ship.hp > 0 then
				GUI.DrawTexture(840+ship.x/cfg_map.width*313-8,(cfg_map.height-ship.y)/cfg_map.height*220-75-8,32,32,image)
			end
		end
	end
end
