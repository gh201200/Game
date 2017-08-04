local print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Relation,Packat_Goods,Language,ConstValue = 
print,Instantiate,EventType,Space,math,os,Vector3,ByteArray,Packat_Relation,Packat_Goods,Language,ConstValue
local PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent = 
PackatHead,Packat_Player,BoxCollider,SceneType,table,require,pairs,tostring,tonumber,Packat_Harbor,AppearEvent
local CFG_role,Color,UploadError = CFG_role,Color,UploadError
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local mAssetManager = nil
local mEventManager = nil
local mNetManager = nil
local mSystemTip = nil
local mAlert = nil
local mFamilyManager = nil
local mHeroManager = nil
local mFriendPanel = nil
local mEnemyInfoViewPanel = nil
local mPanelManager = nil
local mCharManager = nil

module("LuaScript.Control.Data.RelationManager")

local mRelations = {}
local mRelationsById = nil
local mApplyList = {}
local mLastUpdateTime = -10000

function GetFrinds()
	return mRelations[0]
end

function GetEnemys()
	return mRelations[1]
end

function IsEnemy(id)
	if mRelationsById[id] and mRelationsById[id].type == 1 then
		return true
	end
end

function GetStrangers()
	return mRelations[2]
end

function AddStranger(id, name)
	local relation =  {id=id, name=name, onLine=true, type=2}
	table.insert(mRelations[2], 1, relation)
	mRelationsById[id] = relation
	
	RequestStrangerInfo()
end

function GetRelationById(id)
	return mRelationsById[id]
end

function GetRelationStr(char)
	local hero = mHeroManager.GetHero()
	local relation = GetRelationById(char.id)
	if relation then
		if relation.type == 0 then
			return Language[133]
		elseif relation.type == 1 then
			return Language[135]
		end
	end
	if hero.familyId and char.familyId == hero.familyId then
		return Language[134]
	end
	return Language[161]
end

function GetRelation(char)
	local relation = GetRelationById(char.id)
	if relation then
		if relation.type == 0 then
			return 3
		elseif relation.type == 1 then
			return 4
		end
	end
	local hero = mHeroManager.GetHero()
	if hero.familyId and char.familyId == hero.familyId then
		return 2
	end
	return 1
end


function Init()
	mAssetManager = require "LuaScript.Control.AssetManager"
	mEventManager = require "LuaScript.Control.EventManager"
	mNetManager = require "LuaScript.Control.System.NetManager"
	mSystemTip = require "LuaScript.View.Tip.SystemTip"
	mAlert = require "LuaScript.View.Alert.Alert"
	mFamilyManager = require "LuaScript.Control.Data.FamilyManager"
	mHeroManager = require "LuaScript.Control.Scene.HeroManager"
	mFriendPanel = require "LuaScript.View.Panel.Friend.FriendPanel"
	mEnemyInfoViewPanel = require "LuaScript.View.Panel.Friend.EnemyInfoViewPanel"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mCharManager = require "LuaScript.Control.Scene.CharManager"
	
	mNetManager.AddListen(PackatHead.RELATION, Packat_Relation.SEND_ALL_RELATION, SEND_ALL_RELATION)
	mNetManager.AddListen(PackatHead.RELATION, Packat_Relation.SEND_ADD_RELATION, SEND_ADD_RELATION)
	mNetManager.AddListen(PackatHead.RELATION, Packat_Relation.SEND_ASK_FOR_FRIEND, SEND_ASK_FOR_FRIEND)
	mNetManager.AddListen(PackatHead.RELATION, Packat_Relation.REQUEST_ADD_FRIEND_EXIST, REQUEST_ADD_FRIEND_EXIST)
	mNetManager.AddListen(PackatHead.RELATION, Packat_Relation.SEND_ONLINE_FRIENDS_DETAIL, SEND_ONLINE_FRIENDS_DETAIL)
	mNetManager.AddListen(PackatHead.RELATION, Packat_Relation.SEND_DEL_FRIEND, SEND_DEL_FRIEND)
	mNetManager.AddListen(PackatHead.PLAYER, Packat_Player.SEND_OTHER_PLAYER_INFO, SEND_OTHER_PLAYER_INFO)
	mNetManager.AddListen(PackatHead.RELATION, Packat_Relation.SEND_ENEMY_LOCATION, SEND_ENEMY_LOCATION)
