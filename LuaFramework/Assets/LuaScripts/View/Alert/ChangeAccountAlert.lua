local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,ByteArray,GUIStyleLabel,CFG_Equip,CFG_property,GUIStyleButton
local ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty = ConstValue,CFG_EquipSuit,CFG_buildDesc,CFG_harborProperty
local AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,CFG_family,EventType,string,Packat_Player,PackatHead = 
AssetType,CFG_role,CFG_Exp,tonumber,GUIStyleTextField,CFG_family,EventType,string,Packat_Player,PackatHead
local Application = Application
local mAssetManager = require "LuaScript.Control.AssetManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mEquipUpPanel = nil
local mEquipSelectPanel = nil
-- 
local mSceneManager = nil
local mHeroManager = require "LuaScript.Control.Scene.HeroManager"
local mCharManager = nil
local mPanelManager = nil
local mHarborManager = nil
local mEventManager = nil
local mSystemTip = nil
local mNetManager = nil
local mPromptAlert = nil
local mFamilyManager = require "LuaScript.Control.Data.FamilyManager"

module("LuaScript.View.Alert.ChangeAccountAlert") -- 使用改名面板
panelType = ConstValue.AlertPanel
local mId = nil
local mName = nil
local mLevel = nil

local mNewId = ""

function Init()
	-- print(111)
	mPanelManager = require "LuaScript.Control.PanelManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	-- mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	-- 
	mEquipUpPanel = require "LuaScript.View.Panel.Equip.EquipUpPanel"
	mEquipSelectPanel = require "LuaScript.View.Panel.Equip.EquipSelectPanel"
	mHarborManager = require "LuaScript.Control.Scene.HarborManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mPromptAlert = require "LuaScript.View.Alert.PromptAlert"
	
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_CHG_NAME_FAILED, SEND_CHG_NAME_FAILED)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_CHG_NAME_SUC, SEND_CHG_NAME_SUC)
	
	
	IsInit = true
end

function Show(id,name,level)
	mId = id
	mName = name
    mLevel = level
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/alertBg")
	GUI.DrawTexture(284,144,560,341,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Text/tip")
	GUI.DrawTexture(486,178,133,34,image)
	
	local mNewId = GUI.TextArea(384,287,356,78, mName, GUIStyleTextField.Left_30_White)
	if string.len(mNewId) <= ConstValue.NameMaxLength then
		mName = mNewId
	else
		mSystemTip.ShowTip("名字长度超过上限")
	end
	
	GUI.Label(386,244,82.7,30,"请输入名称:", GUIStyleLabel.Center_30_Brown_Art)
	
	if GUI.Button(372,366,166,77, "确定", GUIStyleButton.BlueBtn) then
		RequestChangeName()
	end
	if GUI.Button(586,366,166,77, "取消", GUIStyleButton.BlueBtn) then
		mPanelManager.Hide(OnGUI)
	end
	if GUI.Button(769,128,77,63, nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
end

function RequestChangeName()
	if string.len(mName) == 0 then
		mSystemTip.ShowTip("名字不能为空")
		return
	end
	local number = tonumber(mName)
	if number then
		mSystemTip.ShowTip("不能用纯数字作为名字")
		return
	end
	mName = mCommonlyFunc.CheckWord(mName)
	
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
	ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_REQUEST_CHG_NAME)
	ByteArray.WriteUTF(cs_ByteArray,mName,40)
	mNetManager.SendData(cs_ByteArray)
end

function SEND_CHG_NAME_FAILED()
	mSystemTip.ShowTip("该名字已被使用")
end

function SEND_CHG_NAME_SUC()
	mPanelManager.Hide(OnGUI)
	mPromptAlert.Show("名字更换成功,请重新登陆游戏", mCommonlyFunc.QuitGame)
end
