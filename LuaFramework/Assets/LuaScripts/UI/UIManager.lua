local UIManager = class("UI.UIManager")

local this = nil

function UIManager:ctor(...)
	this = self
	
	this.ready = false
	
	this.CacheQue = {}
	this.WaitOpenQue = {}
	this.CloseQue = {}
	
	this.canvasPath = "Prefabs/UI/Common/Canvas.prefab"
	this.eventSystemPath = "Prefabs/UI/Common/EventSystem.prefab"
	this.canvas = GameObject.Find("Canvas")
	this.eventSystem = GameObject.Find("EventSystem")
	
	if not this.eventSystem then
		AssetLoader.Instance:LoadAsync(this.eventSystemPath, AssetType.Prefab, function(obj)
			this.eventSystem = GameObject.Instantiate(obj)
			this.eventSystem.name = "EventSystem"
		end)
	end
	
	if this.canvas then
		this.ready = true
		this:CreateLayers()
	else
		AssetLoader.Instance:LoadAsync(this.canvasPath, AssetType.Prefab, function(obj)
			this.canvas = GameObject.Instantiate(obj)
			this.canvas.name = "Canvas"
			this.ready = true	
			this:CreateLayers()		
		end)
	end
		
	LuaManager.OnUpdateEvent = { "+=", this.Update }
end

function UIManager:CreateLayers()	
	for _, v in pairs(UILayer) do
		if not this.canvas.transform:Find(v.name) then
			local go = GameObject(v.name)
			go.transform:SetParent(this.canvas.transform)
			go.transform:SetSiblingIndex(v.index)
			go.layer = LayerMask.NameToLayer("UI")
			local rt = go:AddComponent(RectTransform)
			rt.localPosition = Vector3.zero
			rt.localScale = Vector3.one
			rt.localEulerAngles = Vector3.zero
			rt.anchorMin = Vector2.zero
			rt.anchorMax = Vector2.one
			rt.offsetMin = Vector2.zero
			rt.offsetMax = Vector2.zero
			this[v.name] = rt
		end
	end
end

function UIManager:Open(name, ...)
	if not name then
		Debug.LogError("打开面板失败！未传入面板名称")
		return
	end
	if not UIConfig[name] then
		Debug.LogError("未配置的面板->" .. name)
		return
	end
	local args = {...}
	this.WaitOpenQue[name] = {
		name = name,
		args = args,
	}
	this.CloseQue[name] = false
end

function UIManager:Close(name)
	if not name then
		Debug.LogError("关闭面板失败！未传入面板名称")
		return
	end
	if not UIConfig[name] then
		Debug.LogError("未配置的面板->" .. name)
		return
	end
	this.CloseQue[name] = true
end

function UIManager:IsOpen(name)
	if this.WaitOpenQue[name] then return true end
	if this.CacheQue[name] then
		return this.CacheQue[name].isOpen
	else
		return false
	end
end

function UIManager:Clear()
	for k, v in pairs(this.CacheQue) do
		v.code:OnClose()
		GameObject.Destroy(v.go)
		this.CacheQue[k] = nil
	end
end

function UIManager.Update()
	if Input.GetKeyDown(KeyCode.Q) then
		GameManager:ReturnLoginPanel()
	end
	if table.size(this.WaitOpenQue) > 0 then
		if not this:IsOpen("LoadingPanel") then
			this:Open("LoadingPanel")
		end
	else
		if this:IsOpen("LoadingPanel") then
			this:Close("LoadingPanel")
		end
	end
	if not this.ready then return end
	if table.size(this.WaitOpenQue) > 0 then
		for k, v in pairs(this.WaitOpenQue) do
			local name, args = k, v.args
			if not this.CacheQue[name] then
				local info = UIConfig[name]
				AssetLoader.Instance:LoadAsync(info.prefabPath, AssetType.Prefab, function(obj)
					local go = GameObject.Instantiate(obj)
					go.name = name
					local parent = this.canvas.transform:Find(info.layer.name)
					if not parent then
						Debug.LogError("Layer " .. info.layer.name .. " is not found!")
						return
					end
					go.transform:SetParent(parent)
					go.transform.localPosition = Vector3.zero
					go.transform.localScale = Vector3.one
					go.transform.localEulerAngles = Vector3.zero
					go.transform:SetAsLastSibling()
					go:SetActive(true)
					local code = require(info.luaPath)
					code.panelName = name
					code.isOpen = true
					code = code.new(go)
					code:OnOpen(args)
					this.CacheQue[name] = {
						name = name,
						go = go,
						code = code,
						isOpen = true,
					}
					EventManager:Dispatch(EventType.OnPanelOpen, name)
				end, function(progress)
					local temp = require "UI.LoadingPanel"
					temp.progress = progress
				end)
			else
				local info = this.CacheQue[name]
				info.isOpen = true
				info.code.isOpen = true
				info.go:SetActive(true)
				info.go.transform:SetAsLastSibling()
				info.code:OnOpen(args)
				EventManager:Dispatch(EventType.OnPanelOpen, name)
			end
			this.WaitOpenQue[name] = nil
		end
	end
	if table.size(this.CloseQue) > 0 then
		for k, v in pairs(this.CloseQue) do
			local info = this.CacheQue[k]
			if info and v == true then
				info.isOpen = false
				info.go:SetActive(false)
				info.code.isOpen = false
				info.code:OnClose()
				this.CloseQue[k] = nil
				EventManager:Dispatch(EventType.OnPanelClose, k)
			end
		end
	end
end

return UIManager.new()
