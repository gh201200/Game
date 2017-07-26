local MainPanel = { }
local this
local transform
local gameObject

local OnBeginDragCallback = { }
local firstDrag = false
local prePointerPos = Vector3.zero

local fPos, sPos
local isDrag = false

----------------------------------------------
local Heros = { }
MainPanel.Heros = Heros

local Bottom = { }
MainPanel.Bottom = Bottom
Bottom.preButton = nil
----------------------------------------------

---------------中间面板切换控制---------------
local Middle = { }
local Panels = { }
Middle.Panels = Panels
MainPanel.Middle = Middle
Middle.forcusMove = true

local tweenTime = 0.8

function Middle:InitMiddle()
	Bottom.slider = transform:Find("Bottom/Buttons"):GetComponent(ScrollRect)
    local panelRoot = transform:Find("Panels"):GetComponent(RectTransform)
    self.scaleFactor = Api.UIScaleFactor
    local size = Vector2(Screen.width / self.scaleFactor, Screen.height / self.scaleFactor)
    panelRoot.pivot = Vector2(0.5, 0.5)
    panelRoot.anchorMax = Vector2.one * 0.5
    panelRoot.anchorMin = Vector2.one * 0.5
    panelRoot.sizeDelta = size
    -- panelRoot.gameObject:AddComponent(BoxCollider).size = Vector3(size.x * panelRoot.childCount, size.y, 1)

    panelRoot.sizeDelta = Vector2(size.x * panelRoot.childCount, size.y)

    self.firstPos = Vector3(- panelRoot.sizeDelta.x / 2 + size.x / 2, 0, 0)
    self.preIndex = 0
    self.curIndex = 1
    self.curGo = nil

    Api.SetTag(panelRoot.gameObject, "MainPanel_Panels")
    Api.SetTag(transform:Find("Bottom").gameObject, "MainPanel_Bottom")

    for i = 0, panelRoot.childCount - 1, 1 do
        local si = { }
        si.index = i
        si.go = panelRoot:GetChild(i).gameObject
		si.go:SetActive(true)
        si.rt = si.go:GetComponent(RectTransform)
        si.rt.pivot = Vector2(0.5, 0.5)
        si.rt.anchorMax = Vector2.one * 0.5
        si.rt.anchorMin = Vector2.one * 0.5
        si.rt.sizeDelta = size
        si.rt.localPosition = self.firstPos + Vector3.right * size.x * si.index
        si.cg = si.go:AddComponent(CanvasGroup)
        function si:Show()
            si.cg.alpha = 1
        end
        function si:Hide()
            si.cg.alpha = 0
        end
        if si.go.name == "Fight" then
			self.curIndex = i
		end
		Panels[i] = si
    end

    function self:GetPos(index)
        local xPos = panelRoot.sizeDelta.x / 2 - size.x / 2 - size.x * index
        return Vector3(xPos, 0, 0)
    end

    function self:AutoSlide()
        local index = 0
        local dis = math.abs(self:GetPos(0).x - panelRoot.localPosition.x)
        Tween.DOKill(panelRoot, false)
        for _, v in pairs(Panels) do
            local _dis = math.abs(self:GetPos(v.index).x - panelRoot.localPosition.x)
            if _dis < dis then
                dis = _dis
                index = v.index
            end
        end
        local res = Tween.DOLocalMoveX(panelRoot, self:GetPos(index).x, tweenTime, false)
        TweenSetting.OnUpdate(res, function()
            self.curPanelRootPos = panelRoot.localPosition
        end )
        TweenSetting.SetEase(res, Ease.OutExpo)
        self.preIndex = self.curIndex
        self.curIndex = index
        Bottom:Slide(index)
        MessageManager.HandleMessage(MsgType.MainPanelSlide, self.curIndex)
    end

    function self:Slide(index)
        --self:ShowAllPanels()
        Tween.DOKill(panelRoot, false)
        if index < 0 or index > panelRoot.childCount - 1 then
            self:AutoSlide()
        else
            local res = Tween.DOLocalMoveX(panelRoot, self:GetPos(index).x, tweenTime, false)
            TweenSetting.OnUpdate(res, function()
                self.curPanelRootPos = panelRoot.localPosition
            end )
            TweenSetting.SetEase(res, Ease.OutExpo)
            self.preIndex = self.curIndex
            self.curIndex = index
            Bottom:Slide(index)
            MessageManager.HandleMessage(MsgType.MainPanelSlide, self.curIndex)
        end
    end

    function self:ShowAllPanels()
        for _, v in pairs(Panels) do
            v:Show()
        end
    end

    self.isDown = false
    self.prePos = nil
    self.offsetX = 0
    self.downTime = 0
    self.timeInterval = 0

    this.OnUpdateEvent = {
        "+=", function()
            if this.isOpen and UIManager.Instance.curPanel:GetDialogQue().Count == 0 then
                if self.isDown then
                    if MouseDragDir == "horizontal" then
                        self.offsetX =(Input.mousePosition.x - self.prePos.x) / self.scaleFactor
                        panelRoot.localPosition = self.curPanelRootPos + Vector3(self.offsetX, 0, 0)
                        --self:ShowAllPanels()
                        -- Tween.DOLocalMove(panelRoot, self.curPanelRootPos + Vector3(self.offsetX, 0, 0), 0.2, false)
                    end
                end
                if Input.GetMouseButtonDown(0) then
                    self.forcusMove = false
                    self.offsetX = 0
                    local go = Api.GetRayCastObject()
                    if not Slua.IsNull(go) and go.tag == "MainPanel_Panels" then
                        Tween.DOKill(panelRoot, false)
                        self.isDown = true
                        self.forcusMove = true
                        self.prePos = Input.mousePosition
                        self.downTime = tonumber(os.clock())
                    end
                end
                if Input.GetMouseButtonUp(0) then
                    if self.forcusMove then
                        self.isDown = false
                        self.curPanelRootPos = panelRoot.localPosition
                        self.timeInterval = tonumber(os.clock()) - self.downTime
                        -- Debug.LogWarning("offsetX " .. tostring(self.offsetX) .. " interval:" .. self.timeInterval)
                        if math.abs(self.offsetX) > 10 then
                            if self.timeInterval <= 0.6 then
                                if self.offsetX > 0 then
                                    self:Slide(self.curIndex - 1)
                                else
                                    self:Slide(self.curIndex + 1)
                                end
                            else
                                self:AutoSlide()
                            end
                        else
                            self:AutoSlide()
                        end
                        self.offsetX = 0
                    end
                end
            end
        end
    }

    -- local restTime = 0
    -- local timeFlag = false

    -- this.OnUpdateEvent = {
        -- "+=", function()
            -- if not timeFlag then return end
            -- restTime = restTime + Time.deltaTime
        -- end
    -- }

    -- MessageManager.AddListener(MsgType.MainPanelSlide, function(index)
        -- timeFlag = true
        -- restTime = 0
        -- for _, v in pairs(Panels) do
            -- if v.index ~= index then
                -- TimeManager.Instance:Do(tweenTime, function()
                    -- if v.go.name ~= self.curGo.name then
                        -- if restTime >= tweenTime then
                            -- v:Hide()
                            -- timeFlag = false
                        -- end
                    -- end
                -- end )
            -- else
                -- self.curGo = v.go
            -- end
        -- end
    -- end )

	function self:GetPanelPos(panelName)
		for k, v in pairs(Panels) do
			if v.go.name == panelName then
				return self:GetPos(k)
			end
		end
	end
	
    panelRoot.localPosition = self:GetPanelPos("Fight")
    self.curPanelRootPos = panelRoot.localPosition
end

---------------底部按钮点击相关---------------

local prePos = -1

function Bottom:InitBottomButtonListener()
    self.layout = transform:Find("Bottom/Buttons/Layout")
    self.cursor = self.layout:Find("FightButton/Select")
    self.firstCursorPos = self.cursor.localPosition
    self.originalCursorPos = self.firstCursorPos
    self.sr = transform:Find("Bottom/Buttons"):GetComponent(ScrollRect)
    self.Buttons = { }
    for i = 0, self.layout.childCount - 1, 1 do
        local si = { }
        si.go = self.layout:GetChild(i).gameObject
        si.index = i
        si.go.transform:Find("Button"):GetComponent(Button).onClick:AddListener( function()
            self:OnButtonClick(si)
        end )
        si.buttonImage = si.go.transform:Find("Button"):GetComponent(Image)
        si.le = si.go:GetComponent(LayoutElement)
        si.buttonLabel = si.go.transform:Find("Text"):GetComponent(Text)
		si.division = si.go.transform:Find("Division"):GetComponent(RectTransform)
        if si.go.name ~= "FightButton" then
            si.buttonLabel.transform.gameObject:SetActive(false)
        end
        if si.index ~= 0 then
            si.L = si.go.transform:Find("L")
        end
        if si.index ~= self.layout.childCount - 1 then
            si.R = si.go.transform:Find("R")
        end
        self.Buttons[i] = si
        if si.go.name == "FightButton" then self.preButton = si end
    end

    self.isMove = false
    this.OnUpdateEvent = {
        "+=", function()
            if Input.GetMouseButtonDown(0) then self.firstCursorPos = self.cursor.localPosition end
            if not self.isMove and math.abs(Middle.offsetX) > 0 then
                self.cursor.localPosition = self.firstCursorPos + Vector3(- Middle.offsetX * 0.2, 0, 0)
            end
        end
    }
end

function Bottom:ResetCursorPos()
    self.cursor.localPosition = self.originalCursorPos
end

function Bottom:Slide(index)
    -- if Middle.preIndex == index then return end
    Tween.DOKill(self.cursor, false)
    local temp = nil
    for _, v in pairs(self.Buttons) do
        if v.index == index then temp = v end
    end
    local go = temp.go

    self.preButton.buttonLabel.transform.gameObject:SetActive(false)
    temp.buttonLabel.transform.gameObject:SetActive(true)

    Tween.DOKill(self.cursor, false)
    -- local targetPos = go.transform.position.x
    -- if temp.index > self.preButton.index then
    -- targetPos = -75 / 0.8
    -- elseif temp.index < self.preButton.index then
    -- targetPos = 75 / 0.8
    -- else
    -- targetPos = 0
    -- end
    -- targetPos = go.transform:TransformPoint(Vector3(targetPos, self.cursor.position.y, 0))
    self.cursor:SetParent(go.transform)
	self.cursor:SetAsFirstSibling()
    local res = Tween.DOLocalMoveX(self.cursor, 0, tweenTime, false)
    TweenSetting.SetEase(res, Ease.OutExpo)
    TweenSetting.OnStart(res, function()
        self.isMove = true
    end )
    TweenSetting.OnComplete(res, function()
        self.isMove = false
    end )

    if self.preButton ~= nil and self.preButton == temp then return end

    -- local image = temp.buttonImage
    -- local spriteName = String(image.sprite.name)
    -- local suffix = spriteName:Substring(spriteName.Length - 7)
    -- image.sprite = Api.LoadImmediately("UI/Textures/Main/" .. spriteName:Replace(suffix, "_select.png"), AssetType.Sprite)

    -- if self.preButton ~= nil then
    -- local preSpriteName = String(self.preButton.sprite.name)
    -- local preSuffix = preSpriteName:Substring(preSpriteName.Length - 7)
    -- self.preButton.sprite = Api.LoadImmediately("UI/Textures/Main/" .. preSpriteName:Replace(preSuffix, "_normal.png"), AssetType.Sprite)
    -- end

    Tween.DOKill(self.preButton.go.transform, false)
    res = Tween.DOScale(self.preButton.buttonImage.transform, 0.8, tweenTime)
    TweenSetting.SetEase(res, Ease.OutExpo)
    res = Tween.DOLocalMoveY(self.preButton.buttonImage.transform, -20, tweenTime, false)
    TweenSetting.SetEase(res, Ease.OutExpo)
    Tween.DOKill(self.preButton.le, false)
    res = Api.DoLayoutElement(self.preButton.le, 194, tweenTime)
    TweenSetting.SetEase(res, Ease.OutExpo)
	
	Tween.DOKill(self.preButton.go.transform, false)
	res = Api.DoRect(self.preButton.division, Vector2(240, 210), tweenTime)
    TweenSetting.SetEase(res, Ease.OutExpo)

    Tween.DOKill(temp.go.transform, false)
    res = Tween.DOScale(temp.buttonImage.transform, 1, tweenTime)
    TweenSetting.SetEase(res, Ease.OutExpo)
    res = Tween.DOLocalMoveY(temp.buttonImage.transform, 0, tweenTime, false)
    TweenSetting.SetEase(res, Ease.OutExpo)
    Tween.DOKill(temp.le, false)
    res = Api.DoLayoutElement(temp.le, 300, tweenTime)
    TweenSetting.SetEase(res, Ease.OutExpo)
	
	Tween.DOKill(temp.go.transform, false)
	res = Api.DoRect(temp.division, Vector2(345, 210), tweenTime)
    TweenSetting.SetEase(res, Ease.OutExpo)

    -- Tween.DOScale(self.preButton.L, 0, tweenTime)
    -- Tween.DOScale(self.preButton.R, 0, tweenTime)
    if self.preButton.L then
        self.preButton.L.gameObject:SetActive(false)
    end

    if temp.L then
        temp.L.gameObject:SetActive(true)
        Tween.DOKill(temp.L, false)
        temp.L.localScale = Vector3(0, 1, 1)
        res = Tween.DOScaleX(temp.L, 1, tweenTime)
        TweenSetting.SetEase(res, Ease.OutElastic)
    end

    if self.preButton.R then
        self.preButton.R.gameObject:SetActive(false)
    end

    if temp.R then
        temp.R.gameObject:SetActive(true)
        Tween.DOKill(temp.R, false)
        temp.R.localScale = Vector3(0, 1, 1)
        temp.R.gameObject:SetActive(true)
        res = Tween.DOScaleX(temp.R, -1, tweenTime)
        TweenSetting.SetEase(res, Ease.OutElastic)
    end

    -- temp.L.localPosition = Vector3(-80, -20, 0)
    -- temp.R.localPosition = Vector3(80, -20, 0)
    -- res = Tween.DOLocalMoveX(temp.L, -120, tweenTime, false)
    -- res = Tween.DOLocalMoveX(temp.R, 120, tweenTime, false)

    if index <= 1 then
        local res = ShortcutExtensions46.DOHorizontalNormalizedPos(self.sr, 0, 0.5, false)
        TweenSetting.SetEase(res, Ease.OutCubic)
    elseif index >= table.size(Panels) -2 then
        local res = ShortcutExtensions46.DOHorizontalNormalizedPos(self.sr, 1, 0.5, false)
        TweenSetting.SetEase(res, Ease.OutCubic)
    end

    self.preButton = temp
