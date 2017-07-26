local ServerSelectDialog = {}

local this
local transform
local gameObject

local curServerLabel
local content

local preServerInfo = nil
local curServerInfo = nil

local pre = Api.LoadImmediately("UI/Dialog/ServerSelectDialog/ServerItem.prefab", AssetType.Prefab)

local serverList = { }

function ServerSelectDialog:Start()
	this = ServerSelectDialog.this
	transform = ServerSelectDialog.transform
	gameObject = ServerSelectDialog.gameObject
	this.enableTween = false
	curServerLabel = transform:Find("CurServerLabel"):GetComponent(Text)
	content = transform:Find("ServerList/Content")
	
	for v in Slua.iter(Api.GetItems(ServerInfo)) do
		local si = { }
		si.info = v
		si.go = GameObject.Instantiate(pre)
		si.go.transform:SetParent(content)
		si.go.transform.localScale = Vector3.one
		si.go.transform.localEulerAngles = Vector3.zero
		si.bgImage = si.go:GetComponent(Image)
		si.nameLabel = si.go.transform:Find("NameLabel"):GetComponent(Text)
		si.nameLabel.text = "<color=cyan>" .. v.szName .. "</color>" .. " " .. v.szIp
		si.go:AddComponent(ClickAnimation)
		si.listener = si.go:GetComponent(UIButton)
		
		si.listener.onClick:AddListener(function()
			curServerLabel.text = si.nameLabel.text
			preServerInfo = curServerInfo
			curServerInfo = si
			if preServerInfo then
				preServerInfo:LoseFocus()
			end
			if curServerInfo then
				curServerInfo:GetFocus()
			end
			MessageManager.HandleMessage(MsgType.ChangeServer, si.info)
			this:OnClose()
		end)
		
		function si:GetFocus()
			si.bgImage.sprite = Api.LoadImmediately("UI/Textures/Login/anniu2.png", AssetType.Sprite)
		end
		
		function si:LoseFocus()
			si.bgImage.sprite = Api.LoadImmediately("UI/Textures/Login/anniu.png", AssetType.Sprite)
		end
		
		serverList[si.info.id] = si
	end
end

function ServerSelectDialog:OnOpen(args)
	if curServerInfo == nil then
		local id = -1
		for k, v in pairs(serverList) do
			id = k
		end
		local res = Api.GetAccount()
		if res then
			if res.serverId ~= 0 and serverList[res.serverId] then
				curServerInfo = serverList[res.serverId]
			else
				curServerInfo = serverList[id]
			end
		else
			curServerInfo = serverList[id]
		end
		curServerInfo:GetFocus()
		curServerLabel.text = "<color=cyan>" .. curServerInfo.info.szName .. "</color>" .. " " .. curServerInfo.info.szIp
	end
end

function ServerSelectDialog:Update()

end

function ServerSelectDialog:FixedUpdate()

end

function ServerSelectDialog:LateUpdate()

end

function ServerSelectDialog:OnDestroy()

end

return ServerSelectDialog
