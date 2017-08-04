local Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,GUIStyleLabel,tostring,type,UnityEventType,Event,os = 
Input,GUI,File,require,print,math,Screen,Color,pairs,Camera,Language,GUIStyleLabel,tostring,type,UnityEventType,Event,os
local CFG_harborProperty,CFG_ship,CFG_Equip,CFG_EquipUp,ConstValue,CFG_sailorSlot,SceneType,CFG_map,CharacterType,string = 
CFG_harborProperty,CFG_ship,CFG_Equip,CFG_EquipUp,ConstValue,CFG_sailorSlot,SceneType,CFG_map,CharacterType,string
local _print,CFG_shipEquip,ActivityType,CFG_UniqueSailor,CFG_harbor,CFG_shipEquipGrade,ReplaceString = 
_print,CFG_shipEquip,ActivityType,CFG_UniqueSailor,CFG_harbor,CFG_shipEquipGrade,ReplaceString
local CFG_magic,CFG_title,CFG_starGrade,CFG_star,CFG_starSkillProperty,CFG_starSkill,luanet = 
CFG_magic,CFG_title,CFG_starGrade,CFG_star,CFG_starSkillProperty,CFG_starSkill,luanet
local CFG_randomTask,CFG_task,platform,LjPlatformType = CFG_randomTask,CFG_task,platform,LjPlatformType
local mHeroManager = nil
local mCharManager = nil
local mSetManager = nil
local mRelationManager = nil
local mActivityManager = nil
local mSDK = nil
local mPanelManager = nil
local mMainPanel = nil
module("LuaScript.Mode.Object.CommonlyFunc")

function Init()
	mCharManager = require "LuaScript.Control.Scene.CharManager" 
	mHeroManager = require "LuaScript.Control.Scene.HeroManager" 
	mSetManager = require "LuaScript.Control.System.SetManager"
	mRelationManager = require "LuaScript.Control.Data.RelationManager"
	mActivityManager = require "LuaScript.Control.Data.ActivityManager"
	mSDK = require "LuaScript.Mode.Object.SDK"
	mPanelManager = require "LuaScript.Control.PanelManager"
	mMainPanel = require "LuaScript.View.Panel.Main.Main"
end

function GetNumberToChn(value)--获取数字对应的中文
	return Language[177+value]
end

function InBattle() -- 进入战场
	local hero = mHeroManager.GetHero()
	if hero then
		return hero.SceneType == SceneType.Battle
	end
	return false
end


function AutoOpenlPanel(panel)
	mPanelManager.AutoClose()
	mPanelManager.Show(panel)
	if panel.FullWindowPanel then
		mPanelManager.Hide(mMainPanel)
	end
end

local mSailorStarInfoList = {} -- 船员技能星星列表
function GetSailorStarInfo(star)
	if not mSailorStarInfoList[star] then
		local quality = ConstValue.StarQuality[star]
		local color = ConstValue.QualityColorStr[quality]
		local info = BeginColor(color)
		info = info .. GetNumberToChn(star) .. "阶"
		info = info .. EndColor()
		mSailorStarInfoList[star] = info
	end
	return mSailorStarInfoList[star]
end

function GetShortNumber(value) -- 获取指定数值，按格式转化到万或亿
	if value >= 1000000000 then
		return math.floor(value/100000000) .. Language[52]
	elseif value >= 100000 then
		return math.floor(value/10000) .. Language[51]
	else
		return value
	end
end

function GetChnTime(value)
	if value < 0 then
		value = 0
	end
	local day = math.floor(value/(60*60*24))
	local hour = math.floor(value%(60*60*24)/(60*60))
	local minute = math.floor(value%(60*60)/60)
	local second = math.floor(value%60)
	local timeStr = nil
	if day > 0 then
		timeStr = day .. Language[69]
		if hour > 0 then
			timeStr = timeStr .. hour .. Language[70]
		end
	elseif hour > 0 then
		timeStr = hour .. Language[70]
		if minute > 0 then
			timeStr = timeStr .. minute .. Language[71]
		end
	elseif minute > 0 then
		timeStr = minute .. Language[71]
		if second > 0 then
			timeStr = timeStr .. second .. Language[72]
		end
	elseif second > 0 then
		timeStr = second .. Language[72]
	end
	return timeStr
