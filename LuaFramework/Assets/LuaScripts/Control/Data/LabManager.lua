local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Lab,Packat_Skill,CFG_harbor,CFG_lab = 
print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Sailor,Packat_Lab,Packat_Skill,CFG_harbor,CFG_lab
local PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent = 
PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent
local Language,LogbookType,Color = Language,LogbookType,Color
local mLogbookManager = nil
local mAssetManager = nil
local mEventManager = nil
local mNetManager = nil
local mSystemTip = nil
local mSailorManager = nil
local mShipManager = nil
local mGoodsManager = nil
local mChatManager = nil
module("LuaScript.Control.Data.LabManager")

local mLabList = {}

function GetLabList()
	return mLabList
end

local mTempBuildCd = {}
function GetBuildCd(cd)
	if mTempBuildCd[cd] then
		return mTempBuildCd[cd]
	end
	if mLabList[3] then
		local level = mLabList[3].level
		local cfg_lab = CFG_lab["3_"..level]
		mTempBuildCd[cd] = math.floor(cd*(100-cfg_lab.propertyValue)/100)
		return mTempBuildCd[cd]
	end
	return cd
end

function LabUpSpeed(cd)
	if mLabList[5] then
		local level = mLabList[5].level
		local cfg_lab = CFG_lab["5_"..level]
		return cfg_lab.propertyValue
	end
	return 0
end

function ShipBuildSpeed()
	if mLabList[2] then
		local level = mLabList[2].level
		local cfg_lab = CFG_lab["5_"..level]
		return cfg_lab.propertyValue
	end
	return 0
end


function EquipUpProbability()
	-- local hero = mHeroManager.GetHero()
	if mLabList[14] then
		local level = mLabList[14].level
		local cfg_lab = CFG_lab["14_"..level]
		return cfg_lab.propertyValue
	end
	return 0
end

local mPower = nil
function GetTotalPower()
	if mPower then
		return mPower
	end
	mPower = 0
	for k,v in pairs(mLabList) do
		local cfg_lab = CFG_lab[k.."_"..v.level]
		mPower = mPower + cfg_lab.power
	end
	return mPower
end

function Init()
	mShipManager = require "LuaScript.Control.Data.ShipManager"
	mSailorManager = require "LuaScript.Control.Data.SailorManager"
	mLogbookManager = require "LuaScript.Control.Data.LogbookManager"
	mAssetManager = require "LuaScript.Control.AssetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mGoodsManager = require "LuaScript.Control.Data.GoodsManager"
	mChatManager = require "LuaScript.Control.Data.ChatManager"
	
	mNetManager.AddListen(PackatHead.LAB, Packat_Lab.SEND_ALL_RESEARCH,SEND_ALL_RESEARCH)
	mNetManager.AddListen(PackatHead.LAB, Packat_Lab.SEND_RESEARCH_FINISH, SEND_RESEARCH_FINISH)
	mNetManager.AddListen(PackatHead.LAB, Packat_Lab.SEND_ADD_RESEARCH, SEND_ADD_RESEARCH)
	mNetManager.AddListen(PackatHead.SKILL, Packat_Skill.SEND_ALL_SKILL, SEND_ALL_SKILL)
	mNetManager.AddListen(PackatHead.SKILL, Packat_Skill.SEND_ADD_SKILL, SEND_ADD_SKILL)
	mNetManager.AddListen(PackatHead.LAB, Packat_Lab.SEND_DEL_ALL_HARBOR_RESEARCH, SEND_DEL_ALL_HARBOR_RESEARCH)
end

function SEND_ALL_RESEARCH(cs_ByteArray)
	-- print("SEND_ALL_RESEARCH")
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count,1 do
		local nHarborIndex = ByteArray.ReadInt(cs_ByteArray)
		local dwTime = ByteArray.ReadInt(cs_ByteArray)
		local nResearchIndex = ByteArray.ReadInt(cs_ByteArray)
		local nLevel = ByteArray.ReadInt(cs_ByteArray)
		-- print(nHarborIndex, dwTime, nResearchIndex, nLevel)
		
		mLabList[nResearchIndex] = mLabList[nResearchIndex] or {}
		mLabList[nResearchIndex].harborId = nHarborIndex
		mLabList[nResearchIndex].level = nLevel
		mLabList[nResearchIndex].cd = dwTime
		mLabList[nResearchIndex].updateTime = os.oldClock
	end
	
	mPower = nil
	-- mShipManager.UpdateAllProperty(false)
	-- mSailorManager.UpdateAllProperty(false)
end