end

function Bottom:OnButtonClick(temp)
    local index = temp.index
    if Middle.curIndex == index then return end
    Middle:Slide(index)
    --Heros:HideSelectGo()
	
	if index == 5 then
		--club按钮 测试使用
        --Api.loadRecoderFile()
		g_Records:reqRecords()
	end
 
    -- Middle:ShowAllPanels()
end

function Bottom:OnOpen()
	TimeManager.Instance:Do(Time.deltaTime, function()
		if prePos ~= -1 then
			self.slider.horizontalNormalizedPosition = prePos
		end
	end)
end

function Bottom:OnClose()
	prePos = self.slider.horizontalNormalizedPosition
end

---------------Fight面板相关---------------
local Fight = { }
MainPanel.Fight = Fight
function Fight:Init()
	local content = transform:Find("Panels/Fight")
	local scoreLabel = content:Find("ArenaScore/ScoreLabel"):GetComponent(Text)
	local dailyProgressContent = content:Find("Task/Layout/Content")
	local dailyTarget = content:Find("Task/Layout/DesLabel"):GetComponent(Text)
	local dailyLabel = content:Find("Task/Label"):GetComponent(Text)
	local dailyBg = content:Find("Task"):GetComponent(Image)
	
	local mapIcon = content:Find("Middle/Map"):GetComponent(Image)
	local mapName = content:Find("Middle/Map/MapName"):GetComponent(Text)
	
	local heroCardSlider = content:Find("HeroFragment/Bg"):GetComponent(Slider)
	local skillCardSlider = content:Find("Skill/Bg"):GetComponent(Slider)
	local coinSlider = content:Find("Coin/Bg"):GetComponent(Slider)
	
	local heroCardLabel = content:Find("HeroFragment/Bg/DeltaLabel"):GetComponent(Text)
	local skillCardLabel = content:Find("Skill/Bg/DeltaLabel"):GetComponent(Text)
	local coinLabel = content:Find("Coin/Bg/DeltaLabel"):GetComponent(Text)
	
	local accountLabel = content:Find("PlayerInfo/Bg/NameLabel"):GetComponent(Text)
	local unionLabel = content:Find("PlayerInfo/Bg/TradeUnionLabel"):GetComponent(Text)
	
	local dailySerialId = math.floor(quest.DailyMissionId / 1000)
	local curTime, totalTime = 0, 0
	local available = false
	self.timeDown = false
	
	dailyBg:GetComponent(UIButton).onClick:AddListener(function()
		OpenBoxId = 1000
		SystemLogic.recvMissionAward(quest.DailyMissionId)
	end)
	
    -- 每日任务刷新倒计时
	function self:RefreshTime()
		TimeManager.Instance:Do(1, function()
			if self.timeDown == false then return end
			curTime = totalTime - os.time()
			local h, m, s = 0, 0, 0
			if curTime >= 0 then
				h, m, s = ConvertTime(curTime)
			else
				curTime = 0
				SystemLogic.Instance:updateMissionData(quest.DailyMissionId)
				return
			end
			local sh, sm, ss = tostring(h), tostring(m), tostring(math.floor(s))
			if h < 10 then sh = "0" .. sh end
			if m < 10 then sm = "0" .. sm end
			if s < 10 then ss = "0" .. ss end
			dailyTarget.text = "剩余刷新时间:\n" .. "<color='#88FF8EFF'>" .. sh .. ":" .. sm .. ":" .. ss .. '</color>'
			self:RefreshTime()
		end)
	end
	
	-- 任务信息更新监听
	MessageManager.AddListener(MsgType.UpdateMission, function(m)
		local sInfo = m[dailySerialId]
		local missionInfo = ConfigReader.GetMissionCfg(sInfo.dataId)
		dailyLabel.text = missionInfo.szName
		local bgName = ""
		if sInfo.flag == 0 then
			-- 未领取奖励
			if sInfo.progress < missionInfo.n32GoalCon then
				dailyProgressContent.gameObject:SetActive(true)
				local count = dailyProgressContent.childCount
				for i = 0, count -1 do
					local go = dailyProgressContent:GetChild(i).gameObject
					go:SetActive(i < sInfo.progress)
				end
				dailyTarget.text = missionInfo.szContent
				bgName = "gongneng2.png"
				available = false
				self.timeDown = false
			else
				dailyProgressContent.gameObject:SetActive(false)
				dailyTarget.text = "打开宝箱"
				bgName = "gongneng.png"
				available = true
				self.timeDown = false
			end
		elseif sInfo.flag == 1 then
			-- 已领取奖励
			dailyProgressContent.gameObject:SetActive(false)
			totalTime = os.time() + sInfo.time
			bgName = "gongneng.png"
			available = false
			if self.timeDown == false then
				self:RefreshTime()
			end
			self.timeDown = true
		end
		Api.Load("UI/Textures/Main/" .. bgName, AssetType.Sprite, function(s)
			dailyBg.sprite = s
		end)
	end)
	
	-- 地图点击监听
	transform:Find("Panels/Fight/Middle/Map"):GetComponent(UIButton).onClick:AddListener(function()
		UIManager.Instance:OpenPanel("ArenaDeltaPanel", true)
		SoundManager.Instance:Play("button004", false)
	end)
	
	-- 打开设置面板
	content:Find("Setting/SettingButton"):GetComponent(Button).onClick:AddListener(function()
		DialogManager.Instance:Open("SettingDialog")
	end)
	
	-- 打开玩家信息面板
	content:Find("PlayerInfo/Icon"):GetComponent(Button).onClick:AddListener(function()
		DialogManager.Instance:Open("PlayerInfoDialog")
	end)
	
	-- 打开成就面板
	content:Find("Middle/Achievement"):GetComponent(UIButton).onClick:AddListener(function()
		DialogManager.Instance:Open("MissionDialog")
		SoundManager.Instance:Play("button004", false)
	end)
	
	-- 打开排行榜面板
	content:Find("Middle/RankList"):GetComponent(UIButton).onClick:AddListener(function()
		DialogManager.Instance:Open("RankListDialog")
		SoundManager.Instance:Play("button004", false)
	end)
	
	-- 打开公告
	content:Find("Middle/Notice"):GetComponent(UIButton).onClick:AddListener(function()
		DialogManager.Instance:Open("AnnouncementDialog", "你好！\n　　欢迎来到<color=green>三个英雄</color>！")
		SoundManager.Instance:Play("button004", false)
	end)
	
	-- 打开战斗记录面板
	content:Find("Middle/Video"):GetComponent(UIButton).onClick:AddListener(function()
		DialogManager.Instance:Open("BattleRecordDialog")
		SoundManager.Instance:Play("button004", false)
	end)
	
	-- 添加竞技场积分监听
	MessageManager.AddListener(MsgType.UpdateAccountData, function(a)
		scoreLabel.text = a.exp
	end)
	
	-- 开始匹配
	content:Find("MatchButton"):GetComponent(Button).onClick:AddListener( function()
		TimeManager.Instance:Do(Time.deltaTime, function()
			if isDrag then return end
			UIManager.Instance:OpenPanel("MatchPanel", true)
			Api.RequestMatch()
			SoundManager.Instance:Play("button004", false)
		end )
	end )			
	
	-- 账号数据更新监听
	MessageManager.AddListener(MsgType.UpdateAccountData, function(arg)
		mapIcon.sprite = Api.LoadImmediately(quest.Arena[Account.level].BattleGroundPreview, AssetType.Sprite)
		mapIcon:SetNativeSize()
		mapName.text = quest.Arena[Account.level].Name
		accountLabel.text = arg.accountId
		unionLabel.text = "暂无工会"
	end)
	
	-- Pvp参赛场次更新监听
	MessageManager.AddListener(MsgType.PvpTimes, function(num)
		if num > quest.Arena[Account.level].GoldRewardLimit then
			num = quest.Arena[Account.level].GoldRewardLimit
		end
		coinSlider.value = num / quest.Arena[Account.level].GoldRewardLimit
		coinLabel.text = num .. "/" .. quest.Arena[Account.level].GoldRewardLimit
	end)
	
	-- Pvp胜利场次更新监听
	MessageManager.AddListener(MsgType.PvpWinTimes, function(num)
		if num > quest.Arena[Account.level].VictoryRewardLimit then
			num  = quest.Arena[Account.level].VictoryRewardLimit
		end
		heroCardSlider.value = num / quest.Arena[Account.level].VictoryRewardLimit
		heroCardLabel.text = num .. "/" .. quest.Arena[Account.level].VictoryRewardLimit
		skillCardSlider.value = num / quest.Arena[Account.level].VictoryRewardLimit
		skillCardLabel.text = num .. "/" .. quest.Arena[Account.level].VictoryRewardLimit
	end)
	
	MessageManager.HandleMessage(MsgType.UpdateAccountData, Account)
	
end

--------------------商店--------------------
local Shop = { }
MainPanel.Shop = Shop
-- 卡牌剩余购买次数
local CardRemainingBuyNum = { }

-- 请求刷新商店卡牌剩余购买次数
function Shop:RefreshShopCardRemainingBuyNum()
	for i = 1001, 1003 do
		local uid = g_Activity:calcAccountUid(i)
		SystemLogic.Instance:UpdateActivityData(uid)
	end
end
	
