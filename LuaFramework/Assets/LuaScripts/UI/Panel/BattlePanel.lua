local BattlePanel = { }

local this
local transform
local gameObject

local SkillBook = { }
local SkillBookWareHouse = { }
SkillBookWareHouse.Books = { }

-- 是否在基地范围内
local isEnter = true
local preIsEnter = false

function BattlePanel:OnPlayerEnterLeave(enter)
    isEnter = enter[1]
end

-----------------------Top------------------------
local Top = {}
BattlePanel.Top = Top

function Top:Init()
	local content = transform:Find("Top")
	local timeLabel = content:Find("RightBg/TimeLabel"):GetComponent(Text)
	local dNum, wNum, timer = 0, 0, 60
	this.OnUpdateEvent = {
		"+=", function()
			if timer > 0 then timer = timer - Time.deltaTime end
			if timer < 0 then timer = 0 end
			if timer == 0 then
				timeLabel.text = "<color=red>00:00</color>"
				return
			end
			local h, m, s = ConvertTime(timer)
			local hl, ml, sl = tostring(h), tostring(m), tostring(s)
			if string.len(hl) <= 1 then
				hl = "0" .. hl
			end
			if string.len(ml) <= 1 then
				ml = "0" .. ml
			end
			if string.len(sl) <= 1 then
				sl = "0" .. sl
			end
			if timer > 10 then
				timeLabel.text = ml.. ":" .. sl
			else
				timeLabel.text = "<color=red>" .. ml .. ":" .. sl .. "</color>"
			end
		end
	}
	MessageManager.AddListener(MsgType.ResetBattleTime, function(restTime)
		timer = restTime / 1000
	end)
end

---------------左侧所有英雄头像相关---------------
-- 剩余时间Label
local leftTimeLabel
-- 对方人头Label
local oppositeRenTouLabel
-- 己方人头Label
local ownRenTouLabel

---------------左侧所有英雄头像相关---------------
local Heros = { }

