local MissionDialog = {}

local this
local transform
local gameObject

local content

local prefab = Api.LoadImmediately("UI/Dialog/MissionDialog/Item.prefab", AssetType.Prefab)

local Items = { }

function MissionDialog:Start()
	this = MissionDialog.this
	transform = MissionDialog.transform
	gameObject = MissionDialog.gameObject
	--this.enableTween = false
	content = transform:Find("View/Content")
end

function MissionDialog:OnOpen(args)
	local co = coroutine.create(function()
		Yield(WaitForEndOfFrame())
		for p in Slua.iter(AgentData.Instance.mMission) do
			if Items[math.floor(p.value.dataId / 1000)] == nil and p.value.dataId ~= quest.DailyMissionId then
				local si = { }
				si.sInfo = p.value
				si.flagInfo = ConfigReader.GetMissionCfg(si.sInfo.flag)
				si.info = ConfigReader.GetMissionCfg(si.sInfo.dataId)
				si.serialId = math.floor(si.info.id / 1000)
				si.go = GameObject.Instantiate(prefab)
				si.go.transform:SetParent(content)
				si.go.transform.localScale = Vector3.one
				si.go.transform.localEulerAngles = Vector3.zero
				si.starContent = si.go.transform:Find("StarContent")
				si.titleLabel = si.go.transform:Find("TitleBg/TitleLabel"):GetComponent(Text)
				si.desLabel = si.go.transform:Find("DesLabel"):GetComponent(Text)
				si.desRT = si.desLabel:GetComponent(RectTransform)
				si.progress = si.go.transform:Find("Progress"):GetComponent(Slider)
				si.deltaLabel = si.go.transform:Find("Progress/DeltaLabel"):GetComponent(Text)
				si.itemBg = si.go.transform:Find("ItemBg").gameObject
				si.itemIcon = si.go.transform:Find("ItemBg/ItemIcon"):GetComponent(Image)
				si.rewardNumLabel = si.go.transform:Find("ItemBg/NumLabel"):GetComponent(Text)
				si.availableFlag = si.go.transform:Find("ItemBg/Tip").gameObject
				si.complete = si.go.transform:Find("Complete").gameObject
				
				si.available = false
				
				si.itemBg:GetComponent(Button).onClick:AddListener(function()
					-- Debug.LogError(tostring(si.available))
					if si.available then
						SystemLogic.recvMissionAward(si.sInfo.dataId)
					end
				end)
				
				if not si.flagInfo then si.flagInfo = si.info end
				
				
				
				function si:Update(arg)
					if arg then
						si.sInfo = arg
						si.flagInfo = ConfigReader.GetMissionCfg(si.sInfo.flag)
						si.info = ConfigReader.GetMissionCfg(si.sInfo.dataId)
					end
					if not si.flagInfo then si.flagInfo = si.info end
					-- Debug.LogError("flag " .. si.sInfo.flag .. " dataId " .. si.sInfo.dataId .. " index " .. si.sInfo.index)
					if si.go.transform:GetSiblingIndex() ~= si.sInfo.index then
						si.go.transform:SetSiblingIndex(si.sInfo.index)
					end
					local index = tonumber(string.sub(si.sInfo.flag, -1))
					for i = 0, si.starContent.childCount -1 do
						local go = si.starContent:GetChild(i).gameObject
						go:SetActive(i < si.flagInfo.n32Degree and i < index - 1)
					end
					if si.flagInfo == nil then
						si.flagInfo = si.info
					end
					si.titleLabel.text = si.info.szName
					si.desLabel.text = si.flagInfo.szContent
					si.progress.value = si.sInfo.progress / si.flagInfo.n32Goal
					if si.progress.value < 0.1 then si.progress.value = 0.1 end
					si.deltaLabel.text = si.sInfo.progress .. "/" .. si.flagInfo.n32Goal
					si.rewardNumLabel.text = "x" .. si.flagInfo.szAwards_num
					
					si.progress.gameObject:SetActive(true)
					si.desRT.anchoredPosition = Vector2(82, 33)
					
					si.complete:SetActive(false)
					
					if si.sInfo.flag < si.sInfo.dataId then
						si.itemBg:SetActive(true)
						si.availableFlag:SetActive(true)
						si.available = true
					elseif si.sInfo.flag == si.sInfo.dataId then
						local bo = SystemLogic.isMissionCompleted(si.sInfo.dataId)
						if bo then
							si.itemBg:SetActive(true)
							si.availableFlag:SetActive(true)
							si.available = true
						else
							si.itemBg:SetActive(true)
							si.availableFlag:SetActive(false)
							si.available = false
						end
					else
						si.itemBg:SetActive(false)
						si.complete:SetActive(true)
						si.progress.gameObject:SetActive(false)
						si.desRT.anchoredPosition = Vector2(82, 0)
						si.available = false
					end
				end
				
				si:Update()
				
				MessageManager.AddListener(MsgType.UpdateMission, function(m)
					si.flagInfo = ConfigReader.GetMissionCfg(si.sInfo.flag)
					si.info = ConfigReader.GetMissionCfg(si.sInfo.dataId)
					si:Update(m[si.serialId])
				end)
				
				Items[si.info.n32SerId] = si
				Yield(WaitForEndOfFrame())
			elseif Items[math.floor(p.value.dataId / 1000)] and p.value.dataId ~= quest.DailyMissionId then
				Items[math.floor(p.value.dataId / 1000)]:Update(p.value)
			end
		end
	end )
	coroutine.resume(co)
end

function MissionDialog:Update()

end

function MissionDialog:FixedUpdate()

end

function MissionDialog:LateUpdate()

end

function MissionDialog:OnDestroy()

end

return MissionDialog