end

function GetFormatTime(value)
	if value < 0 then
		value = 0
	else
		value = math.floor(value)
	end
	local hour = math.floor(value/(60*60))
	local minute = math.floor(value%(60*60)/60)
	local Second = math.floor(value%60)
	local timeStr = string.format("%02d:%02d:%02d",hour,minute,Second)
	return timeStr
end

function GetShortFormatTime(value)
	if value < 0 then
		value = 0
	else
		value = math.floor(value)
	end
	local minute = math.floor(value%(60*60)/60)
	local Second = math.floor(value%60)
	local timeStr = string.format("%02d:%02d",minute,Second)
	return timeStr
end

function GetApplyTime(value)
	return os.date("%Y/%m/%d", value)
end

function GetOnlineTime(value)
	if value <= 0 then
		return Language[144]
	else
		local serverTime = mActivityManager.GetServerTime()
		if not serverTime then
			return
		end
		local pastTime = serverTime - value
		if pastTime < 60*60 then
			return Language[145]
		elseif pastTime < 24*60*60 then
			return string.format(Language[197], math.floor(pastTime/(60*60)))
		elseif pastTime < 24*60*60 * 7 then
			return string.format(Language[198], math.floor(pastTime/(24*60*60)))
		else
			return Language[146]
		end
	end
end

function GetGiftTime(value)
	if value ~= 0 then
		return os.date("\n有效期:%m月%d日", value)
	else
		return ""
	end
end

function GetRMBTime(value)
	return os.date("<color=#00ff00>截止:%m月%d日</color>\n", value)
end

local mVipStr = {}
function GetRMBVip(vip, nowVip)
	local key = vip * 100 + nowVip
	if mVipStr[key] then
		return mVipStr[key]
	end
	local str = nil
	if vip <= nowVip then
		str = string.format("<color=#00ff00>需求:VIP%d</color>\n", vip)
	else
		str = string.format("<color=#ff0000>需求:VIP%d</color>\n", vip)
	end
	mVipStr[key] = str
	return str
end

function BeginColor(color)
	return string.format("<color=#%s>",color)
end

function EndColor()
	return "</color>"
end

function NGUIBeginColor(color)
	return string.format("[%s]",color)
end

function NGUIEndColor()
	return "[-]"
end

function BeginSize(size)
	size = math.floor(size * GUI.modulus)
	return string.format("<size=%d>",size)
end

function EndSize()
	return "</size>"
end

function BeginBoldface()
	return "<b>"
end

function EndBoldface()
	return "</b>"
end

function BeginItalics()
	return "<i>"
end

function EndItalics()
	return "</i>"
end

function Linefeed()
	return "\n"
end

-- function LineHeight(height)
	-- height = math.floor(height / 1.155 * GUI.modulus)
	-- return string.format("<size=%d></size>", height)
-- end

function GetEquipPower(equip, star)
	if not star then
		star = equip.star or 0
	end
	local cfg_Equip = CFG_Equip[equip.id]
	local cfg_EquipUp = CFG_EquipUp[star]
	power = math.floor(cfg_Equip.power*(cfg_EquipUp.addPer+100)/100) + cfg_EquipUp.power
	
	if equip.magic and equip.magic ~= 0 then
		-- print(equip.magic)
		local cfg_magic = CFG_magic[equip.magic]
		power = power + cfg_magic.power
	end
	
	return power
end

function GetShipEquipPower(equip, star)
	if not star then
		star = equip.star or 0
	end
	
	local cfg_Equip = CFG_shipEquip[equip.id]
	local cfg_EquipUp = CFG_shipEquipGrade[cfg_Equip.quality.."_"..star]
	-- print(cfg_Equip.quality.."_"..star)
	return math.floor(cfg_Equip.power*(cfg_EquipUp.addPer+100)/100)
end

function GetShipPower(id, ship)
	if not ship or ship.duty == 0 then
		local cfg_Ship = CFG_ship[id]
		return cfg_Ship.power
	elseif ship.power then
		return ship.power
	else
		local mShipEquipManager = require "LuaScript.Control.Data.ShipEquipManager"
		local cfg_Ship = CFG_ship[id]
		local power = cfg_Ship.power + mShipEquipManager.GetpowerBySid(ship.index)
		-- ship.power = power
		return power
	end