end

function SEND_ALL_RELATION(cs_ByteArray)
	-- print("SEND_ALL_RELATION")
	local count = ByteArray.ReadInt(cs_ByteArray)
	mRelations[0] = {}
	mRelations[1] = {}
	mRelations[2] = {}
	mRelationsById = {}
	
	-- for k,v in pairs(mRelations[2]) do
		-- mRelationsById[v.id] = v
	-- end
	-- print(mRelationsById)
	
	for i=1,count,1 do
		local relation = {}
		relation.id = ByteArray.ReadInt(cs_ByteArray)
		relation.name = ByteArray.ReadUTF(cs_ByteArray,40)
		relation.type = ByteArray.ReadByte(cs_ByteArray)
		relation.role = ByteArray.ReadByte(cs_ByteArray)
		
		local cfg_role = CFG_role[relation.role]
		relation.quality = cfg_role.quality
		relation.resId = cfg_role.resId
		table.insert(mRelations[relation.type], relation)
		mRelationsById[relation.id] = relation
	end
end

function SortFunc(a, b)
	if a.onLine and not b.onLine then
		return true
	elseif a.onLine == b.onLine and not (not a.level and not b.level) 
		and ((a.level and not b.level) or (a.level > b.level)) then
		return true
	end
	return false
end

function SEND_ADD_RELATION(cs_ByteArray)
	-- print("SEND_ADD_RELATION")
	local id = ByteArray.ReadInt(cs_ByteArray)
	local relation = mRelationsById[id]
	if relation then
		DelRelation(id, relation.type)
	end
	-- print(id)
	local relation = {}
	relation.id = id
	relation.name = ByteArray.ReadUTF(cs_ByteArray,40)
	relation.type = ByteArray.ReadByte(cs_ByteArray)
	relation.role = ByteArray.ReadByte(cs_ByteArray)
	local cfg_role = CFG_role[relation.role]
	relation.quality = cfg_role.quality
	relation.resId = cfg_role.resId
	
	table.insert(mRelations[relation.type], relation)
	mRelationsById[relation.id] = relation
	
	if relation.type == 0 then
		mLastUpdateTime = -10000
		RequestFriendInfo()
		local info = "已和" .. mCommonlyFunc.BeginColor(Color.CyanStr)
		info = info .. relation.name
		info = info .. mCommonlyFunc.EndColor()
		info = info .. "成为好友!"
		mSystemTip.ShowTip(info, Color.WhiteStr)
	elseif relation.type == 1 then
		local info = "已将" .. mCommonlyFunc.BeginColor(Color.CyanStr)
		info = info .. relation.name
		info = info .. mCommonlyFunc.EndColor()
		info = info .. "加入仇敌!"
		mSystemTip.ShowTip(info, Color.WhiteStr)
	end
	-- table.sort(mRelations[relation.type], SortFunc)
end

function SEND_ASK_FOR_FRIEND(cs_ByteArray)
	local name = ByteArray.ReadUTF(cs_ByteArray,40)
	local id = ByteArray.ReadInt(cs_ByteArray)
	mFriendPanel.AddEvent(0,id,name)
end

function REQUEST_ADD_FRIEND_EXIST(cs_ByteArray)
	-- print("REQUEST_ADD_FRIEND_EXIST")
	local exist = ByteArray.ReadBool(cs_ByteArray)
	if exist then
		mSystemTip.ShowTip("已向该玩家发起请求", Color.LimeStr)
	else
		mSystemTip.ShowTip("该玩家不存在或不在线")
	end
end

