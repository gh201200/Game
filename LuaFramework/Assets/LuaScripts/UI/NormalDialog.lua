local NormalDialog = class("NormalDialog", UIBase)

local this = nil

function NormalDialog:ctor(...)
	this = self
	local t = this.go.transform
	this.titleLabel = t:Find("TitleLabel"):GetComponent(UI.Text)
	this.contentLabel = t:Find("View/Content"):GetComponent(UI.Text)
	this.button1 = t:Find("Button1"):GetComponent(UI.Button)
	this.button1Label = t:Find("Button1/Text"):GetComponent(UI.Text)
	this.button2 = t:Find("Button2"):GetComponent(UI.Button)
	this.button2Label = t:Find("Button2/Text"):GetComponent(UI.Text)
	this.sr = t:Find("View"):GetComponent(UI.ScrollRect)
end

local function Close()
	UIManager:Close("NormalDialog")
end

function NormalDialog:OnOpen(args)
	local title, content, button1Str, cb1, button2Str, cb2 = args[1], args[2], args[3], args[4], args[5], args[6]
	if not title or not content then
		Debug.LogError("参数错误!")
		return
	end
	
	this.titleLabel.text = title
	this.contentLabel.text = content
	
	this.sr.verticalNormalizedPosition = 1
	
	local twoButton = button1Str and button2Str
	
	if twoButton then
		this.button1.transform.gameObject:SetActive(true)
		this.button2.transform.gameObject:SetActive(true)
		this.button1.transform.localPosition = Vector2(-150, -155)
		this.button2.transform.localPosition = Vector2(150, -155)
	else
		this.button1.transform.gameObject:SetActive(true)
		this.button2.transform.gameObject:SetActive(false)
		this.button1.transform.localPosition = Vector2(0, -155)
	end
	
	if button1Str then
		this.button1Label.text = button1Str		
	else
		this.button1Label.text = "确定"
	end
	
	if cb1 then
		this.button1.onClick:AddListener(cb1)
	else
		this.button1.onClick:AddListener(Close)
	end
	
	if button2Str then
		this.button2Label.text = button2Str		
	else
		this.button2Label.text = "取消"
	end
	
	if cb2 then
		this.button2.onClick:AddListener(cb2)
	else
		this.button2.onClick:AddListener(Close)
	end
end

return NormalDialog
