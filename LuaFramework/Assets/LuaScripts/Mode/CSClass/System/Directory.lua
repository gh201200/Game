
Directory = {}

Directory.Delete = function(path, recursive)
	if not Directory.Exists(path) then
		return
	end
	return RunStaticFunc("System.IO.Directory", "Delete", path, recursive)
end

Directory.CreateDirectory = function(path)
	return RunStaticFunc("System.IO.Directory", "CreateDirectory", path)
end

Directory.Exists = function(path)
	return RunStaticFunc("System.IO.Directory", "Exists", path)
end