function SEND_ONLINE_FRIENDS_DETAIL(cs_ByteArray)
	-- print("SEND_ONLINE_FRIENDS_DETAIL")
	for k,relation in pairs(mRelationsById) do
		if relation.type ~= 2 then
			relation.level = nil
			relation.power = nil
			relation.onLine = nil
		end
	end
	
	local count = ByteArray.ReadInt(cs_ByteArray)
	for i=1,count,1 do
		local id = ByteArray.ReadInt(cs_ByteArray)
		local level = ByteArray.ReadInt(cs_ByteArray)
		local power = ByteArray.ReadInt(cs_ByteArray)
		local role = ByteArray.ReadByte(cs_ByteArray)
		local relation = mRelationsById[id]
		if relation then
			relation.level = level
			relation.power = power
			relation.onLine = true
			relation.role = role
		
			local cfg_role = CFG_role[relation.role]
			relation.quality = cfg_role.quality
			relation.resId = cfg_role.resId
		end
	end
	table.sort(mRelations[0], SortFunc)
	table.sort(mRelations[1], SortFunc)
end

function SEND_DEL_FRIEND(cs_ByteArray)
	-- print("SEND_DEL_FRIEND")
	local type = ByteArray.ReadByte(cs_ByteArray)
	local id = ByteArray.ReadInt(cs_ByteArray)
	DelRelation(id, type)
	mFriendPanel.RemoveNewMsg(id)
	
	if type == 1 then
		local char = mCharManager.GetChar(id)
		if char then
			mCommonlyFunc.UpdateTitle(char)
		end
	end
	-- print(type, id)
end

function SEND_OTHER_PLAYER_INFO(cs_ByteArray)
	-- print("SEND_OTHER_PLAYER_INFO")
	
	local id = ByteArray.ReadInt(cs_ByteArray)
	local role = ByteArray.ReadByte(cs_ByteArray)
	local level = ByteArray.ReadByte(cs_ByteArray)
	local power = ByteArray.ReadInt(cs_ByteArray)
	local name = ByteArray.ReadUTF(cs_ByteArray,40)
	
	local relation = mRelationsById[id] 
	if not relation then
		return
	end
	relation.role = role
	relation.level = level
	relation.power = power
	relation.name = name
	relation.onLine = true
	
	local cfg_role = CFG_role[relation.role]
	relation.quality = cfg_role.quality
	relation.resId = cfg_role.resId
end

function SEND_ENEMY_LOCATION(cs_ByteArray)
	-- print("SEND_ENEMY_LOCATION")
	
	local char = {}
	char.state = ByteArray.ReadByte(cs_ByteArray)
	char.name = ByteArray.ReadUTF(cs_ByteArray, 40)
	char.x = ByteArray.ReadShort(cs_ByteArray)
	char.y = ByteArray.ReadShort(cs_ByteArray)
	char.role = ByteArray.ReadByte(cs_ByteArray)
	char.level = ByteArray.ReadInt(cs_ByteArray)
	char.power = ByteArray.ReadInt(cs_ByteArray)
	char.harbor = ByteArray.ReadInt(cs_ByteArray)
	char.map = ByteArray.ReadByte(cs_ByteArray)
	char.id = ByteArray.ReadInt(cs_ByteArray)
	-- print(char)
	
	if char.state == 0 then
		mSystemTip.ShowTip("该玩家不在线")
		return
	end
	
	local cfg_role = CFG_role[char.role]
	char.quality = cfg_role.quality
	char.resId = cfg_role.resId
	
	
	mEnemyInfoViewPanel.SetData(char)
	mPanelManager.Show(mEnemyInfoViewPanel)
end

function DelRelation(id, type)
	for k,v in pairs(mRelations[type]) do
		if v.id == id then
			table.remove(mRelations[type], k)
			break
		end
	end
	mRelationsById[id] = nil
	mFriendPanel.RemoveNewMsg(id)
end

function RequestAgree(id, confirm)
	-- print("RequestAgree")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.RELATION)
	ByteArray.WriteByte(cs_ByteArray,Packat_Relation.CLIENT_CONFIRM_ADD_FRIEND)
	ByteArray.WriteInt(cs_ByteArray,id)
	ByteArray.WriteByte(cs_ByteArray,confirm)
	mNetManager.SendData(cs_ByteArray)
