

module("LuaScript.View.Panel.Main.ExpLine",package.seeall)


function Init()
	
end


function OnGUI()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/expLine1")
	GUI.DrawTexture(255,614,840,26,image)
	
	
	local hero = mHeroManager.GetHero()
	local cfg_Exp = CFG_Exp[hero.level]
	local nowExp = math.min(hero.exp, cfg_Exp.exp)
	local nextExp = cfg_Exp.exp
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/expLine2")
	GUI.DrawTexture(280,621,nowExp/cfg_Exp.exp*790,12,image)
	GUI.Label(280,620,790,12, math.floor(nowExp/nextExp*100).."%("..nowExp.."/"..nextExp..")", GUIStyleLabel.Center_12_White, Color.Black)
	-- GUI.Label(245,620,100,12, hero.level.."级", GUIStyleLabel.Center_12_White, Color.Black)
end