end

function GetHarborPower(level)
	local cfg_property = CFG_harborProperty[level]
	return cfg_property.power
end

function GetSailorPower(sailor, level, exLevel)
	if not level then
		local hero = mHeroManager.GetHero()
		level = hero.level
	end
	if not exLevel then
		exLevel = sailor.exLevel
	end
	
	local cfg_sailor = CFG_UniqueSailor[sailor.index]
	return math.floor(cfg_sailor.power * ((level + exLevel) / 10 + 1))
end

function GetSailorRestPower(sailor)
	if sailor.duty ~= 0 then
		return 0
	end
	local power = sailor.restAttack + sailor.restDefense + sailor.restHp / 4
	return math.floor(power)
end


function GetSailorFightLevel(index)
	return CFG_sailorSlot[index].level
end

function GetSailorFightCount(level)
	levelSlot = levelSlot or  {}
	if not levelSlot[level] then
		local count = 0
		for k,sailorSlot in pairs(CFG_sailorSlot) do
			if level >= sailorSlot.level then
				count = sailorSlot.count
			end
		end
		levelSlot[level] = count
	end
	
	return levelSlot[level]
end

function GetUid(id, type, shipId)
	return id * 100 + type * 10 + shipId
end

function CdToMoney(cd)
	-- print(cd)
	return math.ceil(cd/300)
end

function UpdateTitle(char)
	-- print("UpdateTitle")
	local hero = mHeroManager.GetHero()
	char.titleName = ""
	-- if char.title and char.title ~= 0 then
		-- local cfg_title = CFG_title[char.title]
		-- local color = ConstValue.QualityColorStr[cfg_title.quality]
		-- char.titleName = char.titleName .. NGUIBeginColor(color) .. "『" .. cfg_title.name .. "』\n" .. NGUIEndColor()
	-- end
	
	if char.familyId then
		char.titleName = char.titleName .. string.format("[ffff99]【%s】%s[-]%s",
						char.familyName,
						ConstValue.PostName[char.post],
						Linefeed())
	end
	
	char.titleName = char.titleName .. char.name
	
	if hero.SceneType ~= SceneType.Battle and char.type == CharacterType.Player and char.level < 28 then
		char.titleName = string.format("%s%s(新手)%s",
							char.titleName,
							NGUIBeginColor(Color.LimeStr), 
							NGUIEndColor())
	elseif hero.SceneType ~= SceneType.Battle and char.type == CharacterType.Player then
		if char.mode == 2 then
			char.titleName = string.format("%s%s(和)%s",
								char.titleName,
								NGUIBeginColor(Color.LimeStr), 
								NGUIEndColor())
		elseif char.protectState then
			char.titleName = string.format("%s%s(保护)%s",
								char.titleName,
								NGUIBeginColor(Color.LimeStr), 
								NGUIEndColor())
		elseif char.mode == 1 then
			char.titleName = string.format("%s%s(战)%s",
								char.titleName,
								NGUIBeginColor(Color.RedStr), 
								NGUIEndColor())
		end
	end
	
	if hero.SceneType ~= SceneType.Battle then
		local mRelationManager = require "LuaScript.Control.Data.RelationManager"
		if mRelationManager.IsEnemy(char.id) then
			char.titleName = string.format("%s%s%s" ,NGUIBeginColor(Color.RedStr), char.titleName, NGUIEndColor())
		end
	end
	
	if hero.SceneType == SceneType.Battle then
		if hero.team ~= char.team then
			char.titleName = string.format("%s%s%s" ,NGUIBeginColor(Color.RedStr), char.titleName, NGUIEndColor())
		end
	elseif char.type == CharacterType.Enemy or char.type == CharacterType.NpcShipTeam then
		local qualityColor = ConstValue.QualityColorStr[char.quality]
		local infostr = string.format("%s%s%s" ,NGUIBeginColor(qualityColor), char.name, NGUIEndColor())
		char.titleName = infostr
	end
	
	if char.csTitle then
		local m3DTextManager = require "LuaScript.Control.Scene.3DTextManager"
		if hero == char then
			m3DTextManager.SetHeroTitle(char.titleName, char.level)
		else
			m3DTextManager.SetText(char.csTitle, char.titleName)
		end
	end
	-- print("UpdateTitle", char.titleName, char.familyId)
