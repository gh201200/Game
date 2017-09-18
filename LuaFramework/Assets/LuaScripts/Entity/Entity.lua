local Entity = class("Entity")

local this = nil

function Entity:ctor(...)
	this = self
	this.go, this.entityType = ...
	this:InitFSM()
	LuaManager.OnUpdateEvent = {"+=", this.Update}
end

function Entity:InitFSM()
	this.fsm = FSMSystem.new()
	
	local idleState = IdleState.new(this, this.fsm)
	this.fsm:AddState(idleState)
end

function Entity.Update()
	fsm:Update()
end

-- entity销毁时手动调用
function Entity:OnDestory()
	LuaManager.OnUpdateEvent = {"-=", this.Update}
end

return Entity
