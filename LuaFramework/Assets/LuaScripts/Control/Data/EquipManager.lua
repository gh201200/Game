local _G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,CFG_Equip,require,table,PackatHead,Packat_Equip,ByteArray = 
_G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,CFG_Equip,require,table,PackatHead,Packat_Equip,ByteArray
local CFG_EquipSuit,AppearEvent,EventType,Color,math,CFG_magic = 
CFG_EquipSuit,AppearEvent,EventType,Color,math,CFG_magic
local mNetManager = nil
local mSystemTip = nil
local mHeroTip = nil
local mEventManager = nil
local mSailorManager = nil
local mCommonlyFunc = nil
local mSetManager = nil
local mAddItemTip = nil
local mAlert = nil
local mPanelManager = nil
local mMainPanel = nil
local mSettingPanel = nil

module("LuaScript.Control.Data.EquipManager")
local mMagicing = false

local mEquips = {}
local mEquipsBySailor = {}
local mEquipsByType = {{},{},{},{},{},{}}
local mDestroyQuality = {}

function GetEquips()
	return mEquips
end

function GetEquipsBySid(sid)
	return mEquipsBySailor[sid]
end

function GetBetterEquip(sid, pos)
	local quality = -1
	if mEquipsBySailor[sid] and mEquipsBySailor[sid][pos] then
		local cfg_equip = CFG_Equip[mEquipsBySailor[sid][pos].id]
		quality = cfg_equip.quality
	end
	local equipList = GetEquipsByType(pos,false)
	if not equipList[1] then
		return
	end
	
	table.sort(equipList, SortFunc)
	
	local cfg_equip = CFG_Equip[equipList[1].id]
	if cfg_equip.quality > quality then
		return equipList[1]
	end
end

function GetEquipByIndex(index)
	for k,v in pairs(mEquips) do
		if v.index == index then
			return v
		end
	end
end

function GetEquipByQuality(quality, duty)
	if duty ~= nil then
		local list = {}
		for k,v in pairs(mEquips) do
			local cfg_Equip = CFG_Equip[v.id]
			if duty and v.sid ~= 0 and cfg_Equip.quality == quality then
				table.insert(list, v)
			elseif not duty and v.sid == 0 and cfg_Equip.quality == quality then
				table.insert(list, v)
			end
		end
		return list
	else
		local list = {}
		for k,v in pairs(mEquips) do
			local cfg_Equip = CFG_Equip[v.id]
			if cfg_Equip.quality == quality then
				table.insert(list, v)
			end
		end
		return list
	end
end

function SailorWearEquip(sid, equipId)
	local cfg_Equip = CFG_Equip[equipId]
	local type = cfg_Equip.type
	if mEquipsBySailor[sid] and mEquipsBySailor[sid][type]then
		if equipId == mEquipsBySailor[sid][type].id then
			return true
		end
	end
end

function GetEquipsByType(type, duty)
	if duty ~= nil then
		local equipList = {}
		for k,equip in pairs(mEquipsByType[type]) do
			if duty and equip.sid ~= 0 then
				table.insert(equipList, equip)
			elseif not duty and equip.sid == 0 then
				table.insert(equipList, equip)
			end
		end
		return equipList
	else
		if type == 0 then
			return mEquips
		end
		return mEquipsByType[type]
	end
end

-- function SailorInShipTeam(id, value)
	-- local equips = GetEquipsBySid(id)
	-- if equips then
		-- for k,equip in pairs(equips) do
			-- equip.inShipTeam = value
		-- end
	-- end
-- end

function GetSuitActiveByEquip(sailor, equip, index)
	if not sailor then
		return false
	end
	local cfg_Equip = CFG_Equip[equip.id]
	local suitId = cfg_Equip.suitId
	local cfg_EquipSuit = CFG_EquipSuit[suitId.."_"..index]
	if not cfg_EquipSuit then
		return false
	end
	
	local equips = GetEquipsBySid(sailor.id)
	local count = 0
	for k,v in pairs(equips) do
		local cfg_Equip = CFG_Equip[v.id]
		if cfg_Equip.suitId == suitId then
			count = count + 1
		end
	end
	return cfg_EquipSuit.equipCount <= count