end

function GetEquipProperty(equip, star)
	if not star then
		star = equip.star or 0
	end
	local cfg_Equip = CFG_Equip[equip.id]
	local cfg_EquipUp = CFG_EquipUp[star]
	local propertyValue = math.floor(cfg_Equip.propertyValue + cfg_Equip.propertyValue*cfg_EquipUp.addPer/100)
	propertyValue = propertyValue + cfg_EquipUp.addPoint
	return propertyValue, cfg_Equip.propertyId
end

function GetStarProperty(star, level)
	if not level then
		level = star.level or 0
	end
	local cfg_star = CFG_star[star.bid]
	local cfg_starGrade = CFG_starGrade[cfg_star.quality.."_"..level]
	local propertyValue = math.floor(cfg_star.propertyValue + cfg_star.propertyValue*cfg_starGrade.addPer/100)
	-- propertyValue = propertyValue + cfg_starGrade.addPoint
	return propertyValue
end

function GetStarPower(star, level)
	if not level then
		level = star.level or 0
	end
	local cfg_star = CFG_star[star.bid]
	local cfg_starGrade = CFG_starGrade[cfg_star.quality.."_"..level]
	-- local cfg_starGrade = CFG_starGrade[cfg_star.quality.."_"..level]
	-- local propertyValue = math.floor(cfg_star.propertyValue + cfg_star.propertyValue*cfg_starGrade.addPer/100)
	-- propertyValue = propertyValue + cfg_starGrade.addPoint
	return math.floor(cfg_star.power*(cfg_starGrade.addPer/100 + 1))
end

-- local mShipEquipProperty = {}
function GetShipEquipProperty(equip, star)
	if not star then
		star = equip.star or 0
	end
	local cfg_Equip = CFG_shipEquip[equip.id]
	local cfg_EquipUp = CFG_shipEquipGrade[cfg_Equip.quality.."_"..star]
	local propertyValue = math.floor(cfg_Equip.propertyValue1 + cfg_Equip.propertyValue1*cfg_EquipUp.addPer/100)
	-- propertyValue = propertyValue + cfg_EquipUp.addPoint
	return propertyValue, cfg_Equip.propertyId1
end

function HaveMoney(value, setCostTip, mCostTip)
	local hero = mHeroManager.GetHero()
	if hero.money < value then
		-- mSystemTip = mSystemTip or require "LuaScript.View.Tip.SystemTip"
		-- mSystemTip.ShowTip("银两不足,还缺"..(value-hero.money).."银两")
		local exMoney = value-hero.money
		local needGold = math.ceil(exMoney/(math.max(hero.level,30)^2.3))
		
		function okFunc(showTip)
			if setCostTip then
				setCostTip(showTip)
			end
			
			if not HaveGold(needGold) then
				return
			else
				mHeroManager.requestBuyMoney(exMoney)
			end
		end
		
		if mCostTip ~= false then
			local mAlert = require "LuaScript.View.Alert.Alert"
			if setCostTip then
				mAlert = require "LuaScript.View.Alert.SelectAlert"
			end
			mAlert.Show("银两不足,还缺"..exMoney.."银两,是否花费"..needGold.."元宝购买？", okFunc)
		else
			okFunc(not mCostTip)
			return true
		end
		return false
	end
	return true
end

function HaveFamilyMoney(value)
	local mFamilyManager = require "LuaScript.Control.Data.FamilyManager" 
	local family = mFamilyManager.GetFamilyInfo()
	if family.money < value then
		mSystemTip = mSystemTip or require "LuaScript.View.Tip.SystemTip"
		mSystemTip.ShowTip("银两不足,还缺"..(value-family.money).."万家族资金")
		return false
	end
	return true
end

function HaveContribute(value)
	local hero = mHeroManager.GetHero()
	if hero.contribute < value then
		mSystemTip = mSystemTip or require "LuaScript.View.Tip.SystemTip"
		mSystemTip.ShowTip("联盟贡献值不足,还缺"..(value-hero.contribute).."献值,可通过联盟捐献获取献值")
		return false
	end
	return true
