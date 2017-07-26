local HeroInfoDialog = { }

local this
local transform
local gameObject

local titleLabel
local heroName
local icon, edge
local upgradeSlider
local progressImage
local upgradeButton
local buttonImage
local buttonLabel
local upgradeLabel
local qualityLabel
local influenceImage
local typeImage
local introduceLabel
local lifeLabel
local mpLabel
local attackLabel
local attackDistanceLabel
local agilityLabel
local mentalityLabel
local skillName
local skillIcon
local skillDes
local levelLabel
local coinLabel
local fullLevel

local heroInfo
local own, heroData

function HeroInfoDialog:Start()
    this = HeroInfoDialog.this
    transform = HeroInfoDialog.transform
    gameObject = HeroInfoDialog.gameObject

	titleLabel = transform:Find("NameBg/Text"):GetComponent(Text)
    heroName = transform:Find("Title"):GetComponent(Text)
    icon = transform:Find("IconMask/Icon"):GetComponent(Image)
	edge = transform.transform:Find("Edge"):GetComponent(Image)
    upgradeSlider = transform:Find("Slider"):GetComponent(Slider)
	progressImage = transform:Find("Slider/Fg"):GetComponent(Image)
    upgradeLabel = transform:Find("Slider/DeltaLabel"):GetComponent(Text)
    qualityLabel = transform:Find("Rect/QualityLabel"):GetComponent(Text)
	influenceImage = transform:Find("Rect/InfluenceImage"):GetComponent(Image)
    typeImage = transform:Find("Rect/TypeImage"):GetComponent(Image)
    introduceLabel = transform:Find("StoryTag/StoryLabel"):GetComponent(Text)
    lifeLabel = transform:Find("Attribute/Life/Bg/Text"):GetComponent(Text)
    mpLabel = transform:Find("Attribute/Magic/Bg/Text"):GetComponent(Text)
    attackLabel = transform:Find("Attribute/Energy/Bg/Text"):GetComponent(Text)
    attackDistanceLabel = transform:Find("Attribute/AttackDistance/Bg/Text"):GetComponent(Text)
    agilityLabel = transform:Find("Attribute/Agility/Bg/Text"):GetComponent(Text)
    mentalityLabel = transform:Find("Attribute/Mentality/Bg/Text"):GetComponent(Text)
    skillName = transform:Find("EffectTag/SkillName"):GetComponent(Text)
	skillIcon = transform:Find("EffectTag/IconMask/Icon"):GetComponent(Image)
    skillDes = transform:Find("EffectTag/SkillDesLabel"):GetComponent(Text)
	levelLabel = transform:Find("Slider/LevelBg/LevelLabel"):GetComponent(Text)
	coinLabel = transform:Find("UpgradeButton/PriceLabel"):GetComponent(Text)
	upgradeButton = transform:Find("UpgradeButton"):GetComponent(Button)
	buttonImage = transform:Find("UpgradeButton"):GetComponent(Image)
	buttonLabel = transform:Find("UpgradeButton/Text"):GetComponent(Text)
	fullLevel = transform:Find("Slider/Fg/FullLevel")

    upgradeButton.onClick:AddListener( function()
        if own then
            SystemLogic.Instance:UpgradeCardColorLevel(heroData.uuid)
        else
            MessageBox.Instance:OpenText("未获得的英雄!", Color.red, 0.5, MessageBoxPos.Middle)
        end
    end )
	
	transform:Find("ConfigSkillButton"):GetComponent(Button).onClick:AddListener(function()
		if own then
			DialogManager.Instance:Open("HeroSkillInfoDialog", heroInfo, heroData)
		else
			MessageBox.Instance:OpenText("没有获得的英雄!", Color.red, 0.5, MessageBoxPos.Middle)
		end
	end)

    -- 已拥有卡牌数量更新监听
    MessageManager.AddListener(MsgType.UpdateHeroData, function(p)
        for v in Slua.iter(p) do
            if heroData and v.value.uuid == heroData.uuid then
				heroData = v.value
				heroInfo = ConfigReader.GetHeroInfo(v.value.dataId)
				self:UpdateUI()
			end
        end
    end )
	
	-- 英雄升级监听
	MessageManager.AddListener(MsgType.UpgradeCard, function(id)
		heroInfo = ConfigReader.GetHeroInfo(id)
		HeroInfoDialog:UpdateUI()
        levelLabel.transform.localScale = Vector3.one * 0.5
        local tweener = Tween.DOScale(levelLabel.transform, 1, 0.7)
        TweenSetting.SetEase(tweener, Ease.OutElastic)
		Api.ShowScreenEffect("effect/ui/ui_kapai.prefab", icon.transform.position, true, 2)
	end)

    -- 当前登录的账号信息
    MessageManager.AddListener(MsgType.UpdateAccountData, function(data)
        this:SetGlobalValue("Account", data)
		self:UpdateUI()
    end )
end

function HeroInfoDialog:OnOpen(...)
    local t = ...
    heroInfo = t[1]
	self:UpdateUI()
end

function HeroInfoDialog:OnClose()
	StopFullLevel(fullLevel)
end

