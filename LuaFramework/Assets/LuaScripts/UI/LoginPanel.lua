local LoginPanel = class("LoginPanel", UIBase)

local this = nil

function LoginPanel:ctor(...)
	this = self
	local t = this.go.transform
	this.progressGo = t:Find("Progress").gameObject
	this.loginGo = t:Find("Login").gameObject
	this.slider = t:Find("Progress/ProgressBg"):GetComponent(UI.Slider)
	this.progressLabel = t:Find("Progress/ProgressBg/ProgressLabel"):GetComponent(UI.Text)
	this.tipLabel = t:Find("Progress/TipLabel"):GetComponent(UI.Text)
end

local function OnStartCheckUpdate()
	this.slider.value = 0.01
	this.progressLabel.text = "0%"
	this.tipLabel.text = "正在检查更新..."
end

local function OnUpdating(file, curSize, totalSize)
	local progress = math.ceil((curSize / totalSize) * 100)
	this.slider.value = curSize / totalSize
	this.progressLabel.text = progress .. "%"
	this.tipLabel.text = "正在更新:" .. file.name
end

local function OnCheckUpdateComplete(needUpdate)
	this.slider.value = 1
	this.progressLabel.text = "100%"
	this.tipLabel.text = "正在进入游戏..."
	if needUpdate then
		this.progressGo:SetActive(true)
		this.loginGo:SetActive(false)
		GameManager:ReturnLoginPanel()
	else
		this.progressGo:SetActive(false)
		this.loginGo:SetActive(true)
	end
end

local function QueryUpdate(totalSize, button1Str, button2Str, button1Cb, button2Cb)
	local size = Api.GetFormatFileSize(totalSize)
	local files = {}
	for k, v in pairs(CheckUpdate.updateList) do
		table.insert(files, "<color=#61FFCAFF>" .. v.path .. "</color>" .. " - " .. "<color=#00FF01FF>" .. Api.GetFormatFileSize(tonumber(v.size)) .. "</color>")
	end	
	UIManager:Open("NormalDialog", "更新提示", "发现新版本！大小" .. "<color=#FF006EFF>" .. size .. "</color>" .. "。\n" .. table.concat(files, "\n"), button1Str, button1Cb, button2Str, button2Cb)
end

function LoginPanel:OnOpen(...)
	this.super:OnOpen(...)
	this.progressGo:SetActive(true)
	this.loginGo:SetActive(false)
	EventManager:Add(EventType.OnStartCheckUpdate, OnStartCheckUpdate)
	EventManager:Add(EventType.OnUpdating, OnUpdating)
	EventManager:Add(EventType.OnCheckUpdateComplete, OnCheckUpdateComplete)
	EventManager:Add(EventType.QueryUpdate, QueryUpdate)
end

function LoginPanel:OnClose()
	EventManager:Remove(EventType.OnStartCheckUpdate, OnStartCheckUpdate)
	EventManager:Remove(EventType.OnUpdating, OnUpdating)
	EventManager:Remove(EventType.OnCheckUpdateComplete, OnCheckUpdateComplete)
	EventManager:Remove(EventType.QueryUpdate, QueryUpdate)
end

return LoginPanel