local ExploreManager = class("ExploreManager")

local COLOR_C = {
	0,3,6,9,12
}

function ExploreManager:Clear()
	self.units = {}
end
 
function ExploreManager:ctor()
	self.units = {}		--探索数据
	
	--注册网络消息
	registerMsgHandler("sendExplore", "sendExplore")
	registerMsgHandler("explore_goFight", "explore_goFight")
	registerMsgHandler("exploreBegin", "exploreBegin")
	registerMsgHandler("exploreEnd", "exploreEnd")
	registerMsgHandler("exploreRefresh", "exploreRefresh")
end

function ExploreManager:addExplore(unit)
	if unit.time > 0 then unit.time = unit.time + os.time() end
	self.units[unit.uuid] = unit
end

--根据index获取探索数据
--0 , 1, 2
function ExploreManager:getExploreByIndex(_index)
	local i = 0
	for k, v in pairs(self.units) do
		if i == _index then return v end
		i = i + 1
	end
	return nil
end

--根据uuid获取探索数据
function ExploreManager:getExploreByUuid(_uuid)
	return self.units[_uuid]
end

--根据探索uuid获得探索收益
--return: 卡牌碎片数量，技能碎片数量， 金币
function ExploreManager:getGains(_uuid, fights)
	local unit = self:getExploreByUuid(_uuid)
 	local gains = {}
    local score = 0
	local exploreDat = ConfigReader.GetExplorepCfg(unit.dataId)
	for i=0, 2 do
		local card = AgentData.Instance:GetCardByUuid( fights[i + 1] )
		if card then
			local color_c = 3
			local con_c = 10
			local dat = ConfigReader.GetHeroInfo(card.dataId)
			if dat.n32Color >= exploreDat.n32Color then
				color_c = color_c + COLOR_C[exploreDat.n32Color]
			end
			if unit["att"..i] == dat.n32MainAtt then
			  con_c = con_c + 5
			end
			if bit_and(unit["cam"..i], dat.n32Camp) ~= 0 then
	        	con_c = con_c + 5
	        end
	        score = score +  color_c * con_c
        end
     end
    score = score * exploreDat.n32Time / 3600
    local cn = math.floor(score * exploreDat.n32CardC)
    local sn = math.floor(score * exploreDat.n32SkillC)
    local gold =  math.floor(score * exploreDat.n32GoldC)
	return cn, sn, gold
end

--出征选择英雄
--expuuid : 探索uuid，carduuid：卡牌uuid，index：槽位选择
function ExploreManager:explore_goFight(expuuid, carduuid, index)
	local sp = SpObject()
	sp:Insert("uuid", carduuid)
	sp:Insert("index", index)
	sp:Insert("expuuid", expuuid)
	sendNetMsg("explore_goFight", sp)	
end

--开始探索
--uuid：探索uuid，uuid0：卡牌uuid，uuid1：卡牌uuid，uuid2：卡牌uuid
function ExploreManager:exploreBegin(uuid, uuid0, uuid1, uuid2)
	if uuid == nil then uuid = "" end
	if uuid0 == nil then uuid0 = "" end
	if uuid1 == nil then uuid1 = "" end
	if uuid2 == nil then uuid2 = "" end
	local sp = SpObject()
	sp:Insert("uuid", uuid)
	sp:Insert("uuid0", uuid0)
	sp:Insert("uuid1", uuid1)
	sp:Insert("uuid2", uuid2)
	sendNetMsg("exploreBegin", sp)	
end

--领取探索收益
--uuid：探索uuid
function ExploreManager:exploreEnd(uuid)
	local sp = SpObject()
	sp:Insert("uuid", uuid)
	sendNetMsg("exploreEnd", sp)	
end

--刷新探索任务
--uuid：探索uuid
function ExploreManager:exploreRefresh(uuid)
	local sp = SpObject()
	sp:Insert("uuid", uuid)
	sendNetMsg("exploreRefresh", sp)	
end

function test_explore_exploreEnd(cmd)
	local unit = g_exploreManager:getExploreByIndex(0)
	g_exploreManager:exploreEnd(unit.uuid)
end

function test_explore_exploreRefresh(cmd)
	local unit = g_exploreManager:getExploreByIndex(0)
	g_exploreManager:exploreRefresh(unit.uuid)
end

function test_explore_exploreBegin(cmd)
	local unit = g_exploreManager:getExploreByIndex(0)
	local card1 = AgentData.Instance:getCardByDataId(110001)
	local card2 = AgentData.Instance:getCardByDataId(230101)
	g_exploreManager:exploreBegin(unit.uuid, card1.uuid, card2.uuid, "")
end

function test_explore_goFight(cmd)
	local arr = string.split(cmd, " ")
	local unit = g_exploreManager:getExploreByIndex(0)
	local card = AgentData.Instance:getCardByDataId(110001)
	g_exploreManager:explore_goFight(unit.uuid, card.uuid, tonumber(arr[2]))
end

function test_explore_getgains(cmd)
	local arr = string.split(cmd, " ")
	local unit = g_exploreManager:getExploreByIndex(tonumber(arr[2]))
	local card, skill, gold = g_exploreManager:getGains(unit.uuid)
	print(card)
	print(skill)
	print(gold)