function Shop:Init()
    local refreshTimeLabel = transform:Find("Panels/Store/Shop/ScrollRect/View/Content/Top/RefreshTimeLabel"):GetComponent(Text)
    local content = transform:Find("Panels/Store/Shop/ScrollRect/View/Content")
    local gift = content:Find("Gift/GiftButton")
    local cardRoot = content:Find("Card/Content")
    local diamondRoot = content:Find("Diamond/Content")
    local heroBoxRoot = content:Find("HeroBox/Content")
    local skillBoxRoot = content:Find("SkillBox/Content")
    local coinRoot = content:Find("Coin/Content")
    local curBatch = -1
    local OpenSprites = {
        red1 = Api.LoadImmediately("UI/Textures/SequenceTextures/OpenBox/red1.png",AssetType.Sprite),
        red2 = Api.LoadImmediately("UI/Textures/SequenceTextures/OpenBox/red2.png",AssetType.Sprite),
        red3 = Api.LoadImmediately("UI/Textures/SequenceTextures/OpenBox/red3.png",AssetType.Sprite),
        blue1 = Api.LoadImmediately("UI/Textures/SequenceTextures/OpenBox/blue1.png",AssetType.Sprite),
        blue2 = Api.LoadImmediately("UI/Textures/SequenceTextures/OpenBox/blue2.png",AssetType.Sprite),
        blue3 = Api.LoadImmediately("UI/Textures/SequenceTextures/OpenBox/blue3.png",AssetType.Sprite),
        green1 = Api.LoadImmediately("UI/Textures/SequenceTextures/OpenBox/green1.png",AssetType.Sprite),
        green2 = Api.LoadImmediately("UI/Textures/SequenceTextures/OpenBox/green2.png",AssetType.Sprite),
        green3 = Api.LoadImmediately("UI/Textures/SequenceTextures/OpenBox/green3.png",AssetType.Sprite),
    }
	local heroItem = Api.LoadImmediately("UI/Panels/MainPanel/Shop/HeroItem.prefab", AssetType.Prefab)
	local skillItem = Api.LoadImmediately("UI/Panels/MainPanel/Shop/SkillItem.prefab", AssetType.Prefab)
	local diamondItem = Api.LoadImmediately("UI/Panels/MainPanel/Shop/DiamondItem.prefab", AssetType.Prefab)
	local boxItem = Api.LoadImmediately("UI/Panels/MainPanel/Shop/BoxItem.prefab", AssetType.Prefab)
	local coinItem = Api.LoadImmediately("UI/Panels/MainPanel/Shop/CoinItem.prefab", AssetType.Prefab)
    self.sr = transform:Find("Panels/Store/Shop/ScrollRect"):GetComponent(ScrollRect)
    self.CardList = { }
    self.DiamondList = { }
    self.BoxList = { }
    self.CoinList = { }
	self.totalTime = 0
    self.curTime = 0
    self.isDown = false
	self.preLevel = 0
	
	local timeDown = false

    this.OnUpdateEvent = {
        "+=", function()
			if not this.isOpen then return end
            if Input.GetMouseButtonDown(0) then
                self.isDown = true
                self.sr.vertical = true
            end
            if Input.GetMouseButtonUp(0) then
                self.isDown = false
            end
            if self.isDown then
                if MouseDragDir == nil or MouseDragDir == "vertical" then
                    self.sr.vertical = true
                else
                    self.sr.vertical = false
                end
            end
        end
    }

    -- 请求刷新商店卡牌
    function self:RefreshShopCard()
		for i = 0, 2 do
			local uid = g_Activity.calcSysUid(i)
			SystemLogic.Instance:UpdateActivityData(uid)
		end
    end
	
	-- 检测特惠商品显示
	function self:CheckGift()
		local uid = g_CoolDown:calcAccountUid(CoolDownSysType.TimeLimitSale)
		SystemLogic.Instance:UpdateCDData(uid)
	end
	
    -- 刷新倒计时
	function self:RefreshTime()
		TimeManager.Instance:Do(1, function()
			if timeDown == false then return end
			self.curTime = self.totalTime - os.time()
			local h, m, s = 0, 0, 0
			if self.curTime >= 0 then
				h, m, s = ConvertTime(self.curTime)
			else
				self.curTime = 0
				g_CoolDown:RefreshShopCd()
			end
			local sh, sm, ss = tostring(h), tostring(m), tostring(math.floor(s))
			if h < 10 then sh = "0" .. sh end
			if m < 10 then sm = "0" .. sm end
			if s < 10 then ss = "0" .. ss end
			if refreshTimeLabel == nil then return end
			refreshTimeLabel.text = "剩余刷新时间:\n" .. "<color='#88FF8EFF'>" .. sh .. ":" .. sm .. ":" .. ss .. '</color>'
			self:RefreshTime()
		end)
	end
	

    -- 倒计时刷新监听
    MessageManager.AddListener(MsgType.UpdateShopCd, function(s)
		if not this.isOpen then return end
        self.totalTime = os.time() + s
		if timeDown == false then
			self:RefreshTime()
			timeDown = true
		end
		self:RefreshShopCard()
        self:RefreshShopCardRemainingBuyNum()
    end )

    -- 卡牌刷新监听
    MessageManager.AddListener(MsgType.RefreshShopCard, function(t)
		self:UpdateCard(t)
    end )

    -- 卡牌剩余购买次数刷新监听
    MessageManager.AddListener(MsgType.RefreshShopRemainingCardNum, function(str)
        CardRemainingBuyNum[str.index] = str.value
		--Debug.LogError(str.index .. " " .. str.value)
    end )

    -- 已拥有卡牌数量更新监听
    MessageManager.AddListener(MsgType.UpdateHeroData, function(p)
		for pa in Slua.iter(p) do
			for k, v in pairs(self.CardList) do
				if v.otherInfo.id == pa.value.dataId then
					v:Update(v.shopInfo.id)
				end
			end
		end
		self:RefreshShopCardRemainingBuyNum()
    end )
	
	-- 技能卡牌数据更新监听
	MessageManager.AddListener(MsgType.UpdataSkillData, function(p)
		for pa in Slua.iter(p) do
			for k, v in pairs(self.CardList) do
				if v.otherInfo.id == pa.value.dataId then
					v:Update(v.shopInfo.id)
				end
			end
		end
		self:RefreshShopCardRemainingBuyNum()
	end)
		
	-- 特惠商品刷新监听
	MessageManager.AddListener(MsgType.RefreshGift, function(cd)
		cd = -1
		gift.parent.gameObject:SetActive(cd > 0)
		-- Debug.LogError("cd->" .. cd)
	end)

    -- 卡牌
    function self:UpdateCard(t)
		local pre = nil
		if t.index == 0 then
			pre = heroItem
		else
			pre = skillItem
		end
		if Shop.CardList[t.index] == nil then
			local si = { }
			si.go = GameObject.Instantiate(pre)
			si.go.transform:SetParent(cardRoot)
			Api.SetTag(si.go, "MainPanel_Panels")
			si.go.transform.localScale = Vector3.one
			si.go.transform.localEulerAngles = Vector3.zero
			si.name = si.go.transform:Find("Name"):GetComponent(Text)
			si.icon = si.go.transform:Find("Icon/Icon"):GetComponent(Image)
			si.slider = si.go.transform:Find("Bg"):GetComponent(Slider)
			si.fg = si.go.transform:Find("Bg/Fg"):GetComponent(Image)
			si.fullLevel = si.go.transform:Find("Bg/Fg/FullLevel")
			si.sliderDelta = si.go.transform:Find("Bg/NumLabel"):GetComponent(Text)
			si.price = si.go.transform:Find("PriceLabel"):GetComponent(Text)
			si.listener = si.go:GetComponent(UIButton)
			
			si.index = t.index
			si.buyNum = 0
			
			-- id：shopId
			function si:Update(id)
				if id == nil then return end
				si.shopInfo = ConfigReader.GetShopCfg(id)
				si.propInfo = ConfigReader.GetItemCfg(si.shopInfo.n32GoodsID)
				si.name.text = si.shopInfo.szName
				Api.Load(si.shopInfo.szIcon, AssetType.Sprite, function(s)
					si.icon.sprite = s
				end)
				si.price.text = si.shopInfo.n32Price * (si.buyNum + 1)
				
				if si.index == 0 then
					si.own, si.sInfo = Api.HasHero(si.propInfo.n32Retain1)
					if si.own then
						si.otherInfo = ConfigReader.GetHeroInfo(si.sInfo.dataId)
					else
						si.otherInfo = ConfigReader.GetHeroInfo(si.propInfo.n32Retain1)
					end
					if si.own then
						si.slider.value = si.sInfo.count / si.otherInfo.n32WCardNum
						if si.otherInfo.n32WCardNum == 0 then
							si.sliderDelta.text = si.sInfo.count .. "/~"
						else
							si.sliderDelta.text = si.sInfo.count .. "/" .. si.otherInfo.n32WCardNum
						end
					else
						si.slider.value = 0
						si.sliderDelta.text = "0/" .. si.otherInfo.n32WCardNum
					end
				else
					si.own, si.sInfo = Api.HasSkill(si.propInfo.n32Retain1)
					if si.own then
						si.otherInfo = ConfigReader.GetSkillDataInfo(si.sInfo.dataId)
					else
						si.otherInfo = ConfigReader.GetSkillDataInfo(si.propInfo.n32Retain1)
					end
					if si.own then
						si.slider.value = si.sInfo.count / si.otherInfo.n32NeedStuff
						if si.otherInfo.n32NeedStuff == 0 then
							si.sliderDelta.text = si.sInfo.count .. "/~"
						else
							si.sliderDelta.text = si.sInfo.count .. "/" .. si.otherInfo.n32NeedStuff
						end
					else
						si.slider.value = 0
						si.sliderDelta.text = "0/" .. si.otherInfo.n32NeedStuff
					end
				end
				
				if si.slider.value >= 1 then
					if (si.own and si.index ~= 0 and si.otherInfo.n32Upgrade < 9) or (si.own and si.index == 0 and si.otherInfo.n32Quality < 25) then
						PlayFullLevel(si.fullLevel)
						si.fg.sprite = Api.LoadImmediately("UI/Textures/Common/Lvjintu.png", AssetType.Sprite)
					else
						StopFullLevel(si.fullLevel)
						si.fg.sprite = Api.LoadImmediately("UI/Textures/Common/jingdutiao.png", AssetType.Sprite)
					end
				else
					StopFullLevel(si.fullLevel)
					si.fg.sprite = Api.LoadImmediately("UI/Textures/Common/jingdutiao.png", AssetType.Sprite)
				end
				
				if Account.gold >= si.shopInfo.n32Price then
					local _, color = ColorUtility.TryParseHtmlString("#FFBA45FF")
					si.price.color = color
				else
					si.price.color = Color.red
				end
			end
			
			si:Update(t.value)
			
			si.listener.onClick:AddListener(function()
				if si.shopInfo.n32Price <= Account.gold then
					if si.index == 0 then
						DialogManager.Instance:Open("HeroCardDialog", si.shopInfo, si.propInfo, CardRemainingBuyNum[si.index], si.index)
					else
						DialogManager.Instance:Open("SkillCardDialog", si.shopInfo, si.propInfo, CardRemainingBuyNum[si.index], si.index)
					end
				else
					DialogManager.Instance:OpenNormal( function(nb)
						nb:Open("提示", "你的金币不足，是否前去购买？", "前去购买", Color.white, function()
							MessageManager.HandleMessage(MsgType.SlideToCoin, nil)
							nb:OnClose()
						end , nil, nil)
					end )
				end
			end)
			
			-- 卡牌剩余购买次数刷新监听
			MessageManager.AddListener(MsgType.RefreshShopRemainingCardNum, function(str)
				if str.index == si.index then
					si.buyNum = str.value
					si:Update(si.shopInfo.id)
				end
			end )
			
			MessageManager.AddListener(MsgType.UpdateAccountData, function(a)
				if Account.gold >= si.shopInfo.n32Price then
					local _, color = ColorUtility.TryParseHtmlString("#FFBA45FF")
					si.price.color = color
				else
					si.price.color = Color.red
				end
			end)
			
			Shop.CardList[t.index] = si
		else
			Shop.CardList[t.index]:Update(t.value)
		end
    end

    -- 分类数据id
    local diamonds, boxs, coins, cards, gifts = { }, { }, { }, { }, { }
    for p in Slua.iter(ConfigReader.shopInfoDic) do
		--Debug.LogError(p.value.id)
        if p.value.n32Type == 1 then
            table.insert(diamonds, p.value)
        elseif p.value.n32Type == 2 then
            table.insert(coins, p.value)
        elseif p.value.n32Type == 3 then
			table.insert(boxs, p.value)
        elseif p.value.n32Type == 4 then
            table.insert(cards, p.value)
        elseif p.value.n32Type == 5 then
            table.insert(gifts, p.value)
        end
    end

    -- 钻石
    function self:UpdateDiamond()
		local co = coroutine.create(function()
			for _, v in pairs(Shop.DiamondList) do
				GameObject.Destroy(v.go)
				Yield(WaitForEndOfFrame())
			end
			Shop.DiamondList = { }
			for _, v in pairs(diamonds) do
				local si = { }
				si.shopInfo = v
				si.go = GameObject.Instantiate(diamondItem)
				si.go.transform:SetParent(diamondRoot)
				si.go.transform.localScale = Vector3.one
				si.go.transform.localPosition = Vector3.zero
				si.go.transform.localEulerAngles = Vector3.zero
				Api.SetTag(si.go, "MainPanel_Panels")
				si.nameLabel = si.go.transform:Find("NameLabel"):GetComponent(Text)
				si.icon = si.go.transform:Find("Icon"):GetComponent(Image)
				si.countLabel = si.go.transform:Find("PriceLabel"):GetComponent(Text)
				si.button = si.go:GetComponent(UIButton)
				si.nameLabel.text = si.shopInfo.szName
				si.countLabel.text = "￥" .. si.shopInfo.n32Price
				Api.Load(si.shopInfo.szIcon, AssetType.Sprite, function(sp)
					si.icon.sprite = sp
					si.icon:SetNativeSize()
				end )
				si.button.onClick:AddListener( function(temp)
					DialogManager.Instance:OpenNormal( function(nb)
						nb:Open(v.szName, v.n32Price .. "元换" .. v.n32Count .. "个钻石？", "确定", Color.white, function()
							-- Api.SendGMCmd("addmoney", v.n32Count, 0)
							SystemLogic.Instance:buyItem(v.id, 1)
							nb:OnClose()
						end , Api.LoadImmediately(si.shopInfo.szIcon, AssetType.Sprite), nil)
					end )
				end )
				table.insert(Shop.DiamondList, si)
				Yield(WaitForEndOfFrame())
			end
		end)
		if table.size(Shop.DiamondList) <= 0 then
			coroutine.resume(co)
		end
    end

    -- 宝箱
    function self:UpdateBox()
		local co = coroutine.create(function()
			for _, v in pairs(Shop.BoxList) do
				GameObject.Destroy(v.go)
				Yield(WaitForEndOfFrame())
			end
			Shop.BoxList = { }
			for _, v in pairs(boxs) do
				if v.n32ArenaLvLwLimit == Account.level then
					local si = { }
					si.go = GameObject.Instantiate(boxItem)
					if v.n32Site <= 2 then
						si.go.transform:SetParent(heroBoxRoot)
					else
						si.go.transform:SetParent(skillBoxRoot)
					end
					si.go.transform.localScale = Vector3.one
					si.go.transform.localPosition = Vector3.zero
					si.go.transform.localEulerAngles = Vector3.zero
					Api.SetTag(si.go, "MainPanel_Panels")
					si.nameLabel = si.go.transform:Find("TitleLabel"):GetComponent(Text)
					si.icon = si.go.transform:Find("Bg/Icon"):GetComponent(Image)
					si.levelLabel = si.go.transform:Find("Bg/LevelBg/Text"):GetComponent(Text)
					si.priceLabel = si.go.transform:Find("PriceLabel"):GetComponent(Text)
					si.button = si.go:GetComponent(UIButton)
					si.nameLabel.text = v.szName
					si.priceLabel.text = v.n32Price
					si.levelLabel.text = v.n32ArenaLvLwLimit .. "阶"
					Api.Load(v.szIcon, AssetType.Sprite, function(sp)
						si.icon.sprite = sp
						si.icon:SetNativeSize()
					end )
					si.button.onClick:AddListener( function(temp)
						--打开宝箱消息
						if Account.buyboxtimes < 1 then
							MessageBox.Instance:OpenText("今日购买次数已达上限，请明日购买", Color.red, 1.5, MessageBoxPos.Middle)
							return
						end
						local c
						if Account.money >= v.n32Price then
							c = Color.white
							OpenBoxId = v.id
							if v.n32Site <= 2 then
								DialogManager.Instance:Open("HeroBoxDialog", v)
							else
								DialogManager.Instance:Open("SkillBoxDialog", v)
							end
						else
							c = Color.red
							DialogManager.Instance:OpenNormal( function(nb)
								nb:Open("提示", "你的钻石不足，是否前去购买？", "前去购买", Color.white, function()
									MessageManager.HandleMessage(MsgType.SlideToDiamond, nil)
									nb:OnClose()
								end , nil, nil)
							end )
						end
					end )
					MessageManager.AddListener(MsgType.UpdateAccountData, function(a)
						if a.money >= v.n32Price then
							si.priceLabel.color = Color.white
						else
							si.priceLabel.color = Color.red
						end
					end )
					MessageManager.HandleMessage(MsgType.UpdateAccountData, Account)
					table.insert(Shop.BoxList, si)
					Yield(WaitForEndOfFrame())
				end
			end
		end)
		if Shop.preLevel ~= Account.level then
			coroutine.resume(co)
			Shop.preLevel = Account.level
		end
    end

    -- 金币
    function self:UpdateCoin()
		local co = coroutine.create(function()
			for _, v in pairs(Shop.CoinList) do
				GameObject.Destroy(v.go)
				Yield(WaitForEndOfFrame())
			end
			Shop.CoinList = { }
			for _, v in pairs(coins) do
				local si = { }
				si.go = GameObject.Instantiate(coinItem)
				si.go.transform:SetParent(coinRoot)
				si.go.transform.localScale = Vector3.one
				si.go.transform.localPosition = Vector3.zero
				si.go.transform.localEulerAngles = Vector3.zero
				Api.SetTag(si.go, "MainPanel_Panels")
				si.nameLabel = si.go.transform:Find("NameLabel"):GetComponent(Text)
				si.icon = si.go.transform:Find("Icon"):GetComponent(Image)
				si.diamondLabel = si.go.transform:Find("PriceLabel"):GetComponent(Text)
				si.button = si.go:GetComponent(UIButton)
				si.nameLabel.text = v.szName
				si.diamondLabel.text = v.n32Price .. ""
				Api.Load(v.szIcon, AssetType.Sprite, function(sp)
					si.icon.sprite = sp
					si.icon:SetNativeSize()
				end )
				si.button.onClick:AddListener( function(temp)
					local c
					if Account.money >= v.n32Price then
						c = Color.white
						DialogManager.Instance:OpenNormal( function(nb)
							nb:Open(v.szName, v.n32Price .. "个钻石换" .. v.n32Count .. "金币？", "确定", c, function()
								-- Api.SendGMCmd("addmoney", -v.n32Price, v.n32Count)
								nb:OnClose()
								SystemLogic.Instance:buyItem(v.id, 1)
							end , Api.LoadImmediately(v.szIcon, AssetType.Sprite), nil)
						end )
					else
						c = Color.red
						DialogManager.Instance:OpenNormal( function(nb)
							nb:Open("提示", "你的钻石不足，是否前去购买？", "进入商店", Color.white, function()
								MessageManager.HandleMessage(MsgType.SlideToDiamond, nil)
								nb:OnClose()
							end , nil, nil)
						end )
					end
				end )
				MessageManager.AddListener(MsgType.UpdateAccountData, function(a)
					if a.money >= v.n32Price then
						local _, color = ColorUtility.TryParseHtmlString("#FFBA45FF")
						si.diamondLabel.color = color
					else
						si.diamondLabel.color = Color.red
					end
				end )
				MessageManager.HandleMessage(MsgType.UpdateAccountData, Account)
				table.insert(Shop.CoinList, si)
				Yield(WaitForEndOfFrame())
			end
		end )
		if table.size(Shop.CoinList) <= 0 then
			coroutine.resume(co)
		end
    end

