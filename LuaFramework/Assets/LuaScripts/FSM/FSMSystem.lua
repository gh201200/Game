local FSMSystem = class("FSMSystem")

local this = nil

function FSMSystem:ctor(...)
	this = self
	this.states = {}
	this.preState = nil
	this.curState = nil
end

function FSMSystem:AddState(state)
	if not state then
		Debug.LogError("state can not be nil")
		return
	end
	if this.states[state.id] then
		Debug.LogError("stateID " .. state.id .. " is already exists!")
		return
	end
	if not this.curState then
		this.curState = state
	end
	this.states[state.id] = state
end

function FSMSystem:RemoveState(state)
	if not state then
		Debug.LogError("state can not be nil")
		return
	end
	if not this.states[state.id] then
		Debug.LogError("stateID " .. state.id .. " you want to remove is not exists!")
		return
	end
	if state == this.curState then
		this.curState = nil
	end
	this.states[state.id] = nil
end

function FSMSystem:Update()
	if not this.curState then return end
	if this.preState ~= this.curState then
		if this.preState then
			this.preState:Exit()
		end
		this.curState:Enter()
	end
	this.curState:Act()
	this.curState:Reason()
end

function FSMSystem:PerformTransition(transition)
	if not table.containsValue(StateTransition, transition) then
		Debug.LogError("transition id " .. transition .. " is not exists!")
		return
	end
	if not this.curState then
		Debug.LogError("curState is nil, transition failed!")
		return
	end
	local id = this.curState:GetStateID(transition)
	if not id then
		Debug.LogError("state id" .. this.curState.id .. " has no state for transition id" .. transition)
		return
	end
	if not this.states[id] then
		Debug.LogError("stateid " .. id .. " is not exists!")
		return
	end
	this.curState = this.states[id]
end

return FSMSystem