function HeroInfoDialog:UpdateUI()
    own, heroData = Api.HasHero(heroInfo.id)
    if own then
		heroInfo = ConfigReader.GetHeroInfo(heroData.dataId)
		if heroData.count >= heroInfo.n32WCardNum then
			upgradeSlider.value = 1
		else
			upgradeSlider.value = heroData.count / heroInfo.n32WCardNum
		end
		if heroInfo.n32WCardNum == 0 then
			upgradeLabel.text = heroData.count .. "/~"
		else
			upgradeLabel.text = heroData.count .. "/" .. heroInfo.n32WCardNum
		end
		if heroData.count >= heroInfo.n32WCardNum then
			Api.Load("UI/Textures/Common/Lvjintu.png", AssetType.Sprite, function(s)
				progressImage.sprite = s
			end)
			PlayFullLevel(fullLevel)
			buttonImage.material = nil
		else
			Api.Load("UI/Textures/Common/jingdutiao.png", AssetType.Sprite, function(s)
				progressImage.sprite = s
			end)
			StopFullLevel(fullLevel)
			buttonImage.material = Api.GreyMat
		end
    else
        upgradeSlider.value = 0
        upgradeLabel.text = "0/" .. heroInfo.n32WCardNum
		buttonImage.material = Api.GreyMat
    end
	
    heroName.text = heroInfo.szName
	titleLabel.text = heroInfo.szName
	qualityLabel.text = quest.IllustrationContent.HeroQuality[heroInfo.n32Color]
	local qualityName = ""
    if heroInfo.n32Color == 1 then
        qualityLabel.color = Color.white
        qualityName = "edge_white.png"
    elseif heroInfo.n32Color == 2 then
        qualityLabel.color = Color.green
        qualityName = "edge_green.png"
    elseif heroInfo.n32Color == 3 then
        qualityLabel.color = Color.blue
        qualityName = "edge_blue.png"
    elseif heroInfo.n32Color == 4 then
        qualityLabel.color = Color(150 / 255, 0, 1, 1)
        qualityName = "edge_purple.png"
    elseif heroInfo.n32Color == 5 then
        qualityLabel.color = Color(1, 125 / 255, 0)
        qualityName = "edge_orange.png"
    end
	edge.sprite = Api.LoadImmediately("UI/Textures/Common/" .. qualityName, AssetType.Sprite)
	
	if heroInfo.n32Camp == 1 then
		influenceImage.sprite = Api.LoadImmediately("UI/Textures/Common/H.png", AssetType.Sprite)
	elseif heroInfo.n32Camp == 2 then
		influenceImage.sprite = Api.LoadImmediately("UI/Textures/Common/l.png", AssetType.Sprite)
	elseif heroInfo.n32Camp == 4 then
		influenceImage.sprite = Api.LoadImmediately("UI/Textures/Common/R.png", AssetType.Sprite)
	end
	influenceImage:SetNativeSize()
	
    if heroInfo.n32MainAtt == 1 then
        typeImage.sprite = Api.LoadImmediately("UI/Textures/Common/liliang.png", AssetType.Sprite)
    elseif heroInfo.n32MainAtt == 2 then
        typeImage.sprite = Api.LoadImmediately("UI/Textures/Common/mingjie.png", AssetType.Sprite)
    elseif heroInfo.n32MainAtt == 3 then
        typeImage.sprite = Api.LoadImmediately("UI/Textures/Common/zhili.png", AssetType.Sprite)
    end
	typeImage:SetNativeSize()

    lifeLabel.text = heroInfo.n32Hp
    mpLabel.text = heroInfo.n32Mp
    attackLabel.text = heroInfo.n32Attack
    attackDistanceLabel.text = heroInfo.n32AttackRange
    agilityLabel.text = heroInfo.n32Agility .. " (<color=#00FF8AFF>+" .. string.format("%.1f", heroInfo.n32LAgility) .. "</color>)"
    mentalityLabel.text = heroInfo.n32Intelligence .. " (<color=#00FF8AFF>+" .. string.format("%.1f", heroInfo.n32LIntelligence ) .. "</color>)"
    --energyLabel.text = heroInfo.n32Strength .. " (<color=#00FF8AFF>+" .. string.format("%.1f", heroInfo.n32LStrength ) .. "</color>)"

    icon.sprite = Api.LoadImmediately(heroInfo.szModelIcon, AssetType.Sprite)

    introduceLabel.text = heroInfo.szContent

    local godSkillId = heroInfo.n32GodSkillId
    local skillInfo = ConfigReader.GetSkillDataInfo(godSkillId)
    if skillInfo then
		skillName.text = skillInfo.szName
        local skillIconName = skillInfo.szIcon
        Api.Load(skillIconName, AssetType.Sprite, function(sp)
            skillIcon.sprite = sp
        end )
        skillDes.text = skillInfo.szDescribe
    else
		skillName.text = "没有相关信息"
        Api.Load("UI/Textures/SkillIcon/hhh", AssetType.Sprite, function(sp)
            skillIcon.sprite = sp
        end )
        skillDes.text = "id为" .. tostring(heroInfo.id) .. "的英雄的GodId:" .. tostring(godSkillId) .. "没有在技能表中找到！"
    end
	
	levelLabel.text = heroInfo.n32Quality
	coinLabel.text = heroInfo.n32GoldNum
	if heroInfo.n32Quality < 25 then
		coinLabel.gameObject:SetActive(true)
		buttonLabel.text = "升级"
		buttonLabel.transform.localPosition = Vector3(0, 35, 0)
		if Account.gold >= heroInfo.n32GoldNum then
			coinLabel.color = Color.yellow
		else
			coinLabel.color = Color.red
		end
	else
		buttonLabel.text = "已达最高等级"
		buttonLabel.transform.localPosition = Vector3.zero
		coinLabel.gameObject:SetActive(false)
		buttonImage.material = Api.GreyMat
		StopFullLevel(fullLevel)
		Api.Load("UI/Textures/Common/jingdutiao.png", AssetType.Sprite, function(s)
			progressImage.sprite = s
		end)
	end
end

return HeroInfoDialog