end

--------------------探索--------------------
local Explore = { }
MainPanel.Explore = Explore
local Entry = { }
Explore.Entry = Entry
function Explore:Init()
	local prefab = Api.LoadImmediately("UI/Panels/MainPanel/Explore/Item.prefab", AssetType.Prefab)
	local content = transform:Find("Panels/Explore/Content")
	local preSlot, curSlot = nil, nil
	local index = 0
	local firstInit = true
	
	MessageManager.AddListener(MsgType.UpdateExplore, function(info)
		if Entry[info.uuid] == nil then
			local si = { }
			si.index = index
			index = index + 1
			si.sinfo = info
			si.info = ConfigReader.GetExplorepCfg(info.dataId)
			si.go = GameObject.Instantiate(prefab)
			si.go.transform:SetParent(content)
			si.go.transform.localEulerAngles = Vector3.zero
			si.go.transform.localScale = Vector3.one
			si.mapIcon = si.go.transform:Find("MapIcon"):GetComponent(Image)
			si.titleBg = si.go.transform:Find("TitleBg"):GetComponent(Image)
			si.title = si.go.transform:Find("Title"):GetComponent(Text)
			si.des = si.go.transform:Find("Des"):GetComponent(Text)
			si.freeLabel = si.go.transform:Find("FreeButton/Text"):GetComponent(Text)
			si.boxButton = si.go.transform:Find("BoxButton"):GetComponent(UIButton)
			si.buttonLabel = si.go.transform:Find("GoButton/Text"):GetComponent(Text)
			si.goButton = si.buttonLabel.transform.parent.gameObject
			si.freeImage = si.go.transform:Find("FreeButton"):GetComponent(Image)
			si.diamond = si.go.transform:Find("FreeButton/Text/DiamondIcon").gameObject
			si.goImage = si.goButton:GetComponent(Image)
			si.rewardBg = si.go.transform:Find("RewardBg").gameObject
			si.coinLabel = si.go.transform:Find("RewardBg/CoinLabel"):GetComponent(Text)
			si.heroLabel = si.go.transform:Find("RewardBg/HeroLabel"):GetComponent(Text)
			si.skillLabel = si.go.transform:Find("RewardBg/SkillLabel"):GetComponent(Text)
			si.titleBg = si.go.transform:Find("TitleBg"):GetComponent(Image)
			si.coin = 0
			si.hero = 0
			si.skill = 0
			si.curTime = 0
			si.totalTime = 0
			si.timeDown = false
			
			si.go.transform:Find("FreeButton"):GetComponent(UIButton).onClick:AddListener(function()
				--探索的刷新
				if Account.exploretimes < 1 then
				   MessageBox.Instance:OpenText("今日刷新次数已达上限", Color.red, 1.5, MessageBoxPos.Middle)
				end
				if si.sinfo.time ~= 0 then return end
				g_exploreManager:exploreRefresh(si.sinfo.uuid)
			end)
			
			si.go.transform:Find("GoButton"):GetComponent(UIButton).onClick:AddListener(function()
				if si.sinfo.time ~= 0 then return end
				local uuid0, uuid1, uuid2
				if si.Slots[0].info then
					uuid0 = AgentData.Instance:getCardByDataId(si.Slots[0].info.id).uuid
				end
				if si.Slots[1].info then
					uuid1 = AgentData.Instance:getCardByDataId(si.Slots[1].info.id).uuid
				end
				if si.Slots[2].info then
					uuid2 = AgentData.Instance:getCardByDataId(si.Slots[2].info.id).uuid
				end
				
				if uuid0 == nil and uuid1 == nil and uuid2 == nil then
					MessageBox.Instance:OpenText("选择探索卡牌!", Color.yellow, 1, MessageBoxPos.Middle)
					return
				end
				
				g_exploreManager:exploreBegin(si.sinfo.uuid, uuid0, uuid1, uuid2)
				UIManager.Instance:ClosePanel("ExpeditionPanel")
			end)
			
			si.boxButton.onClick:AddListener(function()
				g_exploreManager:exploreEnd(si.sinfo.uuid)
				OpenBoxId = 1100
			end)
			
			-- 刷新倒计时
			function si:RefreshTime()
				TimeManager.Instance:Do(1, function()
					if si.timeDown == false then return end
					si.curTime = si.totalTime - os.time()
					if si.curTime > 0 then
						--Debug.LogError(si.curTime)
						local h, m, s = 0, 0, 0
						if si.goButton.activeSelf == false then
							si.goButton:SetActive(true)
						end
						if si.boxButton.gameObject.activeSelf == false then
							si.boxButton.gameObject:SetActive(false)
						end
						h, m, s = ConvertTime(si.curTime)
						local sh, sm, ss = tostring(h), tostring(m), tostring(math.floor(s))
						if h < 10 then sh = "0" .. sh end
						if m < 10 then sm = "0" .. sm end
						if s < 10 then ss = "0" .. ss end
						si.buttonLabel.text = "进行中:\n" .. "<color='#88FF8EFF'>" .. sh .. ":" .. sm .. ":" .. ss .. '</color>'
						si:RefreshTime()
					else--if si.curTime < 0 then
						si.rewardBg:SetActive(false)
						si.goButton:SetActive(false)
						si.boxButton.gameObject:SetActive(true)
					-- else
						-- si.rewardBg:SetActive(true)
						-- si.goButton:SetActive(true)
						-- si.boxButton.gameObject:SetActive(false)
					end
				end)
			end
			
			function si:GetUuid()
				local t = { }
				local uuid0, uuid1, uuid2 = "", "", ""
				if si.Slots[0].info then
					uuid0 = AgentData.Instance:getCardByDataId(si.Slots[0].info.id).uuid
				end
				if si.Slots[1].info then
					uuid1 = AgentData.Instance:getCardByDataId(si.Slots[1].info.id).uuid
				end
				if si.Slots[2].info then
					uuid2 = AgentData.Instance:getCardByDataId(si.Slots[2].info.id).uuid
				end
				table.insert(t, uuid0)
				table.insert(t, uuid1)
				table.insert(t, uuid2)
				return t
			end
			
			si.Slots = { }
			si.slotContent = si.go.transform:Find("SlotContent")
			
			for k = 0, si.slotContent.childCount - 1 do
				local slotGo = si.slotContent:GetChild(k).gameObject
				local item = { }
				item.index = k
				item.go = slotGo
				item.heroIcon = slotGo.transform:Find("HeroIcon"):GetComponent(Image)
				item.edge = slotGo.transform:Find("HeroIcon/Edge"):GetComponent(Image)
				item.influenceIcon = slotGo.transform:Find("InfluenceIcon"):GetComponent(Image)
				item.typeIcon = slotGo.transform:Find("TypeIcon"):GetComponent(Image)
				item.light = slotGo.transform:Find("Light").gameObject
				item.bg = item.go:GetComponent(Image)
				
				item.go:GetComponent(Button).onClick:AddListener(function()
					if si.sinfo.time ~= 0 then return end
					TimeManager.Instance:Do(Time.deltaTime, function()
						if isDrag then return end
						preSlot = curSlot
						curSlot = item
						if preSlot then
							preSlot:LoseFocus()
						end
						if curSlot then
							curSlot:GetFocus()
						end
						Tween.DOKill(content, false)
						local targetPos = Vector2(0, 960) - content.parent:InverseTransformPoint(si.go.transform.position)
						local res = Tween.DOLocalMoveY(content, targetPos.y + content.localPosition.y, 0.5, false)
						TweenSetting.SetEase(res, Ease.OutExpo)
						UIManager.Instance:OpenPanel("ExpeditionPanel", false, si.sinfo, item.index, item.info)
					end )
				end)
				
				function item:LoseFocus()
					item.light:SetActive(false)
				end
				
				function item:GetFocus()
					item.light:SetActive(true)
				end
				
				function item:RefreshCondition()
					if item.info then
						if si.sinfo["cam" .. item.index] == item.info.n32Camp then
							item.influenceIcon.material = nil
						else
							item.influenceIcon.material = Api.GreyMat
						end
						if si.sinfo["att" .. item.index] == item.info.n32MainAtt then
							item.typeIcon.material = nil
						else
							item.typeIcon.material = Api.GreyMat
						end
					else
						item.typeIcon.material = nil
						item.influenceIcon.material = nil
					end
				end
				
				function item:Update()
					local expinfo = g_exploreManager:getExploreByIndex(si.index)
					if item.index == 0 then
						item.influenceIcon.gameObject:SetActive(si.sinfo.cam0 ~= 0)
						item.typeIcon.gameObject:SetActive(si.sinfo.att0 ~= 0)
						if si.sinfo.cam0 == 1 then
							item.influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/H.png", AssetType.Sprite)
						elseif si.sinfo.cam0 == 2 then
							item.influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/l.png", AssetType.Sprite)
						elseif si.sinfo.cam0 == 4 then
							item.influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/R.png", AssetType.Sprite)
						end
						if si.sinfo.att0 == 1 then
							item.typeIcon.sprite = Api.LoadImmediately("UI/Textures/Common/liliang.png", AssetType.Sprite)
						elseif si.sinfo.att0 == 2 then
							item.typeIcon.sprite = Api.LoadImmediately("UI/Textures/Common/mingjie.png", AssetType.Sprite)
						elseif si.sinfo.att0 == 3 then
							item.typeIcon.sprite = Api.LoadImmediately("UI/Textures/Common/zhili.png", AssetType.Sprite)
						end
						if si.sinfo.time ~= 0 then
							if expinfo then
								local data = AgentData.Instance:GetCardByUuid(expinfo.uuid0)
								if data then
									MessageManager.HandleMessage(MsgType.GoHero, {expuuid = si.sinfo.uuid, index = 0, dataId = data.dataId})
								end
							end
						end
					elseif item.index == 1 then
						item.influenceIcon.gameObject:SetActive(si.sinfo.cam1 ~= 0)
						item.typeIcon.gameObject:SetActive(si.sinfo.att1 ~= 0)
						if si.sinfo.cam1 == 1 then
							item.influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/H.png", AssetType.Sprite)
						elseif si.sinfo.cam1 == 2 then
							item.influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/l.png", AssetType.Sprite)
						elseif si.sinfo.cam1 == 4 then
							item.influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/R.png", AssetType.Sprite)
						end
						if si.sinfo.att1 == 1 then
							item.typeIcon.sprite = Api.LoadImmediately("UI/Textures/Common/liliang.png", AssetType.Sprite)
						elseif si.sinfo.att1 == 2 then
							item.typeIcon.sprite = Api.LoadImmediately("UI/Textures/Common/mingjie.png", AssetType.Sprite)
						elseif si.sinfo.att1 == 3 then
							item.typeIcon.sprite = Api.LoadImmediately("UI/Textures/Common/zhili.png", AssetType.Sprite)
						end
						if si.sinfo.time ~= 0 then
							if expinfo then
								local data = AgentData.Instance:GetCardByUuid(expinfo.uuid1)
								if data then
									MessageManager.HandleMessage(MsgType.GoHero, {expuuid = si.sinfo.uuid, index = 1, dataId = data.dataId})
								end
							end
						end
					elseif item.index == 2 then
						item.influenceIcon.gameObject:SetActive(si.sinfo.cam2 ~= 0)
						item.typeIcon.gameObject:SetActive(si.sinfo.att2 ~= 0)
						if si.sinfo.cam2 == 1 then
							item.influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/H.png", AssetType.Sprite)
						elseif si.sinfo.cam2 == 2 then
							item.influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/l.png", AssetType.Sprite)
						elseif si.sinfo.cam2 == 4 then
							item.influenceIcon.sprite = Api.LoadImmediately("UI/Textures/Common/R.png", AssetType.Sprite)
						end
						if si.sinfo.att2 == 1 then
							item.typeIcon.sprite = Api.LoadImmediately("UI/Textures/Common/liliang.png", AssetType.Sprite)
						elseif si.sinfo.att2 == 2 then
							item.typeIcon.sprite = Api.LoadImmediately("UI/Textures/Common/mingjie.png", AssetType.Sprite)
						elseif si.sinfo.att2 == 3 then
							item.typeIcon.sprite = Api.LoadImmediately("UI/Textures/Common/zhili.png", AssetType.Sprite)
						end
						if si.sinfo.time ~= 0 then
							if expinfo then
								local data = AgentData.Instance:GetCardByUuid(expinfo.uuid2)
								if data then
									MessageManager.HandleMessage(MsgType.GoHero, {expuuid = si.sinfo.uuid, index = 2, dataId = data.dataId})
								end
							end
						end
					end
					if si.info.n32Color == 2 then
						item.bg.sprite = Api.LoadImmediately("UI/Textures/Explore/lvjia.png", AssetType.Sprite)
					elseif si.info.n32Color == 3 then
						item.bg.sprite = Api.LoadImmediately("UI/Textures/Explore/lanjia.png", AssetType.Sprite)
					elseif si.info.n32Color == 4 then
						item.bg.sprite = Api.LoadImmediately("UI/Textures/Explore/zijia.png", AssetType.Sprite)
					elseif si.info.n32Color == 5 then
						item.bg.sprite = Api.LoadImmediately("UI/Textures/Explore/chengjia.png", AssetType.Sprite)
					end
				end
				
				MessageManager.AddListener(MsgType.GoHero, function(data)
					if data.expuuid == si.sinfo.uuid and data.index == item.index then
						item.info = ConfigReader.GetHeroInfo(data.dataId)
						item.heroIcon.gameObject:SetActive(true)
						item.heroIcon.sprite = Api.LoadImmediately(item.info.szModelIcon, AssetType.Sprite)
						
						si.hero, si.skill, si.coin = g_exploreManager:getGains(si.sinfo.uuid, si:GetUuid())
						si:UpdateReward(si.coin, si.hero, si.skill)
						
						if item.info.n32Color == 1 then
							item.edge.sprite = Api.LoadImmediately("UI/Textures/Common/edge_white.png", AssetType.Sprite)
						elseif item.info.n32Color == 2 then
							item.edge.sprite = Api.LoadImmediately("UI/Textures/Common/edge_green.png", AssetType.Sprite)
						elseif item.info.n32Color == 3 then
							item.edge.sprite = Api.LoadImmediately("UI/Textures/Common/edge_blue.png", AssetType.Sprite)
						elseif item.info.n32Color == 4 then
							item.edge.sprite = Api.LoadImmediately("UI/Textures/Common/edge_purple.png", AssetType.Sprite)
						elseif item.info.n32Color == 5 then
							item.edge.sprite = Api.LoadImmediately("UI/Textures/Common/edge_orange.png", AssetType.Sprite)
						end
						item:RefreshCondition()
					end
				end)
				
				MessageManager.AddListener(MsgType.CancelSelectHero, function(id)
					if item.info == nil then return end
					if id == item.info.id then
						item.heroIcon.gameObject:SetActive(false)
						item.info = nil
						si:UpdateReward()
						item:RefreshCondition()
					end
				end)
				
				MessageManager.AddListener(MsgType.GetExploreReward, function(uuid)
					if uuid == si.sinfo.uuid then
						item.heroIcon.gameObject:SetActive(false)
						item.info = nil
						si:UpdateReward()
						item:RefreshCondition()
					end
				end)
				
				si.Slots[k] = item
			end
			
			function si:Update()
				si.info = ConfigReader.GetExplorepCfg(si.sinfo.dataId)
				si.mapIcon.sprite = Api.LoadImmediately(si.info.szBackground, AssetType.Sprite)
				si.title.text = si.info.szName .. "\n　　　" .. "<size=28>用时: " .. math.floor(si.info.n32Time / 3600) .. "小时" .. "</size>"
				si.des.text = si.info.szContent
				
				if si.info.n32Color == 2 then
					si.titleBg.sprite = Api.LoadImmediately("UI/Textures/Explore/lvtiao.png", AssetType.Sprite)
				elseif si.info.n32Color == 3 then
					si.titleBg.sprite = Api.LoadImmediately("UI/Textures/Explore/lantiao.png", AssetType.Sprite)
				elseif si.info.n32Color == 4 then
					si.titleBg.sprite = Api.LoadImmediately("UI/Textures/Explore/zitiao.png", AssetType.Sprite)
				elseif si.info.n32Color == 5 then
					si.titleBg.sprite = Api.LoadImmediately("UI/Textures/Explore/chengtiao.png", AssetType.Sprite)
				end
				
				for k, v in pairs(si.Slots) do
					v:Update()
				end
				
				si:UpdateReward()
				
				si.totalTime = si.sinfo.time
				if si.sinfo.time == 0 then
					si.freeImage.material = nil
					si.goImage.material = nil
					si.buttonLabel.text = "出发"
					si.goButton:SetActive(true)
					si.boxButton.gameObject:SetActive(false)
					si.rewardBg:SetActive(true)
				elseif si.sinfo.time < 0 or si.sinfo.time < os.time() then
					si.rewardBg:SetActive(false)
					si.goButton:SetActive(false)
					si.boxButton.gameObject:SetActive(true)
				elseif si.sinfo.time > os.time() then
					si.freeImage.material = Api.GreyMat
					si.goImage.material = Api.GreyMat
					si.rewardBg:SetActive(true)
					si.goButton:SetActive(true)
					si.boxButton.gameObject:SetActive(false)
					if si.timeDown == false then
						si.timeDown = true
						si:RefreshTime()
					end
				end
			end
			
			function si:UpdateReward()
				si.hero, si.skill, si.coin = g_exploreManager:getGains(si.sinfo.uuid, si:GetUuid())
				si.coinLabel.text = si.coin
				si.heroLabel.text = si.hero
				si.skillLabel.text = si.skill
				si.freeImage.gameObject:SetActive(si.sinfo.time == 0)
			end
			
			si:Update()
			
			MessageManager.AddListener(MsgType.OnCloseExpeditionPanel, function()
				Tween.DOKill(content, false)
				content.localPosition = Vector2(0, 960)
				if curSlot then
					curSlot:LoseFocus()
				end
				preSlot = nil
				curSlot = nil
			end)
			
			MessageManager.AddListener(MsgType.RefreshExplore, function(num)
				-- local remain = quest.RefreshExploreTimes - num
				-- if remain > 0 then
					-- si.diamond:SetActive(false)
					-- si.freeLabel.transform.localPosition = Vector3(20, 0, 0)
					-- si.freeLabel.fontSize = 45
					-- si.freeLabel.text = "免费(" .. remain .. ")"
					-- si.freeLabel.color = Color.white
				-- else
					si.diamond:SetActive(true)
					si.freeLabel.transform.localPosition = Vector3(54.5, 0, 0)
					si.freeLabel.fontSize = 50
					si.freeLabel.text = quest.RefreshExploreCost
					if Account.money >= quest.RefreshExploreCost then
						si.freeLabel.color = Color.white
					else
						si.freeLabel.color = Color.red
					end
				-- end
			end)
			
			Entry[info.uuid] = si
		else
			Entry[info.uuid].sinfo = info
			Entry[info.uuid]:Update()
		end
	end)
	
	for k, v in pairs(g_exploreManager.units) do
		MessageManager.HandleMessage(MsgType.UpdateExplore, v)
	end
	