end

function HaveGold(value)
	local hero = mHeroManager.GetHero()
	if hero.gold < value then
		mAlert = mAlert or require "LuaScript.View.Alert.Alert"
		mAlert.Show("余额不足,需要"..value.."元宝,还缺"..(value-hero.gold).."元宝，是否立即充值？",Recharge,nil,"充值")
		-- mSystemTip = mSystemTip or require "LuaScript.View.Tip.SystemTip"
		-- mSystemTip.ShowTip("余额不足,需要"..value.."元宝,还需"..(value-hero.gold))
		return false
	end
	return true
end

function Recharge(showPanel)
	local mRechargePanel = require "LuaScript.View.Panel.Recharge.RechargePanel"
	local mSceneManager = require "LuaScript.Control.Scene.SceneManager"
	local mPanelManager = require "LuaScript.Control.PanelManager" 
	local mFirstRechange = require "LuaScript.View.Panel.FirstRechange.FirstRechange"
	local mMainPanel = require "LuaScript.View.Panel.Main.Main"
	local mPassPanel = require "LuaScript.View.Panel.Pass.PassPanel"
	local hero = mHeroManager.GetHero()
	-- if hero.firstRecharge > 0 then
		-- if showPanel then
			mPanelManager.Show(mRechargePanel)
			-- mSceneManager.SetMouseEvent(false)
		-- else
			-- mAlert = require "LuaScript.View.Alert.Alert"
			-- mAlert.Show("元宝充值比例为1:10,即充值1元人民币可获得10元宝", mRechargePanel.Pay)
			-- mRechargePanel.Pay()
		-- end
	-- else
		-- mSystemTip = mSystemTip or require "LuaScript.View.Tip.SystemTip"
		-- mSystemTip.ShowTip("首冲可获得3倍奖励,请选择充值金额", Color.LimeStr)
		
		-- mActivityPanel.SetData(ActivityType.FirstRechange)
		
		-- mPanelManager.AutoClose()
		-- mPanelManager.Hide(mMainPanel)
		-- mPanelManager.Hide(mPassPanel)
		-- mPanelManager.Show(mFirstRechange)
		
		-- mSceneManager.SetMouseEvent(false)
	-- end
end

function GetRandomTaskAward(quality)
	local hero = mHeroManager.GetHero()
	local rate = ConstValue.RandomTaskAwardRate[quality]
	local exp = (5000+100*hero.level)*rate
	local money = math.floor((660+5*hero.level*hero.level)*rate)
	return exp,money
end

function GetQualityStr(quality)
	qualityStrList = qualityStrList or  {}
	if not qualityStrList[quality] then
		local color = ConstValue.QualityColorStr[quality]
		local str = string.format("%s%s%s", BeginColor(color), ConstValue.Quality[quality], EndColor())
		-- str = str .. ConstValue.Quality[quality]
		-- str = str .. EndColor()
		qualityStrList[quality] = str
	end
	return qualityStrList[quality]
end

function LoopDis(a,b,length)
	if a > b then
		return math.min(math.abs(a-b),math.abs(a-b-length))
	else
		return math.min(math.abs(a-b),math.abs(a-b+length))
	end
end

function LoopVector(a,b,length)
	if a > b then
		if math.abs(a-b) > math.abs(a-b-length) then
			return a-b-length,a-length
		else
			return a-b,a
		end
	else
		if math.abs(a-b) > math.abs(a-b+length) then
			return a-b+length,a+length
		else
			return a-b,a
		end
	end
end

function ReviseCharPosition(char)
	-- print(char.ships[2])
	local hero = mHeroManager.GetHero()
	local mapWidth = CFG_map[hero.map].width

	for _,ship in pairs(char.ships) do
		local dis = ship.x - hero.x
		if dis > 3000 then
			ship.x = ship.x-mapWidth
		elseif dis < -3000 then
			ship.x = ship.x+mapWidth
		end
		
		if ship.move then
			ship.move.path[1] = RevisePathX(ship.x, ship.move.path[1])
		end
	end
	
	char.x = char.ships[1].x
end


