local BattleRecordDialog = {}

local this
local transform
local gameObject

local titleLabel
local recordContent
local recordPrefab
local heroPrefab
local skillPrefab

local label
local battleButton

local loadingImage

local Records = { }

function BattleRecordDialog:Start()
	this = BattleRecordDialog.this
	transform = BattleRecordDialog.transform
	gameObject = BattleRecordDialog.gameObject
	titleLabel = transform:Find("Title"):GetComponent(Text)
	recordContent = transform:Find("View/Content")
	label = transform:Find("View/Content/Label").gameObject
	battleButton = transform:Find("View/BattleButton").gameObject
	loadingImage = transform:Find("View/Loading/Image")
	
	battleButton:GetComponent(UIButton).onClick:AddListener(function()
		this:OnClose()
		UIManager.Instance:OpenPanel("MatchPanel", true)
		Api.RequestMatch()
	end)
	
	recordPrefab = Api.LoadImmediately("UI/Dialog/BattleRecordDialog/RecordItem.prefab", AssetType.Prefab)
	heroPrefab = Api.LoadImmediately("UI/Dialog/BattleRecordDialog/HeroItem.prefab", AssetType.Prefab)
	skillPrefab = Api.LoadImmediately("UI/Dialog/BattleRecordDialog/SkillItem.prefab", AssetType.Prefab)
	
	MessageManager.AddListener(MsgType.UpdateBattleRecord, function(data)
		if #data <= 0 then
			label:SetActive(false)
			battleButton:SetActive(true)
		else
			label:SetActive(true)
			battleButton:SetActive(false)
		end
		local co = coroutine.create(function()
			Yield(WaitForEndOfFrame())
			loadingImage.parent.gameObject:SetActive(false)
			for k, v in pairs(data) do
				local si = { }
				si.go = GameObject.Instantiate(recordPrefab)
				si.go.transform:SetParent(recordContent)
				si.go.transform.localScale = Vector3.one
				si.go.transform.localEulerAngles = Vector3.zero
				si.Items = { }
				si.redContent = si.go.transform:Find("RedBg")
				si.blueContent = si.go.transform:Find("BlueBg")
				si.titleImage = si.go.transform:Find("Title/ResultImage"):GetComponent(Image)
				
				local selfColor = -1
				local winflag = -1
				for _, temp in pairs(v) do
					if temp.account_id == Account.accountId then
						selfColor = temp.color
						winflag = temp.winflag
					end
				end
				if selfColor == -1 then
					Debug.LogError("self color is not found")
					return
				end
				if winflag == -1 then
					Debug.LogError("winflag is not found")
					return
				elseif winflag == 1 then
					si.titleImage.sprite = Api.LoadImmediately("UI/Textures/BattleRecord/shengli.png", AssetType.Sprite)
				elseif winflag == 2 then
					si.titleImage.sprite = Api.LoadImmediately("UI/Textures/BattleRecord/shibai.png", AssetType.Sprite)
				elseif winflag == 3 then
					si.titleImage.sprite = Api.LoadImmediately("UI/Textures/BattleRecord/pingju.png", AssetType.Sprite)
				end
				
				Yield(WaitForEndOfFrame())
				
				if this.isOpen == false and Slua.IsNull(si.go) == false then
					-- Debug.LogError("destroy " .. si.go.name)
					GameObject.Destroy(si.go)
					return
				end
				
				for key, value in pairs(v) do
					local isOwn = true
					if value.account_id ~= Account.accountId then
						if value.color < 4 and selfColor < 4 then
							isOwn = true
						elseif value.color > 3 and selfColor > 3 then
							isOwn = true
						else
							isOwn = false
						end
					end
					local item = { }
					item.go = GameObject.Instantiate(heroPrefab)
					if isOwn then
						item.go.transform:SetParent(si.blueContent)
					else
						item.go.transform:SetParent(si.redContent)
					end
					item.go.transform.localScale = Vector3.one
					item.go.transform.localEulerAngles = Vector3.zero
					item.icon = item.go.transform:Find("IconMask/Icon"):GetComponent(Image)
					item.nameLabel = item.go.transform:Find("NameLabel"):GetComponent(Text)
					item.killLabel = item.go.transform:Find("KillBg/Text"):GetComponent(Text)
					item.deadLabel = item.go.transform:Find("DeadBg/Text"):GetComponent(Text)
					item.helpLabel = item.go.transform:Find("HelpBg/Text"):GetComponent(Text)
					item.light = item.go.transform:Find("Light").gameObject
					
					item.light:SetActive(value.account_id == Account.accountId)
					
					item.info = ConfigReader.GetHeroInfo(value.heroId)
					Api.Load(item.info.szModelIcon, AssetType.Sprite, function(s)
						item.icon.sprite = s
					end)
					item.nameLabel.text = item.info.szName
					item.killLabel.text = value.killNum
					item.deadLabel.text = value.deadthNum
					item.helpLabel.text = value.assistNum
					
					item.skillContent = item.go.transform:Find("SkillContent")
					item.layout = item.skillContent:GetComponent(HorizontalLayoutGroup)
					item.layout.enabled = true
					item.Skills = { }
					
					Yield(WaitForEndOfFrame())
					
					for _k, _v in pairs(value.skillTable) do
						local gh = { }
						
						local level = tonumber(string.sub(_v, -1))
						
						gh.info = ConfigReader.GetSkillDataInfo(_v)
						
						if gh.info == nil then
							gh.info = ConfigReader.GetSkillDataInfo(_v + 1)
						end
						
						if gh.info ~= nil and gh.info.n32SkillType ~= 0 then
							gh.go = GameObject.Instantiate(skillPrefab)
							gh.rt = gh.go:GetComponent(RectTransform)
							gh.go.transform:SetParent(item.skillContent)
							gh.go.transform.localScale = Vector3.one
							gh.go.transform.localEulerAngles = Vector3.zero
							gh.icon = gh.go.transform:Find("IconMask/Icon"):GetComponent(Image)
							gh.levelContent = gh.go.transform:Find("LevelContent")
							Api.Load(gh.info.szIcon, AssetType.Sprite, function(s)
								--Debug.LogError(gh.info.szIcon .. " " .. s.name .. " " .. gh.info.id)
								gh.icon.sprite = s
							end)
							if gh.info.n32SkillType == 2 then
								gh.levelContent.gameObject:SetActive(true)
								gh.go.transform:SetAsFirstSibling()
								for a = 0, gh.levelContent.childCount -1 do
									if a < level  then
										gh.levelContent:GetChild(a).gameObject:SetActive(true)
									else
										gh.levelContent:GetChild(a).gameObject:SetActive(false)
									end
								end
							else
								gh.levelContent.gameObject:SetActive(false)
							end
							item.Skills[_k] = gh
							Yield(WaitForEndOfFrame())
						end
					end
					
					if this.isOpen == false then return end
					
					item.layout.enabled = false
					for k1, v1 in pairs(item.Skills) do
						if v1.info.n32SkillType ~= 2 then
							local pos = v1.rt.anchoredPosition
							v1.rt.anchoredPosition = Vector2(pos.x, -100)
						end
					end
					si.Items[key] = item
				end
				Records[k] = si
			end
		end)
		coroutine.resume(co)
	end)
	
end

function BattleRecordDialog:OnOpen(args)
	loadingImage.parent.gameObject:SetActive(true)
	TimeManager.Instance:Do(0.5, function()
		if this.isOpen then
			g_Records:reqRecords()
		end
	end)
end

function BattleRecordDialog:OnClose()
	-- for _, v in pairs(Records) do
		-- GameObject.Destroy(v.go)
	-- end
	Records = { }
	for v in Slua.iter(recordContent) do
		if v.name ~= "Label" then
			GameObject.Destroy(v.gameObject)
		end
	end
end

function BattleRecordDialog:Update()
	
end

function BattleRecordDialog:FixedUpdate()
	loadingImage:Rotate(Vector3.forward, -150 * Time.deltaTime)
end

function BattleRecordDialog:LateUpdate()

end

function BattleRecordDialog:OnDestroy()

end

return BattleRecordDialog