-- 初始化Heros
function Heros:Init()
    self.HeroList = { }
    self.isOpen = true
    local prefab = Api.LoadImmediately("UI/Panels/BattlePanel/HeroItem.prefab", AssetType.Prefab)
    local leftRt = transform:Find("Left"):GetComponent(RectTransform)
    local parent = transform:Find("Left/Content"):GetComponent(RectTransform)
    local jianTou = transform:Find("Left/JianTouButton")
    -- 创建英雄监听
    for player in Slua.iter(EntityManager.AllEntitys) do
        if player.value.entityType == EntityType.Player then
            if PlayerManager.Instance.LocalPlayer:isRed() ~= player.value:isRed() then
                local HeroItem = { }
                local si = HeroItem
                si.go = GameObject.Instantiate(Api.AsObject(prefab))
                si.go.transform:SetParent(parent)
                si.go.transform.localScale = Vector3.one
                si.player = player.value
                si.focusGo = si.go.transform:Find("Focus").gameObject
				si.icon = si.go.transform:Find("IconBg/Icon"):GetComponent(Image)
                local spName = player.value.EntityData.szModelIcon
                si.icon.sprite = Api.LoadImmediately(spName, AssetType.Sprite)
                function si:GetFocus()
                    self.focusGo:SetActive(true)
                end
                function si:LoseFocus()
                    self.focusGo:SetActive(false)
                end
                table.insert(self.HeroList, si)
                -- 头像点击监听
                si.go:GetComponent(Button).onClick:AddListener( function()
                    PlayerManager.Instance.LocalPlayer:SetSyncLockTarget(si.player);
                end )
            end
        end
    end

    -- 锁定英雄监听
    MessageManager.AddListener(MsgType.LockHero, function(entity)
        if entity ~= nil then
            for k, v in pairs(self.HeroList) do
                if v.player.ServerId == entity.ServerId then
                    v:GetFocus()
                else
                    v:LoseFocus()
                end
            end
        else
            for k, v in pairs(self.HeroList) do
                v:LoseFocus()
            end
        end
    end )

    -- 收缩英雄头像
    local startPos = leftRt.localPosition
    local endPos = startPos + Vector3.left * parent.sizeDelta.x
    jianTou:GetComponent(Button).onClick:AddListener( function()
        if self.isOpen then
            res = Tween.DOLocalMove(leftRt, endPos, 0.3, false)
            TweenSetting.OnComplete(res, function()
                parent.gameObject:SetActive(false)
            end )
            jianTou.localScale = Vector3(1, 1, 1)
        else
            parent.gameObject:SetActive(true)
            Tween.DOLocalMove(leftRt, startPos, 0.3, false)
            jianTou.localScale = Vector3(-1, 1, 1)
        end
        self.isOpen = not self.isOpen
    end )

    jianTou.gameObject:SetActive(#self.HeroList > 0)
end

---------------技能相关---------------
-- 右侧所有技能图标
local Skills = { }
Skills.SkillList = { }
BattlePanel.Skills = Skills

-- 初始化Skills
function Skills:Init()
    local root = transform:Find("Right/Content")

    local prefab = Api.LoadImmediately("UI/Panels/BattlePanel/SkillItem.prefab", AssetType.Prefab)
    local prefab2 = Api.LoadImmediately("UI/Panels/BattlePanel/Skill_Normal.prefab", AssetType.Prefab)

    local space = 176
    local firstPos = Vector3(0, -330, 0)
    local index = 0
	local pointerDown = false
	local tipId = 0
	self.exchangeImageTweenTime = 0.3

    function self:UpdateIndex()
        index = 0
        for k, v in pairs(self.SkillList) do
            if v then index = index + 1 end
        end
    end

    -- 通过id获取技能图标位置
    function self:GetSkillInfoById(id)
        local si = nil
        for k, v in pairs(self.SkillList) do
            if tostring(id) == k then si = v end
        end
        if si ~= nil then
            return si.go.transform.position
        else
            self:UpdateIndex()
            local pos = firstPos + Vector3.up *(index) * space
            return root:TransformPoint(pos)
        end
    end

    -- 设置技能等级
    function self:SetLevel(id, level)
        if level > quest.SkillMaxLevel or self.SkillList[tostring(id)] == nil then return end
        local item = self.SkillList[tostring(id)]
        local root = item.go.transform:Find("LevelBg")
        for i = 0, root.childCount - 1 do
            local temp = root:GetChild(i)
            temp.gameObject:SetActive(i < level)
        end
        self.SkillList[tostring(id)].level = level
    end

    -- 替换技能
    function self:ExchangeSkill(oldId, newId)
        if self.SkillList[tostring(oldId)] == nil then
            Debug.LogError("替换技能失败！id不存在！oldId: " .. oldId .. " newId: " .. newId)
            return
        end
        local si = self.SkillList[tostring(oldId)]
        si.go.name = newId
        si.id = newId
        si.skillInfo = ConfigReader.GetSkillDataInfo(si.id)
        local spName = si.skillInfo.szIcon
        Api.Load(spName, AssetType.Sprite, function(sp)
            if sp ~= nil then
                si.icon.sprite = sp
            else
                Debug.LogError("id 为" .. si.id .. "的技能没有找到对应的图片")
            end
        end )

        local frameImageName = ""
        if si.skillInfo.n32Active == 1 then
            frameImageName = "SkillFrame2.png"
        elseif si.skillInfo.n32Active == 0 then
            frameImageName = "skillFrame1.png"
        end
        Api.Load("UI/Textures/Battle/" .. frameImageName, AssetType.Sprite, function(sp)
            si.frameImage.sprite = sp
        end )
        si.level = 1
        si.SetUpgradeButtonShow()
        self:SetLevel(si.id, si.level)
        self.SkillList[tostring(newId)] = si
        self.SkillList[tostring(oldId)] = nil
        -- 技能学习特效
        preName = "Jinengxuexi.prefab"
        Api.ShowScreenEffect("effect/ui/" .. preName, si.go.transform.position, true, 1);
    end
	
	function self:ShowExchangeGlow(skillId, scale)
		if self.SkillList[tostring(skillId)] ~= nil then
			self.SkillList[tostring(skillId)]:ShowExchangeGlow(scale)
		end
	end
	
	function self:HideExchangeGlow(skillId)
		if self.SkillList[tostring(skillId)] ~= nil then
			self.SkillList[tostring(skillId)]:HideExchangeGlow()
		end
	end

    -- 添加技能监听
    MessageManager.AddListener(MsgType.AddSkill, function(dict)
        index = 0
        for p in Slua.iter(dict) do
            if self.SkillList[tostring(p.key)] == nil then
                self:UpdateIndex()
                local temp
                local isGodSkill
                if p.key == PlayerManager.Instance.LocalPlayer.GodSkill.id then
                    temp = prefab2
                    isGodSkill = true
                else
                    temp = prefab
                    isGodSkill = false
                end
                local go = GameObject.Instantiate(Api.AsObject(temp))
                go.name = tostring(p.key)
                go.transform:SetParent(root)
                go.transform.localScale = Vector3.zero
                go.transform.eulerAngles = Vector3.zero

                local SkillItem = { }
                local si = SkillItem

                self.SkillList[tostring(p.key)] = si
                go.transform.localPosition = firstPos + Vector3.up * index * space

                si.index = index
                si.go = go
                si.sizeDelta = si.go:GetComponent(RectTransform).sizeDelta
                si.id = p.key
                si.level = p.value
                si.icon = go.transform:Find("IconMask/Icon"):GetComponent(Image)
                si.skillInfo = ConfigReader.GetSkillDataInfo(si.id)

                TimeManager.Instance:Do(1, function()
                    go.transform.localScale = Vector3.one * 0.8
                    if si.skillInfo.n32SkillType ~= 2 then
                        -- 技能学习特效
                        preName = "Jinengxuexi.prefab"
                        Api.ShowScreenEffect("effect/ui/" .. preName, go.transform.position, true, 1);
                    end
                end )

                local spName = si.skillInfo.szIcon
                Api.Load(spName, AssetType.Sprite, function(sp)
                    if sp ~= nil then
                        si.icon.sprite = sp
                    else
                        Debug.LogError("id 为" .. si.id .. "的技能没有找到对应的图片")
                    end
                end )

                si.frameImage = si.go.transform:Find("LevelBg"):GetComponent(Image)
                local frameImageName = ""
                if isGodSkill then
                    frameImageName = "skillFrame1.png"
                else
                    if si.skillInfo.n32Active == 1 then
                        frameImageName = "SkillFrame2.png"
                    elseif si.skillInfo.n32Active == 0 then
                        frameImageName = "skillFrame1.png"
                    end
                end
                Api.Load("UI/Textures/Battle/" .. frameImageName, AssetType.Sprite, function(sp)
                    si.frameImage.sprite = sp
                end )

                si.mask = go.transform:Find("Mask"):GetComponent(Image)
                -- si.mask.gameObject:SetActive(si.level <= 0)
                si.SetActive = function(active)
                    si.isActive = active
                    if active then
                        si.icon.material = nil
                    else
                        Api.Load("Shaders/Discoloration/Discoloration.mat", AssetType.Material, function(m)
                            si.icon.material = m
                        end )
                    end
                end

                si.SetActive(si.level > 0)

                si.coldTimeLabel = go.transform:Find("LeftTime"):GetComponent(Text)
                si.coldTime = 0
                si.curTime = 0
                si.isColding = false
                si.Callback = { }
                si.upgradeByClickButton = false
                si.addLevelButton = si.go.transform:Find("AddLevelButton")
                si.addLevelButton:GetComponent(Button).onClick:AddListener( function()
					if SelfPlayerDead then return end
					if si.canUpgrade then
						si.upgradeByClickButton = true
						FightLogic.upgradeSkill(si.id)
					else
						MessageBox.Instance:OpenText("金币不足!", Color.red, 0.5, MessageBoxPos.Middle)
					end
                end )
				si.upgradeCoinLabel = si.addLevelButton.transform:Find("CoinLabel"):GetComponent(Text)

                si.SetUpgradeButtonShow = function()
                    if not isEnter then si.addLevelButton.gameObject:SetActive(false) return end
                    if si.level <= 0 or si.level >= quest.SkillMaxLevel then
                        si.addLevelButton.gameObject:SetActive(false)
						return
                    end
                    si.addLevelButton.gameObject:SetActive(true)
                    local curGold = PlayerManager.Instance.LocalPlayer.Gold
                    local needGold = quest.GoldSkillLv[si.level]
					si.canUpgrade = curGold >= needGold
					si.upgradeCoinLabel.text = needGold .. ""
					if si.canUpgrade then si.upgradeCoinLabel.color = Color.white
					else si.upgradeCoinLabel.color = Color.red end
                end

                si.SetUpgradeButtonShow()

                si.ro = si.addLevelButton:Find("Image")
				si.ro.gameObject:SetActive(false)
                si.Rotate = function()
                    if si.ro.gameObject.activeInHierarchy then
                        si.ro:Rotate(- Vector3.forward * 360 * Time.deltaTime)
                    end
                end

                --this.OnUpdateEvent = { "+=", si.Rotate }
                --this.OnDestroyEvent = { "-=", si.Rotate }

                self:SetLevel(si.id, si.level)

                go:GetComponent(Button).onClick:AddListener( function()
                    if SelfPlayerDead or si.tipFlag or si.skillInfo.n32Active == 1 or si.isColding or not si.isActive then return end
					Api.RequestCastSkill(si.id)
                    si:ResetCd(0)
                    si.isColding = true
                    si.mask.gameObject:SetActive(true)
                    si.mask.fillAmount = 1
                    si.coldTimeLabel.gameObject:SetActive(true)
                    si.coldTimeLabel.text = math.floor(si.coldTime)
                    si.curTime = si.coldTime
                    for k, v in pairs(si.Callback) do
                        if type(v) == "function" then
                            v()
                        else
                            v:Invoke()
                        end
                    end
                end )

                function si:AddListener(callback)
                    for k, v in pairs(self.Callback) do
                        if callback == v then
                            Debug.LogError(type(callback) .. "Has been included!!!")
                            return
                        end
                    end
                    table.insert(self.Callback, callback)
                end

                function si:RemoveListener(callback)
                    local exis = false
                    local index
                    for k, v in pairs(self.Callback) do
                        if callback == v then
                            exis = true
                            index = k
                        end
                    end
                    if exis == false then Debug.LogError(type(callback) .. "is not included!!!") end
                    table.remove(self.Callback, index)
                end

                function si.ColdAnimation()
                    if si.isColding == false then return end
                    si.curTime = si.curTime - Time.deltaTime
                    if si.curTime <= 0 then
                        si.curTime = 0
                        si.coldTimeLabel.text = 0
                        si.coldTimeLabel.gameObject:SetActive(false)
                        si.mask.fillAmount = 0
                        si.mask.gameObject:SetActive(false)
                        si.isColding = false
                    end
                    local curTime = math.floor(si.curTime)
                    si.coldTimeLabel.text = curTime
                    si.mask.fillAmount = si.curTime / si.coldTime
                end
				
				function si:ResetCd(timer)
					si.coldTime = timer
					si.curTime = timer
					si.mask.gameObject:SetActive(true)
                    si.coldTimeLabel.gameObject:SetActive(true)
                    si.coldTimeLabel.text = math.floor(si.coldTime)
					si.isColding = true
				end

                this.OnUpdateEvent = { "+=", si.ColdAnimation }
                this.OnDestroyEvent = { "-=", si.ColdAnimation }

                si.tipTimer = 0
                si.timing = false
                si.tipFlag = false
                si.listener = si.go:AddComponent(EventListener)
				si.exchangeImage = si.go.transform:Find("ExchangeImage").gameObject:AddComponent(CanvasGroup)
				si.exchangeImage.alpha = 0
				si.startPos = si.go.transform.localPosition
				si.status = 0		-- 0正常	1放大
				function si:ShowExchangeGlow(scale)
					Tween.DOKill(si.go.transform, false)
					Api.Fade(si.exchangeImage, Skills.exchangeImageTweenTime, false)
					if scale then
						Tween.DOScale(si.go.transform, 1, Skills.exchangeImageTweenTime)
						Tween.DOLocalMove(si.go.transform, si.startPos + Vector3.left * 25, Skills.exchangeImageTweenTime, false)
					end
					si.go.transform:SetAsLastSibling()
					for _, v in pairs(Skills.SkillList) do
						if v.status == 1 then
							v:HideExchangeGlow()
						end
					end
					si.status = 1
				end
				
				function si:HideExchangeGlow()
					Api.Fade(si.exchangeImage, Skills.exchangeImageTweenTime, true)
					Tween.DOScale(si.go.transform, 0.8, Skills.exchangeImageTweenTime)
					Tween.DOLocalMove(si.go.transform, si.startPos, Skills.exchangeImageTweenTime, false)
					si.status = 0
				end
				
                si.listener.OnPointerDownEvent = {
                    "+=", function(arg1, arg2)
                        si.tipTimer = 0
                        si.timing = true
                        si.tipFlag = false
                    end
                }
				
                si.listener.OnPointerUpEvent = {
                    "+=", function(arg1, arg2)
                        si.tipTimer = 0
                        si.timing = false
                    end
                }
				
				si.listener.OnPointerEnterEvent = {
					"+=", function(arg1, arg2)
						if SkillBook.dragging and si.go.tag == "SkillItem" then
							si:ShowExchangeGlow(true)
						end
					end
				}
				
				si.listener.OnPointerExitEvent = {
					"+=", function(arg1, arg2)
						if SkillBook.dragging and si.go.tag == "SkillItem" then
							si:HideExchangeGlow()
						end
						si.tipTimer = 0
						si.timing = false
					end
				}

                this.OnUpdateEvent = {
                    "+=", function()
                        if si.timing then
                            si.tipTimer = si.tipTimer + Time.deltaTime
                            if si.tipTimer >= 0.5 then
                                si.tipTimer = 0
                                si.timing = false
                                si.tipFlag = true
								pointerDown = true
								tipId = si.id
								local info = ConfigReader.GetSkillDataInfo(si.skillInfo.id - 1 + si.level)
								if info then
									UIManager.Instance:ShowSkillTip(info.szDescribe, si.go.transform.position, SkillTipPosType.Left)
								else
									UIManager.Instance:ShowSkillTip(si.skillInfo.szDescribe, si.go.transform.position, SkillTipPosType.Left)
								end
                            end
                        end
                        if si.tipFlag then
                            if Input.GetMouseButtonUp(0) then
                                UIManager.Instance:HideSkillTip()
                                si.tipFlag = false
								pointerDown = false
								tipId = 0
                            end
                        end
						if tipId == si.id then
                            local dis = Vector2.Distance(si.go.transform.position, Input.mousePosition) / Api.UIScaleFactor
                            if Api.isMouseButtonDown == false or dis > si.sizeDelta.x / 2 then
                                UIManager.Instance:HideSkillTip()
                                si.tipFlag = false
								pointerDown = false
								tipId = 0
                            end
						end
                    end
                }
            end
        end
    end )

    -- 升级技能监听
    MessageManager.AddListener(MsgType.UpgradeSkill, function(arg)
        local id = arg[1]
        local level = arg[2]
        if self.SkillList[tostring(id)].upgradeByClickButton then
            Api.ShowScreenEffect("effect/ui/Jinengshenji.prefab", self.SkillList[tostring(id)].go.transform.position, true, 1);
            self:SetLevel(id, level)
            self.SkillList[tostring(id)]:SetUpgradeButtonShow()
            -- 技能升级特效
            preName = "Jinengshenji.prefab"
            Api.ShowScreenEffect("effect/ui/" .. preName, self.SkillList[tostring(id)].go.transform.position, true, 1);
            self.SkillList[tostring(id)].SetActive(self.SkillList[tostring(id)].level > 0)
        else
            TimeManager.Instance:Do(0.8, function()
                self:SetLevel(id, level)
                self.SkillList[tostring(id)]:SetUpgradeButtonShow()
                -- 技能升级特效
                preName = "Jinengshenji.prefab"
                Api.ShowScreenEffect("effect/ui/" .. preName, self.SkillList[tostring(id)].go.transform.position, true, 1);
                self.SkillList[tostring(id)].SetActive(self.SkillList[tostring(id)].level > 0)
            end )
        end
        self.SkillList[tostring(id)].upgradeByClickButton = false
    end )

    -- 重置技能cd监听
    MessageManager.AddListener(MsgType.ResetSkillCd, function(dict)
        for p in Slua.iter(dict) do
            local si = self.SkillList[tostring(p.key)]
            if si ~= nil then
				si:ResetCd(math.ceil(p.value / 1000))
				-- Debug.Log("<color=green>重置CD-> skillId:" .. tostring(p.key) .. " CD:" .. tostring(math.ceil(p.value / 1000)) .. "</color>")				
            end
        end
    end )

    -- 属性更新监听
    MessageManager.AddListener(MsgType.UpdateStat, function()
        for k, v in pairs(self.SkillList) do
            v:SetUpgradeButtonShow()
        end
    end )
	
	-- 设置技能监听
	MessageManager.AddListener(MsgType.RaycastSkill, function(skillId)
		self:ShowExchangeGlow(skillId, false)
	end)
	
	-- 释放技能监听
	MessageManager.AddListener(MsgType.RaycastingSkill, function(skillId)
		self:HideExchangeGlow(skillId)
	end)
	
    this.OnUpdateEvent = {
        "+=", function()
            if isEnter ~= preIsEnter then
                preIsEnter = isEnter
                for k, v in pairs(self.SkillList) do
                    v:SetUpgradeButtonShow()
                end
            end
			if pointerDown then
				local obj = Api.GetRayCastObject()
				if obj == nil or obj.transform.parent.parent.name ~= "Right" then
					UIManager.Instance:HideSkillTip()
				end
			end
        end
    }
end

---------------底部个人信息---------------
local SelfInfo = { }
SelfInfo.isOpen = true

function SelfInfo:Init()
    local bottom = transform:Find("Bottom")
    local content = transform:Find("Bottom/Content")
    local levelSlider = content:Find("Level/Fg"):GetComponent(Image)
    local levelProgressLabel = levelSlider.transform:Find("ProgressLabel"):GetComponent(Text)
    local levelLabel = content:Find("Level/Bg/Label"):GetComponent(Text)
    local hpSlider = content:Find("Hp/Fg"):GetComponent(Image)
    local hpLabel = content:Find("Hp/HpLabel"):GetComponent(Text)
    local mpSlider = content:Find("Mp/Fg"):GetComponent(Image)
    local mpLabel = content:Find("Mp/MpLabel"):GetComponent(Text)
    local attackPowerLabel = content:Find("Layout/AttackPower/Text"):GetComponent(Text)
    local powerLabel = content:Find("Layout/Power/Text"):GetComponent(Text)
    local defenseLabel = content:Find("Layout/Defense/Text"):GetComponent(Text)
    local mentalityLabel = content:Find("Layout/Mentality/Text"):GetComponent(Text)
    local attackSpeedLabel = content:Find("Layout/AttackSpeed/Text"):GetComponent(Text)
    local agilityLabel = content:Find("Layout/Agility/Text"):GetComponent(Text)
    local skillPointLabel = content:Find("SkillPoint/Text"):GetComponent(Text)
    local skillTray = transform:Find("SkillTray"):GetComponent(RectTransform)

    skillTray.gameObject:SetActive(false)

    local headIcon = content:Find("Head"):GetComponent(Image)
    Api.Load(PlayerManager.Instance.LocalPlayer.EntityData.szModelIcon, AssetType.Sprite, function(s)
        headIcon.sprite = s
    end )

    local mainFlag = content:Find("MainFlag"):GetComponent(Image)
    local spName = ""
    local mainAtt = PlayerManager.Instance.LocalPlayer.EntityData.n32MainAtt
    if mainAtt == 1 then
        spName = "powerIcon.png"
    elseif mainAtt == 2 then
        spName = "agilityIcon.png"
    elseif mainAtt == 3 then
        spName = "mentalityIcon.png"
    end
    Api.Load("UI/Textures/Battle/" .. spName, AssetType.Sprite, function(s)
        mainFlag.sprite = s
    end )

    local startPos = bottom.localPosition
    local endPos = bottom.localPosition + Vector3.right * content:GetComponent(RectTransform).sizeDelta.x
    self.isOpen = true
    local jGo = transform:Find("Bottom/JianTouButton")
    local skillBookBar = transform:Find("SkillBookBar")
    local _startPos = skillBookBar.localPosition
    local _endPos = Vector3(0, -879, 0)
    local startPos_tray = Vector3(0, -1059.5 - skillTray.sizeDelta.y / 2, 0)
    local endPos_tray = Vector3(0, -985, 0)
	
	function self:OnJianTouButtonClick()
        if self.isOpen then
            Tween.DOLocalMove(skillBookBar, _endPos, 0.3, false)
            local res = Tween.DOLocalMove(bottom, endPos, 0.3, false)
            TweenSetting.OnComplete(res, function()
                content.gameObject:SetActive(false)
                self.isOpen = not self.isOpen
            end )
            skillTray.gameObject:SetActive(true)
            Tween.DOLocalMove(skillTray, endPos_tray, 0.3, false)
            SkillBook.isUp = false
            jGo.localScale = Vector3(-1, 1, 1)
            if #SkillBook.Items > 3 then
                SkillBook.content.sizeDelta = Vector2(#SkillBook.Items * 140 - 140, 162)
            end
        else
            content.gameObject:SetActive(true)
            Tween.DOLocalMove(skillBookBar, _startPos, 0.3, false)
            Tween.DOLocalMove(bottom, startPos, 0.3, false)
            jGo.localScale = Vector3(1, 1, 1)
            self.isOpen = not self.isOpen
            SkillBook.isUp = true
            SkillBook.content.sizeDelta = Vector2(420, 162)
            local res = Tween.DOLocalMove(skillTray, startPos_tray, 0.3, false)
            TweenSetting.OnComplete(res, function()
                skillTray.gameObject:SetActive(false)
            end )
        end
        SkillBook:Sort(true)
	end
	
    transform:Find("Bottom/JianTouButton"):GetComponent(Button).onClick:AddListener( function()
		self:OnJianTouButtonClick()
    end )
	
	self.isOpen = false
	skillBookBar.localPosition = _endPos
	bottom.localPosition = endPos
	content.gameObject:SetActive(false)
    skillTray.gameObject:SetActive(true)
    skillTray.localPosition = endPos_tray
    SkillBook.isUp = false
    jGo.localScale = Vector3(-1, 1, 1)

    function self.UpdateInfo(entity)
        local needExp = Api.GetExpByLevel(entity.Level + 1)
        if needExp == 0 then
            levelSlider.fillAmount = 1
        else
            levelSlider.fillAmount = PlayerManager.Instance.LocalPlayer.Exp / needExp
        end

        if needExp > 0 then
            levelProgressLabel.text = PlayerManager.Instance.LocalPlayer.Exp .. "/" .. needExp
        else
            levelProgressLabel.gameObject:SetActive(false)
        end
        levelLabel.text = entity.Level
        hpSlider.fillAmount = entity.Hp / entity.HpMax
        hpLabel.text = entity.Hp .. "/" .. entity.HpMax
        mpSlider.fillAmount = entity.Mp / entity.MpMax
        mpLabel.text = entity.Mp .. "/" .. entity.MpMax
        attackPowerLabel.text = entity.Attack .. ""
        powerLabel.text = entity.Strength .. ""
        defenseLabel.text = entity.Defence .. ""
        mentalityLabel.text = entity.Intelligence .. ""
        attackSpeedLabel.text = math.floor(100 * entity.ASpeed / 10000) / 100 .. ""
        agilityLabel.text = entity.Agility .. ""
        skillPointLabel.text = PlayerManager.Instance.LocalPlayer.Gold .. ""
    end

    MessageManager.AddListener(MsgType.UpdateStat, self.UpdateInfo)
end

---------------技能书相关---------------

-- 技能书按钮预制
local skillBookPrefab = Api.LoadImmediately("UI/Panels/BattlePanel/SkillBookItem.prefab", AssetType.Prefab)

function SkillBook:Init()
    -- 每个技能书item
    self.Items = { }
    -- 技能书按钮父级
    self.skillItemParent = transform:Find("SkillBookBar"):GetComponent(RectTransform)
    self.content = self.skillItemParent:Find("Content"):GetComponent(RectTransform)
    self.scaleFactor = Api.Canvas:GetComponent(Canvas).scaleFactor
    -- 技能书间距
    local space = 140
    local firstPos = Vector3(-140, 0, 0)
    self.isUp = false

    function self:GetIndex(go)
        count = 0
        for _, v in pairs(self.Items) do
            if v.sort then
                count = count + 1
                if v.go == go then
                    return count - 1
                end
            end
        end
    end

    function self:GetAllIndex()
        count = 0
        for _, v in pairs(self.Items) do
            if v.sort then count = count + 1 end
        end
        return count
    end

    -- 排序
    function self:Sort(backSnap)
        for k, v in pairs(self.Items) do
            local borderNum = 0
            if self.isUp then borderNum = 3 end

            if k <= #self.Items - borderNum then
                if self.isUp then
                    TimeManager.Instance:Do(0.5, function()
                        v.go:SetActive(false)
                    end )
                    v.sort = false
                else
                    v.go:SetActive(true)
                    v.sort = true
                end
            else
                v.go:SetActive(true)
                v.sort = true
            end
        end
        count = self:GetAllIndex()
        _count = count
        if self.isUp then
            if _count > 3 then _count = 3 end
        else
            if _count > 6 then _count = 6 end
        end
        Api.DoRect(self.skillItemParent, Vector2(_count * 140, 162), 0.5)
        self.tweener = Api.DoRect(self.content, Vector2(count * 140, 162), 0.5)
        TweenSetting.OnUpdate(self.tweener, function()
            xOffset =(self.content.sizeDelta.x - self.skillItemParent.sizeDelta.x) / 2
            if backSnap then xOffset = xOffset * -1 end
            if backSnap ~= nil then
                Tween.DOLocalMove(self.content, Vector3(xOffset, 0, 0), 0.5, false)
            end
            firstPos = Vector3(- self.content.sizeDelta.x / 2 + 70, 0, 0)
            for k, v in pairs(self.Items) do
                if v.sort then
                    res = Tween.DOLocalMove(v.go.transform, firstPos + Vector3.right * self:GetIndex(v.go) * space, 0.3, false)
                    TweenSetting.SetUpdate(res, false)
                else
                    res = Tween.DOLocalMove(v.go.transform, firstPos + Vector3.left * space, 0.3, false)
                    TweenSetting.SetUpdate(res, false)
                end
            end
        end )
    end

    function self:CheckSort()
        if #self.Items <= 1 then self:Sort(true) end
        _dis =(self.content.sizeDelta.x - self.skillItemParent.sizeDelta.x) / 2
        if self.content.localPosition.x > _dis or self.content.localPosition.x < - _dis then
            dis1 = Vector3.Distance(self.Items[1].go.transform.position, self.skillItemParent.position) / self.scaleFactor
            dis2 = Vector3.Distance(self.Items[#self.Items].go.transform.position, self.skillItemParent.position) / self.scaleFactor
            if dis1 < self.skillItemParent.sizeDelta.x / 2 - 70 then
                self:Sort(false)
            elseif dis2 < self.skillItemParent.sizeDelta.x / 2 - 70 then
                self:Sort(true)
            elseif dis1 > self.skillItemParent.sizeDelta.x / 2 - 70 and dis1 < dis2 then
                self:Sort(false)
            elseif dis2 > self.skillItemParent.sizeDelta.x / 2 - 70 and dis1 > dis2 then
                self:Sort(true)
            end
        end
    end

    -- 技能书拾取监听
    MessageManager.AddListener(MsgType.PickSkillBook, function(pa)
        local item = { }
        item.isGodSkill = false
        local dat = ConfigReader.GetItemCfg(pa.itemId)
        local skillId = 0
        if dat.n32Type == 1 then
            skillId = PlayerManager.Instance.LocalPlayer.GodSkill.id
            item.isGodSkill = true
        elseif dat.n32Type == 0 then
            skillId = dat.n32Retain1
            item.isGodSkill = false
        end
		if pa.skillId > 0 then
			skillId = pa.skillId
		end
        item.go = GameObject.Instantiate(Api.AsObject(skillBookPrefab))
        item.go.transform:SetParent(self.content)
        item.go.transform.localPosition = firstPos + Vector3.right * self:GetAllIndex() * space
        item.go.transform.localScale = Vector3.one
        item.go.name = tostring(skillId)
        item.sizeDelta = item.go:GetComponent(RectTransform).sizeDelta
        item.canUse = true
        item.OnVisible = item.go:GetComponent(OnVisible)
        item.IsVisible = function()
            return item.OnVisible.isVisible
        end
        item.sort = true
        item.info = pa
        item.icon = item.go.transform:Find("IconMask/Icon"):GetComponent(Image)
        item.skillInfo = ConfigReader.GetSkillDataInfo(skillId)
		-- Debug.LogError(skillId)
        Api.Load(item.skillInfo.szIcon, AssetType.Sprite, function(sp)
            item.icon.sprite = sp
        end )
        item.nameLabel = item.go.transform:Find("Name"):GetComponent(Text)
        item.nameLabel.text = item.skillInfo.szName
        item.glowImage = item.go.transform:Find("Glow"):GetComponent(Image)
        item.glowImage.gameObject:SetActive(true)
        local fireEffectGoPath = ""
        local kind = ConfigReader.GetItemCfg(pa.itemId).szRetain2
        if string.find(kind, "1") then
            fireEffectGoPath = "effect/ui/Jineng_icon_L.prefab"
            item.glowImage.color = Color.red
        elseif string.find(kind, "2") then
            fireEffectGoPath = "effect/ui/Jineng_icon_Z.prefab"
            item.glowImage.color = Color.blue
        elseif string.find(kind, "3") then
            fireEffectGoPath = "effect/ui/Jineng_icon_M.prefab"
            item.glowImage.color = Color.green
        elseif string.find(kind, "4") then
            fireEffectGoPath = "effect/ui/Jineng_icon_T.prefab"
            item.glowImage.color = Color.yellow
        else
            fireEffectGoPath = "effect/ui/Jineng_icon_T.prefab"
            item.glowImage.color = Color.black
        end

        item.glowEffectGo = Api.ShowScreenEffect("effect/ui/Jinengshu.prefab", item.go.transform.position, true, 1)
        if item.isGodSkill then
            item.fireEffectGo = Api.ShowScreenEffect(fireEffectGoPath, item.go.transform.position, false, 0)
            item.fireEffectGo.transform.localScale = Vector3.one * 0.7
        else
            fireEffectGoPath = nil
        end
        this.OnUpdateEvent = {
            "+=", function()
                if not Slua.IsNull(item.glowEffectGo) and not Slua.IsNull(item.go) then
                    item.glowEffectGo.transform.position = Camera.main:ScreenToWorldPoint(item.go.transform.position)
                end
                if item.isGodSkill then
                    if not Slua.IsNull(item.fireEffectGo) and not Slua.IsNull(item.go) then
                        item.fireEffectGo.transform.position = Camera.main:ScreenToWorldPoint(item.go.transform.position) + item.fireEffectGo.transform.forward * 5
                    end

                    if Slua.IsNull(item.go) then
                        if not Slua.IsNull(item.fireEffectGo) then
                            -- 销毁火焰特效
                            GameObject.Destroy(item.fireEffectGo)
                        end
                    end

                    if not Slua.IsNull(item.go) then
                        if item:IsVisible() ~= item.fireEffectGo.activeSelf then
                            item.fireEffectGo:SetActive(item:IsVisible())
                        end

                        if item.sort ~= item.fireEffectGo.activeSelf and item:IsVisible() then
                            item.fireEffectGo:SetActive(item.sort)
                        end
                    end
                end
            end
        }

        function item:SendUseMsg()
            item.canUse = false
            _startPos = item.go.transform.position
            _endPos = Skills:GetSkillInfoById(skillId)
            startPos = Vector3(math.floor(_startPos.x), math.floor(_startPos.y), 0)
            endPos = Vector3(math.floor(_endPos.x), math.floor(_endPos.y), 0)
            -- 发送使用技能书消息
            FightLogic.usePickItem(item.info.serverId, startPos, endPos)
        end

        -- 技能书点击监听
        item.go:GetComponent(Button).onClick:AddListener( function()
            if not item.canDrag or self.isSlide or not item.canUse then return end
        end )
        item.tipFlag = false
        item.timing = false
        item.downTimer = 0
        item.canDrag = false
        item.clone = nil
        item.listener = item.go:AddComponent(EventListener)
        
		item.listener.OnDragEvent = {
            "+=", function(go, data)
                local dis = item.go.transform.position - Input.mousePosition
                if math.abs(dis.y) / Api.UIScaleFactor > item.sizeDelta.x / 2 then
                    item.canDrag = true
					SkillBook.dragging = true
                else
                    item.canDrag = false
					SkillBook.dragging = false
                end
                if not Slua.IsNull(item.clone) then
                    if math.abs(dis.y) / Api.UIScaleFactor > item.sizeDelta.x then
                        local res = Tween.DOScale(item.clone.transform, 1.3, 0.3)
                        TweenSetting.SetUpdate(res, false)
                    else
                        local res = Tween.DOScale(item.clone.transform, 1, 0.3)
                        TweenSetting.SetUpdate(res, false)
                    end
                end
                if item.clone ~= nil then
                    item.clone.transform.position = Input.mousePosition
                end
                if Api.isMouseButtonDown and item.canDrag == false and Slua.IsNull(item.clone) then
                    if self.isUp then return end
                    self.content.position = self.content.position + Vector3(data.delta.x, 0, 0)
                    UIManager.Instance:HideSkillTip()
                else
                    if Api.isMouseButtonDown and item.clone == nil then
                        item.clone = GameObject.Instantiate(item.go)
                        item.clone.name = item.go.name .. "_clone"
                        item.clone.transform:SetParent(UIManager.Instance.MiddleLayer)
                        item.clone.transform.localScale = Vector3.one
                        -- * 1.5
                        item.clone.transform.localEulerAngles = Vector3.zero
                        item.clone.transform.position = Input.mousePosition
                        item.clone:AddComponent(CanvasGroup).alpha = 0.6
                        GameObject.Destroy(item.clone:GetComponent(Button))
                        item.clone.transform:Find("IconMask/Icon"):GetComponent(Image).raycastTarget = false
                    end
                end
            end
        }

        item.listener.OnPointerDownEvent = {
            "+=", function(go, data)
                UIManager.Instance:ShowSkillTip(item.skillInfo.szDescribe, item.go.transform.position, SkillTipPosType.Up)
                item.tipFlag = true
				Tween.DOKill(self.content, false)
            end
        }

        item.listener.OnEndDragEvent = {
            "+=", function(go, data)
                if not item.canDrag then
                    if self.isUp then return end
                    self.isSlide = false
                    self:CheckSort()
                else
                    if item.clone ~= nil then
                        GameObject.Destroy(item.clone)
                        item.clone = nil
                    end
                    item.canDrag = false
                end
            end
        }

        item.listener.OnPointerUpEvent = {
            "+=", function(arg1, arg2)
                if Slua.IsNull(item.go) then return end
                UIManager.Instance:HideSkillTip()
				SkillBook.dragging = false
                if item.clone ~= nil then
                    self:CheckSort()
                    obj = Api.GetRayCastObject()
                    local dis = item.go.transform.position - Input.mousePosition
                    if Slua.IsNull(obj) then
                        if math.abs(dis.y) / Api.UIScaleFactor > item.sizeDelta.x then
                            item:SendUseMsg()
                        end
                    else
                        if obj.tag == "SkillItem" then
							Skills:HideExchangeGlow(tonumber(obj.name))
                            local bSkillInfo = ConfigReader.GetSkillDataInfo(tonumber(obj.name))
                            if item.skillInfo.n32SkillType == 2 and bSkillInfo.n32SkillType == 2 then
                                if math.abs(dis.y) / Api.UIScaleFactor > item.sizeDelta.x then
									item:SendUseMsg()
                                end
                            else
                                if isEnter or SelfPlayerDead then
                                    if item.skillInfo.n32SkillType ~= 2 and bSkillInfo.n32SkillType ~= 2 then
                                        if tostring(skillId) ~= obj.name then
                                            if table.containKey(Skills.SkillList, tostring(skillId)) then
                                                MessageBox.Instance:OpenText("已经学习过的技能!", Color.white, 1.5, MessageBoxPos.Middle)
                                            else
                                                FightLogic.replaceSkill(item.info.serverId, tonumber(obj.name))
                                            end
                                        else
                                            MessageBox.Instance:OpenText("相同的技能!", Color.white, 1.5, MessageBoxPos.Middle)
                                        end
                                    else
                                        MessageBox.Instance:OpenText("大招不能替换!", Color.white, 1.5, MessageBoxPos.Middle)
                                    end
                                else
                                    MessageBox.Instance:OpenText("请在基地范围之内替换技能!", Color.white, 1.5, MessageBoxPos.Middle)
                                end
                            end
                        else
                            if math.abs(dis.y) / Api.UIScaleFactor > item.sizeDelta.x then
								item:SendUseMsg()
                            end
                        end
                    end
                    GameObject.Destroy(item.clone)
                    item.clone = nil
                end
                item.tipFlag = false
            end
        }
        this.OnUpdateEvent = {
            "+=", function()
                if self.isSlide or Slua.IsNull(item.go) then return end
                if item.tipFlag then
                    local dis = Vector2.Distance(item.go.transform.position, Input.mousePosition) / Api.UIScaleFactor
                    if Api.isMouseButtonDown == false or dis > item.sizeDelta.x / 2 then
                        print("dis", dis)
                        UIManager.Instance:HideSkillTip()
                        item.tipFlag = false
						self.isSlide = false
						item.canDrag = false
                    end
                end
            end
        }

        table.insert(self.Items, item)
        self:Sort(true)
    end )

    -- 技能书使用监听(更新UI显示)
    MessageManager.AddListener(MsgType.UseSkillBook, function(item)
        -- local isSelf = item.belong == PlayerManager.Instance.LocalPlayer.ServerId
        local temp = nil
        local pos = -1

        for k, v in pairs(self.Items) do
            if v.info.serverId == item.serverId then
                pos = k
                temp = v
            end
        end

        if temp == nil then return end

        GameObject.Destroy(temp.go)

        table.remove(self.Items, pos)

        if self.isUp then
            self:Sort(true)
        else
            self:Sort()
        end
    end )

    -- 替换技能监听
    MessageManager.AddListener(MsgType.ExchangeSkill, function(args)
        local newId, oldId = args[1], args[2]
        Skills:ExchangeSkill(oldId, newId)
    end )
end

--------------技能书仓库--------------

function SkillBookWareHouse:Init()
    self.panel = transform:Find("Bottom/ItemWarehouse")
    self.parent = self.panel:Find("Layout/View/Content")
    self.sizeDelta = self.panel:GetComponent(RectTransform).sizeDelta
    self.panel.localPosition = self.panel.localPosition + Vector3.down * self.sizeDelta.y
    self.panel.gameObject:SetActive(false)
    self.tweenTime = 0.3
    self.isOpen = false
    self.Open = function()
        self.isOpen = true
        self.panel.gameObject:SetActive(true)
        Tween.DOLocalMoveY(self.panel, self.panel.localPosition.y + self.sizeDelta.y, self.tweenTime, false)
    end
    self.Close = function()
        self.isOpen = false
        local res = Tween.DOLocalMoveY(self.panel, self.panel.localPosition.y - self.sizeDelta.y, self.tweenTime, false)
        TweenSetting.OnComplete(res, function()
            self.panel.gameObject:SetActive(false)
        end )
    end
    transform:Find("Bottom/Content/SkillBook"):GetComponent(Button).onClick:AddListener( function()
        self:Open()
    end )
    self.panel:Find("CloseButton"):GetComponent(Button).onClick:AddListener( function()
        self:Close()
    end )
    MessageManager.AddListener(MsgType.PickSkillBook, function(item)
        local exis = false
        for k, v in pairs(self.Books) do
            if v.info.serverId == item.serverId then exis = true end
        end
        if exis then return end

        local si = { }
        si.go = GameObject.Instantiate(skillBookPrefab)
        si.go.transform:SetParent(self.parent)
        si.go.transform.localScale = Vector3.one
        si.go.transform.localEulerAngles = Vector3.zero
        si.info = item
        si.icon = si.go.transform:Find("IconMask/Icon"):GetComponent(Image)

        local dat = ConfigReader.GetItemCfg(item.itemId)
        local skillId = 0
        if dat.n32Type == 1 then
            skillId = PlayerManager.Instance.LocalPlayer.GodSkill.id
        elseif dat.n32Type == 0 then
            skillId = dat.n32Retain1
        end

        si.go.name = tostring(item.serverId .. "_" .. skillId)

        si.skillInfo = ConfigReader.GetSkillDataInfo(skillId)
        local spName = si.skillInfo.szIcon
        Api.Load("UI/Textures/SkillIcon/" .. spName, AssetType.Sprite, function(sp)
            si.icon.sprite = sp
        end )

        si.nameLabel = si.go.transform:Find("Name"):GetComponent(Text)
        si.nameLabel.text = si.skillInfo.szName

        si.glowImage = si.go.transform:Find("Glow"):GetComponent(Image)
        si.glowImage.gameObject:SetActive(false)
        if self.isOpen then
            TimeManager.Instance:Do(Time.deltaTime, function()
                if si.go.transform.localPosition.x > 1000 then return end
                Api.ShowScreenEffect("effect/ui/Jinengshu.prefab", si.go.transform.position, true, 1)
            end )
        end
        si.go:GetComponent(Button).onClick:AddListener( function()
            local dat = ConfigReader.GetItemCfg(item.itemId)
            local skillId = 0
            if dat.n32Type == 1 then
                skillId = PlayerManager.Instance.LocalPlayer.GodSkill.id
            elseif dat.n32Type == 0 then
                skillId = dat.n32Retain1
            end


            if Skills.SkillList[tostring(skillId)] == nil or Skills.SkillList[tostring(skillId)].level < quest.SkillMaxLevel then
                local preName
                if Skills.SkillList[tostring(skillId)] == nil then
                    preName = "Jinengxuexi.prefab"
                else
                    preName = "Jinengshenji.prefab"
                end
                if preName == "Jinengshenji.prefab" or(preName == "Jinengxuexi.prefab" and table.size(Skills.SkillList) < 4) then
                    TimeManager.Instance:Do(0.8, function()
                        local endPos = Skills:GetSkillInfoById(skillId)
                        Api.ShowScreenEffect("effect/ui/" .. preName, endPos, true, 1);
                    end )
                end
            end
            FightLogic.usePickItem(item.serverId)
        end )
        table.insert(self.Books, si)
    end )
    MessageManager.AddListener(MsgType.UseSkillBook, function(item)
        local isSelf = item.belong == PlayerManager.Instance.LocalPlayer.ServerId
        local pos = -1
        local startPos = Vector3.zero
        for k, v in pairs(self.Books) do
            if v.info.serverId == item.serverId then startPos = v.go.transform.position pos = k end
        end
        if self.isOpen and isSelf and startPos.x < 1000 then
            local dat = ConfigReader.GetItemCfg(item.itemId)
            local skillId = 0
            if dat.n32Type == 1 then
                skillId = PlayerManager.Instance.LocalPlayer.GodSkill.id
            elseif dat.n32Type == 0 then
                skillId = dat.n32Retain1
            end
            local endPos = Skills:GetSkillInfoById(skillId)
            Api.ShowPickupSkillBookEffect(startPos, endPos)
        end
        if pos ~= -1 then
            GameObject.Destroy(self.Books[pos].go)
            table.remove(self.Books, pos)
        end
    end )
end


---------------自动调用---------------
function BattlePanel:Start()
    this = BattlePanel.this
    transform = BattlePanel.transform
    gameObject = BattlePanel.gameObject
	
	Top:Init()
    Skills:Init()
    SelfInfo:Init()
    Heros:Init()
    SkillBook:Init()
    -- SkillBookWareHouse:Init()
    MessageManager.AddListener(MsgType.PlayLineEffect, function(arg)
        local startPos, endPos = arg[0], arg[1]
        Api.ShowPickupSkillBookEffect(startPos, endPos)
    end )
	
	-- 游戏结束监听
	MessageManager.AddListener(MsgType.GameOver, function(arg)
		UIManager.Instance:OpenPanel("SettlementPanel", true, arg)
	end)
	
	end

function BattlePanel:OnDestroy()
    MessageManager.RemoveListener(MsgType.UpdateStat)
end

---------------留给C#调用的接口---------------
-- 参数1：技能id 参数2：点击回调
function BattlePanel:AddSkillClickListener(...)
    local t = ...
    local id, callback = t[1], t[2]
    if self.Skills.SkillList[tostring(id)] == nil then
        Debug.LogError("skillId " .. tostring(id) .. " is not found!!!")
        return
    end
    Debug.LogWarning("add skill listener" .. tostring(id))
    self.Skills.SkillList[tostring(id)]:AddListener(callback)
end

-- 参数1：技能id 参数2：需要注销的回调
function BattlePanel:RemoveSkillClickListener(...)
    local t = ...
    local id, callback = t[1], t[2]
    if self.Skills.SkillList[tostring(id)] == nil then
        Debug.LogError("skillId " .. tostring(id) .. " is not found!!!")
        return
    end
    self.Skills.SkillList[tostring(id)]:RemoveListener(callback)
end

return BattlePanel