end


---------------------------------------
--网络消息
--收到探索数据
function onHandleRequest_sendExplore( sp )
	 Util.Log("onHandleRequest_sendExplore")
     Util.DumpObject(sp)
     
     local dict = sp:getTable("exploresList")
     if not dict then return end
	 local index_ = 0
     for p in Slua.iter(dict) do
     	local unit = {
			dataId  = p.value:getInt("dataId"),			--探索配置表id
			uuid0 = p.value:getString("uuid0"),			--配置的卡牌uuid
			uuid1 = p.value:getString("uuid1"),
			uuid2 = p.value:getString("uuid2"),
			att0 = p.value:getInt("att0"),				--槽位1的属性要求，如果为0，则代表没有要求
			cam0 = p.value:getInt("cam0"),				--槽位1的势力要求，如果为0，则代表没有要求
			att1 = p.value:getInt("att1"),	
			cam1 = p.value:getInt("cam1"),	
			att2 = p.value:getInt("att2"),	
			cam2 = p.value:getInt("cam2"),
			time = p.value:getInt("time"),				--剩余时间 > 0 ：正在出征； < 0 ：可以领取奖励；= 0 ：奖励领取过了，还没开始出征
			uuid =p.value:getString("uuid"),			--探索的uuid
		}
		g_exploreManager:addExplore(unit)
	end

	for _, v in pairsByKeys(g_exploreManager.units) do
		--Debug.LogError("update explore data time " .. v.time .. "dataId " .. v.dataId.. " uuid "..v.uuid)
		MessageManager.HandleMessage(MsgType.UpdateExplore, v)
	end
end

--设置英雄回复
function onHandleResponse_explore_goFight( sp )
 	Util.Log("onHandleResponse_explore_goFight")
    Util.DumpObject(sp)
    
    local errorCode = sp:getInt("errorCode")	--
	local carduuid = sp:getString("uuid")		--	卡牌uuid	
	local index = sp:getInt("index")				--槽位选择
	local expuuid = sp:getString("expuuid")			--探索uuid
    if errorCode == 0 then
		local dataId = AgentData.Instance:GetCardByUuid(carduuid).dataId
		MessageManager.HandleMessage(MsgType.GoHero, {expuuid = expuuid, index = index, dataId = dataId})
	else
		MessageBox.Instance:OpenText("unknow exception!", Color.red, 1, MessageBoxPos.Middle)
	end
end

--开始探索回复
function onHandleResponse_exploreBegin( sp )
	Util.Log("onHandleResponse_exploreBegin")
    Util.DumpObject(sp)
    local errorCode = sp:getInt("errorCode")
	local uuid = sp:getString("uuid")			--探索uuid
    
end

--领取探索收益结果
function onHandleResponse_exploreEnd( sp )
	Util.Log("onHandleResponse_exploreEnd")
    Util.DumpObject(sp)
    local errorCode = sp:getInt("errorCode")
	local uuid = sp:getString("uuid")			--探索uuid
	local dict = sp:getTable("items")			--获得的道具
	local items = {}
	if dict then		--获得的道具[data id]=[数量]
		for p in Slua.iter(dict) do
			items[p.value:getInt("x")] = p.value:getInt("y")
		end
	end
	
	if errorCode == 0 then
		local t = UIManager.Instance:GetPanel("MainPanel").luaTable.Explore.Entry[uuid]:GetUuid()
		local hero, skill, coin = g_exploreManager:getGains(uuid, t)
		--MessageBox.Instance:OpenText("英雄卡牌 +" .. hero .. "\n技能卡牌 +" .. skill .. "\n金币 +" .. coin, Color.cyan, 2, MessageBoxPos.Middle)
		UIManager.Instance:OpenPanel("OpenBoxPanel", false, items)
		MessageManager.HandleMessage(MsgType.GetExploreReward, uuid)
	else
		MessageBox.Instance:OpenText("unknow exception!", Color.red, 1, MessageBoxPos.Middle)
	end
end

--刷新探索任务回复
function onHandleResponse_exploreRefresh( sp )
	Util.Log("onHandleResponse_exploreRefresh")
    Util.DumpObject(sp)
    local errorCode = sp:getInt("errorCode")		--钻石不足
	local uuid = sp:getString("uuid")				--探索uuid
	if errorCode == 0 then
		MessageBox.Instance:OpenText("刷新成功！\n <size=40><color=red>今日剩余刷新次数：</color><color=#00FF56FF>" .. Account.exploretimes .. "</color></size>", Color.cyan, 1, MessageBoxPos.Middle)
		SystemLogic.Instance:UpdateActivityData(g_Activity:calcAccountUid(ActivitySysType.RefreshExplore))
	elseif errorCode == 1 then
		MessageBox.Instance:OpenText("钻石不足！", Color.red, 1, MessageBoxPos.Middle)
	elseif errorCode == 2 then
		MessageBox.Instance:OpenText("今日刷新次数已用完", Color.red, 1, MessageBoxPos.Middle)
    else
		MessageBox.Instance:OpenText("unknow errorCode", Color.red, 1, MessageBoxPos.Middle)
	end
end

return ExploreManager.new()