end

------------------技能仓库------------------
local Skills = { }
local SkillList = { }
Skills.SkillList = SkillList
MainPanel.Skills = Skills
	
local redBg = Api.LoadImmediately("UI/Textures/Heros/Button_Red.png", AssetType.Sprite)
local blueBg = Api.LoadImmediately("UI/Textures/Heros/anniuB.png", AssetType.Sprite)
local greenBg = Api.LoadImmediately("UI/Textures/Heros/anniul.png", AssetType.Sprite)
local yellowBg = Api.LoadImmediately("UI/Textures/Heros/Button_Yellow.png", AssetType.Sprite)
	
function Skills:Init()
    local content = transform:Find("Panels/Skill/View/Content")
    local root1 = content:Find("Camp1/Content")
    local root2 = content:Find("Camp2/Content")
    local root3 = content:Find("Camp3/Content")
    
    local sr = transform:Find("Panels/Skill"):GetComponent(ScrollRect)
    
    local button1 = transform:Find("Panels/Skill/TopImage/Content/Button1"):GetComponent(Button)
    local button2 = transform:Find("Panels/Skill/TopImage/Content/Button2"):GetComponent(Button)
    local button3 = transform:Find("Panels/Skill/TopImage/Content/Button3"):GetComponent(Button)
    
    local prefab = Api.LoadImmediately("UI/Panels/MainPanel/Skill/SkillItem.prefab", AssetType.Prefab)
	
	local label1 = transform:Find("Panels/Skill/View/Content/Camp1/Title/Label"):GetComponent(Text)
	local label2 = transform:Find("Panels/Skill/View/Content/Camp2/Title/Label"):GetComponent(Text)
	local label3 = transform:Find("Panels/Skill/View/Content/Camp3/Title/Label"):GetComponent(Text)
	local preCamp = button1
	
	local curTab = 0
	
	local AllSkill = { }
	local C1 = { }
	local C2 = { }
	local C3 = { }
	
	label1.text = quest.IllustrationContent.HeroCamp[1]
	label2.text = quest.IllustrationContent.HeroCamp[2]
	label3.text = quest.IllustrationContent.HeroCamp[4]
	
	-- 添加技能
	function self:AddSkill(info)
        if info.n32SkillType == 1 and info.n32Faction > 0 and SkillList[info.n32SeriId] == nil then
            local si = { }
            si.info = info
            si.sInfo = nil
            si.id = si.info.n32SeriId
			si.index = 0
            local parent = nil
            if si.info.n32Faction == 1 then
                parent = root1
				si.index = 0
            elseif si.info.n32Faction == 2 then
                parent = root2
				si.index = 1
            elseif si.info.n32Faction == 4 then
                parent = root3
				si.index = 2
            end
            si.go = GameObject.Instantiate(prefab)
            si.go.name = si.info.szName
            si.go.transform:SetParent(parent)
            si.go.transform.localScale = Vector3.one
            si.go.transform.localEulerAngles = Vector3.zero
            Api.SetTag(si.go, "MainPanel_Panels")
            si.icon = si.go.transform:Find("IconMask/Icon"):GetComponent(Image)
            si.level = si.go.transform:Find("Progress/LevelBg/Text"):GetComponent(Text)
            si.name = si.go.transform:Find("IconMask/NameBg/SkillName"):GetComponent(Text)
            si.starContent = si.go.transform:Find("StarContent")
			si.slider = si.go.transform:Find("Progress"):GetComponent(Slider)
			si.deltaLabel = si.slider.transform:Find("DeltaLabel"):GetComponent(Text)
			si.fg = si.slider.transform:Find("Fg"):GetComponent(Image)
			si.fullLevel = si.slider.transform:Find("Fg/FullLevel")

            si.own = false

            Api.Load(si.info.szIcon, AssetType.Sprite, function(s)
                si.icon.sprite = s
            end )
			si.icon.material = Api.GreyMat

            -- 隐藏所有星星
            for i = 0, si.starContent.childCount - 1 do
                local temp = si.starContent:GetChild(i)
                temp:GetComponent(Image).material = Api.GreyMat
                temp.gameObject:SetActive(si.info.n32Quality >= i)
            end

            si.name.text = si.info.szName
            si.level.text = si.info.n32Upgrade

            -- 更新技能阶数显示
            function si:Upgrade()
                for i = 0, si.starContent.childCount - 1 do
                    local temp = si.starContent:GetChild(i)
                    temp:GetComponent(Image).material = nil
                    temp.gameObject:SetActive(si.info.n32Quality >= i)
                end
            end

			si.slider.value = 0
			si.deltaLabel.text = "0/" .. si.info.n32NeedStuff
				
            -- 更新UI显示
            function si:Update(sInfo, arg)
				if arg then
					si.go.transform:SetSiblingIndex(arg)
				end
                si.sInfo = sInfo
                si.info = ConfigReader.GetSkillDataInfo(sInfo.dataId)
                si.icon.material = nil
                si.name.text = si.info.szName
                si.level.text = si.info.n32Upgrade + 1
				si.slider.value = si.sInfo.count / si.info.n32NeedStuff
				if si.info.n32NeedStuff == 0 then
					si.deltaLabel.text = si.sInfo.count .. "/~"
				else
					si.deltaLabel.text = si.sInfo.count .. "/" .. si.info.n32NeedStuff
				end
                si:Upgrade()
                si.own = true
				si:CheckFullLevelAnimation()
            end
			
			function si:CheckFullLevelAnimation()
				if Panels[Middle.curIndex].go.name == "Skill" and si.slider.value >= 1 and si.info.n32Upgrade < 9 and si.index == curTab then
					PlayFullLevel(si.fullLevel)
					si.fg.sprite = Api.LoadImmediately("UI/Textures/Common/Lvjintu.png", AssetType.Sprite)
				else
					StopFullLevel(si.fullLevel)
					si.fg.sprite = Api.LoadImmediately("UI/Textures/Common/jingdutiao.png", AssetType.Sprite)
				end
			end

            -- 点击事件监听
            si.go:GetComponent(UIButton).onClick:AddListener( function()
                DialogManager.Instance:Open("SkillInfoDialog", si.info)
            end )

            -- 技能强化监听
            MessageManager.AddListener(MsgType.IntensifySkill, function(uuid)
                if si.sInfo then
                    if si.sInfo.uuid == uuid then
                        si.sInfo = AgentData.Instance:GetSkillDataBySerId(si.info.n32SeriId)
                        si:Update(si.sInfo)
                    end
                end
            end )

            SkillList[si.info.n32SeriId] = si
        end
	end
	
    -- 分类并排序卡牌
    for p in Slua.iter(ConfigReader.SkillDatasDic) do
		if p.value.n32Faction > 0 then
			table.insert(AllSkill, p.value)
		end
    end
	
	for k, v in pairs(AllSkill) do
		if v.n32Faction == 1 then
			table.insert(C1, v)
		elseif v.n32Faction == 2 then
			table.insert(C2, v)
		elseif v.n32Faction == 4 then
			table.insert(C3, v)
		end
	end
	
	table.sort(C1, function(l, r)
		return l.id < r.id
	end)
	
	table.sort(C2, function(l, r)
		return l.id < r.id
	end)
	
	table.sort(C3, function(l, r)
		return l.id < r.id
	end)
	
    -- 实例化技能item
	for k, v in pairs(C1) do
		self:AddSkill(v)
	end
	
	for k, v in pairs(C2) do
		self:AddSkill(v)
	end
	
	for k, v in pairs(C3) do
		self:AddSkill(v)
	end

    button1.onClick:AddListener( function()
		if preCamp == button1 then return end
        root1.parent.gameObject:SetActive(true)
        root2.parent.gameObject:SetActive(false)
        root3.parent.gameObject:SetActive(false)
		if preCamp then
			preCamp.transform:GetComponent(Image).sprite = redBg
			local icon = preCamp.transform:Find("Icon"):GetComponent(Image)
			local spName = String(icon.sprite.name)
			spName = spName:Replace('_', '')
			Api.Load("UI/Textures/Heros/" .. spName .. ".png", AssetType.Sprite, function(s)
				icon.sprite = s
			end)
		end
		button1.transform:GetComponent(Image).sprite = blueBg
		Api.Load("UI/Textures/Heros/Camp1_.png", AssetType.Sprite, function(s)
			button1.transform:Find("Icon"):GetComponent(Image).sprite = s
		end)
		preCamp = button1
		curTab = 0
		for _, v in pairs(SkillList) do
			v:CheckFullLevelAnimation()
		end
    end )
	
    button2.onClick:AddListener( function()
		if preCamp == button2 then return end
        root2.parent.gameObject:SetActive(true)
        root1.parent.gameObject:SetActive(false)
        root3.parent.gameObject:SetActive(false)
		if preCamp then
			preCamp.transform:GetComponent(Image).sprite = redBg
			local icon = preCamp.transform:Find("Icon"):GetComponent(Image)
			local spName = String(icon.sprite.name)
			spName = spName:Replace('_', '')
			Api.Load("UI/Textures/Heros/" .. spName .. ".png", AssetType.Sprite, function(s)
				icon.sprite = s
			end)
		end
		button2.transform:GetComponent(Image).sprite = greenBg
		Api.Load("UI/Textures/Heros/Camp2_.png", AssetType.Sprite, function(s)
			button2.transform:Find("Icon"):GetComponent(Image).sprite = s
		end)
		preCamp = button2
		curTab = 1
		for _, v in pairs(SkillList) do
			v:CheckFullLevelAnimation()
		end
    end )
	
    button3.onClick:AddListener( function()
		if preCamp == button3 then return end
        root3.parent.gameObject:SetActive(true)
        root1.parent.gameObject:SetActive(false)
        root2.parent.gameObject:SetActive(false)
		if preCamp then
			preCamp.transform:GetComponent(Image).sprite = redBg
			local icon = preCamp.transform:Find("Icon"):GetComponent(Image)
			local spName = String(icon.sprite.name)
			spName = spName:Replace('_', '')
			Api.Load("UI/Textures/Heros/" .. spName .. ".png", AssetType.Sprite, function(s)
				icon.sprite = s
			end)
		end
		button3.transform:GetComponent(Image).sprite = yellowBg
		Api.Load("UI/Textures/Heros/Camp4_.png", AssetType.Sprite, function(s)
			button3.transform:Find("Icon"):GetComponent(Image).sprite = s
		end)
		preCamp = button3
		curTab = 2
		for _, v in pairs(SkillList) do
			v:CheckFullLevelAnimation()
		end
    end )

    -- 技能数据更新监听
    MessageManager.AddListener(MsgType.UpdataSkillData, function(d)
		local T1 = { }
		local T2 = { }
		local T3 = { }
		
        for p in Slua.iter(d) do
			local info = ConfigReader.GetSkillDataInfo(p.value.dataId)
			if not info then Debug.LogError(p.value.dataId .. " is not found in skilltable!") end
			if info.n32Faction == 1 then
				table.insert(T1, p.value)
			elseif info.n32Faction == 2 then
				table.insert(T2, p.value)
			elseif info.n32Faction == 4 then
				table.insert(T3, p.value)
			end
        end
		
		table.sort(T1, function(l, r)
			return l.dataId < r.dataId
		end)
		
		table.sort(T2, function(l, r)
			return l.dataId < r.dataId
		end)
		
		table.sort(T3, function(l, r)
			return l.dataId < r.dataId
		end)
		
		for k, v in pairs(T1) do
            local sId = math.floor(v.dataId / 1000)
            if SkillList[sId] then
                SkillList[sId]:Update(v, k - 1)
            end
		end
		
		for k, v in pairs(T2) do
            local sId = math.floor(v.dataId / 1000)
            if SkillList[sId] then
                SkillList[sId]:Update(v, k - 1)
            end
		end
		
		for k, v in pairs(T3) do
            local sId = math.floor(v.dataId / 1000)
            if SkillList[sId] then
                SkillList[sId]:Update(v, k - 1)
            end
		end
    end )

    -- 首次进入主界面手动派发消息
    MessageManager.HandleMessage(MsgType.UpdataSkillData, AgentData.Instance.mSkill)

    self.isDown = false
    this.OnUpdateEvent = {
        "+=", function()
			if not this.isOpen then return end
            if Input.GetMouseButtonDown(0) then
                self.isDown = true
                sr.vertical = true
            end
            if Input.GetMouseButtonUp(0) then
                self.isDown = false
            end
            if self.isDown then
                if MouseDragDir == nil or MouseDragDir == "vertical" then
                    sr.vertical = true
                else
                    sr.vertical = false
                end
            end
        end
    }
	
