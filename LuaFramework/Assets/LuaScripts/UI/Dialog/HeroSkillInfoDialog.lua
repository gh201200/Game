local HeroSkillInfoDialog = {}

local this
local transform
local gameObject

local heroName						-- 英雄名字
local skillContent
local slotRoot						-- 技能槽根节点

local tagLabel
local influenceImage

local info, sInfo					-- 英雄信息类	英雄信息类（服务器下发）

local prefab						-- 技能item预制

local preSlot, curSlot				-- 上一个选中的槽位		现在选中的槽位

local sr							-- 滑动列表控件

local clone = nil					-- 技能item的克隆体

local Slots = { }
local Skills = { }

function HeroSkillInfoDialog:Start()
	this = HeroSkillInfoDialog.this
	transform = HeroSkillInfoDialog.transform
	gameObject = HeroSkillInfoDialog.gameObject
	heroName = transform:Find("Title"):GetComponent(Text)
	skillContent = transform:Find("SkillList/View/Content")
	slotRoot = transform:Find("SkillSlot")
	sr = transform:Find("SkillList"):GetComponent(ScrollRect)
	tagLabel = transform:Find("Tag"):GetComponent(Text)
	influenceImage = transform:Find("Tag/InfluenceImage"):GetComponent(Image)
	
	transform:Find("CloseButton"):GetComponent(Button).onClick:AddListener(function()
		UIManager.Instance:GetPanel("MainPanel"):CloseAllDialog()
	end)
	
	transform:Find("BackButton"):GetComponent(Button).onClick:AddListener(function()
		this:OnClose()
		DialogManager.Instance:Open("HeroInfoDialog", info)
	end)
	
	-- 加载技能item预制
	prefab = Api.LoadImmediately("UI/Prefabs/SkillItem.prefab", AssetType.Prefab)
	
	-- 初始化技能槽位
	for i = 0, slotRoot.childCount - 1 do
		local si = { }
		si.info = nil
		si.go = slotRoot:GetChild(i).gameObject
		si.icon = si.go.transform:Find("IconMask/Icon"):GetComponent(Image)
		si.skillName = si.go.transform:Find("SkillName"):GetComponent(Text)
		si.levelLabel = si.go.transform:Find("IconMask/LevelBg/LevelLabel"):GetComponent(Text)
		si.starContent = si.go.transform:Find("StarContent")
		si.selectCg = si.go.transform:Find("Select"):GetComponent(CanvasGroup)
		si.selectCg.alpha = 0
		si.tweener = nil
		si.index = i
		si.hasConfig = false
		si.listener = si.go:GetComponent(UIButton)
		
		-- 鼠标进入监听
		si.listener.onEnter:AddListener(function()
			if not clone then return end
			preSlot = curSlot
			curSlot = si
			if curSlot then
				curSlot:GetFocus()
			end
			if preSlot then
				preSlot:LoseFocus()
			end
		end)
		
		-- 鼠标离开监听
		si.listener.onExit:AddListener(function()
			if not clone then return end
			if curSlot then
				curSlot:LoseFocus()
			end
			if preSlot then
				preSlot:LoseFocus()
			end
		end)
					
		-- 技能配置成功监听
		MessageManager.AddListener(MsgType.SkillConfig, function(t)
			if t.slot == si.index then
				si.hasConfig = true
				si.info = ConfigReader.GetSkillDataInfo(t.skillId)
				si.skillName.text = si.info.szName
				si.levelLabel.text = si.info.n32Upgrade
				si.icon.sprite = Api.LoadImmediately(si.info.szIcon, AssetType.Sprite)
				for a = 0, si.starContent.childCount -1 do
					si.starContent:GetChild(a).gameObject:SetActive(a <= si.info.n32Quality)
				end
			end
		end)
		
		-- 获取焦点
		function si:GetFocus()
			if si.tweener then TweenExtensions.Kill(si.tweener, false) end
			si.selectCg.alpha = 1
		end
		
		-- 失去焦点
		function si:LoseFocus()
			if si.tweener then TweenExtensions.Kill(si.tweener, false) end
			si.tweener = Api.Fade(si.selectCg, 0.5, true)
		end
		
		Slots[i] = si
	end
end
	