end

function DestroyAllEquip()
	mDestroyQuality = {}
	mDestroyQuality[0] = mSetManager.GetDestroyEquip0()
	mDestroyQuality[1] = mSetManager.GetDestroyEquip1()
	mDestroyQuality[2] = mSetManager.GetDestroyEquip2()
	mDestroyQuality[3] = mSetManager.GetDestroyEquip3()
	mDestroyQuality[4] = mSetManager.GetDestroyEquip4()
	
	for k,equip in pairs(mEquips) do
		local cfg_Equip = CFG_Equip[equip.id]
		if (equip.sid == 0 and equip.star == 0) and mDestroyQuality[cfg_Equip.quality] then
			RequestDestroyEquip(equip.index)
		end
	end
end

function GetSuitCountByEquip(sailor, equip)
	if not sailor then
		return 0
	end

	local cfg_Equip = CFG_Equip[equip.id]
	local suitId = cfg_Equip.suitId
	if suitId == 0 then
		return 0
	end
	
	local equips = GetEquipsBySid(sailor.id)
	local count = 0
	for k,v in pairs(equips) do
		local cfg_Equip = CFG_Equip[v.id]
		if cfg_Equip.suitId == suitId then
			count = count + 1
		end
	end
	return count, cfg_Equip.suitId
end

local mPower = nil
function GetTotalPower()
	if mPower then
		return mPower
	end
	mPower = 0
	for k, equip in pairs(mEquips) do
		if equip.sid ~= 0 then
			mPower = mPower + mCommonlyFunc.GetEquipPower(equip)
		end
	end
	return mPower
end

function GetPowerBySailor(sailor)
	local equips = GetEquipsBySid(sailor.id)
	if not equips then
		return 0
	end
	local power = 0
	for k, equip in pairs(equips) do
		power = power + mCommonlyFunc.GetEquipPower(equip)
	end
	return power
end

function GetSuitPowerBySailor(sailor)
	local equips = GetEquipsBySid(sailor.id)
	if not equips then
		return 0
	end
	local suitList = {}
	for k,equip in pairs(equips) do
		local cfg_Equip = CFG_Equip[equip.id]
		if not suitList[cfg_Equip.suitId] then
			local value,suitId = GetSuitCountByEquip(sailor, equip)
			suitList[suitId] = value
		end
	end
	-- print(suitList)
	local power = 0
	for suitId,value in pairs(suitList) do
		for k=1,3,1 do
			local key = suitId.."_"..k
			local cfg_EquipSuit = CFG_EquipSuit[key]
			if cfg_EquipSuit and cfg_EquipSuit.equipCount <= value then
				power = power + cfg_EquipSuit.power
			end
			-- print(cfg_EquipSuit)
			-- print(key)
		end
	end
	-- print(power)
	return power
end

function Init()
	mSailorManager = require "LuaScript.Control.Data.SailorManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mHeroTip = require "LuaScript.View.Tip.HeroTip"
	mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
	mSetManager = require "LuaScript.Control.System.SetManager"
	mAddItemTip = require "LuaScript.View.Tip.AddItemTip"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
	mSettingPanel = require "LuaScript.View.Panel.SettingPanel"
	mAlert = require "LuaScript.View.Alert.Alert"

	mNetManager.AddListen(PackatHead.EQUIP, Packat_Equip.SEND_ALL_EQUIP, SEND_ALL_EQUIP)
	mNetManager.AddListen(PackatHead.EQUIP, Packat_Equip.SEND_ADD_EQUIP, SEND_ADD_EQUIP)
	mNetManager.AddListen(PackatHead.EQUIP, Packat_Equip.SEND_DEL_EQUIP, SEND_DEL_EQUIP)
	mNetManager.AddListen(PackatHead.EQUIP, Packat_Equip.SEND_EQUIP_SAILOR_CHANGE, SEND_EQUIP_SAILOR_CHANGE)
	mNetManager.AddListen(PackatHead.EQUIP, Packat_Equip.SEND_STAR_UP_RLT, SEND_STAR_UP_RLT)
	mNetManager.AddListen(PackatHead.EQUIP, Packat_Equip.SEND_MAGIC_RLT, SEND_MAGIC_RLT)
	
	mEventManager.AddEventListen(nil, EventType.ConnectFailure, ConnectFailure)
	mEventManager.AddEventListen(nil, EventType.IntoHarbor, IntoHarbor)
	