end

------------------英雄仓库------------------
function Heros:Init()
    -- 已经显示的英雄表
    self.HeroList = { }

    self.preSelect = nil
	self.preComp = nil
	
	local AllHero = { }
	local C1 = { }
	local C2 = { }
	local C3 = { }

    local prefab = Api.LoadImmediately("UI/Panels/MainPanel/HeroItem.prefab", AssetType.Prefab)
	local redBg = Api.LoadImmediately("UI/Textures/Heros/Button_Red.png", AssetType.Sprite)
	local yellowBg = Api.LoadImmediately("UI/Textures/Heros/Button_Yellow.png", AssetType.Sprite)

    local camp1Root = transform:Find("Panels/Heros/View/Content/Camp1/Content")
    local camp2Root = transform:Find("Panels/Heros/View/Content/Camp2/Content")
    local camp3Root = transform:Find("Panels/Heros/View/Content/Camp3/Content")
	
	local label1 = transform:Find("Panels/Heros/View/Content/Camp1/Title/Label"):GetComponent(Text)
	local label2 = transform:Find("Panels/Heros/View/Content/Camp2/Title/Label"):GetComponent(Text)
	local label3 = transform:Find("Panels/Heros/View/Content/Camp3/Title/Label"):GetComponent(Text)

    local camp1Button = transform:Find("Panels/Heros/TopImage/Content/Button1"):GetComponent(Button)
    local camp2Button = transform:Find("Panels/Heros/TopImage/Content/Button2"):GetComponent(Button)
    local camp3Button = transform:Find("Panels/Heros/TopImage/Content/Button3"):GetComponent(Button)
	
	local curTab = 0

    local sr = transform:Find("Panels/Heros"):GetComponent(ScrollRect)
	
	self.preComp = camp1Button
	
	label1.text = quest.IllustrationContent.HeroCamp[1]
	label2.text = quest.IllustrationContent.HeroCamp[2]
	label3.text = quest.IllustrationContent.HeroCamp[4]

    camp1Button.onClick:AddListener( function()
		if self.preComp == camp1Button then return end
        camp1Root.parent.gameObject:SetActive(true)
        camp2Root.parent.gameObject:SetActive(false)
        camp3Root.parent.gameObject:SetActive(false)
		if self.preComp then
			self.preComp.transform:GetComponent(Image).sprite = redBg
			local icon = self.preComp.transform:Find("Icon"):GetComponent(Image)
			local spName = String(icon.sprite.name)
			spName = spName:Replace('_', '')
			Api.Load("UI/Textures/Heros/" .. spName .. ".png", AssetType.Sprite, function(s)
				icon.sprite = s
			end)
		end
		camp1Button.transform:GetComponent(Image).sprite = blueBg
		Api.Load("UI/Textures/Heros/Camp1_.png", AssetType.Sprite, function(s)
			camp1Button.transform:Find("Icon"):GetComponent(Image).sprite = s
		end)
		self.preComp = camp1Button
		curTab = 0
		for _, v in pairs(self.HeroList) do
			v:CheckFullLevelAnimation()
		end
    end )
	
    camp2Button.onClick:AddListener( function()
		if self.preComp == camp2Button then return end
        camp1Root.parent.gameObject:SetActive(false)
        camp2Root.parent.gameObject:SetActive(true)
        camp3Root.parent.gameObject:SetActive(false)
		if self.preComp then
			self.preComp.transform:GetComponent(Image).sprite = redBg
			local icon = self.preComp.transform:Find("Icon"):GetComponent(Image)
			local spName = String(icon.sprite.name)
			spName = spName:Replace('_', '')
			Api.Load("UI/Textures/Heros/" .. spName .. ".png", AssetType.Sprite, function(s)
				icon.sprite = s
			end)
		end
		camp2Button.transform:GetComponent(Image).sprite = greenBg
		Api.Load("UI/Textures/Heros/Camp2_.png", AssetType.Sprite, function(s)
			camp2Button.transform:Find("Icon"):GetComponent(Image).sprite = s
		end)
		self.preComp = camp2Button
		curTab = 1
		for _, v in pairs(self.HeroList) do
			v:CheckFullLevelAnimation()
		end
    end )
	
    camp3Button.onClick:AddListener( function()
		if self.preComp == camp3Button then return end
        camp1Root.parent.gameObject:SetActive(false)
        camp2Root.parent.gameObject:SetActive(false)
        camp3Root.parent.gameObject:SetActive(true)
		if self.preComp then
			self.preComp.transform:GetComponent(Image).sprite = redBg
			local icon = self.preComp.transform:Find("Icon"):GetComponent(Image)
			local spName = String(icon.sprite.name)
			spName = spName:Replace('_', '')
			Api.Load("UI/Textures/Heros/" .. spName .. ".png", AssetType.Sprite, function(s)
				icon.sprite = s
			end)
		end
		camp3Button.transform:GetComponent(Image).sprite = yellowBg
		Api.Load("UI/Textures/Heros/Camp4_.png", AssetType.Sprite, function(s)
			camp3Button.transform:Find("Icon"):GetComponent(Image).sprite = s
		end)
		self.preComp = camp3Button
		curTab = 2
		for _, v in pairs(self.HeroList) do
			v:CheckFullLevelAnimation()
		end
    end )

    function self:AddHero(info)
        local heroInfo = info
        local exis = false
        for k, v in pairs(self.HeroList) do
            if v.info.n32SeriId == heroInfo.n32SeriId then exis = true end
        end
        if not exis then
            local si = { }
            si.go = GameObject.Instantiate(prefab)
			si.index = 0
            if heroInfo.n32Camp == 1 then
                si.go.transform:SetParent(camp1Root)
				si.index = 0
            elseif heroInfo.n32Camp == 2 then
                si.go.transform:SetParent(camp2Root)
				si.index = 1
            elseif heroInfo.n32Camp == 4 then
                si.go.transform:SetParent(camp3Root)
				si.index = 2
            else
                Debug.LogError("read hero n32Camp error!!!") return
            end

            si.go.transform.localScale = Vector3.one
            si.go.transform.localEulerAngles = Vector3.zero
            Api.SetTag(si.go, "MainPanel_Panels")

            si.info = heroInfo
            si.id = heroInfo.n32SeriId
            si.trueId = heroInfo.id
            si.own = false
            si.go.name = heroInfo.szName
            si.qualitySprite = si.go.transform:Find("Content/Edge"):GetComponent(Image)
			si.levelLabel = si.go.transform:Find("Progress/LevelBg/LevelLabel"):GetComponent(Text)
			si.content = si.go.transform:Find("Content")
			si.select = si.content:Find("Select")
			si.nameLabel = si.go.transform:Find("Content/NameLabel"):GetComponent(Text)
            si.fullLevel = si.go.transform:Find("Progress/Fg/FullLevel")
            si.icon = si.go.transform:Find("Content/Mask/Icon"):GetComponent(Image)
			
			si.nameLabel.text = si.info.szName
            Api.Load(si.info.szModelIcon, AssetType.Sprite, function(sp)
                si.icon.sprite = sp
            end )
			si.icon.material = Api.GreyMat
			
			si.select:Find("SkillButton"):GetComponent(UIButton).onClick:AddListener(function()
				if si.sInfo then
					DialogManager.Instance:Open("HeroSkillInfoDialog", si.info, si.sInfo)
					Tween.DOKill(si.content, false)
					si.select.gameObject:SetActive(false)
					si.content.localScale = Vector3(1, 1, 1)
				else
					MessageBox.Instance:OpenText("没有获得的英雄!", Color.red, 0.5, MessageBoxPos.Middle)
				end
			end)
			
			si.select:Find("InfoButton"):GetComponent(UIButton).onClick:AddListener(function()
				DialogManager.Instance:Open("HeroInfoDialog", si.info)
				Tween.DOKill(si.content, false)
				si.select.gameObject:SetActive(false)
				si.content.localScale = Vector3(1, 1, 1)
			end)
			
			function si:ShowSelect()
				if Heros.preSelect then
					Tween.DOKill(Heros.preSelect.content, false)
					local res = Tween.DOScaleX(Heros.preSelect.content, 1, tweenTime)
					TweenSetting.SetEase(res, Ease.OutExpo)
					TimeManager.Instance:Do(tweenTime / 10, function()
						Heros.preSelect.select.gameObject:SetActive(false)
					end)
				end
				TimeManager.Instance:Do(tweenTime / 10, function()
					Heros.preSelect = si
				end)
				local res = Tween.DOScaleX(si.content, -1, tweenTime)
				TweenSetting.SetEase(res, Ease.OutExpo)
				TimeManager.Instance:Do(tweenTime / 10, function()
					if Heros.preSelect == si then
						si.select.gameObject:SetActive(true)
					end
				end)
			end
			
			function si:HideSelect()
				Tween.DOKill(si.content, false)
				local res = Tween.DOScaleX(si.content, 1, tweenTime)
				TweenSetting.SetEase(res, Ease.OutExpo)
				TimeManager.Instance:Do(tweenTime / 10, function()
					si.select.gameObject:SetActive(false)
				end)
			end
			
            si.go.transform:Find("Content/Edge"):GetComponent(Button).onClick:AddListener( function()
				si:ShowSelect()
            end )

            si.sInfo = nil
            si.curLevel = 1
			si.curLevel = si.info.n32Quality
			si.levelLabel.text = si.curLevel

            function si:UpdateInfo()
                local spName
                if si.info.n32Color == 1 then
                    spName = "edge_white.png"
                elseif si.info.n32Color == 2 then
                    spName = "edge_green.png"
                elseif si.info.n32Color == 3 then
                    spName = "edge_blue.png"
                elseif si.info.n32Color == 4 then
                    spName = "edge_purple.png"
                elseif si.info.n32Color == 5 then
                    spName = "edge_orange.png"
                end

                local spPath = "UI/Textures/Common/" .. spName
                Api.Load(spPath, AssetType.Sprite, function(sp)
                    si.qualitySprite.sprite = sp
                end )
                si.progressSlider.value = si.sInfo.count / si.info.n32WCardNum
				if si.info.n32WCardNum == 0 then
					si.progressLabel.text = si.sInfo.count .. "/~"
				else
					si.progressLabel.text = si.sInfo.count .. "/" .. si.info.n32WCardNum
				end
				si.levelLabel.text = si.curLevel
				si:CheckFullLevelAnimation()
            end
			
			function si:CheckFullLevelAnimation()
				if Panels[Middle.curIndex].go.name == "Heros" and curTab == si.index and si.progressSlider.value >= 1 and si.info.n32Quality < 25 then
					PlayFullLevel(si.fullLevel)
					si.fg.sprite = Api.LoadImmediately("UI/Textures/Common/Lvjintu.png", AssetType.Sprite)
				else
					StopFullLevel(si.fullLevel)
					si.fg.sprite = Api.LoadImmediately("UI/Textures/Common/jingdutiao.png", AssetType.Sprite)
				end
			end

            function si:MarkOwn(hi, arg)
                si.go.transform:SetSiblingIndex(arg)
                si.curNum = hi.count
                -- Debug.LogError(hi.dataId .. " " .. hi.count)
                si.sInfo = hi
                local heroInfo = ConfigReader.GetHeroInfo(hi.dataId)
                si.info = heroInfo
                si.curLevel = si.info.n32Quality
				if si.curLevel > 0 then
					si.icon.material = nil
					si.own = true
				end
                self:UpdateInfo()
            end

            si.progressSlider = si.go.transform:Find("Progress"):GetComponent(Slider)
			si.fg = si.go.transform:Find("Progress/Fg"):GetComponent(Image)
            si.progressLabel = si.go.transform:Find("Progress/DeltaLabel"):GetComponent(Text)
            si.progressSlider.value = 0
            si.progressLabel.text = "0/" .. si.info.n32WCardNum

            -- 升级卡牌(更新UI显示)
            function si:Upgrade(info)
                self.info = info
                si.curLevel = ConfigReader.GetHeroInfo(info.id).n32Quality
                self:UpdateInfo()
            end

            --si:UpdateInfo()

            self.HeroList[si.id] = si
        end
    end

    for p in Slua.iter(ConfigReader.HeroXmlInfoDict) do
        -- self:AddHero(p.value.id)
		table.insert(AllHero, p.value)
    end
	
	-- 分类并排序卡牌
	for k, v in pairs(AllHero) do
		if v.n32Camp == 1 then
			table.insert(C1, v)
		elseif v.n32Camp == 2 then
			table.insert(C2, v)
		elseif v.n32Camp == 4 then
			table.insert(C3, v)
		end
	end
	
	table.sort(C1, function(l, r)
		return l.id < r.id
	end)
	table.sort(C2, function(l, r)
		return l.id < r.id
	end)
	table.sort(C3, function(l, r)
		return l.id < r.id
	end)
	
	-- 实例化卡牌
	for k, v in pairs(C1) do
		self:AddHero(v)
	end
	
	for k, v in pairs(C2) do
		self:AddHero(v)
	end
	
	for k, v in pairs(C3) do
		self:AddHero(v)
	end

	transform:Find("Panels/Heros/View").gameObject:AddComponent(EventListener).OnPointerClickEvent = {
		"+=", function()
			if Heros.preSelect then
				Heros.preSelect:HideSelect()
				Heros.preSelect = nil
			end
		end
	}
	
    MessageManager.AddListener(MsgType.UpdateHeroData, function(dict)
		local T1 = { }
		local T2 = { }
		local T3 = { }
		
        for p in Slua.iter(dict) do
			local info = ConfigReader.GetHeroInfo(p.value.dataId)
			if info.n32Camp == 1 then
				table.insert(T1, p.value)
			elseif info.n32Camp == 2 then
				table.insert(T2, p.value)
			elseif info.n32Camp == 4 then
				table.insert(T3, p.value)
			end
        end
		
        table.sort(T1, function(l, r)
			return l.dataId < r.dataId
		end)
		
        table.sort(T2, function(l, r)
			return l.dataId < r.dataId
		end)
		
        table.sort(T3, function(l, r)
			return l.dataId < r.dataId
		end)
		
		for k, v in pairs(T1) do
            local id = Api.GetHeroSerialId(v.dataId)
            self.HeroList[id]:MarkOwn(v, k - 1)
		end
		
		for k, v in pairs(T2) do
            local id = Api.GetHeroSerialId(v.dataId)
            self.HeroList[id]:MarkOwn(v, k - 1)
		end
		
		for k, v in pairs(T3) do
            local id = Api.GetHeroSerialId(v.dataId)
            self.HeroList[id]:MarkOwn(v, k - 1)
		end
		
    end )

    MessageManager.AddListener(MsgType.UpgradeCard, function(heroId)
        local serialId = Api.GetHeroSerialId(heroId)
        if self.HeroList[serialId] == nil then
            Debug.LogError("英雄升级错误！没有找到英雄id" .. tostring(heroId))
        else
            local heroInfo = ConfigReader.GetHeroInfo(heroId)
            self.HeroList[serialId]:Upgrade(heroInfo)
        end
        Shop:RefreshShopCardRemainingBuyNum()
    end )

    self.isDown = false
    this.OnUpdateEvent = {
        "+=", function()
			if not this.isOpen then return end
            if Input.GetMouseButtonDown(0) then
                self.isDown = true
                sr.vertical = true
            end
            if Input.GetMouseButtonUp(0) then
                self.isDown = false
            end
            if self.isDown then
                if MouseDragDir == nil or MouseDragDir == "vertical" then
                    sr.vertical = true
                else
                    sr.vertical = false
                end
            end
        end
    }
	
