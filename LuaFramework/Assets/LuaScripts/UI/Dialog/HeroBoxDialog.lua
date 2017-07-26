local HeroBoxDialog = {}

local this
local transform
local gameObject

local titleLabel
local boxImage
local levelLabel
local numLabel
local priceLabel

local shopInfo

function HeroBoxDialog:Start()
	this = HeroBoxDialog.this
	transform = HeroBoxDialog.transform
	gameObject = HeroBoxDialog.gameObject
	titleLabel = transform:Find("Title"):GetComponent(Text)
	boxImage = transform:Find("BoxImage"):GetComponent(Image)
	levelLabel = transform:Find("BoxImage/LevelBg/Text"):GetComponent(Text)
	numLabel = transform:Find("Content/NumLabel"):GetComponent(Text)
	priceLabel = transform:Find("SureButton/Text"):GetComponent(Text)
	transform:Find("SureButton"):GetComponent(Button).onClick:AddListener(function()
		this:OnClose()
		SystemLogic.Instance:buyItem(shopInfo.id, 1)
	end)
end

function HeroBoxDialog:OnOpen(args)
	shopInfo = args[1]
	titleLabel.text = shopInfo.szName
	Api.Load(shopInfo.szIcon, AssetType.Sprite, function(s)
		boxImage.sprite = s
	end)
	levelLabel.text = Account.level .. "阶"
	priceLabel.text = shopInfo.n32Price
	if shopInfo.n32Site == 1 then
		numLabel.text = "x" .. quest.Arena[Account.level].HeroPiecePInfo[1]
	elseif shopInfo.n32Site == 2 then
		numLabel.text = "x" .. quest.Arena[Account.level].AdvHeroPiecePInfo[1]
	end
end

function HeroBoxDialog:Update()

end

function HeroBoxDialog:FixedUpdate()

end

function HeroBoxDialog:LateUpdate()

end

function HeroBoxDialog:OnDestroy()

end

return HeroBoxDialog
