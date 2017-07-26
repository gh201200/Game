local PlayerInfoDialog = {}

local this
local transform
local gameObject

local Heros = { }
local Skills = { }

local curIndex = 0

local infoContent, inboxContent

local infoButtonImage, inboxButtonImage

local nickName, unionName
local unionIcon
local scoreLabel
local commonUseHeroIcon
local commonUseHeroName
local heroProgress
local heroDeltaLabel
local skillProgress
local skillDeltaLabel
local highestScoreLabel, vectoryCountLabel, praiseCountLabel

local mailContent
local mailPrefab
local heroPrefab
local prefab
local Mails = { }

function PlayerInfoDialog:Start()
	this = PlayerInfoDialog.this
	transform = PlayerInfoDialog.transform
	gameObject = PlayerInfoDialog.gameObject
	infoContent = transform:Find("InfoContent").gameObject
	inboxContent = transform:Find("InboxContent").gameObject
	infoButtonImage = transform:Find("InfoButton"):GetComponent(Image)
	inboxButtonImage = transform:Find("InboxButton"):GetComponent(Image)
	nickName = infoContent.transform:Find("NickNameIcon/NickName"):GetComponent(Text)
	unionName = infoContent.transform:Find("NickNameIcon/UnionName"):GetComponent(Text)
	unionIcon = infoContent.transform:Find("NickNameIcon/UnionIcon"):GetComponent(Image)
	scoreLabel = infoContent.transform:Find("Score/ScoreLabel"):GetComponent(Text)
	commonUseHeroIcon = infoContent.transform:Find("CommonUseHeroIcon"):GetComponent(Image)
	commonUseHeroName = infoContent.transform:Find("CommonUseHeroIcon/Bg/Text"):GetComponent(Text)
	heroProgress = infoContent.transform:Find("HeroProgress/Bg"):GetComponent(Slider)
	heroDeltaLabel = infoContent.transform:Find("HeroProgress/Bg/DeltaLabel"):GetComponent(Text)
	skillProgress = infoContent.transform:Find("SkillProgress/Bg"):GetComponent(Slider)
	skillDeltaLabel = infoContent.transform:Find("SkillProgress/Bg/DeltaLabel"):GetComponent(Text)
	highestScoreLabel = infoContent.transform:Find("HighestScore/Bg/DeltaLabel"):GetComponent(Text)
	vectoryCountLabel = infoContent.transform:Find("VectoryCount/Bg/DeltaLabel"):GetComponent(Text)
	praiseCountLabel = infoContent.transform:Find("PraiseCount/Bg/DeltaLabel"):GetComponent(Text)
	mailContent = inboxContent.transform:Find("Content")
	
	nickName.text = Account.accountId
	unionName.text = "暂无工会"
	
	transform:Find("InfoButton"):GetComponent(Button).onClick:AddListener(function()
		if curIndex == 0 then return end
		infoContent:SetActive(true)
		inboxContent:SetActive(false)
		curIndex = 0
		local temp = inboxButtonImage.sprite
		inboxButtonImage.sprite = infoButtonImage.sprite
		infoButtonImage.sprite = temp
	end)
	
	transform:Find("InboxButton"):GetComponent(Button).onClick:AddListener(function()
		if curIndex == 1 then return end
		infoContent:SetActive(false)
		inboxContent:SetActive(true)
		curIndex = 1
		local temp = inboxButtonImage.sprite
		inboxButtonImage.sprite = infoButtonImage.sprite
		infoButtonImage.sprite = temp
	end)
	
	-- 更新邮件监听
	MessageManager.AddListener(MsgType.UpdateMail, function(v)
		local co = coroutine.create(function()
			if mailPrefab == nil then
				mailPrefab = Api.LoadImmediately("UI/Dialog/PlayerInfoDialog/MailItem.prefab", AssetType.Prefab)
			end
			if heroPrefab == nil then
				heroPrefab = Api.LoadImmediately("UI/Dialog/PlayerInfoDialog/HeroItem.prefab", AssetType.Prefab)
			end
			if prefab == nil then
				prefab = Api.LoadImmediately("UI/Dialog/PlayerInfoDialog/Item.prefab", AssetType.Prefab)
			end
			if Mails[v.uuid] == nil then
				Yield(WaitForEndOfFrame())
				local si = { }
				si.go = GameObject.Instantiate(mailPrefab)
				si.go.transform:SetParent(mailContent)
				si.go.transform.localScale = Vector3.one
				si.go.transform.localEulerAngles = Vector3.zero
				si.info = v
				si.index = v.index
				si.titleLabel = si.go.transform:Find("Bg/TitleLabel"):GetComponent(Text)
				si.senderLabel = si.go.transform:Find("Bg/SenderLabel"):GetComponent(Text)
				si.point = si.go.transform:Find("Point")
				si.content = si.go.transform:Find("Content")
				si.messageLabel = si.content:Find("Text"):GetComponent(Text)
				si.itemContent = si.content:Find("ItemContent")
				si.rewardButton = si.go.transform:Find("Bg/GetRewardButton"):GetComponent(Image)
				si.Items = { }
				si.go.transform:Find("Bg"):GetComponent(Button).onClick:AddListener(function()
					si.content.gameObject:SetActive(not si.content.gameObject.activeSelf)
				end)
				si.go.transform:Find("Bg/GetRewardButton"):GetComponent(Button).onClick:AddListener(function()
					if table.size(si.info.items) > 0 then
						g_Mails:recvMailItems(si.index)
					end
				end)
				
				-- 附件领取监听
				MessageManager.AddListener(MsgType.ReceiveMailItem, function(info)
					for _, v_ in pairs(Mails) do
						if v_.info.uuid == info.uuid then
							v_:Update(info)
							this:OnClose()
						end
					end
				end)
				
				function si:Update(info)
					si.info = info
					si.index = info.index
					if Mails[v.uuid] == nil then
						si.go.transform:SetSiblingIndex(si.index)
					end
					si.rewardButton.gameObject:SetActive(table.size(si.info.items) > 0)
					if bit_and(si.info.flag, bit(1)) ~= 0 then
						si.rewardButton.material = Api.GreyMat
						si.point.gameObject:SetActive(false)
					else
						si.rewardButton.material = nil
						si.point.gameObject:SetActive(true)
					end
					si.titleLabel.text = si.info.title
					si.senderLabel.text = si.info.sender
					si.messageLabel.text = si.info.content
					for _, v in pairs(si.Items) do
						GameObject.Destroy(v.go)
					end
					si.Items = { }
					for k, v in pairs(si.info.items) do
						local sb = { }
						sb.info = ConfigReader.GetItemCfg(k)
						if sb.info.n32Type == 3 then
							sb.go = GameObject.Instantiate(heroPrefab)
						else
							sb.go = GameObject.Instantiate(prefab)
						end
						if sb.go == nil then
							Debug.LogError("item type error")
							return
						end
						sb.go.transform:SetParent(si.itemContent)
						sb.go.transform.localScale = Vector3.one
						sb.go.transform.localEulerAngles = Vector3.zero
						sb.icon = sb.go.transform:Find("Mask/Icon"):GetComponent(Image)
						sb.icon.sprite = Api.LoadImmediately(sb.info.szIcon, AssetType.Sprite)
						si.Items[k] = sb
					end
				end
				si:Update(si.info)
				Mails[v.uuid] = si
			else
				Mails[v.uuid]:Update(v)
			end
		end)
		coroutine.resume(co)
	end)
	
	-- 获胜场次监听
	MessageManager.AddListener(MsgType.PvpWinTimes, function(value)
		vectoryCountLabel.text = value
	end)
	
	for _, v in pairs(g_Mails.units) do
		MessageManager.HandleMessage(MsgType.UpdateMail, v)
	end
	 
