local HotfixPanel = class("HotfixPanel", UIBase)

local this = nil

function HotfixPanel:ctor(...)
	this = self
	
	if not Data.HotfixPanel then
		Data.HotfixPanel = {}
	end
	
	local t = this.go.transform
	this.urlInput = t:Find("URLInput"):GetComponent(UI.InputField)
	this.codeInput = t:Find("CodeInput"):GetComponent(UI.InputField)
	
	local data = Data.HotfixPanel
	
	if data.url then
		this.urlInput.text = data.url
	end
	
	if data.luaCode then
		this.codeInput.text = GameUtil.DecryptString(data.luaCode)
	end
	
	t:Find("CloseButton"):GetComponent(UI.Button).onClick:AddListener(function()
		UIManager:Close("HotfixPanel")
	end)
	t:Find("RunLocalButton"):GetComponent(UI.Button).onClick:AddListener(function()
		package.loaded["Hotfix"] = nil
		require "Hotfix"
	end)
	t:Find("RunRemoteButton"):GetComponent(UI.Button).onClick:AddListener(function()
		local url = this.urlInput.text
		if url and string.find(url, "http://") then
			local bytes = HttpHelper.Instance:Load(url)
			local str = Api.GetString(bytes)
			loadstring(str)()
			data.url = url
		end
	end)
	t:Find("RunCurrentButton"):GetComponent(UI.Button).onClick:AddListener(function()
		loadstring(this.codeInput.text)()
		data.luaCode = GameUtil.EncryptString(this.codeInput.text)
	end)
end

return HotfixPanel
