local _G,Screen,Language,GUI,ByteArray,print,Texture2D,Input,math,Event,UnityEventType,MouseButton,CFG_map,AppearEvent = 
_G,Screen,Language,GUI,ByteArray,print,Texture2D,Input,math,Event,UnityEventType,MouseButton,CFG_map,AppearEvent
local PackatHead,Packat_Account,Packat_Player,require,KeyCode = PackatHead,Packat_Account,Packat_Player,require,KeyCode
local GUIStyleLabel,Color,SceneType,GUIStyleButton,EventType,CFG_send,ConstValue,AssetPath = 
GUIStyleLabel,Color,SceneType,GUIStyleButton,EventType,CFG_send,ConstValue,AssetPath
local mAssetManager = nil
local mPanelManager = nil

module("LuaScript.View.Panel.BorderPanel")
notAutoClose = true
notShowGuide = true
panelType = ConstValue.TipPanel

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mPanelManager = require "LuaScript.Control.PanelManager"
	IsInit = true
end

-- function Hide()
	-- print("!!!!!!!!!!!!!")
-- end

function OnGUI()
	if GUI.offsetX == 0 and GUI.offsetY == 0 then
		mPanelManager.Hide(OnGUI)
		return
	end
	if GUI.offsetX ~= 0 then
		local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_verticalBorder)
		GUI.UnScaleDrawTexture(0,0,GUI.offsetX,Screen.height,image)
		GUI.UnScaleDrawTexture(Screen.width-GUI.offsetX,0,GUI.offsetX,Screen.height,image,1,0,-1,1,0,0,0,0)
		GUI.UnScaleButton(0,0,GUI.offsetX,Screen.height,nil,GUIStyleButton.Transparent)
		GUI.UnScaleButton(Screen.width-GUI.offsetX,0,GUI.offsetX,Screen.height,nil,GUIStyleButton.Transparent)
	else
		local image = mAssetManager.GetAsset(AssetPath.Gui_Bg_horizontalBorder)
		GUI.UnScaleDrawTexture(0,0,Screen.width,GUI.offsetY,image)
		GUI.UnScaleDrawTexture(0,Screen.height-GUI.offsetY,Screen.width,GUI.offsetY,image,0,1,1,-1,0,0,0,0)
		GUI.UnScaleButton(0,0,Screen.width,GUI.offsetY,nil,GUIStyleButton.Transparent)
		GUI.UnScaleButton(0,Screen.height-GUI.offsetY,Screen.width,GUI.offsetY,nil,GUIStyleButton.Transparent)
	end
end