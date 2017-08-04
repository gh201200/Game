local _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel = _G,Screen,Language,GUI,ByteArray,print,Texture2D,GUIStyleLabel
local PackatHead,Packat_Account,Packat_Player,require,table = PackatHead,Packat_Account,Packat_Player,require,table
local Color,os,ConstValue,pairs,math,GUIStyleButton,ActionType,AssetPath,SceneType = 
Color,os,ConstValue,pairs,math,GUIStyleButton,ActionType,AssetPath,SceneType
local mPanelManager = nil
local mCommonlyFunc = nil
local mGUIStyleManager = nil
local mAssetManager = nil
local mMainPanel = nil
local mLoadPanel = nil
local mHeroManager = nil
local mAlert = nil
local mActionManager = nil
local mBattleFieldManager = nil
local mCharManager = nil
-- local mSkillTip = require "LuaScript.View.Tip.SkillTip"

module("LuaScript.View.Panel.Main.BattleDPS")

mShowAll = nil
local mStr1 = nil
local mStr2 = nil

local mNameList = nil

function Init()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mLoadPanel = require "LuaScript.View.Panel.LoadPanel"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mAlert = require "LuaScript.View.Alert.Alert"
	mActionManager = require "LuaScript.Control.ActionManager"
	mBattleFieldManager = require "LuaScript.Control.Data.BattleFieldManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
end

function OnGUI()
	local hero = mHeroManager.GetHero()
	if hero.SceneType == SceneType.Harbor then
		mNameList = nil
		return
	end
	
	hurtList = mBattleFieldManager.GetHurtList()
	if not hurtList then
		return
	end
	
	local offset = 0
	if hero.SceneType == SceneType.Normal then
		offset = 305
	-- elseif mSkillTip.visible then
		-- offset = 320
	end
	
	if mShowAll then
		if GUI.Button(offset,0,295,45,nil,GUIStyleButton.Transparent) then
			mShowAll = false
		end
		
		local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_HurtBank_2)
		GUI.DrawTexture(offset,0,512,512,image)
		
		DrawRanker(offset+20,53,1)
		DrawRanker(offset+20,53+34,2)
		DrawRanker(offset+20,53+34*2,3)
		DrawRanker(offset+20,53+34*3,4)
		DrawRanker(offset+20,53+34*4,5)
		DrawRanker(offset+20,53+34*5,6)
		DrawRanker(offset+20,53+34*6,7)
		DrawRanker(offset+20,53+34*7,8)
		DrawRanker(offset+20,53+34*8,9)
		DrawRanker(offset+20,53+34*9,10)
		
		DrawSelfRank(offset+20,53+34*10)
		
	else
		if GUI.Button(offset,0,156,45,nil,GUIStyleButton.Transparent) then
			mShowAll = true
		end
		
		local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_HurtBank_1)
		GUI.DrawTexture(offset,0,256,64,image)
	end
end

function DrawRanker(x,y,index)
	local ranker = hurtList.rankList[index]
	if ranker then
		mNameList = mNameList or {}
		
		local char = mCharManager.GetChar(ranker.id)
		local mStr1 = nil
		if char then
			mStr1 = index .. "." ..  char.name .. "\n"
			mNameList[ranker.id] = char.name 
		elseif mNameList[ranker.id] then
			mStr1 = index .. "." ..  mNameList[ranker.id] .. "\n"
		else
			mStr1 = index .. ".????\n"
		end
		
		GUI.Label(x,y,0,50,mStr1,GUIStyleLabel.Left_23_White)
		GUI.Label(x+253,y,0,50,ranker.hurt,GUIStyleLabel.Right_25_White)
	end
end

function DrawSelfRank(x, y)
	local mStr1 = nil
	if hurtList.rank ~= 0 then
		mStr1 = "当前排名: " .. hurtList.rank
	else
		mStr1 = "当前排名: --"
	end
	
	GUI.Label(x,y,0,50,mStr1,GUIStyleLabel.Left_23_White)
	GUI.Label(x+253,y,0,50,hurtList.hurt,GUIStyleLabel.Right_25_White)
end
