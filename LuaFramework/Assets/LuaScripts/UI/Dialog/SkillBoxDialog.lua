local SkillBoxDialog = {}

local this
local transform
local gameObject

local titleLabel
local boxImage
local levelLabel
local itemContent
local priceLabel

local shopInfo

function SkillBoxDialog:Start()
	this = SkillBoxDialog.this
	transform = SkillBoxDialog.transform
	gameObject = SkillBoxDialog.gameObject
	titleLabel = transform:Find("Title"):GetComponent(Text)
	boxImage = transform:Find("BoxImage"):GetComponent(Image)
	levelLabel = transform:Find("BoxImage/LevelBg/Text"):GetComponent(Text)
	itemContent = transform:Find("Content")
	priceLabel = transform:Find("SureButton/Text"):GetComponent(Text)
	transform:Find("SureButton"):GetComponent(Button).onClick:AddListener(function()
		this:OnClose()
		SystemLogic.Instance:buyItem(shopInfo.id, 1)
	end)
end

function SkillBoxDialog:OnOpen(args)
	shopInfo = args[1]
	titleLabel.text = shopInfo.szName
	Api.Load(shopInfo.szIcon, AssetType.Sprite, function(s)
		boxImage.sprite = s
	end)
	levelLabel.text = Account.level .. "阶"
	priceLabel.text = shopInfo.n32Price
	if shopInfo.n32Site == 3 then
		for i = 1, 3 do
			local go = itemContent:GetChild(i - 1).gameObject
			local num = quest.Arena[Account.level].SkillCardPInfo[i]
			go:SetActive(num > 0)
			go.transform:Find("Label"):GetComponent(Text).text = "x" .. num
		end
	elseif shopInfo.n32Site == 4 then
		for i = 1, 3 do
			local go = itemContent:GetChild(i - 1).gameObject
			local num = quest.Arena[Account.level].AdvSkillCardPInfo[i]
			go:SetActive(num > 0)
			go.transform:Find("Label"):GetComponent(Text).text = "x" .. num
		end
	end
end

function SkillBoxDialog:Update()

end

function SkillBoxDialog:FixedUpdate()

end

function SkillBoxDialog:LateUpdate()

end

function SkillBoxDialog:OnDestroy()

end

return SkillBoxDialog
