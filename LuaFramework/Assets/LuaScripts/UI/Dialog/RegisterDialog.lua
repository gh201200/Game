local RegisterDialog = {}

local this
local transform
local gameObject
local account_input
local passwd_input
local passwd2_input
local gou, gou2, gou3
local re, re2, re3
local pos = {
	Vector3(428, -211, 0),
	Vector3(428, -321, 0),
	Vector3(428, -431, 0)
}

local flag = false

local serverId = -1

function RegisterDialog:Start()
	this = RegisterDialog.this
	transform = RegisterDialog.transform
	gameObject = RegisterDialog.gameObject
	this.enableTween = false
	account_input = transform:Find("accountInput"):GetComponent(InputField)
	passwd_input = transform:Find("passwordInput"):GetComponent(InputField)
	passwd2_input = transform:Find("passwordInput2"):GetComponent(InputField)
	gou = transform:Find("Gou")
	re = transform:Find("Re")
	gou2 = transform:Find("Gou2")
	re2 = transform:Find("Re2")
	gou3 = transform:Find("Gou3")
	re3 = transform:Find("Re3")
	
	account_input.onEndEdit:AddListener(function(str)
		re.transform.localPosition = pos[1]
		gou.localPosition = pos[1]
		if String.IsNullOrEmpty(str) then
			gou.gameObject:SetActive(false)
			re.gameObject:SetActive(true)
			MessageBox.Instance:OpenText("账号名称不能为空", Color.cyan, 1, MessageBoxPos.Middle)
			return
		elseif string.utf8len(account_input.text) < 3 then
			gou.gameObject:SetActive(false)
			re.gameObject:SetActive(true)
			MessageBox.Instance:OpenText("帐号名称不能少于3个字", Color.cyan, 1, MessageBoxPos.Middle)
			return
		elseif string.utf8len(account_input.text) > 7 then
			gou.gameObject:SetActive(false)
			re.gameObject:SetActive(true)
			MessageBox.Instance:OpenText("帐号名称不能超过7个字", Color.cyan, 1, MessageBoxPos.Middle)
			return
		end
		local bo = Api.CheckAccount(account_input.text)
		if bo == false then
			gou.gameObject:SetActive(false)
			re.gameObject:SetActive(true)
			MessageBox.Instance:OpenText("帐号名称不能包含特殊符号", Color.cyan, 1, MessageBoxPos.Middle)
			return
		end
		if string.find(account_input.text, "%s+") then
			gou.gameObject:SetActive(false)
			re.gameObject:SetActive(true)
			MessageBox.Instance:OpenText("帐号名称不能包含空格", Color.cyan, 1, MessageBoxPos.Middle)
			return
		end
		bo = Api.FindOne(account_input.text)
		if bo then
			gou.gameObject:SetActive(false)
			re.gameObject:SetActive(true)
			MessageBox.Instance:OpenText("帐号名称包含敏感字符", Color.cyan, 1, MessageBoxPos.Middle)
			return
		end
		if(passwd_input.text == nil or passwd_input.text == "") then
			flag = true
			Api.CloseInternet()
			Api.ConnectToServer(2, nil)
		end
	end )
	
	passwd_input.onEndEdit:AddListener(function(str)
		re2.transform.localPosition = pos[2]
		gou2.localPosition = pos[2]
		if String.IsNullOrEmpty(str) then
			gou2.gameObject:SetActive(false)
			re2.gameObject:SetActive(true)
			MessageBox.Instance:OpenText("密码不能为空", Color.cyan, 1, MessageBoxPos.Middle)
			return
		elseif string.utf8len(str) < 6 then
			gou2.gameObject:SetActive(false)
			re2.gameObject:SetActive(true)
			MessageBox.Instance:OpenText("密码长度不能少于6个字符", Color.cyan, 1, MessageBoxPos.Middle)
			return
		elseif string.utf8len(str) > 14 then
			gou2.gameObject:SetActive(false)
			re2.gameObject:SetActive(true)
			MessageBox.Instance:OpenText("密码长度过长不能大于14个字符", Color.cyan, 1, MessageBoxPos.Middle)
			return
		end
		local bo = false
		for w in string.gmatch(str, "%W+") do
			bo = true
			break
		end
		if bo then
			gou2.gameObject:SetActive(false)
			re2.gameObject:SetActive(true)
			MessageBox.Instance:OpenText("密码不能包含特殊字符", Color.cyan, 1, MessageBoxPos.Middle)
			return
		end
		gou2.gameObject:SetActive(true)
		re2.gameObject:SetActive(false)
	end	)
	
	passwd2_input.onEndEdit:AddListener(function(str)
		re3.transform.localPosition = pos[3]
		gou3.localPosition = pos[3]
		if passwd_input.text ~= str then
			gou3.gameObject:SetActive(false)
			re3.gameObject:SetActive(true)
			MessageBox.Instance:OpenText("2次密码输入不一致", Color.cyan, 1, MessageBoxPos.Middle)
			return
		end
		if gou2.gameObject.activeSelf == false then
			gou3.gameObject:SetActive(false)
			re3.gameObject:SetActive(false)
			return
		end
		gou3.gameObject:SetActive(true)
		re3.gameObject:SetActive(false)
	end	)
	
	MessageManager.AddListener(MsgType.OnConnectedToServer, function()
		if flag then
			local sp = SpObject()
			sp:Insert("name", account_input.text)
			sp:Insert("client_pub", passwd_input.text)
			Api.Send("create", sp)
			flag = false
		end
	end	)
	
	transform:Find("sureButton"):GetComponent(Button).onClick:AddListener(function()
		if gou.gameObject.activeSelf and gou2.gameObject.activeSelf and gou3.gameObject.activeSelf then
			flag = true
			Api.CloseInternet()
			Api.ConnectToServer(2, nil)
		else
			MessageBox.Instance:OpenText("信息填写错误", Color.cyan, 1, MessageBoxPos.Middle)
		end
	end )
	
	MessageManager.AddListener(MsgType.RegisterResponse, function(errorId)
		if errorId == 1 then
			MessageBox.Instance:OpenText("您的名称已被注册，请替换其他名称", Color.cyan, 1, MessageBoxPos.Middle)
			gou.gameObject:SetActive(false)
			re.gameObject:SetActive(true)
		elseif errorId == 0 then
			local data = Api.GetAccount(account_input.text)
			data.account = account_input.text
			data.password = passwd_input.text
			data.serverId = serverId
			Api.SaveAccount(data)
			this:OnClose()
			UIManager.Instance:ClosePanel("LoginPanel")
		elseif errorId == 2 then
			gou.gameObject:SetActive(true)
			re.gameObject:SetActive(false)
		end
	end	)
end

function RegisterDialog:OnOpen(args)
	serverId = args[1]
	account_input.text = ""
	passwd_input.text = ""
	passwd2_input.text = ""
	gou.gameObject:SetActive(false)
	gou2.gameObject:SetActive(false)
	gou3.gameObject:SetActive(false)
	re.gameObject:SetActive(false)
	re2.gameObject:SetActive(false)
	re3.gameObject:SetActive(false)
end

function RegisterDialog:Update()

end

function RegisterDialog:FixedUpdate()

end

function RegisterDialog:LateUpdate()

end

function RegisterDialog:OnDestroy()

end

return RegisterDialog
