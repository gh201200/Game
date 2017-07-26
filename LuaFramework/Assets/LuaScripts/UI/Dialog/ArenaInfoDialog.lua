local ArenaInfoDialog = {}

local this
local transform
local gameObject

local titleLabel
local coinLabel
local content1
local content2

local Box1 = { }
local Box2 = { }

local arenaInfo

function ArenaInfoDialog:Start()
	this = ArenaInfoDialog.this
	transform = ArenaInfoDialog.transform
	gameObject = ArenaInfoDialog.gameObject
	titleLabel = transform:Find("TitleLabel"):GetComponent(Text)
	coinLabel = transform:Find("CoinEdge/Text"):GetComponent(Text)
	content1 = transform:Find("Content1")
	content2 = transform:Find("Content2")
end

function ArenaInfoDialog:OnOpen(args)
	arenaInfo = args[1]
	if not arenaInfo then Debug.LogError("参数缺失") return end
	
	-- 初始化宝箱奖励
	local BoxInfo = { }
	table.insert(BoxInfo, arenaInfo.HeroPiecePackage)
	table.insert(BoxInfo, arenaInfo.AdvHeroPiecePackage)
	table.insert(BoxInfo, arenaInfo.SkillCardPackage)
	table.insert(BoxInfo, arenaInfo.AdvSkillCardPackage)
	
	local NumInfo = { }
	table.insert(NumInfo, arenaInfo.HeroPiecePInfo)
	table.insert(NumInfo, arenaInfo.AdvHeroPiecePInfo)
	table.insert(NumInfo, arenaInfo.SkillCardPInfo)
	table.insert(NumInfo, arenaInfo.AdvSkillCardPInfo)
	
	for i = 1, 4 do
		local si = { }
		-- 道具信息
		si.propInfo = ConfigReader.GetItemCfg(BoxInfo[i])
		si.go = content1:GetChild(i - 1).gameObject
		si.content = si.go.transform:Find("Content")
		si.icon = si.go.transform:Find("Icon"):GetComponent(Image)
		si.icon.sprite = Api.LoadImmediately(si.propInfo.szIcon, AssetType.Sprite)
		for j = 1, 3 do
			local go = si.content:GetChild(j - 1).gameObject
			go:SetActive(NumInfo[i][j] ~= 0)
			go.transform:Find("Text"):GetComponent(Text).text = "x" .. NumInfo[i][j]
		end
	end
	
	-- 初始化战斗奖励
	local BoxInfo_Battle = { }
	table.insert(BoxInfo_Battle, arenaInfo.VictoryReward)
	table.insert(BoxInfo_Battle, arenaInfo.DailyReward)
	
	local NumInfo_Battle = { }
	table.insert(NumInfo_Battle, arenaInfo.VictoryRewardInfo)
	table.insert(NumInfo_Battle, arenaInfo.DailyRewardInfo)
	
	for i = 1, 2 do
		local si = { }
		-- 道具信息
		si.propInfo = ConfigReader.GetItemCfg(BoxInfo_Battle[i])
		si.go = content2:GetChild(i - 1).gameObject
		si.content = si.go.transform:Find("Content")
		si.icon = si.go.transform:Find("Icon"):GetComponent(Image)
		si.icon.sprite = Api.LoadImmediately(si.propInfo.szIcon, AssetType.Sprite)
		for j = 1, 3 do
			local go = si.content:GetChild(j - 1).gameObject
			go:SetActive(NumInfo_Battle[i][j] ~= 0)
			go.transform:Find("Text"):GetComponent(Text).text = "x" .. NumInfo_Battle[i][j]
		end
	end
	
	-- 初始化标题和金币奖励
	titleLabel.text = arenaInfo.BattleGroundName
	coinLabel.text = arenaInfo.GoldReward
end

function ArenaInfoDialog:Update()

end

function ArenaInfoDialog:FixedUpdate()

end

function ArenaInfoDialog:LateUpdate()

end

function ArenaInfoDialog:OnDestroy()

end

return ArenaInfoDialog
