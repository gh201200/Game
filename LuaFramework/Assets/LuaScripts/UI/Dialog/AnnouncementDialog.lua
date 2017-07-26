local AnnouncementDialog = {}

local this
local transform
local gameObject

local message

function AnnouncementDialog:Start()
	this = AnnouncementDialog.this
	transform = AnnouncementDialog.transform
	gameObject = AnnouncementDialog.gameObject
	message = transform:Find("View/Content/Text"):GetComponent(Text)
	transform:Find("SureButton"):GetComponent(Button).onClick:AddListener(function()
		this:OnClose()
	end)
end

function AnnouncementDialog:OnOpen(args)
	message.text = args[1]
end

function AnnouncementDialog:Update()

end

function AnnouncementDialog:FixedUpdate()

end

function AnnouncementDialog:LateUpdate()

end

function AnnouncementDialog:OnDestroy()

end

return AnnouncementDialog