function RevisePathX(cur_X, path_X)
	-- print(char.ships[2])
	
	local hero = mHeroManager.GetHero()
	local cfg_map = CFG_map[hero.map]
	if cfg_map.loop ~= 1 then
		return path_X
	end
	local mapWidth = cfg_map.width
	
	local path_x1 = path_X - mapWidth
	local path_x2 = path_X
	local path_x3 = path_X + mapWidth
	-- print(path_x1, path_x2, path_x3)
	local dis1 = math.abs(path_x1 - cur_X)
	local dis2 = math.abs(path_x2 - cur_X)
	local dis3 = math.abs(path_x3 - cur_X)

	if dis1 < dis2 and dis1 < dis3 then
		return path_x1
	elseif dis2 < dis1 and dis2 < dis3 then
		-- _print(cur_X, path_X, dis2, path_x2)
		return path_x2
	else
		return path_x3
	end
end

function QuitGame()
	mPanelManager = require "LuaScript.Control.PanelManager"
	mClosePanel = require "LuaScript.View.Panel.ClosePanel"
	mSDK = require "LuaScript.Mode.Object.SDK"
	mPanelManager.Reset()
	mPanelManager.Show(mClosePanel)
	mSDK.ShowFloatButton(0,0,false)
end

function GetLabCd(cd)
	local mLabManager = require "LuaScript.Control.Data.LabManager"
	local mVipManager = require "LuaScript.Control.Data.VipManager"
	local speed = mLabManager.LabUpSpeed() + mVipManager.LabUpSpeed()
	return math.floor(cd*(100-speed)/100)
end

function GetShipBuildCd(cd)
	local mLabManager = require "LuaScript.Control.Data.LabManager"
	local mVipManager = require "LuaScript.Control.Data.VipManager"
	local speed = mLabManager.ShipBuildSpeed() + mVipManager.ShipBuildSpeed()
	return math.floor(cd*(100-speed)/100)
end

function HideChar(char, shipCount)
	if char.type ~= CharacterType.Player then
		return false
	end
	
	local hero = mHeroManager.GetHero()
	if char.id == hero.id then
		return
	end
	if hero.SceneType == SceneType.Battle then
		return false
	end
	
	if mSetManager.GetHideChar() then
		return true
	end
	
	local relation = mRelationManager.GetRelation(char)
	if mSetManager.GetHideChar1() and relation == 1 then
		return true
	end

	if mSetManager.GetHideChar2() and (relation == 2 or relation == 3) then
		return true
	end
	
	if shipCount < ConstValue.MaxShipCount then
		return false
	end
	
	return true
end

function GetBattleShortInfo(battleField)
	if battleField.shortInfo then
		return battleField.shortInfo
	end
	local saveInfo = true
	
	local str = ""
	if battleField.team[0][1] then
		local char = mCharManager.GetChar(battleField.team[0][1].id)
		if char then
			local relation = mRelationManager.GetRelation(char)
			local color = ConstValue.RelationColorStr[relation]
			local info = BeginColor(color)
			info = info .. char.name
			info = info .. EndColor()
			
			str = str .. info
		else
			str = str .. "????"
			saveInfo = false
		end
	else
		str = str .. "????"
		saveInfo = false
	end
	
	str = str .. " <color=#ff0000>VS</color> "
	if battleField.team[1][1] then
		local member = battleField.team[1][1]
		if member.type == CharacterType.Harbor then
			local cfg_harbor = CFG_harbor[member.id]
			str = str .. cfg_harbor.name
		else
			local char = mCharManager.GetChar(member.id)
			if char then
				local relation = mRelationManager.GetRelation(char)
				local color = ConstValue.RelationColorStr[relation]
				local info = BeginColor(color)
				info = info .. char.name
				info = info .. EndColor()
				
				str = str .. info
			else
				str = str .. "????"
				saveInfo = false
			end
		end
	else
		str = str .. "????"
		saveInfo = false
	end
	
	if saveInfo then
		battleField.shortInfo = str
	end
	return str
end

