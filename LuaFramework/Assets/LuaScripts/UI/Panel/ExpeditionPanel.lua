local ExpeditionPanel = {}

local this
local transform
local gameObject

local content

local prefab = Api.LoadImmediately("UI/Panels/PickHeroPanel/HeroItem.prefab", AssetType.Prefab)

local Heros = { }

local preSelect, curSelect = nil, nil

local isDrag = false

--local firstInit = true

local exploreInfo = nil
local index = 0
local heroInfo = nil

local Entry = UIManager.Instance:GetPanel("MainPanel").luaTable.Explore.Entry

local SelectHero = { }

function ExpeditionPanel:Start()
	this = ExpeditionPanel.this
	transform = ExpeditionPanel.transform
	gameObject = ExpeditionPanel.gameObject
	content = transform:Find("View/Content")
	transform:Find("CloseButton"):GetComponent(UIButton).onClick:AddListener(function()
		UIManager.Instance:ClosePanel("ExpeditionPanel")
		UIManager.Instance:OpenPanel("MainPanel", true)
	end)
	Tween.DOKill(transform, false)
	transform.localPosition = Vector2(0, -1920)
	
	MessageManager.AddListener(MsgType.GoHero, function(data)
		self:Refresh()
	end)
	
	MessageManager.AddListener(MsgType.CancelSelectHero, function(id)
		self:Refresh()
	end)
end

function ExpeditionPanel:OnOpen(args)
	exploreInfo = args[1]
	index = args[2]
	heroInfo = args[3]
	local res = Tween.DOLocalMoveY(transform, 0, 0.5, false)
	TweenSetting.SetEase(res, Ease.OutExpo)
	for k, v in pairs(ownedHeros) do
		if Heros[v.n32SeriId] == nil then
			local si = { }
			si.info = v
			si.go = GameObject.Instantiate(prefab)
			si.go.transform:SetParent(content)
			si.go.transform.localScale = Vector3.one
			si.go.transform.localEulerAngles = Vector3.zero
			si.icon = si.go.transform:Find("IconMask/Icon"):GetComponent(Image)
			si.edge = si.go.transform:Find("Edge"):GetComponent(Image)
			si.influenceIcon = si.go.transform:Find("InfluenceIcon"):GetComponent(Image)
			si.typeIcon = si.go.transform:Find("TypeIcon"):GetComponent(Image)
			si.name = si.go.transform:Find("NameBg/NameLabel"):GetComponent(Text)
			si.light = si.go.transform:Find("Light").gameObject
			si.up = si.go.transform:Find("Up").gameObject
			si.go.transform:SetSiblingIndex(k)
			si.icon.sprite = Api.LoadImmediately(v.szModelIcon, AssetType.Sprite)
			si.name.text = v.szName
			if v.n32Camp == 1 then
				si.influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/H.png", AssetType.Sprite)
			elseif v.n32Camp == 2 then
				si.influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/l.png", AssetType.Sprite)
			elseif v.n32Camp == 4 then
				si.influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/R.png", AssetType.Sprite)
			end
			if v.n32MainAtt == 1 then
				si.typeIcon.sprite = Api.LoadImmediately("UI/Textures/Common/liliang.png", AssetType.Sprite)
			elseif v.n32MainAtt == 2 then
				si.typeIcon.sprite = Api.LoadImmediately("UI/Textures/Common/mingjie.png", AssetType.Sprite)
			elseif v.n32MainAtt == 3 then
				si.typeIcon.sprite = Api.LoadImmediately("UI/Textures/Common/zhili.png", AssetType.Sprite)
			end
			
			si.go:GetComponent(UIButton).onClick:AddListener(function()
				if SelectHero[si.info.id] then
					if SelectHero[si.info.id] == 1 then
						if si.up.activeSelf then
							MessageManager.HandleMessage(MsgType.CancelSelectHero, si.info.id)
						else
							MessageBox.Instance:OpenText("这个英雄已经在列表里面了!", Color.red, 1, MessageBoxPos.Middle)
						end
					elseif SelectHero[si.info.id] == 0 then
						MessageBox.Instance:OpenText("这个英雄已经出征过一次了!", Color.red, 1, MessageBoxPos.Middle)
					end
					return
				end
				preSelect = curSelect
				curSelect = si
				if preSelect then
					preSelect:LoseFocus()
				end
				if curSelect then
					curSelect:GetFocus()
				end
				local carduuid = AgentData.Instance:getCardByDataId(si.info.id).uuid
				g_exploreManager:explore_goFight(exploreInfo.uuid, carduuid, index)
			end)
			
			MessageManager.AddListener(MsgType.CancelSelectHero, function(id)
				if id == si.info.id then
					si:LoseFocus()
				end
			end)
			
			function si:LoseFocus()
				si.light:SetActive(false)
				si.up:SetActive(false)
			end
			
			function si:GetFocus()
				si.light:SetActive(true)
				si.up:SetActive(true)
			end
			
			function si:Update(info)
				si.info = info
				if heroInfo and heroInfo.id == info.id then
					si.up:SetActive(true)
				else
					si.up:SetActive(false)
				end
				if si.info.n32Color == 1 then
					si.edge.sprite = Api.LoadImmediately("UI/Textures/Common/edge_white.png", AssetType.Sprite)
				elseif si.info.n32Color == 2 then
					si.edge.sprite = Api.LoadImmediately("UI/Textures/Common/edge_green.png", AssetType.Sprite)
				elseif si.info.n32Color == 3 then
					si.edge.sprite = Api.LoadImmediately("UI/Textures/Common/edge_blue.png", AssetType.Sprite)
				elseif si.info.n32Color == 4 then
					si.edge.sprite = Api.LoadImmediately("UI/Textures/Common/edge_purple.png", AssetType.Sprite)
				elseif si.info.n32Color == 5 then
					si.edge.sprite = Api.LoadImmediately("UI/Textures/Common/edge_orange.png", AssetType.Sprite)
				end
			end
			
			si:Update(v)
			
			Heros[v.n32SeriId] = si
		else
			Heros[v.n32SeriId]:Update(v)
		end
	end
	
	-- if firstInit then
		self:Refresh()
	-- end
	-- firstInit = false
