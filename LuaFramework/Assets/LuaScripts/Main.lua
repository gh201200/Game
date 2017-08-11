import "UnityEngine"

require "common.common"

local mt = {
	name = "god",
	age = 25,
	__call = function(args)
		print(dumpTab(args))
	end,
}

local t = Class(Application)



print(t)