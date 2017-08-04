
Socket = {}
Socket._socketList = {}

Socket.Init = function()
	local cs_Socket = HHSocket.New()
	table.insert(Socket._socketList, cs_Socket)
	return cs_Socket
end

Socket.Destroy = function(cs_Socket)
	cs_Socket:Close()
	
	for k,v in pairs(Socket._socketList) do
		if v == cs_Socket then
			table.remove(Socket._socketList, k)
			break
		end
	end
end

Socket.Update = function()
	for _,cs_socket in pairs(Socket._socketList) do
		CsSocketUpdate(cs_socket)
	end
end