end

function IntoHarbor()
	if mEquips and #mEquips > 150 then
		function okFunc()
			mSettingPanel.mScrollPositionY = 7 * 96
			mPanelManager.Hide(mMainPanel)
			mPanelManager.Show(mSettingPanel)
		end
		mAlert.Show("您当前装备过多,请及时分解无用装备,可在设置界面开启自动分解装备!",okFunc,nil,"设置")
	end
end

function ConnectFailure()
	mMagicing = false
	mPower = nil
end

function EquipMove(sourceId, destId)
	if not sourceId or not destId then
		return
	end	
	mEquipsBySailor[destId] = mEquipsBySailor[sourceId]
	mEquipsBySailor[sourceId] = nil
	
	if mEquipsBySailor[destId] then
		for k,equipe in pairs(mEquipsBySailor[destId]) do
			equipe.sid = destId
		end
	end
end

function SEND_ALL_EQUIP(cs_ByteArray)
	mEquips = {}
	mEquipsBySailor = {}
	mEquipsByType = {{},{},{},{},{},{}}
	
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count,1 do
		local equip = {}
		equip.index = ByteArray.ReadInt(cs_ByteArray)
		equip.id = ByteArray.ReadInt(cs_ByteArray)
		equip.sid = ByteArray.ReadInt(cs_ByteArray)
		equip.star = ByteArray.ReadInt(cs_ByteArray)
		equip.magic = ByteArray.ReadInt(cs_ByteArray)
		equip.power = mCommonlyFunc.GetEquipPower(equip)
		-- print(equip.sid)
		local cfg_equip = CFG_Equip[equip.id]
		local type = cfg_equip.type
		mEquipsBySailor[equip.sid] = mEquipsBySailor[equip.sid] or {}
		mEquipsBySailor[equip.sid][type] = equip
		
		-- print(equip.id, type)
		table.insert(mEquipsByType[type], equip)
		table.insert(mEquips, equip)
	end
	
	-- table.sort(mEquipsByType[1], SortFunc)
	-- table.sort(mEquipsByType[2], SortFunc)
	-- table.sort(mEquipsByType[3], SortFunc)
	-- table.sort(mEquipsByType[4], SortFunc)
	-- table.sort(mEquipsByType[5], SortFunc)
	-- table.sort(mEquipsByType[6], SortFunc)
	table.sort(mEquips, SortFunc)
	
	DestroyAllEquip()
end


function SortFunc(a, b)
	local cfg_a = CFG_Equip[a.id]
	local cfg_b = CFG_Equip[b.id]
	if not a.inShipTeam and b.inShipTeam then
		return true
	elseif a.inShipTeam and not b.inShipTeam then
		return false
	end
	if cfg_a.quality > cfg_b.quality then
		return true
	elseif cfg_a.quality < cfg_b.quality then
		return false
	end
	if cfg_a.type < cfg_b.type then
		return true
	elseif cfg_a.type > cfg_b.type then
		return false
	end
	if a.power > b.power then
		return true
	elseif a.power < b.power then
		return false
	end
	if a.id > b.id then
		return true
	elseif a.id < b.id then
		return false
	end
	return false
end

function SEND_ADD_EQUIP(cs_ByteArray)
	-- print("SEND_ADD_EQUIP")
	local equip = {}
	equip.index = ByteArray.ReadInt(cs_ByteArray)
	equip.id = ByteArray.ReadInt(cs_ByteArray)
	equip.sid = 0
	equip.star = 0
	equip.power = mCommonlyFunc.GetEquipPower(equip)
	-- print(equip.index)
	local cfg_equip = CFG_Equip[equip.id]
	local type = cfg_equip.type
	mEquipsBySailor[equip.sid] = mEquips[equip.sid] or {}
	mEquipsBySailor[equip.sid][type] = equip
	
	table.insert(mEquipsByType[type], equip)
	table.insert(mEquips, equip)
	-- table.sort(mEquipsByType[type], SortFunc)
	table.sort(mEquips, SortFunc)
	mAddItemTip.ShowTip(1, equip.id)
	
	local cfg_Equip = CFG_Equip[equip.id]
	if mDestroyQuality[cfg_Equip.quality] then
		RequestDestroyEquip(equip.index)
	end
