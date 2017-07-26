local Tween = ShortcutExtensions

local PickHeroPanel = { }
local Own = { }
local Opposite = { }

local this
local transform
local gameObject

local ownContent
local oppositeContent
local content
local buttonImage

local defaultIcon

local matchData

local preItem, curItem

function PickHeroPanel:Init()
	ownContent = transform:Find("Own")
	oppositeContent = transform:Find("Opposite")
	content = transform:Find("View/Content")
	buttonImage = transform:Find("SureButton"):GetComponent(Image)
	for i = 0, ownContent.childCount - 1 do
		local si = { }
		si.index = i
		si.free = true
		si.go = ownContent:GetChild(i).gameObject
		si.icon = si.go.transform:Find("IconMask/Icon"):GetComponent(Image)
		si.edge = si.go.transform:Find("Edge"):GetComponent(Image)
		si.nickName = si.go.transform:Find("NickName"):GetComponent(Text)
		
		if defaultIcon == nil then defaultIcon = si.icon.sprite end
		
		function si:Update(account, heroId)
			si.edge.gameObject:SetActive(true)
			si.nickName.text = account
			si.info = ConfigReader.GetHeroInfo(heroId)
			si.icon.sprite = Api.LoadImmediately(si.info.szModelIcon, AssetType.Sprite)
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
			si.free = false
		end
		
		function si:Reset()
			si.free = true
			si.icon.sprite = defaultIcon
			si.nickName.text = "未知玩家"
			si.edge.gameObject:SetActive(false)
			si.edge.sprite = Api.LoadImmediately("UI/Textures/Common/edge_white.png", AssetType.Sprite)
		end
		
		Own[si.index] = si
	end
	
	for i = 0, oppositeContent.childCount - 1 do
		local si = { }
		si.index = i
		si.free = true
		si.go = oppositeContent:GetChild(i).gameObject
		si.icon = si.go.transform:Find("IconMask/Icon"):GetComponent(Image)
		si.edge = si.go.transform:Find("Edge"):GetComponent(Image)
		si.nickName = si.go.transform:Find("NickName"):GetComponent(Text)
		function si:Update(account, heroId)
			si.edge.gameObject:SetActive(true)
			si.nickName.text = account
			si.info = ConfigReader.GetHeroInfo(heroId)
			si.icon.sprite = Api.LoadImmediately(si.info.szModelIcon, AssetType.Sprite)
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
			si.free = false
		end
		
		function si:Reset()
			si.free = true
			si.icon.sprite = defaultIcon
			si.nickName.text = "玩家昵称"
			si.edge.gameObject:SetActive(false)
			si.edge.sprite = Api.LoadImmediately("UI/Textures/Common/edge_white.png", AssetType.Sprite)
		end
		
		Opposite[si.index] = si
	end
end

function PickHeroPanel:AddPlayer(account, heroId, isOwn)
	if account == Account.accountId then
		Own[0]:Update(account, heroId)
	else
		if isOwn then
			for i = 1, 2 do
				local si = Own[i]
				if si.free then
					si:Update(account, heroId)
					break
				end
			end
		else
			for i = 0, 2 do
				local si = Opposite[i]
				if si.free then
					si:Update(account, heroId)
					break
				end
			end
		end
	end
end

---------------倒计时---------------
local countDownText
local totalTime = 30
local leftTime = totalTime

function PickHeroPanel:CountDown()
    if countDownText == nil then countDownText = transform:Find("CountDownText"):GetComponent(Text) end
    leftTime = leftTime - Time.deltaTime
    countDownText.text = math.floor(leftTime)
    if leftTime <= 0 then
        leftTime = 0
        countDownText.text = 0
		if Confirme == false then
			UIManager.Instance:OpenPanel("MainPanel", true)
		end	
        return
    end
end

---------------英雄选择---------------
PickHeroPanel.HeroList = { }

