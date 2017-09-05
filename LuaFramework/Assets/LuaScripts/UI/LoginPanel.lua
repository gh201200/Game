local LoginPanel = class("LoginPanel", UIBase)

local this = nil

function LoginPanel:ctor(...)
	this = self
	local t = this.go.transform
	this.slider = t:Find("ProgressBg"):GetComponent(UI.Slider)
	this.progressLabel = t:Find("ProgressBg/ProgressLabel"):GetComponent(UI.Text)
	this.tipLabel = t:Find("TipLabel"):GetComponent(UI.Text)	
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

local function OnCheckUpdateComplete()
	this.slider.value = 1
	this.progressLabel.text = "100%"
	this.tipLabel.text = "正在进入游戏..."
end

local function QueryUpdate(totalSize, button1Str, button2Str, button1Cb, button2Cb)
	local size = Api.GetFormatFileSize(totalSize)
	-- if totalSize < 1024 then
		-- size = string.format("%.2f", totalSize) .. "B"
	-- elseif totalSize > 1024 and totalSize < 1024 * 1024 then
		-- size = string.format("%.2f", totalSize / 1024) .. "KB"
	-- else
		-- size = string.format("%.2f", totalSize / 1024 / 1024) .. "M"
	-- end
	
	local files = {}
	for k, v in pairs(CheckUpdate.updateList) do
		table.insert(files, "<color=#61FFCAFF>" .. v.path .. "</color>")
	end
	
	UIManager:Open("NormalDialog", "更新提示", "发现新版本！大小" .. size .. "。\n" .. table.concat(files, "\n"), button1Str, function()
		button1Cb()
		UIManager:Close("NormalDialog")
	end, button2Str, button2Cb)
end

function LoginPanel:OnOpen(...)
	this.super:OnOpen(...)
	EventManager:Add(EventType.OnStartCheckUpdate, OnStartCheckUpdate)
	EventManager:Add(EventType.OnUpdating, OnUpdating)
	EventManager:Add(EventType.OnCheckUpdateComplete, OnCheckUpdateComplete)
	EventManager:Add(EventType.QueryUpdate, QueryUpdate)
end

return LoginPanel
