local _G,pairs,table,type,print,GUI,CopyTable,os,ConstValue,Screen,getfenv,error,EventType,AppearEvent,Event,UnityEventType
 = _G,pairs,table,type,print,GUI,CopyTable,os,ConstValue,Screen,getfenv,error,EventType,AppearEvent,Event,UnityEventType
local CsCurrentEventEqualsType,require,tostring,PanelOperateType = 
CsCurrentEventEqualsType,require,tostring,PanelOperateType

local mAlert = require "LuaScript.View.Alert.Alert"
module("LuaScript.Control.PanelManager")
mPanelList = {{},{},{},{},{}}
mOperatePanelList = nil

mInitFuncList = nil

mInitFontSize = false

_G.GUITime = 0
_G.GUISecondTime = {}

_G.OnGUI = function()
	local now = 0
	if _G.IsDebug then
		now = os._clock()
	end
	
	GUI.EventRepaint = CsCurrentEventEqualsType(UnityEventType.Repaint)
	
	Init()
	
	if not mInitFontSize then
		mInitFontSize = true
		GUI.HideScrollbar()
	end
	
	if mOperatePanelList and GUI.EventRepaint then
		local list = mOperatePanelList
		local appearEvent = false
		mOperatePanelList = nil

		for k,v in pairs(list) do
			if v.Operate == PanelOperateType.Remove then
				for k,panel in pairs(mPanelList[v.panelType]) do
					if v.panel == panel then
						if panel.Hide then
							panel.Hide()
							GUI.CSRemovePanel(panel._NAME)
						end
						table.remove(mPanelList[v.panelType], k)
						-- print("remove",panel)
						if not v.panel.notShowGuide then
							appearEvent = true
							-- print(v.panel)
						end
						break
					end	
				end
			else
				if v.panel.Display then
					v.panel.Display()
					GUI.CSAddPanel(v.panel._NAME)
				end
				table.insert(mPanelList[v.panelType], v.panel)
				if not v.panel.notShowGuide then
					appearEvent = true
					-- print(v.panel)
				end
				-- print("insert",v.panel)
			end
		end
		if appearEvent then
			AppearEvent(nil,EventType.OnRefreshGuide)
			AppearEvent(nil,EventType.CheckAllTask)
			-- AppearEvent(nil,EventType.OnRefreshRedPoint) --监听事件
		end
	end
	
	
	for _,panel in pairs(mPanelList[ConstValue.LoadPanel]) do
		panel.PerGUI()
	end
	
	for _,panel in pairs(mPanelList[ConstValue.GuidePanel]) do
		if panel.PerGUI then
			panel.PerGUI()
		end
	end
	
	if mPanelList[ConstValue.AlertPanel][1] then
		GUI.SetEnabled(false)
	end
	
	for _,panel in pairs(mPanelList[ConstValue.CommonPanel]) do
		panel.OnGUI()
	end
	
	local count = #mPanelList[ConstValue.AlertPanel]
	for k,panel in pairs(mPanelList[ConstValue.AlertPanel]) do
		if count == k then
			GUI.SetEnabled(true)
		end
		panel.OnGUI()
	end
	
	for _,panel in pairs(mPanelList[ConstValue.GuidePanel]) do
		panel.OnGUI()
	end
	
	for _,panel in pairs(mPanelList[ConstValue.LoadPanel]) do
		panel.OnGUI()
	end

	for _,panel in pairs(mPanelList[ConstValue.TipPanel]) do
		panel.OnGUI()
	end
	
	if _G.IsDebug then
		local t = os.time()
		_G.GUISecondTime[t] = _G.GUISecondTime[t] or 0
		_G.GUISecondTime[t] = _G.GUISecondTime[t] + os._clock() - now
		if GUI.EventRepaint then
			_G.GUISecondTime[-t] = _G.GUISecondTime[-t] or 0
			_G.GUISecondTime[-t] = _G.GUISecondTime[-t] + 1
		end
		_G.GUITime = _G.GUITime + os.clock() - now
	end
end

function Reset()
	mPanelList = {{},{},{},{},{}}
end

function HaveGuidePanel()
	return mPanelList[ConstValue.GuidePanel][1]
end

function Init()
	if not mInitFuncList then
		return
	end
	-- print("mInitFuncList", mInitFuncList)
	-- print("init")
	for InitFunc,_ in pairs(mInitFuncList) do
		-- print(InitFunc)
		InitFunc()
	end
	mInitFuncList = nil
end