function PickHeroPanel:InitHeroList()
    -- 预制体
    local prefab = Api.LoadImmediately("UI/Panels/PickHeroPanel/HeroItem.prefab", AssetType.Prefab)
	-- 实例化卡牌
	for _, v in pairs(ownedHeros) do
		if v.n32Quality > 0 then
			if self.HeroList[v.n32SeriId] == nil then
				local si = { }
				self.HeroList[v.n32SeriId] = si
				-- 英雄信息
				si.heroInfo = v
				-- GameObject对象
				si.go = GameObject.Instantiate(Api.AsObject(prefab))
				si.go.transform:SetParent(content)
				si.go.transform.localScale = Vector3.one
				si.go.transform.localEulerAngles = Vector3.zero
				si.icon = si.go.transform:Find("IconMask/Icon"):GetComponent(Image)
				si.qualitySprite = si.go.transform:Find("Edge"):GetComponent(Image)
				si.nameLabel = si.go.transform:Find("NameBg/NameLabel"):GetComponent(Text)
				si.influenceIcon = si.go.transform:Find("InfluenceIcon"):GetComponent(Image)
				si.typeIcon = si.go.transform:Find("TypeIcon"):GetComponent(Image)
				si.light = si.go.transform:Find("Light").gameObject
				si.listener = si.go:GetComponent(UIButton)
				
				si.listener.onClick:AddListener(function()
					if not PickHeroPanel.sure then
						Api.PickHero(si.heroInfo.id)
						Confirme = true
					end
				end)
				
				function si:LoseFocus()
					si.light:SetActive(false)
				end
				
				function si:GetFocus()
					si.light:SetActive(true)
				end
				
				function si:Update(info)
					si.heroInfo = info
					si.icon.sprite = Api.LoadImmediately(si.heroInfo.szModelIcon, AssetType.Sprite)
					if si.heroInfo.n32Color == 1 then
						si.qualitySprite.sprite = Api.LoadImmediately("UI/Textures/Common/edge_white.png", AssetType.Sprite)
					elseif si.heroInfo.n32Color == 2 then
						si.qualitySprite.sprite = Api.LoadImmediately("UI/Textures/Common/edge_green.png", AssetType.Sprite)
					elseif si.heroInfo.n32Color == 3 then
						si.qualitySprite.sprite = Api.LoadImmediately("UI/Textures/Common/edge_blue.png", AssetType.Sprite)
					elseif si.heroInfo.n32Color == 4 then
						si.qualitySprite.sprite = Api.LoadImmediately("UI/Textures/Common/edge_purple.png", AssetType.Sprite)
					elseif si.heroInfo.n32Color == 5 then
						si.qualitySprite.sprite = Api.LoadImmediately("UI/Textures/Common/edge_orange.png", AssetType.Sprite)
					end
					si.nameLabel.text = si.heroInfo.szName
					
					if si.heroInfo.n32Camp == 1 then
						si.influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/H.png", AssetType.Sprite)
					elseif si.heroInfo.n32Camp == 2 then
						si.influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/l.png", AssetType.Sprite)
					elseif si.heroInfo.n32Camp == 4 then
						si.influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/R.png", AssetType.Sprite)
					end
					
					if si.heroInfo.n32MainAtt == 1 then
						si.typeIcon.sprite = Api.LoadImmediately("UI/Textures/Common/liliang.png", AssetType.Sprite)
					elseif si.heroInfo.n32MainAtt == 2 then
						si.typeIcon.sprite = Api.LoadImmediately("UI/Textures/Common/mingjie.png", AssetType.Sprite)
					elseif si.heroInfo.n32MainAtt == 3 then
						si.typeIcon.sprite = Api.LoadImmediately("UI/Textures/Common/zhili.png", AssetType.Sprite)
					end
				end
				
				si:Update(si.heroInfo)
				si:LoseFocus()

				-- 添加到HeroList
				-- table.insert(self.HeroList, si)
			else
				self.HeroList[v.n32SeriId]:Update(v)
			end
		end
	end

    -- 已经被选的卡牌
    self.SelectedList = { }

    -- 添加英雄选择监听
    MessageManager.AddListener(MsgType.SelectedHero, function(obj)
        local account, heroId = obj[0], obj[1]
		local sid = math.floor(tonumber(heroId) / 100)
        self.SelectedList[account] = sid
		
		if account == Account.accountId then
			Confirme = true
			preItem = curItem
			curItem = self.HeroList[sid]
			if preItem then preItem:LoseFocus() end
			if curItem then curItem:GetFocus() end
		end

		for k, v in pairs(self.HeroList) do
			v.go.transform:Find("IconMask/Icon"):GetComponent(Image).material = nil
		end
		
		for k, v in pairs(self.SelectedList) do
			if k ~= Account.accountId then
				self.HeroList[v].go.transform:Find("IconMask/Icon"):GetComponent(Image).material = Api.GreyMat
			end
		end
		
		local isOwn = true
		local cl = matchData:GetColor(Account.accountId)
		if account ~= Account.accountId then
			if cl < 4 and matchData:GetColor(account) < 4 then
				isOwn = true
			elseif cl > 3 and matchData:GetColor(account) > 3 then
				isOwn = true
			else
				isOwn = false
			end
		end
		
        self:AddPlayer(account, tonumber(heroId), isOwn)
    end )
end

------------------------------------------
function PickHeroPanel:Start()
    this = PickHeroPanel.this
    transform = PickHeroPanel.transform
    gameObject = PickHeroPanel.gameObject
	
	self:Init()
    self:InitHeroList()

    self.sure = false

    transform:Find("SureButton"):GetComponent(Button).onClick:AddListener( function()
        if curItem == nil then
            Debug.LogWarning("curItem is nil !!!")
            return
        end
		
        if self.sure then return end

        -- 确定按钮点击
        Api.ConfirmHero()
        buttonImage.material = Api.GreyMat
        self.sure = true
		for _, v in pairs(PickHeroPanel.HeroList) do
			v.listener.enabled = false
		end
    end )
	
end

function PickHeroPanel:Update()
	if this.isOpen then
		self:CountDown()
	end
end

-- 每次打开的时候调用
function PickHeroPanel:OnOpen(args)
	matchData = args[1]
    leftTime = totalTime
    self.sure = false
	buttonImage.material = nil
	for k, v in pairs(Own) do
		v:Reset()
		Opposite[k]:Reset()
	end
	if preItem then preItem:LoseFocus() end
	if curItem then curItem:LoseFocus() end
	for _, v in pairs(PickHeroPanel.HeroList) do
		v.listener.enabled = true
		v.go.transform:Find("IconMask/Icon"):GetComponent(Image).material = nil
	end
	Confirme = false
end

function PickHeroPanel:OnClose()
	self.SelectedList = { }
end

return PickHeroPanel
