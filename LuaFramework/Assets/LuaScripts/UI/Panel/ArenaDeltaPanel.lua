local ArenaDeltaPanel = {}

local this
local transform
local gameObject

local openComplete = false		-- 面板是否已经缓存过了
local arenaPrefab				-- 竞技场item预制
local heroPrefab				-- 英雄图标预制
local skillPrefab				-- 技能图标预制
local arenaContent				-- 竞技场Item根节点
local Arenas = { }				-- 所有竞技场
local sr

function ArenaDeltaPanel:Start()
	this = ArenaDeltaPanel.this
	transform = ArenaDeltaPanel.transform
	gameObject = ArenaDeltaPanel.gameObject
	
	arenaContent = transform:Find("ScrollList/Content")
	sr = arenaContent.parent:GetComponent(ScrollRect)
	
	arenaPrefab = Api.LoadImmediately("UI/Panels/ArenaDeltaPanel/ArenaItem.prefab", AssetType.Prefab)
	heroPrefab = Api.LoadImmediately("UI/Panels/ArenaDeltaPanel/HeroItem.prefab", AssetType.Prefab)
	skillPrefab = Api.LoadImmediately("UI/Panels/ArenaDeltaPanel/SkillItem.prefab", AssetType.Prefab)
	
	-- 关闭按钮点击监听
	transform:Find("CloseButton"):GetComponent(UIButton).onClick:AddListener(function()
		UIManager.Instance:OpenPanel("MainPanel", true)
	end)
end

