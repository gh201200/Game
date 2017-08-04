local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os
local CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleButton,GUIStyleTextField,string = 
CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleButton,GUIStyleTextField,string
local AssetType,GetFirstKey,EnemyState,CFG_map,CFG_harbor = 
AssetType,GetFirstKey,EnemyState,CFG_map,CFG_harbor
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHarborManager = require "LuaScript.Control.Scene.HarborManager"
local mSailorPanel = require "LuaScript.View.Panel.Sailor.SailorPanel"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mSceneManager = nil
local mHeroManager = nil
local mCommonlyFunc = nil
local mFriendChatPanel = nil
local mMainPanel = nil
local mCharViewPanel = nil
local mFriendFindPanel = nil
local mRelationManager = nil
local mAlert = nil
local mSystemTip = nil

module("LuaScript.View.Panel.Friend.EnemyInfoViewPanel")
local mMouseEventState = nil
local mChar = nil
panelType = ConstValue.AlertPanel

function Init()
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mFriendChatPanel = require "LuaScript.View.Panel.Friend.FriendChatPanel"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mCharViewPanel = require "LuaScript.View.Panel.View.CharViewPanel"
	mRelationManager = require "LuaScript.Control.Data.RelationManager"
	mFriendFindPanel = require "LuaScript.View.Panel.Friend.FriendFindPanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	IsInit = true
end

function SetData(char)
	mChar = char
end

function Hide()
	mSceneManager.SetMouseEvent(mMouseEventState)
end

function Display()
	mMouseEventState = mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false)
end

function OnGUI()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg2_2")
	GUI.DrawTexture(309.7,152.05,560, 350.1, image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/equipSlot_"..(mChar.quality or 1))
	GUI.DrawTexture(371.7, 255, 128, 128, image)
	local image = mAssetManager.GetAsset("Texture/Character/Header/"..mChar.resId, AssetType.Pic)
	GUI.DrawTexture(376.7, 260, 100, 100, image)
	
	GUI.Label(477, 337, 0, 30,  "Lv:"..mChar.level, GUIStyleLabel.Right_25_White,Color.Black)
		
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(506,242,313,140,image,0,0,1,1,20,20,20,20)
	
	if mChar.state == 0 then
		GUI.Label(457.7, 190.8, 256.2, 30, mChar.name, GUIStyleLabel.Center_35_Brown_Art)
		GUI.Label(527.85, 246, 256.2, 30, "状态: 离线", GUIStyleLabel.Left_25_Black)
		GUI.Label(527.85, 282, 256.2, 30, "位置: ????", GUIStyleLabel.Left_25_Black)
		GUI.Label(527.85, 315, 256.2, 30, "坐标: ????", GUIStyleLabel.Left_25_Black)
		GUI.Label(527.85, 348, 256.2, 30, "战斗力: ????", GUIStyleLabel.Left_25_Black)
	elseif mChar.state == 1 then
		GUI.Label(457.7, 190.8, 256.2, 30,  mChar.name, GUIStyleLabel.Center_35_Brown_Art)
		GUI.Label(527.85, 246, 256.2, 30, "状态: 在线", GUIStyleLabel.Left_25_Black)
		if mChar.harbor ~= 0 then
			GUI.Label(527.85, 282, 256.2, 30, "位置: 港口("..CFG_harbor[mChar.harbor].name..")", GUIStyleLabel.Left_25_Black)
		else
			GUI.Label(527.85, 282, 256.2, 30, "位置: "..CFG_map[mChar.map].name, GUIStyleLabel.Left_25_Black)
		end
		GUI.Label(527.85, 315, 256.2, 30, "坐标: "..mChar.x .. "," .. mChar.y, GUIStyleLabel.Left_25_Black)
		GUI.Label(527.85, 348, 256.2, 30, "战斗力: "..mChar.power, GUIStyleLabel.Left_25_Black)
	elseif mChar.state == 2 then
		GUI.Label(457.7, 190.8, 256.2, 30,  mChar.name, GUIStyleLabel.Center_35_Brown_Art)
		GUI.Label(527.85, 246, 256.2, 30, "状态: 保护", GUIStyleLabel.Left_25_Black)
		if mChar.harbor ~= 0 then
			GUI.Label(527.85, 282, 256.2, 30, "位置: 港口("..CFG_harbor[mChar.harbor].name..")", GUIStyleLabel.Left_25_Black)
		else
			GUI.Label(527.85, 282, 256.2, 30, "位置: "..CFG_map[mChar.map].name, GUIStyleLabel.Left_25_Black)
		end
		GUI.Label(527.85, 315, 256.2, 30, "坐标: "..mChar.x .. "," .. mChar.y, GUIStyleLabel.Left_25_Black)
		GUI.Label(527.85, 348, 256.2, 30, "战斗力: "..mChar.power, GUIStyleLabel.Left_25_Black)
	elseif mChar.state == 3 then
		GUI.Label(457.7, 190.8, 256.2, 30,  mChar.name, GUIStyleLabel.Center_35_Brown_Art)
		GUI.Label(527.85, 246, 256.2, 30, "状态: 和平", GUIStyleLabel.Left_25_Black)
		if mChar.harbor ~= 0 then
			GUI.Label(527.85, 282, 256.2, 30, "位置: 港口("..CFG_harbor[mChar.harbor].name..")", GUIStyleLabel.Left_25_Black)
		else
			GUI.Label(527.85, 282, 256.2, 30, "位置: "..CFG_map[mChar.map].name, GUIStyleLabel.Left_25_Black)
		end
		GUI.Label(527.85, 315, 256.2, 30, "坐标: "..mChar.x .. "," .. mChar.y, GUIStyleLabel.Left_25_Black)
		GUI.Label(527.85, 348, 256.2, 30, "战斗力: "..mChar.power, GUIStyleLabel.Left_25_Black)
	end
	local oldEnabled = GUI.GetEnabled()
	if mChar.state ~= 1 then
		GUI.SetEnabled(false)
	end
	if GUI.Button(423, 405, 111, 53, "复仇", GUIStyleButton.ShortOrangeArtBtn) then
		function OkFunc()
			if mCommonlyFunc.HaveGold(100) then
				mRelationManager.RequestAttackEnemyInfo(mChar.id)
			end
		end
		mAlert.Show("是否花费100元宝直接攻击该玩家?",OkFunc)
	end	
	if mChar.state ~= 1 then
		GUI.SetEnabled(oldEnabled)
	end
	
	
	if GUI.Button(663, 405, 111, 53, "关闭", GUIStyleButton.ShortOrangeArtBtn) then
		mPanelManager.Hide(OnGUI)
	end
	
	if GUI.Button(802.2, 139, 77, 63,nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end