end

function PlayerInfoDialog:OnOpen(args)

	local heroCount, skillCount = 0, 0
	
	for p in Slua.iter(ConfigReader.HeroXmlInfoDict) do
		if Heros[p.value.n32SeriId] == nil then
			Heros[p.value.n32SeriId] = "fuck"
			heroCount = heroCount + 1
		end
	end
	
	for p in Slua.iter(ConfigReader.SkillDatasDic) do
		if Skills[p.value.n32SeriId] == nil then
			Skills[p.value.n32SeriId] = "fuck"
			skillCount = skillCount + 1
		end
	end
	
	if heroCount == 0 then heroCount = 1 end
	if skillCount == 0 then skillCount = 1 end
	
	scoreLabel.text = Account.exp
	highestScoreLabel.text = Account.topexp
	
	heroProgress.value = AgentData.Instance.mHero.Count / heroCount
	heroDeltaLabel.text = AgentData.Instance.mHero.Count .. "/" .. heroCount
	skillProgress.value = AgentData.Instance.mSkill.Count / skillCount
	skillDeltaLabel.text = AgentData.Instance.mSkill.Count .. "/" .. skillCount
	
	Heros = { }
	Skills = { }
	heroCount = 0
	skillCount = 0
	
	praiseCountLabel.text = AgentData.Instance.mAccount.star
	SystemLogic.Instance:UpdateActivityData(g_Activity:calcAccountUid(ActivitySysType.PvpWinTimes))
end

function PlayerInfoDialog:Update()

end

function PlayerInfoDialog:FixedUpdate()

end

function PlayerInfoDialog:LateUpdate()

end

function PlayerInfoDialog:OnDestroy()

end

return PlayerInfoDialog