function HeroSkillInfoDialog:OnOpen(args)
	if #args < 2 then
		Debug.LogError("缺少参数! -> HeroSkillInfoDialog:OnOpen(args)")
		return
	end
	info, sInfo = args[1], args[2]
	
	local Configs = { }
	
	self.co = coroutine.create(function()
		Yield(WaitForEndOfFrame())
		local t = { }
		local index = 0
		for p in Slua.iter(AgentData.Instance.mSkill) do
			t[index] = p.value
			index = index + 1
		end
		local size = table.size(t)
		for i = 0, size - 1 do
			for j = i + 1, size - 1 do
				local temp = t[i]
				if t[i].dataId > t[j].dataId then
					t[i] = t[j]
					t[j] = temp
				end
			end
		end
		
		heroName.text = info.szName
		tagLabel.text = quest.IllustrationContent.HeroCamp[info.n32Camp]
		if info.n32Camp == 1 then
			influenceImage.sprite = Api.LoadImmediately("UI/Textures/Common/H.png", AssetType.Sprite)
		elseif info.n32Camp == 2 then
			influenceImage.sprite = Api.LoadImmediately("UI/Textures/Common/l.png", AssetType.Sprite)
		elseif info.n32Camp == 4 then
			influenceImage.sprite = Api.LoadImmediately("UI/Textures/Common/R.png", AssetType.Sprite)
		end
		
		index = -1
		for k, v in pairs(t) do
			local _info = ConfigReader.GetSkillDataInfo(v.dataId)
			if info.n32Camp == _info.n32Faction then
				index = index + 1
				if Skills[index] == nil then
					local si = { }
					if this.isOpen == false then
						return
					end
					si.index = index
					si.info = _info
					si.go = GameObject.Instantiate(prefab)
					si.go.transform:SetParent(skillContent)
					si.go.transform.localScale = Vector3.one
					si.go.transform.localEulerAngles = Vector3.zero
					si.go.transform:SetSiblingIndex(k)
					si.icon = si.go.transform:Find("IconMask/Icon"):GetComponent(Image)
					si.level = si.go.transform:Find("IconMask/LevelBg/LevelLabel"):GetComponent(Text)
					si.name = si.go.transform:Find("SkillName"):GetComponent(Text)
					si.comprehend = si.go.transform:Find("IconMask/Comprehend").gameObject
					si.listener = si.go:GetComponent(UIButton)
					si.starContent = si.go.transform:Find("StarContent")
					
					-- 计时标志位
					si.timerFlag = false
					-- 拖拽标志位
					si.dragFlag = false
					-- 计时器
					si.timer = 0
					-- 生成克隆的间隔时间
					si.interval = 0.2
					
					function si:Update(arg)
						if arg then
							si.info = arg
						end
						si.comprehend:SetActive(false)
						-- 是否领悟该技能
						si.hasComprehend = false
						-- 星星数量显示
						for a = 0, si.starContent.childCount -1 do
							si.starContent:GetChild(a).gameObject:SetActive(a <= si.info.n32Quality)
						end
						-- 加载图标
						si.icon.sprite = Api.LoadImmediately(si.info.szIcon, AssetType.Sprite)
						si.level.text = si.info.n32Upgrade
						si.name.text = si.info.szName
						si.go.name = si.info.szName
						--Debug.LogError(si.go.name)
					end
					
					si:Update()
					
					-- 鼠标按下监听
					si.listener.onDown:AddListener(function()
						si.timerFlag = true
						si.dragFlag = false
						si.timer = 0
					end)
					
					-- 鼠标抬起监听
					si.listener.onUp:AddListener(function()
						si.timerFlag = false
						si.timer = 0
					end)
					
					this.OnUpdateEvent = {
						"+=", function()
							if si.timerFlag then
								si.timer = si.timer + Time.deltaTime
								if si.timer >= si.interval then
									-- 克隆GameObject
									clone = GameObject.Instantiate(si.go)
									clone.name = si.go.name .. "_clone"
									clone.transform:SetParent(UIManager.Instance.MiddleLayer)
									clone.transform.localScale = Vector3.one * 1.2
									clone:AddComponent(CanvasGroup).alpha = 0.6
									clone.transform:Find("IconMask/Icon"):GetComponent(Image).raycastTarget = false
									clone:GetComponent(RectTransform).sizeDelta = Vector2(180, 180)
									si.timerFlag = false
									si.dragFlag = true
									si.timer = 0
									sr.enabled = false
									curSlot = nil
									preSlot = nil
								end
							end
							
							-- 克隆物体位置跟随
							if clone then
								clone.transform.position = Input.mousePosition
							end
							
							-- 鼠标抬起监听
							if Input.GetMouseButtonUp(0) then
								if not si.dragFlag then return end
								si.timerFlag = false
								si.dragFlag = false
								si.timer = 0
								if clone then
									GameObject.Destroy(clone)
									clone = nil
									sr.enabled = true
									if curSlot then
										if not si.hasComprehend then
											-- 向服务器发送配置英雄技能请求
											local skillData = AgentData.Instance:GetSkillDataBySerId(si.info.n32SeriId)
											SystemLogic.bindSkill(curSlot.index, sInfo.uuid, skillData.uuid)
										else
											MessageBox.Instance:OpenText("这个技能已领悟!", Color.white, 1, MessageBoxPos.Middle)
										end
										curSlot:LoseFocus()
										if preSlot then
											preSlot:LoseFocus()
										end
										preSlot = nil
										curSlot = nil
									end
								end
							end
						end
					}
					
					si.SkillConfig = function(t)
						Configs[t.slot] = t.skillId
						--TimeManager.Instance:Do()
						local exis = false
						for _, v in pairs(Configs) do
							if v == si.info.id then exis = true end
						end
						if exis then
							si.comprehend:SetActive(true)
							si.hasComprehend = true
						else
							si.comprehend:SetActive(false)
							si.hasComprehend = false
						end
					end
					
					-- 技能配置成功监听
					MessageManager.AddListener(MsgType.SkillConfig, si.SkillConfig)
					
					Skills[si.index] = si
					Yield(WaitForEndOfFrame())
				else
					Skills[index]:Update(_info)
				end
				
			end		
		end
		
		for i = 0, table.size(Skills) - 1 do
			Skills[i].go:SetActive(i <= index)
		end
		
		Api.DispatchSkillConfigMessage(info.id)
	end)
	coroutine.resume(self.co)
end

function HeroSkillInfoDialog:OnClose()

end

function HeroSkillInfoDialog:OnDestroy()

end

return HeroSkillInfoDialog
