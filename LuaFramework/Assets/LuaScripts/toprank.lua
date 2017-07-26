local TopRank = class("TopRank")

--[[
RankItem {
	head 0 : string	???
	nick 1 : string	???
	factionicon 2 : string	???????
	factionname 3 : string	????????
	score 4 : integer ?
}
--]]

function TopRank:Clear()
	self.rankGroup = {}	
end

function TopRank:ctor()
	self.rankGroup = {}		--???��?????
	self.maxnum = 200		--????????
	
	--??????????
	registerMsgHandler("reqTopRank", "reqTopRank")
end

function TopRank:update(atype, sets)
	if not self.rankGroup[atype] then
		self.rankGroup[atype] = {}
	end
	
	for k, v in pairs(sets) do
		v.score = math.floor(v.score / 1000)
		table.insert(self.rankGroup[atype] , v)
	end
end

--??????????��?????
function TopRank:reqTopRank(atype, start, num)
	local sp = SpObject()
	sp:Insert("atype", atype)
	sp:Insert("start", start)
	sp:Insert("num", num)
	sendNetMsg("reqTopRank", sp)																																														
end

--??????��?
function TopRank:clear()
	self.rankGroup = {}
end

--??????��??????
function TopRank:getCount(atype)
	if self.rankGroup[atype] then
		return #self.rankGroup[atype]
	end
	return 0
end

--??????��?item
function TopRank:getItem(atype, index)
	if not self.rankGroup[atype] then return nil end
	return self.rankGroup[atype][index]
end

---------------------------------------
--???????
function onHandleResponse_reqTopRank( sp )
	 Util.Log("onHandleResponse_reqTopRank")
     Util.DumpObject(sp)
	
	local atype = sp:getInt("atype")
	local dict = sp:getTable("items")
	
	if not dict then return end
	
	local sets = {}
	for p in Slua.iter(dict) do
		local item = {
			head =  p.value:getString("head"),
			nick = p.value:getString("nick"),
			factionicon =  p.value:getString("factionicon"),
			--factionname = p.value:getString("factionname"),
			factionname = "暂无工会",
			score = p.value:getInt("score"),
			
		}
		table.insert( sets, item )
	end
	g_TopRank:update(atype, sets)
	MessageManager.HandleMessage(MsgType.UpdateRankList, sets)
end



return TopRank.new()