function SEND_RESEARCH_FINISH(cs_ByteArray)
	-- print("SEND_RESEARCH_FINISH")
	local nHarborIndex = ByteArray.ReadInt(cs_ByteArray)
	local nResearchIndex = ByteArray.ReadInt(cs_ByteArray)
	local nLevel = ByteArray.ReadInt(cs_ByteArray)
	local harborId = mLabList[nResearchIndex].harborId
	
	mLabList[nResearchIndex].harborId = nil
	mLabList[nResearchIndex].level = nLevel
	mLabList[nResearchIndex].cd = nil
	mLabList[nResearchIndex].updateTime = nil
	-- print(nHarborIndex, nResearchIndex, nLevel)
	local cfg_harbor = CFG_harbor[nHarborIndex]
	local cfg_lab = CFG_lab[nResearchIndex.."_"..nLevel]
	local infoStr = cfg_harbor.name..cfg_lab.name..Language[148]
	mSystemTip.ShowTip(infoStr, Color.LimeStr)
	mChatManager.AddServerMsg(infoStr)
	
	mLogbookManager.AddLog(LogbookType.Lab, os.oldTime, harborId, nResearchIndex, nLevel)
	
	if nResearchIndex == 3 then
		mTempBuildCd = {}
	elseif nResearchIndex == 9 then
		mGoodsManager.CleanGoodsPriceList()
	end
	
	mPower = nil
	mShipManager.UpdateAllProperty(false)
	mSailorManager.UpdateAllProperty(false)
	
	-- print(mLabList)
end

function SEND_ADD_RESEARCH(cs_ByteArray)
	-- print("SEND_ADD_RESEARCH")
	local nHarborIndex = ByteArray.ReadInt(cs_ByteArray)
	local dwTime = ByteArray.ReadInt(cs_ByteArray)
	local nResearchIndex = ByteArray.ReadInt(cs_ByteArray)
	local nLevel = ByteArray.ReadInt(cs_ByteArray)
	
	mLabList[nResearchIndex] = {}
	mLabList[nResearchIndex].harborId = nHarborIndex
	mLabList[nResearchIndex].level = nLevel
	mLabList[nResearchIndex].cd = dwTime
	mLabList[nResearchIndex].updateTime = os.oldClock
	
	if nResearchIndex == 3 then
		mTempBuildCd = {}
	end
end

function SEND_ALL_SKILL(cs_ByteArray)
	-- print("SEND_ALL_SKILL")
	mLabList = {}
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count,1 do
		local nIndex = ByteArray.ReadInt(cs_ByteArray)
		local nlevel = ByteArray.ReadInt(cs_ByteArray)
		mLabList[nIndex] = {}
		mLabList[nIndex].level = nlevel
	end
end

function HarborLabWork(harborId)
	for k,v in pairs(mLabList) do
		if v.harborId == harborId then
			return k
		end
	end
	return false
end

function RequestUpLab(labId)
	-- print("RequestUpLab",labId)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.LAB)
	ByteArray.WriteByte(cs_ByteArray,Packat_Lab.CLIENT_REQUEST_RESEARCH)
	ByteArray.WriteInt(cs_ByteArray,labId)
	mNetManager.SendData(cs_ByteArray)
end

function RequestSpeed(harborId)
	-- print("RequestSpeed",harborId)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.LAB)
	ByteArray.WriteByte(cs_ByteArray,Packat_Lab.CLIENT_REQUEST_RESEARCH_FAST_FINISH)
	ByteArray.WriteInt(cs_ByteArray,harborId)
	mNetManager.SendData(cs_ByteArray)
end

function SEND_ADD_SKILL(cs_ByteArray)
	-- print("SEND_ADD_SKILL")
	local nIndex = ByteArray.ReadInt(cs_ByteArray)
	local nlevel = ByteArray.ReadInt(cs_ByteArray)
	mLabList[nIndex] = mLabList[nIndex] or {}
	mLabList[nIndex].level = nlevel
end

function SEND_DEL_ALL_HARBOR_RESEARCH(cs_ByteArray)
	local harborId = ByteArray.ReadInt(cs_ByteArray)
	for k,v in pairs(mLabList) do
		if v.harborId == harborId then
			v.harborId = nil
			v.cd = nil
			v.updateTime = nil
			break
		end
	end
end

function GetLabProperty()
	local property = {}
	-- local lab = mLabList
	for k,lab in pairs(mLabList) do
		local cfg_lab = CFG_lab[k.."_"..lab.level]
		property[cfg_lab.propertyId] = property[cfg_lab.propertyId] or 0
		property[cfg_lab.propertyId] = property[cfg_lab.propertyId] + cfg_lab.propertyValue
	end
	return property
end