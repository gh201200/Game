
FileInfo = {}
FileInfo.Init = function(path)
	local cs_Args = NewObjectArr(path)
	return cs_Base:InitClass("System.IO.FileInfo", cs_Args)
end

-- File
-- f.Directory.Exists;
-- f.Directory.Create()