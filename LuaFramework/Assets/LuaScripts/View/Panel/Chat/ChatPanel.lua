local GUI,RunLuaScript,Language,_G,os,print,Application,KeyCode,Input,Event,UnityEventType,Vector2,SceneType,require,EventType = 
GUI,RunLuaScript,Language,_G,os,print,Application,KeyCode,Input,Event,UnityEventType,Vector2,SceneType,require,EventType
local pairs,ConstValue,Directory,GUIStyleButton,GUIStyleTextField,Color,GUIStyleLabel,string,CFG_item,math ,CFG_map= 
pairs,ConstValue,Directory,GUIStyleButton,GUIStyleTextField,Color,GUIStyleLabel,string,CFG_item,math,CFG_map
local CsStringSub = CsStringSub
local mPanelManager = require "LuaScript.Control.PanelManager"
local mAlertManager = require "LuaScript.View.Alert.Alert"
local mTimer = require "LuaScript.Common.Timer"
local mChatManager = require "LuaScript.Control.Data.ChatManager"
local mEventManager = nil
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mAssetManager = require "LuaScript.Control.AssetManager"
local mHeroManager = nil
local mMainPanel = nil
local mSceneManager = nil
local mSystemTip = nil
local mItemManager = nil
local mAlert = nil
local mSelectAlert = nil
local mSetManager = nil
local mFamilyManager = nil
local mSDK = mSDK
module("LuaScript.View.Panel.Chat.ChatPanel") -- 聊天面板
panelType = ConstValue.AlertPanel

local mMsgStr = ""
local mSendMsgStr = ""
local mScrollPositionY = 0
local mSelectChannel = false
local mSendChannel = 1
local mReciveChannel = -1
local mCostTip = nil
local mHero = nil
local mNewCount = 0
local mBottom = true

function GetNewCount()
	return math.min(mNewCount, 99)
end

function Hide()
	-- mSendChannel = 1
	mReciveChannel = -1
	mSelectChannel = false
	mSceneManager.SetMouseEvent(mMouseEventState)
end

function Display()
	mNewCount = 0
	OnRefreshChat()
	mMouseEventState = mSceneManager.GetMouseEventState()
	mSceneManager.SetMouseEvent(false)
	mCostTip = mSetManager.GetCostTip()
end

function Init()
	mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	mItemManager = require "LuaScript.Control.Data.ItemManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mAlert = require "LuaScript.View.Alert.Alert"
	mSelectAlert = require "LuaScript.View.Alert.SelectAlert"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	mEventManager.AddEventListen(nil,EventType.OnRefreshChat,OnRefreshChat)
	IsInit = true
end

function SetChannel(channel)
	mSendChannel = channel
end

function OnRefreshChat(_,_,channel)
	if not visible and channel ~= -1 then
		mNewCount = mNewCount + 1
		return
	end
	
	channel = channel or mReciveChannel
	if mReciveChannel ~= -1 and mReciveChannel ~= channel then
		return
	end
	
	local mMsgList = mChatManager.GetMsgList(mReciveChannel)
	mMsgStr = ""
	for k,msg in pairs(mMsgList) do
		local color = ConstValue.ChannelColorStr[msg.channel]
		local str =  mCommonlyFunc.BeginColor(color)
		str = str .. "『" .. ConstValue.ChannelStr[msg.channel] .. "』"
		str = str .. mCommonlyFunc.EndColor()
		str = str .. mCommonlyFunc.BeginColor(Color.RedbeanStr)
		
		if msg.channel == 3 and msg.post >= 2 then
			str = str .. mCommonlyFunc.BeginColor(Color.RedStr)
			str = str .. "[" ..ConstValue.PostName[msg.post] .. "]"
			str = str .. mCommonlyFunc.EndColor()
		end
		if msg.fname then
			str = str .. msg.fname .. "("..msg.fid.."):"
		end
		str = str .. mCommonlyFunc.EndColor()
		str = str .. mCommonlyFunc.BeginColor(Color.BrownStr)
		str = str .. msg.info
		str = str .. mCommonlyFunc.EndColor()
		str = str .. mCommonlyFunc.Linefeed()
		mMsgStr = mMsgStr .. str
	end
	-- mMsgStr = mMsgStr .. mCommonlyFunc.LineHeight(30)
	
	if mBottom then
		mScrollPositionY = 99999
	end
