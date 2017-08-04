Dns = {}
local csDns = CsFindType("System.Net.Dns")
Dns.GetIp = function()
	local hostName = csDns.GetHostName()
	local ip = tostring(csDns.GetHostEntry(hostName).AddressList[0])
	return ip
end