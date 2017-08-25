local GameInfo = class("Common.GameInfo")

function GameInfo:ctor(callback)
	self.canvas = GameObject.Find("Canvas")
	if not self.canvas then
		AssetLoader.Instance:LoadAsync("prefabs/Canvas.prefab", AssetType.Prefab, function(obj)
			self.canvas = GameObject.Instantiate(obj)
			self.canvas.name = "Canvas"
			callback.Start()
		end, nil)
	end
end

return GameInfo
