local SkillInfoDialog = {}

local this
local transform
local gameObject

local info							-- 技能信息类
local nextInfo						-- 技能信息类（下一等级）
local sInfo							-- 技能信息类（服务器下发）

local skillNameLabel
local icon
local levelLabel
local progress
local fg
local fullLevel
local deltaLabel
local starContent
local influenceImage
local tagLabel
local mpLabel
local cdLabel
local desLabel
local effectLabel1, effectLabel2
local upgradeButtonImage
local buttonLabel

function SkillInfoDialog:Start()
	this = SkillInfoDialog.this
	transform = SkillInfoDialog.transform
	gameObject = SkillInfoDialog.gameObject
	skillNameLabel = transform:Find("Title"):GetComponent(Text)
	icon = transform:Find("IconMask/Icon"):GetComponent(Image)
	levelLabel = transform:Find("Slider/LevelBg/LevelLabel"):GetComponent(Text)
	progress = transform:Find("Slider"):GetComponent(Slider)
	fg = progress.transform:Find("Fg"):GetComponent(Image)
	fullLevel = transform:Find("Slider/Fg/FullLevel")
	deltaLabel = progress.transform:Find("DeltaLabel"):GetComponent(Text)
	starContent = transform:Find("Rect/StarContent")
	influenceImage = transform:Find("Rect/InfluenceImage"):GetComponent(Image)
	tagLabel = transform:Find("Rect/TagLabel"):GetComponent(Text)
	mpLabel = transform:Find("Attribute/Magic/Bg/Text"):GetComponent(Text)
	cdLabel = transform:Find("Attribute/CD/Bg/Text"):GetComponent(Text)
	desLabel = transform:Find("Content/Des/InfoLabel"):GetComponent(Text)
	effectLabel1 = transform:Find("Content/Effect/EffectLabel"):GetComponent(Text)
	effectLabel2 = transform:Find("Content/NextEffect/EffectLabel"):GetComponent(Text)
	upgradeButtonImage = transform:Find("UpgradeButton"):GetComponent(Image)
	buttonLabel = transform:Find("UpgradeButton/Text"):GetComponent(Text)
	
	-- 升级按钮点击监听
	upgradeButtonImage:GetComponent(Button).onClick:AddListener(function()
		if sInfo then
			if info.n32Upgrade < 9 then
				SystemLogic.strengthSkill(sInfo.uuid)
			else
				MessageBox.Instance:OpenText("已达最高等级!", Color.white, 0.5, MessageBoxPos.Middle)
				--SystemLogic.fuseSkill(sInfo.uuid)
			end
		else
			MessageBox.Instance:OpenText("未获得的技能!", Color.red, 0.5, MessageBoxPos.Middle)
		end
	end)
	
	-- 升级成功监听
	MessageManager.AddListener(MsgType.IntensifySkill, function(uuid)
		if sInfo then
			if sInfo.uuid == uuid then
				sInfo = AgentData.Instance:GetSkillDataBySerId(info.n32SeriId)
				info = ConfigReader.GetSkillDataInfo(sInfo.dataId)
				SkillInfoDialog:UpdateUI()
				levelLabel.transform.localScale = Vector3.one * 0.5
				local tweener = Tween.DOScale(levelLabel.transform, 1, 0.7)
				TweenSetting.SetEase(tweener, Ease.OutElastic)
				Api.ShowScreenEffect("effect/ui/ui_kapai.prefab", icon.transform.position, true, 2)
			end
		end
	end)
end

function SkillInfoDialog:OnDestroy()

end

function SkillInfoDialog:OnOpen(args)
	if #args < 1 then
		Debug.LogError("SkillInfoDialog/OnOpen(args)->参数不全")
		return
	end
	info = args[1]
	sInfo = AgentData.Instance:GetSkillDataBySerId(info.n32SeriId)
	self:UpdateUI()
end

function SkillInfoDialog:OnClose()
	StopFullLevel(fullLevel)
end

function SkillInfoDialog:UpdateUI()
	nextInfo = ConfigReader.GetSkillDataInfo(info.id + 1)
	skillNameLabel.text = info.szName
	tagLabel.text = info.szLabel
	icon.sprite = Api.LoadImmediately(info.szIcon, AssetType.Sprite)
	levelLabel.text = info.n32Upgrade + 1
	effectLabel1.text = info.szDescribe
	mpLabel.text = info.n32MpCost
	cdLabel.text = info.n32CD
	if sInfo then
		if sInfo.count >= info.n32NeedStuff then
			progress.value = 1
		else
			progress.value = sInfo.count / info.n32NeedStuff
		end
		if sInfo.count >= info.n32NeedStuff and info.n32Upgrade < 9 then
			PlayFullLevel(fullLevel)
			Api.Load("UI/Textures/Common/Lvjintu.png", AssetType.Sprite, function(s)
				fg.sprite = s
			end)
		else
			StopFullLevel(fullLevel)
			Api.Load("UI/Textures/Common/jingdutiao.png", AssetType.Sprite, function(s)
				fg.sprite = s
			end)
		end
		if info.n32NeedStuff == 0 then
			deltaLabel.text = sInfo.count .. "/~"
		else
			deltaLabel.text = sInfo.count .. "/" .. info.n32NeedStuff
		end
		upgradeButtonImage.material = nil
	else
		progress.value = 0
		--fullLevelGo:SetActive(false)
		deltaLabel.text = "0/" .. info.n32NeedStuff
		upgradeButtonImage.material = Api.GreyMat
	end
	-- 星级显示
	for i = 0, starContent.childCount - 1 do
		local go = starContent:GetChild(i).gameObject
		go:SetActive(i <= info.n32Quality)
	end
	
	-- 势力显示
	if info.n32Faction == 1 then
		influenceImage.sprite = Api.LoadImmediately("UI/Textures/Common/H.png", AssetType.Sprite)
	elseif info.n32Faction == 2 then
		influenceImage.sprite = Api.LoadImmediately("UI/Textures/Common/l.png", AssetType.Sprite)
	elseif info.n32Faction == 4 then
		influenceImage.sprite = Api.LoadImmediately("UI/Textures/Common/R.png", AssetType.Sprite)
	end
	influenceImage:SetNativeSize()
	
	-- 技能描述
	desLabel.text = info.szInfo
	
	if nextInfo then
		effectLabel2.text = nextInfo.szDescribe
		buttonLabel.text = "升级"
		upgradeButtonImage.material = nil
	else
		effectLabel2.text = "已达最高等级"
		buttonLabel.text = "已达最高等级"
		upgradeButtonImage.material = Api.GreyMat
	end
end

return SkillInfoDialog
