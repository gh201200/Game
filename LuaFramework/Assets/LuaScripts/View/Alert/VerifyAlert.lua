local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,_G,getfenv,GUIStyleButton,ConstValue,GUIStyleLabel
local string,GUIStyleTextField,tonumber = string,GUIStyleTextField,tonumber

local mAssetManager = nil
local mGUIStyleManager = nil
local mPanelManager = require "LuaScript.Control.PanelManager"
local mSceneManager = nil
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
module("LuaScript.View.Alert.VerifyAlert") -- 验证码窗口

local mInfo = nil
local mStr = ""
local key = nil
local mOkFunction = nil

panelType = ConstValue.AlertPanel


local mSigns = {
	{func = math.sum,   str = "验证题目：%d + %d = ?"},
	{func = math.minus, str = "验证题目：%d - %d = ?"}
}

function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	IsInit = true
end

function Show(func)
	local a = math.random(10)
	local b = math.random(10)
	local sign = mSigns[math.random(2)]
	-- print(sign)
	key = sign.func(a, b)
	mInfo = string.format(sign.str, a, b)
	mStr = ""
	mOkFunction = func
	mPanelManager.Show(OnGUI)
end

function OnGUI()
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/alertBg")
	GUI.DrawTexture(286,150,560,341,image)
	local image = mAssetManager.GetAsset("Texture/Gui/Text/tip")
	GUI.DrawTexture(486,182,133,34,image)
	
	GUI.Label(388, 261, 424.2, 150, mInfo, GUIStyleLabel.Left_30_Brown_Art)
	GUI.Label(388, 317, 424.2, 150, "请输答案：", GUIStyleLabel.Left_30_Brown_Art)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/text_4")
	GUI.DrawTexture(533,311,173,47,image)
	mStr = GUI.TextArea(533,311,173,47, mStr, GUIStyleTextField.Transparent_25)
	
	if GUI.Button(473, 372, 166, 77, Language[25], GUIStyleButton.BlueBtn) then
		-- print(key, tonumber(mStr))
		if tonumber(mStr) ~= key then
			Show(mOkFunction)
		else
			if mOkFunction then
				mOkFunction()
			end
			mPanelManager.Hide(OnGUI)
		end
	end
end