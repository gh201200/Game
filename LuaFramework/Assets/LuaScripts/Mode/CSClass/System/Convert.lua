Convert = {}
Convert.ToSingle = function(value)
	return RunStaticFunc("System.Convert","ToSingle", value)
end

Convert.ToInt32 = function(value)
	return RunStaticFunc("System.Convert","ToInt32", value)
end