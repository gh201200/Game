local GameInfo = class("Common.GameInfo")

function GameInfo:ctor(callback)
	self.canvas = GameObject.Find("Canvas")
	if not self.canvas then
		AssetLoader.Instance:LoadAsync("prefabs/Canvas.prefab", AssetType.Prefab, function(obj)
			self.canvas = GameObject.Instantiate(obj)
			self.canvas.name = "Canvas"
			callback.Start()
		end,
		function(p)
			print("canvas load: " .. p * 100 .. "%")
		end)
	end
end

return GameInfo
