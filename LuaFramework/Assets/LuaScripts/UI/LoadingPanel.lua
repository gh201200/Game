local LoadingPanel = class("UI.Common.LoadingPanel", UIBase)

local this = nil

function LoadingPanel:ctor(...)
	this = self
end

function LoadingPanel:OnOpen(...)
	self.super:OnOpen(...)
	this.ro = this.go.transform:Find("Loading")
	this.label = this.go.transform:Find("ProgressText"):GetComponent(UI.Text)
	LuaManager.OnUpdateEvent = {"+=", self.Update}
end

function LoadingPanel:OnClose()
	LuaManager.OnUpdateEvent = {"-=", self.Update}
	-- print("LoadingPanel Close")
end

function LoadingPanel:Update()
	if this.ro then
		this.ro:Rotate(Vector3.forward, -200 * Time.deltaTime)
	end
	if this.progress then
		this.label.text = this.progress * 100 .. "%"
	end
end

return LoadingPanel
