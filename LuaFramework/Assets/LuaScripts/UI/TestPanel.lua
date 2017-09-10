local TestPanel = class("UI.TestPanel", UIBase)

local this = nil

function TestPanel:ctor(...)
	this = self
	this.UIScroller = this.go.transform:Find("View"):GetComponent(UIScroller)
	this.UIScroller.OnShowEvent = {"+=", function(index, go, info)
		go.transform:Find("Text"):GetComponent(UI.Text).text = info
	end}
	AssetLoader.Instance:LoadAsync("Prefabs/UI/Common/Item.prefab", AssetType.Prefab, function(obj)
		for i = 0, 200 do
			this.UIScroller:Add(obj, i)
		end
	end)
end

function TestPanel:OnOpen(...)
	
end

return TestPanel