end

----------------顶部个人信息----------------
local HeroInfo = { }
function HeroInfo:Init()
	local view = transform:Find("Panels/Store/Shop/ScrollRect/View")
	local content = transform:Find("Panels/Store/Shop/ScrollRect/View/Content")
	local coinContent = transform:Find("Panels/Store/Shop/ScrollRect/View/Content/Coin"):GetComponent(RectTransform)
	local diamondContent = transform:Find("Panels/Store/Shop/ScrollRect/View/Content/Diamond"):GetComponent(RectTransform)
	local cg = transform:Find("Top"):GetComponent(CanvasGroup)
    self.levelSlider = transform:Find("Top/Level/LevelSlider"):GetComponent(Image)
    self.levelDeltaLabel = transform:Find("Top/Level/LevelSlider/Text"):GetComponent(Text)
    self.levelLabel = transform:Find("Top/Level/LevelBg/Text"):GetComponent(Text)
    self.coinLabel = transform:Find("Top/Coin/CoinLabel"):GetComponent(Text)
    self.diamondLabel = transform:Find("Top/Diamond/DiamondLabel"):GetComponent(Text)

    MessageManager.AddListener(MsgType.SlideToCoin, function(str)
        if Middle.curIndex ~= 0 then
            Middle:Slide(0)
        end
		local offsetY = view.position.y - coinContent.position.y + coinContent.sizeDelta.y / 2 * Api.UIScaleFactor
		Tween.DOMoveY(content, content.position.y + offsetY, 0.5, false)
    end )

    MessageManager.AddListener(MsgType.SlideToDiamond, function(str)
        if Middle.curIndex ~= 0 then
            Middle:Slide(0)
        end
		local offsetY = view.position.y - diamondContent.position.y + diamondContent.sizeDelta.y / 2 * Api.UIScaleFactor
		Tween.DOMoveY(content, content.position.y + offsetY, 0.5, false)
    end )

    transform:Find("Top/Coin/AddButton"):GetComponent(Button).onClick:AddListener( function()
        MessageManager.HandleMessage(MsgType.SlideToCoin, nil)
        -- Debug.Log("on add coin button click")
    end )
    transform:Find("Top/Diamond/AddButton"):GetComponent(Button).onClick:AddListener( function()
        MessageManager.HandleMessage(MsgType.SlideToDiamond, nil)
    end )

    MessageManager.AddListener(MsgType.UpdateAccountData, function(xxx)
        self.levelSlider.fillAmount = Account.aexp / AccountLevelUtil.getExpByLevel(Account.Alevel + 1)
		local label1, label2 = Account.aexp, AccountLevelUtil.getExpByLevel(Account.Alevel + 1)
		if string.len(label1) >= 5 then
			label1 = tonumber(string.format("%.1f", label1 / 1000)) .. "k"
		end
		if string.len(label2) >= 5 then
			label2 = tonumber(string.format("%.1f", label2 / 1000)) .. "k"
		end
        self.levelDeltaLabel.text = label1 .. "/" .. label2
        self.levelLabel.text = Account.Alevel
        self.coinLabel.text = Account.gold
		if string.len(Account.gold) >= 6 then
			self.coinLabel.text = tonumber(string.format("%.1f", Account.gold / 1000)) .. "k"
		end
        self.diamondLabel.text = Account.money
		if string.len(Account.money) >= 6 then
			self.diamondLabel.text = tonumber(string.format("%.1f", Account.money / 1000)) .. "k"
		end
    end )
	
	MessageManager.AddListener(MsgType.MainPanelSlide, function(index)
		if (Panels[index].go.name == "Explore" or Panels[index].go.name == "Heros" or Panels[index].go.name == "Skill") and cg.alpha ~= 0 then
			Api.Fade(cg, 0.5, true)
		elseif (Panels[index].go.name ~= "Explore" and Panels[index].go.name ~= "Heros" and Panels[index].go.name ~= "Skill") and cg.alpha ~= 1 then
			Api.Fade(cg, 0.5, false)
		end
	end)
	
