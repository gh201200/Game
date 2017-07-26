local Activity = class("Activity")

function update_activity_data(uid, val, time)
	g_Activity:update(uid, val, time)
end

ActivitySysType =
{
		--RefreshShopCard               = 0,    --商城卡牌刷新批次
		ShopCardId1                     = 0,    --金币商城道具id1
	  ShopCardId2                     = 1,    --金币商城道具id2
		ShopCardId3                     = 2,    --金币商城道具id3
		
   	BuyShopCard1                    = 1001, --商城购买卡牌1次数
   	BuyShopCard2                    = 1002, --商城购买卡牌2次数
   	BuyShopCard3                    = 1003, --商城购买卡牌3次数
   	PvpTimes												= 2001, --pvp参加场次
   	PvpWinTimes											= 2002, --pvp胜利场次
   	RefreshExplore									= 3001, --刷新探索次数
       
}

function Activity:Clear()
	self.units = {}
end


--根据uid获得accountId, atype
function Activity.calcNameType(uid)
	local t = string.split(uid, '$')
	return t[1], tonumber(t[2])
end


--获得系统活动uid
function Activity.calcSysUid(atype)
        return 'system' .. '$' .. atype
end

--获得玩家活动 uid
function Activity:calcAccountUid(atype)
        return Account.accountId .. '$' .. atype
end

--根据key获得uid
function Activity.calcUid(name, atype)
        return name .. '$' .. atype
end


function Activity:ctor()
	self.units = {}
end


function Activity.create(uid, val, time)
         return {uid=uid,  value=val, time = time}
end

--数据更新反馈
function Activity:update(uid, val, time)
	-- Util.Log("Activity:update")
	-- print("uid = "..uid)
	-- print("val = "..val)
	-- print("time = "..time)
	if self.units[uid] then
		self.units[uid].value = val		--次数
		self.units[uid].time = time		--剩余时间
	else
		self.units[uid] = self.create(uid, val, time)
	end
	
	local name, atype = Activity.calcNameType(uid)
	
	if atype == ActivitySysType.ShopCardId1 then
		local t = { }
		local value = val
		t.index = atype
		t.value = value
		MessageManager.HandleMessage(MsgType.RefreshShopCard, t)
	elseif atype == ActivitySysType.ShopCardId2 then
		local t = { }
		local value = val
		t.index = atype
		t.value = value
		MessageManager.HandleMessage(MsgType.RefreshShopCard, t)
	elseif atype == ActivitySysType.ShopCardId3 then
		local t = { }
		local value = val
		t.index = atype
		t.value = value
		MessageManager.HandleMessage(MsgType.RefreshShopCard, t)
	elseif atype == ActivitySysType.BuyShopCard1 then
		local index = string.sub(tostring(atype), string.len(tostring(atype))) - 1
		local value = val
		local t = { }
		t.index = index
		t.value = value
		MessageManager.HandleMessage(MsgType.RefreshShopRemainingCardNum, t)
	elseif atype == ActivitySysType.BuyShopCard2 then
		local index = string.sub(tostring(atype), string.len(tostring(atype))) - 1
		local value = val
		local t = { }
		t.index = index
		t.value = value
		MessageManager.HandleMessage(MsgType.RefreshShopRemainingCardNum, t)
	elseif atype == ActivitySysType.BuyShopCard3 then
		local index = string.sub(tostring(atype), string.len(tostring(atype))) - 1
		local value = val
		local t = { }
		t.index = index
		t.value = value
		MessageManager.HandleMessage(MsgType.RefreshShopRemainingCardNum, t)
	elseif atype == ActivitySysType.PvpTimes then
		MessageManager.HandleMessage(MsgType.PvpTimes, val)
	elseif atype == ActivitySysType.PvpWinTimes	then
		MessageManager.HandleMessage(MsgType.PvpWinTimes, val)
	elseif atype == ActivitySysType.RefreshExplore then
		MessageManager.HandleMessage(MsgType.RefreshExplore, val)
	end
end

--获得系统活动值
function Activity:getSysValue(atype)
	local uid = self.calcUid('system', atype)
	if self.units[uid] then
		return self.units[uid].value
	end
	return 0
end

--获得玩家活动值
function Activity:getAccountValue(atype)
	local uid = self.calcUid(Account.accountId, atype)
	if self.units[uid] then
		return self.units[uid].value
	end
	return 0
end

return Activity.new()