function ArenaDeltaPanel:OnOpen(args)
	local co = coroutine.create(function()
		UIManager.Instance:ShowLoading()
		Yield(WaitForEndOfFrame())
		for i = 1, table.size(quest.Arena) do
			Yield(WaitForEndOfFrame())
			local si = {}
			si.index = i
			si.info = quest.Arena[i]
			si.go = GameObject.Instantiate(arenaPrefab)
			si.go.transform:SetParent(arenaContent)
			si.go.transform.localScale = Vector3.one
			si.go.transform.localEulerAngles = Vector3.zero
			si.go.name = si.info.Name
			si.nameLabel = si.go.transform:Find("TitleBg/Title"):GetComponent(Text)
			si.scoreLabel = si.go.transform:Find("TitleBg/ScoreLabel"):GetComponent(Text)
			si.infoButton = si.go.transform:Find("TitleBg/InfoButton"):GetComponent(UIButton)
			si.icon = si.go.transform:Find("MapIcon"):GetComponent(Image)
			si.heroContent = si.go.transform:Find("HeroContent")
			si.skillContent = si.go.transform:Find("SkillContent")
			si.heroLabel = si.go.transform:Find("HeroLabel").gameObject
			si.skillLabel = si.go.transform:Find("SkillLabel").gameObject
			
			-- 信息按钮点击监听
			si.infoButton.onClick:AddListener(function()
				DialogManager.Instance:Open("ArenaInfoDialog", si.info)
			end)
			
			si.Heros = { }
			si.Skills = { }
			
			local heroFlag = table.size(si.info.UnlockHero) > 0
			local skillFlag = table.size(si.info.UnlockSkill) > 0
			si.heroContent.gameObject:SetActive(heroFlag)
			si.heroLabel:SetActive(heroFlag)
			si.skillContent.gameObject:SetActive(skillFlag)
			si.skillLabel:SetActive(skillFlag)
			
			-- 实例化英雄
			for _, v in pairs(si.info.UnlockHero) do
				Yield(WaitForEndOfFrame())
				local item = { }
				item.info = ConfigReader.GetHeroInfo(v)
				item.go = GameObject.Instantiate(heroPrefab)
				item.go.transform:SetParent(si.heroContent)
				item.go.transform.localScale = Vector3.one
				item.go.transform.localEulerAngles = Vector3.zero
				item.go.name = item.info.szName
				item.nameLabel = item.go.transform:Find("NameBg/Text"):GetComponent(Text)
				item.icon = item.go.transform:Find("Mask/Icon"):GetComponent(Image)
				item.edge = item.go.transform:Find("Edge"):GetComponent(Image)
				
				-- 加载英雄图标
				Api.Load(item.info.szModelIcon, AssetType.Sprite, function(s)
					item.icon.sprite = s
				end)
				
				-- 加载品质图标
                local spName
                if item.info.n32Color == 1 then
                    spName = "edge_white.png"
                elseif item.info.n32Color == 2 then
                    spName = "edge_green.png"
                elseif item.info.n32Color == 3 then
                    spName = "edge_blue.png"
                elseif item.info.n32Color == 4 then
                    spName = "edge_purple.png"
                elseif item.info.n32Color == 5 then
                    spName = "edge_orange.png"
                end
                local spPath = "UI/Textures/Common/" .. spName
                Api.Load(spPath, AssetType.Sprite, function(sp)
                    item.edge.sprite = sp
                end )
				
				-- 英雄名称
				item.nameLabel.text = item.info.szName
				
				-- 点击事件监听
				item.go:GetComponent(UIButton).onClick:AddListener(function()
					DialogManager.Instance:Open("HeroDesDialog", item.info)
				end)
			end
			
			-- 实例化技能
			for _, v in pairs(si.info.UnlockSkill) do
				Yield(WaitForEndOfFrame())
				local item = { }
				item.info = ConfigReader.GetSkillDataInfo(v)
				item.go = GameObject.Instantiate(skillPrefab)
				item.go.transform:SetParent(si.skillContent)
				item.go.transform.localScale = Vector3.one
				item.go.transform.localEulerAngles = Vector3.zero
				item.go.name = item.info.szName
				item.icon = item.go.transform:Find("Mask/Icon"):GetComponent(Image)
				Api.Load(item.info.szIcon, AssetType.Sprite, function(s)
					item.icon.sprite = s
				end)
				item.go:GetComponent(UIButton).onClick:AddListener(function()
					DialogManager.Instance:Open("SkillDesDialog", item.info)
				end)
			end
			
			si.nameLabel.text = si.info.Name
			si.scoreLabel.text = si.info.EloLimit
			Arenas[si.index] = si
			Api.Load(si.info.BattleGroundPreview, AssetType.Sprite, function(s)
				si.icon.sprite = s
				si.icon:SetNativeSize()
			end)
		end
		Yield(WaitForEndOfFrame())
		sr.verticalNormalizedPosition = 1
		local targetPos = arenaContent.parent:InverseTransformPoint(Arenas[Account.level].go.transform.position)
		arenaContent.localPosition = arenaContent.localPosition - targetPos + Vector3.up * 960
		UIManager.Instance:HideLoading()
	end)
	if not openComplete then
		coroutine.resume(co)
	else
		UIManager.Instance:HideLoading()
		sr.verticalNormalizedPosition = 1
		local targetPos = arenaContent.parent:InverseTransformPoint(Arenas[Account.level].go.transform.position)
		arenaContent.localPosition = arenaContent.localPosition - targetPos + Vector3.up * 960
	end
	openComplete = true
	
end

function ArenaDeltaPanel:OnClose()

end
local index = 0
function ArenaDeltaPanel:Update()
	if Input.GetKeyDown(KeyCode.Q) then
		index = index + 1
		sr.verticalNormalizedPosition = 1
		local targetPos = arenaContent.parent:InverseTransformPoint(Arenas[index % 7 + 1].go.transform.position)
		arenaContent.localPosition = arenaContent.localPosition - targetPos + Vector3.up * 960
	end
end

function ArenaDeltaPanel:FixedUpdate()

end

function ArenaDeltaPanel:LateUpdate()

end

function ArenaDeltaPanel:OnDestroy()

end

return ArenaDeltaPanel
