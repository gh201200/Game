local _G,Screen,Language,GUI,ByteArray,print,Texture2D = _G,Screen,Language,GUI,ByteArray,print,Texture2D
local PackatHead,Packat_Account,GUIStyleButton,Color,CFG_role,math,GUIStyleLabel,ConstValue,string,tonumber, platform, mSDK, luanet = 
PackatHead,Packat_Account,GUIStyleButton,Color,CFG_role,math,GUIStyleLabel,ConstValue,string,tonumber, platform, mSDK, luanet
local AssetType,os,CFG_UniqueSailor,CFG_skill = AssetType,os,CFG_UniqueSailor,CFG_skill
local CFG_first_name,GUIStyleTextField = CFG_first_name,GUIStyleTextField
local CFG_last_name,require,debug,cs_Base = CFG_last_name,require,debug,cs_Base

local mAlertPanel = require "LuaScript.View.Alert.Alert"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mNetManager = require "LuaScript.Control.System.NetManager"
local mPanelManager = require "LuaScript.Control.PanelManager"
local mSceneManager = require "LuaScript.Control.Scene.SceneManager"
local mGUIStyleManager = require "LuaScript.Control.GUIStyleManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mSetManager = nil
local mSystemTip = nil
local JsonObj = nil
local mLoginPanel = nil
local mHeroManager = nil
local mHero = nil

module("LuaScript.View.Panel.Login.CreateHeroPanel") -- 创建角色界面

local heroRole = 105
local mUserName = '请输入姓名'

-- 随机名字按钮
-- local RandomButtonStyle_normal = {
	-- normal = {
		-- background = "Texture/Gui/CreateHero/15"
	-- },
	-- active = {
		-- background = "Texture/Gui/CreateHero/15"
	-- }
-- }
-- 开始游戏按钮
-- local StartGameStyle_normal = {
	-- normal = {
		-- background = "Texture/Gui/CreateHero/17"
	-- },
	-- active = {
		-- background = "Texture/Gui/CreateHero/17"
	-- }
-- }

function Init()
	mSetManager = require "LuaScript.Control.System.SetManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	JsonObj = luanet.import_type("JsonObj")
	mLoginPanel = require "LuaScript.View.Panel.Login.LoginPanel"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mHero = mHeroManager.GetHero()
	IsInit = true
	mNetManager.AddListen(PackatHead.ACCOUNT, Packat_Account.CHREATE_CHAR_RESULT, Create_Result)
	RandomName()
end

function Destroy()
	-- mNetManager.AddListen(PackatHead.ACCOUNT, Packat_Account.CHREATE_CHAR_RESULT, nil)
end

function OnGUI()
	
	local image = mAssetManager.GetAsset("Texture/Gui/CreateHero/18") --背景
	--GUI.DrawPackerTexture(image)
	GUI.DrawPackerTexture(image)
	-- local image = mAssetManager.GetAsset("Texture/Gui/CreateHero/12")
	-- GUI.DrawTexture(12,175,1108,156,image)
	
	local audioOpen = mSetManager.GetAudio()
	
	if audioOpen then -- 音效的开关按钮
		if GUI.Button(1040, 0, 90, 61,nil, GUIStyleButton.AudioBtn_1) then
			mSetManager.SetAudio(not audioOpen)
		end
	else
		if GUI.Button(1040, 0, 90, 61,nil, GUIStyleButton.AudioBtn_2) then
			mSetManager.SetAudio(not audioOpen)
		end
	end
	
	local cW,cH,cAllh,cgap= 164,164,178,160
		local image = mAssetManager.GetAsset("Texture/Gui/CreateHero/6", AssetType.Pic)
		if heroRole == 101 then
		      image = mAssetManager.GetAsset("Texture/Gui/CreateHero/1", AssetType.Pic)
		end
		if GUI.TextureButton(488+190, cAllh, cW, cH, image)then
			heroRole = 101 
		end
		local image = mAssetManager.GetAsset("Texture/Gui/CreateHero/7", AssetType.Pic)
		if heroRole == 102 then
		      image = mAssetManager.GetAsset("Texture/Gui/CreateHero/2", AssetType.Pic)
		end
		if GUI.TextureButton(488+380, cAllh, cW, cH, image)then
			heroRole = 102
		end
		local image = mAssetManager.GetAsset("Texture/Gui/CreateHero/8", AssetType.Pic)
		if heroRole == 103 then
		      image = mAssetManager.GetAsset("Texture/Gui/CreateHero/3", AssetType.Pic)
		end
		if GUI.TextureButton(110, cAllh, cW, cH, image)then
			heroRole = 103
		end
		local image = mAssetManager.GetAsset("Texture/Gui/CreateHero/9", AssetType.Pic)
		if heroRole == 104 then
		      image = mAssetManager.GetAsset("Texture/Gui/CreateHero/4", AssetType.Pic)
		end
		if GUI.TextureButton(300, cAllh, cW, cH, image)then
			heroRole = 104
		end
		local image = mAssetManager.GetAsset("Texture/Gui/CreateHero/10", AssetType.Pic)
		if heroRole == 105 then
		      image = mAssetManager.GetAsset("Texture/Gui/CreateHero/5", AssetType.Pic)
		end
		if GUI.TextureButton(488, cAllh, cW, cH, image)then
			heroRole = 105
		end
		
		-- local image = mAssetManager.GetAsset("Texture/Gui/CreateHero/19") -- 天赋技能框显示
		-- GUI.DrawTexture(110+20, cAllh+ 160, 128, 64, image)
		-- GUI.DrawTexture(300+20, cAllh+ 160, 128, 64, image)
		-- GUI.DrawTexture(488+20, cAllh+ 160, 128, 64, image)	
		-- GUI.DrawTexture(488+210, cAllh+ 160, 128, 64, image)
		-- GUI.DrawTexture(488+400, cAllh+ 160, 128, 64, image)
		-- local image = mAssetManager.GetAsset("Texture/Gui/CreateHero/3_1") -- 天赋技能内容显示
		-- GUI.DrawTexture(110+52, cAllh+ 183, 64,32, image)
		-- local image = mAssetManager.GetAsset("Texture/Gui/CreateHero/4_1")
		-- GUI.DrawTexture(300+52, cAllh+ 183, 64,32, image)
		-- local image = mAssetManager.GetAsset("Texture/Gui/CreateHero/5_1")
		-- GUI.DrawTexture(488+52, cAllh+ 183, 64,32, image)
		-- local image = mAssetManager.GetAsset("Texture/Gui/CreateHero/1_1")
		-- GUI.DrawTexture(688+40, cAllh+ 183, 64,32, image)
		-- local image = mAssetManager.GetAsset("Texture/Gui/CreateHero/2_1")
		-- GUI.DrawTexture(878+40, cAllh+ 183, 64,32, image)
		
		-- GUI.Label(630, 165.35,250,220, role.desc, GUIStyleLabel.Left_25_White_Art_WordWrap, Color.Black) -- 角色介绍
		
		-- local image = mAssetManager.GetAsset("Texture/Gui/CreateHero/11")
		-- GUI.DrawTexture(352,85,443,69,image)  -- 创建角色标题
		-- local image = mAssetManager.GetAsset("Texture/Gui/CreateHero/13")
		-- GUI.DrawTexture(350,410,141,29,image) -- 角色名称艺术字背景
		-- local image = mAssetManager.GetAsset("Texture/Gui/CreateHero/14")
		-- GUI.DrawTexture(352,410,141,29,image) -- 角色名称艺术字
		-- local image = mAssetManager.GetAsset("Texture/Gui/CreateHero/16")
		-- GUI.DrawTexture(500,400,254,46,image) -- 名称输入框背景
		
		-- 随机名字
		if GUI.Button(703, 403, 34, 36,nil, GUIStyleButton.Transparent) then
			RandomName()
		end
		
		local newName  = GUI.TextArea(515, 400, 185, 71, mUserName, GUIStyleTextField.Transparent)
		if string.len(newName) <= ConstValue.NameMaxLength then
			mUserName = newName
		else
			mSystemTip.ShowTip("名字长度超过上限")
		end
		
		-- 创建角色，开始游戏
		if GUI.Button(415, 450, 277, 93, nil, GUIStyleButton.Transparent) then
			Create()
		end
		GUI.FrameAnimation(425,433,256,128,'CreateHeroStartButton',7,0.1) -- 动画
