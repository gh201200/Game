local SettlementPanel = { }

local this
local transform
local gameObject

local tweenTime = 0.5

local cg
local light
local resultImage
local blueContent
local redContent
local coinLabel
local scoreLabel

local heroItem
local skillItem

local heroTabel = { }

local Items = { }

local maxDamage, maxBeDamage, maxKill
local players = { }

local PlayersGo = { }

function SettlementPanel:Start()
    this = SettlementPanel.this
    transform = SettlementPanel.transform
    gameObject = SettlementPanel.gameObject
	cg = gameObject:AddComponent(CanvasGroup)
    skillItem = Api.LoadImmediately("UI/Panels/SettlementPanel/SkillItem.prefab", AssetType.Prefab)
    heroItem = Api.LoadImmediately("UI/Panels/SettlementPanel/HeroItem.prefab", AssetType.Prefab)
	light = transform:Find("Light")
	resultImage = transform:Find("ResultImage"):GetComponent(Image)
	blueContent = transform:Find("BlueContent")
	redContent = transform:Find("RedContent")
	coinLabel = transform:Find("CoinLabel"):GetComponent(Text)
	scoreLabel = transform:Find("ScoreLabel"):GetComponent(Text)
	transform:Find("ContinueButton"):GetComponent(Button).onClick:AddListener(function()
		if Items then
			UIManager.Instance:OpenPanel("OpenBoxPanel", true, Items)
		else
			self:ReturnMain()
		end
	end)
end

function SettlementPanel:OnOpen(args)
	-- Debug.LogError("GameOver")
	local res = args[1]
	maxDamage = res.maxDamage
	maxBeDamage = res.maxBeDamage
	maxKill = res.maxKill
	players = res.players
	Items = players[Api.GetAccount().account]["items"]
	cg.alpha = 0
	
	local co = coroutine.create(function()
		for k, v in pairs(PlayersGo) do
			GameObject.Destroy(v.go)
		end
		PlayersGo = { }
		for k, v in pairs(players) do
			-- Debug.LogError("GameOver")
			-- print(v)
			local si = { }
			si.info = v
			si.go = GameObject.Instantiate(heroItem)
			if v.own then
				si.go.transform:SetParent(blueContent)
			else
				si.go.transform:SetParent(redContent)
			end
			si.praiseGo = si.go.transform:Find("PraiseButton").gameObject
			if v.own then
				si.praiseGo:SetActive(si.info.accountid ~= Account.accountId)
			else
				si.praiseGo:SetActive(false)
			end
			si.go.transform.localScale = Vector3.one
			si.go.transform.localEulerAngles = Vector3.zero
			si.icon = si.go.transform:Find("IconMask/Icon"):GetComponent(Image)
			si.nameLabel = si.go.transform:Find("NameLabel"):GetComponent(Text)
			si.killLabel = si.go.transform:Find("KillBg/Text"):GetComponent(Text)
			si.deadLabel = si.go.transform:Find("DeadBg/Text"):GetComponent(Text)
			si.helpLabel = si.go.transform:Find("HelpBg/Text"):GetComponent(Text)
			si.heartGo = si.go.transform:Find("PraiseButton/Image").gameObject
			si.skillContent = si.go.transform:Find("SkillContent")
			si.layout = si.skillContent:GetComponent(HorizontalLayoutGroup)
			si.select = si.go.transform:Find("Select").gameObject
			si.Skills = { }
			
			si.praiseFlag = false
			si.heartGo:SetActive(false)
			si.select:SetActive(si.info.accountid == Account.accountId)
			si.icon.sprite = Api.LoadImmediately(si.info.heroData.szModelIcon, AssetType.Sprite)
			si.nameLabel.text = si.info.heroData.szName
			si.killLabel.text = si.info.kills
			si.deadLabel.text = si.info.deads
			si.helpLabel.text = si.info.helps
			si.layout.enabled = true
			Yield(WaitForEndOfFrame())
			
			for key, value in pairs(si.info.skills) do
				local info = ConfigReader.GetSkillDataInfo(key)
				if info and info.n32SkillType ~= 0 then
					local item = { }
					item.info = info
					item.go = GameObject.Instantiate(skillItem)
					item.rt = item.go:GetComponent(RectTransform)
					item.go.transform:SetParent(si.skillContent)
					item.go.transform.localScale = Vector3.one
					item.go.transform.localEulerAngles = Vector3.zero
					item.icon = item.go.transform:Find("IconMask/Icon"):GetComponent(Image)
					item.levelContent = item.go.transform:Find("LevelContent")
					item.icon.sprite = Api.LoadImmediately(item.info.szIcon, AssetType.Sprite)
					if info.n32SkillType == 2 then
						item.levelContent.gameObject:SetActive(true)
						item.go.transform:SetAsFirstSibling()
						for i = 0, item.levelContent.childCount - 1 do
							local obj = item.levelContent:GetChild(i).gameObject
							obj:SetActive(i < value)
						end
					else
						item.levelContent.gameObject:SetActive(false)
					end
					si.Skills[key] = item
					Yield(WaitForEndOfFrame())
				end
			end
			
			si.layout.enabled = false
			for k1, v1 in pairs(si.Skills) do
				if v1.info.n32SkillType ~= 2 then
					local pos = v1.rt.anchoredPosition
					v1.rt.anchoredPosition = Vector2(pos.x, -120)
				end
			end
			
			si.go.transform:Find("PraiseButton"):GetComponent(Button).onClick:AddListener(function()
				if si.praiseFlag then return end
				SettlementPanel:givePlayerStar(si.info.accountid)
				si.heartGo:SetActive(true)
			end)
			
			PlayersGo[k] = si
		end
		coinLabel.text = players[Api.GetAccount().account]["gold"]
		scoreLabel.text = players[Api.GetAccount().account]["score"]
		local res = players[Api.GetAccount().account]["result"]
		if res == 0 then
			resultImage.sprite = Api.LoadImmediately("UI/Textures/Settlement/shenli.png", AssetType.Sprite)
			OpenBoxId = 2000
		elseif res == 1 or res == 3 then
			resultImage.sprite = Api.LoadImmediately("UI/Textures/Settlement/shibai.png", AssetType.Sprite)
		elseif res == 2 then
			resultImage.sprite = Api.LoadImmediately("UI/Textures/Settlement/pingju.png", AssetType.Sprite)
		end
		Api.Fade(cg, 0.3, false)
	end)
	coroutine.resume(co)
end

function SettlementPanel:OnDestroy()

end

function SettlementPanel:ReturnMain()
    Api.LoadSceneAsync("UIScene", function()
    end )
	TimeManager.Instance:Do(0.2, function()
		UIManager.Instance:OpenPanel("MainPanel", false)
	end )
end

--点赞
function SettlementPanel:givePlayerStar(accountid)
	local sp = SpObject()
	sp:Insert("accountid", accountid)
	sendNetMsg("givePlayerStar", sp)	
end

return SettlementPanel