end

function ExpeditionPanel:OnClose()
	MessageManager.HandleMessage(MsgType.OnCloseExpeditionPanel, 0)
	Tween.DOKill(transform, false)
	transform.localPosition = Vector2(0, -1920)
	if curSelect then
		curSelect:LoseFocus()
	end
	preSelect = nil
	curSelect = nil
end

function ExpeditionPanel:Update()
	if Input.GetMouseButtonDown(0) then
		fPos = Input.mousePosition
	end
	if Input.GetMouseButtonUp(0) and fPos then
		sPos = Input.mousePosition
		local dir = sPos - fPos
		if dir.magnitude > 1 then
			isDrag = true
		else
			isDrag = false
		end
	end
end

function ExpeditionPanel:Refresh()
	SelectHero = { }
	for p in Slua.iter(AgentData.Instance.mHero) do
		if p.value.explore > os.time() then
			SelectHero[p.value.dataId] = 0
		end
	end
	for k, v in pairs(Heros) do
		local exis = false
		for key, value in pairs(Entry) do
			for i, j in pairs(value.Slots) do
				if j.info and j.info.id == v.info.id and SelectHero[j.info.id] == nil then
					exis = true
					SelectHero[j.info.id] = 1
				end
			end
		end
		if exis then
			v.icon.material = Api.GreyMat
		else
			if SelectHero[v.info.id] then
				v.icon.material = Api.GreyMat
			else
				v.icon.material = nil
			end
		end
	end
end

function ExpeditionPanel:FixedUpdate()

end

function ExpeditionPanel:LateUpdate()

end

function ExpeditionPanel:OnDestroy()

end

return ExpeditionPanel
