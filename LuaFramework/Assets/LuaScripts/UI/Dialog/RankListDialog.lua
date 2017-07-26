local RankListDialog = {}

local this
local transform
local gameObject

local sr
local content
local firstPrefab
local prefab

local Items = { }
local nextIndex = 0
local perNum = 7

function RankListDialog:Start()
	this = RankListDialog.this
	transform = RankListDialog.transform
	gameObject = RankListDialog.gameObject
	sr = transform:Find("View"):GetComponent(UIScrollRect)
	content = transform:Find("View/Content")
	firstPrefab = Api.LoadImmediately("UI/Dialog/RankListDialog/FirstItem.prefab", AssetType.Prefab)
	prefab = Api.LoadImmediately("UI/Dialog/RankListDialog/Item.prefab", AssetType.Prefab)
	
	-- 监听排行榜数据刷新
	MessageManager.AddListener(MsgType.UpdateRankList, function(t)
		self:UpdateUI(t)
	end)
	
	sr.OnDragToBottomEvent = {
		"+=", self.RequestUpdate
	}
	
	self:RequestUpdate()
end

function RankListDialog:OnOpen(args)
	g_TopRank:clear()
	g_TopRank:reqTopRank(quest.RankType.Exp, 0, nextIndex)
	--Debug.LogError(nextIndex)
end

-- 请求更新排行榜
function RankListDialog:RequestUpdate()
	TimeManager.Instance:Do(0.5, function()
		g_TopRank:reqTopRank(quest.RankType.Exp, nextIndex, perNum)
	end)
	--Debug.LogError("RequestUpdate startIndex:" .. tostring(nextIndex) .. " num:" .. tostring(perNum))
end

-- 更新排行榜UI显示
function RankListDialog:UpdateUI(t)
	local co = coroutine.create(function()
		for k, v in pairs(t) do
			if Items[v.nick] == nil then
				local si = { }
				si.index = nextIndex + 1
				si.info = v
				if si.index == 1 then si.go = GameObject.Instantiate(firstPrefab) else si.go = GameObject.Instantiate(prefab) end
				si.go.transform:SetParent(content)
				si.go.transform.localScale = Vector3.one
				si.go.transform.localEulerAngles = Vector3.zero
				si.cupIcon = si.go.transform:Find("CupIcon"):GetComponent(Image)
				si.rankLabel = si.go.transform:Find("RankLabel"):GetComponent(Text)
				si.headIcon = si.go.transform:Find("PlayerIcon"):GetComponent(Image)
				si.unionIcon = si.go.transform:Find("PlayerIcon/TradeUnionIcon"):GetComponent(Image)
				si.nameLabel = si.go.transform:Find("PlayerIcon/NameLabel"):GetComponent(Text)
				si.unionLabel = si.go.transform:Find("PlayerIcon/TradeUnionLabel"):GetComponent(Text)
				si.scoreLabel = si.go.transform:Find("Score/ScoreLabel"):GetComponent(Text)
				
				function si:Update()
					if si.index == 1 then
						si.go.transform.localPosition = Vector3.zero
						si.cupIcon.gameObject:SetActive(true)
						si.rankLabel.gameObject:SetActive(false)
					elseif si.index == 2 then
						si.cupIcon.gameObject:SetActive(true)
						si.rankLabel.gameObject:SetActive(false)
						Api.Load("UI/Textures/RankList/er.png", AssetType.Sprite, function(s)
							si.cupIcon.sprite = s
						end)
					elseif si.index == 3 then
						si.cupIcon.gameObject:SetActive(true)
						si.rankLabel.gameObject:SetActive(false)
						Api.Load("UI/Textures/RankList/san.png", AssetType.Sprite, function(s)
							si.cupIcon.sprite = s
						end)
					else
						si.cupIcon.gameObject:SetActive(false)
						si.rankLabel.gameObject:SetActive(true)
						si.rankLabel.text = si.index
					end
					si.nameLabel.text = v.nick
					si.unionLabel.text = v.factionname
					si.scoreLabel.text = v.score
				end
				
				si:Update()
				
				nextIndex = nextIndex + 1
				
				Items[v.nick] = si
				--Debug.LogError(si.index)
				Yield(WaitForEndOfFrame())
			else
				Items[v.nick].info = v
				Items[v.nick]:Update()
			end
		end
	end)
	coroutine.resume(co)
end

function RankListDialog:Update()

end

function RankListDialog:FixedUpdate()

end

function RankListDialog:LateUpdate()

end

function RankListDialog:OnDestroy()

end

return RankListDialog
