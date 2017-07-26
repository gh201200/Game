local ReenterGameDialog = {}

local this
local transform
local gameObject

local contentLabel, timeLabel
local sureButton

local totalTime = 15
local timer = totalTime

function ReenterGameDialog:Start()
	this = ReenterGameDialog.this
	transform = ReenterGameDialog.transform
	gameObject = ReenterGameDialog.gameObject
	contentLabel = transform:Find("Content/ContentLabel"):GetComponent(Text)
	timeLabel = transform:Find("Content/TimeLabel"):GetComponent(Text)
	sureButton = transform:Find("SureButton"):GetComponent(Button)
	sureButton.onClick:AddListener(function()
		Api.ReenterGame()
		this:OnClose()
	end)
	transform:Find("CloseButton"):GetComponent(Button).onClick:AddListener(function()
		ReenterGameDialog.Reset()
	end)
end

function ReenterGameDialog:OnOpen(args)
	transform.parent.parent:Find("BlackBg"):GetComponent(EventListener).OnPointerDownEvent = {
		"+=", ReenterGameDialog.Reset
	}
	timer = totalTime
	print("on open", timer)
	contentLabel.text = "游戏还未结束，你可以重新连接！"
end

function ReenterGameDialog:OnClose()
	transform.parent.parent:Find("BlackBg"):GetComponent(EventListener).OnPointerDownEvent = {
		"-=", ReenterGameDialog.Reset
	}
end

function ReenterGameDialog:Update()
	if this.isOpen == false then return end
	if timer <= 0 then return end
	if timer > 0 then
		timer = timer - Time.deltaTime
	end
	if timer <= 0 then
		timer = 0
		this:OnClose()
		Api.CloseInternet()
	end
	timeLabel.text = "(" .. math.floor(timer) .. "s" .. ")"
end

function ReenterGameDialog.Reset()
	Api.CloseInternet()
	ClearAgentData()
end

return ReenterGameDialog
