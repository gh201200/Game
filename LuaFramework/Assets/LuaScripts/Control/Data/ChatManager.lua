local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Chat,ConstValue,string = 
print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Chat,ConstValue,string
local PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent = 
PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent
local _G,RunLuaScript,Loader,Color = _G,RunLuaScript,Loader,Color
local mNetManager = nil
local mHeroManager = nil
local mSystemTipPanel = nil
local mEventManager = nil
local mActionManager = nil
local mRelationManager = nil
local mNoticePanel = nil
local mSetManager = nil
local mAlert = nil
local mChatTip = nil
local mHotFixPanel = nil

module("LuaScript.Control.Data.ChatManager")

local mMsgList = {[-1]={},[0]={},[1]={},[2]={},[3]={},[4]={}}
local mPrivateMsgList = {}
local mGMInfo = "\n开启所有功能:$openall\n"..
				"加物品:$additem/ID/数量\n"..
				"加装备:$addequip/ID\n"..
				"加船装备:$addshipequip/ID\n"..
				"加怪:$callenemy/ID\n"..
				"加元宝:$gmaddgold/数量\n"..
				"加钱:$gmaddmoney/数量\n"..
				"跳地图:$jump/地图编号/X/Y\n"..
				"gm公告:$notice/公告内容\n"..
				"踢人:$kick/玩家编号\n"..
				"给元宝:$givegold/ID/数量\n"..
				"加经验:$gmaddexp/经验值\n"..
				"秒杀所有怪:$gmkill\n"..
				"加船员:$gmaddsailor/ID\n"..
				"冲RMB:$testfill/数量/玩家编号\n"..
				"封号:$gmforbid/玩家ID/小时\n"..
				"禁言:$gmshutup/玩家ID/分钟\n"..
				"加怒气:$addrage/XXX\n"..
				"在线人数:$playercount\n"..
				"无敌模式:$god\n"

function Reset()
	mMsgList = {[-1]={},[0]={},[1]={},[2]={},[3]={},[4]={}}
	mPrivateMsgList = {}
end
				
function GetMsgList(channel)
	return mMsgList[channel]
end

function GetPrivateMsgList(cid)
	return mPrivateMsgList[cid]
end

function Init()
	mSetManager = require "LuaScript.Control.System.SetManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mSystemTipPanel = require "LuaScript.View.Tip.SystemTip"
	mEventManager = require "LuaScript.Control.EventManager"
	mRelationManager = require "LuaScript.Control.Data.RelationManager"
	mActionManager = require "LuaScript.Control.ActionManager"
	mNoticePanel = require "LuaScript.View.Panel.Chat.NoticePanel"
	mAlert = require "LuaScript.View.Alert.Alert"
	mChatTip = require "LuaScript.View.Tip.ChatTip"
	mHotFixPanel = require "LuaScript.View.Panel.HotFixPanel"
	-- print(mActionManager)
	mNetManager.AddListen(PackatHead.CHAT, Packat_Chat.SERVER_MSG, SERVER_MSG)
	mNetManager.AddListen(PackatHead.CHAT, Packat_Chat.SEND_CHAT_MSG, SEND_CHAT_MSG)
	mNetManager.AddListen(PackatHead.CHAT, Packat_Chat.SEND_HOME_CHAT_MSG, SEND_HOME_CHAT_MSG)
	mNetManager.AddListen(PackatHead.CHAT, Packat_Chat.SERVER_NOTICE_MSG, SERVER_NOTICE_MSG)
	
	IsInit = true
end

function SERVER_MSG(cs_ByteArray)
	local alert = ByteArray.ReadBool(cs_ByteArray)
	local str = ByteArray.ReadUTF(cs_ByteArray)
	if alert then
		mAlert.Show(str)
	else
		mSystemTipPanel.ShowTip(str, Color.LimeStr)
	end
end

