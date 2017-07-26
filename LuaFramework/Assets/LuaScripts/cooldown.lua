local CoolDown = class("CoolDown")

function update_CoolDown_data(uid, val)
	g_CoolDown:update(uid, val)
end

CoolDownSysType =
{
        ResetCardPower          		= 0,    --英雄体力重置
        RefreshShopCard                 = 1,    --卡牌商店刷新
        
        TimeLimitSale                   = 1001, --限时特惠商品
}

function CoolDown:Clear()
	self.units = {}
end

--根据uid获得accountId, atype
function CoolDown.calcNameType(uid)
	local t = string.split(uid, '$')
	return t[1], tonumber(t[2])
end

--获得系统CD uid
function CoolDown.calcSysUid(atype)
        return 'system' .. '$' .. atype
end

--获得玩家CD uid
function CoolDown:calcAccountUid(atype)
        return Account.accountId .. '$' .. atype
end

--根据key获得uid
function CoolDown.calcUid(name, atype)
        return name .. '$' .. atype
end


function CoolDown:ctor()
	self.units = {}
end


function CoolDown.create(uid, val)
         return {uid=uid, value=val}
end

--数据更新反馈
function CoolDown:update(uid, val)
	
	if self.units[uid] then
		self.units[uid].value = val
	else
		self.units[uid] = self.create(uid, val)
	end
	local name, atype = CoolDown.calcNameType(uid)
	--根据 atype 来判断是何种CD数据更新了
	
	if atype == CoolDownSysType.RefreshShopCard then
		local value = self:getSysValue(atype)
		MessageManager.HandleMessage(MsgType.UpdateShopCd, value)
	elseif atype == CoolDownSysType.TimeLimitSale then
		local value = self:getAccountValue(atype)
		MessageManager.HandleMessage(MsgType.RefreshGift, value)
	end
end

--获得系统CD值
function CoolDown:getSysValue(atype)
	local uid = self.calcUid('system', atype)
	if self.units[uid] then
		print("uid",self.units)
		return self.units[uid].value
	end
	return 0
end

--获得玩家CD值
function CoolDown:getAccountValue(atype)
	local uid = self.calcUid(Account.accountId, atype)
	if self.units[uid] then
		return self.units[uid].value
	end
	return 0
end

----------------------------------------------------------------------------------------------------------------------

function CoolDown:RefreshShopCd()
	local uid = self.calcSysUid(CoolDownSysType.RefreshShopCard)
	SystemLogic.Instance:UpdateCDData(uid)
end

return CoolDown.new()

