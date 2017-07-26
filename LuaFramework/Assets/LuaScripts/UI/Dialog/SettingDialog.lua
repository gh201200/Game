local SettingDialog = {}

local this
local transform
local gameObject

local musicLine
local soundLine

function SettingDialog:Start()
	this = SettingDialog.this
	transform = SettingDialog.transform
	gameObject = SettingDialog.gameObject
	musicLine = transform:Find("MusicButton/Line").gameObject
	soundLine = transform:Find("SoundButton/Line").gameObject
	transform:Find("MusicButton"):GetComponent(Button).onClick:AddListener(function()
		PlayerInfo.MusicFlag = not PlayerInfo.MusicFlag
		musicLine:SetActive(not PlayerInfo.MusicFlag)
		if PlayerInfo.MusicFlag then
			SoundManager.Instance:Play("MainPanel_Bg", true)
		else
			SoundManager.Instance:Pause()
		end
	end)
	transform:Find("SoundButton"):GetComponent(Button).onClick:AddListener(function()
		PlayerInfo.SoundFlag = not PlayerInfo.SoundFlag
		soundLine:SetActive(not PlayerInfo.SoundFlag)
		SoundManager.enableSound = PlayerInfo.SoundFlag
	end)
end

function SettingDialog:OnOpen(args)
	musicLine:SetActive(not PlayerInfo.MusicFlag)
	soundLine:SetActive(not PlayerInfo.SoundFlag)
end

function SettingDialog:Update()

end

function SettingDialog:FixedUpdate()

end

function SettingDialog:LateUpdate()

end

function SettingDialog:OnDestroy()

end

return SettingDialog
