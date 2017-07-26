local LoadingScenePanel = { }

local this
local transform
local gameObject

local slider
local percentLabel
local gameTip
local ao
local OnComplete

local isOpen = false
local curTime
local totalTime = 1.5

function LoadingScenePanel:Start()
    this = LoadingScenePanel.this
    transform = LoadingScenePanel.transform
    gameObject = LoadingScenePanel.gameObject
    slider = transform:Find("Slider"):GetComponent(Slider)
    percentLabel = transform:Find("Slider/PercentLabel"):GetComponent(Text)
    gameTip = transform:Find("GameTip"):GetComponent(Text)
end

function LoadingScenePanel:OnOpen(args)
    isOpen = true
    curTime = 0
    slider.value = 0
	if args[1] then
		ao = args[1]
	else
		Debug.LogError("ao is null")
		return
	end
	if #args >= 2 then
		if args[2] then
			OnComplete = args[2]
		else
			OnComplete = nil
		end
	end
end

function LoadingScenePanel:OnClose()
    isOpen = false
end

function LoadingScenePanel:UpdatePercent()
    if isOpen == false then return end
    Api.SetActive(gameObject, true)
	-- slider.value = ao.progress
	-- percentLabel.text = math.floor(ao.progress * 100) .. "%"
	-- if ao.isDone and OnComplete ~= nil then
		-- OnComplete:Invoke()
		-- isOpen = false
	-- end
    curTime = curTime + Time.deltaTime
    if curTime >= totalTime then
        curTime = totalTime
        slider.value = 1
        percentLabel.text = 100 .. "%"
        isOpen = false
		if OnComplete then OnComplete:Invoke() end
		if SceneManager.GetActiveScene().name == "UIScene" then
			UIManager.Instance:ClosePanel("LoadingScenePanel")
		end
		
        return
    end
    slider.value = curTime / totalTime
    percentLabel.text = math.floor(curTime / totalTime * 100) .. "%"
	
end

function LoadingScenePanel:Update()
    self:UpdatePercent()
end

function LoadingScenePanel:OnDestroy()
end

return LoadingScenePanel
