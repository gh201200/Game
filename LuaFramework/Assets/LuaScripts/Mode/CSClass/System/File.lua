
File = {}

File.WriteAllBytes = function(path, bytes)
	if not File.Exists(path) then
		local cs_FileInfo = FileInfo.Init(path)
		local cs_Directory = cs_FileInfo.Directory
		cs_Directory:Create()
		-- cs_FileInfo
	end
	-- print(path, bytes, append)
	return RunStaticFunc("System.IO.File", "WriteAllBytes", path, bytes)
end

File.ReadAllBytes = function(path)
	return RunStaticFunc("System.IO.File", "ReadAllBytes", path)
end

File.Exists = function(path)
	return RunStaticFunc("System.IO.File", "Exists", path)
end

File.Create = function(path)
	return RunStaticFunc("System.IO.File", "Create", path)
end

File.Open = function(path, fileMode)
	return RunStaticFunc("System.IO.File", "Open", path, fileMode)
end

File.Delete = function(path)
	return RunStaticFunc("System.IO.File", "Delete", path)
end