end

function RequestFriendById(id)
	local relation = mRelationsById[id]
	if relation and relation.type == 0 then
		mSystemTip.ShowTip("该玩家已经是你好友了")
		return
	end
	-- print("RequestFriendById")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.RELATION)
	ByteArray.WriteByte(cs_ByteArray,Packat_Relation.CLIENT_REQUEST_ADD_FRIEND_BY_UIN)
	ByteArray.WriteInt(cs_ByteArray,id)
	mNetManager.SendData(cs_ByteArray)
end

function RequestFriendByName(name)
	-- print("RequestFriendByName")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.RELATION)
	ByteArray.WriteByte(cs_ByteArray,Packat_Relation.CLIENT_REQUEST_ADD_FRIEND)
	ByteArray.WriteUTF(cs_ByteArray,name, 40)
	mNetManager.SendData(cs_ByteArray)
end

function RequestFriendInfo()
	if os.oldClock - mLastUpdateTime < ConstValue.UpdateFrinedTime then
		return
	end
	mLastUpdateTime = os.oldClock
	-- print("RequestFriendInfo")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.RELATION)
	ByteArray.WriteByte(cs_ByteArray,Packat_Relation.CLIENT_REQUEST_ONLINE_FRIENDS_DETAIL)
	mNetManager.SendData(cs_ByteArray)
end

function RequestDelFriend(id)
	-- print("RequestDelFriend")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.RELATION)
	ByteArray.WriteByte(cs_ByteArray,Packat_Relation.CLIENT_REQUEST_DEL_FRIEND)
	ByteArray.WriteByte(cs_ByteArray,0)
	ByteArray.WriteInt(cs_ByteArray,id)
	mNetManager.SendData(cs_ByteArray)
end

function RequestDelStranger(id)
	-- print("RequestDelStranger")
	for k,v in pairs(mRelations[2]) do
		if v.id == id then
			table.remove(mRelations[2], k)
			break
		end
	end
	mRelationsById[id] = nil
	mFriendPanel.RemoveNewMsg(id)
end

function RequestDelEnemy(id)
	-- print("RequestDelEnemy")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.RELATION)
	ByteArray.WriteByte(cs_ByteArray,Packat_Relation.CLIENT_REQUEST_DEL_FRIEND)
	ByteArray.WriteByte(cs_ByteArray,1)
	ByteArray.WriteInt(cs_ByteArray,id)
	mNetManager.SendData(cs_ByteArray)
end

function RequestStrangerInfo()
	-- print("RequestStrangerInfo")
	for k,v in pairs(mRelations[2]) do
		if not v.IsInit then
			-- print(v.id)
			local cs_ByteArray = ByteArray.Init()
			ByteArray.WriteByte(cs_ByteArray,PackatHead.PLAYER)
			ByteArray.WriteByte(cs_ByteArray,Packat_Player.CLIENT_VIEW_OTHER_PLAYER_INFO)
			ByteArray.WriteInt(cs_ByteArray,v.id)
			mNetManager.SendData(cs_ByteArray)
			
			v.IsInit = true
		end
	end
end

function RequestEnemyInfo(id)
	-- print("RequestEnemyInfo")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.RELATION)
	ByteArray.WriteByte(cs_ByteArray,Packat_Relation.CLIENT_REQUEST_LOCATE_ENEMY)
	ByteArray.WriteInt(cs_ByteArray,id)
	mNetManager.SendData(cs_ByteArray)	
end
function RequestAttackEnemyInfo(id)
	-- print("RequestAttackEnemyInfo")
	local cs_ByteArray = ByteArray.Init()
	ByteArray.WriteByte(cs_ByteArray,PackatHead.RELATION)
	ByteArray.WriteByte(cs_ByteArray,Packat_Relation.CLIENT_REQUEST_JUMP_FIGHT_ENEMY)
	ByteArray.WriteInt(cs_ByteArray,id)
	mNetManager.SendData(cs_ByteArray)	
end