function Show(arg)
	local panel = nil
	if type(arg) == "table" then
		panel = arg
	elseif type(arg) == "function" then
		panel = getfenv(arg)
	else
		error("not panel")
	end
	if not panel.OnGUI then
		error("not panel")
	end
	
	-- guiFunc = panel.OnGUI
	if not panel.IsInit and panel.Init then
		InitPanel(panel)
		panel.IsInit = true
	end
	
	panel.enable = true
	panel.visible = true
	local panelType = panel.panelType or ConstValue.CommonPanel
	-- print(panelType)
	if panelType == ConstValue.AlertPanel then
		for _,panel in pairs(mPanelList[ConstValue.CommonPanel]) do
			-- print(false)
			panel.enable = false
		end
		
		for _,panel in pairs(mPanelList[ConstValue.AlertPanel]) do
			panel.enable = false
		end
		
		if mOperatePanelList then
			for _,operate in  pairs(mOperatePanelList) do
				-- print(operate)
				if operate.panelType == ConstValue.CommonPanel or operate.panelType == ConstValue.AlertPanel then
					operate.panel.enable = false
				end
			end
		end
	elseif panelType == ConstValue.CommonPanel and mPanelList[ConstValue.AlertPanel][1] then
		panel.enable = false
	else
		panel.enable = true
	end
	
	mOperatePanelList = mOperatePanelList or {}
	table.insert(mOperatePanelList ,{panelType=panelType, panel=panel, Operate=PanelOperateType.Remove})
	table.insert(mOperatePanelList ,{panelType=panelType, panel=panel, Operate=PanelOperateType.Insert})
	
	
	-- if panel.childrens then
		-- for k,children in pairs(panel.childrens) do
			-- Show(children)
		-- end
	-- end
	-- print(mOperatePanelList[#mOperatePanelList].panel)
end

function Hide(arg)
	-- print(111111)
	local panel = nil
	if type(arg) == "table" then
		panel = arg
	else
		panel = getfenv(arg)
	end
	-- print("Hide",panel._NAME)
	local panelType = panel.panelType or ConstValue.CommonPanel
	local alertList = mPanelList[ConstValue.AlertPanel]
	if panel.enable and panelType == ConstValue.AlertPanel and not alertList[2] then
		for _,panel in pairs(mPanelList[ConstValue.CommonPanel]) do
			if panel.visible then
				panel.enable = true
			end
			-- print(true)
		end
	elseif panel.enable and panelType == ConstValue.AlertPanel then
		alertList[#alertList-1].enable = true
	end
	
	
	panel.visible = false
	panel.enable = false
	
	mOperatePanelList = mOperatePanelList or {}
	table.insert(mOperatePanelList, {panelType=panelType, panel=panel, Operate=PanelOperateType.Remove})
	
	
	
	
	-- if panel.childrens then
		-- for k,children in pairs(panel.childrens) do
			-- Hide(children)
		-- end
	-- end
end

function AutoClose()
	if mOperatePanelList then
		local removeList = {}
		for k=#mOperatePanelList,1,-1 do
			local v = mOperatePanelList[k]
			if v and v.Operate == PanelOperateType.Insert and not v.panel.notAutoClose then
				v.panel.visible = false
				v.panel.enable = false
				table.insert(removeList, k)
			end
		end
		
		for k,v in pairs(removeList) do
			table.remove(mOperatePanelList, v)
		end
	end
	
	
	for _,panel in pairs(mPanelList[ConstValue.CommonPanel]) do
		if not panel.notAutoClose then
			Hide(panel)
		end
	end
	
	for k,panel in pairs(mPanelList[ConstValue.AlertPanel]) do
		if not panel.notAutoClose then
			Hide(panel)
		end
	end
	
	for _,panel in pairs(mPanelList[ConstValue.TipPanel]) do
		if not panel.notAutoClose then
			Hide(panel)
		end
	end
	
	for _,panel in pairs(mPanelList[ConstValue.GuidePanel]) do
		if not panel.notAutoClose then
			Hide(panel)
		end
	end
	
	mAlert.mMouseEventState = true
end

function Reset()
	for k,list in pairs(mPanelList) do
		for k,panel in pairs(list) do
			panel.visible = false
			panel.enable = false
		end
	end
	mPanelList = {{},{},{},{},{}}
	mOperatePanelList = nil
end

function InitPanel(arg)
	local initFunc = arg.Init
	-- initFunc = arg.Init

	if not mInitFuncList then
		mInitFuncList = {}
	end
	mInitFuncList[initFunc] = true
end