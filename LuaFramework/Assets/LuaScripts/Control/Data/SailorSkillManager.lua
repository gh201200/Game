local _G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,CFG_item,require,table,PackatHead,Packat_Item,ByteArray = 
_G,pairs,io,xpcall,print,tostring,ConstValue,tonumber,CFG_item,require,table,PackatHead,Packat_Item,ByteArray
local CFG_itemSuit,math,EventType,CFG_skillRequire,CFG_UniqueSailor,CFG_skill,Color = 
CFG_itemSuit,math,EventType,CFG_skillRequire,CFG_UniqueSailor,CFG_skill,Color
local mNetManager = nil
local mSystemTip = nil
local mHeroTip = nil
local mSailorManager = require "LuaScript.Control.Data.SailorManager"
local mEquipManager = require "LuaScript.Control.Data.EquipManager"
local mCommonlyFunc = require "LuaScript.Mode.Object.CommonlyFunc"
local string = string
 
module("LuaScript.Control.Data.SailorSkillManager")--船员技能管理

function InitSailor(sailor)
	if not sailor.skills then
		sailor.skills = {}
		local cfg_sailor = CFG_UniqueSailor[sailor.index]
		if cfg_sailor.skillId1 ~= -1 then
			table.insert(sailor.skills, {id=cfg_sailor.skillId1})
		end
		if cfg_sailor.skillId2 ~= -1 then
			table.insert(sailor.skills, {id=cfg_sailor.skillId2})
		end
		if cfg_sailor.skillId3 ~= -1 then
			table.insert(sailor.skills, {id=cfg_sailor.skillId3})
		end
		if cfg_sailor.skillId4 ~= -1 then
			table.insert(sailor.skills, {id=cfg_sailor.skillId4})
		end
		if cfg_sailor.skillId5 ~= -1 then
			table.insert(sailor.skills, {id=cfg_sailor.skillId5})
		end
		if cfg_sailor.skillId6 ~= -1 then
			table.insert(sailor.skills, {id=cfg_sailor.skillId6})
		end
	end
	-- print(sailor.skills)
end

function InitSkillRequires(cfg_skill)
	if not cfg_skill.requires then
		cfg_skill.requires = {}
		for k,v in pairs(CFG_skillRequire) do
			if v.skillId == cfg_skill.id then
				table.insert(cfg_skill.requires, v)
			end
		end
	end
	-- return cfg_skill.requires
end

function RefreshSkill(sailor)
	InitSailor(sailor)
	
	for k,skill in pairs(sailor.skills) do
		CheckSkill(sailor, skill)
		sailor.skillPower = nil
	end
	
	table.sort(sailor.skills, SortFunc)
	
	InitSkillDesc(sailor)
end

function InitSkillDesc(sailor) -- 技能信息列表
	local skillDesc1 = ""
	local skillDesc2 = ""
	local skillFullDesc = ""
	for k,skill in pairs(sailor.skills) do
		local cfg_skill = CFG_skill[skill.id] --技能信息
		local desc = "◆" .. cfg_skill.name .. "\n" -- 最后不用这个拼接，直接用fulldesc完整名称
		local fullDesc = cfg_skill.skillDesc
		--根据ID获取
		if skill.active then -- 开启关闭时候的颜色
			desc = mCommonlyFunc.BeginColor(Color.BlackStr) .. desc .. mCommonlyFunc.EndColor()
			fullDesc = mCommonlyFunc.BeginColor(Color.BlackStr) .. fullDesc .. mCommonlyFunc.EndColor()
		else
			desc = mCommonlyFunc.BeginColor(Color.GrayStr) .. desc .. mCommonlyFunc.EndColor()
			fullDesc = mCommonlyFunc.BeginColor(Color.GrayStr) .. fullDesc .. mCommonlyFunc.EndColor()
		end
		--
		if k%2 == 0 then 
			skillDesc2 = skillDesc2 .. desc
		else
			skillDesc1 = skillDesc1 .. desc
		end
		skillFullDesc = skillFullDesc .. fullDesc -- 循环拼接
	end
	
	local cfg_sailor = CFG_UniqueSailor[sailor.index] -- 船员信息
	for k=1,10,1 do
		local skillId = cfg_sailor["starSkillId"..k]-- 技能，一到十，对应在CFG_skill中的ID查找
		if skillId == -1 then
			break
		end
		local cfg_skill = CFG_skill[skillId]
		-- local desc = "★" .. cfg_skill.name .. "\n"
		local fullDesc = cfg_skill.skillDesc
		fullDesc = string.format(fullDesc,k)
		if sailor.star >= k then
			-- desc = mCommonlyFunc.BeginColor(Color.BlackStr) .. desc .. mCommonlyFunc.EndColor()
			fullDesc = mCommonlyFunc.BeginColor(Color.BlackStr) .. fullDesc .. mCommonlyFunc.EndColor()
		else
			-- desc = mCommonlyFunc.BeginColor(Color.GrayStr) .. desc .. mCommonlyFunc.EndColor()
			fullDesc = mCommonlyFunc.BeginColor(Color.GrayStr) .. fullDesc .. mCommonlyFunc.EndColor()
		end
		-- if k%2 == 0 then
			-- skillDesc2 = skillDesc2 .. desc
		-- else
			-- skillDesc1 = skillDesc1 .. desc
		-- end
		skillFullDesc = skillFullDesc .. fullDesc
	end
	
	sailor.skillDesc1 = skillDesc1 --船员面板技能左竖列
	sailor.skillDesc2 = skillDesc2 --船员面板技能右竖列
	sailor.skillFullDesc = skillFullDesc -- 技能面板的所有内容
