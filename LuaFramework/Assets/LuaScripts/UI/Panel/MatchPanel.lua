local MatchPanel = { }

local this
local transform
local gameObject

local gameTip
local cancelButton
local mapIcon1, mapIcon2

function MatchPanel:MatchAnimation()
    magnifying:RotateAround(rotatePoint.position, Vector3.forward, 180 * Time.deltaTime);
    magnifying.localEulerAngles = Vector3.zero

    pointTimer = pointTimer + Time.deltaTime * 4
    timer = math.floor(pointTimer)
    index = timer % 4

    if index == 0 then
        matchText.text = "匹配中"
    elseif index == 1 then
        matchText.text = "匹配中."
    elseif index == 2 then
        matchText.text = "匹配中.."
    elseif index == 3 then
        matchText.text = "匹配中..."
    end
end

function MatchPanel:Start()
    this = MatchPanel.this
    transform = MatchPanel.transform
    gameObject = MatchPanel.gameObject

    gameTip = transform:Find("GameTip")
    cancelButton = transform:Find("CancelButton")
	mapIcon1 = transform:Find("Map"):GetComponent(Image)
	mapIcon2 = transform:Find("Mask/Map2"):GetComponent(Image)

    cancelButton:GetComponent(Button).onClick:AddListener( function()
		SystemLogic.CancelMatch()
    end )
	
	MessageManager.AddListener(MsgType.CancelMatch, function()
        UIManager.Instance:OpenPanel("MainPanel", true)
	end)
end

function MatchPanel:OnOpen(args)
	mapIcon1.sprite = Api.LoadImmediately(quest.Arena[Account.level].BattleGroundPreview, AssetType.Sprite)
	mapIcon2.sprite = Api.LoadImmediately(quest.Arena[Account.level].BattleGroundPreview, AssetType.Sprite)
end

function MatchPanel:Update()
    -- if UIManager.Instance:IsPanelShow("MatchPanel") then
        -- self:MatchAnimation()
    -- end
end

function MatchPanel:FixedUpdate()

end

function MatchPanel:LateUpdate()

end

function MatchPanel:OnDestroy()

end

return MatchPanel
