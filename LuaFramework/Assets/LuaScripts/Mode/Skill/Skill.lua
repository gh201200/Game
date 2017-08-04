local require = require

module("LuaScript.Mode.Skill.Skill")

local skillList = {}
skillList[1] = (require "LuaScript.Mode.Skill.Skill1").start
skillList[2] = (require "LuaScript.Mode.Skill.Skill2").start
skillList[3] = (require "LuaScript.Mode.Skill.Skill3").start
skillList[4] = (require "LuaScript.Mode.Skill.Skill4").start
skillList[5] = (require "LuaScript.Mode.Skill.Skill5").start
skillList[6] = (require "LuaScript.Mode.Skill.Skill6").start
skillList[7] = (require "LuaScript.Mode.Skill.Skill7").start
skillList[8] = (require "LuaScript.Mode.Skill.Skill8").start
skillList[9] = (require "LuaScript.Mode.Skill.Skill9").start
skillList[10] = (require "LuaScript.Mode.Skill.Skill10").start
skillList[11] = (require "LuaScript.Mode.Skill.Skill11").start
skillList[12] = (require "LuaScript.Mode.Skill.Skill12").start
skillList[13] = (require "LuaScript.Mode.Skill.Skill13").start
skillList[14] = (require "LuaScript.Mode.Skill.Skill14").start
skillList[15] = (require "LuaScript.Mode.Skill.Skill15").start
-- skillList[16] = (require "LuaScript.Mode.Skill.Skill1").start


--获取对应的技能控制脚本
function GetSkill(id)
	return skillList[id]
end