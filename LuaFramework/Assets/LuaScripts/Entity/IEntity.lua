local IEntity = class("IEntity")

local this = nil

function IEntity:ctor(...)
	this = self
	this.go = ...
	this.preState = nil
	this.curState = EntityState.Idle
	LuaManager.OnUpdateEvent = {"+=", this.Update}
	LuaManager.OnDestroyEvent = {"+=", this.OnDestroy}
end

function IEntity:CanChangeState(state)
	local state = EntityState[state]
	if not state then
		Debug.LogError("state:'" .. state .. "' is not exists!")
		return
	end
	if state == this.curState then
		return false
	end
	return true
end

function IEntity:ChangeState(state)
	if not this:CanChangeState(state) then return end
	this.preState = this.curState
	this.curState = state
end

function IEntity.Update()
	if this.curState ~= this.preState then
		if this.preState then
			EventManager:Dispatch(EventType.OnStateExit, this.preState, this)
		end
		this.preState = this.curState
		EventManager:Dispatch(EventType.OnStateEnter, this.curState, this)
	end
	EventManager:Dispatch(EventType.OnStateExecute, this.curState, this)
end

function IEntity.OnDestroy()
	LuaManager.OnUpdateEvent = {"-=", this.Update}
end

return IEntity
