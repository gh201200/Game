local LoadingPanel = { }

local this
local icon

function LoadingPanel:Start()
    this = LoadingPanel.this
    icon = this.transform:Find("Image"):GetComponent(Image)
end

function LoadingPanel:Update()
    icon.transform:Rotate(- Vector3.forward * 120 * Time.deltaTime)
end

function LoadingPanel:FixedUpdate()

end

function LoadingPanel:LateUpdate()

end

function LoadingPanel:OnDestroy()

end

return LoadingPanel
