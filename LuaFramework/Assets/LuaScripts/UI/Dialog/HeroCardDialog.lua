local HeroCardDialog = {}

local this
local transform
local gameObject

local titleLabel
local iconContent
local progress
local fg
local fullLevel
local deltaLabel
local levelLabel
local influenceIcon
local typeLabel
local remainLabel
local priceLabel
local buttonImage
local button

local shopInfo,propInfo, heroInfo, buyNum, remainNum, index
local own, heroData

function HeroCardDialog:Start()
	this = HeroCardDialog.this
	transform = HeroCardDialog.transform
	gameObject = HeroCardDialog.gameObject
	titleLabel = transform:Find("Title"):GetComponent(Text)
	iconContent = transform:Find("IconContent")
	progress = transform:Find("Progress"):GetComponent(Slider)
	deltaLabel = transform:Find("Progress/DeltaLabel"):GetComponent(Text)
	levelLabel = transform:Find("Progress/LevelBg/Text"):GetComponent(Text)
	influenceIcon = transform:Find("Content/InfluenceIcon"):GetComponent(Image)
	typeLabel = transform:Find("Content/TypeLabel"):GetComponent(Text)
	remainLabel = transform:Find("RemainText"):GetComponent(Text)
	priceLabel = transform:Find("SureButton/Text"):GetComponent(Text)
	fg = transform:Find("Progress/Fg"):GetComponent(Image)
	fullLevel = transform:Find("Progress/Fg/FullLevel")
	buttonImage = transform:Find("SureButton"):GetComponent(Image)
	button = transform:Find("SureButton"):GetComponent(Button)
	button.onClick:AddListener(function()
		SystemLogic.Instance:buyItem(shopInfo.id, 1)
	end)
	
    -- 卡牌剩余购买次数刷新监听
    MessageManager.AddListener(MsgType.RefreshShopRemainingCardNum, function(str)
		if this.isOpen then
			if str.index == index then
				remainNum 	= 	shopInfo.n32Limit - str.value
				buyNum = str.value
				self:UpdateUI()
			end
		end
    end )
	
    -- 已拥有卡牌数量更新监听
    MessageManager.AddListener(MsgType.UpdateHeroData, function(p)
		if this.isOpen then
			self:UpdateUI()
		end
    end )
	
    -- 倒计时刷新监听
    MessageManager.AddListener(MsgType.UpdateShopCd, function(s)
		if this.isOpen then
			this:OnClose()
			MessageBox.Instance:OpenText("信息已过时!", Color.cyan, 1, MessageBoxPos.Middle)
		end
    end )
end

function HeroCardDialog:OnOpen(args)
	local co = coroutine.create(function()
		Yield(WaitForEndOfFrame())
		shopInfo	=	args[1]
		propInfo 	= 	args[2]
		buyNum	 	= 	args[3]
		index	 	=	args[4]
		remainNum 	= 	shopInfo.n32Limit - buyNum
		heroInfo	=	ConfigReader.GetHeroInfo(propInfo.n32Retain1)
		self:UpdateUI()
	end)
	coroutine.resume(co)
end

function HeroCardDialog:UpdateUI()
	titleLabel.text = shopInfo.szName
	if remainNum <= 0 then
		button.enabled = false
		buttonImage.material = Api.GreyMat
	else
		button.enabled = true
		buttonImage.material = nil
	end
	Api.Load(shopInfo.szIcon, AssetType.Sprite, function(s)
		for v in Slua.iter(iconContent) do
			v:Find("Icon"):GetComponent(Image).sprite = s
		end
	end)
	own, heroData = Api.HasHero(heroInfo.id)
	if own then
		heroInfo = ConfigReader.GetHeroInfo(heroData.dataId)
		progress.value = heroData.count / heroInfo.n32WCardNum
		deltaLabel.text = heroData.count .. "/" .. heroInfo.n32WCardNum
		if progress.value >= 1 and heroInfo.n32Quality < 25 then
			PlayFullLevel(fullLevel)
			fg.sprite = Api.LoadImmediately("UI/Textures/Common/Lvjintu.png", AssetType.Sprite)
		else
			StopFullLevel(fullLevel)
			fg.sprite = Api.LoadImmediately("UI/Textures/Common/jingdutiao.png", AssetType.Sprite)
		end
	else
		progress.value = 0
		deltaLabel.text = "0/" .. heroInfo.n32WCardNum
		StopFullLevel(fullLevel)
	end
	levelLabel.text = heroInfo.n32Quality
	if heroInfo.n32MainAtt == 1 then
		typeLabel.text = "力量"
	elseif heroInfo.n32MainAtt == 2 then
		typeLabel.text = "智力"
	elseif heroInfo.n32MainAtt == 3 then
		typeLabel.text = "敏捷"
	end
	remainLabel.text = "本次还可购买" .. "<size=70>" .. "<color=orange>" .. remainNum .. "</color>" .. "</size>" .. "张"
	local price = shopInfo.n32Price * (buyNum + 1)
	priceLabel.text = price
	if Account.gold >= price then priceLabel.color = Color.white else priceLabel.color = Color.red end
	
	if heroInfo.n32Camp == 1 then
		influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/H.png", AssetType.Sprite)
	elseif heroInfo.n32Camp == 2 then
		influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/l.png", AssetType.Sprite)
	elseif heroInfo.n32Camp == 4 then
		influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/R.png", AssetType.Sprite)
	end
	influenceIcon:SetNativeSize()
end

function HeroCardDialog:OnClose()
	StopFullLevel(fullLevel)
end

function HeroCardDialog:OnDestroy()

end

return HeroCardDialog
