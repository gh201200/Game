local TextBox = { }

local this
local transform
local gameObject

local label
local rt

function TextBox:Start()
    this = TextBox.this
    transform = TextBox.transform
    gameObject = TextBox.gameObject

    label = transform:Find("Bg/Label"):GetComponent(Text)
    rt = transform:Find("Bg"):GetComponent(RectTransform)
end

function TextBox:OnOpen(...)
    local ps = ...
    local content = ps[1]
    local color = ps[2]
    local pos = ps[3]
    label.text = content
    label.color = color
    rt.localScale = Vector3.zero
    TimeManager.Instance:Do(Time.deltaTime, function()
        rt.localScale = Vector3.one
        local offset = rt.sizeDelta.y / 2 + Screen.height / 6
        local newPosY
        if pos == MessageBoxPos.Top then
            newPosY = 960 - offset
        elseif pos == MessageBoxPos.Middle then
            newPosY = 0
        elseif pos == MessageBoxPos.Bottom then
            newPosY = -960 + offset
        end
        rt.localPosition = Vector3(0, newPosY, 0)
    end )
end

return TextBox
