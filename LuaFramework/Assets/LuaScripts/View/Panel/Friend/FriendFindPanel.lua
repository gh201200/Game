local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,Vector2,tostring,table,os
local CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleButton,GUIStyleTextField,string,tonumber = 
CFG_ship,CFG_buildDesc,ConstValue,SceneType,GUIStyleButton,GUIStyleTextField,string,tonumber
local mAssetManager = nil
local mGUIStyleManager = nil
local mPanelManager = nil
local mSceneManager = nil
local mRelationManager = nil
local mSystemTip = nil
local mHeroManager = nil
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"

module("LuaScript.View.Panel.Friend.FriendFindPanel")

panelType = ConstValue.AlertPanel
local mName = ""

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mRelationManager = require "LuaScript.Control.Data.RelationManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	IsInit = true
	-- print("init")
end

function Hide()
	mName = ""
end

function OnGUI()
	-- GUI.BeginGroup(55,-20,1000,600)
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/alertBg")
		GUI.DrawTexture(291,194,560,341,image)
		
		local image = mAssetManager.GetAsset("Texture/Gui/Text/addFriend")
		GUI.DrawTexture(508,226,103,35,image)
		-- GUI.Label(306, 223, 457.95, 150, "加好友", GUIStyleLabel.Left_25_White_WordWrap)
		GUI.Label(394.3, 282, 133, 150, "名字或编号:", GUIStyleLabel.Left_30_Redbean_Art)
		
		-- local image = mAssetManager.GetAsset("Texture/Gui/Button/text_3")
		-- GUI.DrawTexture(386,323,371.95,53,image,0,0,1,1,15,23,15,23)
		
		name = GUI.TextField(386,323,366.45,78, mName, GUIStyleTextField.Left_30_White)
		if string.len(name) <= ConstValue.NameMaxLength then
			mName = name
		end
		
		if GUI.Button(496, 420, 133, 60,nil, GUIStyleButton.AddFriendBtn) then
			if string.len(mName) <= 0 then
				mSystemTip.ShowTip("请先输入玩家名字或编号")
				return
			end
			local hero = mHeroManager.GetHero()
			local id = tonumber(mName)
			if id then
				if id == hero.id then
					mSystemTip.ShowTip("无法加自己为好友")
					return
				end
				mRelationManager.RequestFriendById(id)
			else
				if mName == hero.name then
					mSystemTip.ShowTip("无法加自己为好友")
					return
				end
				mRelationManager.RequestFriendByName(mName)
			end
			mPanelManager.Hide(OnGUI)
		end
		
		if GUI.Button(777, 178.5, 77, 63,nil, GUIStyleButton.CloseBtn) then
			mPanelManager.Hide(OnGUI)
		end
	-- GUI.EndGroup()
end