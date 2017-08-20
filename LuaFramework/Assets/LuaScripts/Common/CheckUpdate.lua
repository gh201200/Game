local CheckUpdate = class("Common.CheckUpdate")

function CheckUpdate:ctor()
	self.remoteUrl = "http://localhost/Version/"
end

return CheckUpdate:new()