end

function SEND_DEL_EQUIP(cs_ByteArray)
	-- print("SEND_DEL_EQUIP")
	local index = ByteArray.ReadInt(cs_ByteArray)
	local equip = nil
	for k,v in pairs(mEquips) do
		if v.index == index then
			equip = v
			table.remove(mEquips, k)
			break
		end
	end
	
	local cfg_equip = CFG_Equip[equip.id]
	local type = cfg_equip.type
	if equip.sid ~= 0 then
		mEquipsBySailor[equip.sid][type] = nil
	end
	
	for k,v in pairs(mEquipsByType[type]) do
		if v.index == index then
			table.remove(mEquipsByType[type], k)
			break
		end
	end
	
	-- mEquips[index] = nil
	mPower = nil
	
	local sailor = mSailorManager.GetSailorById(equip.sid)
	if sailor then
		mSailorManager.UpdateProperty(sailor, true)
	end
	
	AppearEvent(nil, EventType.RefreshEquip)
end

function SEND_EQUIP_SAILOR_CHANGE(cs_ByteArray)
	-- print("SEND_EQUIP_SAILOR_CHANGE")
	local index = ByteArray.ReadInt(cs_ByteArray)
	local sid = ByteArray.ReadInt(cs_ByteArray)
	local equip = nil
	
	for k,v in pairs(mEquips) do
		if v.index == index then
			equip = v
			break
		end
	end
	
	local cfg_equip = CFG_Equip[equip.id]
	if mEquipsBySailor[equip.sid] then
		mEquipsBySailor[equip.sid][cfg_equip.type] = nil
	end
	
	local sailor = mSailorManager.GetSailorById(equip.sid)
	equip.sid = sid
	if sailor then
		mSailorManager.UpdateProperty(sailor)
	end
	
	if mEquipsBySailor[sid] then
		local oldEquip = mEquipsBySailor[sid][cfg_equip.type]
		if oldEquip then
			oldEquip.sid = 0
			
			local cfg_oldEquip = CFG_Equip[oldEquip.id]
			if oldEquip.star == 0 and mDestroyQuality[cfg_oldEquip.quality] then
				RequestDestroyEquip(oldEquip.index)
			end
		end
	end
	
	mEquipsBySailor[sid] = mEquipsBySailor[sid] or {}
	mEquipsBySailor[sid][cfg_equip.type] = equip
	
	local sailor = mSailorManager.GetSailorById(sid)
	if sailor then
		mSailorManager.UpdateProperty(sailor)
	end
	
	mPower = nil
	AppearEvent(nil, EventType.UpdateHeroPower)
	AppearEvent(nil, EventType.EquipSailorChange)
end

function SEND_STAR_UP_RLT(cs_ByteArray)
	-- mUping = false
	-- print("SEND_STAR_UP_RLT")
	mPower = nil
	
	local index = ByteArray.ReadInt(cs_ByteArray)
	local suc = ByteArray.ReadBool(cs_ByteArray)
	if suc then
		local equip = nil
		for k,v in pairs(mEquips) do
			if v.index == index then
				equip = v
				break
			end
		end
		equip.star = equip.star + 1
		equip.power = mCommonlyFunc.GetEquipPower(equip)
		mSystemTip.ShowTip("强化成功", Color.LimeStr)
		AppearEvent(nil, EventType.RefreshEquipUp)
		
		local cfg_equip = CFG_Equip[equip.id]
		-- table.sort(mEquipsByType[cfg_equip.type], SortFunc)
		table.sort(mEquips, SortFunc)
		
		
		local sailor = mSailorManager.GetSailorById(equip.sid)
		if sailor then
			mSailorManager.UpdateProperty(sailor, true)
		end
	else
		mSystemTip.ShowTip("强化失败", Color.LimeStr)
	end