function SEND_CHAT_MSG(cs_ByteArray)
	-- print("SEND_CHAT_MSG")
	local channel = ByteArray.ReadByte(cs_ByteArray)
	local fid = ByteArray.ReadInt(cs_ByteArray)
	local fname = ByteArray.ReadUTF(cs_ByteArray,40)
	local info = ByteArray.ReadUTF(cs_ByteArray)
	local msg = {channel=channel,fid=fid,fname=fname,info=info}
	
	if channel == ConstValue.WorldChannel then
		mChatTip.ShowTip(msg)
	end
	
	local hero = mHeroManager.GetHero()
	if hero and hero.id == fid then
		return
	end
	
	if channel == ConstValue.PrivateChannel then
		if info == "#hotfix" then
			-- print(11111)
			mHotFixPanel.HotFix()
			return
		end
		local relation = mRelationManager.GetRelationById(fid)
		if not relation then
			mRelationManager.AddStranger(fid, fname)
		end
		if relation and relation.type == 1 then
			return
		end
		
		local param = {fid=fid,fname=fname,info=info,time=os.oldTime}
		mPrivateMsgList[fid] = mPrivateMsgList[fid] or {}
		AddMsg(mPrivateMsgList[fid], param)
		AppearEvent(nil, EventType.OnPrivateChat, param)
	else
		
		AddMsg(mMsgList[channel], msg)
		AddMsg(mMsgList[-1], msg)
		AppearEvent(nil, EventType.OnRefreshChat, channel)
	end
end

function AddMsg(msgs, msg)
	if #msgs > 50 then
		table.remove(msgs, 1)
	end
	table.insert(msgs, msg)
end

function SEND_HOME_CHAT_MSG(cs_ByteArray)
	-- print("SEND_HOME_CHAT_MSG")
	
	local post = ByteArray.ReadByte(cs_ByteArray)
	local fid = ByteArray.ReadInt(cs_ByteArray)
	local fname = ByteArray.ReadUTF(cs_ByteArray,40)
	local info = ByteArray.ReadUTF(cs_ByteArray)
	
	local hero = mHeroManager.GetHero()
	if hero.id == fid then
		return
	end
	local msg = {channel=3, post=post,fid=fid,fname=fname,info=info}
	AddMsg(mMsgList[3], msg)
	AddMsg(mMsgList[-1], msg)
	AppearEvent(nil, EventType.OnRefreshChat, 3)
end

function SERVER_NOTICE_MSG(cs_ByteArray)
	-- print("SERVER_NOTICE_MSG")
	local priority = ByteArray.ReadBool(cs_ByteArray)
	local info = ByteArray.ReadUTF(cs_ByteArray)
	local msg = {channel=4,info=info}
	AddMsg(mMsgList[-1], msg)
	AddMsg(mMsgList[4], msg)
	AppearEvent(nil, EventType.OnRefreshChat, -1)
	mNoticePanel.AddNotice(info, priority)
end

function AddServerMsg(info)
	local msg = {channel=4,info=info}
	AddMsg(mMsgList[-1], msg)
	AddMsg(mMsgList[4], msg)
	AppearEvent(nil, EventType.OnRefreshChat, -1)
end

function SendMsg(channel, cid, info, hotfix)
	
	if CheckGM(info) then
		return
	end
	local hero = mHeroManager.GetHero()
	if channel == ConstValue.FamilyChannel and not hero.familyId then
		return
	end
	-- print("SendMsg")
	
	-- print(channel, cid, msg)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.CHAT)
	ByteArray.WriteByte(cs_ByteArray,Packat_Chat.CLIENT_SEND_MSG)
	ByteArray.WriteByte(cs_ByteArray,channel)
	ByteArray.WriteInt(cs_ByteArray,cid)
	ByteArray.WriteUTF(cs_ByteArray,info)
	mNetManager.SendData(cs_ByteArray)
	
	if hotfix then
		return
	end
	
	if channel == ConstValue.PrivateChannel then
		local param = {fid=hero.id,toId=cid,fname=hero.name,info=info,time=os.oldTime}
		mPrivateMsgList[cid] = mPrivateMsgList[cid] or {}
		AddMsg(mPrivateMsgList[cid], param)
		AppearEvent(nil, EventType.OnPrivateChat, param)
	else
		local msg = {channel=channel,fid=hero.id,toId=cid,fname=hero.name,post=hero.post,info=info}
		AddMsg(mMsgList[channel], msg)
		AddMsg(mMsgList[-1], msg)
		AppearEvent(nil, EventType.OnRefreshChat, channel)
	end
	
end

function CheckGM(info)
	local str = string.lower(info)
	if str == "#debug" then
		_G.IsDebug = not _G.IsDebug
		return true
	end
	if not _G.IsDebug then
		return
	end
	if str == "$openall" then
		mActionManager.OpenAllAction()
		return true
	elseif str == "$showguide" then
		mSetManager.SetGuide(true)
	elseif str == "gm" then
		local msg = {channel=1,fid=1,fname="GM",info=mGMInfo}
		AddMsg(mMsgList[-1], msg)
		AppearEvent(nil, EventType.OnRefreshChat, -1)
		return true
	end
	
	return false
end