end

function OnGUI()
	if not IsInit then
		return
	end
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/chatBg")
	GUI.DrawTexture(178,56,753,531,image)
	
	local image = mAssetManager.GetAsset("Texture/Gui/Bg/bg4_1")
	GUI.DrawTexture(230,185,650,276,image,0,0,1,1,20,20,20,20)
	
	GUI.Label(353,95,169,50, "聊天记录", GUIStyleLabel.Center_40_Brown_Art) 
	if mSDK.GetChannelName() ~= "185sy" then
		GUI.Label(698,160,169,50, "(QQ群:390261959)", GUIStyleLabel.Left_22_Redbean)
	end
	
	local height = GUI.GetTextHeight(mMsgStr, 610, GUIStyleLabel.Left_20_White_WordWrap)
	_,mScrollPositionY,mBottom = GUI.BeginScrollView(230, 185, 660, 261, 0, mScrollPositionY, 0, 0, 560, height)
		GUI.Label(20,5,610,height, mMsgStr, GUIStyleLabel.Left_20_White_WordWrap)
	GUI.EndScrollView()
	-- GUI.Label(10,5,555,0, mScrollPositionY .. " " ..height, GUIStyleLabel.Left_20_White_WordWrap)
	if mReciveChannel == -1 then
		GUI.Button(290-45,148,84,37, ConstValue.ChannelStr[-1], GUIStyleButton.ChannelSelectBtn_1)
	elseif GUI.Button(290-45,148,84,37, ConstValue.ChannelStr[-1], GUIStyleButton.ChannelSelectBtn_2) then
		mReciveChannel = -1
		mScrollPositionY = 99999
		OnRefreshChat()
	end
	
	if mReciveChannel == 4 then
		GUI.Button(382-45,148,84,37, ConstValue.ChannelStr[4], GUIStyleButton.ChannelSelectBtn_1)
	elseif GUI.Button(382-45,148,84,37, ConstValue.ChannelStr[4], GUIStyleButton.ChannelSelectBtn_2) then
		mReciveChannel = 4
		mScrollPositionY = 99999
		OnRefreshChat()
	end
	
	-- if mReciveChannel == 0 then
		-- GUI.Button(382+92-45,148,84,37, ConstValue.ChannelStr[0], GUIStyleButton.ChannelSelectBtn_1)
	-- elseif GUI.Button(382+92-45,148,84,37, ConstValue.ChannelStr[0], GUIStyleButton.ChannelSelectBtn_2) then
		-- mReciveChannel = 0
		-- mScrollPositionY = 99999
		-- OnRefreshChat()
	-- end
	
	if mReciveChannel == 1 then
		GUI.Button(474-45,148,84,37, ConstValue.ChannelStr[1], GUIStyleButton.ChannelSelectBtn_1)
	elseif GUI.Button(474-45,148,84,37, ConstValue.ChannelStr[1], GUIStyleButton.ChannelSelectBtn_2) then
		mReciveChannel = 1
		mScrollPositionY = 99999
		OnRefreshChat()
	end
	
	if mReciveChannel == 3 then
		GUI.Button(566-45,148,84,37, ConstValue.ChannelStr[3], GUIStyleButton.ChannelSelectBtn_1)
	elseif GUI.Button(566-45,148,84,37, ConstValue.ChannelStr[3], GUIStyleButton.ChannelSelectBtn_2) then
		mReciveChannel = 3
		mScrollPositionY = 99999
		OnRefreshChat()
	end
	
	local image = mAssetManager.GetAsset("Texture/Gui/Button/text_4")
	GUI.DrawTexture(343,483,406,67,image,0,0,1,1,15,23,15,23)
	local newMsgStr = GUI.TextArea(343,477,406,65, mSendMsgStr, GUIStyleTextField.MLeft_Transparent_30)
	
	if string.len(newMsgStr) > ConstValue.MaxMsgLength then
		if CsStringSub then
			newMsgStr = CsStringSub(newMsgStr,0,ConstValue.MaxMsgLength)
		else
			return
		end
	end
	mSendMsgStr = newMsgStr
	
	if GUI.Button(745,484,151,67, "发  送", GUIStyleButton.ShortOrangeArtBtn) then
		if string.len(mSendMsgStr) == 0 then
			return
		end
		
		if string.find(mSendMsgStr, "%$") then
			mSystemTip.ShowTip("消息中不能包含'$'符号")
			return
		end
		if mSendChannel == 1 then
			local count = mItemManager.GetItemCountById(18)
			local cfg_item = CFG_item[18]
			if count <= 0 then
				if mCostTip then
					function okFun(showTip)
						if not mCommonlyFunc.HaveGold(cfg_item.price) then
							return
						end
						mSendMsgStr = mCommonlyFunc.CheckWord(mSendMsgStr)
						mChatManager.SendMsg(mSendChannel, 0, mSendMsgStr)
						mSendMsgStr = ""
						mCostTip = not showTip
					end
					mSelectAlert.Show("该频道需要消耗一个喇叭,是否花费"..cfg_item.price.."元宝购买?", okFun)
					return
				else
					if not mCommonlyFunc.HaveGold(cfg_item.price) then
						return
					end
				end
			end
		end
		mSendMsgStr = mCommonlyFunc.CheckWord(mSendMsgStr)
		mChatManager.SendMsg(mSendChannel, 0, mSendMsgStr)
		mSendMsgStr = ""
	end
	
	if GUI.Button(855,36,82,67, nil, GUIStyleButton.CloseBtn) then
		mPanelManager.Hide(OnGUI)
	end
	
	if mSelectChannel then  -- 选择聊天频道
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/channel_2")
		GUI.DrawTexture(212,339,135,209,image)
		if GUI.Button(212,356,135,43, ConstValue.ChannelStr[3], GUIStyleButton.ChannelBtn_3) then
			mSelectChannel = false
			local family = mFamilyManager.GetFamilyInfo()
			if family then
				mSendChannel = 3
			else
				mSystemTip.ShowTip("加入联盟之后才可使用改频道")
			end
		end
		if GUI.Button(208,402,135,43, ConstValue.ChannelStr[1], GUIStyleButton.ChannelBtn_1) then
			mSelectChannel = false
			mSendChannel = 1
		end
		-- if GUI.Button(208,446,135,43, ConstValue.ChannelStr[0], GUIStyleButton.ChannelBtn_0) then
			-- mSelectChannel = false
			-- mSendChannel = 0
		-- end
		
		if GUI.Button(208,493,135,43, ConstValue.ChannelStr[mSendChannel], GUIStyleButton["ChannelBtn_"..mSendChannel]) then
			mSelectChannel = false
		end
	else
		local image = mAssetManager.GetAsset("Texture/Gui/Bg/channel_1")
		GUI.DrawTexture(212,483,135,65,image)
		if GUI.Button(208,493,135,43, ConstValue.ChannelStr[mSendChannel], GUIStyleButton["ChannelBtn_"..mSendChannel]) then
			-- mSelectChannel = true
			if mSendChannel == 1 then
				mSendChannel = 3
			else
				mSendChannel = 1
			end
		end
	end
	
	mHero = mHeroManager.GetHero()
	if GUI.Button(720,420,150,46, "提示坐标", GUIStyleButton.ShortOrangeArtBtn) then
	   local x =  math.floor(mHero.x)
	   local y =  math.floor(mHero.y)
	   -- print(CFG_map[mHero.map].name) 
	   mSystemTip.ShowTip('您当前所处坐标是'..CFG_map[mHero.map].name..'('.. x ..','.. y ..')')
	   mSendMsgStr = '当前所处坐标是'..CFG_map[mHero.map].name..'('.. x ..','.. y ..')'
	end
	
	-- if GUI.Button(0,585,111, 53, Language[2], GUIStyleButton.ShortOrangeBtn) then
		-- RunLuaScript("load")
	-- end
	-- if GUI.Button(112,585,111, 53, "清缓", GUIStyleButton.ShortOrangeBtn) then
		-- if Directory.Exists(ConstValue.ResPath) then
			-- Directory.Delete(ConstValue.ResPath, true)
		-- end
	-- end
end