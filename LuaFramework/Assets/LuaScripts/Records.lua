local Records = class("Records")

function Records:ctor()
	--注册网络消息
	registerMsgHandler("requestFightRecords", "reqRecords")
end

--请求战斗记录
function Records:reqRecords(atype, start, num)
	local sp = SpObject()
	sendNetMsg("requestFightRecords", sp)																																														
end
---------------------------------------
--网络消息
function onHandleResponse_reqRecords( sp )
	Util.Log("onHandleResponse_reqRecords")
    --Util.DumpObject(sp)
	local dict = sp:getTable("records")
	local data = { }
	if dict == nil then
		--没有战斗记录
		MessageManager.HandleMessage(MsgType.UpdateBattleRecord, data)
		return
	end
	-- print(dict.Count)
	for i=0,dict.Count-1,1 do
		-- print("fight record item:" .. i)
		local str = dict[i]:AsString()
		local fightItem = load(str)()
		table.insert(data, fightItem)
		
		for j=1,#fightItem do
			local player = fightItem[j]
			-- Debug.LogError("records")
			-- print(player)
			-- print("player:" .. j)
			-- print(player.account_id)
			-- print(player.nickName)
			-- print(player.color)
			-- print(player.winflag) -- 1 胜利 2 失败 3 平局
			-- print(player.heroId)
			-- print(player.skillTable)
			-- print(player.assistNum)
			-- print(player.killNum)
			-- print(player.deadthNum)
			
			-- local id = { }
			-- for k, v in pairs(player.skillTable) do
				-- local info = ConfigReader.GetSkillDataInfo(v)
				-- if info == nil or info.n32SkillType == 0 then
					-- table.insert(id, k)
				-- end
			-- end
			-- for k, v in pairs(id) do
				-- table.remove(player.skillTable, v)
			-- end
		end
	end
	MessageManager.HandleMessage(MsgType.UpdateBattleRecord, data)
end



return Records.new()

