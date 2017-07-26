-- local s = Api.LoadImmediately("Config/ciku.txt", AssetType.TextAsset)
-- Api.CheckString(tostring(s), "([^，,、,\\n\\s]+)")

-- print(Api.FindOne("格雷"))

for w in string.gmatch("[hp:100,mp:200]", "[^\\[hp:'',mp:''\\]]+") do
	print(w)
end