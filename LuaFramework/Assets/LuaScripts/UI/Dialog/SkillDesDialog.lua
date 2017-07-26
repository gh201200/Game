local SkillDesDialog = {}

local this
local transform
local gameObject

local titleLabel
-- local typeLabel
local magicLabel
local cdLabel
local infoLabel
local desLabel

local iconImage
local influenceImage
local starContent

local skillInfo

function SkillDesDialog:Start()
	this = SkillDesDialog.this
	transform = SkillDesDialog.transform
	gameObject = SkillDesDialog.gameObject
	titleLabel = transform:Find("TitleLabel"):GetComponent(Text)
	-- typeLabel = transform:Find("Frame/TypeLabel"):GetComponent(Text)
	magicLabel = transform:Find("Magic/TextBg/Text"):GetComponent(Text)
	cdLabel = transform:Find("CD/TextBg/Text"):GetComponent(Text)
	infoLabel = transform:Find("Content/DesTag/InfoLabel"):GetComponent(Text)
	desLabel = transform:Find("Content/EffectTag/EffectLabel"):GetComponent(Text)
	iconImage = transform:Find("Head/Icon"):GetComponent(Image)
	influenceImage = transform:Find("Frame/InfluenceIcon"):GetComponent(Image)
	starContent = transform:Find("Frame/StarContent")
end

function SkillDesDialog:OnOpen(args)
	skillInfo = args[1]
	if not skillInfo then Debug.LogError("参数缺失") return end
	titleLabel.text = skillInfo.szName
	-- typeLabel.text = skillInfo.szLabel
	magicLabel.text = skillInfo.n32MpCost
	cdLabel.text = skillInfo.n32CD
	infoLabel.text = skillInfo.szInfo
	desLabel.text = skillInfo.szDescribe
	Api.Load(skillInfo.szIcon, AssetType.Sprite, function(s)
		iconImage.sprite = s
	end)
	for i = 0, 2 do
		local go = starContent:GetChild(i).gameObject
		go:SetActive(i <= skillInfo.n32Quality)
	end
end

function SkillDesDialog:Update()

end

function SkillDesDialog:FixedUpdate()

end

function SkillDesDialog:LateUpdate()

end

function SkillDesDialog:OnDestroy()

end

return SkillDesDialog