end

function SEND_MAGIC_RLT(cs_ByteArray)
	mMagicing = false
	-- print("SEND_MAGIC_RLT")
	mPower = nil
	
	local index = ByteArray.ReadInt(cs_ByteArray)
	local magic = ByteArray.ReadInt(cs_ByteArray)

	local equip = nil
	for k,v in pairs(mEquips) do
		if v.index == index then
			equip = v
			break
		end
	end
	equip.magic = magic
	equip.power = mCommonlyFunc.GetEquipPower(equip)
	AppearEvent(nil, EventType.RefreshEquipUp)
		
	table.sort(mEquips, SortFunc)
		
	local sailor = mSailorManager.GetSailorById(equip.sid)
	if sailor then
		mSailorManager.UpdateProperty(sailor, true)
	end
end

function RequestWearEquip(index, sid)
	-- print("RequestWearEquip"..index.." "..sid)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.EQUIP)
	ByteArray.WriteByte(cs_ByteArray,Packat_Equip.CLIENT_PUT_ON_EQUIP)
	ByteArray.WriteInt(cs_ByteArray,index)
	ByteArray.WriteInt(cs_ByteArray,sid)
	mNetManager.SendData(cs_ByteArray)
end

function RequestUp(sid, gid, count, star)
	-- mUping = true
	-- print("RequestUp")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.EQUIP)
	ByteArray.WriteByte(cs_ByteArray,Packat_Equip.CLIENT_REQUEST_STAR_UP)
	ByteArray.WriteInt(cs_ByteArray,sid)
	ByteArray.WriteInt(cs_ByteArray,gid)
	ByteArray.WriteInt(cs_ByteArray,count)
	ByteArray.WriteInt(cs_ByteArray,star)
	mNetManager.SendData(cs_ByteArray)
end

function RequestMagic(sid)	
	if mMagicing then
		return
	end
	mMagicing = true
	-- print("RequestMagic")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.EQUIP)
	ByteArray.WriteByte(cs_ByteArray,Packat_Equip.CLIENT_REQUEST_MAGIC_ITEM)
	ByteArray.WriteInt(cs_ByteArray,sid)
	mNetManager.SendData(cs_ByteArray)
end

function RequestDestroyEquip(index)
	-- print("RequestDestroyEquip"..index)
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.EQUIP)
	ByteArray.WriteByte(cs_ByteArray,Packat_Equip.CLIENT_REQUEST_SPLIT)
	ByteArray.WriteInt(cs_ByteArray,index)
	mNetManager.SendData(cs_ByteArray)
end

function GetEquipProperty(sailor)
	local equips = GetEquipsBySid(sailor.id)
	if not equips then
		return
	end
	local property = {}
	for k,equip in pairs(equips) do
		local value,type = mCommonlyFunc.GetEquipProperty(equip)
		property[type] = property[type] or 0
		property[type] = property[type] + value
		
		if equip.magic and equip.magic ~= 0 then
			local cfg_magic = CFG_magic[equip.magic]
			property[cfg_magic.type] = property[cfg_magic.type] or 0
			property[cfg_magic.type] = property[cfg_magic.type] + cfg_magic.value
		end
	end
	
	return property
end

function GetSuitProperty(sailor, property)
	local equips = GetEquipsBySid(sailor.id)
	if not equips then
		return
	end
	local suitList = {}
	for k,equip in pairs(equips) do
		local cfg_Equip = CFG_Equip[equip.id]
		if not suitList[cfg_Equip.suitId] then
			local value,suitId = GetSuitCountByEquip(sailor, equip)
			suitList[suitId] = value
		end
	end
	for suitId,value in pairs(suitList) do
		for k=1,math.floor(value/2),1 do
			local key = suitId.."_"..k
			local cfg_EquipSuit = CFG_EquipSuit[key]
			if cfg_EquipSuit then
				property[cfg_EquipSuit.propertyId] = property[cfg_EquipSuit.propertyId] or 0
				property[cfg_EquipSuit.propertyId] = property[cfg_EquipSuit.propertyId] + cfg_EquipSuit.propertyValue
			end
		end
	end
	return property
end