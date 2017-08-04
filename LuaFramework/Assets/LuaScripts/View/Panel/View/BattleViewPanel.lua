local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,CFG_sign,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,CFG_sign,os
local ConstValue,GUIStyleButton,PackatHead,Packat_Player,UnityEventType,CsCurrentEventEqualsType,CFG_Enemy = 
ConstValue,GUIStyleButton,PackatHead,Packat_Player,UnityEventType,CsCurrentEventEqualsType,CFG_Enemy
local CharacterType,CFG_harbor = CharacterType,CFG_harbor
local mAssetManager = require "LuaScript.Control.AssetManager"
local mPanelManager = nil
local mMainPanel = nil
local mSceneManager = nil
local mCommonlyFunc = nil
local mCharManager = nil
local mBattleManager = nil
local mRelationManager = nil
local mNetManager = nil
local mSystemTip = nil
local mAlert = nil
local mHeroManager = nil

module("LuaScript.View.Panel.View.BattleViewPanel")
panelType = ConstValue.AlertPanel
local mBattleFieldId = 0
local tipStr = nil

function SetData(id)
	mBattleFieldId = id
end

function Init()
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	mBattleManager = require "LuaScript.Control.Data.BattleFieldManager"
	mRelationManager = require "LuaScript.Control.Data.RelationManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mAlert = require "LuaScript.View.Alert.Alert"
	IsInit = true
	
	tipStr = mCommonlyFunc.BeginColor(ConstValue.RelationColorStr[2])
	tipStr = tipStr .. Language[137]
	tipStr = tipStr .. mCommonlyFunc.EndColor()
	tipStr = tipStr .. mCommonlyFunc.Linefeed()
	
	tipStr = tipStr .. mCommonlyFunc.BeginColor(ConstValue.RelationColorStr[3])
	tipStr = tipStr .. Language[138]
	tipStr = tipStr .. mCommonlyFunc.EndColor()
	tipStr = tipStr .. mCommonlyFunc.Linefeed()
	
	tipStr = tipStr .. mCommonlyFunc.BeginColor(ConstValue.RelationColorStr[4])
	tipStr = tipStr .. Language[139]
	tipStr = tipStr .. mCommonlyFunc.EndColor()
end

function Display()
	-- mMouseEventState = mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false)
end

-- function Hide()
	-- mSceneManager.SetMouseEvent(mMouseEventState)
-- end

function OnGUI()
	local battleField = mBattleManager.GetBattleField(mBattleFieldId)
	if not battleField then
		if GUI.EventRepaint then
			mPanelManager.Hide(OnGUI)
			mSystemTip.ShowTip("战斗已经结束")
			mSceneManager.SetMouseEvent(true)
		end
		return
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg23_1")
	GUI.DrawTexture(110,47,908,561,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/family_1")
	GUI.DrawTexture(185,106,305,361,image)
	GUI.DrawTexture(626,106,305,361,image)

	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg13_1")
	GUI.DrawTexture(480,149,159,177,image)
	
	local teamStr1,teamStr2 = mCommonlyFunc.GetBattleTeamInfo(battleField)
	GUI.Label(211, 128, 254, 300, teamStr1, GUIStyleLabel.Center_25_White, Color.Black)
	GUI.Label(652, 128, 254, 300, teamStr2, GUIStyleLabel.Center_25_White, Color.Black)
	
	GUI.Label(508, 348, 104.2, 400, tipStr, GUIStyleLabel.Center_20_White_Art, Color.Black)
	
	if GUI.Button(226, 456, 223, 78, "加入", GUIStyleButton.OrangeBtn) then
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
		if BreakProtect(battleField.team[1], battleField.team[0]) then
			function OkFunc()
				Join(battleField, 0)
			end
			mAlert.Show("加入该战场,当前保护状态将消失,是否继续?", OkFunc)
		elseif BreakMode(battleField.team[1], battleField.team[0]) then
			function OkFunc()
				Join(battleField, 0)
			end
			mAlert.Show("加入该战场,将自动切换成“战争模式”,是否继续?", OkFunc)
		else
			Join(battleField, 0)
		end
		-- print("join")
	end
	if GUI.Button(668, 456, 223, 78, "加入", GUIStyleButton.OrangeBtn) then
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
		if BreakProtect(battleField.team[0],battleField.team[1]) then
			function OkFunc()
				Join(battleField, 1)
			end
			mAlert.Show("加入该战场,当前保护状态将消失,是否继续?", OkFunc)
		elseif BreakMode(battleField.team[0], battleField.team[1]) then
			function OkFunc()
				Join(battleField, 1)
			end
			mAlert.Show("加入该战场,将自动切换成“战争模式”,是否继续?", OkFunc)
		else
			Join(battleField, 1)
		end
		-- print("join")
	end
	
	if GUI.Button(941, 38, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
		mSceneManager.SetMouseEvent(true)
		-- print("guanbi")
	end
end

function BreakProtect(team,selfTeam)
	local hero = mHeroManager.GetHero()
	if not hero.protectState then
		return false
	end
	for k,member in pairs(team) do
		if member.type == CharacterType.Harbor then
			return false
		end
	end
	for k,member in pairs(selfTeam) do
		if member.type == CharacterType.Harbor then
			return false
		end
	end
	for k,member in pairs(team) do
		if member.type ~= CharacterType.Enemy and member.type ~= CharacterType.NpcShipTeam then
			return true
		end
	end
end

function BreakMode(team,selfTeam)
	local hero = mHeroManager.GetHero()
	if hero.mode == 1 then
		return false
	end
	if hero.level < 28 then
		return false
	end
	for k,member in pairs(team) do
		if member.type == CharacterType.Harbor then
			return false
		end
	end
	for k,member in pairs(selfTeam) do
		if member.type == CharacterType.Harbor then
			return false
		end
	end
	for k,member in pairs(team) do
		if member.type == CharacterType.Enemy then
			local char = mCharManager.GetChar(member.id)
			if char then
				local cfg_Enemy = CFG_Enemy[char.eid]
				if cfg_Enemy.isBoss ~= 0 then
					return true
				end
			end
		end
		if member.type ~= CharacterType.Enemy and member.type ~= CharacterType.NpcShipTeam then
			return true
		end
	end
end

function Join(battleField, teamId)
	local battleField = mBattleManager.GetBattleField(battleField.id)
	if not battleField then
		return
	end
	local hero = mHeroManager.GetHero()
	mHeroManager.SetTarget(ConstValue.BattleField, {battleFieldId=battleField.id,teamId=teamId})
	mHeroManager.Goto(hero.map, battleField.x, battleField.y)
end

