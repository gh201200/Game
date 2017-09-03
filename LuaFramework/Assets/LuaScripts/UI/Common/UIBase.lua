local UIBase = class("UI.Common.UIBase")

local this = nil

function UIBase:ctor(...)
	this = self
	this.animationDuration = 0.5
	this.go = ...
end

function UIBase:OnOpen(...)
	this.AnimationType = UIConfig[this.panelName].AnimationType
	if this.AnimationType == AnimationType.None then
	
	elseif this.AnimationType == AnimationType.Alpha then
	
	elseif this.AnimationType == AnimationType.Scale then
	
	elseif this.AnimationType == AnimationType.L2R then
	
	elseif this.AnimationType == AnimationType.R2L then
	
	elseif this.AnimationType == AnimationType.T2B then
	
	elseif this.AnimationType == AnimationType.B2T then
	
	end
end

function UIBase:OnClose()
	
end

return UIBase
