local OpenBoxPanel = { }

local this
local transform
local gameObject
local B1, B2, B3, B4, B5, B6
local box, topImage, bottomImage
local items
local prefab
local parent
local tipLabel

local openEffect

local fPos, sPos
local isDrag = false

local layout

local t = { }

local Boxs = { }

local canBack = false	-- 是否可以返回

local numberTip --购买宝箱次数的Text

function OpenBoxPanel:Start()
    this = OpenBoxPanel.this
    transform = OpenBoxPanel.transform
    gameObject = OpenBoxPanel.gameObject
	B1 = transform:Find("B1")
	B2 = transform:Find("B2")
	B3 = transform:Find("B3")
	B4 = transform:Find("B4")
	B5 = transform:Find("B5")
	B6 = transform:Find("B6")
	Boxs["B1"] = B1
	Boxs["B2"] = B2
	Boxs["B3"] = B3
	Boxs["B4"] = B4
	Boxs["B5"] = B5
	Boxs["B6"] = B6
	numberTip = transform:Find("BoxNumberTip/BoxNumber"):GetComponent(Text)
	layout = transform:Find("View/Content"):GetComponent(GridLayoutGroup)
    prefab = Api.LoadImmediately("UI/Panels/OpenBoxPanel/Item.prefab", AssetType.Prefab)
	parent = transform:Find("View/Content")
	tipLabel = transform:Find("Tip"):GetComponent(Text)
end

function OpenBoxPanel:Update()
    if Input.GetMouseButtonDown(0) then
        fPos = Input.mousePosition
		if isDrag or not canBack then return end
		UIManager.Instance:ClosePanel("OpenBoxPanel")
		UIManager.Instance.curPanel = UIManager.Instance:GetPanel("MainPanel")
		local sName = SceneManager.GetActiveScene().name
		if sName ~= "UIScene" and sName ~= "Version" then
			local s = require "SettlementPanel"
			s:ReturnMain()
		end
    end
    if Input.GetMouseButtonUp(0) then
        sPos = Input.mousePosition
        local dir = sPos - fPos
        if dir.magnitude > 1 then
            isDrag = true
        else
            isDrag = false
        end
    end
	if openEffect then
		local worldPos = Camera.main:ScreenToWorldPoint(box.position + Vector3(0, -25, 0))
		worldPos = worldPos + Camera.main.transform.forward
		openEffect.transform.position = worldPos
	end
end

