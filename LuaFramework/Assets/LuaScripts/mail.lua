local MailManager = class("Mail")

local Flag = {
	Read 		= bit(0),		--已读
	Recv 		= bit(1),		--附件已领取
	Delete 		= bit(2),		--已删除
}

function MailManager:Clear()
	self.units = {}
end

function MailManager:ctor()
	self.units = {}		--邮件数据
	
	--注册网络消息
	registerMsgHandler("sendMaill", "sendMaill")
	registerMsgHandler("recvMailItems", "recvMailItems")
end

function MailManager:getMail(uuid)
	for k, v in pairs(self.units) do
		if v.uuid == uuid then
			return v
		end
	end
	return nil
end

function MailManager:addMail(mail)
	local old = self:getMail(mail.uuid)
	if old then
		old.flag = mail.flag
		old.index = mail.index
		return
	else
		table.insert(self.units, mail)
	end
	
	-- table.sort(self.units, function(left,right) 
		-- if left.time <= right.time then return false end
		-- return true
	-- end)
	-- print(self.units)
end

--读取邮件
function MailManager:readMail(uuid)
	if bit_and(self.units[uuid].flag, Flag.Read) ~= 0 then return end
	
	local sp = SpObject()
	sp:Insert("uuid", uuid)
	sendNetMsg("readMail", sp)		
end
--[[
function testrecvMailItems(cmd)
	local arr = string.split(cmd, " ")
	g_Mails:recvMailItems(tonumber(arr[2]))
end
--]]
--领取附件
function MailManager:recvMailItems(index)
	index = index + 1
	if bit_and(self.units[index].flag, Flag.Recv) ~= 0 then return end		--未领取
	if Table_Get_N(self.units[index].items) == 0 then return end			--必须是附件邮件
	
	local sp = SpObject()
	sp:Insert("uuid", self.units[index].uuid)
	sendNetMsg("recvMailItems", sp)	
end



---------------------------------------
--网络消息
--收到邮件数据
function onHandleRequest_sendMaill( sp )
	 Util.Log("onHandleRequest_sendMaill")
     Util.DumpObject(sp)
     
     local dict = sp:getTable("mailsList")
     if not dict then return end
	 local index_ = 0
	 dict = Api.SortDic(dict)
     for p in Slua.iter(dict) do
     	local uuid = p.value:getString("uuid")
     	local mail = {
			index = index_,
			uuid =  p.value:getString("uuid"),
			title =  p.value:getString("title"),		--标题
			content =  p.value:getString("content"),	--内容
			sender =  p.value:getString("sender"),		--发送者（system）
			items =  {},								--附件
			flag = p.value:getInt("flag"),				--邮件标识
			time = p.value:getInt("time"),				--发送时间
		}
		index_ = index_ + 1
		local items =  p.value:getString("items")
		local arr = string.split(items, ",")
		print(arr)
		for i=1, #arr, 2 do
			mail.items[tonumber(arr[i])] = tonumber(arr[i+1])
		end
		g_Mails:addMail(mail)
		MessageManager.HandleMessage(MsgType.UpdateMail, mail)
     end
     --
end

--收取附件回复
function onHandleResponse_recvMailItems( sp )
 	Util.Log("onHandleResponse_recvMailItems")
    Util.DumpObject(sp)
     
    local errorCode = sp:getInt("errorCode")
	local uuid = sp:getString("uuid")				
	local dict = sp:getTable("items")
	local items = {}
	if dict then		--获得的道具[data id]=[数量]
		for p in Slua.iter(dict) do
			items[p.value:getInt("x")] = p.value:getInt("y")
		end
	end
	--
	if errorCode ~= 0 then
		MessageBox.Instance:OpenText("error code : " .. tostring(errorCode), Color.red, 1, MessageBoxPos.Middle)
		return
	end
	
	if table.size(items) > 0 then
		UIManager.Instance:OpenPanel("OpenBoxPanel", false, items)
	else
		MessageBox.Instance:OpenText("领取成功!", Color.cyan, 1, MessageBoxPos.Middle)
	end
	
	local info = nil
	for k, v in pairs(g_Mails.units) do
		v.index = k - 1
		if v.uuid == uuid then
			info = v
		end
	end
	MessageManager.HandleMessage(MsgType.ReceiveMailItem, info)
end

return MailManager.new()