end

---------------自动调用的方法---------------
function MainPanel:Start()
    this = MainPanel.this
    transform = MainPanel.transform
    gameObject = MainPanel.gameObject
	
	local fightInit = false
	local herosInit = false
	local shopInit = false
	local exploreInit = false
	local skillInit = false

    HeroInfo:Init()
    Middle:InitMiddle()
    Bottom:InitBottomButtonListener()
	
	MessageManager.AddListener(MsgType.MainPanelSlide, function(index)
		if Panels[index].go.name == "Store" and Panels[Middle.preIndex].go.name ~= "Store" then
			if shopInit == false then
				Shop:Init()
				shopInit = true
			end
			g_CoolDown:RefreshShopCd()
			Shop:UpdateBox()
			Shop:CheckGift()
			Shop:UpdateDiamond()
			Shop:UpdateCoin()
        end
	end)
	
	MessageManager.AddListener(MsgType.MainPanelSlide, function(index)
		if Panels[index].go.name == "Explore" and Panels[Middle.preIndex].go.name ~= "Explore" then
			if exploreInit == false then
				Explore:Init()
				exploreInit = true
			end
			SystemLogic.Instance:UpdateActivityData(g_Activity:calcAccountUid(ActivitySysType.RefreshExplore))
        end
	end)
	
	MessageManager.AddListener(MsgType.MainPanelSlide, function(index)
		if Panels[index].go.name == "Fight" and Panels[Middle.preIndex].go.name ~= "Fight" then
			if fightInit == false then
				Fight:Init()
				MessageManager.HandleMessage(MsgType.UpdateAccountData, AgentData.Instance.mAccount)
				SystemLogic.Instance:UpdateActivityData(g_Activity:calcAccountUid(ActivitySysType.PvpTimes))
				SystemLogic.Instance:UpdateActivityData(g_Activity:calcAccountUid(ActivitySysType.PvpWinTimes))
				MessageManager.HandleMessage(MsgType.UpdateMission, AgentData.Instance.mMission)
				fightInit = true
			end
        end
	end)
	
	MessageManager.AddListener(MsgType.MainPanelSlide, function(index)
		if Panels[index].go.name == "Heros" and Panels[Middle.preIndex].go.name ~= "Heros" then
			if herosInit == false then
				Heros:Init()
				MessageManager.HandleMessage(MsgType.UpdateHeroData, AgentData.Instance.mHero)
				herosInit = true
			end
			for _, v in pairs(Heros.HeroList) do
				v:CheckFullLevelAnimation()
			end
        end
	end)
	
	MessageManager.AddListener(MsgType.MainPanelSlide, function(index)
		if Panels[index].go.name == "Skill" and Panels[Middle.preIndex].go.name ~= "Skill" then
			if skillInit == false then
				Skills:Init()
				skillInit = true
			end
			for _, v in pairs(SkillList) do
				v:CheckFullLevelAnimation()
			end
        end
	end)
	
    -- 抽卡监听
    MessageManager.AddListener(MsgType.OpenBox, function(t)
        UIManager.Instance:OpenPanel("OpenBoxPanel", false, t)
    end )
	
	-- 匹配成功监听
	MessageManager.AddListener(MsgType.MatchSuccess, function(data)
        Debug.Log("<color=red>匹配成功！打牌选英雄界面</color>")
		UIManager.Instance:OpenPanel("PickHeroPanel", true, data)
	end )
	
	for k, v in pairs(Panels) do
		if v.go.name == "Fight" then
			MessageManager.HandleMessage(MsgType.MainPanelSlide, k)
		end
	end
	
	if PlayerInfo.MusicFlag then
		SoundManager.Instance:Play("MainPanel_Bg", true)
	else
		SoundManager.Instance:Stop()
	end
	
end

function MainPanel:Update()
	if Input.GetMouseButtonDown(0) then
		fPos = Input.mousePosition
	end
	if Input.GetMouseButtonUp(0) and fPos then
		sPos = Input.mousePosition
		local dir = sPos - fPos
		if dir.magnitude > 20 then
			isDrag = true
		else
			isDrag = false
		end
	end
    if Input.GetKeyDown(KeyCode.LeftArrow) then
        Middle:Slide(Middle.curIndex - 1)
    end
    if Input.GetKeyDown(KeyCode.RightArrow) then
        Middle:Slide(Middle.curIndex + 1)
    end
end

function MainPanel:FixedUpdate()

end

function MainPanel:LateUpdate()

end

function MainPanel:OnDestroy()

end

function MainPanel:OnOpen(args)
    Bottom:ResetCursorPos()
	Bottom:OnOpen()
end

function MainPanel:OnClose()
	Bottom:OnClose()
end

return MainPanel