function OpenBoxPanel:OnOpen(args)

	if OpenBoxId > 2000 then
		numberTip.transform.parent.gameObject:SetActive(true)
		numberTip.text = Account.buyboxtimes   --显示剩余次数
	else
		numberTip.transform.parent.gameObject:SetActive(false)
	end

	items = args[1]
	
	for _, v in pairs(t) do
		GameObject.Destroy(v.go)
		v = nil
	end
	t = { }
	
	canBack = false
	tipLabel.gameObject:SetActive(false)
	
	if OpenBoxId then
		local number = tonumber(string.sub(tostring(OpenBoxId), -1))
		if OpenBoxId > 30000 and OpenBoxId < 31000 then
			if number == 1 then
				-- 英雄宝箱
				self:Init("B4")
				topImage.sprite = Api.LoadImmediately("UI/Textures/BoxIcon/HeroBoxTop.png", AssetType.Sprite)
				bottomImage.sprite = Api.LoadImmediately("UI/Textures/BoxIcon/HeroBoxBottom.png", AssetType.Sprite)
			elseif number == 2 then
				-- 高阶英雄宝箱
				self:Init("B1")
				topImage.sprite = Api.LoadImmediately("UI/Textures/BoxIcon/AdvHeroBoxTop.png", AssetType.Sprite)
				bottomImage.sprite = Api.LoadImmediately("UI/Textures/BoxIcon/AdvHeroBoxBottom.png", AssetType.Sprite)
			end
		elseif OpenBoxId > 31000 and OpenBoxId < 32000 then
			if number == 1 then
				-- 技能宝箱
				self:Init("B5")
				topImage.sprite = Api.LoadImmediately("UI/Textures/BoxIcon/SkillBoxTop.png", AssetType.Sprite)
				bottomImage.sprite = Api.LoadImmediately("UI/Textures/BoxIcon/SkillBoxBottom.png", AssetType.Sprite)
			elseif number == 2 then
				-- 高阶技能宝箱
				self:Init("B2")
				topImage.sprite = Api.LoadImmediately("UI/Textures/BoxIcon/AdvSkillBoxTop.png", AssetType.Sprite)
				bottomImage.sprite = Api.LoadImmediately("UI/Textures/BoxIcon/AdvSkillBoxBottom.png", AssetType.Sprite)
			end
		elseif OpenBoxId == 1000 then
			-- 每日宝箱
			self:Init("B3")
		elseif OpenBoxId == 2000 then
			-- 战斗宝箱
			self:Init("B6")
		elseif OpenBoxId == 1100 then
			-- 探索宝箱
			self:Init("B4")
		end
	else
		self:Init("B3")
	end
	
	local co = coroutine.create(function()
		if this.isOpen == false then return end
		local res = Tween.DOLocalMoveY(topImage.transform, 130, 1, false)
		TweenSetting.SetEase(res, Ease.OutExpo)
		TimeManager.Instance:Do(0.8, function()
			if this.isOpen == false then return end
			Tween.DOKill(topImage.transform, false)
			local res = Tween.DOLocalMoveY(topImage.transform, 110, 1, false)
			TweenSetting.SetEase(res, Ease.InOutSine)
			TweenSetting.SetLoops(res, -1, 1)
		end)
		TimeManager.Instance:Do(0.2, function()
			if this.isOpen == false then return end
			openEffect = Api.ShowScreenEffect("effect/ui/ui_Baoxiang.prefab", box.position + Vector3(0, -25, 0), true, 0)
			local worldPos = Camera.main:ScreenToWorldPoint(box.position)
			worldPos = worldPos + Camera.main.transform.forward
			openEffect.transform.position = worldPos
			openEffect:SetActive(true)
			TimeManager.Instance:Do(1.25, function()
				if this.isOpen == false then return end
				local res = Tween.DOLocalMoveY(box, 550, 1, false)
				TweenSetting.SetEase(res, -1, 1)
				canBack = true
				tipLabel.gameObject:SetActive(true)
				local res = ShortcutExtensions46.DOFade(tipLabel, 0, 0.7)
				TweenSetting.SetLoops(res, -1, 1)
				TweenSetting.SetEase(res, Ease.InOutSine)
			end)
		end)
		Yield(WaitForSeconds(1.7))
		if this.isOpen == false then return end
		local length = table.size(items)
		if length < 4 then
			layout.spacing = Vector2(85, 45)
		else
			layout.spacing = Vector2(15, 45)
		end
		for k, v in pairs(items) do
			local si = { }
			si.info = ConfigReader.GetItemCfg(k)
			si.go = GameObject.Instantiate(prefab)
			si.icon = si.go.transform:Find("IconMask/Icon"):GetComponent(Image)
			si.nameLabel = si.go.transform:Find("IconMask/NameBg/NameLabel"):GetComponent(Text)
			si.numLabel = si.go.transform:Find("IconMask/NameBg/NumLabel"):GetComponent(Text)
			si.starContent = si.go.transform:Find("StarContent")
			si.whiteImage = si.go.transform:Find("IconMask/White"):GetComponent(Image)
			si.starContent.gameObject:SetActive(si.info.n32Type == 7)
			si.go.transform:SetParent(parent)
			si.go.transform.localPosition = Vector3.zero
			si.go.transform.localEulerAngles = Vector3.zero
			
			si.go.transform.localScale = Vector3.one * 1.5
			si.whiteImage.color = Color(1, 1, 1, 1)
			
			Tween.DOScale(si.go.transform, 1, 0.5)
			TimeManager.Instance:Do(0.05, function()
				if this.isOpen == false then return end
				ShortcutExtensions46.DOFade(si.whiteImage, 0, 0.7)
			end)
			
			si.listener = si.go:AddComponent(UIButton)
			si.go:AddComponent(ClickAnimation)
			
			-- si.listener.onClick:AddListener(function()
				-- if si.info.n32Type == 7 then
					-- DialogManager.Instance:Open("SkillInfoDialog", si.otherInfo)
				-- elseif si.info.n32Type == 3 then
					-- DialogManager.Instance:Open("HeroInfoDialog", si.otherInfo)
				-- end
			-- end)
			
			si.otherInfo = nil
			
			if si.info.n32Type == 3 then
				-- 英雄卡
				si.otherInfo = ConfigReader.GetHeroInfo(si.info.n32Retain1)
				si.nameLabel.text = si.otherInfo.szName
				si.numLabel.text = "x" .. v
				si.icon.sprite = Api.LoadImmediately(si.otherInfo.szModelIcon, AssetType.Sprite)
			elseif si.info.n32Type == 5 then
				-- 游戏外金币
				si.nameLabel.text = "金币"
				si.numLabel.text = "x" .. v
				si.icon.sprite = Api.LoadImmediately("UI/Textures/Shop/Yidaijinbi.png", AssetType.Sprite)
			elseif si.info.n32Type == 6 then
				-- 钻石
				si.nameLabel.text = "钻石"
				si.numLabel.text = "x" .. v
				si.icon.sprite = Api.LoadImmediately("UI/Textures/Shop/Yidaizuanshi.png", AssetType.Sprite)
			elseif si.info.n32Type == 7 then
				-- 技能材料
				si.otherInfo = ConfigReader.GetSkillDataInfo(si.info.n32Retain1)
				si.nameLabel.text = si.otherInfo.szName
				si.numLabel.text = "x" .. v
				
				for i = 0, si.starContent.childCount - 1 do
					local temp = si.starContent:GetChild(i)
					temp.gameObject:SetActive(si.otherInfo.n32Quality >= i)
				end
				
				si.icon.sprite = Api.LoadImmediately(si.otherInfo.szIcon, AssetType.Sprite)
			end
			t[k] = si
			Yield(WaitForSeconds(0.05))
		end
	end)
	
	TimeManager.Instance:Do(0.2, function()
		if not this.isOpen then return end
		coroutine.resume(co)
	end)
end

function OpenBoxPanel:Init(arg)
	for k, v in pairs(Boxs) do
		if k == arg then
			v.gameObject:SetActive(true)
			box = v
		else
			v.gameObject:SetActive(false)
		end
	end
	topImage = box:Find("Top"):GetComponent(Image)
	bottomImage = box:Find("Bottom"):GetComponent(Image)
end

function OpenBoxPanel:OnClose()
	if openEffect ~= nil then
		GameObject.Destroy(openEffect)
		openEffect = nil
	end
	
	Tween.DOKill(box, false)
	Tween.DOKill(topImage.transform, false)
	box.localPosition = Vector2(0, 100)
	topImage.transform.localPosition = Vector3.zero
	tipLabel.gameObject:SetActive(false)
	Tween.DOKill(tipLabel, false)
	tipLabel.color = Color(1, 1, 1, 1)
	
	for k, v in pairs(Boxs) do
		v.localPosition = Vector3(0, 100, 0)
		v:Find("Top").localPosition = Vector3(6, 0, 0)
		v.gameObject:SetActive(false)
	end
end

return OpenBoxPanel
