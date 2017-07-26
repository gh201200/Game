local LoginPanel = { }

local this
local transform
local gameObject
local accountInput
local passwordInput
local sureButton
local account
local password
local accountList
local autoLoginFlag
local rememberPasswordFlag
local item
local itemParent
local serverSelectButton, curServerLabel
local serverInfo

local autoLogin = true
local rememberPassword = true

local flag = false

function LoginPanel:Start()
    -- 初始化字段
    this = LoginPanel.this
    transform = LoginPanel.transform
    gameObject = LoginPanel.gameObject
    accountInput = transform:Find("accountInput"):GetComponent(InputField)
    passwordInput = transform:Find("passwordInput"):GetComponent(InputField)
    sureButton = transform:Find("sureButton"):GetComponent(Button)
	serverSelectButton = transform:Find("ServerSelect"):GetComponent(Button)
	curServerLabel = serverSelectButton.transform:Find("Label"):GetComponent(Text)
	accountList = transform:Find("accountInput/accountList")
	item = Api.LoadImmediately("UI/Panels/LoginPanel/Item.prefab", AssetType.Prefab)
	itemParent = accountList:Find("View/Content")
	autoLoginFlag = transform:Find("AutoLoginButton/Check").gameObject
	rememberPasswordFlag = transform:Find("RememberPasswordButton/Check").gameObject
	
	MessageManager.AddListener(MsgType.ChangeServer, function(info)
		curServerLabel.text = "服务器: " .. info.szName
		serverInfo = info
		local data = Api.GetAccount()
		data.serverId = serverInfo.id
		Api.SaveAccount(data)
	end)
	
	self:Refresh()

    -- 事件监听
    accountInput.onValueChanged:AddListener( function(str)
        account = str
		local exis = false
		if str ~= "" then
			for v in Slua.iter(Api.GetLoginHistory()) do
				if string.find(v.key, account) ~= nil then exis = true end
			end
		end
		accountList.gameObject:SetActive(exis)
		if exis then
			self:Refresh(str)
		end
    end )

    passwordInput.onValueChanged:AddListener( function(str)
        password = str
		local exis = false
		for w in string.gmatch(str, "%W+") do
			exis = true
		end
		if exis then
			MessageBox.Instance:OpenText("密码只能包含数字和字母", Color.cyan, 1, MessageBoxPos.Middle)
		end
    end )
	
	for v in Slua.iter(Api.GetLoginHistory()) do
		local go = GameObject.Instantiate(item)
		go.transform:SetParent(itemParent)
		go.transform.localScale = Vector3.one
		go.transform.localEulerAngles = Vector3.zero
		-- go.transform:SetAsFirstSibling()
		go.name = v.key
		go.transform:Find("Text"):GetComponent(Text).text = v.key
		go:GetComponent(Button).onClick:AddListener(function()
			accountInput.text = v.value.account
			passwordInput.text = v.value.password
			accountList.gameObject:SetActive(false)
			self:Refresh(v.value.account)
		end)
	end
	
	transform:Find("Bg").gameObject:AddComponent(EventListener).OnPointerClickEvent = {"+=", function(arg1, arg2)
		accountList.gameObject:SetActive(false)
	end}
	
	accountInput.gameObject:AddComponent(EventListener).OnPointerClickEvent = {"+=", function(arg1, arg2)
		accountList.gameObject:SetActive(true)
	end}

    sureButton.onClick:AddListener(self.OnSureButtonClick)
	
	serverSelectButton.onClick:AddListener(function()
		DialogManager.Instance:Open("ServerSelectDialog")
	end)
	
	transform:Find("AutoLoginButton"):GetComponent(Button).onClick:AddListener(function()
		autoLogin = not autoLogin
		autoLoginFlag:SetActive(autoLogin)
	end)
	
	transform:Find("RememberPasswordButton"):GetComponent(Button).onClick:AddListener(function()
		rememberPassword = not rememberPassword
		rememberPasswordFlag:SetActive(rememberPassword)
	end)
	
	transform:Find("RegisterButton"):GetComponent(Button).onClick:AddListener(function()
		DialogManager.Instance:Open("RegisterDialog", serverInfo.id)
	end)
	
	if PlayerInfo.MusicFlag then
		SoundManager.Instance:Play("LoginPanel_Bg", true)
	else
		SoundManager.Instance:Stop()
	end
	
	MessageManager.AddListener(MsgType.OnConnectedToServer, function()
		if flag then
			local sp = SpObject()
			sp:Insert("name", account)
			sp:Insert("client_pub", password)
			Api.Send("login", sp)
			flag = false
		end
	end	)
	
	MessageManager.AddListener(MsgType.LoginResponse, function(errorId)
		if errorId == 0 then
			local data = Api.GetAccount(account)
			data.account = account
			data.password = password
			data.serverId = serverInfo.id
			data.autoLogin = autoLogin
			data.rememberPassword = rememberPassword
			Api.SaveAccount(data)
		elseif errorId == 1 then
			MessageBox.Instance:OpenText("帐号不存在", Color.cyan, 1, MessageBoxPos.Middle)
		elseif errorId == 2 then
			MessageBox.Instance:OpenText("密码错误", Color.cyan, 1, MessageBoxPos.Middle)
		elseif errorId == 3 then
			MessageBox.Instance:OpenText("版本太低无法登录", Color.cyan, 1, MessageBoxPos.Middle)
		end
	end	)
end

function LoginPanel.OnSureButtonClick()
	if String.IsNullOrEmpty(accountInput.text) or String.IsNullOrEmpty(passwordInput.text) then
		MessageBox.Instance:OpenText("账号名或密码不能为空", Color.cyan, 1, MessageBoxPos.Middle)
		return
	end
	flag = true
	Api.CloseInternet()
	Api.ConnectToServer(2, nil)

    -- 连接到服务器
    --Api.ConnectToServer(2, "create")
end

function LoginPanel:Refresh(arg)
    -- 获取本地登录信息
    local res = Api.GetAccount(arg)
    if res then
		if res.account ~= "" then
			accountInput.text = res.account
		end
		if res.password ~= "" then
			passwordInput.text = res.password
		end
		autoLogin = res.autoLogin
		rememberPassword = res.rememberPassword
        account = accountInput.text
        password = passwordInput.text
		autoLoginFlag:SetActive(autoLogin)
		rememberPasswordFlag:SetActive(rememberPassword)
		if arg == nil then
			if res.serverId and res.serverId ~= 0 and Api.GetItem(ServerInfo, res.serverId) then
				MessageManager.HandleMessage(MsgType.ChangeServer, Api.GetItem(ServerInfo, res.serverId))
			else
				MessageManager.HandleMessage(MsgType.ChangeServer, Api.GetItems(ServerInfo)[0])
			end
		end
	else
		if arg == nil then
			MessageManager.HandleMessage(MsgType.ChangeServer, Api.GetItems(ServerInfo)[0])
		end
    end
end

function LoginPanel:Update()
	-- if Input.GetKeyDown(KeyCode.Q) then
		-- MessageBox.Instance:OpenText("奖励已领取！", Color.cyan, 1, MessageBoxPos.Middle)
	-- end
end

return LoginPanel
