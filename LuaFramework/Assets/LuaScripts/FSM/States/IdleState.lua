local IdleState = class("IdleState", FSMState)

local this = nil

function IdleState:ctor(...)
	this = self
	this.id = StateID.Idle
end

function IdleState:Enter()
	this.super:Enter()
end

function IdleState:Act()
	this.super:Act()
end

function IdleState:Reason()
	this.super:Reason()
end

function IdleState:Exit()
	this.super:Exit()
end

return IdleState
