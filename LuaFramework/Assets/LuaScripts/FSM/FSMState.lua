local FSMState = class("FSMState")

local this = nil

function FSMState:ctor(...)
	this = self
	this.entity, this.fsm = ...
	this.id = StateID.Idle
	this.transitionMap = {}
end

function FSMState:AddTransition(stateID, transition)
	if not table.containsValue(StateTransition, transition) then
		Debug.LogError("transition id " .. transition .. " is not exists!")
		return
	end
	if not table.containsValue(StateID, stateID) then
		Debug.LogError("state id " .. stateID .. " is not exists!")
		return
	end
	if not this.transitionMap[stateID] then
		this.transitionMap[stateID] = {}
	end
	for k, v in pairs(this.transitionMap) do
		for k2, _ in pairs(v) do
			if k2 == transition then
				Debug.LogError("one transition can only has one stateID" .. " stateID:" .. stateID .. "," .. k .. " has the same transition:" .. transition)
				return
			end
		end
	end
	this.transitionMap[stateID][transition] = true
end

function FSMState:RemoveTransition(stateID, transition)
	if not transition then
		if this.transitionMap[stateID] then
			this.transitionMap[stateID] = nil
			return
		else
			Debug.LogError("state id " .. stateID .. " you want to remove is not exists!")
			return
		end
	end
	if not table.containsValue(StateTransition, transition) then
		Debug.LogError("transition id " .. transition .. " is not exists!")
		return
	end
	if not table.containsValue(StateID, stateID) then
		Debug.LogError("state id " .. stateID .. " is not exists!")
		return
	end
	this.transitionMap[stateID][transition] = nil
end

function FSMState:GetStateID(transition)
	for stateID, transitionList in pairs(this.transitionMap) do
		for k, _ in pairs(transitionList) do
			if k == transition then
				return stateID
			end
		end
	end
	return nil
end

function FSMState:Enter()

end

function FSMState:Exit()

end

function FSMState:Act()

end

function FSMState:Reason()

end

return FSMState
