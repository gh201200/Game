local HeroDesDialog = {}

local this
local transform
local gameObject

local titleLabel
local heroNameLabel
local hpLabel
local powerLabel
local magicLabel
local agilityLabel
local distanceLabel
local mentalityLabel
local storyLabel

local iconImage
local influenceImage
local typeImage
local skillImage

local heroInfo

function HeroDesDialog:Start()
	this = HeroDesDialog.this
	transform = HeroDesDialog.transform
	gameObject = HeroDesDialog.gameObject
	titleLabel = transform:Find("TitleLabel"):GetComponent(Text)
	heroNameLabel = transform:Find("Head/NameBg/Text"):GetComponent(Text)
	hpLabel = transform:Find("AttributeContent/Hp/LabelBg/Text"):GetComponent(Text)
	powerLabel = transform:Find("AttributeContent/Power/LabelBg/Text"):GetComponent(Text)
	magicLabel = transform:Find("AttributeContent/Magic/LabelBg/Text"):GetComponent(Text)
	agilityLabel = transform:Find("AttributeContent/Agility/LabelBg/Text"):GetComponent(Text)
	distanceLabel = transform:Find("AttributeContent/Distance/LabelBg/Text"):GetComponent(Text)
	mentalityLabel = transform:Find("AttributeContent/Mentality/LabelBg/Text"):GetComponent(Text)
	storyLabel = transform:Find("StoryLabel"):GetComponent(Text)
	iconImage = transform:Find("Head/Mask/Icon"):GetComponent(Image)
	influenceImage = transform:Find("Frame/InfluenceIcon"):GetComponent(Image)
	typeImage = transform:Find("Frame/TypeIcon"):GetComponent(Image)
	skillImage = transform:Find("Frame/SkillIcon"):GetComponent(Image)
end

function HeroDesDialog:OnOpen(args)
	heroInfo = args[1]
	if not heroInfo then Debug.LogError("参数缺失") return end
	titleLabel.text = heroInfo.szName
	heroNameLabel.text = heroInfo.szName
	hpLabel.text = heroInfo.n32Hp
	powerLabel.text = heroInfo.n32Attack
	magicLabel.text = heroInfo.n32Mp
	agilityLabel.text = heroInfo.n32LAgility
	distanceLabel.text = heroInfo.n32AttackRange
	mentalityLabel.text = heroInfo.n32Intelligence
	storyLabel.text = heroInfo.szContent
	
	Api.Load(heroInfo.szModelIcon, AssetType.Sprite, function(s)
		iconImage.sprite = s
	end)
	
    local godSkillId = heroInfo.n32GodSkillId
    local skillInfo = ConfigReader.GetSkillDataInfo(godSkillId)
    if skillInfo then
        local skillIconName = skillInfo.szIcon
        Api.Load(skillIconName, AssetType.Sprite, function(sp)
            skillImage.sprite = sp
        end )
    else
        Api.Load("UI/Textures/SkillIcon/hhh", AssetType.Sprite, function(sp)
            skillImage.sprite = sp
        end )
    end
	
	local influenceIconName = ""
	if heroInfo.n32Camp == 1 then
	
	elseif heroInfo.n32Camp == 2 then
	
	elseif heroInfo.n32Camp == 3 then
	
	elseif heroInfo.n32Camp == 4 then
	
	end
	
	local typeIconName = ""
	if heroInfo.n32MainAtt == 1 then
		typeIconName = "liliang.png"
	elseif heroInfo.n32MainAtt == 2 then
		typeIconName = "mingjie.png"
	elseif heroInfo.n32MainAtt == 3 then
		typeIconName = "zhili.png"
	end
	Api.Load("UI/Textures/Common/" .. typeIconName, AssetType.Sprite, function(s)
		typeImage.sprite = s
	end)
end

function HeroDesDialog:Update()

end

function HeroDesDialog:FixedUpdate()

end

function HeroDesDialog:LateUpdate()

end

function HeroDesDialog:OnDestroy()

end

return HeroDesDialog
