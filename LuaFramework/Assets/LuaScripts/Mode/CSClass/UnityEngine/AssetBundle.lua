
AssetBundle = {}

AssetBundle.CreateFromFile = function(path)
	local cs_ByteArray = File.ReadAllBytes(path)
	return RunStaticFunc("UnityEngine.AssetBundle", "CreateFromMemory", cs_ByteArray)
end