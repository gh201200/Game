local SkillCardDialog = {}

local this
local transform
local gameObject

local titleLabel
local icon
local progress
local fg
local fullLevel
local deltaLabel
local levelLabel
local influenceIcon
local starContent
local remainLabel
local priceLabel
local buttonImage
local button

local shopInfo,propInfo, skillInfo, buyNum, remainNum, index
local own, skillData

function SkillCardDialog:Start()
	this = SkillCardDialog.this
	transform = SkillCardDialog.transform
	gameObject = SkillCardDialog.gameObject
	titleLabel = transform:Find("Title"):GetComponent(Text)
	icon = transform:Find("Icon/Mask/Icon"):GetComponent(Image)
	progress = transform:Find("Progress"):GetComponent(Slider)
	fg = transform:Find("Progress/Fg"):GetComponent(Image)
	fullLevel = transform:Find("Progress/Fg/FullLevel")
	deltaLabel = transform:Find("Progress/DeltaLabel"):GetComponent(Text)
	levelLabel = transform:Find("Progress/LevelBg/Text"):GetComponent(Text)
	influenceIcon = transform:Find("Content/InfluenceIcon"):GetComponent(Image)
	starContent = transform:Find("Content/Stars")
	remainLabel = transform:Find("RemainText"):GetComponent(Text)
	priceLabel = transform:Find("SureButton/Text"):GetComponent(Text)
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
    MessageManager.AddListener(MsgType.UpdataSkillData, function(p)
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

function SkillCardDialog:OnOpen(args)
	local co = coroutine.create(function()
		Yield(WaitForEndOfFrame())
		shopInfo	=	args[1]
		propInfo 	= 	args[2]
		buyNum	 	= 	args[3]
		index	 	=	args[4]
		remainNum 	= 	shopInfo.n32Limit - buyNum
		skillInfo	=	ConfigReader.GetSkillDataInfo(propInfo.n32Retain1)
		self:UpdateUI()
	end)
	coroutine.resume(co)
end

function SkillCardDialog:UpdateUI()
	titleLabel.text = skillInfo.szName
	if remainNum <= 0 then
		button.enabled = false
		buttonImage.material = Api.GreyMat
	else
		button.enabled = true
		buttonImage.material = nil
	end
	Api.Load(skillInfo.szIcon, AssetType.Sprite, function(s)
		icon.sprite = s
	end)
	own, skillData = Api.HasSkill(skillInfo.id)
	if own then
		skillInfo = ConfigReader.GetSkillDataInfo(skillData.dataId)
		progress.value = skillData.count / skillInfo.n32NeedStuff
		deltaLabel.text = skillData.count .. "/" .. skillInfo.n32NeedStuff
		if progress.value >= 1 and skillInfo.n32Upgrade < 9 then
			PlayFullLevel(fullLevel)
			fg.sprite = Api.LoadImmediately("UI/Textures/Common/Lvjintu.png", AssetType.Sprite)
		else
			StopFullLevel(fullLevel)
			fg.sprite = Api.LoadImmediately("UI/Textures/Common/jingdutiao.png", AssetType.Sprite)
		end
	else
		progress.value = 0
		deltaLabel.text = "0/" .. skillInfo.n32NeedStuff
		StopFullLevel(fullLevel)
	end
	levelLabel.text = skillInfo.n32Upgrade
	for i = 0, starContent.childCount - 1 do
		local go = starContent:GetChild(i).gameObject
		-- Debug.LogError(i .. skillInfo.szName .. skillInfo.n32Quality)
		go:SetActive(i <= skillInfo.n32Quality)
	end
	remainLabel.text = "本次还可购买" .. "<size=70>" .. "<color=orange>" .. remainNum .. "</color>" .. "</size>" .. "张"
	local price = shopInfo.n32Price * (buyNum + 1)
	priceLabel.text = price
	
	if Account.gold >= price then priceLabel.color = Color.white else priceLabel.color = Color.red end
	
	if skillInfo.n32Faction == 1 then
		influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/H.png", AssetType.Sprite)
	elseif skillInfo.n32Faction == 2 then
		influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/l.png", AssetType.Sprite)
	elseif skillInfo.n32Faction == 4 then
		influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/R.png", AssetType.Sprite)
	end
	influenceIcon:SetNativeSize()
end

function SkillCardDialog:OnClose()
	StopFullLevel(fullLevel)
end

function SkillCardDialog:OnDestroy()

end

return SkillCardDialog