end


-- function InitStarSkillDesc(sailor)
	-- local skillDesc1 = ""
	-- local skillDesc2 = ""
	-- local skillFullDesc = ""
	-- local cfg_sailor = CFG_UniqueSailor[sailor.index]
	-- for k=1,10,1 do
		-- local skillId = cfg_sailor["starSkillId"..k]
		-- local cfg_skill = CFG_skill[skillId]
		-- local desc = "★" .. cfg_skill.name .. "\n"
		-- local fullDesc = cfg_skill.skillDesc
		
		-- if sailor.star >= k then
			-- desc = mCommonlyFunc.BeginColor(Color.BlackStr) .. desc .. mCommonlyFunc.EndColor()
			-- fullDesc = mCommonlyFunc.BeginColor(Color.BlackStr) .. fullDesc .. mCommonlyFunc.EndColor()
		-- else
			-- desc = mCommonlyFunc.BeginColor(Color.GrayStr) .. desc .. mCommonlyFunc.EndColor()
			-- fullDesc = mCommonlyFunc.BeginColor(Color.GrayStr) .. fullDesc .. mCommonlyFunc.EndColor()
		-- end
		-- if k%2 == 0 then
			-- skillDesc2 = skillDesc2 .. desc
		-- else
			-- skillDesc1 = skillDesc1 .. desc
		-- end
		-- skillFullDesc = skillFullDesc .. fullDesc
	-- end
	-- sailor.starSkillDesc1 = skillDesc1
	-- sailor.starSkillDesc2 = skillDesc2
	-- sailor.starSkillFullDesc = skillFullDesc
-- end



function SortFunc(a, b)
	if a.active and not b.active then
		return true
	elseif not a.active and b.active then
		return false
	end
	
	if a.id < b.id then
		return true
	end
	return false
end

function CheckSkill(sailor, skill)
	local cfg_skill = CFG_skill[skill.id]
	if sailor.duty == 0 then
		skill.active = cfg_skill.isPassive == 1
		return
	elseif cfg_skill.isPassive == 1 then
		skill.active = false
		return
	end
	
	InitSkillRequires(cfg_skill)
	
	local count = 0
	for k,mRequire in pairs(cfg_skill.requires) do
		if CheckRequire(sailor, mRequire) then
			count = count + 1
		end
	end
	
	skill.active = (count >= cfg_skill.requireCount)
end

function CheckRequire(sailor, mRequire)
	-- print(sailor.id, mRequire.requireId)
	if mRequire.requireType == 0 then
		return mEquipManager.SailorWearEquip(sailor.id, mRequire.requireId)
	elseif mRequire.requireType == 1 then
		return mSailorManager.SailorDuty(mRequire.requireId)
	end
end

function GetSkillProperty(sailor, property)
	RefreshSkill(sailor)
	for _,skill in pairs(sailor.skills) do
		if skill.active then
			local cfg_skill = CFG_skill[skill.id]
			if cfg_skill then
				property[cfg_skill.propertyId] = property[cfg_skill.propertyId] or 0
				property[cfg_skill.propertyId] = property[cfg_skill.propertyId] + cfg_skill.propertyValue
				
				-- print(sailor.id, cfg_skill.id, cfg_skill.propertyValue)
			end
		else
			break
		end
	end
	
	local cfg_sailor = CFG_UniqueSailor[sailor.index]
	for k=1,10,1 do
		local skillId = cfg_sailor["starSkillId"..k]
		local cfg_skill = CFG_skill[skillId]
		if sailor.star >= k then
			property[cfg_skill.propertyId] = property[cfg_skill.propertyId] or 0
			property[cfg_skill.propertyId] = property[cfg_skill.propertyId] + cfg_skill.propertyValue
		end
	end
	
	return property
end

function GetSkillPower(sailor)
	if sailor.skillPower then
		return sailor.skillPower
	end
	local power = 0
	for _,skill in pairs(sailor.skills) do
		if skill.active then
			power = power + CFG_skill[skill.id].power
		else
			break
		end
	end
	
	local cfg_sailor = CFG_UniqueSailor[sailor.index]
	for k=1,10,1 do
		if sailor.star >= k then
			local skillId = cfg_sailor["starSkillId"..k]
			local cfg_skill = CFG_skill[skillId]
			power = power + cfg_skill.power
		end
	end
	
	sailor.skillPower = power
	return sailor.skillPower
end