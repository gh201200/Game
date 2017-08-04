local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,GUIStyleButton,ActionType,AssetPath,SceneType,CFG_starSkill,Vector2,GUIUtility = 
Color,os,ConstValue,pairs,math,GUIStyleButton,ActionType,AssetPath,SceneType,CFG_starSkill,Vector2,GUIUtility
local mPanelManager = require "LuaScript.Control.PanelManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mLoadPanel = require "LuaScript.View.Panel.LoadPanel"
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mAlert = require "LuaScript.View.Alert.Alert"
local mActionManager = require "LuaScript.Control.ActionManager"
local mBattleFieldManager = require "LuaScript.Control.Data.BattleFieldManager"
local mCharManager = require "LuaScript.Control.Scene.CharManager"
local mStarFateManager = require "LuaScript.Control.Data.StarFateManager"
local pivotPoint = nil

module("LuaScript.View.Panel.Main.BattleSkill")-- 战场技能面板


function Init()
	pivotPoint = Vector2.New(GUI.HorizontalRestX(982+296/2),GUI.VerticalRestY(500+296/2))
end

function OnGUI()
	local mActiveSkillList = mStarFateManager.GetActionSkillList()
	if not mActiveSkillList then
		visible = false
		return
	end
	visible = true
	
	local ragePoint = mStarFateManager.GetRagePoint()
	local angle = 90*ragePoint/100 - 90 + 41
	GUIUtility.RotateAroundPivot(angle, pivotPoint)
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg52_4")
	GUI.DrawTexture(982, 500, 296, 296, image)
	GUIUtility.RotateAroundPivot(-angle, pivotPoint)
	
	GUI.FrameAnimation(962, 483, 173, 157,'battle_hot') -- 怒气动画

	
	local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg52_1)
	GUI.DrawTexture(958,485,340,340,image)
	
	-- local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg52_3)
	-- GUI.DrawTexture(0,3,(271*ragePoint/100),19,image,0,0,ragePoint/100,1,0,25,0,0)
	
	-- local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_bg52_1)
	-- GUI.DrawTexture(0,-18,319,91,image)
	GUI.Label(1060,540,75,0,mCommonlyFunc.GetRageStr(ragePoint),GUIStyleLabel.Right_18_Lime,Color.Black)
	
	DrawSkill(864, 500, mActiveSkillList[1])
	DrawSkill(939, 422, mActiveSkillList[2])
	DrawSkill(1030, 367, mActiveSkillList[3])
end

function DrawSkill(x, y, skill)
	if not skill then
		return
	end
	
	local cfg_starSkill = CFG_starSkill[skill.id]
	local ragePoint = mStarFateManager.GetRagePoint()
	local cd = skill.cd or 0
	local cd2 = skill.cd2 or 0
	
	if cd > os.oldClock or cd2 > os.oldClock or  cfg_starSkill.anger > ragePoint then
		if not cfg_starSkill.resId2 then
			cfg_starSkill.resId2 = "Texture/Icon/StarSkill2/"..cfg_starSkill.resId.."_2"
		end
		local image = mAssetManager.GetAsset(cfg_starSkill.resId2)
		GUI.DrawTexture(x, y,95,95,image)
		GUI.Button(x, y,95,95,nil,GUIStyleButton.Transparent)
	else
		if not cfg_starSkill.resId1 then
			cfg_starSkill.resId1 = "Texture/Icon/StarSkill2/"..cfg_starSkill.resId.."_1"
		end
		local image = mAssetManager.GetAsset(cfg_starSkill.resId1)
		if GUI.TextureButton(x, y,95,95,image) then
			skill.cd2 = os.oldClock + 1
			mBattleFieldManager.RequestUseSkill(skill.index)
		end
	end
	
	if cd2 > os.oldClock then
	elseif cd > os.oldClock then
		GUI.Label(x+48,y+35,0,0,math.ceil(cd-os.oldClock),GUIStyleLabel.Center_30_Lime_Art,Color.Black)
	else
		if not cfg_starSkill.angerStr then
			cfg_starSkill.angerStr = "怒气:"..cfg_starSkill.anger
		end
		if cfg_starSkill.anger > ragePoint then
			GUI.Label(x+45,y+65,0,0,cfg_starSkill.angerStr,GUIStyleLabel.Center_20_Gray_Art,Color.Black)
		else
			GUI.Label(x+45,y+65,0,0,cfg_starSkill.angerStr,GUIStyleLabel.Center_20_Lime_Art,Color.Black)
		end
	end
end