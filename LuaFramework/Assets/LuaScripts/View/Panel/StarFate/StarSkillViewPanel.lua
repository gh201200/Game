local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_item,string = ConstValue,CFG_EquipSuit,CFG_item,string
local AssetType,CFG_UniqueSailor,CFG_star,CFG_starSkill,SkillType,CFG_starSkillProperty,DrawItemCell,ItemType = 
AssetType,CFG_UniqueSailor,CFG_star,CFG_starSkill,SkillType,CFG_starSkillProperty,DrawItemCell,ItemType
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipDestroyPanel = nil
local mEquipSelectPanel = nil

local mSceneManager = nil
local mHeroManager = nil
local mCharManager = nil
local mPanelManager = nil
local mSailorViewPanel = nil
local mStarFataManager = require "LuaScript.Control.Data.SailorManager"
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"

module("LuaScript.View.Panel.StarFate.StarSkillViewPanel")
panelType = ConstValue.AlertPanel
local mStarSkill = nil
local mSelectFunc = nil

function SetData(skill, func)
	mStarSkill = skill
	mSelectFunc = func
end

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipDestroyPanel = require "LuaScript.View.Panel.Equip.EquipDestroyPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mSailorViewPanel = require "LuaScript.View.Panel.Sailor.SailorViewPanel"
	mStarFataManager = require "LuaScript.Control.Data.StarFateManager"
	IsInit = true
end

function OnGUI()
	if not IsInit then
		return
	end
	-- local cfg_starSkill = CFG_starSkill[mStarSkill.id]	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg51_4")
	-- GUI.DrawTexture(258,184,640,320,image,0,0,1,1,20,20,20,20)
	
	-- local image = mAssetManager.GetAsset("Texture/Icon/StarSkill/"..cfg_starSkill.resId, AssetType.Icon)
	-- GUI.DrawTexture(352,294,128,128,image)

	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	-- GUI.DrawTexture(554,246,274,186,image)
	
	-- local image = mAssetManager.GetAsset("Texture/Gui/Bg/namebg")
	-- GUI.DrawTexture(302,234,246,59,image)
	
	-- GUI.Label(352, 238, 139, 30, cfg_starSkill.name, GUIStyleLabel.Center_45_Brown_Art, Color.Black)
	
	-- GUI.Label(558, 246, 255, 30, "好星运好星运好星运好星运好星运好星运", GUIStyleLabel.Left_25_Black_Art_WordWrap)
	
	-- GUI.Label(558, 316, 59.2, 30, Language[129], GUIStyleLabel.Left_20_Black)
	-- local infostr = mCommonlyFunc.GetQualityStr(mStarSkill.quality)
	-- GUI.Label(608, 316, 66.2, 30, infostr, GUIStyleLabel.Center_30_White_Art, Color.Black)
	
	
	local cfg_starSkill = CFG_starSkill[mStarSkill.id]	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg51_4")
	GUI.DrawTexture(275,153,660,353,image,0,0,1,1,20,20,20,20)
	
	local image = mAssetManager.GetAsset("Texture/Icon/StarSkill/"..cfg_starSkill.resId, AssetType.Icon)
	GUI.DrawTexture(610,170,128,128,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/skill_"..mStarSkill.quality, AssetType.Icon)
	GUI.DrawTexture(610,170,128,128,image)
	-- if mStarSkill.level then
		-- GUI.Label(380+183, 215+107, 139, 30, "LV:"..mStarSkill.level, GUIStyleLabel.Right_25_LightBlue, Color.Black)
	-- end
	
	
	if mSelectFunc and GUI.Button(720+128-207, 238+15, 70, 120, "更换技能", GUIStyleButton.Transparent_Art_25_Lime) then
		mSelectFunc()
		mPanelManager.Hide(OnGUI)
	end

	GUI.Label(310, 170, 139, 30, cfg_starSkill.name, GUIStyleLabel.Left_25_LightBlue)
	
	GUI.Label(310, 217, 59.2, 30, Language[129], GUIStyleLabel.Left_20_White)
	local infostr = mCommonlyFunc.GetQualityStr(mStarSkill.quality)
	GUI.Label(365, 208, 66.2, 30, infostr, GUIStyleLabel.Center_30_White_Art)
	
	
	
	-- local value = mCommonlyFunc.GetStarProperty(mStar)
	-- local property = CFG_property[cfg_starSkill.propertyId]
	-- local infostr = property.type .. ": " .. value .. property.sign
	GUI.Label(310,250,270,186, "类型: "..SkillType[cfg_starSkill.active], GUIStyleLabel.Left_20_White)
	
	-- local power = mCommonlyFunc.GetStarPower(mStar)
	-- local key = mStarSkill.id .. "_" .. mStarSkill.quality
	-- local cfg = CFG_starSkillProperty[key]
	if cfg_starSkill.anger == 0 then
		GUI.Label(310,290,270,186, "消耗怒气: 无", GUIStyleLabel.Left_20_White)
	else
		GUI.Label(310,290,270,186, "消耗怒气: "..cfg_starSkill.anger, GUIStyleLabel.Left_20_White)
	end
	
	
	-- local starSkillProperty = CFG_starSkillProperty[mStarSkill.id.."_"..mStarSkill.quality]
	-- local s1 = mCommonlyFunc.BeginColor(Color.RedStr)..starSkillProperty.value1..mCommonlyFunc.EndColor()
	-- local s2 = mCommonlyFunc.BeginColor(Color.OrangeStr)..starSkillProperty.value1..mCommonlyFunc.EndColor()
	GUI.Label(310, 330, 540, 30, "技能效果:"..cfg_starSkill["desc"..mStarSkill.quality], GUIStyleLabel.Left_25_White_Art_WordWrap)
	
	if GUI.Button(0, 0, 1136, 640,nil, GUIStyleButton.Transparent) then
		mPanelManager.Hide(OnGUI)
		-- print("guanbi")
	end
	
	GUI.Label(310, 390, 540, 30, "需求星魂:", GUIStyleLabel.Left_25_Lime_Art)
	
	
	for i=1,7,1 do
		local starId = cfg_starSkill["star"..i]
		if starId == 0 then
			break
		end
		id = mStarFataManager.GetCFGStar(starId, mStarSkill.quality)
		local cfg_star = CFG_star[id]
		DrawItemCell(cfg_star,ItemType.Star,210+i*90,410,100,100)
		-- print({id=mStarFataManager.GetCFGStar(starId, mStarSkill.quality)},ItemType.Star,223+i*90,417,82,82)
	end
	
end