end

function RandomName()  -- 随机名字
	local role = CFG_role[heroRole]
	local firstName = ""
	local lastName = ""
	local lastCount = ConstValue.NameMaxLength - 2
	while true do
		local first_name = CFG_first_name[math.random(#CFG_first_name)]
		if first_name.sex == role.sex then
			firstName = first_name.name
			lastCount = lastCount - string.len(firstName)
			break
		end
	end
	
	while true do
		local last_name = CFG_last_name[math.random(#CFG_last_name)]
		if last_name.sex == role.sex and lastCount >= string.len(last_name.name) and 
			firstName ~= last_name.name then
			lastName = last_name.name
			break
		end
	end
	
	mUserName = firstName .. "·" .. lastName
end

function Create()  -- 创建按钮点击
	--判断起名是否合法
	if string.len(mUserName) == 0 then
		mAlertPanel.Show("名字不能为空",RandomName,nil,"更换")
		return
	end
	
	if string.find(mUserName," ") then
		mAlertPanel.Show("名字不能加入空格",RandomName,nil,"更换")
		return
	end

	if string.find(mUserName,"%%") then
		mAlertPanel.Show("名字不能加入百分号",RandomName,nil,"更换")
		return
	endreturn
	end
	
	if string.find(mUserName,"\\") then
		mAlertPanel.Show("名字不能加入斜杠",RandomName,nil,"更换")
		return
	end
	
	if string.find(mUserName,"?") or string.find(mUserName,"？") then
		mAlertPanel.Show("名字不能加入问号",RandomName,nil,"更换")
		return
	end
	
	if string.find(mUserName,"=") then
		mAlertPanel.Show("名字不能加入等号",RandomName,nil,"更换")
		return
	end
	
	if string.find(mUserName,"&") then
		mAlertPanel.Show("名字不能加入&",RandomName,nil,"更换")
		return
	end
	
	
	local number = tonumber(mUserName)
	if number then
		mAlertPanel.Show("不能用纯数字作为名字",RandomName,nil,"更换")
		return
	end 

	mUserName = mCommonlyFunc.CheckWord(mUserName)
	
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.ACCOUNT)
	ByteArray.WriteByte(cs_ByteArray,Packat_Account.REQUEST_CREATE_CHAR)
	ByteArray.WriteInt(cs_ByteArray,heroRole)
	ByteArray.WriteUTF(cs_ByteArray,mUserName)
	mNetManager.SendData(cs_ByteArray)
end


function Create_Result(cs_ByteArray) -- 判断名字是否已经被使用
	local sucess = ByteArray.ReadInt(cs_ByteArray)
	mHero = mHeroManager.GetHero()
	print("Create_Result " .. sucess)
	print("mHero", _G.dumpTab(mHero))
	if sucess == 1 then
		mAlertPanel.Show("名字已经被使用",RandomName,nil,"更换")
	else
		mHeroManager.newHero = true
	end
end