function GetBattleTeamInfo(battleField)
	if battleField.teamInfo1 then
		return battleField.teamInfo1,battleField.teamInfo2
	end
	-- print(222)
	local saveInfo = true
	
	local teamStr1 = ""
	for k,member in pairs(battleField.team[0]) do
		local char = mCharManager.GetChar(member.id)
		if char then
			local relation = mRelationManager.GetRelation(char)
			local color = ConstValue.RelationColorStr[relation]
			info = BeginColor(color)
			info = info .. char.name
			info = info .. EndColor()
			info = info .. Linefeed()
			
			teamStr1 = teamStr1 .. info
		else
			teamStr1 = teamStr1 .. "????"
			teamStr1 = teamStr1 .. Linefeed()
			saveInfo = false
		end
	end
	
	local teamStr2 = ""
	for k,member in pairs(battleField.team[1]) do
		if member.type == CharacterType.Harbor then
			local cfg_harbor = CFG_harbor[member.id]
			teamStr2 = teamStr2 .. cfg_harbor.name
			teamStr2 = teamStr2 .. Linefeed()
		else
			local char = mCharManager.GetChar(member.id)
			if char then
				local relation = mRelationManager.GetRelation(char)
				local color = ConstValue.RelationColorStr[relation]
				teamStr2 = teamStr2 .. BeginColor(color)
				teamStr2 = teamStr2 .. char.name
				teamStr2 = teamStr2 .. EndColor()
				teamStr2 = teamStr2 .. Linefeed()
			else
				teamStr2 = teamStr2 .. "????"
				teamStr2 = teamStr2 .. Linefeed()
				saveInfo = false
			end
		end
	end
	
	if saveInfo then
		battleField.teamInfo1 = teamStr1
		battleField.teamInfo2 = teamStr2
	end
	return teamStr1,teamStr2
end


function CheckWord(str)
	str = ReplaceString(str, "钓鱼岛","***")
	str = ReplaceString(str, "尖阁列岛","****")
	str = ReplaceString(str, "『","*")
	str = ReplaceString(str, "』","*")
	str = ReplaceString(str, "<","*")
	str = ReplaceString(str, ">","*")
	str = ReplaceString(str, ">","*")
	return str
end

local mRageStrList = {}
function GetRageStr(rage)
	if not mRageStrList[rage] then
		mRageStrList[rage] = string.format("%d/100", rage)
	end
	return mRageStrList[rage]
end

function GetStarByTAQ(type, quality)
	if not CFG_star2 then
		CFG_star2 = {}
		for k,v in pairs(CFG_star) do
			CFG_star2[v.type.."_"..v.quality] = v
		end
	end
	local key = type.."_"..quality
	return CFG_star2[key]
end


function GetTaskCFG(id)
	local cfg = nil
	if id > 10000 then
		cfg = CFG_randomTask[id]
	else
		cfg = CFG_task[id]
	end
	return cfg
end

function GetRMBList()
	if mRMBList then
		return mRMBList
	end
	-- if platform == "lj" then
		-- local channel = mSDK.GetChannel()
		-- if LjPlatformType[channel] and LjPlatformType[channel].AccountHead == "YDMM" then
			-- mRMBList = {6,30,68,128,198,300}
			-- return mRMBList
		-- end
	-- end
	
	mRMBList = {{1, 6}, {6, 5}, {30, 4}, {68, 3}, {168, 2}, {328, 2}, {648, 2}, {2298, 2}}
	return mRMBList
end

function GetGoldList()
	if mGoldList then
		return mGoldList
	end
	-- if platform == "lj" then
		-- local channel = mSDK.GetChannel()
		-- if LjPlatformType[channel] and LjPlatformType[channel].AccountHead == "YDMM" then
			-- mGoldList = {60,300,680,1280,1980,3000}
			-- return mGoldList
		-- end
	-- end
	
	mGoldList = {60,300,680,1980,3280,6480}
	return mGoldList
end

function GetGoldUnitList()
	if mGoldUnitList then
		return mGoldUnitList
	end
	-- if platform == "lj" then
		-- local channel = mSDK.GetChannel()
		-- if LjPlatformType[channel] and LjPlatformType[channel].AccountHead == "YDMM" then
			-- mGoldUnitList = {[6]=true,[30]=true,[68]=true,[128]=true,[198]=true,[300]=true}
			-- return mGoldUnitList
		-- end
	-- end
	
	mGoldUnitList = {[6]=true,[30]=true,[68]=true,[198]=true,[328]=true,[648]=true}
	return mGoldUnitList
end