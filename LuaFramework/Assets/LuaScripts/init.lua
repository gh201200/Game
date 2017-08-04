luanet.load_assembly("Assembly-CSharp")
luanet.load_assembly("UnityEngine")
luanet.load_assembly("System")

import("BulletList")
import("SeagullList")
import("HpBar")
import("UILabel")
import("Animator")
-- print(HpBar)
CsPrint = print
-- import("BulletList")
-- import("BulletList")
-- import("BulletList")

-- print(Rect)
-- CsPrint(_G.loader.path)

-- CsPrint(import("Color"))

function CsFindType(name)
	-- CsPrint("CsFindType".. name)
	import(name)
	
	-- _G.CCLASS = _G.CCLASS or {}
	-- if not _G.CCLASS[name] then
		-- local tagert = _G
		-- local arr = SplitString(name, ".")
		-- for i=1,#arr do
			-- print(#arr)
			-- print(arr[1])
			
			-- tagert = tagert[arr[i]]
			-- print(tagert)
			-- if tagert == nil then
				-- return
			-- end
		-- end
		-- _G.CCLASS[name] = tagert
	-- end
	
	-- print(UnityEngine.Color)
	-- print(_G[name])
	-- print(_G.)
	-- return _G.CCLASS[name]
end
local _GetComponent = GetComponent
function GetComponent(...)
	-- print(1111)
	return _GetComponent(...)
end

-- print(CsFindType("UnityEngine.Color"))
-- print(1111, os.clock())
require "LuaScript.CFG"
require "LuaScript.Common.string"
require "LuaScript.Common.common"
require "LuaScript.Common.table"
-- print(BaseVersion)
-- print(UnityEngine.Color.New())
Timer = require "LuaScript.Common.Timer"
RunLuaScript("require 'LuaScript.start'")